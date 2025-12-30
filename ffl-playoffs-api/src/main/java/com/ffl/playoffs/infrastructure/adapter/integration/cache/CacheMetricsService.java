package com.ffl.playoffs.infrastructure.adapter.integration.cache;

import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Cache Metrics Service
 *
 * Tracks cache performance metrics:
 * - Hit/miss ratios per cache type
 * - Response times
 * - Memory usage estimates
 *
 * Provides alerts when cache hit rate drops below threshold.
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class CacheMetricsService {

    private static final double TARGET_HIT_RATIO = 0.80; // 80% target
    private static final double ALERT_THRESHOLD = 0.60; // Alert if below 60%

    private final Map<String, CacheStats> statsPerCache = new ConcurrentHashMap<>();

    /**
     * Record a cache hit
     */
    public void recordHit(String cacheName) {
        getStats(cacheName).recordHit();
    }

    /**
     * Record a cache miss
     */
    public void recordMiss(String cacheName) {
        getStats(cacheName).recordMiss();
    }

    /**
     * Record cache operation time
     */
    public void recordResponseTime(String cacheName, long milliseconds) {
        getStats(cacheName).recordResponseTime(milliseconds);
    }

    /**
     * Get stats for a specific cache
     */
    private CacheStats getStats(String cacheName) {
        return statsPerCache.computeIfAbsent(cacheName, k -> new CacheStats(cacheName));
    }

    /**
     * Get overall hit ratio across all caches
     */
    public double getOverallHitRatio() {
        long totalHits = 0;
        long totalMisses = 0;

        for (CacheStats stats : statsPerCache.values()) {
            totalHits += stats.getHits();
            totalMisses += stats.getMisses();
        }

        long total = totalHits + totalMisses;
        return total > 0 ? (double) totalHits / total : 0.0;
    }

    /**
     * Get hit ratio for specific cache
     */
    public double getHitRatio(String cacheName) {
        CacheStats stats = statsPerCache.get(cacheName);
        return stats != null ? stats.getHitRatio() : 0.0;
    }

    /**
     * Get all cache statistics
     */
    public Map<String, CacheStats> getAllStats() {
        return new ConcurrentHashMap<>(statsPerCache);
    }

    /**
     * Check and alert on low cache hit rates - runs every 5 minutes
     */
    @Scheduled(fixedRate = 300000)
    public void checkCacheHealth() {
        double overallHitRatio = getOverallHitRatio();

        if (overallHitRatio > 0 && overallHitRatio < ALERT_THRESHOLD) {
            log.warn("CACHE ALERT: Overall hit ratio {} is below threshold {}",
                    String.format("%.2f%%", overallHitRatio * 100),
                    String.format("%.2f%%", ALERT_THRESHOLD * 100));

            // Log per-cache stats for investigation
            for (Map.Entry<String, CacheStats> entry : statsPerCache.entrySet()) {
                CacheStats stats = entry.getValue();
                if (stats.getHitRatio() < ALERT_THRESHOLD) {
                    log.warn("  {} cache hit ratio: {}, hits: {}, misses: {}",
                            entry.getKey(),
                            String.format("%.2f%%", stats.getHitRatio() * 100),
                            stats.getHits(),
                            stats.getMisses());
                }
            }
        } else if (overallHitRatio > 0) {
            log.info("Cache health check: hit ratio {} (target: {})",
                    String.format("%.2f%%", overallHitRatio * 100),
                    String.format("%.2f%%", TARGET_HIT_RATIO * 100));
        }
    }

    /**
     * Log detailed metrics - runs every hour
     */
    @Scheduled(fixedRate = 3600000)
    public void logDetailedMetrics() {
        log.info("=== Cache Metrics Report ===");
        log.info("Overall hit ratio: {}", String.format("%.2f%%", getOverallHitRatio() * 100));

        for (Map.Entry<String, CacheStats> entry : statsPerCache.entrySet()) {
            CacheStats stats = entry.getValue();
            log.info("  {}: hits={}, misses={}, ratio={}, avgTime={}ms",
                    entry.getKey(),
                    stats.getHits(),
                    stats.getMisses(),
                    String.format("%.2f%%", stats.getHitRatio() * 100),
                    String.format("%.2f", stats.getAverageResponseTime()));
        }
        log.info("===========================");
    }

    /**
     * Reset all statistics (for testing)
     */
    public void resetStats() {
        statsPerCache.clear();
        log.info("Cache metrics reset");
    }

    /**
     * Cache statistics for a single cache
     */
    @Getter
    public static class CacheStats {
        private final String cacheName;
        private final AtomicLong hits = new AtomicLong(0);
        private final AtomicLong misses = new AtomicLong(0);
        private final AtomicLong totalResponseTime = new AtomicLong(0);
        private final AtomicLong responseCount = new AtomicLong(0);

        public CacheStats(String cacheName) {
            this.cacheName = cacheName;
        }

        public void recordHit() {
            hits.incrementAndGet();
        }

        public void recordMiss() {
            misses.incrementAndGet();
        }

        public void recordResponseTime(long milliseconds) {
            totalResponseTime.addAndGet(milliseconds);
            responseCount.incrementAndGet();
        }

        public long getHits() {
            return hits.get();
        }

        public long getMisses() {
            return misses.get();
        }

        public double getHitRatio() {
            long total = hits.get() + misses.get();
            return total > 0 ? (double) hits.get() / total : 0.0;
        }

        public double getAverageResponseTime() {
            long count = responseCount.get();
            return count > 0 ? (double) totalResponseTime.get() / count : 0.0;
        }
    }
}
