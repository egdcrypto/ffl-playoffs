package com.ffl.playoffs.domain.model;

/**
 * Enum representing the status of a playoff matchup
 */
public enum MatchupStatus {
    SCHEDULED("Scheduled"),
    IN_PROGRESS("In Progress"),
    COMPLETED("Completed"),
    TIED("Tied - Tiebreaker Required");

    private final String displayName;

    MatchupStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }
}
