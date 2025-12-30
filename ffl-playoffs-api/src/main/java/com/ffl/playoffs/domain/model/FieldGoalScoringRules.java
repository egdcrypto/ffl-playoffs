package com.ffl.playoffs.domain.model;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

/**
 * FieldGoalScoringRules Value Object
 * Represents field goal scoring configuration based on kick distance
 * Immutable value object with no framework dependencies
 */
public class FieldGoalScoringRules {
    private final Double fg0to19Points;
    private final Double fg20to29Points;
    private final Double fg30to39Points;
    private final Double fg40to49Points;
    private final Double fg50PlusPoints;
    private final Double extraPointPoints;
    private final Double missedExtraPointPenalty;

    // Constructors
    public FieldGoalScoringRules(Double fg0to19, Double fg20to29, Double fg30to39,
                                 Double fg40to49, Double fg50Plus,
                                 Double extraPoint, Double missedExtraPoint) {
        this.fg0to19Points = fg0to19;
        this.fg20to29Points = fg20to29;
        this.fg30to39Points = fg30to39;
        this.fg40to49Points = fg40to49;
        this.fg50PlusPoints = fg50Plus;
        this.extraPointPoints = extraPoint;
        this.missedExtraPointPenalty = missedExtraPoint;
    }

    /**
     * Creates field goal scoring rules with simplified 3-tier format
     * @param fg0to39Points points for 0-39 yard field goals
     * @param fg40to49Points points for 40-49 yard field goals
     * @param fg50PlusPoints points for 50+ yard field goals
     * @return configured field goal scoring rules
     */
    public static FieldGoalScoringRules withSimplifiedTiers(Double fg0to39Points, Double fg40to49Points, Double fg50PlusPoints) {
        return new FieldGoalScoringRules(
                fg0to39Points,  // 0-19 uses 0-39 value
                fg0to39Points,  // 20-29 uses 0-39 value
                fg0to39Points,  // 30-39 uses 0-39 value
                fg40to49Points, // 40-49
                fg50PlusPoints, // 50+
                1.0,           // Default extra point
                0.0            // Default missed XP penalty
        );
    }

    /**
     * Creates field goal scoring rules with simplified 3-tier format and extra point configuration
     * @param fg0to39Points points for 0-39 yard field goals
     * @param fg40to49Points points for 40-49 yard field goals
     * @param fg50PlusPoints points for 50+ yard field goals
     * @param extraPointPoints points for made extra points
     * @param missedExtraPointPenalty penalty for missed extra points
     * @return configured field goal scoring rules
     */
    public static FieldGoalScoringRules withSimplifiedTiers(
            Double fg0to39Points, Double fg40to49Points, Double fg50PlusPoints,
            Double extraPointPoints, Double missedExtraPointPenalty) {
        return new FieldGoalScoringRules(
                fg0to39Points,
                fg0to39Points,
                fg0to39Points,
                fg40to49Points,
                fg50PlusPoints,
                extraPointPoints,
                missedExtraPointPenalty
        );
    }

    /**
     * Creates default field goal scoring rules
     * Default: 0-39 yards = 3pts, 40-49 = 4pts, 50+ = 5pts
     * @return default field goal scoring configuration
     */
    public static FieldGoalScoringRules defaultRules() {
        return new FieldGoalScoringRules(
                3.0,  // 0-19 yards
                3.0,  // 20-29 yards
                3.0,  // 30-39 yards
                4.0,  // 40-49 yards
                5.0,  // 50+ yards
                1.0,  // Extra point
                0.0   // Missed XP penalty
        );
    }

    /**
     * Gets the points value for a specific distance range (simplified 3-tier)
     * @param range the distance range
     * @return points for that range
     */
    public double getPointsForRange(FieldGoalDistanceRange range) {
        return switch (range) {
            case RANGE_0_39 -> fg0to19Points != null ? fg0to19Points : 0.0; // Uses 0-19 which equals 0-39 in simplified
            case RANGE_40_49 -> fg40to49Points != null ? fg40to49Points : 0.0;
            case RANGE_50_PLUS -> fg50PlusPoints != null ? fg50PlusPoints : 0.0;
        };
    }

    /**
     * Calculates points for a field goal based on distance
     * @param yards distance in yards
     * @return fantasy points earned
     */
    public double calculateFieldGoalPoints(int yards) {
        if (yards < 20) return fg0to19Points != null ? fg0to19Points : 0.0;
        if (yards < 30) return fg20to29Points != null ? fg20to29Points : 0.0;
        if (yards < 40) return fg30to39Points != null ? fg30to39Points : 0.0;
        if (yards < 50) return fg40to49Points != null ? fg40to49Points : 0.0;
        return fg50PlusPoints != null ? fg50PlusPoints : 0.0;
    }

    /**
     * Calculates points for extra point attempts
     * @param made number of extra points made
     * @param missed number of extra points missed
     * @return fantasy points earned (or lost)
     */
    public double calculateExtraPointPoints(int made, int missed) {
        double points = 0.0;
        if (extraPointPoints != null) points += made * extraPointPoints;
        if (missedExtraPointPenalty != null) points -= missed * missedExtraPointPenalty;
        return points;
    }

    /**
     * Calculates total points for a list of field goal attempts
     * Only made field goals are counted
     * @param attempts list of field goal attempts
     * @return total fantasy points earned
     */
    public double calculateTotalPoints(List<FieldGoalAttempt> attempts) {
        if (attempts == null || attempts.isEmpty()) {
            return 0.0;
        }
        return attempts.stream()
                .filter(FieldGoalAttempt::isMade)
                .mapToDouble(attempt -> calculateFieldGoalPoints(attempt.getDistanceYards()))
                .sum();
    }

    /**
     * Calculates a breakdown of field goal points by distance range
     * @param attempts list of field goal attempts
     * @return map with range -> {count, pointsPerFg, total} for each tier
     */
    public Map<FieldGoalDistanceRange, FieldGoalRangeBreakdown> calculateBreakdown(List<FieldGoalAttempt> attempts) {
        Map<FieldGoalDistanceRange, FieldGoalRangeBreakdown> breakdown = new HashMap<>();

        // Initialize all ranges
        for (FieldGoalDistanceRange range : FieldGoalDistanceRange.values()) {
            breakdown.put(range, new FieldGoalRangeBreakdown(range, 0, getPointsForRange(range), 0.0));
        }

        if (attempts == null || attempts.isEmpty()) {
            return breakdown;
        }

        // Count made field goals in each range
        for (FieldGoalAttempt attempt : attempts) {
            if (attempt.isMade()) {
                FieldGoalDistanceRange range = attempt.getDistanceRange();
                FieldGoalRangeBreakdown current = breakdown.get(range);
                double pointsPerFg = getPointsForRange(range);
                breakdown.put(range, new FieldGoalRangeBreakdown(
                        range,
                        current.getCount() + 1,
                        pointsPerFg,
                        current.getTotal() + pointsPerFg
                ));
            }
        }

        return breakdown;
    }

    /**
     * Inner class representing the breakdown for a single distance range
     */
    public static class FieldGoalRangeBreakdown {
        private final FieldGoalDistanceRange range;
        private final int count;
        private final double pointsPerFg;
        private final double total;

        public FieldGoalRangeBreakdown(FieldGoalDistanceRange range, int count, double pointsPerFg, double total) {
            this.range = range;
            this.count = count;
            this.pointsPerFg = pointsPerFg;
            this.total = total;
        }

        public FieldGoalDistanceRange getRange() {
            return range;
        }

        public int getCount() {
            return count;
        }

        public double getPointsPerFg() {
            return pointsPerFg;
        }

        public double getTotal() {
            return total;
        }
    }

    // Getters (immutable - no setters)
    public Double getFg0to19Points() {
        return fg0to19Points;
    }

    public Double getFg20to29Points() {
        return fg20to29Points;
    }

    public Double getFg30to39Points() {
        return fg30to39Points;
    }

    public Double getFg40to49Points() {
        return fg40to49Points;
    }

    public Double getFg50PlusPoints() {
        return fg50PlusPoints;
    }

    public Double getExtraPointPoints() {
        return extraPointPoints;
    }

    public Double getMissedExtraPointPenalty() {
        return missedExtraPointPenalty;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        FieldGoalScoringRules that = (FieldGoalScoringRules) o;

        if (fg0to19Points != null ? !fg0to19Points.equals(that.fg0to19Points) : that.fg0to19Points != null)
            return false;
        if (fg20to29Points != null ? !fg20to29Points.equals(that.fg20to29Points) : that.fg20to29Points != null)
            return false;
        if (fg30to39Points != null ? !fg30to39Points.equals(that.fg30to39Points) : that.fg30to39Points != null)
            return false;
        if (fg40to49Points != null ? !fg40to49Points.equals(that.fg40to49Points) : that.fg40to49Points != null)
            return false;
        if (fg50PlusPoints != null ? !fg50PlusPoints.equals(that.fg50PlusPoints) : that.fg50PlusPoints != null)
            return false;
        if (extraPointPoints != null ? !extraPointPoints.equals(that.extraPointPoints) : that.extraPointPoints != null)
            return false;
        return missedExtraPointPenalty != null ? missedExtraPointPenalty.equals(that.missedExtraPointPenalty) : that.missedExtraPointPenalty == null;
    }

    @Override
    public int hashCode() {
        int result = fg0to19Points != null ? fg0to19Points.hashCode() : 0;
        result = 31 * result + (fg20to29Points != null ? fg20to29Points.hashCode() : 0);
        result = 31 * result + (fg30to39Points != null ? fg30to39Points.hashCode() : 0);
        result = 31 * result + (fg40to49Points != null ? fg40to49Points.hashCode() : 0);
        result = 31 * result + (fg50PlusPoints != null ? fg50PlusPoints.hashCode() : 0);
        result = 31 * result + (extraPointPoints != null ? extraPointPoints.hashCode() : 0);
        result = 31 * result + (missedExtraPointPenalty != null ? missedExtraPointPenalty.hashCode() : 0);
        return result;
    }
}
