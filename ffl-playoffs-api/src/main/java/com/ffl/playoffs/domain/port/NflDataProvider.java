package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.Score;

import java.util.List;

/**
 * Port (interface) for NFL data integration.
 * This defines the contract for fetching NFL game data and scores.
 */
public interface NflDataProvider {
    Score getTeamScore(String nflTeam, Integer weekNumber);
    List<String> getPlayoffTeams(Integer year);
    List<String> getAvailableTeamsForWeek(Integer weekNumber);
    boolean isTeamInPlayoffs(String nflTeam, Integer year);
}
