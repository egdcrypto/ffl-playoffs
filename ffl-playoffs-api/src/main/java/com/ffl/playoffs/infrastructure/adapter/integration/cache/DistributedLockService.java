package com.ffl.playoffs.infrastructure.adapter.integration.cache;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import java.time.Duration;
import java.util.UUID;
import java.util.concurrent.TimeUnit;
import java.util.function.Supplier;

/**
 * Distributed Lock Service for Cache Stampede Protection
 *
 * Prevents cache stampede by ensuring only one request fetches data
 * when cache expires, while other requests wait for the result.
 *
 * Uses Redis SETNX (SET if Not eXists) for distributed locking.
 *
 * Example scenario:
 * - 100 concurrent requests miss cache simultaneously
 * - First request acquires lock and calls API
 * - 99 other requests wait for lock to release
 * - First request caches data and releases lock
 * - All 100 requests use the cached result
 * - Only 1 API call made instead of 100
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class DistributedLockService {

    private final StringRedisTemplate redisTemplate;

    private static final String LOCK_PREFIX = "lock:";
    private static final Duration DEFAULT_LOCK_TIMEOUT = Duration.ofSeconds(30);
    private static final Duration DEFAULT_WAIT_TIMEOUT = Duration.ofSeconds(10);
    private static final long RETRY_DELAY_MS = 50;

    /**
     * Execute a supplier with distributed lock protection.
     * Only one caller will execute the supplier; others wait for the result.
     *
     * @param lockKey The unique key for this lock
     * @param supplier The function to execute if lock is acquired
     * @param cacheGetter Function to check if cached value exists
     * @param <T> Return type
     * @return The result from supplier or cache
     */
    public <T> T executeWithLock(
            String lockKey,
            Supplier<T> supplier,
            Supplier<T> cacheGetter) {
        return executeWithLock(lockKey, supplier, cacheGetter, DEFAULT_LOCK_TIMEOUT, DEFAULT_WAIT_TIMEOUT);
    }

    /**
     * Execute with customizable timeouts
     */
    public <T> T executeWithLock(
            String lockKey,
            Supplier<T> supplier,
            Supplier<T> cacheGetter,
            Duration lockTimeout,
            Duration waitTimeout) {

        String fullLockKey = LOCK_PREFIX + lockKey;
        String lockValue = UUID.randomUUID().toString();
        long waitEndTime = System.currentTimeMillis() + waitTimeout.toMillis();

        try {
            // Try to acquire lock
            Boolean acquired = redisTemplate.opsForValue()
                    .setIfAbsent(fullLockKey, lockValue, lockTimeout.getSeconds(), TimeUnit.SECONDS);

            if (Boolean.TRUE.equals(acquired)) {
                // Lock acquired - execute the supplier
                log.debug("Lock acquired for key: {}", lockKey);
                try {
                    return supplier.get();
                } finally {
                    // Release lock only if we still own it
                    releaseLock(fullLockKey, lockValue);
                }
            } else {
                // Lock not acquired - wait for cache to be populated
                log.debug("Lock not acquired for key: {}, waiting for cache...", lockKey);
                return waitForCache(lockKey, cacheGetter, waitEndTime);
            }
        } catch (Exception e) {
            log.error("Error during locked execution for key: {}", lockKey, e);
            // Try to release lock in case of error
            releaseLock(fullLockKey, lockValue);
            throw e;
        }
    }

    /**
     * Wait for cache to be populated by another caller
     */
    private <T> T waitForCache(String lockKey, Supplier<T> cacheGetter, long waitEndTime) {
        String fullLockKey = LOCK_PREFIX + lockKey;

        while (System.currentTimeMillis() < waitEndTime) {
            // Check if cache now has the value
            T cachedValue = cacheGetter.get();
            if (cachedValue != null) {
                log.debug("Cache populated while waiting for key: {}", lockKey);
                return cachedValue;
            }

            // Check if lock is still held
            Boolean lockExists = redisTemplate.hasKey(fullLockKey);
            if (!Boolean.TRUE.equals(lockExists)) {
                // Lock released but cache empty - check cache one more time
                cachedValue = cacheGetter.get();
                if (cachedValue != null) {
                    return cachedValue;
                }
                // Lock released but no cache - something went wrong, caller should retry
                log.warn("Lock released but cache empty for key: {}", lockKey);
                return null;
            }

            // Wait before retry
            try {
                Thread.sleep(RETRY_DELAY_MS);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                log.warn("Interrupted while waiting for cache: {}", lockKey);
                return null;
            }
        }

        log.warn("Timeout waiting for cache for key: {}", lockKey);
        return null;
    }

    /**
     * Release lock only if we still own it (atomic check-and-delete)
     */
    private void releaseLock(String fullLockKey, String lockValue) {
        try {
            String currentValue = redisTemplate.opsForValue().get(fullLockKey);
            if (lockValue.equals(currentValue)) {
                redisTemplate.delete(fullLockKey);
                log.debug("Lock released for key: {}", fullLockKey);
            }
        } catch (Exception e) {
            log.warn("Error releasing lock for key: {}", fullLockKey, e);
        }
    }

    /**
     * Try to acquire a simple lock (non-blocking)
     *
     * @param lockKey The lock key
     * @param timeout How long the lock should be held
     * @return true if lock acquired, false otherwise
     */
    public boolean tryLock(String lockKey, Duration timeout) {
        String fullLockKey = LOCK_PREFIX + lockKey;
        String lockValue = UUID.randomUUID().toString();

        Boolean acquired = redisTemplate.opsForValue()
                .setIfAbsent(fullLockKey, lockValue, timeout.getSeconds(), TimeUnit.SECONDS);

        return Boolean.TRUE.equals(acquired);
    }

    /**
     * Force release a lock (admin operation)
     */
    public void forceReleaseLock(String lockKey) {
        String fullLockKey = LOCK_PREFIX + lockKey;
        redisTemplate.delete(fullLockKey);
        log.info("Force released lock for key: {}", lockKey);
    }

    /**
     * Check if a lock exists
     */
    public boolean isLocked(String lockKey) {
        String fullLockKey = LOCK_PREFIX + lockKey;
        return Boolean.TRUE.equals(redisTemplate.hasKey(fullLockKey));
    }
}
