package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * PlayerSelection Entity
 * Represents a league player's selection of an NFL player for a specific week
 * Enforces the rule that a league player cannot select the same NFL player twice
 * across different weeks within their own selections (but other players can select the same NFL player)
 * Domain model with no framework dependencies
 */
public class PlayerSelection {
    private UUID id;
    private UUID leaguePlayerId;  // The league player making the selection
    private Long nflPlayerId;     // The NFL player being selected
    private UUID gameId;          // The game this selection belongs to
    private Integer weekNumber;   // Which week this selection is for
    private LocalDateTime selectedAt;
    private LocalDateTime updatedAt;
    private LocalDateTime createdAt;
    private boolean locked;       // Locked when deadline passes
    private LocalDateTime lockedAt;

    // Denormalized fields for query optimization
    private String nflPlayerName;
    private Position nflPlayerPosition;
    private String nflTeam;

    // Scoring (populated after week completes)
    private Double weekScore;
    private Integer gamesPlayed;

    // Constructors
    public PlayerSelection() {
        this.id = UUID.randomUUID();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        this.locked = false;
    }

    public PlayerSelection(UUID leaguePlayerId, Long nflPlayerId, UUID gameId, Integer weekNumber) {
        this();
        this.leaguePlayerId = leaguePlayerId;
        this.nflPlayerId = nflPlayerId;
        this.gameId = gameId;
        this.weekNumber = weekNumber;
        this.selectedAt = LocalDateTime.now();
    }

    // Business Logic

    /**
     * Validates that this selection can be modified
     * @throws IllegalStateException if selection is locked
     */
    public void validateMutable() {
        if (this.locked) {
            throw new IllegalStateException(
                "Cannot modify selection - deadline has passed since " + this.lockedAt
            );
        }
    }

    /**
     * Updates the NFL player for this selection
     * @param newPlayerId the new player ID
     * @param playerName the player's name
     * @param position the player's position
     * @param team the player's team
     * @throws IllegalStateException if selection is locked
     */
    public void updatePlayer(Long newPlayerId, String playerName, Position position, String team) {
        validateMutable();
        this.nflPlayerId = newPlayerId;
        this.nflPlayerName = playerName;
        this.nflPlayerPosition = position;
        this.nflTeam = team;
        this.selectedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Locks this selection so it cannot be changed
     * Called when the week deadline passes
     */
    public void lock() {
        if (this.locked) {
            throw new IllegalStateException("Selection is already locked");
        }
        this.locked = true;
        this.lockedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Sets the score for this selection after the week completes
     */
    public void setScore(Double score, Integer gamesPlayed) {
        this.weekScore = score;
        this.gamesPlayed = gamesPlayed;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Gets display text for this selection
     */
    public String getDisplayText() {
        if (nflPlayerName != null && nflPlayerPosition != null) {
            return nflPlayerName + ", " + nflPlayerPosition.name();
        }
        return "No selection";
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getLeaguePlayerId() {
        return leaguePlayerId;
    }

    public void setLeaguePlayerId(UUID leaguePlayerId) {
        this.leaguePlayerId = leaguePlayerId;
    }

    public Long getNflPlayerId() {
        return nflPlayerId;
    }

    public void setNflPlayerId(Long nflPlayerId) {
        this.nflPlayerId = nflPlayerId;
        this.updatedAt = LocalDateTime.now();
    }

    public UUID getGameId() {
        return gameId;
    }

    public void setGameId(UUID gameId) {
        this.gameId = gameId;
    }

    public Integer getWeekNumber() {
        return weekNumber;
    }

    public void setWeekNumber(Integer weekNumber) {
        this.weekNumber = weekNumber;
    }

    public LocalDateTime getSelectedAt() {
        return selectedAt;
    }

    public void setSelectedAt(LocalDateTime selectedAt) {
        this.selectedAt = selectedAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isLocked() {
        return locked;
    }

    public void setLocked(boolean locked) {
        this.locked = locked;
    }

    public LocalDateTime getLockedAt() {
        return lockedAt;
    }

    public void setLockedAt(LocalDateTime lockedAt) {
        this.lockedAt = lockedAt;
    }

    public String getNflPlayerName() {
        return nflPlayerName;
    }

    public void setNflPlayerName(String nflPlayerName) {
        this.nflPlayerName = nflPlayerName;
    }

    public Position getNflPlayerPosition() {
        return nflPlayerPosition;
    }

    public void setNflPlayerPosition(Position nflPlayerPosition) {
        this.nflPlayerPosition = nflPlayerPosition;
    }

    public String getNflTeam() {
        return nflTeam;
    }

    public void setNflTeam(String nflTeam) {
        this.nflTeam = nflTeam;
    }

    public Double getWeekScore() {
        return weekScore;
    }

    public void setWeekScore(Double weekScore) {
        this.weekScore = weekScore;
    }

    public Integer getGamesPlayed() {
        return gamesPlayed;
    }

    public void setGamesPlayed(Integer gamesPlayed) {
        this.gamesPlayed = gamesPlayed;
    }

    @Override
    public String toString() {
        return String.format(
            "PlayerSelection{id=%s, leaguePlayerId=%s, player=%s, week=%d, score=%.1f}",
            id, leaguePlayerId, nflPlayerName, weekNumber, weekScore != null ? weekScore : 0.0
        );
    }
}
