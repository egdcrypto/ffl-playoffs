package com.ffl.playoffs.domain.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

/**
 * Comprehensive ScoringRules Value Object
 * Aggregates all scoring configurations for a league:
 * - PPR scoring (rushing, receiving, receptions)
 * - Passing scoring (passing yards, touchdowns, interceptions)
 * - Field goal scoring (tiered by distance)
 * - Defensive scoring (sacks, turnovers, points allowed)
 *
 * Immutable value object with no framework dependencies (except Lombok).
 */
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ScoringRules {

    // Passing scoring
    private Double passingYardsPerPoint;      // e.g., 25 = 1 point per 25 yards
    private Double passingTouchdownPoints;
    private Double interceptionPenalty;

    // PPR scoring component
    private PPRScoringRules pprScoringRules;

    // Field goal scoring component
    private FieldGoalScoringRules fieldGoalScoringRules;

    // Defensive scoring component
    private DefensiveScoringRules defensiveScoringRules;

    // Legacy fields for backwards compatibility
    private Integer touchdownPoints;
    private Integer fieldGoalPoints;
    private Integer safetyPoints;
    private Integer extraPointPoints;
    private Integer twoPointConversionPoints;

    /**
     * Creates default PPR scoring rules suitable for most fantasy leagues.
     * Defaults:
     * - Passing: 25 yards per point, 4 pts per TD, -2 for INT
     * - PPR: Full PPR (1 point per reception)
     * - Field Goals: Standard tiered scoring
     * - Defense: Standard defensive scoring with points allowed tiers
     *
     * @return default scoring configuration
     */
    public static ScoringRules defaultRules() {
        return ScoringRules.builder()
                .passingYardsPerPoint(25.0)
                .passingTouchdownPoints(4.0)
                .interceptionPenalty(2.0)
                .pprScoringRules(PPRScoringRules.fullPPRRules())
                .fieldGoalScoringRules(FieldGoalScoringRules.defaultRules())
                .defensiveScoringRules(DefensiveScoringRules.defaultRules())
                // Legacy fields
                .touchdownPoints(6)
                .fieldGoalPoints(3)
                .safetyPoints(2)
                .extraPointPoints(1)
                .twoPointConversionPoints(2)
                .build();
    }

    /**
     * Creates standard (non-PPR) scoring rules.
     *
     * @return standard scoring configuration
     */
    public static ScoringRules standardRules() {
        return ScoringRules.builder()
                .passingYardsPerPoint(25.0)
                .passingTouchdownPoints(4.0)
                .interceptionPenalty(2.0)
                .pprScoringRules(PPRScoringRules.standardRules())
                .fieldGoalScoringRules(FieldGoalScoringRules.defaultRules())
                .defensiveScoringRules(DefensiveScoringRules.defaultRules())
                .touchdownPoints(6)
                .fieldGoalPoints(3)
                .safetyPoints(2)
                .extraPointPoints(1)
                .twoPointConversionPoints(2)
                .build();
    }

    /**
     * Creates half-PPR scoring rules.
     *
     * @return half PPR scoring configuration
     */
    public static ScoringRules halfPPRRules() {
        return ScoringRules.builder()
                .passingYardsPerPoint(25.0)
                .passingTouchdownPoints(4.0)
                .interceptionPenalty(2.0)
                .pprScoringRules(PPRScoringRules.halfPPRRules())
                .fieldGoalScoringRules(FieldGoalScoringRules.defaultRules())
                .defensiveScoringRules(DefensiveScoringRules.defaultRules())
                .touchdownPoints(6)
                .fieldGoalPoints(3)
                .safetyPoints(2)
                .extraPointPoints(1)
                .twoPointConversionPoints(2)
                .build();
    }

    /**
     * Builder method to create custom scoring rules with PPR configuration.
     *
     * @param passingYardsPerPoint yards needed for 1 point
     * @param rushingYardsPerPoint yards needed for 1 point
     * @param receivingYardsPerPoint yards needed for 1 point
     * @param receptionPoints points per reception (PPR)
     * @param touchdownPoints points per touchdown
     * @return custom scoring configuration
     */
    public static ScoringRules custom(
            Double passingYardsPerPoint,
            Double rushingYardsPerPoint,
            Double receivingYardsPerPoint,
            Double receptionPoints,
            Double touchdownPoints) {

        PPRScoringRules ppr = new PPRScoringRules(
                receptionPoints,
                rushingYardsPerPoint,
                receivingYardsPerPoint,
                touchdownPoints,  // rushing TD
                touchdownPoints,  // receiving TD
                2.0,              // 2-point conversion
                2.0               // fumble penalty
        );

        return ScoringRules.builder()
                .passingYardsPerPoint(passingYardsPerPoint)
                .passingTouchdownPoints(touchdownPoints)
                .interceptionPenalty(2.0)
                .pprScoringRules(ppr)
                .fieldGoalScoringRules(FieldGoalScoringRules.defaultRules())
                .defensiveScoringRules(DefensiveScoringRules.defaultRules())
                .build();
    }

    /**
     * Calculates passing fantasy points.
     *
     * @param passingYards total passing yards
     * @param passingTDs number of passing touchdowns
     * @param interceptions number of interceptions thrown
     * @return fantasy points for passing
     */
    public double calculatePassingPoints(int passingYards, int passingTDs, int interceptions) {
        double points = 0.0;

        if (passingYardsPerPoint != null && passingYardsPerPoint > 0) {
            points += passingYards / passingYardsPerPoint;
        }
        if (passingTouchdownPoints != null) {
            points += passingTDs * passingTouchdownPoints;
        }
        if (interceptionPenalty != null) {
            points -= interceptions * interceptionPenalty;
        }

        return points;
    }

    /**
     * Creates a copy of these scoring rules (for cloning leagues).
     *
     * @return a new ScoringRules instance with the same values
     */
    public ScoringRules copy() {
        return ScoringRules.builder()
                .passingYardsPerPoint(this.passingYardsPerPoint)
                .passingTouchdownPoints(this.passingTouchdownPoints)
                .interceptionPenalty(this.interceptionPenalty)
                .pprScoringRules(this.pprScoringRules)
                .fieldGoalScoringRules(this.fieldGoalScoringRules)
                .defensiveScoringRules(this.defensiveScoringRules)
                .touchdownPoints(this.touchdownPoints)
                .fieldGoalPoints(this.fieldGoalPoints)
                .safetyPoints(this.safetyPoints)
                .extraPointPoints(this.extraPointPoints)
                .twoPointConversionPoints(this.twoPointConversionPoints)
                .build();
    }

    /**
     * Checks if this is a PPR scoring configuration.
     *
     * @return true if PPR scoring is enabled
     */
    public boolean isPPR() {
        return pprScoringRules != null &&
               pprScoringRules.getReceptionPoints() != null &&
               pprScoringRules.getReceptionPoints() > 0;
    }

    /**
     * Gets the reception points value (PPR value).
     *
     * @return reception points or 0 if not PPR
     */
    public Double getReceptionPoints() {
        if (pprScoringRules != null && pprScoringRules.getReceptionPoints() != null) {
            return pprScoringRules.getReceptionPoints();
        }
        return 0.0;
    }

    /**
     * Gets the rushing yards per point.
     *
     * @return rushing yards per point or null
     */
    public Double getRushingYardsPerPoint() {
        if (pprScoringRules != null) {
            return pprScoringRules.getRushingYardsPerPoint();
        }
        return null;
    }

    /**
     * Gets the receiving yards per point.
     *
     * @return receiving yards per point or null
     */
    public Double getReceivingYardsPerPoint() {
        if (pprScoringRules != null) {
            return pprScoringRules.getReceivingYardsPerPoint();
        }
        return null;
    }
}
