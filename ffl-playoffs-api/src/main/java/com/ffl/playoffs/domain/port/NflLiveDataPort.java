package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.PlayerStats;
import com.ffl.playoffs.domain.model.nfl.NFLGameStatus;

import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.UUID;

/**
 * Port for fetching live NFL data from external sources
 * Infrastructure adapter will implement actual API calls
 */
public interface NflLiveDataPort {

    /**
     * Fetch current player statistics for all active games
     * @param week the NFL week number
     * @param season the NFL season year
     * @return list of current player stats
     */
    List<PlayerStats> fetchLivePlayerStats(int week, int season);

    /**
     * Fetch player statistics for a specific game
     * @param nflGameId the NFL game ID
     * @return list of player stats for that game
     */
    List<PlayerStats> fetchGamePlayerStats(UUID nflGameId);

    /**
     * Fetch statistics for specific NFL players
     * @param nflPlayerIds the list of NFL player IDs
     * @param week the NFL week number
     * @param season the NFL season year
     * @return map of playerId to stats
     */
    Map<Long, PlayerStats> fetchPlayerStats(List<Long> nflPlayerIds, int week, int season);

    /**
     * Get the current status of an NFL game
     * @param nflGameId the NFL game ID
     * @return the game status
     */
    Optional<NFLGameStatus> getGameStatus(UUID nflGameId);

    /**
     * Get current game statuses for all games in a week
     * @param week the NFL week number
     * @param season the NFL season year
     * @return map of gameId to status
     */
    Map<UUID, NFLGameStatus> getAllGameStatuses(int week, int season);

    /**
     * Get games that are currently in progress
     * @param week the NFL week number
     * @param season the NFL season year
     * @return list of in-progress game IDs
     */
    List<UUID> getGamesInProgress(int week, int season);

    /**
     * Get the current game clock/quarter info
     * @param nflGameId the NFL game ID
     * @return game clock info (e.g., "3Q 8:42")
     */
    Optional<String> getGameClock(UUID nflGameId);

    /**
     * Get the current score of an NFL game
     * @param nflGameId the NFL game ID
     * @return map with homeScore and awayScore
     */
    Optional<Map<String, Integer>> getGameScore(UUID nflGameId);

    /**
     * Check if the data source is available
     * @return true if data source is responding
     */
    boolean isAvailable();

    /**
     * Get the timestamp of the last successful data fetch
     * @return epoch millis of last fetch
     */
    long getLastFetchTimestamp();
}
