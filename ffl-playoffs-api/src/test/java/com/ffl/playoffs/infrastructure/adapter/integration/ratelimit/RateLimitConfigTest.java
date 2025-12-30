package com.ffl.playoffs.infrastructure.adapter.integration.ratelimit;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for RateLimitConfig
 */
class RateLimitConfigTest {

    private RateLimitConfig config;

    @BeforeEach
    void setUp() {
        config = new RateLimitConfig();
    }

    @Nested
    @DisplayName("Default Values")
    class DefaultValues {

        @Test
        @DisplayName("should have rate limiting enabled by default")
        void shouldBeEnabledByDefault() {
            assertTrue(config.isEnabled());
        }

        @Test
        @DisplayName("should have default bucket capacity of 30")
        void shouldHaveDefaultBucketCapacity() {
            assertEquals(30, config.getBucketCapacity());
        }

        @Test
        @DisplayName("should have default refill tokens of 30")
        void shouldHaveDefaultRefillTokens() {
            assertEquals(30, config.getRefillTokens());
        }

        @Test
        @DisplayName("should have default refill period of 60 seconds")
        void shouldHaveDefaultRefillPeriod() {
            assertEquals(60, config.getRefillPeriodSeconds());
        }

        @Test
        @DisplayName("should have default max queue size of 100")
        void shouldHaveDefaultMaxQueueSize() {
            assertEquals(100, config.getMaxQueueSize());
        }

        @Test
        @DisplayName("should have default alert threshold of 80%")
        void shouldHaveDefaultAlertThreshold() {
            assertEquals(80, config.getAlertThresholdPercent());
        }

        @Test
        @DisplayName("should have distributed rate limiting disabled by default")
        void shouldHaveDistributedDisabledByDefault() {
            assertFalse(config.isDistributedEnabled());
        }

        @Test
        @DisplayName("should have FREE tier by default")
        void shouldHaveFreeTierByDefault() {
            assertEquals(RateLimitConfig.ApiTier.FREE, config.getTier().getCurrent());
        }
    }

    @Nested
    @DisplayName("Computed Values")
    class ComputedValues {

        @Test
        @DisplayName("should calculate tokens per second correctly")
        void shouldCalculateTokensPerSecond() {
            config.setRefillTokens(30);
            config.setRefillPeriodSeconds(60);

            assertEquals(0.5, config.getTokensPerSecond(), 0.001);
        }

        @Test
        @DisplayName("should calculate effective bucket capacity based on tier")
        void shouldCalculateEffectiveBucketCapacity() {
            config.setBucketCapacity(100);
            config.getTier().setCurrent(RateLimitConfig.ApiTier.FREE);
            config.getTier().setFreeLimit(30);

            assertEquals(30, config.getEffectiveBucketCapacity());
        }

        @Test
        @DisplayName("should use bucket capacity when lower than tier limit")
        void shouldUseBucketCapacityWhenLower() {
            config.setBucketCapacity(20);
            config.getTier().setCurrent(RateLimitConfig.ApiTier.PAID);
            config.getTier().setPaidLimit(600);

            assertEquals(20, config.getEffectiveBucketCapacity());
        }

        @Test
        @DisplayName("should calculate alert threshold in tokens")
        void shouldCalculateAlertThresholdTokens() {
            config.setBucketCapacity(30);
            config.setAlertThresholdPercent(80);
            config.getTier().setCurrent(RateLimitConfig.ApiTier.FREE);
            config.getTier().setFreeLimit(30);

            // 80% threshold means alert when 20% remaining = 6 tokens
            assertEquals(6, config.getAlertThresholdTokens());
        }
    }

    @Nested
    @DisplayName("Tier Configuration")
    class TierConfiguration {

        @Test
        @DisplayName("should return correct limit for FREE tier")
        void shouldReturnFreeTierLimit() {
            config.getTier().setCurrent(RateLimitConfig.ApiTier.FREE);
            config.getTier().setFreeLimit(30);

            assertEquals(30, config.getTier().getCurrentLimit());
        }

        @Test
        @DisplayName("should return correct limit for STARTER tier")
        void shouldReturnStarterTierLimit() {
            config.getTier().setCurrent(RateLimitConfig.ApiTier.STARTER);
            config.getTier().setStarterLimit(60);

            assertEquals(60, config.getTier().getCurrentLimit());
        }

        @Test
        @DisplayName("should return correct limit for PAID tier")
        void shouldReturnPaidTierLimit() {
            config.getTier().setCurrent(RateLimitConfig.ApiTier.PAID);
            config.getTier().setPaidLimit(600);

            assertEquals(600, config.getTier().getCurrentLimit());
        }
    }

    @Nested
    @DisplayName("Backoff Configuration")
    class BackoffConfiguration {

        @Test
        @DisplayName("should have default initial backoff of 2000ms")
        void shouldHaveDefaultInitialBackoff() {
            assertEquals(2000, config.getBackoff().getInitialBackoffMs());
        }

        @Test
        @DisplayName("should have default max backoff of 60000ms")
        void shouldHaveDefaultMaxBackoff() {
            assertEquals(60000, config.getBackoff().getMaxBackoffMs());
        }

        @Test
        @DisplayName("should have default backoff multiplier of 2.0")
        void shouldHaveDefaultMultiplier() {
            assertEquals(2.0, config.getBackoff().getMultiplier(), 0.001);
        }

        @Test
        @DisplayName("should have default permanent reduction threshold of 5")
        void shouldHaveDefaultPermanentReductionThreshold() {
            assertEquals(5, config.getBackoff().getPermanentReductionThreshold());
        }

        @Test
        @DisplayName("should have default permanent reduction percent of 80")
        void shouldHaveDefaultPermanentReductionPercent() {
            assertEquals(80, config.getBackoff().getPermanentReductionPercent());
        }
    }
}
