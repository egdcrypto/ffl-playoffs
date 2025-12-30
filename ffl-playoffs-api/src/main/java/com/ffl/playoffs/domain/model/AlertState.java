package com.ffl.playoffs.domain.model;

/**
 * Alert state enumeration
 * Defines the current state of an alert
 */
public enum AlertState {
    /**
     * Alert condition has been met, waiting for duration threshold
     */
    PENDING,

    /**
     * Alert is actively firing
     */
    FIRING,

    /**
     * Alert condition is no longer met
     */
    RESOLVED,

    /**
     * Alert is acknowledged but not yet resolved
     */
    ACKNOWLEDGED,

    /**
     * Alert is temporarily silenced
     */
    SILENCED
}
