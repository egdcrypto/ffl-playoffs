package com.ffl.playoffs.infrastructure.adapter.integration.sportsdataio.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;

/**
 * SportsData.io Fantasy API Player Game Stats Response DTO
 * Maps to Fantasy Sports API /FantasyPlayerGameStatsByWeek endpoint
 * Real-time updates every 30 seconds during games
 */
@Data
public class SportsDataIoFantasyStatsResponse {

    @JsonProperty("PlayerID")
    private Long playerID;

    @JsonProperty("GameKey")
    private String gameKey;

    @JsonProperty("Season")
    private Integer season;

    @JsonProperty("Week")
    private Integer week;

    @JsonProperty("Name")
    private String name;

    @JsonProperty("Team")
    private String team;

    @JsonProperty("Position")
    private String position;

    // Passing Stats
    @JsonProperty("PassingYards")
    private Integer passingYards;

    @JsonProperty("PassingTouchdowns")
    private Integer passingTouchdowns;

    @JsonProperty("PassingInterceptions")
    private Integer passingInterceptions;

    @JsonProperty("PassingAttempts")
    private Integer passingAttempts;

    @JsonProperty("PassingCompletions")
    private Integer passingCompletions;

    // Rushing Stats
    @JsonProperty("RushingYards")
    private Integer rushingYards;

    @JsonProperty("RushingTouchdowns")
    private Integer rushingTouchdowns;

    @JsonProperty("RushingAttempts")
    private Integer rushingAttempts;

    // Receiving Stats
    @JsonProperty("Receptions")
    private Integer receptions;

    @JsonProperty("ReceivingYards")
    private Integer receivingYards;

    @JsonProperty("ReceivingTouchdowns")
    private Integer receivingTouchdowns;

    @JsonProperty("Targets")
    private Integer targets;

    // Other Offensive Stats
    @JsonProperty("TwoPointConversionPasses")
    private Integer twoPointConversionPasses;

    @JsonProperty("TwoPointConversionRuns")
    private Integer twoPointConversionRuns;

    @JsonProperty("TwoPointConversionReceptions")
    private Integer twoPointConversionReceptions;

    @JsonProperty("Fumbles")
    private Integer fumbles;

    @JsonProperty("FumblesLost")
    private Integer fumblesLost;

    // Kicking Stats
    @JsonProperty("FieldGoalsMade")
    private Integer fieldGoalsMade;

    @JsonProperty("FieldGoalsAttempted")
    private Integer fieldGoalsAttempted;

    @JsonProperty("FieldGoalsMade0to19")
    private Integer fieldGoalsMade0to19;

    @JsonProperty("FieldGoalsMade20to29")
    private Integer fieldGoalsMade20to29;

    @JsonProperty("FieldGoalsMade30to39")
    private Integer fieldGoalsMade30to39;

    @JsonProperty("FieldGoalsMade40to49")
    private Integer fieldGoalsMade40to49;

    @JsonProperty("FieldGoalsMade50Plus")
    private Integer fieldGoalsMade50Plus;

    @JsonProperty("ExtraPointsMade")
    private Integer extraPointsMade;

    @JsonProperty("ExtraPointsAttempted")
    private Integer extraPointsAttempted;

    // Fantasy Points
    @JsonProperty("FantasyPointsPPR")
    private Double fantasyPointsPPR;

    @JsonProperty("FantasyPointsStandard")
    private Double fantasyPointsStandard;

    @JsonProperty("FantasyPointsHalfPPR")
    private Double fantasyPointsHalfPPR;

    // Game Status
    @JsonProperty("IsGameOver")
    private Boolean isGameOver;

    @JsonProperty("GameStatus")
    private String gameStatus;
}
