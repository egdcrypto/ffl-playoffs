package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * TeamSelection entity - represents a player's team choice for a specific week
 * Domain model with no framework dependencies
 */
public class TeamSelection {
    private UUID id;
    private UUID playerId;
    private Integer week;
    private String nflTeamCode;
    private String nflTeamName;
    private SelectionStatus status;
    private LocalDateTime selectedAt;
    private Score score;

    public TeamSelection() {
        this.id = UUID.randomUUID();
        this.status = SelectionStatus.PENDING;
    }

    public TeamSelection(UUID playerId, Integer week, String nflTeamCode, String nflTeamName) {
        this();
        this.playerId = playerId;
        this.week = week;
        this.nflTeamCode = nflTeamCode;
        this.nflTeamName = nflTeamName;
        this.selectedAt = LocalDateTime.now();
    }

    // Business methods
    public void lockSelection() {
        if (this.status != SelectionStatus.PENDING) {
            throw new IllegalStateException("Can only lock pending selections");
        }
        this.status = SelectionStatus.LOCKED;
    }

    public void completeSelection(Score score) {
        if (this.status != SelectionStatus.LOCKED) {
            throw new IllegalStateException("Selection must be locked before completion");
        }
        this.score = score;
        this.status = SelectionStatus.COMPLETED;
    }

    public boolean isWinningSelection() {
        return this.score != null && this.score.isWin();
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getPlayerId() {
        return playerId;
    }

    public void setPlayerId(UUID playerId) {
        this.playerId = playerId;
    }

    public Integer getWeek() {
        return week;
    }

    public void setWeek(Integer week) {
        this.week = week;
    }

    public String getNflTeamCode() {
        return nflTeamCode;
    }

    public void setNflTeamCode(String nflTeamCode) {
        this.nflTeamCode = nflTeamCode;
    }

    public String getNflTeamName() {
        return nflTeamName;
    }

    public void setNflTeamName(String nflTeamName) {
        this.nflTeamName = nflTeamName;
    }

    public SelectionStatus getStatus() {
        return status;
    }

    public void setStatus(SelectionStatus status) {
        this.status = status;
    }

    public LocalDateTime getSelectedAt() {
        return selectedAt;
    }

    public void setSelectedAt(LocalDateTime selectedAt) {
        this.selectedAt = selectedAt;
    }

    public Score getScore() {
        return score;
    }

    public void setScore(Score score) {
        this.score = score;
    }

    public enum SelectionStatus {
        PENDING,
        LOCKED,
        COMPLETED
    }
}
