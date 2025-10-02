package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.NFLPlayer;
import com.ffl.playoffs.domain.model.PlayerStats;
import com.ffl.playoffs.domain.model.Score;

import java.util.List;
import java.util.Optional;

/**
 * Port (interface) for NFL data integration.
 * This defines the contract for fetching NFL game data and scores.
 */
public interface NflDataProvider {
    Score getTeamScore(String nflTeam, Integer weekNumber);
    List<String> getPlayoffTeams(Integer year);
    List<String> getAvailableTeamsForWeek(Integer weekNumber);
    boolean isTeamInPlayoffs(String nflTeam, Integer year);

    // Player data methods for extended functionality
    Optional<NFLPlayer> getPlayerById(Long nflPlayerId);
    Optional<PlayerStats> getPlayerWeeklyStats(Long nflPlayerId, Integer week, Integer season);
    List<PlayerStats> getWeeklyStats(Integer week, Integer season);
    List<String> getPlayerNews(Long nflPlayerId);
    String getPlayerInjuryStatus(Long nflPlayerId);
}
