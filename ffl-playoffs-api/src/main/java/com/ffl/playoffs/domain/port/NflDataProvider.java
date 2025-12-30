package com.ffl.playoffs.domain.port;

import java.util.List;
import java.util.Map;

public interface NflDataProvider {
    /**
     * Get all NFL playoff teams for a given season
     */
    List<String> getPlayoffTeams(int season);

    /**
     * Get player statistics for a specific NFL team and week
     */
    Map<String, Object> getTeamPlayerStats(String teamAbbreviation, int week, int season);

    /**
     * Get game schedule for a specific week
     */
    List<Map<String, Object>> getWeekSchedule(int week, int season);

    /**
     * Check if a team is playing in a specific week
     */
    boolean isTeamPlaying(String teamAbbreviation, int week, int season);

    /**
     * Get individual player statistics for a specific week
     * @param playerId the NFL player ID
     * @param week the NFL week number
     * @return map of stat name to value
     */
    Map<String, Object> getPlayerStats(Long playerId, int week);

    /**
     * Get statistics for multiple players in a specific week
     * @param playerIds list of NFL player IDs
     * @param week the NFL week number
     * @return map of player ID to stats map
     */
    default Map<Long, Map<String, Object>> getPlayersStats(List<Long> playerIds, int week) {
        Map<Long, Map<String, Object>> result = new java.util.HashMap<>();
        for (Long playerId : playerIds) {
            result.put(playerId, getPlayerStats(playerId, week));
        }
        return result;
    }

    /**
     * Get the current NFL week number
     */
    default Integer getCurrentWeek() {
        return 15; // Default implementation for testing
    }

    /**
     * Get the current NFL season year
     */
    default Integer getCurrentSeason() {
        return 2025; // Default implementation for testing
    }

    /**
     * Get team name by abbreviation
     */
    default String getTeamName(String abbreviation) {
        return abbreviation; // Default implementation
    }
}
