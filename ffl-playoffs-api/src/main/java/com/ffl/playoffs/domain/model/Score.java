package com.ffl.playoffs.domain.model;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Domain model representing scoring data for a team selection.
 */
public class Score {
    private UUID id;
    private UUID teamSelectionId;
    private Double totalScore;
    private Map<String, Double> positionScores;
    private Map<String, Object> rawStats;

    public Score() {
        this.id = UUID.randomUUID();
        this.positionScores = new HashMap<>();
        this.rawStats = new HashMap<>();
        this.totalScore = 0.0;
    }

    public Score(UUID teamSelectionId) {
        this();
        this.teamSelectionId = teamSelectionId;
    }

    public void addPositionScore(String position, Double score) {
        this.positionScores.put(position, score);
        recalculateTotal();
    }

    private void recalculateTotal() {
        this.totalScore = positionScores.values().stream()
                .mapToDouble(Double::doubleValue)
                .sum();
    }

    // Getters and setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public UUID getTeamSelectionId() { return teamSelectionId; }
    public void setTeamSelectionId(UUID teamSelectionId) { this.teamSelectionId = teamSelectionId; }

    public Double getTotalScore() { return totalScore; }
    public void setTotalScore(Double totalScore) { this.totalScore = totalScore; }

    public Map<String, Double> getPositionScores() { return positionScores; }
    public void setPositionScores(Map<String, Double> positionScores) { 
        this.positionScores = positionScores;
        recalculateTotal();
    }

    public Map<String, Object> getRawStats() { return rawStats; }
    public void setRawStats(Map<String, Object> rawStats) { this.rawStats = rawStats; }
}
