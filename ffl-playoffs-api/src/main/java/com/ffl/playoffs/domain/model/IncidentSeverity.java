package com.ffl.playoffs.domain.model;

/**
 * Incident severity enumeration
 * Defines the severity level of an incident
 */
public enum IncidentSeverity {
    /**
     * SEV1 - Critical incident affecting all users
     */
    SEV1,

    /**
     * SEV2 - Major incident affecting many users
     */
    SEV2,

    /**
     * SEV3 - Minor incident affecting some users
     */
    SEV3,

    /**
     * SEV4 - Low impact incident
     */
    SEV4
}
