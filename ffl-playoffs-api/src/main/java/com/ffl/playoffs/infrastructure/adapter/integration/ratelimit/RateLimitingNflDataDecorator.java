package com.ffl.playoffs.infrastructure.adapter.integration.ratelimit;

import com.ffl.playoffs.domain.model.NFLPlayer;
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
    public Score getTeamScore(String nflTeam, Integer weekNumber) {
        consumeToken("getTeamScore");
        return delegate.getTeamScore(nflTeam, weekNumber);
    }

    @Override
    public List<String> getPlayoffTeams(Integer year) {
        consumeToken("getPlayoffTeams");
        return delegate.getPlayoffTeams(year);
    }

    @Override
    public List<String> getAvailableTeamsForWeek(Integer weekNumber) {
        consumeToken("getAvailableTeamsForWeek");
        return delegate.getAvailableTeamsForWeek(weekNumber);
    }

    @Override
    public boolean isTeamInPlayoffs(String nflTeam, Integer year) {
        consumeToken("isTeamInPlayoffs");
        return delegate.isTeamInPlayoffs(nflTeam, year);
    }

    /**
     * Get player by ID with rate limiting
     *
     * @param nflPlayerId Player ID
     * @return Optional NFLPlayer
     */
    public Optional<NFLPlayer> getPlayerById(Long nflPlayerId) {
        consumeToken("getPlayerById");

        try {
            Method method = delegate.getClass().getMethod("getPlayerById", Long.class);
            @SuppressWarnings("unchecked")
            Optional<NFLPlayer> result = (Optional<NFLPlayer>) method.invoke(delegate, nflPlayerId);
            return result;
        } catch (Exception e) {
            log.error("Error invoking getPlayerById on delegate: {}", e.getMessage());
            return Optional.empty();
        }
    }

    /**
     * Get player weekly stats with rate limiting
     *
     * @param nflPlayerId Player ID
     * @param week Week number
     * @param season Season year
     * @return Optional PlayerStats
     */
    public Optional<PlayerStats> getPlayerWeeklyStats(Long nflPlayerId, Integer week, Integer season) {
        consumeToken("getPlayerWeeklyStats");

        try {
            Method method = delegate.getClass().getMethod("getPlayerWeeklyStats", Long.class, Integer.class, Integer.class);
            @SuppressWarnings("unchecked")
            Optional<PlayerStats> result = (Optional<PlayerStats>) method.invoke(delegate, nflPlayerId, week, season);
            return result;
        } catch (Exception e) {
            log.error("Error invoking getPlayerWeeklyStats on delegate: {}", e.getMessage());
            return Optional.empty();
        }
    }

    /**
     * Get all weekly stats with rate limiting
     *
     * @param week Week number
     * @param season Season year
     * @return List of PlayerStats
     */
    public List<PlayerStats> getWeeklyStats(Integer week, Integer season) {
        consumeToken("getWeeklyStats");

        try {
            Method method = delegate.getClass().getMethod("getWeeklyStats", Integer.class, Integer.class);
            @SuppressWarnings("unchecked")
            List<PlayerStats> result = (List<PlayerStats>) method.invoke(delegate, week, season);
            return result;
        } catch (Exception e) {
            log.error("Error invoking getWeeklyStats on delegate: {}", e.getMessage());
            return List.of();
        }
    }

    /**
     * Get player news with rate limiting
     *
     * @param nflPlayerId Player ID
     * @return List of news headlines
     */
    public List<String> getPlayerNews(Long nflPlayerId) {
        consumeToken("getPlayerNews");

        try {
            Method method = delegate.getClass().getMethod("getPlayerNews", Long.class);
            @SuppressWarnings("unchecked")
            List<String> result = (List<String>) method.invoke(delegate, nflPlayerId);
            return result;
        } catch (Exception e) {
            log.error("Error invoking getPlayerNews on delegate: {}", e.getMessage());
            return List.of();
        }
    }

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
