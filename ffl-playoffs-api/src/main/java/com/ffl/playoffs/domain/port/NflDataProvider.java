package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.service.ScoringService.TeamGameStats;

import java.util.List;

/**
 * Port interface for NFL data integration
 * Domain defines the contract, infrastructure implements it
 * No framework dependencies in this interface
 */
public interface NflDataProvider {

    /**
     * Get game statistics for a specific team in a specific week
     */
    TeamGameStats getTeamGameStats(String teamCode, Integer week, Integer season);

    /**
     * Get list of teams still in playoffs for a given week
     */
    List<String> getPlayoffTeams(Integer week, Integer season);

    /**
     * Check if a team won their game in a specific week
     */
    boolean didTeamWin(String teamCode, Integer week, Integer season);

    /**
     * Get current NFL season year
     */
    Integer getCurrentSeason();

    /**
     * Get current NFL week number
     */
    Integer getCurrentWeek();

    /**
     * Get team name from team code
     */
    String getTeamName(String teamCode);
}
