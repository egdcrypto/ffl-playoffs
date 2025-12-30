package com.ffl.playoffs.domain.model;

import java.util.Objects;

/**
 * Value object representing a single field goal attempt
 * Immutable value object with no framework dependencies
 */
public class FieldGoalAttempt {
    private final int distanceYards;
    private final FieldGoalResult result;
    private final String kicker;
    private final Integer quarter;

    public FieldGoalAttempt(int distanceYards, FieldGoalResult result) {
        this(distanceYards, result, null, null);
    }

    public FieldGoalAttempt(int distanceYards, FieldGoalResult result, String kicker, Integer quarter) {
        if (distanceYards < 0) {
            throw new IllegalArgumentException("Field goal distance cannot be negative: " + distanceYards);
        }
        this.distanceYards = distanceYards;
        this.result = Objects.requireNonNull(result, "Field goal result cannot be null");
        this.kicker = kicker;
        this.quarter = quarter;
    }

    public int getDistanceYards() {
        return distanceYards;
    }

    public FieldGoalResult getResult() {
        return result;
    }

    public String getKicker() {
        return kicker;
    }

    public Integer getQuarter() {
        return quarter;
    }

    /**
     * Checks if the field goal was made
     * @return true if successful
     */
    public boolean isMade() {
        return result.isSuccessful();
    }

    /**
     * Gets the distance range this attempt falls into
     * @return the distance range
     */
    public FieldGoalDistanceRange getDistanceRange() {
        return FieldGoalDistanceRange.fromDistance(distanceYards);
    }

    /**
     * Creates a made field goal attempt
     * @param distanceYards the distance in yards
     * @return a new FieldGoalAttempt with MADE result
     */
    public static FieldGoalAttempt made(int distanceYards) {
        return new FieldGoalAttempt(distanceYards, FieldGoalResult.MADE);
    }

    /**
     * Creates a missed field goal attempt
     * @param distanceYards the distance in yards
     * @return a new FieldGoalAttempt with MISSED result
     */
    public static FieldGoalAttempt missed(int distanceYards) {
        return new FieldGoalAttempt(distanceYards, FieldGoalResult.MISSED);
    }

    /**
     * Creates a blocked field goal attempt
     * @param distanceYards the distance in yards
     * @return a new FieldGoalAttempt with BLOCKED result
     */
    public static FieldGoalAttempt blocked(int distanceYards) {
        return new FieldGoalAttempt(distanceYards, FieldGoalResult.BLOCKED);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        FieldGoalAttempt that = (FieldGoalAttempt) o;
        return distanceYards == that.distanceYards &&
                result == that.result &&
                Objects.equals(kicker, that.kicker) &&
                Objects.equals(quarter, that.quarter);
    }

    @Override
    public int hashCode() {
        return Objects.hash(distanceYards, result, kicker, quarter);
    }

    @Override
    public String toString() {
        return String.format("FieldGoalAttempt{%d yards, %s}", distanceYards, result);
    }
}
