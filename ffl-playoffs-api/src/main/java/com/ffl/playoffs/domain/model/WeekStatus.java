package com.ffl.playoffs.domain.model;

/**
 * Week Status enumeration
 * Represents the lifecycle stages of a game week
 */
public enum WeekStatus {
    /**
     * Week has not started yet
     */
    UPCOMING,

    /**
     * Selections are open, before deadline
     */
    ACTIVE,

    /**
     * Deadline passed, games in progress
     */
    LOCKED,

    /**
     * All games finished, scores calculated
     */
    COMPLETED
}
