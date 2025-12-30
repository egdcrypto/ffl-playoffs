package com.ffl.playoffs.infrastructure.adapter.integration.ratelimit;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.time.Instant;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for RateLimitMetrics
 */
class RateLimitMetricsTest {

    private RateLimitMetrics metrics;

    @BeforeEach
    void setUp() {
        metrics = new RateLimitMetrics();
    }

    @Nested
    @DisplayName("Call Recording")
    class CallRecording {

        @Test
        @DisplayName("should record API calls")
        void shouldRecordCalls() {
            metrics.recordCall("getPlayoffTeams");
            metrics.recordCall("getPlayoffTeams");
            metrics.recordCall("getWeekSchedule");

            assertEquals(3, metrics.getTotalCalls().get());
        }

        @Test
        @DisplayName("should track calls per endpoint")
        void shouldTrackCallsPerEndpoint() {
            metrics.recordCall("getPlayoffTeams");
            metrics.recordCall("getPlayoffTeams");
            metrics.recordCall("getWeekSchedule");

            assertEquals(2, metrics.getEndpointMetrics().get("getPlayoffTeams").getCalls().get());
            assertEquals(1, metrics.getEndpointMetrics().get("getWeekSchedule").getCalls().get());
        }

        @Test
        @DisplayName("should record rate-limited calls")
        void shouldRecordRateLimitedCalls() {
            metrics.recordRateLimited("getPlayoffTeams");
            metrics.recordRateLimited("getPlayoffTeams");

            assertEquals(2, metrics.getRateLimitedCalls().get());
            assertEquals(2, metrics.getEndpointMetrics().get("getPlayoffTeams").getRateLimited().get());
        }

        @Test
        @DisplayName("should record rejected calls")
        void shouldRecordRejectedCalls() {
            metrics.recordRejected("getPlayoffTeams");

            assertEquals(1, metrics.getRejectedCalls().get());
            assertEquals(1, metrics.getEndpointMetrics().get("getPlayoffTeams").getRejected().get());
        }

        @Test
        @DisplayName("should record rate limit hits")
        void shouldRecordRateLimitHits() {
            metrics.recordRateLimitHit();
            metrics.recordRateLimitHit();

            assertEquals(2, metrics.getRateLimitHits().get());
        }
    }

    @Nested
    @DisplayName("Token Tracking")
    class TokenTracking {

        @Test
        @DisplayName("should update available tokens")
        void shouldUpdateAvailableTokens() {
            metrics.updateAvailableTokens(25);

            assertEquals(25, metrics.getAvailableTokens().get());
        }

        @Test
        @DisplayName("should calculate usage percentage")
        void shouldCalculateUsagePercent() {
            metrics.updateAvailableTokens(15);

            // 15 of 30 remaining = 50% used
            assertEquals(50.0, metrics.getUsagePercent(30), 0.1);
        }

        @Test
        @DisplayName("should detect when alert threshold is reached")
        void shouldDetectAlertThreshold() {
            metrics.updateAvailableTokens(5);

            assertTrue(metrics.shouldAlert(6));
            assertFalse(metrics.shouldAlert(4));
        }
    }

    @Nested
    @DisplayName("Queue Tracking")
    class QueueTracking {

        @Test
        @DisplayName("should update queue size")
        void shouldUpdateQueueSize() {
            metrics.updateQueueSize(10);

            assertEquals(10, metrics.getQueueSize().get());
        }
    }

    @Nested
    @DisplayName("Rate Limit Headers")
    class RateLimitHeadersTests {

        @Test
        @DisplayName("should update from headers")
        void shouldUpdateFromHeaders() {
            long resetTimestamp = Instant.now().plusSeconds(60).getEpochSecond();
            RateLimitMetrics.RateLimitHeaders headers =
                new RateLimitMetrics.RateLimitHeaders(30, 15, resetTimestamp);

            metrics.updateFromHeaders(headers);

            assertNotNull(metrics.getLastHeaders());
            assertEquals(30, metrics.getLastHeaders().getLimit());
            assertEquals(15, metrics.getLastHeaders().getRemaining());
        }

        @Test
        @DisplayName("should calculate seconds until reset")
        void shouldCalculateSecondsUntilReset() {
            long resetTimestamp = Instant.now().plusSeconds(30).getEpochSecond();
            RateLimitMetrics.RateLimitHeaders headers =
                new RateLimitMetrics.RateLimitHeaders(30, 15, resetTimestamp);

            long secondsUntilReset = headers.getSecondsUntilReset();

            // Allow some variance due to test execution time
            assertTrue(secondsUntilReset >= 28 && secondsUntilReset <= 31);
        }
    }

    @Nested
    @DisplayName("Metrics Snapshot")
    class MetricsSnapshotTests {

        @Test
        @DisplayName("should create snapshot with current values")
        void shouldCreateSnapshot() {
            metrics.recordCall("endpoint1");
            metrics.recordCall("endpoint2");
            metrics.recordRateLimited("endpoint1");
            metrics.recordRejected("endpoint1");
            metrics.recordRateLimitHit();
            metrics.updateAvailableTokens(20);
            metrics.updateQueueSize(5);

            RateLimitMetrics.MetricsSnapshot snapshot = metrics.getSnapshot();

            assertEquals(2, snapshot.totalCalls());
            assertEquals(1, snapshot.rateLimitedCalls());
            assertEquals(1, snapshot.rejectedCalls());
            assertEquals(1, snapshot.rateLimitHits());
            assertEquals(20, snapshot.availableTokens());
            assertEquals(5, snapshot.queueSize());
        }
    }

    @Nested
    @DisplayName("Metrics Reset")
    class MetricsReset {

        @Test
        @DisplayName("should reset all metrics")
        void shouldResetAllMetrics() {
            // Set some values
            metrics.recordCall("endpoint1");
            metrics.recordRateLimited("endpoint1");
            metrics.recordRejected("endpoint1");
            metrics.recordRateLimitHit();
            metrics.updateQueueSize(10);

            // Reset
            metrics.reset();

            // Verify all reset
            assertEquals(0, metrics.getTotalCalls().get());
            assertEquals(0, metrics.getRateLimitedCalls().get());
            assertEquals(0, metrics.getRejectedCalls().get());
            assertEquals(0, metrics.getRateLimitHits().get());
            assertEquals(0, metrics.getQueueSize().get());
            assertTrue(metrics.getEndpointMetrics().isEmpty());
        }
    }

    @Nested
    @DisplayName("Violations Tracking")
    class ViolationsTracking {

        @Test
        @DisplayName("should track violations this hour")
        void shouldTrackViolationsThisHour() {
            metrics.recordRateLimitHit();
            metrics.recordRateLimitHit();
            metrics.recordRateLimitHit();

            assertEquals(3, metrics.getViolationsThisHour());
        }
    }
}
