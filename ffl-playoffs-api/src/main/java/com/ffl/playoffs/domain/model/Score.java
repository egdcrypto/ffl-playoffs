package com.ffl.playoffs.domain.model;

import java.util.UUID;

/**
 * Score entity - represents the score for a team selection
 * Domain model with no framework dependencies
 */
public class Score {
    private UUID id;
    private UUID teamSelectionId;
    private Integer totalPoints;
    private Integer offensivePoints;
    private Integer defensivePoints;
    private Integer fieldGoalPoints;
    private boolean isWin;
    private String opponentTeamCode;

    public Score() {
        this.id = UUID.randomUUID();
        this.totalPoints = 0;
        this.offensivePoints = 0;
        this.defensivePoints = 0;
        this.fieldGoalPoints = 0;
        this.isWin = false;
    }

    public Score(UUID teamSelectionId) {
        this();
        this.teamSelectionId = teamSelectionId;
    }

    // Business methods
    public void calculateTotalPoints() {
        this.totalPoints = this.offensivePoints + this.defensivePoints + this.fieldGoalPoints;
    }

    public void addOffensivePoints(Integer points) {
        this.offensivePoints += points;
        calculateTotalPoints();
    }

    public void addDefensivePoints(Integer points) {
        this.defensivePoints += points;
        calculateTotalPoints();
    }

    public void addFieldGoalPoints(Integer points) {
        this.fieldGoalPoints += points;
        calculateTotalPoints();
    }

    public void recordWin() {
        this.isWin = true;
    }

    public void recordLoss() {
        this.isWin = false;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getTeamSelectionId() {
        return teamSelectionId;
    }

    public void setTeamSelectionId(UUID teamSelectionId) {
        this.teamSelectionId = teamSelectionId;
    }

    public Integer getTotalPoints() {
        return totalPoints;
    }

    public void setTotalPoints(Integer totalPoints) {
        this.totalPoints = totalPoints;
    }

    public Integer getOffensivePoints() {
        return offensivePoints;
    }

    public void setOffensivePoints(Integer offensivePoints) {
        this.offensivePoints = offensivePoints;
    }

    public Integer getDefensivePoints() {
        return defensivePoints;
    }

    public void setDefensivePoints(Integer defensivePoints) {
        this.defensivePoints = defensivePoints;
    }

    public Integer getFieldGoalPoints() {
        return fieldGoalPoints;
    }

    public void setFieldGoalPoints(Integer fieldGoalPoints) {
        this.fieldGoalPoints = fieldGoalPoints;
    }

    public boolean isWin() {
        return isWin;
    }

    public void setWin(boolean win) {
        isWin = win;
    }

    public String getOpponentTeamCode() {
        return opponentTeamCode;
    }

    public void setOpponentTeamCode(String opponentTeamCode) {
        this.opponentTeamCode = opponentTeamCode;
    }
}
