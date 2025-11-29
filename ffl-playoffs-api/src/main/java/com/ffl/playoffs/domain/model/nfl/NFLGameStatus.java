package com.ffl.playoffs.domain.model.nfl;

/**
 * NFL Game Status enumeration
 * Represents the various states an NFL game can be in
 * Domain model with no framework dependencies
 */
public enum NFLGameStatus {
    SCHEDULED("Scheduled"),
    IN_PROGRESS("In Progress"),
    HALFTIME("Halftime"),
    FINAL("Final"),
    POSTPONED("Postponed"),
    CANCELLED("Cancelled");

    private final String displayName;

    NFLGameStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    /**
     * Check if the game is active (in progress or at halftime)
     * @return true if game is currently being played
     */
    public boolean isActive() {
        return this == IN_PROGRESS || this == HALFTIME;
    }

    /**
     * Check if the game has completed
     * @return true if game is final
     */
    public boolean isCompleted() {
        return this == FINAL;
    }

    /**
     * Check if the game is still scheduled (not started)
     * @return true if game has not started
     */
    public boolean isScheduled() {
        return this == SCHEDULED;
    }

    /**
     * Check if the game was cancelled or postponed
     * @return true if game was cancelled or postponed
     */
    public boolean isCancelledOrPostponed() {
        return this == CANCELLED || this == POSTPONED;
    }

    /**
     * Convert from string value
     * @param value the string value
     * @return the corresponding NFLGameStatus
     */
    public static NFLGameStatus fromString(String value) {
        if (value == null) {
            return SCHEDULED;
        }
        try {
            return valueOf(value.toUpperCase().replace(" ", "_"));
        } catch (IllegalArgumentException e) {
            return SCHEDULED;
        }
    }
}
