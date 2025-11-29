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
