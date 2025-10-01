package com.ffl.playoffs.application.dto;

/**
 * Data Transfer Object for Scoring Rules
 * Defines PPR scoring configuration for a league
 */
public class ScoringRulesDTO {
    private Double passingYards;
    private Double passingTouchdowns;
    private Double interceptions;
    private Double rushingYards;
    private Double rushingTouchdowns;
    private Double receivingYards;
    private Double receivingTouchdowns;
    private Double receptions;
    private Double fumblesLost;
    private Double twoPointConversions;

    // Constructors
    public ScoringRulesDTO() {
    }

    // Getters and Setters
    public Double getPassingYards() {
        return passingYards;
    }

    public void setPassingYards(Double passingYards) {
        this.passingYards = passingYards;
    }

    public Double getPassingTouchdowns() {
        return passingTouchdowns;
    }

    public void setPassingTouchdowns(Double passingTouchdowns) {
        this.passingTouchdowns = passingTouchdowns;
    }

    public Double getInterceptions() {
        return interceptions;
    }

    public void setInterceptions(Double interceptions) {
        this.interceptions = interceptions;
    }

    public Double getRushingYards() {
        return rushingYards;
    }

    public void setRushingYards(Double rushingYards) {
        this.rushingYards = rushingYards;
    }

    public Double getRushingTouchdowns() {
        return rushingTouchdowns;
    }

    public void setRushingTouchdowns(Double rushingTouchdowns) {
        this.rushingTouchdowns = rushingTouchdowns;
    }

    public Double getReceivingYards() {
        return receivingYards;
    }

    public void setReceivingYards(Double receivingYards) {
        this.receivingYards = receivingYards;
    }

    public Double getReceivingTouchdowns() {
        return receivingTouchdowns;
    }

    public void setReceivingTouchdowns(Double receivingTouchdowns) {
        this.receivingTouchdowns = receivingTouchdowns;
    }

    public Double getReceptions() {
        return receptions;
    }

    public void setReceptions(Double receptions) {
        this.receptions = receptions;
    }

    public Double getFumblesLost() {
        return fumblesLost;
    }

    public void setFumblesLost(Double fumblesLost) {
        this.fumblesLost = fumblesLost;
    }

    public Double getTwoPointConversions() {
        return twoPointConversions;
    }

    public void setTwoPointConversions(Double twoPointConversions) {
        this.twoPointConversions = twoPointConversions;
    }
}
