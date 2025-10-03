package com.ffl.playoffs.domain.port;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

/**
 * Port interface for NFL data integration.
 * No framework dependencies - pure domain interface.
 */
public interface NflDataProvider {
    
    /**
     * Get team statistics for a specific team and week.
     */
    Map<String, Object> getTeamStats(String teamCode, int nflWeek, int season);
    
    /**
     * Get all NFL teams playing in a specific week.
     */
    List<String> getTeamsPlayingInWeek(int nflWeek, int season);
    
    /**
     * Check if a team code is valid.
     */
    boolean isValidTeamCode(String teamCode);
    
    /**
     * Get the current NFL week based on the date.
     */
    int getCurrentNflWeek(LocalDate date);
}
