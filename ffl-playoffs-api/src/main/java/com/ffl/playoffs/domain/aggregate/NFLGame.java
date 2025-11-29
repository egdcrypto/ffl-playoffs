package com.ffl.playoffs.domain.aggregate;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * NFLGame Entity
 * Represents an actual NFL game with schedule and results
 * Used to sync game data and determine when rosters lock
 * Domain model with no framework dependencies
 */
public class NFLGame {
    private UUID id;
    private String externalGameId;    // External API game ID (ESPN, Yahoo, etc.)
    private Integer week;              // NFL week number (1-18 regular season, 19-22 playoffs)
    private Integer season;            // NFL season year
    private String homeTeam;           // Home team abbreviation (e.g., "KC")
    private String awayTeam;           // Away team abbreviation (e.g., "SF")
    private LocalDateTime gameTime;    // Scheduled game start time
    private String venue;              // Stadium name
    private String gameStatus;         // SCHEDULED, IN_PROGRESS, FINAL, POSTPONED, CANCELLED
    private Integer homeScore;         // Final or current home team score
    private Integer awayScore;         // Final or current away team score
    private String quarter;            // Q1, Q2, Q3, Q4, OT, FINAL
    private String timeRemaining;      // Time remaining in current quarter
    private LocalDateTime actualStartTime;  // Actual kickoff time (may differ from scheduled)
    private LocalDateTime completedAt; // When game finished
    private String weather;            // Weather conditions
    private Integer temperature;       // Temperature in Fahrenheit
    private String broadcastNetwork;   // TV network (CBS, FOX, NBC, ESPN, etc.)
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime syncedAt;    // When game data was last synced

    // Constructors
    public NFLGame() {
        this.id = UUID.randomUUID();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        this.gameStatus = "SCHEDULED";
    }

    public NFLGame(Integer week, Integer season, String homeTeam, String awayTeam, LocalDateTime gameTime) {
        this();
        this.week = week;
        this.season = season;
        this.homeTeam = homeTeam;
        this.awayTeam = awayTeam;
        this.gameTime = gameTime;
    }

    // Business Logic

    /**
     * Checks if the game has started
     * @param currentTime current time to check against
     * @return true if game has started, false otherwise
     */
    public boolean hasStarted(LocalDateTime currentTime) {
        if ("IN_PROGRESS".equals(gameStatus) || "FINAL".equals(gameStatus)) {
            return true;
        }
        return gameTime != null && currentTime.isAfter(gameTime);
    }

    /**
     * Checks if the game is in progress
     * @return true if game is currently being played
     */
    public boolean isInProgress() {
        return "IN_PROGRESS".equalsIgnoreCase(gameStatus);
    }

    /**
     * Checks if the game is final/completed
     * @return true if game is finished
     */
    public boolean isFinal() {
        return "FINAL".equalsIgnoreCase(gameStatus);
    }

    /**
     * Checks if the game is scheduled (not yet started)
     * @return true if game is scheduled
     */
    public boolean isScheduled() {
        return "SCHEDULED".equalsIgnoreCase(gameStatus);
    }

    /**
     * Starts the game (marks as in progress)
     */
    public void startGame() {
        if (!"SCHEDULED".equals(gameStatus)) {
            throw new IllegalStateException("Can only start scheduled games");
        }
        this.gameStatus = "IN_PROGRESS";
        this.actualStartTime = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Completes the game with final scores
     * @param finalHomeScore final home team score
     * @param finalAwayScore final away team score
     */
    public void completeGame(Integer finalHomeScore, Integer finalAwayScore) {
        if (!"IN_PROGRESS".equals(gameStatus)) {
            throw new IllegalStateException("Can only complete games that are in progress");
        }
        this.gameStatus = "FINAL";
        this.homeScore = finalHomeScore;
        this.awayScore = finalAwayScore;
        this.quarter = "FINAL";
        this.completedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Updates game score during the game
     * @param currentHomeScore current home score
     * @param currentAwayScore current away score
     * @param currentQuarter current quarter
     * @param timeLeft time remaining in quarter
     */
    public void updateScore(Integer currentHomeScore, Integer currentAwayScore,
                           String currentQuarter, String timeLeft) {
        if (!"IN_PROGRESS".equals(gameStatus)) {
            this.gameStatus = "IN_PROGRESS";
        }
        this.homeScore = currentHomeScore;
        this.awayScore = currentAwayScore;
        this.quarter = currentQuarter;
        this.timeRemaining = timeLeft;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Postpones the game
     * @param newGameTime new scheduled time
     */
    public void postpone(LocalDateTime newGameTime) {
        this.gameStatus = "POSTPONED";
        this.gameTime = newGameTime;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Cancels the game
     */
    public void cancel() {
        this.gameStatus = "CANCELLED";
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Marks game data as synced from external source
     */
    public void markSynced() {
        this.syncedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Gets the winning team abbreviation
     * @return winning team abbreviation, or null if tie or not final
     */
    public String getWinner() {
        if (!isFinal() || homeScore == null || awayScore == null) {
            return null;
        }
        if (homeScore > awayScore) {
            return homeTeam;
        } else if (awayScore > homeScore) {
            return awayTeam;
        }
        return null;  // Tie (rare in NFL)
    }

    /**
     * Gets the losing team abbreviation
     * @return losing team abbreviation, or null if tie or not final
     */
    public String getLoser() {
        if (!isFinal() || homeScore == null || awayScore == null) {
            return null;
        }
        if (homeScore < awayScore) {
            return homeTeam;
        } else if (awayScore < homeScore) {
            return awayTeam;
        }
        return null;  // Tie
    }

    /**
     * Checks if this is a playoff game
     * @return true if week is 19 or later (playoff weeks)
     */
    public boolean isPlayoffGame() {
        return week != null && week >= 19;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getExternalGameId() {
        return externalGameId;
    }

    public void setExternalGameId(String externalGameId) {
        this.externalGameId = externalGameId;
    }

    public Integer getWeek() {
        return week;
    }

    public void setWeek(Integer week) {
        this.week = week;
    }

    public Integer getSeason() {
        return season;
    }

    public void setSeason(Integer season) {
        this.season = season;
    }

    public String getHomeTeam() {
        return homeTeam;
    }

    public void setHomeTeam(String homeTeam) {
        this.homeTeam = homeTeam;
    }

    public String getAwayTeam() {
        return awayTeam;
    }

    public void setAwayTeam(String awayTeam) {
        this.awayTeam = awayTeam;
    }

    public LocalDateTime getGameTime() {
        return gameTime;
    }

    public void setGameTime(LocalDateTime gameTime) {
        this.gameTime = gameTime;
        this.updatedAt = LocalDateTime.now();
    }

    public String getVenue() {
        return venue;
    }

    public void setVenue(String venue) {
        this.venue = venue;
    }

    public String getGameStatus() {
        return gameStatus;
    }

    public void setGameStatus(String gameStatus) {
        this.gameStatus = gameStatus;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getHomeScore() {
        return homeScore;
    }

    public void setHomeScore(Integer homeScore) {
        this.homeScore = homeScore;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getAwayScore() {
        return awayScore;
    }

    public void setAwayScore(Integer awayScore) {
        this.awayScore = awayScore;
        this.updatedAt = LocalDateTime.now();
    }

    public String getQuarter() {
        return quarter;
    }

    public void setQuarter(String quarter) {
        this.quarter = quarter;
    }

    public String getTimeRemaining() {
        return timeRemaining;
    }

    public void setTimeRemaining(String timeRemaining) {
        this.timeRemaining = timeRemaining;
    }

    public LocalDateTime getActualStartTime() {
        return actualStartTime;
    }

    public void setActualStartTime(LocalDateTime actualStartTime) {
        this.actualStartTime = actualStartTime;
    }

    public LocalDateTime getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(LocalDateTime completedAt) {
        this.completedAt = completedAt;
    }

    public String getWeather() {
        return weather;
    }

    public void setWeather(String weather) {
        this.weather = weather;
    }

    public Integer getTemperature() {
        return temperature;
    }

    public void setTemperature(Integer temperature) {
        this.temperature = temperature;
    }

    public String getBroadcastNetwork() {
        return broadcastNetwork;
    }

    public void setBroadcastNetwork(String broadcastNetwork) {
        this.broadcastNetwork = broadcastNetwork;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalDateTime getSyncedAt() {
        return syncedAt;
    }

    public void setSyncedAt(LocalDateTime syncedAt) {
        this.syncedAt = syncedAt;
    }
}
