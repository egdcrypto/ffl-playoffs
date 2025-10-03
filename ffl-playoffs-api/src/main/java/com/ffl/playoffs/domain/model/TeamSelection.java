package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Domain model representing a player's team selection for a specific week.
 */
public class TeamSelection {
    private UUID id;
    private UUID playerId;
    private UUID weekId;
    private String teamCode;
    private LocalDateTime selectedAt;
    private Double score;

    public TeamSelection() {
        this.id = UUID.randomUUID();
        this.selectedAt = LocalDateTime.now();
    }

    public TeamSelection(UUID playerId, UUID weekId, String teamCode) {
        this();
        this.playerId = playerId;
        this.weekId = weekId;
        this.teamCode = teamCode;
    }

    public void setScore(Double score) {
        this.score = score;
    }

    // Getters and setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public UUID getPlayerId() { return playerId; }
    public void setPlayerId(UUID playerId) { this.playerId = playerId; }

    public UUID getWeekId() { return weekId; }
    public void setWeekId(UUID weekId) { this.weekId = weekId; }

    public String getTeamCode() { return teamCode; }
    public void setTeamCode(String teamCode) { this.teamCode = teamCode; }

    public LocalDateTime getSelectedAt() { return selectedAt; }
    public void setSelectedAt(LocalDateTime selectedAt) { this.selectedAt = selectedAt; }

    public Double getScore() { return score; }
}
