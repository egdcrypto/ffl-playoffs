package com.ffl.playoffs.domain.model;

/**
 * Enum representing the rounds in the NFL playoffs
 * Maps to the 4-week playoff structure
 */
public enum PlayoffRound {
    WILD_CARD(1, "Wild Card"),
    DIVISIONAL(2, "Divisional"),
    CONFERENCE(3, "Conference Championship"),
    SUPER_BOWL(4, "Super Bowl");

    private final int weekNumber;
    private final String displayName;

    PlayoffRound(int weekNumber, String displayName) {
        this.weekNumber = weekNumber;
        this.displayName = displayName;
    }

    public int getWeekNumber() {
        return weekNumber;
    }

    public String getDisplayName() {
        return displayName;
    }

    /**
     * Get the playoff round for a given week number
     * @param weekNumber the week number (1-4)
     * @return the corresponding PlayoffRound
     * @throws IllegalArgumentException if week number is invalid
     */
    public static PlayoffRound fromWeekNumber(int weekNumber) {
        for (PlayoffRound round : values()) {
            if (round.weekNumber == weekNumber) {
                return round;
            }
        }
        throw new IllegalArgumentException("Invalid playoff week number: " + weekNumber);
    }

    /**
     * Get the next playoff round
     * @return the next round, or null if this is the Super Bowl
     */
    public PlayoffRound getNextRound() {
        if (this == SUPER_BOWL) {
            return null;
        }
        return fromWeekNumber(this.weekNumber + 1);
    }

    /**
     * Check if this is the final round (Super Bowl)
     * @return true if this is the Super Bowl
     */
    public boolean isFinalRound() {
        return this == SUPER_BOWL;
    }
}
