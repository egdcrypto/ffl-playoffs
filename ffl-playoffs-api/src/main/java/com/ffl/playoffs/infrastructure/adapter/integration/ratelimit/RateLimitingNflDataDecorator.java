package com.ffl.playoffs.infrastructure.adapter.integration.ratelimit;

import com.ffl.playoffs.domain.aggregate.NFLPlayer;
import com.ffl.playoffs.domain.model.PlayerStats;
import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.port.NflDataProvider;
import io.github.bucket4j.Bandwidth;
import io.github.bucket4j.Bucket;
import io.github.bucket4j.Refill;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.time.Duration;
import java.util.List;
import java.util.Optional;

/**
 * Rate Limiting Decorator for NflDataProvider
 * Implements token bucket algorithm using Bucket4j
 *
 * Rate Limits (SportsData.io):
 * - Free/Starter tier: 10 requests per second
 * - Conservative limit: 8 requests per second (80% of max)
 *
 * Hexagonal Architecture: Infrastructure layer decorator
 */
@Component("rateLimitingNflDataDecorator")
@Slf4j
public class RateLimitingNflDataDecorator implements NflDataProvider {

    private final NflDataProvider delegate;
    private final Bucket bucket;

    /**
     * Constructor with delegate NflDataProvider
     * Initializes token bucket with conservative rate limit
     *
     * @param delegate The NflDataProvider to decorate with rate limiting
     */
    public RateLimitingNflDataDecorator(NflDataProvider delegate) {
        this.delegate = delegate;

        // Token bucket: 8 tokens, refill 8 tokens per second
        // Conservative 80% of SportsData.io's 10 req/sec limit
        Bandwidth limit = Bandwidth.classic(8, Refill.intervally(8, Duration.ofSeconds(1)));
        this.bucket = Bucket.builder()
                .addLimit(limit)
                .build();

        log.info("RateLimitingNflDataDecorator initialized with 8 req/sec limit");
    }

    @Override
    public List<String> getPlayoffTeams(int season) {
        consumeToken("getPlayoffTeams");
        return delegate.getPlayoffTeams(season);
    }

    @Override
    public java.util.Map<String, Object> getTeamPlayerStats(String teamAbbreviation, int week, int season) {
        consumeToken("getTeamPlayerStats");
        return delegate.getTeamPlayerStats(teamAbbreviation, week, season);
    }

    @Override
    public List<java.util.Map<String, Object>> getWeekSchedule(int week, int season) {
        consumeToken("getWeekSchedule");
        return delegate.getWeekSchedule(week, season);
    }

    @Override
    public boolean isTeamPlaying(String teamAbbreviation, int week, int season) {
        consumeToken("isTeamPlaying");
        return delegate.isTeamPlaying(teamAbbreviation, week, season);
    }

    // NOTE: The following methods were removed because they don't exist in the current NflDataProvider interface:
    // - getTeamScore, getAvailableTeamsForWeek, isTeamInPlayoffs
    // - getPlayerById, getPlayerWeeklyStats, getWeeklyStats, getPlayerNews

    /**
     * Consume a token from the bucket
     * Blocks if no tokens available (rate limit exceeded)
     *
     * @param methodName Method name for logging
     */
    private void consumeToken(String methodName) {
        if (!bucket.tryConsume(1)) {
            log.warn("Rate limit exceeded for method: {}, blocking until token available", methodName);

            // Block until token becomes available
            try {
                bucket.asBlocking().consume(1);
                log.debug("Rate limit resolved, proceeding with {}", methodName);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                throw new RateLimitException("Rate limit wait interrupted", e);
            }
        }
    }

    /**
     * Get available tokens (for monitoring/debugging)
     *
     * @return Number of available tokens
     */
    public long getAvailableTokens() {
        return bucket.getAvailableTokens();
    }
}
