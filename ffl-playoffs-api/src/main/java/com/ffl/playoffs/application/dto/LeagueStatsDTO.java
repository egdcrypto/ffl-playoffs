package com.ffl.playoffs.application.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

import java.util.UUID;

/**
 * Data Transfer Object for League Statistics
 * Used for API communication to show aggregate league data
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LeagueStatsDTO {
    private UUID leagueId;
    private int totalPlayers;
    private int activePlayers;
    private int eliminatedPlayers;
    private double highestScore;
    private double lowestScore;
    private double averageScore;
    private String currentLeader;
    private double leaderScore;
    private int currentWeek;
    private int totalWeeks;
    private String mostSelectedTeam;
    private int mostSelectedTeamCount;
}
