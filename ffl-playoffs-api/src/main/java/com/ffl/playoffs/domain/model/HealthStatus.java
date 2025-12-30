package com.ffl.playoffs.domain.model;

/**
 * Health status enumeration for system health indicators
 * Represents the current health state of a service or component
 */
public enum HealthStatus {
    /**
     * Service is operating normally
     */
    HEALTHY,

    /**
     * Service is degraded but functional
     */
    WARNING,

    /**
     * Service is experiencing critical issues
     */
    CRITICAL,

    /**
     * Service status is unknown or unreachable
     */
    UNKNOWN
}
