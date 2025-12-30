package com.ffl.playoffs.infrastructure.adapter.integration.ratelimit;

import com.ffl.playoffs.domain.port.NflDataProvider;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.*;

/**
 * Unit tests for RateLimitingNflDataDecorator
 */
@ExtendWith(MockitoExtension.class)
class RateLimitingNflDataDecoratorTest {

    @Mock
    private NflDataProvider delegate;

    private RateLimitConfig config;
    private RateLimitingNflDataDecorator decorator;

    @BeforeEach
    void setUp() {
        config = new RateLimitConfig();
        config.setEnabled(true);
        config.setBucketCapacity(30);
        config.setRefillTokens(30);
        config.setRefillPeriodSeconds(60);
        config.getTier().setCurrent(RateLimitConfig.ApiTier.FREE);
        config.getTier().setFreeLimit(30);

        decorator = new RateLimitingNflDataDecorator(delegate, config);
    }

    @Nested
    @DisplayName("Constructor")
    class ConstructorTests {

        @Test
        @DisplayName("should initialize with config")
        void shouldInitializeWithConfig() {
            assertNotNull(decorator);
            assertTrue(decorator.isEnabled());
            assertEquals(30, decorator.getEffectiveLimit());
        }

        @Test
        @DisplayName("should initialize with default config when not provided")
        void shouldInitializeWithDefaultConfig() {
            RateLimitingNflDataDecorator defaultDecorator = new RateLimitingNflDataDecorator(delegate);

            assertNotNull(defaultDecorator);
            assertTrue(defaultDecorator.isEnabled());
        }

        @Test
        @DisplayName("should start with full token bucket")
        void shouldStartWithFullBucket() {
            assertEquals(30, decorator.getAvailableTokens());
        }
    }

    @Nested
    @DisplayName("Token Consumption")
    class TokenConsumption {

        @Test
        @DisplayName("should consume token on getPlayoffTeams")
        void shouldConsumeTokenOnGetPlayoffTeams() {
            when(delegate.getPlayoffTeams(anyInt())).thenReturn(List.of("KC", "BUF"));

            decorator.getPlayoffTeams(2024);

            assertEquals(29, decorator.getAvailableTokens());
            verify(delegate).getPlayoffTeams(2024);
        }

        @Test
        @DisplayName("should consume token on getTeamPlayerStats")
        void shouldConsumeTokenOnGetTeamPlayerStats() {
            when(delegate.getTeamPlayerStats(anyString(), anyInt(), anyInt())).thenReturn(Map.of());

            decorator.getTeamPlayerStats("KC", 1, 2024);

            assertEquals(29, decorator.getAvailableTokens());
            verify(delegate).getTeamPlayerStats("KC", 1, 2024);
        }

        @Test
        @DisplayName("should consume token on getWeekSchedule")
        void shouldConsumeTokenOnGetWeekSchedule() {
            when(delegate.getWeekSchedule(anyInt(), anyInt())).thenReturn(List.of());

            decorator.getWeekSchedule(1, 2024);

            assertEquals(29, decorator.getAvailableTokens());
            verify(delegate).getWeekSchedule(1, 2024);
        }

        @Test
        @DisplayName("should consume token on isTeamPlaying")
        void shouldConsumeTokenOnIsTeamPlaying() {
            when(delegate.isTeamPlaying(anyString(), anyInt(), anyInt())).thenReturn(true);

            decorator.isTeamPlaying("KC", 1, 2024);

            assertEquals(29, decorator.getAvailableTokens());
            verify(delegate).isTeamPlaying("KC", 1, 2024);
        }

        @Test
        @DisplayName("should consume multiple tokens for multiple calls")
        void shouldConsumeMultipleTokens() {
            when(delegate.getPlayoffTeams(anyInt())).thenReturn(List.of());

            decorator.getPlayoffTeams(2024);
            decorator.getPlayoffTeams(2024);
            decorator.getPlayoffTeams(2024);

            assertEquals(27, decorator.getAvailableTokens());
            verify(delegate, times(3)).getPlayoffTeams(2024);
        }
    }

    @Nested
    @DisplayName("Rate Limiting Disabled")
    class RateLimitingDisabled {

        @Test
        @DisplayName("should not consume tokens when disabled")
        void shouldNotConsumeTokensWhenDisabled() {
            config.setEnabled(false);
            decorator = new RateLimitingNflDataDecorator(delegate, config);

            when(delegate.getPlayoffTeams(anyInt())).thenReturn(List.of());

            decorator.getPlayoffTeams(2024);

            // Tokens should remain at capacity
            assertEquals(30, decorator.getAvailableTokens());
        }

        @Test
        @DisplayName("should report disabled status")
        void shouldReportDisabledStatus() {
            config.setEnabled(false);
            decorator = new RateLimitingNflDataDecorator(delegate, config);

            assertFalse(decorator.isEnabled());
        }
    }

    @Nested
    @DisplayName("Metrics Tracking")
    class MetricsTracking {

        @Test
        @DisplayName("should track total calls")
        void shouldTrackTotalCalls() {
            when(delegate.getPlayoffTeams(anyInt())).thenReturn(List.of());

            decorator.getPlayoffTeams(2024);
            decorator.getPlayoffTeams(2024);

            RateLimitMetrics.MetricsSnapshot snapshot = decorator.getMetricsSnapshot();
            assertEquals(2, snapshot.totalCalls());
        }

        @Test
        @DisplayName("should track available tokens")
        void shouldTrackAvailableTokens() {
            when(delegate.getPlayoffTeams(anyInt())).thenReturn(List.of());

            decorator.getPlayoffTeams(2024);

            RateLimitMetrics.MetricsSnapshot snapshot = decorator.getMetricsSnapshot();
            assertEquals(29, snapshot.availableTokens());
        }

        @Test
        @DisplayName("should return metrics object")
        void shouldReturnMetrics() {
            assertNotNull(decorator.getMetrics());
        }
    }

    @Nested
    @DisplayName("Rate Limit Response Handling")
    class RateLimitResponseHandling {

        @Test
        @DisplayName("should record rate limit hit")
        void shouldRecordRateLimitHit() {
            decorator.handleRateLimitResponse();

            RateLimitMetrics.MetricsSnapshot snapshot = decorator.getMetricsSnapshot();
            assertEquals(1, snapshot.rateLimitHits());
        }

        @Test
        @DisplayName("should record multiple rate limit hits")
        void shouldRecordMultipleRateLimitHits() {
            decorator.handleRateLimitResponse();
            decorator.handleRateLimitResponse();
            decorator.handleRateLimitResponse();

            RateLimitMetrics.MetricsSnapshot snapshot = decorator.getMetricsSnapshot();
            assertEquals(3, snapshot.rateLimitHits());
        }
    }

    @Nested
    @DisplayName("Rate Limit Headers")
    class RateLimitHeaders {

        @Test
        @DisplayName("should handle rate limit headers")
        void shouldHandleRateLimitHeaders() {
            long resetTimestamp = System.currentTimeMillis() / 1000 + 60;

            decorator.handleRateLimitHeaders(30, 10, resetTimestamp);

            RateLimitMetrics.MetricsSnapshot snapshot = decorator.getMetricsSnapshot();
            assertNotNull(snapshot.lastHeaders());
            assertEquals(30, snapshot.lastHeaders().getLimit());
            assertEquals(10, snapshot.lastHeaders().getRemaining());
        }
    }

    @Nested
    @DisplayName("Backoff Management")
    class BackoffManagement {

        @Test
        @DisplayName("should reset backoff")
        void shouldResetBackoff() {
            decorator.handleRateLimitResponse(); // Trigger backoff
            decorator.resetBackoff();

            // No exception should be thrown when making calls after reset
            when(delegate.getPlayoffTeams(anyInt())).thenReturn(List.of());
            decorator.getPlayoffTeams(2024);

            verify(delegate).getPlayoffTeams(2024);
        }
    }

    @Nested
    @DisplayName("Permanent Rate Reduction")
    class PermanentRateReduction {

        @Test
        @DisplayName("should reduce effective limit after threshold violations")
        void shouldReduceEffectiveLimitAfterThreshold() {
            config.getBackoff().setPermanentReductionThreshold(3);
            config.getBackoff().setPermanentReductionPercent(80);
            decorator = new RateLimitingNflDataDecorator(delegate, config);

            // Record violations beyond threshold
            decorator.handleRateLimitResponse();
            decorator.handleRateLimitResponse();
            decorator.handleRateLimitResponse();

            // Effective limit should be reduced to 80% of 30 = 24
            assertEquals(24, decorator.getEffectiveLimit());
        }
    }

    @Nested
    @DisplayName("Tier Configuration")
    class TierConfiguration {

        @Test
        @DisplayName("should use FREE tier limit")
        void shouldUseFreeTierLimit() {
            config.getTier().setCurrent(RateLimitConfig.ApiTier.FREE);
            config.getTier().setFreeLimit(30);
            config.setBucketCapacity(100);
            decorator = new RateLimitingNflDataDecorator(delegate, config);

            assertEquals(30, decorator.getEffectiveLimit());
        }

        @Test
        @DisplayName("should use STARTER tier limit")
        void shouldUseStarterTierLimit() {
            config.getTier().setCurrent(RateLimitConfig.ApiTier.STARTER);
            config.getTier().setStarterLimit(60);
            config.setBucketCapacity(100);
            decorator = new RateLimitingNflDataDecorator(delegate, config);

            assertEquals(60, decorator.getEffectiveLimit());
        }

        @Test
        @DisplayName("should use PAID tier limit")
        void shouldUsePaidTierLimit() {
            config.getTier().setCurrent(RateLimitConfig.ApiTier.PAID);
            config.getTier().setPaidLimit(600);
            config.setBucketCapacity(1000);
            decorator = new RateLimitingNflDataDecorator(delegate, config);

            assertEquals(600, decorator.getEffectiveLimit());
        }
    }

    @Nested
    @DisplayName("Concurrent Access")
    class ConcurrentAccess {

        @Test
        @DisplayName("should handle concurrent requests safely")
        void shouldHandleConcurrentRequests() throws InterruptedException {
            config.setBucketCapacity(50);
            config.getTier().setFreeLimit(50);
            decorator = new RateLimitingNflDataDecorator(delegate, config);

            when(delegate.getPlayoffTeams(anyInt())).thenReturn(List.of());

            int numThreads = 10;
            int requestsPerThread = 5;
            ExecutorService executor = Executors.newFixedThreadPool(numThreads);
            CountDownLatch latch = new CountDownLatch(numThreads);
            AtomicInteger successfulCalls = new AtomicInteger(0);

            for (int i = 0; i < numThreads; i++) {
                executor.submit(() -> {
                    try {
                        for (int j = 0; j < requestsPerThread; j++) {
                            decorator.getPlayoffTeams(2024);
                            successfulCalls.incrementAndGet();
                        }
                    } finally {
                        latch.countDown();
                    }
                });
            }

            latch.await(30, TimeUnit.SECONDS);
            executor.shutdown();

            // All 50 calls should succeed
            assertEquals(50, successfulCalls.get());
            verify(delegate, times(50)).getPlayoffTeams(2024);
        }
    }

    @Nested
    @DisplayName("Alert Threshold")
    class AlertThreshold {

        @Test
        @DisplayName("should track when alert threshold is reached")
        void shouldTrackAlertThreshold() {
            config.setBucketCapacity(10);
            config.getTier().setFreeLimit(10);
            config.setAlertThresholdPercent(80); // Alert when 2 tokens left
            decorator = new RateLimitingNflDataDecorator(delegate, config);

            when(delegate.getPlayoffTeams(anyInt())).thenReturn(List.of());

            // Make 8 calls to get to 2 tokens remaining
            for (int i = 0; i < 8; i++) {
                decorator.getPlayoffTeams(2024);
            }

            // Metrics should indicate we hit alert threshold
            RateLimitMetrics metrics = decorator.getMetrics();
            assertTrue(metrics.shouldAlert(2));
        }
    }
}
