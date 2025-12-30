package com.ffl.playoffs.domain.model;

/**
 * League status enumeration representing the lifecycle states of a league.
 *
 * Lifecycle flow:
 * DRAFT → ACTIVE → COMPLETED → ARCHIVED
 *                ↓ ↑
 *           INACTIVE
 *                ↓ ↑
 *            PAUSED
 *                ↓
 *           CANCELLED
 */
public enum LeagueStatus {
    /**
     * League created but not yet started.
     * Configuration can be modified.
     * Players cannot make team selections.
     */
    DRAFT,

    /**
     * League waiting for minimum players.
     * Configuration can still be modified.
     */
    WAITING_FOR_PLAYERS,

    /**
     * League is in progress.
     * Players can make team selections.
     * Critical configuration is locked.
     */
    ACTIVE,

    /**
     * League has been temporarily deactivated.
     * Players cannot make new selections.
     * Existing selections are preserved.
     * Can be reactivated.
     */
    INACTIVE,

    /**
     * League has been paused by admin.
     * All deadlines are suspended.
     * Players cannot make selections.
     * Scoring calculations are suspended.
     */
    PAUSED,

    /**
     * League has finished all weeks.
     * Final standings are calculated.
     * No further modifications allowed.
     */
    COMPLETED,

    /**
     * League was cancelled before completion.
     * All selections preserved for reference.
     * No further actions allowed.
     */
    CANCELLED,

    /**
     * League has been archived after completion.
     * Data preserved for historical viewing.
     * No modifications allowed.
     */
    ARCHIVED;

    /**
     * Checks if the league is in a state where players can make selections.
     */
    public boolean canAcceptSelections() {
        return this == ACTIVE;
    }

    /**
     * Checks if the league configuration can be modified.
     */
    public boolean canModifyConfiguration() {
        return this == DRAFT || this == WAITING_FOR_PLAYERS;
    }

    /**
     * Checks if the league can be activated.
     */
    public boolean canActivate() {
        return this == DRAFT || this == WAITING_FOR_PLAYERS || this == INACTIVE;
    }

    /**
     * Checks if the league can be deactivated.
     */
    public boolean canDeactivate() {
        return this == ACTIVE;
    }

    /**
     * Checks if the league can be paused.
     */
    public boolean canPause() {
        return this == ACTIVE;
    }

    /**
     * Checks if the league can be resumed.
     */
    public boolean canResume() {
        return this == PAUSED;
    }

    /**
     * Checks if the league can be cancelled.
     */
    public boolean canCancel() {
        return this == DRAFT || this == WAITING_FOR_PLAYERS || this == ACTIVE || this == INACTIVE || this == PAUSED;
    }

    /**
     * Checks if the league can be archived.
     */
    public boolean canArchive() {
        return this == COMPLETED;
    }

    /**
     * Checks if the league can be deleted.
     * Only draft leagues with no players can be deleted.
     */
    public boolean canDelete() {
        return this == DRAFT;
    }

    /**
     * Checks if the league is in a terminal state (no further state transitions allowed).
     */
    public boolean isTerminal() {
        return this == CANCELLED || this == ARCHIVED;
    }
}
