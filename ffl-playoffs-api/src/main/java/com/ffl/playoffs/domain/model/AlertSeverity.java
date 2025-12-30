package com.ffl.playoffs.domain.model;

/**
 * Alert severity enumeration
 * Defines the severity level of platform alerts
 */
public enum AlertSeverity {
    /**
     * Informational alert - no action required
     */
    INFO,

    /**
     * Warning alert - potential issue that may require attention
     */
    WARNING,

    /**
     * Critical alert - immediate attention required
     */
    CRITICAL
}
