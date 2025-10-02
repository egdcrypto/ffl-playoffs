package com.ffl.playoffs.infrastructure.adapter.integration.cache;

import com.ffl.playoffs.domain.model.NFLPlayer;
import com.ffl.playoffs.domain.model.PlayerStats;
import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.port.NflDataProvider;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;
import java.util.List;
import java.util.Optional;

/**
 * Caching Decorator for NflDataProvider
 * Implements decorator pattern to add Redis caching layer
 *
 * Cache Strategy:
 * - Live stats: 30-second TTL (during games)
 * - Player profiles: 1-hour TTL
 * - Final stats: 7-day TTL (games over)
 * - Playoff teams: 24-hour TTL
 *
 * Uses Spring Cache abstraction with Redis backend
 * Hexagonal Architecture: Infrastructure layer decorator
 */
@Component("cachingNflDataDecorator")
@Slf4j
public class CachingNflDataDecorator implements NflDataProvider {

    private final NflDataProvider delegate;

    /**
     * Constructor with delegate NflDataProvider
     * Uses dependency injection - Spring will inject the actual adapter
     *
     * @param delegate The actual NflDataProvider implementation to decorate
     */
    public CachingNflDataDecorator(NflDataProvider delegate) {
        this.delegate = delegate;
        log.info("CachingNflDataDecorator initialized with delegate: {}", delegate.getClass().getSimpleName());
    }

    @Override
    @Cacheable(value = "team-scores", key = "#nflTeam + '-' + #weekNumber")
    public Score getTeamScore(String nflTeam, Integer weekNumber) {
        log.debug("Cache miss for team score: {} week {}", nflTeam, weekNumber);
        return delegate.getTeamScore(nflTeam, weekNumber);
    }

    @Override
    @Cacheable(value = "playoff-teams", key = "#year")
    public List<String> getPlayoffTeams(Integer year) {
        log.debug("Cache miss for playoff teams: {}", year);
        return delegate.getPlayoffTeams(year);
    }

    @Override
    @Cacheable(value = "available-teams", key = "#weekNumber")
    public List<String> getAvailableTeamsForWeek(Integer weekNumber) {
        log.debug("Cache miss for available teams: week {}", weekNumber);
        return delegate.getAvailableTeamsForWeek(weekNumber);
    }

    @Override
    @Cacheable(value = "team-in-playoffs", key = "#nflTeam + '-' + #year")
    public boolean isTeamInPlayoffs(String nflTeam, Integer year) {
        log.debug("Cache miss for team in playoffs: {} year {}", nflTeam, year);
        return delegate.isTeamInPlayoffs(nflTeam, year);
    }

    /**
     * Get player by ID with caching
     * Cache: 1-hour TTL for player profiles
     *
     * @param nflPlayerId Player ID
     * @return Optional NFLPlayer
     */
    @Cacheable(value = "nfl-players", key = "#nflPlayerId")
    public Optional<NFLPlayer> getPlayerById(Long nflPlayerId) {
        log.debug("Cache miss for player: {}", nflPlayerId);

        // Call delegate (reflection to handle extended methods not in port interface)
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
     * Get player weekly stats with caching
     * Cache: 30-second TTL for live stats (short TTL for real-time updates)
     *        7-day TTL for final stats (game over)
     *
     * Note: Actual TTL configuration in application.yml
     *
     * @param nflPlayerId Player ID
     * @param week Week number
     * @param season Season year
     * @return Optional PlayerStats
     */
    @Cacheable(value = "player-stats", key = "#nflPlayerId + '-' + #week + '-' + #season")
    public Optional<PlayerStats> getPlayerWeeklyStats(Long nflPlayerId, Integer week, Integer season) {
        log.debug("Cache miss for player stats: {} season {} week {}", nflPlayerId, season, week);

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
     * Get all weekly stats with caching
     * Cache: 30-second TTL for live data
     *
     * @param week Week number
     * @param season Season year
     * @return List of PlayerStats
     */
    @Cacheable(value = "weekly-stats", key = "#week + '-' + #season")
    public List<PlayerStats> getWeeklyStats(Integer week, Integer season) {
        log.debug("Cache miss for weekly stats: season {} week {}", season, week);

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
     * Get player news with caching
     * Cache: 5-minute TTL for news/injuries (moderate TTL for recent updates)
     *
     * @param nflPlayerId Player ID
     * @return List of news headlines
     */
    @Cacheable(value = "player-news", key = "#nflPlayerId")
    public List<String> getPlayerNews(Long nflPlayerId) {
        log.debug("Cache miss for player news: {}", nflPlayerId);

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
     * Get player injury status with caching
     * Cache: 5-minute TTL for injury status
     *
     * @param nflPlayerId Player ID
     * @return Injury status string
     */
    @Cacheable(value = "player-injury-status", key = "#nflPlayerId")
    public String getPlayerInjuryStatus(Long nflPlayerId) {
        log.debug("Cache miss for player injury status: {}", nflPlayerId);

        try {
            Method method = delegate.getClass().getMethod("getPlayerInjuryStatus", Long.class);
            String result = (String) method.invoke(delegate, nflPlayerId);
            return result;
        } catch (Exception e) {
            log.error("Error invoking getPlayerInjuryStatus on delegate: {}", e.getMessage());
            return "UNKNOWN";
        }
    }
}
