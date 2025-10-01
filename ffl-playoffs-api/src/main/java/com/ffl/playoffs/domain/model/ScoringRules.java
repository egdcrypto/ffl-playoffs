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

    // PPR (Points Per Reception) scoring
    private Double receptionPoints;
    private Double twoPointConversionPoints;

    // Negative scoring
    private Double interceptionThrownPoints; // Negative points for QB INTs
    private Double fumbleLostPoints; // Negative points for fumbles lost

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

    // Points allowed tiers
    private Double pointsAllowed0Points;
    private Double pointsAllowed1To6Points;
    private Double pointsAllowed7To13Points;
    private Double pointsAllowed14To20Points;
    private Double pointsAllowed21To27Points;
    private Double pointsAllowed28PlusPoints;

    // Yards allowed tiers (for defensive scoring)
    private Double yardsAllowedUnder100Points;
    private Double yardsAllowed100To199Points;
    private Double yardsAllowed200To299Points;
    private Double yardsAllowed300To349Points;
    private Double yardsAllowed350To399Points;
    private Double yardsAllowed400To449Points;
    private Double yardsAllowed450To499Points;
    private Double yardsAllowed500To549Points;
    private Double yardsAllowed550PlusPoints;

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

        // PPR scoring
        this.receptionPoints = 1.0; // Full PPR (1 point per reception)
        this.twoPointConversionPoints = 2.0;

        // Negative scoring
        this.interceptionThrownPoints = -2.0; // QB interceptions
        this.fumbleLostPoints = -2.0; // Fumbles lost

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

        // Points allowed tiers
        this.pointsAllowed0Points = 10.0;
        this.pointsAllowed1To6Points = 7.0;
        this.pointsAllowed7To13Points = 4.0;
        this.pointsAllowed14To20Points = 1.0;
        this.pointsAllowed21To27Points = 0.0;
        this.pointsAllowed28PlusPoints = -1.0;

        // Yards allowed tiers
        this.yardsAllowedUnder100Points = 5.0;
        this.yardsAllowed100To199Points = 3.0;
        this.yardsAllowed200To299Points = 2.0;
        this.yardsAllowed300To349Points = 0.0;
        this.yardsAllowed350To399Points = -1.0;
        this.yardsAllowed400To449Points = -3.0;
        this.yardsAllowed450To499Points = -5.0;
        this.yardsAllowed500To549Points = -6.0;
        this.yardsAllowed550PlusPoints = -7.0;
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

    // PPR scoring getters/setters
    public Double getReceptionPoints() {
        return receptionPoints;
    }

    public void setReceptionPoints(Double receptionPoints) {
        this.receptionPoints = receptionPoints;
    }

    public Double getTwoPointConversionPoints() {
        return twoPointConversionPoints;
    }

    public void setTwoPointConversionPoints(Double twoPointConversionPoints) {
        this.twoPointConversionPoints = twoPointConversionPoints;
    }

    // Negative scoring getters/setters
    public Double getInterceptionThrownPoints() {
        return interceptionThrownPoints;
    }

    public void setInterceptionThrownPoints(Double interceptionThrownPoints) {
        this.interceptionThrownPoints = interceptionThrownPoints;
    }

    public Double getFumbleLostPoints() {
        return fumbleLostPoints;
    }

    public void setFumbleLostPoints(Double fumbleLostPoints) {
        this.fumbleLostPoints = fumbleLostPoints;
    }

    // Yards allowed tiers getters/setters
    public Double getYardsAllowedUnder100Points() {
        return yardsAllowedUnder100Points;
    }

    public void setYardsAllowedUnder100Points(Double yardsAllowedUnder100Points) {
        this.yardsAllowedUnder100Points = yardsAllowedUnder100Points;
    }

    public Double getYardsAllowed100To199Points() {
        return yardsAllowed100To199Points;
    }

    public void setYardsAllowed100To199Points(Double yardsAllowed100To199Points) {
        this.yardsAllowed100To199Points = yardsAllowed100To199Points;
    }

    public Double getYardsAllowed200To299Points() {
        return yardsAllowed200To299Points;
    }

    public void setYardsAllowed200To299Points(Double yardsAllowed200To299Points) {
        this.yardsAllowed200To299Points = yardsAllowed200To299Points;
    }

    public Double getYardsAllowed300To349Points() {
        return yardsAllowed300To349Points;
    }

    public void setYardsAllowed300To349Points(Double yardsAllowed300To349Points) {
        this.yardsAllowed300To349Points = yardsAllowed300To349Points;
    }

    public Double getYardsAllowed350To399Points() {
        return yardsAllowed350To399Points;
    }

    public void setYardsAllowed350To399Points(Double yardsAllowed350To399Points) {
        this.yardsAllowed350To399Points = yardsAllowed350To399Points;
    }

    public Double getYardsAllowed400To449Points() {
        return yardsAllowed400To449Points;
    }

    public void setYardsAllowed400To449Points(Double yardsAllowed400To449Points) {
        this.yardsAllowed400To449Points = yardsAllowed400To449Points;
    }

    public Double getYardsAllowed450To499Points() {
        return yardsAllowed450To499Points;
    }

    public void setYardsAllowed450To499Points(Double yardsAllowed450To499Points) {
        this.yardsAllowed450To499Points = yardsAllowed450To499Points;
    }

    public Double getYardsAllowed500To549Points() {
        return yardsAllowed500To549Points;
    }

    public void setYardsAllowed500To549Points(Double yardsAllowed500To549Points) {
        this.yardsAllowed500To549Points = yardsAllowed500To549Points;
    }

    public Double getYardsAllowed550PlusPoints() {
        return yardsAllowed550PlusPoints;
    }

    public void setYardsAllowed550PlusPoints(Double yardsAllowed550PlusPoints) {
        this.yardsAllowed550PlusPoints = yardsAllowed550PlusPoints;
    }
}
