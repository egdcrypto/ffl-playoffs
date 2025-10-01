package com.ffl.playoffs.domain.model;

import java.util.UUID;

/**
 * ScoringRules entity - represents configurable scoring rules for a game
 * Domain model with no framework dependencies
 */
public class ScoringRules {
    private UUID id;
    private UUID gameId;

    // Offensive scoring
    private Double passingTouchdownPoints;
    private Double rushingTouchdownPoints;
    private Double receivingTouchdownPoints;
    private Double passingYardsPerPoint;
    private Double rushingYardsPerPoint;
    private Double receivingYardsPerPoint;

    // Field goal scoring
    private Double fieldGoalUnder40Points;
    private Double fieldGoal40To49Points;
    private Double fieldGoal50PlusPoints;
    private Double extraPointPoints;

    // Defensive scoring
    private Double sackPoints;
    private Double interceptionPoints;
    private Double fumbleRecoveryPoints;
    private Double safetyPoints;
    private Double defensiveTouchdownPoints;
    private Double pointsAllowed0Points;
    private Double pointsAllowed1To6Points;
    private Double pointsAllowed7To13Points;
    private Double pointsAllowed14To20Points;
    private Double pointsAllowed21To27Points;
    private Double pointsAllowed28PlusPoints;

    public ScoringRules() {
        this.id = UUID.randomUUID();
        setDefaultScoringRules();
    }

    public ScoringRules(UUID gameId) {
        this();
        this.gameId = gameId;
    }

    private void setDefaultScoringRules() {
        // Default offensive scoring
        this.passingTouchdownPoints = 4.0;
        this.rushingTouchdownPoints = 6.0;
        this.receivingTouchdownPoints = 6.0;
        this.passingYardsPerPoint = 25.0;
        this.rushingYardsPerPoint = 10.0;
        this.receivingYardsPerPoint = 10.0;

        // Default field goal scoring
        this.fieldGoalUnder40Points = 3.0;
        this.fieldGoal40To49Points = 4.0;
        this.fieldGoal50PlusPoints = 5.0;
        this.extraPointPoints = 1.0;

        // Default defensive scoring
        this.sackPoints = 1.0;
        this.interceptionPoints = 2.0;
        this.fumbleRecoveryPoints = 2.0;
        this.safetyPoints = 2.0;
        this.defensiveTouchdownPoints = 6.0;
        this.pointsAllowed0Points = 10.0;
        this.pointsAllowed1To6Points = 7.0;
        this.pointsAllowed7To13Points = 4.0;
        this.pointsAllowed14To20Points = 1.0;
        this.pointsAllowed21To27Points = 0.0;
        this.pointsAllowed28PlusPoints = -1.0;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getGameId() {
        return gameId;
    }

    public void setGameId(UUID gameId) {
        this.gameId = gameId;
    }

    public Double getPassingTouchdownPoints() {
        return passingTouchdownPoints;
    }

    public void setPassingTouchdownPoints(Double passingTouchdownPoints) {
        this.passingTouchdownPoints = passingTouchdownPoints;
    }

    public Double getRushingTouchdownPoints() {
        return rushingTouchdownPoints;
    }

    public void setRushingTouchdownPoints(Double rushingTouchdownPoints) {
        this.rushingTouchdownPoints = rushingTouchdownPoints;
    }

    public Double getReceivingTouchdownPoints() {
        return receivingTouchdownPoints;
    }

    public void setReceivingTouchdownPoints(Double receivingTouchdownPoints) {
        this.receivingTouchdownPoints = receivingTouchdownPoints;
    }

    public Double getPassingYardsPerPoint() {
        return passingYardsPerPoint;
    }

    public void setPassingYardsPerPoint(Double passingYardsPerPoint) {
        this.passingYardsPerPoint = passingYardsPerPoint;
    }

    public Double getRushingYardsPerPoint() {
        return rushingYardsPerPoint;
    }

    public void setRushingYardsPerPoint(Double rushingYardsPerPoint) {
        this.rushingYardsPerPoint = rushingYardsPerPoint;
    }

    public Double getReceivingYardsPerPoint() {
        return receivingYardsPerPoint;
    }

    public void setReceivingYardsPerPoint(Double receivingYardsPerPoint) {
        this.receivingYardsPerPoint = receivingYardsPerPoint;
    }

    public Double getFieldGoalUnder40Points() {
        return fieldGoalUnder40Points;
    }

    public void setFieldGoalUnder40Points(Double fieldGoalUnder40Points) {
        this.fieldGoalUnder40Points = fieldGoalUnder40Points;
    }

    public Double getFieldGoal40To49Points() {
        return fieldGoal40To49Points;
    }

    public void setFieldGoal40To49Points(Double fieldGoal40To49Points) {
        this.fieldGoal40To49Points = fieldGoal40To49Points;
    }

    public Double getFieldGoal50PlusPoints() {
        return fieldGoal50PlusPoints;
    }

    public void setFieldGoal50PlusPoints(Double fieldGoal50PlusPoints) {
        this.fieldGoal50PlusPoints = fieldGoal50PlusPoints;
    }

    public Double getExtraPointPoints() {
        return extraPointPoints;
    }

    public void setExtraPointPoints(Double extraPointPoints) {
        this.extraPointPoints = extraPointPoints;
    }

    public Double getSackPoints() {
        return sackPoints;
    }

    public void setSackPoints(Double sackPoints) {
        this.sackPoints = sackPoints;
    }

    public Double getInterceptionPoints() {
        return interceptionPoints;
    }

    public void setInterceptionPoints(Double interceptionPoints) {
        this.interceptionPoints = interceptionPoints;
    }

    public Double getFumbleRecoveryPoints() {
        return fumbleRecoveryPoints;
    }

    public void setFumbleRecoveryPoints(Double fumbleRecoveryPoints) {
        this.fumbleRecoveryPoints = fumbleRecoveryPoints;
    }

    public Double getSafetyPoints() {
        return safetyPoints;
    }

    public void setSafetyPoints(Double safetyPoints) {
        this.safetyPoints = safetyPoints;
    }

    public Double getDefensiveTouchdownPoints() {
        return defensiveTouchdownPoints;
    }

    public void setDefensiveTouchdownPoints(Double defensiveTouchdownPoints) {
        this.defensiveTouchdownPoints = defensiveTouchdownPoints;
    }

    public Double getPointsAllowed0Points() {
        return pointsAllowed0Points;
    }

    public void setPointsAllowed0Points(Double pointsAllowed0Points) {
        this.pointsAllowed0Points = pointsAllowed0Points;
    }

    public Double getPointsAllowed1To6Points() {
        return pointsAllowed1To6Points;
    }

    public void setPointsAllowed1To6Points(Double pointsAllowed1To6Points) {
        this.pointsAllowed1To6Points = pointsAllowed1To6Points;
    }

    public Double getPointsAllowed7To13Points() {
        return pointsAllowed7To13Points;
    }

    public void setPointsAllowed7To13Points(Double pointsAllowed7To13Points) {
        this.pointsAllowed7To13Points = pointsAllowed7To13Points;
    }

    public Double getPointsAllowed14To20Points() {
        return pointsAllowed14To20Points;
    }

    public void setPointsAllowed14To20Points(Double pointsAllowed14To20Points) {
        this.pointsAllowed14To20Points = pointsAllowed14To20Points;
    }

    public Double getPointsAllowed21To27Points() {
        return pointsAllowed21To27Points;
    }

    public void setPointsAllowed21To27Points(Double pointsAllowed21To27Points) {
        this.pointsAllowed21To27Points = pointsAllowed21To27Points;
    }

    public Double getPointsAllowed28PlusPoints() {
        return pointsAllowed28PlusPoints;
    }

    public void setPointsAllowed28PlusPoints(Double pointsAllowed28PlusPoints) {
        this.pointsAllowed28PlusPoints = pointsAllowed28PlusPoints;
    }
}
