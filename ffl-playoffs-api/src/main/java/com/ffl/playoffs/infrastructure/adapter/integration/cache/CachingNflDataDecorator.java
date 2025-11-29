package com.ffl.playoffs.infrastructure.adapter.integration.cache;

import com.ffl.playoffs.domain.model.NFLPlayer;
import com.ffl.playoffs.domain.model.PlayerStats;
import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.port.NflDataProvider;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Component;

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
    @Cacheable(value = "playoff-teams", key = "#season")
    public List<String> getPlayoffTeams(int season) {
        log.debug("Cache miss for playoff teams: {}", season);
        return delegate.getPlayoffTeams(season);
    }

    @Override
    @Cacheable(value = "team-player-stats", key = "#teamAbbreviation + '-' + #week + '-' + #season")
    public java.util.Map<String, Object> getTeamPlayerStats(String teamAbbreviation, int week, int season) {
        log.debug("Cache miss for team player stats: {} week {} season {}", teamAbbreviation, week, season);
        return delegate.getTeamPlayerStats(teamAbbreviation, week, season);
    }

    @Override
    @Cacheable(value = "week-schedule", key = "#week + '-' + #season")
    public List<java.util.Map<String, Object>> getWeekSchedule(int week, int season) {
        log.debug("Cache miss for week schedule: week {} season {}", week, season);
        return delegate.getWeekSchedule(week, season);
    }

    @Override
    @Cacheable(value = "team-playing", key = "#teamAbbreviation + '-' + #week + '-' + #season")
    public boolean isTeamPlaying(String teamAbbreviation, int week, int season) {
        log.debug("Cache miss for team playing: {} week {} season {}", teamAbbreviation, week, season);
        return delegate.isTeamPlaying(teamAbbreviation, week, season);
    }

    // NOTE: The following methods were removed because they don't exist in the current NflDataProvider interface:
    // - getTeamScore
    // - getAvailableTeamsForWeek
    // - isTeamInPlayoffs
    // - getPlayerById
    // - getPlayerWeeklyStats
    // - getWeeklyStats
    // - getPlayerNews
    // - getPlayerInjuryStatus
}
