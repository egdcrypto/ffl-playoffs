package com.ffl.playoffs.domain.model;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

/**
 * Value object representing PPR (Points Per Reception) scoring configuration
 * Immutable configuration for calculating fantasy football scores
 */
public class PPRScoringConfiguration {

    // Passing
    private final BigDecimal passingYardsPerPoint;
    private final BigDecimal passingTouchdownPoints;
    private final BigDecimal interceptionPoints;

    // Rushing
    private final BigDecimal rushingYardsPerPoint;
    private final BigDecimal rushingTouchdownPoints;

    // Receiving
    private final BigDecimal receivingYardsPerPoint;
    private final BigDecimal receivingTouchdownPoints;
    private final BigDecimal receptionPoints; // PPR value

    // Turnovers
    private final BigDecimal fumbleLostPoints;

    // Milestone bonuses
    private final BigDecimal passingYards300Bonus;
    private final BigDecimal rushingYards100Bonus;
    private final BigDecimal receivingYards100Bonus;
    private final BigDecimal longTouchdown40Bonus;

    // Kicking
    private final BigDecimal extraPointMadePoints;
    private final BigDecimal fieldGoal0to39Points;
    private final BigDecimal fieldGoal40to49Points;
    private final BigDecimal fieldGoal50PlusPoints;

    // Defense
    private final BigDecimal sackPoints;
    private final BigDecimal defensiveInterceptionPoints;
    private final BigDecimal fumbleRecoveryPoints;
    private final BigDecimal defensiveTouchdownPoints;
    private final Map<String, BigDecimal> pointsAllowedScoring;

    private PPRScoringConfiguration(Builder builder) {
        this.passingYardsPerPoint = builder.passingYardsPerPoint;
        this.passingTouchdownPoints = builder.passingTouchdownPoints;
        this.interceptionPoints = builder.interceptionPoints;
        this.rushingYardsPerPoint = builder.rushingYardsPerPoint;
        this.rushingTouchdownPoints = builder.rushingTouchdownPoints;
        this.receivingYardsPerPoint = builder.receivingYardsPerPoint;
        this.receivingTouchdownPoints = builder.receivingTouchdownPoints;
        this.receptionPoints = builder.receptionPoints;
        this.fumbleLostPoints = builder.fumbleLostPoints;
        this.passingYards300Bonus = builder.passingYards300Bonus;
        this.rushingYards100Bonus = builder.rushingYards100Bonus;
        this.receivingYards100Bonus = builder.receivingYards100Bonus;
        this.longTouchdown40Bonus = builder.longTouchdown40Bonus;
        this.extraPointMadePoints = builder.extraPointMadePoints;
        this.fieldGoal0to39Points = builder.fieldGoal0to39Points;
        this.fieldGoal40to49Points = builder.fieldGoal40to49Points;
        this.fieldGoal50PlusPoints = builder.fieldGoal50PlusPoints;
        this.sackPoints = builder.sackPoints;
        this.defensiveInterceptionPoints = builder.defensiveInterceptionPoints;
        this.fumbleRecoveryPoints = builder.fumbleRecoveryPoints;
        this.defensiveTouchdownPoints = builder.defensiveTouchdownPoints;
        this.pointsAllowedScoring = new HashMap<>(builder.pointsAllowedScoring);
    }

    /**
     * Create the default PPR scoring configuration as per Gherkin scenarios
     */
    public static PPRScoringConfiguration defaultConfiguration() {
        Map<String, BigDecimal> pointsAllowed = new HashMap<>();
        pointsAllowed.put("0", new BigDecimal("10"));
        pointsAllowed.put("1-6", new BigDecimal("7"));
        pointsAllowed.put("7-13", new BigDecimal("4"));
        pointsAllowed.put("14-20", new BigDecimal("1"));
        pointsAllowed.put("21-27", BigDecimal.ZERO);
        pointsAllowed.put("28+", new BigDecimal("-4"));

        return PPRScoringConfiguration.builder()
            // Passing: 0.04 points per yard = 1 point per 25 yards
            .passingYardsPerPoint(new BigDecimal("0.04"))
            .passingTouchdownPoints(new BigDecimal("4"))
            .interceptionPoints(new BigDecimal("-2"))
            // Rushing: 0.1 points per yard = 1 point per 10 yards
            .rushingYardsPerPoint(new BigDecimal("0.1"))
            .rushingTouchdownPoints(new BigDecimal("6"))
            // Receiving: 0.1 points per yard, 1 point per reception (PPR)
            .receivingYardsPerPoint(new BigDecimal("0.1"))
            .receivingTouchdownPoints(new BigDecimal("6"))
            .receptionPoints(new BigDecimal("1.0"))
            // Turnovers
            .fumbleLostPoints(new BigDecimal("-2"))
            // Milestone bonuses
            .passingYards300Bonus(new BigDecimal("3"))
            .rushingYards100Bonus(new BigDecimal("3"))
            .receivingYards100Bonus(new BigDecimal("3"))
            .longTouchdown40Bonus(new BigDecimal("2"))
            // Kicking
            .extraPointMadePoints(new BigDecimal("1"))
            .fieldGoal0to39Points(new BigDecimal("3"))
            .fieldGoal40to49Points(new BigDecimal("4"))
            .fieldGoal50PlusPoints(new BigDecimal("5"))
            // Defense
            .sackPoints(new BigDecimal("1"))
            .defensiveInterceptionPoints(new BigDecimal("2"))
            .fumbleRecoveryPoints(new BigDecimal("2"))
            .defensiveTouchdownPoints(new BigDecimal("6"))
            .pointsAllowedScoring(pointsAllowed)
            .build();
    }

    /**
     * Get defensive points based on points allowed
     */
    public BigDecimal getPointsAllowedScore(int pointsAllowed) {
        if (pointsAllowed == 0) {
            return pointsAllowedScoring.getOrDefault("0", BigDecimal.ZERO);
        } else if (pointsAllowed <= 6) {
            return pointsAllowedScoring.getOrDefault("1-6", BigDecimal.ZERO);
        } else if (pointsAllowed <= 13) {
            return pointsAllowedScoring.getOrDefault("7-13", BigDecimal.ZERO);
        } else if (pointsAllowed <= 20) {
            return pointsAllowedScoring.getOrDefault("14-20", BigDecimal.ZERO);
        } else if (pointsAllowed <= 27) {
            return pointsAllowedScoring.getOrDefault("21-27", BigDecimal.ZERO);
        } else {
            return pointsAllowedScoring.getOrDefault("28+", BigDecimal.ZERO);
        }
    }

    // Getters
    public BigDecimal getPassingYardsPerPoint() { return passingYardsPerPoint; }
    public BigDecimal getPassingTouchdownPoints() { return passingTouchdownPoints; }
    public BigDecimal getInterceptionPoints() { return interceptionPoints; }
    public BigDecimal getRushingYardsPerPoint() { return rushingYardsPerPoint; }
    public BigDecimal getRushingTouchdownPoints() { return rushingTouchdownPoints; }
    public BigDecimal getReceivingYardsPerPoint() { return receivingYardsPerPoint; }
    public BigDecimal getReceivingTouchdownPoints() { return receivingTouchdownPoints; }
    public BigDecimal getReceptionPoints() { return receptionPoints; }
    public BigDecimal getFumbleLostPoints() { return fumbleLostPoints; }
    public BigDecimal getPassingYards300Bonus() { return passingYards300Bonus; }
    public BigDecimal getRushingYards100Bonus() { return rushingYards100Bonus; }
    public BigDecimal getReceivingYards100Bonus() { return receivingYards100Bonus; }
    public BigDecimal getLongTouchdown40Bonus() { return longTouchdown40Bonus; }
    public BigDecimal getExtraPointMadePoints() { return extraPointMadePoints; }
    public BigDecimal getFieldGoal0to39Points() { return fieldGoal0to39Points; }
    public BigDecimal getFieldGoal40to49Points() { return fieldGoal40to49Points; }
    public BigDecimal getFieldGoal50PlusPoints() { return fieldGoal50PlusPoints; }
    public BigDecimal getSackPoints() { return sackPoints; }
    public BigDecimal getDefensiveInterceptionPoints() { return defensiveInterceptionPoints; }
    public BigDecimal getFumbleRecoveryPoints() { return fumbleRecoveryPoints; }
    public BigDecimal getDefensiveTouchdownPoints() { return defensiveTouchdownPoints; }
    public Map<String, BigDecimal> getPointsAllowedScoring() { return new HashMap<>(pointsAllowedScoring); }

    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private BigDecimal passingYardsPerPoint = new BigDecimal("0.04");
        private BigDecimal passingTouchdownPoints = new BigDecimal("4");
        private BigDecimal interceptionPoints = new BigDecimal("-2");
        private BigDecimal rushingYardsPerPoint = new BigDecimal("0.1");
        private BigDecimal rushingTouchdownPoints = new BigDecimal("6");
        private BigDecimal receivingYardsPerPoint = new BigDecimal("0.1");
        private BigDecimal receivingTouchdownPoints = new BigDecimal("6");
        private BigDecimal receptionPoints = new BigDecimal("1.0");
        private BigDecimal fumbleLostPoints = new BigDecimal("-2");
        private BigDecimal passingYards300Bonus = new BigDecimal("3");
        private BigDecimal rushingYards100Bonus = new BigDecimal("3");
        private BigDecimal receivingYards100Bonus = new BigDecimal("3");
        private BigDecimal longTouchdown40Bonus = new BigDecimal("2");
        private BigDecimal extraPointMadePoints = new BigDecimal("1");
        private BigDecimal fieldGoal0to39Points = new BigDecimal("3");
        private BigDecimal fieldGoal40to49Points = new BigDecimal("4");
        private BigDecimal fieldGoal50PlusPoints = new BigDecimal("5");
        private BigDecimal sackPoints = new BigDecimal("1");
        private BigDecimal defensiveInterceptionPoints = new BigDecimal("2");
        private BigDecimal fumbleRecoveryPoints = new BigDecimal("2");
        private BigDecimal defensiveTouchdownPoints = new BigDecimal("6");
        private Map<String, BigDecimal> pointsAllowedScoring = new HashMap<>();

        public Builder passingYardsPerPoint(BigDecimal value) { this.passingYardsPerPoint = value; return this; }
        public Builder passingTouchdownPoints(BigDecimal value) { this.passingTouchdownPoints = value; return this; }
        public Builder interceptionPoints(BigDecimal value) { this.interceptionPoints = value; return this; }
        public Builder rushingYardsPerPoint(BigDecimal value) { this.rushingYardsPerPoint = value; return this; }
        public Builder rushingTouchdownPoints(BigDecimal value) { this.rushingTouchdownPoints = value; return this; }
        public Builder receivingYardsPerPoint(BigDecimal value) { this.receivingYardsPerPoint = value; return this; }
        public Builder receivingTouchdownPoints(BigDecimal value) { this.receivingTouchdownPoints = value; return this; }
        public Builder receptionPoints(BigDecimal value) { this.receptionPoints = value; return this; }
        public Builder fumbleLostPoints(BigDecimal value) { this.fumbleLostPoints = value; return this; }
        public Builder passingYards300Bonus(BigDecimal value) { this.passingYards300Bonus = value; return this; }
        public Builder rushingYards100Bonus(BigDecimal value) { this.rushingYards100Bonus = value; return this; }
        public Builder receivingYards100Bonus(BigDecimal value) { this.receivingYards100Bonus = value; return this; }
        public Builder longTouchdown40Bonus(BigDecimal value) { this.longTouchdown40Bonus = value; return this; }
        public Builder extraPointMadePoints(BigDecimal value) { this.extraPointMadePoints = value; return this; }
        public Builder fieldGoal0to39Points(BigDecimal value) { this.fieldGoal0to39Points = value; return this; }
        public Builder fieldGoal40to49Points(BigDecimal value) { this.fieldGoal40to49Points = value; return this; }
        public Builder fieldGoal50PlusPoints(BigDecimal value) { this.fieldGoal50PlusPoints = value; return this; }
        public Builder sackPoints(BigDecimal value) { this.sackPoints = value; return this; }
        public Builder defensiveInterceptionPoints(BigDecimal value) { this.defensiveInterceptionPoints = value; return this; }
        public Builder fumbleRecoveryPoints(BigDecimal value) { this.fumbleRecoveryPoints = value; return this; }
        public Builder defensiveTouchdownPoints(BigDecimal value) { this.defensiveTouchdownPoints = value; return this; }
        public Builder pointsAllowedScoring(Map<String, BigDecimal> value) { this.pointsAllowedScoring = value; return this; }

        public PPRScoringConfiguration build() {
            return new PPRScoringConfiguration(this);
        }
    }
}
