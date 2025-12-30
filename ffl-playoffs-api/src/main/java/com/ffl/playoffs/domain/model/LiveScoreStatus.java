package com.ffl.playoffs.domain.model;

/**
 * Live Score Status enumeration
 * Represents the current state of a player's score during live updates
 * Domain model with no framework dependencies
 */
public enum LiveScoreStatus {
    LIVE("Live"),
    FINAL("Final"),
    SUSPENDED("Suspended"),
    PARTIAL("Partial"),
    DELAYED("Delayed");

    private final String displayName;

    LiveScoreStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    /**
     * Check if the score is still being updated
     * @return true if score is live and updates are expected
     */
    public boolean isUpdating() {
        return this == LIVE || this == PARTIAL || this == DELAYED;
    }

    /**
     * Check if the score is finalized and locked
     * @return true if score is final
     */
    public boolean isFinal() {
        return this == FINAL;
    }

    /**
     * Check if there are issues with the score data
     * @return true if score data has issues
     */
    public boolean hasIssues() {
        return this == SUSPENDED || this == PARTIAL || this == DELAYED;
    }
}
