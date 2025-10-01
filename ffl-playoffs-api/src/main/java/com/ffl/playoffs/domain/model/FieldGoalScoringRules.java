package com.ffl.playoffs.domain.model;

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
     * Creates default field goal scoring rules
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
