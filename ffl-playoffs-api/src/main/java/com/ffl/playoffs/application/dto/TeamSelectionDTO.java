package com.ffl.playoffs.application.dto;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Data Transfer Object for TeamSelection.
 */
public class TeamSelectionDTO {
    private UUID id;
    private UUID playerId;
    private UUID weekId;
    private Integer weekNumber;
    private String teamCode;
    private String teamName;
    private LocalDateTime selectedAt;
    private Double score;

    // Constructors
    public TeamSelectionDTO() {}

    // Getters and Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public UUID getPlayerId() { return playerId; }
    public void setPlayerId(UUID playerId) { this.playerId = playerId; }

    public UUID getWeekId() { return weekId; }
    public void setWeekId(UUID weekId) { this.weekId = weekId; }

    public Integer getWeekNumber() { return weekNumber; }
    public void setWeekNumber(Integer weekNumber) { this.weekNumber = weekNumber; }

    public String getTeamCode() { return teamCode; }
    public void setTeamCode(String teamCode) { this.teamCode = teamCode; }

    public String getTeamName() { return teamName; }
    public void setTeamName(String teamName) { this.teamName = teamName; }

    public LocalDateTime getSelectedAt() { return selectedAt; }
    public void setSelectedAt(LocalDateTime selectedAt) { this.selectedAt = selectedAt; }

    public Double getScore() { return score; }
    public void setScore(Double score) { this.score = score; }
}
