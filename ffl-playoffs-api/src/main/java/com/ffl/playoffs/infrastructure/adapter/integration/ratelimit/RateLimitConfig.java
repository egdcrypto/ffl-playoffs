package com.ffl.playoffs.infrastructure.adapter.integration.ratelimit;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration properties for NFL Data API rate limiting.
 * Maps to 'nfl-data.rate-limit' properties in application.yml
 *
 * Supports:
 * - Configurable bucket capacity and refill rate
 * - Per-tier rate limits (FREE, STARTER, PAID)
 * - Alert thresholds for monitoring
 * - Distributed rate limiting via Redis
 */
@Configuration
@ConfigurationProperties(prefix = "nfl-data.rate-limit")
@Data
public class RateLimitConfig {

    /**
     * Enable/disable rate limiting (default: true)
     */
    private boolean enabled = true;

    /**
     * Token bucket capacity (max burst size)
     * Default: 30 tokens (as per feature file: 30 requests per minute capacity)
     */
    private int bucketCapacity = 30;

    /**
     * Tokens to refill per period
     * Default: 30 tokens per minute (0.5 tokens/second)
     */
    private int refillTokens = 30;

    /**
     * Refill period in seconds
     * Default: 60 seconds (refill to full every minute)
     */
    private int refillPeriodSeconds = 60;

    /**
     * Maximum queue size for waiting requests
     * Default: 100 requests
     */
    private int maxQueueSize = 100;

    /**
     * Alert threshold as percentage of bucket capacity (0-100)
     * Default: 80% - alert when only 20% tokens remaining
     */
    private int alertThresholdPercent = 80;

    /**
     * Enable distributed rate limiting via Redis
     * Default: false (local rate limiting)
     */
    private boolean distributedEnabled = false;

    /**
     * Redis key prefix for distributed rate limiting
     */
    private String redisKeyPrefix = "ffl:ratelimit:";

    /**
     * Number of application instances for fallback calculation
     * When Redis is unavailable, divide limit by this number
     */
    private int instanceCount = 1;

    /**
     * Backoff settings for 429 responses
     */
    private BackoffConfig backoff = new BackoffConfig();

    /**
     * API tier settings
     */
    private TierConfig tier = new TierConfig();

    /**
     * Backoff configuration for rate limit violations
     */
    @Data
    public static class BackoffConfig {
        /**
         * Initial backoff in milliseconds after hitting rate limit
         */
        private long initialBackoffMs = 2000;

        /**
         * Maximum backoff in milliseconds
         */
        private long maxBackoffMs = 60000;

        /**
         * Backoff multiplier for exponential backoff
         */
        private double multiplier = 2.0;

        /**
         * Number of rate limit violations before permanent reduction
         */
        private int permanentReductionThreshold = 5;

        /**
         * Permanent rate reduction percentage (e.g., 80 = reduce to 80%)
         */
        private int permanentReductionPercent = 80;
    }

    /**
     * API tier configuration
     */
    @Data
    public static class TierConfig {
        /**
         * Current API tier: FREE, STARTER, PAID
         */
        private ApiTier current = ApiTier.FREE;

        /**
         * Rate limits per tier (requests per minute)
         */
        private int freeLimit = 30;
        private int starterLimit = 60;
        private int paidLimit = 600;

        /**
         * Get rate limit for current tier
         */
        public int getCurrentLimit() {
            return switch (current) {
                case FREE -> freeLimit;
                case STARTER -> starterLimit;
                case PAID -> paidLimit;
            };
        }
    }

    /**
     * API tier enumeration
     */
    public enum ApiTier {
        FREE,
        STARTER,
        PAID
    }

    /**
     * Get tokens per second based on current configuration
     */
    public double getTokensPerSecond() {
        return (double) refillTokens / refillPeriodSeconds;
    }

    /**
     * Get effective bucket capacity based on tier
     */
    public int getEffectiveBucketCapacity() {
        return Math.min(bucketCapacity, tier.getCurrentLimit());
    }

    /**
     * Get alert threshold in tokens
     */
    public int getAlertThresholdTokens() {
        return (int) (getEffectiveBucketCapacity() * (100 - alertThresholdPercent) / 100.0);
    }
}
