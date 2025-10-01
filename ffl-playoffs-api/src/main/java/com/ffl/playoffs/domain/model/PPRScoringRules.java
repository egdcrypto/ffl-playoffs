package com.ffl.playoffs.domain.model;

/**
 * PPRScoringRules Value Object
 * Represents Points Per Reception scoring configuration
 * Supports full PPR, half PPR, or custom reception scoring
 * Immutable value object with no framework dependencies
 */
public class PPRScoringRules {
    private final Double receptionPoints;
    private final Double rushingYardsPerPoint;
    private final Double receivingYardsPerPoint;
    private final Double rushingTouchdownPoints;
    private final Double receivingTouchdownPoints;
    private final Double twoPointConversionPoints;
    private final Double fumbleLostPenalty;

    public enum PPRType {
        STANDARD,   // 0 points per reception
        HALF_PPR,   // 0.5 points per reception
        FULL_PPR    // 1.0 point per reception
    }

    // Constructors
    public PPRScoringRules(Double receptionPoints, Double rushYardsPerPt, Double recYardsPerPt,
                          Double rushTD, Double recTD, Double twoPoint, Double fumble) {
        this.receptionPoints = receptionPoints;
        this.rushingYardsPerPoint = rushYardsPerPt;
        this.receivingYardsPerPoint = recYardsPerPt;
        this.rushingTouchdownPoints = rushTD;
        this.receivingTouchdownPoints = recTD;
        this.twoPointConversionPoints = twoPoint;
        this.fumbleLostPenalty = fumble;
    }

    /**
     * Creates standard (non-PPR) scoring rules
     * @return standard scoring configuration
     */
    public static PPRScoringRules standardRules() {
        return new PPRScoringRules(
                0.0,   // No PPR
                10.0,  // 1 point per 10 rushing yards
                10.0,  // 1 point per 10 receiving yards
                6.0,   // Rushing TD
                6.0,   // Receiving TD
                2.0,   // 2-point conversion
                2.0    // Fumble lost penalty
        );
    }

    /**
     * Creates half PPR scoring rules
     * @return half PPR scoring configuration
     */
    public static PPRScoringRules halfPPRRules() {
        return new PPRScoringRules(
                0.5,   // 0.5 points per reception
                10.0,  // 1 point per 10 rushing yards
                10.0,  // 1 point per 10 receiving yards
                6.0,   // Rushing TD
                6.0,   // Receiving TD
                2.0,   // 2-point conversion
                2.0    // Fumble lost penalty
        );
    }

    /**
     * Creates full PPR scoring rules
     * @return full PPR scoring configuration
     */
    public static PPRScoringRules fullPPRRules() {
        return new PPRScoringRules(
                1.0,   // 1 point per reception
                10.0,  // 1 point per 10 rushing yards
                10.0,  // 1 point per 10 receiving yards
                6.0,   // Rushing TD
                6.0,   // Receiving TD
                2.0,   // 2-point conversion
                2.0    // Fumble lost penalty
        );
    }

    /**
     * Creates scoring rules by PPR type
     * @param type the PPR type
     * @return corresponding scoring configuration
     */
    public static PPRScoringRules byType(PPRType type) {
        switch (type) {
            case FULL_PPR:
                return fullPPRRules();
            case HALF_PPR:
                return halfPPRRules();
            case STANDARD:
            default:
                return standardRules();
        }
    }

    /**
     * Calculates offensive fantasy points (RB/WR/TE positions)
     * @param rushYards rushing yards
     * @param rushTDs rushing touchdowns
     * @param receptions number of receptions
     * @param recYards receiving yards
     * @param recTDs receiving touchdowns
     * @param twoPointConversions two-point conversions
     * @param fumblesLost fumbles lost
     * @return total fantasy points
     */
    public double calculatePoints(int rushYards, int rushTDs, int receptions,
                                 int recYards, int recTDs, int twoPointConversions,
                                 int fumblesLost) {
        double points = 0.0;

        // Rushing
        if (rushingYardsPerPoint != null && rushingYardsPerPoint > 0) {
            points += rushYards / rushingYardsPerPoint;
        }
        if (rushingTouchdownPoints != null) {
            points += rushTDs * rushingTouchdownPoints;
        }

        // Receiving
        if (receptionPoints != null) {
            points += receptions * receptionPoints;  // PPR component
        }
        if (receivingYardsPerPoint != null && receivingYardsPerPoint > 0) {
            points += recYards / receivingYardsPerPoint;
        }
        if (receivingTouchdownPoints != null) {
            points += recTDs * receivingTouchdownPoints;
        }

        // Other
        if (twoPointConversionPoints != null) {
            points += twoPointConversions * twoPointConversionPoints;
        }
        if (fumbleLostPenalty != null) {
            points -= fumblesLost * fumbleLostPenalty;
        }

        return points;
    }

    /**
     * Gets the PPR type based on reception points
     * @return PPR type
     */
    public PPRType getPPRType() {
        if (receptionPoints == null || receptionPoints == 0.0) {
            return PPRType.STANDARD;
        } else if (receptionPoints == 0.5) {
            return PPRType.HALF_PPR;
        } else if (receptionPoints == 1.0) {
            return PPRType.FULL_PPR;
        } else {
            // Custom PPR value
            return null;
        }
    }

    /**
     * Checks if this is full PPR scoring
     * @return true if full PPR
     */
    public boolean isFullPPR() {
        return receptionPoints != null && receptionPoints == 1.0;
    }

    /**
     * Checks if this is half PPR scoring
     * @return true if half PPR
     */
    public boolean isHalfPPR() {
        return receptionPoints != null && receptionPoints == 0.5;
    }

    /**
     * Checks if this is standard (non-PPR) scoring
     * @return true if standard
     */
    public boolean isStandard() {
        return receptionPoints == null || receptionPoints == 0.0;
    }

    // Getters (immutable - no setters)
    public Double getReceptionPoints() {
        return receptionPoints;
    }

    public Double getRushingYardsPerPoint() {
        return rushingYardsPerPoint;
    }

    public Double getReceivingYardsPerPoint() {
        return receivingYardsPerPoint;
    }

    public Double getRushingTouchdownPoints() {
        return rushingTouchdownPoints;
    }

    public Double getReceivingTouchdownPoints() {
        return receivingTouchdownPoints;
    }

    public Double getTwoPointConversionPoints() {
        return twoPointConversionPoints;
    }

    public Double getFumbleLostPenalty() {
        return fumbleLostPenalty;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        PPRScoringRules that = (PPRScoringRules) o;

        if (receptionPoints != null ? !receptionPoints.equals(that.receptionPoints) : that.receptionPoints != null)
            return false;
        if (rushingYardsPerPoint != null ? !rushingYardsPerPoint.equals(that.rushingYardsPerPoint) : that.rushingYardsPerPoint != null)
            return false;
        if (receivingYardsPerPoint != null ? !receivingYardsPerPoint.equals(that.receivingYardsPerPoint) : that.receivingYardsPerPoint != null)
            return false;
        if (rushingTouchdownPoints != null ? !rushingTouchdownPoints.equals(that.rushingTouchdownPoints) : that.rushingTouchdownPoints != null)
            return false;
        if (receivingTouchdownPoints != null ? !receivingTouchdownPoints.equals(that.receivingTouchdownPoints) : that.receivingTouchdownPoints != null)
            return false;
        if (twoPointConversionPoints != null ? !twoPointConversionPoints.equals(that.twoPointConversionPoints) : that.twoPointConversionPoints != null)
            return false;
        return fumbleLostPenalty != null ? fumbleLostPenalty.equals(that.fumbleLostPenalty) : that.fumbleLostPenalty == null;
    }

    @Override
    public int hashCode() {
        int result = receptionPoints != null ? receptionPoints.hashCode() : 0;
        result = 31 * result + (rushingYardsPerPoint != null ? rushingYardsPerPoint.hashCode() : 0);
        result = 31 * result + (receivingYardsPerPoint != null ? receivingYardsPerPoint.hashCode() : 0);
        result = 31 * result + (rushingTouchdownPoints != null ? rushingTouchdownPoints.hashCode() : 0);
        result = 31 * result + (receivingTouchdownPoints != null ? receivingTouchdownPoints.hashCode() : 0);
        result = 31 * result + (twoPointConversionPoints != null ? twoPointConversionPoints.hashCode() : 0);
        result = 31 * result + (fumbleLostPenalty != null ? fumbleLostPenalty.hashCode() : 0);
        return result;
    }
}
