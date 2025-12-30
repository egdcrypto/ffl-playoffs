package com.ffl.playoffs.domain.model;

/**
 * Enum representing field goal distance ranges for scoring tiers
 */
public enum FieldGoalDistanceRange {
    RANGE_0_39("0-39 yards", 0, 39),
    RANGE_40_49("40-49 yards", 40, 49),
    RANGE_50_PLUS("50+ yards", 50, Integer.MAX_VALUE);

    private final String displayName;
    private final int minYards;
    private final int maxYards;

    FieldGoalDistanceRange(String displayName, int minYards, int maxYards) {
        this.displayName = displayName;
        this.minYards = minYards;
        this.maxYards = maxYards;
    }

    public String getDisplayName() {
        return displayName;
    }

    public int getMinYards() {
        return minYards;
    }

    public int getMaxYards() {
        return maxYards;
    }

    /**
     * Determines which distance range a field goal falls into
     * @param yards the distance of the field goal in yards
     * @return the corresponding distance range
     * @throws IllegalArgumentException if yards is negative
     */
    public static FieldGoalDistanceRange fromDistance(int yards) {
        if (yards < 0) {
            throw new IllegalArgumentException("Field goal distance cannot be negative: " + yards);
        }
        if (yards < 40) {
            return RANGE_0_39;
        } else if (yards < 50) {
            return RANGE_40_49;
        } else {
            return RANGE_50_PLUS;
        }
    }

    /**
     * Checks if a distance falls within this range
     * @param yards the distance to check
     * @return true if the distance is within this range
     */
    public boolean contains(int yards) {
        return yards >= minYards && yards <= maxYards;
    }
}
