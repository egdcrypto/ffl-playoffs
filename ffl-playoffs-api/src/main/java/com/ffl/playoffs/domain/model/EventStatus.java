package com.ffl.playoffs.domain.model;

/**
 * Lifecycle status of a world event.
 */
public enum EventStatus {
    SCHEDULED,      // Created but not yet active
    ACTIVE,         // Currently affecting simulation
    EXPIRED,        // Duration completed
    CANCELLED       // Manually cancelled before completion
}
