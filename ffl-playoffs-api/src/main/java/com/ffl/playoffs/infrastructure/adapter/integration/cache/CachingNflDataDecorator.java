package com.ffl.playoffs.infrastructure.adapter.integration.cache;

import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.infrastructure.config.cache.CacheTTLConfig;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.cache.Cache;
import org.springframework.cache.CacheManager;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Map;

/**
 * Multi-Layer Caching Decorator for NflDataProvider
 *
 * Implements:
 * - Two-layer caching (Caffeine L1 + Redis L2)
 * - Different TTL strategies per data type
 * - Cache stampede protection via distributed locks
 * - Cache metrics tracking
 *
 * Cache Flow: Request -> Caffeine (L1) -> Redis (L2) -> API -> Cache -> Response
 *
 * Hexagonal Architecture: Infrastructure layer decorator
 */
@Component("cachingNflDataDecorator")
@Slf4j
public class CachingNflDataDecorator implements NflDataProvider {

    private final NflDataProvider delegate;
    private final CacheManager cacheManager;
    private final DistributedLockService lockService;
    private final CacheMetricsService metricsService;

    public CachingNflDataDecorator(
            @Qualifier("sportsDataIoAdapter") NflDataProvider delegate,
            CacheManager cacheManager,
            DistributedLockService lockService,
            CacheMetricsService metricsService) {
        this.delegate = delegate;
        this.cacheManager = cacheManager;
        this.lockService = lockService;
        this.metricsService = metricsService;
        log.info("CachingNflDataDecorator initialized with multi-layer caching and stampede protection");
    }

    @Override
    public List<String> getPlayoffTeams(int season) {
        String cacheKey = CacheTTLConfig.PLAYOFF_TEAMS.buildKeySingle(String.valueOf(season));
        String cacheName = CacheTTLConfig.PLAYOFF_TEAMS.getCacheName();

        return getWithCacheAndLock(
                cacheName,
                cacheKey,
                () -> delegate.getPlayoffTeams(season),
                List.class
        );
    }

    @Override
    public Map<String, Object> getTeamPlayerStats(String teamAbbreviation, int week, int season) {
        String cacheKey = CacheTTLConfig.PLAYER_PROFILE.buildKeyMultiple(teamAbbreviation, String.valueOf(week), String.valueOf(season));
        String cacheName = CacheTTLConfig.PLAYER_PROFILE.getCacheName();

        return getWithCacheAndLock(
                cacheName,
                cacheKey,
                () -> delegate.getTeamPlayerStats(teamAbbreviation, week, season),
                Map.class
        );
    }

    @Override
    public List<Map<String, Object>> getWeekSchedule(int week, int season) {
        String cacheKey = CacheTTLConfig.SCHEDULE.buildKeyMultiple(String.valueOf(week), String.valueOf(season));
        String cacheName = CacheTTLConfig.SCHEDULE.getCacheName();

        return getWithCacheAndLock(
                cacheName,
                cacheKey,
                () -> delegate.getWeekSchedule(week, season),
                List.class
        );
    }

    @Override
    public boolean isTeamPlaying(String teamAbbreviation, int week, int season) {
        String cacheKey = CacheTTLConfig.SCHEDULE.buildKeyMultiple("playing", teamAbbreviation, String.valueOf(week), String.valueOf(season));
        String cacheName = CacheTTLConfig.SCHEDULE.getCacheName();

        Boolean result = getWithCacheAndLock(
                cacheName,
                cacheKey,
                () -> delegate.isTeamPlaying(teamAbbreviation, week, season),
                Boolean.class
        );

        return result != null ? result : false;
    }

    /**
     * Get value from cache with stampede protection
     *
     * Flow:
     * 1. Check L1 (Caffeine) cache
     * 2. If miss, check L2 (Redis) cache
     * 3. If miss, acquire distributed lock
     * 4. Only one request fetches from API
     * 5. Result is cached in both layers
     * 6. Other requests wait and get cached result
     */
    @SuppressWarnings("unchecked")
    private <T> T getWithCacheAndLock(
            String cacheName,
            String cacheKey,
            java.util.function.Supplier<T> dataFetcher,
            Class<?> expectedType) {

        long startTime = System.currentTimeMillis();

        try {
            // Try to get from cache first
            Cache cache = cacheManager.getCache(cacheName);
            if (cache != null) {
                Cache.ValueWrapper wrapper = cache.get(cacheKey);
                if (wrapper != null && wrapper.get() != null) {
                    metricsService.recordHit(cacheName);
                    metricsService.recordResponseTime(cacheName, System.currentTimeMillis() - startTime);
                    log.debug("Cache HIT for {}: {}", cacheName, cacheKey);
                    return (T) wrapper.get();
                }
            }

            // Cache miss - use distributed lock to prevent stampede
            metricsService.recordMiss(cacheName);
            log.debug("Cache MISS for {}: {}", cacheName, cacheKey);

            final Cache finalCache = cache;
            return lockService.executeWithLock(
                    cacheKey,
                    () -> {
                        // Double-check cache after acquiring lock
                        if (finalCache != null) {
                            Cache.ValueWrapper wrapper = finalCache.get(cacheKey);
                            if (wrapper != null && wrapper.get() != null) {
                                log.debug("Cache populated while waiting for lock: {}", cacheKey);
                                return (T) wrapper.get();
                            }
                        }

                        // Fetch from API
                        log.debug("Fetching from API for key: {}", cacheKey);
                        T result = dataFetcher.get();

                        // Store in cache
                        if (result != null && finalCache != null) {
                            finalCache.put(cacheKey, result);
                            log.debug("Cached result for key: {}", cacheKey);
                        }

                        metricsService.recordResponseTime(cacheName, System.currentTimeMillis() - startTime);
                        return result;
                    },
                    () -> {
                        // Cache getter for waiting requests
                        if (finalCache != null) {
                            Cache.ValueWrapper wrapper = finalCache.get(cacheKey);
                            if (wrapper != null) {
                                return (T) wrapper.get();
                            }
                        }
                        return null;
                    }
            );

        } catch (Exception e) {
            log.error("Error getting cached data for {}: {}", cacheName, cacheKey, e);
            // Fallback to direct API call on cache error
            return dataFetcher.get();
        }
    }

    /**
     * Invalidate cache for a specific key
     */
    public void invalidateCache(String cacheName, String cacheKey) {
        Cache cache = cacheManager.getCache(cacheName);
        if (cache != null) {
            cache.evict(cacheKey);
            log.info("Cache invalidated: {} - {}", cacheName, cacheKey);
        }
    }

    /**
     * Invalidate all entries in a cache
     */
    public void invalidateCache(String cacheName) {
        Cache cache = cacheManager.getCache(cacheName);
        if (cache != null) {
            cache.clear();
            log.info("Cache cleared: {}", cacheName);
        }
    }

    /**
     * Invalidate schedule cache (for manual refresh after time changes)
     */
    public void invalidateScheduleCache(int week, int season) {
        String cacheKey = CacheTTLConfig.SCHEDULE.buildKeyMultiple(String.valueOf(week), String.valueOf(season));
        invalidateCache(CacheTTLConfig.SCHEDULE.getCacheName(), cacheKey);
    }

    /**
     * Invalidate player cache (for roster updates)
     */
    public void invalidatePlayerCache(String teamAbbreviation, int week, int season) {
        String cacheKey = CacheTTLConfig.PLAYER_PROFILE.buildKeyMultiple(teamAbbreviation, String.valueOf(week), String.valueOf(season));
        invalidateCache(CacheTTLConfig.PLAYER_PROFILE.getCacheName(), cacheKey);
    }
}
