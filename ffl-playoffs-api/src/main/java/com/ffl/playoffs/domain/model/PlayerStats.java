package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * PlayerStats Entity
 * Represents NFL player statistics for a specific game
 * Used for calculating fantasy points
 * Domain model with no framework dependencies
 */
public class PlayerStats {
    private UUID id;
    private Long nflPlayerId;      // References NFLPlayer
    private UUID nflGameId;         // References NFLGame
    private Integer week;           // NFL week number
    private Integer season;         // NFL season year

    // Passing Stats
    private Integer passingYards;
    private Integer passingTouchdowns;
    private Integer interceptions;
    private Integer passingAttempts;
    private Integer passingCompletions;

    // Rushing Stats
    private Integer rushingYards;
    private Integer rushingTouchdowns;
    private Integer rushingAttempts;

    // Receiving Stats
    private Integer receptions;
    private Integer receivingYards;
    private Integer receivingTouchdowns;
    private Integer targets;

    // Other Offensive Stats
    private Integer twoPointConversions;
    private Integer fumbles;
    private Integer fumblesLost;

    // Kicker Stats
    private Integer fieldGoalsMade;
    private Integer fieldGoalsAttempted;
    private Integer fieldGoalsMade0_19;
    private Integer fieldGoalsMade20_29;
    private Integer fieldGoalsMade30_39;
    private Integer fieldGoalsMade40_49;
    private Integer fieldGoalsMade50Plus;
    private Integer extraPointsMade;
    private Integer extraPointsAttempted;

    // Calculated fantasy points
    private Double fantasyPoints;
    private Double pprFantasyPoints;  // PPR scoring
    private Double halfPprFantasyPoints;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime syncedAt;  // When stats were last synced from external source

    // Constructors
    public PlayerStats() {
        this.id = UUID.randomUUID();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public PlayerStats(Long nflPlayerId, UUID nflGameId, Integer week, Integer season) {
        this();
        this.nflPlayerId = nflPlayerId;
        this.nflGameId = nflGameId;
        this.week = week;
        this.season = season;
    }

    // Business Logic

    /**
     * Calculates standard fantasy points based on common scoring rules
     * This is a default calculation - actual scoring should use ScoringRules
     * @return calculated fantasy points
     */
    public double calculateStandardPoints() {
        double points = 0.0;

        // Passing
        if (passingYards != null) points += passingYards * 0.04;  // 1 point per 25 yards
        if (passingTouchdowns != null) points += passingTouchdowns * 4;
        if (interceptions != null) points -= interceptions * 2;

        // Rushing
        if (rushingYards != null) points += rushingYards * 0.1;  // 1 point per 10 yards
        if (rushingTouchdowns != null) points += rushingTouchdowns * 6;

        // Receiving
        if (receivingYards != null) points += receivingYards * 0.1;  // 1 point per 10 yards
        if (receivingTouchdowns != null) points += receivingTouchdowns * 6;

        // Other
        if (twoPointConversions != null) points += twoPointConversions * 2;
        if (fumblesLost != null) points -= fumblesLost * 2;

        // Kicker
        if (fieldGoalsMade0_19 != null) points += fieldGoalsMade0_19 * 3;
        if (fieldGoalsMade20_29 != null) points += fieldGoalsMade20_29 * 3;
        if (fieldGoalsMade30_39 != null) points += fieldGoalsMade30_39 * 3;
        if (fieldGoalsMade40_49 != null) points += fieldGoalsMade40_49 * 4;
        if (fieldGoalsMade50Plus != null) points += fieldGoalsMade50Plus * 5;
        if (extraPointsMade != null) points += extraPointsMade * 1;

        return points;
    }

    /**
     * Calculates PPR fantasy points (adds 1 point per reception)
     * @return calculated PPR fantasy points
     */
    public double calculatePPRPoints() {
        double points = calculateStandardPoints();
        if (receptions != null) points += receptions * 1.0;  // 1 point per reception
        return points;
    }

    /**
     * Calculates Half-PPR fantasy points (adds 0.5 points per reception)
     * @return calculated Half-PPR fantasy points
     */
    public double calculateHalfPPRPoints() {
        double points = calculateStandardPoints();
        if (receptions != null) points += receptions * 0.5;  // 0.5 points per reception
        return points;
    }

    /**
     * Marks stats as synced from external source
     */
    public void markSynced() {
        this.syncedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public Long getNflPlayerId() {
        return nflPlayerId;
    }

    public void setNflPlayerId(Long nflPlayerId) {
        this.nflPlayerId = nflPlayerId;
    }

    public UUID getNflGameId() {
        return nflGameId;
    }

    public void setNflGameId(UUID nflGameId) {
        this.nflGameId = nflGameId;
    }

    public Integer getWeek() {
        return week;
    }

    public void setWeek(Integer week) {
        this.week = week;
    }

    public Integer getSeason() {
        return season;
    }

    public void setSeason(Integer season) {
        this.season = season;
    }

    public Integer getPassingYards() {
        return passingYards;
    }

    public void setPassingYards(Integer passingYards) {
        this.passingYards = passingYards;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getPassingTouchdowns() {
        return passingTouchdowns;
    }

    public void setPassingTouchdowns(Integer passingTouchdowns) {
        this.passingTouchdowns = passingTouchdowns;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getInterceptions() {
        return interceptions;
    }

    public void setInterceptions(Integer interceptions) {
        this.interceptions = interceptions;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getPassingAttempts() {
        return passingAttempts;
    }

    public void setPassingAttempts(Integer passingAttempts) {
        this.passingAttempts = passingAttempts;
    }

    public Integer getPassingCompletions() {
        return passingCompletions;
    }

    public void setPassingCompletions(Integer passingCompletions) {
        this.passingCompletions = passingCompletions;
    }

    public Integer getRushingYards() {
        return rushingYards;
    }

    public void setRushingYards(Integer rushingYards) {
        this.rushingYards = rushingYards;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getRushingTouchdowns() {
        return rushingTouchdowns;
    }

    public void setRushingTouchdowns(Integer rushingTouchdowns) {
        this.rushingTouchdowns = rushingTouchdowns;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getRushingAttempts() {
        return rushingAttempts;
    }

    public void setRushingAttempts(Integer rushingAttempts) {
        this.rushingAttempts = rushingAttempts;
    }

    public Integer getReceptions() {
        return receptions;
    }

    public void setReceptions(Integer receptions) {
        this.receptions = receptions;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getReceivingYards() {
        return receivingYards;
    }

    public void setReceivingYards(Integer receivingYards) {
        this.receivingYards = receivingYards;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getReceivingTouchdowns() {
        return receivingTouchdowns;
    }

    public void setReceivingTouchdowns(Integer receivingTouchdowns) {
        this.receivingTouchdowns = receivingTouchdowns;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getTargets() {
        return targets;
    }

    public void setTargets(Integer targets) {
        this.targets = targets;
    }

    public Integer getTwoPointConversions() {
        return twoPointConversions;
    }

    public void setTwoPointConversions(Integer twoPointConversions) {
        this.twoPointConversions = twoPointConversions;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getFumbles() {
        return fumbles;
    }

    public void setFumbles(Integer fumbles) {
        this.fumbles = fumbles;
    }

    public Integer getFumblesLost() {
        return fumblesLost;
    }

    public void setFumblesLost(Integer fumblesLost) {
        this.fumblesLost = fumblesLost;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getFieldGoalsMade() {
        return fieldGoalsMade;
    }

    public void setFieldGoalsMade(Integer fieldGoalsMade) {
        this.fieldGoalsMade = fieldGoalsMade;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getFieldGoalsAttempted() {
        return fieldGoalsAttempted;
    }

    public void setFieldGoalsAttempted(Integer fieldGoalsAttempted) {
        this.fieldGoalsAttempted = fieldGoalsAttempted;
    }

    public Integer getFieldGoalsMade0_19() {
        return fieldGoalsMade0_19;
    }

    public void setFieldGoalsMade0_19(Integer fieldGoalsMade0_19) {
        this.fieldGoalsMade0_19 = fieldGoalsMade0_19;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getFieldGoalsMade20_29() {
        return fieldGoalsMade20_29;
    }

    public void setFieldGoalsMade20_29(Integer fieldGoalsMade20_29) {
        this.fieldGoalsMade20_29 = fieldGoalsMade20_29;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getFieldGoalsMade30_39() {
        return fieldGoalsMade30_39;
    }

    public void setFieldGoalsMade30_39(Integer fieldGoalsMade30_39) {
        this.fieldGoalsMade30_39 = fieldGoalsMade30_39;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getFieldGoalsMade40_49() {
        return fieldGoalsMade40_49;
    }

    public void setFieldGoalsMade40_49(Integer fieldGoalsMade40_49) {
        this.fieldGoalsMade40_49 = fieldGoalsMade40_49;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getFieldGoalsMade50Plus() {
        return fieldGoalsMade50Plus;
    }

    public void setFieldGoalsMade50Plus(Integer fieldGoalsMade50Plus) {
        this.fieldGoalsMade50Plus = fieldGoalsMade50Plus;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getExtraPointsMade() {
        return extraPointsMade;
    }

    public void setExtraPointsMade(Integer extraPointsMade) {
        this.extraPointsMade = extraPointsMade;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getExtraPointsAttempted() {
        return extraPointsAttempted;
    }

    public void setExtraPointsAttempted(Integer extraPointsAttempted) {
        this.extraPointsAttempted = extraPointsAttempted;
    }

    public Double getFantasyPoints() {
        return fantasyPoints;
    }

    public void setFantasyPoints(Double fantasyPoints) {
        this.fantasyPoints = fantasyPoints;
    }

    public Double getPprFantasyPoints() {
        return pprFantasyPoints;
    }

    public void setPprFantasyPoints(Double pprFantasyPoints) {
        this.pprFantasyPoints = pprFantasyPoints;
    }

    public Double getHalfPprFantasyPoints() {
        return halfPprFantasyPoints;
    }

    public void setHalfPprFantasyPoints(Double halfPprFantasyPoints) {
        this.halfPprFantasyPoints = halfPprFantasyPoints;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public LocalDateTime getSyncedAt() {
        return syncedAt;
    }

    public void setSyncedAt(LocalDateTime syncedAt) {
        this.syncedAt = syncedAt;
    }
}
