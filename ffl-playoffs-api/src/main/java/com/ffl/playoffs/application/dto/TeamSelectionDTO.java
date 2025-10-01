package com.ffl.playoffs.application.dto;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Data Transfer Object for TeamSelection
 * Used for API communication
 */
public class TeamSelectionDTO {
    private UUID id;
    private UUID playerId;
    private Integer week;
    private String nflTeamCode;
    private String nflTeamName;
    private String status;
    private LocalDateTime selectedAt;
    private Integer totalPoints;
    private boolean isWin;

    // Constructors
    public TeamSelectionDTO() {
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

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getSelectedAt() {
        return selectedAt;
    }

    public void setSelectedAt(LocalDateTime selectedAt) {
        this.selectedAt = selectedAt;
    }

    public Integer getTotalPoints() {
        return totalPoints;
    }

    public void setTotalPoints(Integer totalPoints) {
        this.totalPoints = totalPoints;
    }

    public boolean isWin() {
        return isWin;
    }

    public void setWin(boolean win) {
        isWin = win;
    }
}
