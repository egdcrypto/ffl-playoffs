package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Game entity - represents an FFL playoffs game
 * Domain model with no framework dependencies
 */
public class Game {
    private UUID id;
    private String name;
    private String code;
    private UUID creatorId;
    private GameStatus status;
    private Integer startingWeek;
    private Integer currentWeek;
    private Integer numberOfWeeks;
    private String eliminationMode;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime configurationLockedAt;
    private String lockReason;
    private LocalDateTime firstGameStartTime;
    private List<Player> players;
    private ScoringRules scoringRules;

    public Game() {
        this.id = UUID.randomUUID();
        this.players = new ArrayList<>();
        this.status = GameStatus.CREATED;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Game(String name, String code, UUID creatorId, Integer startingWeek) {
        this();
        this.name = name;
        this.code = code;
        this.creatorId = creatorId;
        this.startingWeek = startingWeek;
        this.currentWeek = startingWeek;
    }

    // Business methods
    public void addPlayer(Player player) {
        if (this.status != GameStatus.CREATED && this.status != GameStatus.WAITING_FOR_PLAYERS) {
            throw new IllegalStateException("Cannot add players to a game that has started");
        }
        this.players.add(player);
        this.updatedAt = LocalDateTime.now();
    }

    public void start() {
        if (this.status != GameStatus.WAITING_FOR_PLAYERS && this.status != GameStatus.CREATED) {
            throw new IllegalStateException("Game cannot be started in current status: " + this.status);
        }
        if (this.players.size() < 2) {
            throw new IllegalStateException("Game requires at least 2 players to start");
        }
        this.status = GameStatus.IN_PROGRESS;
        this.updatedAt = LocalDateTime.now();
    }

    public void advanceWeek() {
        if (this.status != GameStatus.IN_PROGRESS) {
            throw new IllegalStateException("Can only advance week for games in progress");
        }
        this.currentWeek++;
        this.updatedAt = LocalDateTime.now();
    }

    public void complete() {
        if (this.status != GameStatus.IN_PROGRESS) {
            throw new IllegalStateException("Can only complete games that are in progress");
        }
        this.status = GameStatus.COMPLETED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Checks if the configuration is locked based on first game start time.
     * Configuration becomes immutable once the first NFL game of the starting week begins.
     *
     * @param currentTime The current time to check against
     * @return true if configuration is locked, false otherwise
     */
    public boolean isConfigurationLocked(LocalDateTime currentTime) {
        if (this.configurationLockedAt != null) {
            return true;
        }

        if (this.firstGameStartTime != null && currentTime.isAfter(firstGameStartTime)) {
            return true;
        }

        return false;
    }

    /**
     * Locks the configuration permanently.
     * Should be called when the first game of the starting NFL week begins.
     *
     * @param lockTime The time when the configuration is being locked
     * @param reason The reason for locking (e.g., "FIRST_GAME_STARTED")
     */
    public void lockConfiguration(LocalDateTime lockTime, String reason) {
        if (this.configurationLockedAt == null) {
            this.configurationLockedAt = lockTime;
            this.lockReason = reason;
            this.updatedAt = LocalDateTime.now();
        }
    }

    /**
     * Validates that configuration can be modified.
     * Throws exception if configuration is locked.
     *
     * @param currentTime The current time to check against
     * @throws ConfigurationLockedException if configuration is locked
     */
    public void validateConfigurationMutable(LocalDateTime currentTime) {
        if (isConfigurationLocked(currentTime)) {
            throw new ConfigurationLockedException(
                "Configuration cannot be modified after the first game has started. " +
                "Locked at: " + this.configurationLockedAt + ". Reason: " + this.lockReason
            );
        }
    }

    /**
     * Sets the first game start time for the starting NFL week.
     * This is used to determine when configuration becomes immutable.
     *
     * @param firstGameStartTime The start time of the first NFL game
     */
    public void setFirstGameStartTime(LocalDateTime firstGameStartTime) {
        this.firstGameStartTime = firstGameStartTime;
    }

    public LocalDateTime getFirstGameStartTime() {
        return firstGameStartTime;
    }

    public LocalDateTime getConfigurationLockedAt() {
        return configurationLockedAt;
    }

    public String getLockReason() {
        return lockReason;
    }

    /**
     * Custom exception for configuration lock violations
     */
    public static class ConfigurationLockedException extends RuntimeException {
        public ConfigurationLockedException(String message) {
            super(message);
        }
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name, LocalDateTime currentTime) {
        validateConfigurationMutable(currentTime);
        this.name = name;
        this.updatedAt = LocalDateTime.now();
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public UUID getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(UUID creatorId) {
        this.creatorId = creatorId;
    }

    public GameStatus getStatus() {
        return status;
    }

    public void setStatus(GameStatus status) {
        this.status = status;
    }

    public Integer getStartingWeek() {
        return startingWeek;
    }

    public void setStartingWeek(Integer startingWeek, LocalDateTime currentTime) {
        validateConfigurationMutable(currentTime);
        this.startingWeek = startingWeek;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getCurrentWeek() {
        return currentWeek;
    }

    public void setCurrentWeek(Integer currentWeek) {
        this.currentWeek = currentWeek;
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

    public List<Player> getPlayers() {
        return players;
    }

    public void setPlayers(List<Player> players) {
        this.players = players;
    }

    public ScoringRules getScoringRules() {
        return scoringRules;
    }

    public void setScoringRules(ScoringRules scoringRules, LocalDateTime currentTime) {
        validateConfigurationMutable(currentTime);
        this.scoringRules = scoringRules;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getNumberOfWeeks() {
        return numberOfWeeks;
    }

    public void setNumberOfWeeks(Integer numberOfWeeks, LocalDateTime currentTime) {
        validateConfigurationMutable(currentTime);
        this.numberOfWeeks = numberOfWeeks;
        this.updatedAt = LocalDateTime.now();
    }

    public String getEliminationMode() {
        return eliminationMode;
    }

    public void setEliminationMode(String eliminationMode, LocalDateTime currentTime) {
        validateConfigurationMutable(currentTime);
        this.eliminationMode = eliminationMode;
        this.updatedAt = LocalDateTime.now();
    }

    public enum GameStatus {
        CREATED,
        WAITING_FOR_PLAYERS,
        IN_PROGRESS,
        COMPLETED,
        CANCELLED
    }
}
