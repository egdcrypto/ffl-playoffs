package com.ffl.playoffs.domain.model;

/**
 * Represents the lock status of a roster in the one-time draft model.
 * Once rosters are locked (at the deadline), no changes are allowed for the entire season.
 */
public enum RosterLockStatus {

    /**
     * Roster is not locked - player can still make changes.
     * This is the initial state before the roster lock deadline.
     */
    UNLOCKED("Roster is open for changes"),

    /**
     * Roster is locked with all positions filled.
     * Player has a complete roster and will score points for all positions.
     */
    LOCKED("Roster locked for the season"),

    /**
     * Roster is locked but has unfilled positions.
     * Player will score 0 points for missing positions throughout the season.
     */
    LOCKED_INCOMPLETE("Roster locked with missing positions");

    private final String displayMessage;

    RosterLockStatus(String displayMessage) {
        this.displayMessage = displayMessage;
    }

    public String getDisplayMessage() {
        return displayMessage;
    }

    /**
     * Check if the roster is in any locked state (complete or incomplete)
     * @return true if roster is locked
     */
    public boolean isLocked() {
        return this == LOCKED || this == LOCKED_INCOMPLETE;
    }

    /**
     * Check if the roster can be modified
     * @return true if roster changes are allowed
     */
    public boolean canModify() {
        return this == UNLOCKED;
    }
}
