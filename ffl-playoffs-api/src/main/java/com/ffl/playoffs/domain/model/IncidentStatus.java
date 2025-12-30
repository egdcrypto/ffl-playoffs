package com.ffl.playoffs.domain.model;

/**
 * Incident status enumeration
 * Defines the lifecycle states of an incident
 */
public enum IncidentStatus {
    /**
     * Incident has been opened but not yet acknowledged
     */
    OPEN,

    /**
     * Incident has been acknowledged by on-call
     */
    ACKNOWLEDGED,

    /**
     * Incident is being actively investigated
     */
    INVESTIGATING,

    /**
     * Incident has been mitigated but not fully resolved
     */
    MITIGATED,

    /**
     * Incident has been fully resolved
     */
    RESOLVED,

    /**
     * Post-incident review completed
     */
    CLOSED
}
