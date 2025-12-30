package com.ffl.playoffs.infrastructure.adapter.integration.ratelimit;

import lombok.Data;
import lombok.extern.slf4j.Slf4j;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Metrics tracking for rate limiting.
 * Tracks API usage, rate limit violations, and performance metrics.
 *
 * Thread-safe implementation using atomic variables.
 */
@Slf4j
@Data
public class RateLimitMetrics {

    /**
     * Total API calls made
     */
    private final AtomicLong totalCalls = new AtomicLong(0);

    /**
     * Calls that were rate limited (blocked/queued)
     */
    private final AtomicLong rateLimitedCalls = new AtomicLong(0);

    /**
     * Calls that were rejected (queue full)
     */
    private final AtomicLong rejectedCalls = new AtomicLong(0);

    /**
     * Times rate limit was hit (429 from API)
     */
    private final AtomicInteger rateLimitHits = new AtomicInteger(0);

    /**
     * Current available tokens
     */
    private final AtomicLong availableTokens = new AtomicLong(0);

    /**
     * Current queue size
     */
    private final AtomicInteger queueSize = new AtomicInteger(0);

    /**
     * Peak rate observed (requests per minute)
     */
    private final AtomicInteger peakRate = new AtomicInteger(0);

    /**
     * Calls per minute sliding window
     */
    private final AtomicInteger callsThisMinute = new AtomicInteger(0);

    /**
     * Last minute reset timestamp
     */
    private volatile Instant lastMinuteReset = Instant.now();

    /**
     * Rate limit violations per hour (for permanent reduction logic)
     */
    private final AtomicInteger violationsThisHour = new AtomicInteger(0);

    /**
     * Last hour reset timestamp
     */
    private volatile Instant lastHourReset = Instant.now();

    /**
     * Metrics per endpoint
     */
    private final Map<String, EndpointMetrics> endpointMetrics = new ConcurrentHashMap<>();

    /**
     * Last API response rate limit headers
     */
    private volatile RateLimitHeaders lastHeaders;

    /**
     * Record an API call
     *
     * @param endpoint The endpoint being called
     */
    public void recordCall(String endpoint) {
        totalCalls.incrementAndGet();
        callsThisMinute.incrementAndGet();
        getOrCreateEndpointMetrics(endpoint).recordCall();
        maybeResetMinuteWindow();
        updatePeakRate();
    }

    /**
     * Record a rate-limited (blocked/queued) call
     *
     * @param endpoint The endpoint being called
     */
    public void recordRateLimited(String endpoint) {
        rateLimitedCalls.incrementAndGet();
        getOrCreateEndpointMetrics(endpoint).recordRateLimited();
    }

    /**
     * Record a rejected call (queue full)
     *
     * @param endpoint The endpoint being called
     */
    public void recordRejected(String endpoint) {
        rejectedCalls.incrementAndGet();
        getOrCreateEndpointMetrics(endpoint).recordRejected();
    }

    /**
     * Record a rate limit violation (429 from API)
     */
    public void recordRateLimitHit() {
        rateLimitHits.incrementAndGet();
        violationsThisHour.incrementAndGet();
        maybeResetHourWindow();
        log.warn("Rate limit hit! Total hits: {}, This hour: {}",
                rateLimitHits.get(), violationsThisHour.get());
    }

    /**
     * Update available tokens
     *
     * @param tokens Current available tokens
     */
    public void updateAvailableTokens(long tokens) {
        availableTokens.set(tokens);
    }

    /**
     * Update queue size
     *
     * @param size Current queue size
     */
    public void updateQueueSize(int size) {
        queueSize.set(size);
    }

    /**
     * Update from API response rate limit headers
     *
     * @param headers The parsed rate limit headers
     */
    public void updateFromHeaders(RateLimitHeaders headers) {
        this.lastHeaders = headers;
        if (headers != null) {
            log.debug("Rate limit headers - Limit: {}, Remaining: {}, Reset: {}",
                    headers.getLimit(), headers.getRemaining(), headers.getResetTime());
        }
    }

    /**
     * Get average rate (calls per minute)
     */
    public double getAverageRate() {
        long total = totalCalls.get();
        if (total == 0) return 0;
        long minutes = ChronoUnit.MINUTES.between(lastMinuteReset.minusSeconds(60), Instant.now());
        return minutes > 0 ? (double) total / minutes : total;
    }

    /**
     * Get rate limit usage percentage
     *
     * @param bucketCapacity The bucket capacity
     * @return Usage percentage (0-100)
     */
    public double getUsagePercent(int bucketCapacity) {
        return 100.0 - (100.0 * availableTokens.get() / bucketCapacity);
    }

    /**
     * Check if we should trigger alert (low tokens)
     *
     * @param alertThreshold Alert threshold in tokens
     * @return true if alert should be triggered
     */
    public boolean shouldAlert(int alertThreshold) {
        return availableTokens.get() <= alertThreshold;
    }

    /**
     * Get violations this hour for permanent reduction logic
     */
    public int getViolationsThisHour() {
        maybeResetHourWindow();
        return violationsThisHour.get();
    }

    /**
     * Get snapshot of current metrics
     */
    public MetricsSnapshot getSnapshot() {
        return new MetricsSnapshot(
                totalCalls.get(),
                rateLimitedCalls.get(),
                rejectedCalls.get(),
                rateLimitHits.get(),
                availableTokens.get(),
                queueSize.get(),
                peakRate.get(),
                getAverageRate(),
                lastHeaders
        );
    }

    /**
     * Reset all metrics
     */
    public void reset() {
        totalCalls.set(0);
        rateLimitedCalls.set(0);
        rejectedCalls.set(0);
        rateLimitHits.set(0);
        queueSize.set(0);
        peakRate.set(0);
        callsThisMinute.set(0);
        violationsThisHour.set(0);
        endpointMetrics.clear();
        lastMinuteReset = Instant.now();
        lastHourReset = Instant.now();
    }

    private EndpointMetrics getOrCreateEndpointMetrics(String endpoint) {
        return endpointMetrics.computeIfAbsent(endpoint, k -> new EndpointMetrics());
    }

    private void maybeResetMinuteWindow() {
        if (ChronoUnit.MINUTES.between(lastMinuteReset, Instant.now()) >= 1) {
            callsThisMinute.set(0);
            lastMinuteReset = Instant.now();
        }
    }

    private void maybeResetHourWindow() {
        if (ChronoUnit.HOURS.between(lastHourReset, Instant.now()) >= 1) {
            violationsThisHour.set(0);
            lastHourReset = Instant.now();
        }
    }

    private void updatePeakRate() {
        int current = callsThisMinute.get();
        peakRate.updateAndGet(peak -> Math.max(peak, current));
    }

    /**
     * Endpoint-specific metrics
     */
    @Data
    public static class EndpointMetrics {
        private final AtomicLong calls = new AtomicLong(0);
        private final AtomicLong rateLimited = new AtomicLong(0);
        private final AtomicLong rejected = new AtomicLong(0);

        public void recordCall() {
            calls.incrementAndGet();
        }

        public void recordRateLimited() {
            rateLimited.incrementAndGet();
        }

        public void recordRejected() {
            rejected.incrementAndGet();
        }
    }

    /**
     * Rate limit headers from API response
     */
    @Data
    public static class RateLimitHeaders {
        private final int limit;
        private final int remaining;
        private final Instant resetTime;

        public RateLimitHeaders(int limit, int remaining, long resetTimestamp) {
            this.limit = limit;
            this.remaining = remaining;
            this.resetTime = Instant.ofEpochSecond(resetTimestamp);
        }

        /**
         * Get seconds until rate limit resets
         */
        public long getSecondsUntilReset() {
            return ChronoUnit.SECONDS.between(Instant.now(), resetTime);
        }
    }

    /**
     * Metrics snapshot for reporting
     */
    public record MetricsSnapshot(
            long totalCalls,
            long rateLimitedCalls,
            long rejectedCalls,
            int rateLimitHits,
            long availableTokens,
            int queueSize,
            int peakRate,
            double averageRate,
            RateLimitHeaders lastHeaders
    ) {}
}
