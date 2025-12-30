package com.ffl.playoffs.domain.model;

/**
 * Represents the status of a roster in the one-time draft model
 *
 * UNLOCKED - Roster can be modified (before first game)
 * LOCKED - Roster is complete and permanently locked
 * LOCKED_INCOMPLETE - Roster is incomplete but permanently locked (player will score 0 for empty positions)
 */
public enum RosterStatus {

    /**
     * Roster is unlocked and can be modified
     * This is the initial state before the first game starts
     */
    UNLOCKED("Unlocked", "Roster can be modified"),

    /**
     * Roster is complete and permanently locked
     * All positions are filled, no changes allowed
     */
    LOCKED("Locked", "Roster locked for the season"),

    /**
     * Roster is incomplete but permanently locked
     * Some positions are empty, player will score 0 for those positions all season
     */
    LOCKED_INCOMPLETE("Locked (Incomplete)", "Roster locked with empty positions - 0 points for missing positions");

    private final String displayName;
    private final String description;

    RosterStatus(String displayName, String description) {
        this.displayName = displayName;
        this.description = description;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getDescription() {
        return description;
    }

    /**
     * Check if roster is locked (either complete or incomplete)
     */
    public boolean isLocked() {
        return this == LOCKED || this == LOCKED_INCOMPLETE;
    }

    /**
     * Check if roster is complete (all positions filled)
     */
    public boolean isComplete() {
        return this == LOCKED;
    }

    /**
     * Determine the appropriate status when locking a roster
     * @param isComplete whether all roster positions are filled
     * @return LOCKED if complete, LOCKED_INCOMPLETE if not
     */
    public static RosterStatus lockStatus(boolean isComplete) {
        return isComplete ? LOCKED : LOCKED_INCOMPLETE;
    }
}
