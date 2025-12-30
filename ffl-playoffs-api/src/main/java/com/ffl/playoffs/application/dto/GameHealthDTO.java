package com.ffl.playoffs.application.dto;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * DTO for game health status response.
 */
public class GameHealthDTO {
    private UUID leagueId;
    private String leagueName;
    private String status;
    private int totalPlayers;
    private String activeSelections;
    private int missedSelections;
    private Integer currentWeek;
    private int weeksRemaining;
    private String dataIntegrationStatus;
    private LocalDateTime lastScoreCalculation;

    public GameHealthDTO() {
    }

    public UUID getLeagueId() {
        return leagueId;
    }

    public void setLeagueId(UUID leagueId) {
        this.leagueId = leagueId;
    }

    public String getLeagueName() {
        return leagueName;
    }

    public void setLeagueName(String leagueName) {
        this.leagueName = leagueName;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getTotalPlayers() {
        return totalPlayers;
    }

    public void setTotalPlayers(int totalPlayers) {
        this.totalPlayers = totalPlayers;
    }

    public String getActiveSelections() {
        return activeSelections;
    }

    public void setActiveSelections(String activeSelections) {
        this.activeSelections = activeSelections;
    }

    public int getMissedSelections() {
        return missedSelections;
    }

    public void setMissedSelections(int missedSelections) {
        this.missedSelections = missedSelections;
    }

    public Integer getCurrentWeek() {
        return currentWeek;
    }

    public void setCurrentWeek(Integer currentWeek) {
        this.currentWeek = currentWeek;
    }

    public int getWeeksRemaining() {
        return weeksRemaining;
    }

    public void setWeeksRemaining(int weeksRemaining) {
        this.weeksRemaining = weeksRemaining;
    }

    public String getDataIntegrationStatus() {
        return dataIntegrationStatus;
    }

    public void setDataIntegrationStatus(String dataIntegrationStatus) {
        this.dataIntegrationStatus = dataIntegrationStatus;
    }

    public LocalDateTime getLastScoreCalculation() {
        return lastScoreCalculation;
    }

    public void setLastScoreCalculation(LocalDateTime lastScoreCalculation) {
        this.lastScoreCalculation = lastScoreCalculation;
    }
}
