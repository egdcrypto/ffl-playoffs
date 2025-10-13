package com.ffl.playoffs.domain.model;

import java.util.Map;
import java.util.TreeMap;

/**
 * DefensiveScoringRules Value Object
 * Represents team defense/special teams scoring configuration
 * Includes tiered scoring for points and yards allowed
 * Immutable value object with no framework dependencies
 */
public class DefensiveScoringRules {
    private final Double sackPoints;
    private final Double interceptionPoints;
    private final Double fumbleRecoveryPoints;
    private final Double safetyPoints;
    private final Double defensiveTouchdownPoints;
    private final Double blockedKickPoints;
    private final Double kickReturnTouchdownPoints;
    private final Double puntReturnTouchdownPoints;

    // Tiered scoring: Map<MaxPoints, FantasyPoints>
    // Example: {0=10.0, 6=7.0, 13=4.0, ...}
    private final Map<Integer, Double> pointsAllowedTiers;
    private final Map<Integer, Double> yardsAllowedTiers;

    // Constructors
    public DefensiveScoringRules(Double sacks, Double interceptions, Double fumbles,
                                 Double safeties, Double touchdowns, Double blockedKicks,
                                 Double kickReturnTDs, Double puntReturnTDs,
                                 Map<Integer, Double> pointsTiers,
                                 Map<Integer, Double> yardsTiers) {
        this.sackPoints = sacks;
        this.interceptionPoints = interceptions;
        this.fumbleRecoveryPoints = fumbles;
        this.safetyPoints = safeties;
        this.defensiveTouchdownPoints = touchdowns;
        this.blockedKickPoints = blockedKicks;
        this.kickReturnTouchdownPoints = kickReturnTDs;
        this.puntReturnTouchdownPoints = puntReturnTDs;
        // Use TreeMap to maintain sorted order
        this.pointsAllowedTiers = pointsTiers != null ? new TreeMap<>(pointsTiers) : new TreeMap<>();
        this.yardsAllowedTiers = yardsTiers != null ? new TreeMap<>(yardsTiers) : new TreeMap<>();
    }

    /**
     * Creates default defensive scoring rules
     * @return default defensive scoring configuration
     */
    public static DefensiveScoringRules defaultRules() {
        Map<Integer, Double> pointsTiers = new TreeMap<>();
        pointsTiers.put(0, 10.0);      // 0 points allowed = +10
        pointsTiers.put(6, 7.0);       // 1-6 points = +7
        pointsTiers.put(13, 4.0);      // 7-13 points = +4
        pointsTiers.put(20, 1.0);      // 14-20 points = +1
        pointsTiers.put(27, 0.0);      // 21-27 points = 0
        pointsTiers.put(34, -1.0);     // 28-34 points = -1
        pointsTiers.put(999, -4.0);    // 35+ points = -4

        Map<Integer, Double> yardsTiers = new TreeMap<>();
        yardsTiers.put(99, 5.0);       // < 100 yards = +5
        yardsTiers.put(199, 3.0);      // 100-199 yards = +3
        yardsTiers.put(299, 2.0);      // 200-299 yards = +2
        yardsTiers.put(399, 0.0);      // 300-399 yards = 0
        yardsTiers.put(449, -1.0);     // 400-449 yards = -1
        yardsTiers.put(499, -3.0);     // 450-499 yards = -3
        yardsTiers.put(999, -5.0);     // 500+ yards = -5

        return new DefensiveScoringRules(
                1.0,  // Sack
                2.0,  // Interception
                2.0,  // Fumble recovery
                2.0,  // Safety
                6.0,  // Defensive/ST TD
                2.0,  // Blocked kick
                6.0,  // Kick return TD
                6.0,  // Punt return TD
                pointsTiers,
                yardsTiers
        );
    }

    /**
     * Calculates defensive/special teams fantasy points
     * @param stats defensive statistics
     * @return total fantasy points
     */
    public double calculatePoints(int sacks, int ints, int fumbles, int safeties,
                                 int defensiveTDs, int blockedKicks,
                                 int kickReturnTDs, int puntReturnTDs,
                                 int pointsAllowed, int yardsAllowed) {
        double points = 0.0;

        // Individual stat points
        if (sackPoints != null) points += sacks * sackPoints;
        if (interceptionPoints != null) points += ints * interceptionPoints;
        if (fumbleRecoveryPoints != null) points += fumbles * fumbleRecoveryPoints;
        if (safetyPoints != null) points += safeties * safetyPoints;
        if (defensiveTouchdownPoints != null) points += defensiveTDs * defensiveTouchdownPoints;
        if (blockedKickPoints != null) points += blockedKicks * blockedKickPoints;
        if (kickReturnTouchdownPoints != null) points += kickReturnTDs * kickReturnTouchdownPoints;
        if (puntReturnTouchdownPoints != null) points += puntReturnTDs * puntReturnTouchdownPoints;

        // Tiered points allowed scoring
        points += calculateTieredPoints(pointsAllowedTiers, pointsAllowed);

        // Tiered yards allowed scoring
        points += calculateTieredPoints(yardsAllowedTiers, yardsAllowed);

        return points;
    }

    /**
     * Calculates points from tiered scoring system
     * @param tiers map of threshold -> points
     * @param value actual stat value
     * @return fantasy points from tier
     */
    private double calculateTieredPoints(Map<Integer, Double> tiers, int value) {
        if (tiers == null || tiers.isEmpty()) return 0.0;

        // Find the appropriate tier
        for (Map.Entry<Integer, Double> entry : tiers.entrySet()) {
            if (value <= entry.getKey()) {
                return entry.getValue();
            }
        }

        // If no tier found, use the highest tier value
        return tiers.values().stream().reduce((first, second) -> second).orElse(0.0);
    }

    // Getters (immutable - no setters)
    public Double getSackPoints() {
        return sackPoints;
    }

    public Double getInterceptionPoints() {
        return interceptionPoints;
    }

    public Double getFumbleRecoveryPoints() {
        return fumbleRecoveryPoints;
    }

    public Double getSafetyPoints() {
        return safetyPoints;
    }

    public Double getDefensiveTouchdownPoints() {
        return defensiveTouchdownPoints;
    }

    public Double getBlockedKickPoints() {
        return blockedKickPoints;
    }

    public Double getKickReturnTouchdownPoints() {
        return kickReturnTouchdownPoints;
    }

    public Double getPuntReturnTouchdownPoints() {
        return puntReturnTouchdownPoints;
    }

    public Map<Integer, Double> getPointsAllowedTiers() {
        return new TreeMap<>(pointsAllowedTiers);  // Return defensive copy
    }

    public Map<Integer, Double> getYardsAllowedTiers() {
        return new TreeMap<>(yardsAllowedTiers);  // Return defensive copy
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        DefensiveScoringRules that = (DefensiveScoringRules) o;

        if (sackPoints != null ? !sackPoints.equals(that.sackPoints) : that.sackPoints != null) return false;
        if (interceptionPoints != null ? !interceptionPoints.equals(that.interceptionPoints) : that.interceptionPoints != null)
            return false;
        if (fumbleRecoveryPoints != null ? !fumbleRecoveryPoints.equals(that.fumbleRecoveryPoints) : that.fumbleRecoveryPoints != null)
            return false;
        if (safetyPoints != null ? !safetyPoints.equals(that.safetyPoints) : that.safetyPoints != null) return false;
        if (defensiveTouchdownPoints != null ? !defensiveTouchdownPoints.equals(that.defensiveTouchdownPoints) : that.defensiveTouchdownPoints != null)
            return false;
        if (blockedKickPoints != null ? !blockedKickPoints.equals(that.blockedKickPoints) : that.blockedKickPoints != null)
            return false;
        if (kickReturnTouchdownPoints != null ? !kickReturnTouchdownPoints.equals(that.kickReturnTouchdownPoints) : that.kickReturnTouchdownPoints != null)
            return false;
        if (puntReturnTouchdownPoints != null ? !puntReturnTouchdownPoints.equals(that.puntReturnTouchdownPoints) : that.puntReturnTouchdownPoints != null)
            return false;
        if (!pointsAllowedTiers.equals(that.pointsAllowedTiers)) return false;
        return yardsAllowedTiers.equals(that.yardsAllowedTiers);
    }

    @Override
    public int hashCode() {
        int result = sackPoints != null ? sackPoints.hashCode() : 0;
        result = 31 * result + (interceptionPoints != null ? interceptionPoints.hashCode() : 0);
        result = 31 * result + (fumbleRecoveryPoints != null ? fumbleRecoveryPoints.hashCode() : 0);
        result = 31 * result + (safetyPoints != null ? safetyPoints.hashCode() : 0);
        result = 31 * result + (defensiveTouchdownPoints != null ? defensiveTouchdownPoints.hashCode() : 0);
        result = 31 * result + (blockedKickPoints != null ? blockedKickPoints.hashCode() : 0);
        result = 31 * result + (kickReturnTouchdownPoints != null ? kickReturnTouchdownPoints.hashCode() : 0);
        result = 31 * result + (puntReturnTouchdownPoints != null ? puntReturnTouchdownPoints.hashCode() : 0);
        result = 31 * result + pointsAllowedTiers.hashCode();
        result = 31 * result + yardsAllowedTiers.hashCode();
        return result;
    }
}
