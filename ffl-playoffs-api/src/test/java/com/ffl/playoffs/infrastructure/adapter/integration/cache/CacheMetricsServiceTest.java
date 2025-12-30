package com.ffl.playoffs.infrastructure.adapter.integration.cache;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for CacheMetricsService
 */
class CacheMetricsServiceTest {

    private CacheMetricsService metricsService;

    @BeforeEach
    void setUp() {
        metricsService = new CacheMetricsService();
    }

    @Test
    void shouldRecordCacheHits() {
        // Given
        String cacheName = "test-cache";

        // When
        metricsService.recordHit(cacheName);
        metricsService.recordHit(cacheName);
        metricsService.recordHit(cacheName);

        // Then
        var stats = metricsService.getAllStats().get(cacheName);
        assertNotNull(stats);
        assertEquals(3, stats.getHits());
        assertEquals(0, stats.getMisses());
    }

    @Test
    void shouldRecordCacheMisses() {
        // Given
        String cacheName = "test-cache";

        // When
        metricsService.recordMiss(cacheName);
        metricsService.recordMiss(cacheName);

        // Then
        var stats = metricsService.getAllStats().get(cacheName);
        assertNotNull(stats);
        assertEquals(0, stats.getHits());
        assertEquals(2, stats.getMisses());
    }

    @Test
    void shouldCalculateHitRatioCorrectly() {
        // Given
        String cacheName = "test-cache";

        // When - 8 hits, 2 misses = 80% hit ratio
        for (int i = 0; i < 8; i++) {
            metricsService.recordHit(cacheName);
        }
        for (int i = 0; i < 2; i++) {
            metricsService.recordMiss(cacheName);
        }

        // Then
        assertEquals(0.80, metricsService.getHitRatio(cacheName), 0.01);
    }

    @Test
    void shouldCalculateOverallHitRatio() {
        // Given
        String cache1 = "cache-1";
        String cache2 = "cache-2";

        // When - cache1: 6 hits, 4 misses; cache2: 4 hits, 6 misses = 50% overall
        for (int i = 0; i < 6; i++) metricsService.recordHit(cache1);
        for (int i = 0; i < 4; i++) metricsService.recordMiss(cache1);
        for (int i = 0; i < 4; i++) metricsService.recordHit(cache2);
        for (int i = 0; i < 6; i++) metricsService.recordMiss(cache2);

        // Then
        assertEquals(0.50, metricsService.getOverallHitRatio(), 0.01);
    }

    @Test
    void shouldRecordResponseTimes() {
        // Given
        String cacheName = "test-cache";

        // When
        metricsService.recordResponseTime(cacheName, 10);
        metricsService.recordResponseTime(cacheName, 20);
        metricsService.recordResponseTime(cacheName, 30);

        // Then - average should be 20ms
        var stats = metricsService.getAllStats().get(cacheName);
        assertEquals(20.0, stats.getAverageResponseTime(), 0.01);
    }

    @Test
    void shouldResetStats() {
        // Given
        String cacheName = "test-cache";
        metricsService.recordHit(cacheName);
        metricsService.recordMiss(cacheName);

        // When
        metricsService.resetStats();

        // Then
        assertTrue(metricsService.getAllStats().isEmpty());
    }

    @Test
    void shouldReturnZeroHitRatioForUnknownCache() {
        // When/Then
        assertEquals(0.0, metricsService.getHitRatio("unknown-cache"));
    }

    @Test
    void shouldReturnZeroOverallRatioWhenNoStats() {
        // When/Then
        assertEquals(0.0, metricsService.getOverallHitRatio());
    }

    @Test
    void shouldTrackMultipleCachesIndependently() {
        // Given
        String cacheA = "cache-a";
        String cacheB = "cache-b";

        // When
        metricsService.recordHit(cacheA);
        metricsService.recordHit(cacheA);
        metricsService.recordMiss(cacheB);
        metricsService.recordMiss(cacheB);
        metricsService.recordMiss(cacheB);

        // Then
        assertEquals(1.0, metricsService.getHitRatio(cacheA)); // 100% hits
        assertEquals(0.0, metricsService.getHitRatio(cacheB)); // 100% misses
    }
}
