package com.ffl.playoffs.infrastructure.adapter.integration.ratelimit;

import com.ffl.playoffs.domain.port.NflDataProvider;
import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.ConsumptionProbe;
import io.github.bucket4j.Refill;
import lombok.Getter;
import lombok.extern.slf4j.Slf4j;

import java.time.Duration;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicLong;

/**
 * Rate Limiting Decorator for NflDataProvider.
 * Implements token bucket algorithm using Bucket4j with configurable limits.
 *
 * Features:
 * - Configurable token bucket capacity and refill rate
 * - Metrics tracking for monitoring and alerting
 * - Adaptive rate limiting (backoff on 429 responses)
 * - Rate limit header parsing
 * - Graceful degradation when approaching limits
 *
 * Hexagonal Architecture: Infrastructure layer decorator
 */
@Slf4j
public class RateLimitingNflDataDecorator implements NflDataProvider {

    private final NflDataProvider delegate;
    private final RateLimitConfig config;

    @Getter
    private final RateLimitMetrics metrics;

    private volatile Bucket bucket;

    /**
     * Current effective rate limit (may be reduced after violations)
     */
    private final AtomicInteger effectiveLimit;

    /**
     * Backoff state
     */
    private volatile Instant backoffUntil = Instant.MIN;
    private final AtomicLong currentBackoffMs = new AtomicLong(0);

    /**
     * Constructor with delegate and configuration
     *
     * @param delegate The NflDataProvider to decorate
     * @param config Rate limit configuration
     */
    public RateLimitingNflDataDecorator(NflDataProvider delegate, RateLimitConfig config) {
        this.delegate = delegate;
        this.config = config;
        this.metrics = new RateLimitMetrics();
        this.effectiveLimit = new AtomicInteger(config.getEffectiveBucketCapacity());

        initializeBucket();

        log.info("RateLimitingNflDataDecorator initialized - capacity: {}, refill: {} tokens/{} sec, tier: {}",
                config.getEffectiveBucketCapacity(),
                config.getRefillTokens(),
                config.getRefillPeriodSeconds(),
                config.getTier().getCurrent());
    }

    /**
     * Constructor with delegate only (uses default configuration)
     *
     * @param delegate The NflDataProvider to decorate
     */
    public RateLimitingNflDataDecorator(NflDataProvider delegate) {
        this(delegate, new RateLimitConfig());
    }

    /**
     * Initialize or reinitialize the token bucket with current settings
     */
    private void initializeBucket() {
        int capacity = effectiveLimit.get();
        int refillTokens = Math.min(config.getRefillTokens(), capacity);

        Bandwidth limit = Bandwidth.classic(
                capacity,
                Refill.intervally(refillTokens, Duration.ofSeconds(config.getRefillPeriodSeconds()))
        );

        this.bucket = Bucket.builder()
                .addLimit(limit)
                .build();

        log.debug("Token bucket initialized: capacity={}, refill={} per {} seconds",
                capacity, refillTokens, config.getRefillPeriodSeconds());
    }

    @Override
    public List<String> getPlayoffTeams(int season) {
        acquireToken("getPlayoffTeams");
        return delegate.getPlayoffTeams(season);
    }

    @Override
    public Map<String, Object> getTeamPlayerStats(String teamAbbreviation, int week, int season) {
        acquireToken("getTeamPlayerStats");
        return delegate.getTeamPlayerStats(teamAbbreviation, week, season);
    }

    @Override
    public List<Map<String, Object>> getWeekSchedule(int week, int season) {
        acquireToken("getWeekSchedule");
        return delegate.getWeekSchedule(week, season);
    }

    @Override
    public boolean isTeamPlaying(String teamAbbreviation, int week, int season) {
        acquireToken("isTeamPlaying");
        return delegate.isTeamPlaying(teamAbbreviation, week, season);
    }

    /**
     * Acquire a token from the bucket, blocking if necessary.
     * Tracks metrics and handles backoff state.
     *
     * @param methodName Method name for logging and metrics
     * @throws RateLimitException if rate limit wait is interrupted
     */
    private void acquireToken(String methodName) {
        if (!config.isEnabled()) {
            return;
        }

        // Check if we're in backoff period
        if (Instant.now().isBefore(backoffUntil)) {
            long waitMs = Duration.between(Instant.now(), backoffUntil).toMillis();
            log.warn("In backoff period, waiting {} ms before request: {}", waitMs, methodName);
            try {
                Thread.sleep(waitMs);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                throw new RateLimitException("Backoff wait interrupted", e);
            }
        }

        metrics.recordCall(methodName);

        // Check for alert threshold before consuming
        if (metrics.shouldAlert(config.getAlertThresholdTokens())) {
            log.warn("Rate limit alert: only {} tokens remaining (threshold: {})",
                    bucket.getAvailableTokens(), config.getAlertThresholdTokens());
        }

        // Try to consume a token
        ConsumptionProbe probe = bucket.tryConsumeAndReturnRemaining(1);

        if (probe.isConsumed()) {
            updateMetrics(); // Update metrics after consumption
            log.debug("Token consumed for {}, {} tokens remaining", methodName, probe.getRemainingTokens());
            return;
        }

        // Rate limited - need to wait
        metrics.recordRateLimited(methodName);
        long waitNanos = probe.getNanosToWaitForRefill();
        long waitMs = waitNanos / 1_000_000;

        log.warn("Rate limit reached for {}, waiting {} ms for token refill", methodName, waitMs);

        try {
            bucket.asBlocking().consume(1);
            updateMetrics(); // Update metrics after consumption
            log.debug("Rate limit resolved, proceeding with {}", methodName);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RateLimitException("Rate limit wait interrupted for " + methodName, e);
        }
    }

    /**
     * Handle a 429 Too Many Requests response from the API.
     * Triggers backoff and potential permanent rate reduction.
     */
    public void handleRateLimitResponse() {
        metrics.recordRateLimitHit();

        // Calculate backoff duration
        long backoffMs = calculateBackoff();
        backoffUntil = Instant.now().plusMillis(backoffMs);

        log.warn("API rate limit hit! Backing off for {} ms", backoffMs);

        // Check for permanent rate reduction
        if (metrics.getViolationsThisHour() >= config.getBackoff().getPermanentReductionThreshold()) {
            applyPermanentRateReduction();
        }
    }

    /**
     * Handle rate limit headers from API response.
     * Adjusts local rate limiter to match API state.
     *
     * @param limit X-RateLimit-Limit header value
     * @param remaining X-RateLimit-Remaining header value
     * @param resetTimestamp X-RateLimit-Reset header value (epoch seconds)
     */
    public void handleRateLimitHeaders(int limit, int remaining, long resetTimestamp) {
        RateLimitMetrics.RateLimitHeaders headers =
                new RateLimitMetrics.RateLimitHeaders(limit, remaining, resetTimestamp);
        metrics.updateFromHeaders(headers);

        // If remaining is very low, preemptively throttle
        if (remaining <= 3 && headers.getSecondsUntilReset() > 0) {
            long secondsUntilReset = headers.getSecondsUntilReset();
            double allowedRate = (double) remaining / secondsUntilReset;
            log.info("Low remaining limit ({}), throttling to {} req/sec until reset",
                    remaining, String.format("%.2f", allowedRate));
        }
    }

    /**
     * Calculate backoff duration using exponential backoff
     */
    private long calculateBackoff() {
        long currentMs = currentBackoffMs.get();
        long newBackoffMs;

        if (currentMs == 0) {
            newBackoffMs = config.getBackoff().getInitialBackoffMs();
        } else {
            newBackoffMs = (long) (currentMs * config.getBackoff().getMultiplier());
        }

        newBackoffMs = Math.min(newBackoffMs, config.getBackoff().getMaxBackoffMs());
        currentBackoffMs.set(newBackoffMs);

        return newBackoffMs;
    }

    /**
     * Apply permanent rate reduction after repeated violations
     */
    private void applyPermanentRateReduction() {
        int currentLimit = effectiveLimit.get();
        int reductionPercent = config.getBackoff().getPermanentReductionPercent();
        int newLimit = (int) (currentLimit * reductionPercent / 100.0);

        effectiveLimit.set(newLimit);

        log.warn("Applying permanent rate reduction! New limit: {} ({}% of {})",
                newLimit, reductionPercent, currentLimit);

        // Reinitialize bucket with new limit
        initializeBucket();
    }

    /**
     * Reset backoff state (e.g., after successful requests)
     */
    public void resetBackoff() {
        currentBackoffMs.set(0);
        backoffUntil = Instant.MIN;
    }

    /**
     * Update metrics with current bucket state
     */
    private void updateMetrics() {
        metrics.updateAvailableTokens(bucket.getAvailableTokens());
    }

    /**
     * Get current available tokens
     *
     * @return Number of available tokens
     */
    public long getAvailableTokens() {
        return bucket.getAvailableTokens();
    }

    /**
     * Get effective rate limit (may be reduced from violations)
     *
     * @return Current effective rate limit
     */
    public int getEffectiveLimit() {
        return effectiveLimit.get();
    }

    /**
     * Check if rate limiting is enabled
     *
     * @return true if rate limiting is enabled
     */
    public boolean isEnabled() {
        return config.isEnabled();
    }

    /**
     * Get metrics snapshot for monitoring
     *
     * @return Current metrics snapshot
     */
    public RateLimitMetrics.MetricsSnapshot getMetricsSnapshot() {
        return metrics.getSnapshot();
    }
}
