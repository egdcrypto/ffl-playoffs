package com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio;

import com.ffl.playoffs.domain.model.NFLPlayer;
import com.ffl.playoffs.domain.model.PlayerStats;
import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.dto.*;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Primary;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

/**
 * SportsData.io Fantasy Sports API Adapter
 * Implements NflDataProvider port using SportsData.io Fantasy API
 *
 * Features:
 * - Real-time fantasy scoring (30-second updates during games)
 * - Pre-calculated fantasy points (PPR, Standard, Half-PPR)
 * - No league setup required - standalone player/game queries
 * - Live injury updates and player news
 *
 * Hexagonal Architecture: Infrastructure layer implementation of domain port
 */
@Component
@Primary
@Slf4j
public class SportsDataIoFantasyAdapter implements NflDataProvider {

    private final SportsDataIoFantasyClient client;
    private final SportsDataIoMapper mapper;

    public SportsDataIoFantasyAdapter(
            SportsDataIoFantasyClient client,
            SportsDataIoMapper mapper) {
        this.client = client;
        this.mapper = mapper;
    }

    @Override
    public Score getTeamScore(String nflTeam, Integer weekNumber) {
        // Note: This is a legacy method from the original stub implementation
        // SportsData.io Fantasy API focuses on player stats, not team scores
        // For full implementation, would need to aggregate player stats by team
        log.warn("getTeamScore is a legacy method - consider using player-level stats instead");

        // Stub implementation - return zero score
        return Score.builder()
                .id(UUID.randomUUID())
                .nflTeam(nflTeam)
                .weekNumber(weekNumber)
                .points(0)
                .breakdown(Score.ScoreBreakdown.builder()
                        .touchdowns(0)
                        .fieldGoals(0)
                        .safeties(0)
                        .extraPoints(0)
                        .twoPointConversions(0)
                        .build())
                .build();
    }

    @Override
    public List<String> getPlayoffTeams(Integer year) {
        // Note: SportsData.io Fantasy API doesn't have a dedicated playoff teams endpoint
        // This would typically be maintained as configuration or fetched from a different endpoint
        log.debug("Returning hardcoded playoff teams for year: {}", year);

        // 2024-2025 NFL Playoff teams (would need to be updated or fetched from API)
        return Arrays.asList(
                "KC", "BUF", "BAL", "HOU", "CLE", "MIA", "PIT",  // AFC
                "SF", "DAL", "DET", "TB", "PHI", "LAR", "GB"     // NFC
        );
    }

    @Override
    public List<String> getAvailableTeamsForWeek(Integer weekNumber) {
        // All NFL teams are "available" in this roster-based system
        // No elimination or team-selection restrictions
        return getPlayoffTeams(2025); // All teams available
    }

    @Override
    public boolean isTeamInPlayoffs(String nflTeam, Integer year) {
        return getPlayoffTeams(year).contains(nflTeam);
    }

    /**
     * Get NFL player by ID with fantasy points
     * Uses SportsData.io Fantasy API /Player endpoint
     *
     * @param nflPlayerId SportsData.io player ID
     * @return Optional containing NFLPlayer domain model
     */
    public Optional<NFLPlayer> getPlayerById(Long nflPlayerId) {
        try {
            log.debug("Fetching player by ID: {}", nflPlayerId);
            SportsDataIoPlayerResponse response = client.getPlayer(nflPlayerId);

            if (response == null) {
                log.warn("Player not found: {}", nflPlayerId);
                return Optional.empty();
            }

            NFLPlayer player = mapper.toDomainPlayer(response);
            return Optional.ofNullable(player);
        } catch (SportsDataIoRateLimitException e) {
            log.error("Rate limit exceeded fetching player: {}", nflPlayerId);
            throw e; // Re-throw to be handled by rate limiting decorator
        } catch (SportsDataIoApiException e) {
            log.error("API error fetching player {}: {}", nflPlayerId, e.getMessage());
            return Optional.empty();
        } catch (Exception e) {
            log.error("Unexpected error fetching player {}: {}", nflPlayerId, e.getMessage());
            return Optional.empty();
        }
    }

    /**
     * Get player's weekly stats with real-time fantasy points
     * Updates every 30 seconds during active games
     *
     * @param nflPlayerId SportsData.io player ID
     * @param week NFL week number (1-22)
     * @param season NFL season year
     * @return Optional containing PlayerStats domain model
     */
    public Optional<PlayerStats> getPlayerWeeklyStats(Long nflPlayerId, Integer week, Integer season) {
        try {
            log.debug("Fetching weekly stats for player {} - season {} week {}", nflPlayerId, season, week);
            SportsDataIoFantasyStatsResponse response = client.getPlayerWeeklyStats(nflPlayerId, season, week);

            if (response == null) {
                log.debug("No stats found for player {} week {}", nflPlayerId, week);
                return Optional.empty();
            }

            PlayerStats stats = mapper.toDomainPlayerStats(response);
            return Optional.ofNullable(stats);
        } catch (SportsDataIoRateLimitException e) {
            log.error("Rate limit exceeded fetching player stats: {} week {}", nflPlayerId, week);
            throw e;
        } catch (SportsDataIoApiException e) {
            log.error("API error fetching player stats {} week {}: {}", nflPlayerId, week, e.getMessage());
            return Optional.empty();
        } catch (Exception e) {
            log.error("Unexpected error fetching player stats {} week {}: {}", nflPlayerId, week, e.getMessage());
            return Optional.empty();
        }
    }

    /**
     * Get all weekly stats for a specific week (all players)
     * Real-time data with 30-second updates during games
     *
     * @param week NFL week number
     * @param season NFL season year
     * @return List of PlayerStats for all players in the week
     */
    public List<PlayerStats> getWeeklyStats(Integer week, Integer season) {
        try {
            log.debug("Fetching all weekly stats for season {} week {}", season, week);
            List<SportsDataIoFantasyStatsResponse> responses = client.getLiveFantasyStats(season, week);

            return responses.stream()
                    .map(mapper::toDomainPlayerStats)
                    .filter(Objects::nonNull)
                    .collect(Collectors.toList());
        } catch (SportsDataIoRateLimitException e) {
            log.error("Rate limit exceeded fetching weekly stats for season {} week {}", season, week);
            throw e;
        } catch (SportsDataIoApiException e) {
            log.error("API error fetching weekly stats season {} week {}: {}", season, week, e.getMessage());
            return Collections.emptyList();
        } catch (Exception e) {
            log.error("Unexpected error fetching weekly stats season {} week {}: {}", season, week, e.getMessage());
            return Collections.emptyList();
        }
    }

    /**
     * Get player news and injury updates
     * Real-time updates on injury status, depth chart changes, etc.
     *
     * @param nflPlayerId SportsData.io player ID
     * @return List of news items for the player
     */
    public List<String> getPlayerNews(Long nflPlayerId) {
        try {
            log.debug("Fetching player news for: {}", nflPlayerId);
            List<SportsDataIoPlayerNewsResponse> newsItems = client.getPlayerNewsById(nflPlayerId);

            return newsItems.stream()
                    .map(SportsDataIoPlayerNewsResponse::getTitle)
                    .filter(Objects::nonNull)
                    .collect(Collectors.toList());
        } catch (SportsDataIoRateLimitException e) {
            log.error("Rate limit exceeded fetching player news: {}", nflPlayerId);
            throw e;
        } catch (SportsDataIoApiException e) {
            log.error("API error fetching player news {}: {}", nflPlayerId, e.getMessage());
            return Collections.emptyList();
        } catch (Exception e) {
            log.error("Unexpected error fetching player news {}: {}", nflPlayerId, e.getMessage());
            return Collections.emptyList();
        }
    }

    /**
     * Get current player injury status
     *
     * @param nflPlayerId SportsData.io player ID
     * @return Injury status string (OUT, QUESTIONABLE, DOUBTFUL, HEALTHY, etc.)
     */
    public String getPlayerInjuryStatus(Long nflPlayerId) {
        try {
            // First try to get from player profile
            Optional<NFLPlayer> player = getPlayerById(nflPlayerId);
            if (player.isPresent() && player.get().getStatus() != null) {
                return player.get().getStatus();
            }

            // Fallback to news feed for latest injury updates
            List<SportsDataIoPlayerNewsResponse> newsItems = client.getPlayerNewsById(nflPlayerId);
            if (!newsItems.isEmpty()) {
                String injuryStatus = mapper.extractInjuryStatus(newsItems.get(0));
                return injuryStatus != null ? injuryStatus : "ACTIVE";
            }

            return "ACTIVE";
        } catch (Exception e) {
            log.error("Error fetching injury status for player {}: {}", nflPlayerId, e.getMessage());
            return "UNKNOWN";
        }
    }

    /**
     * Check if API is accessible (health check)
     *
     * @return true if API responds successfully
     */
    public boolean isApiHealthy() {
        return client.isApiAccessible();
    }
}
