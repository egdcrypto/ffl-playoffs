package com.ffl.playoffs.domain.model;

/**
 * Widget category enumeration
 * Defines the functional category of dashboard widgets
 */
public enum WidgetCategory {
    /**
     * User-related widgets (stats, signups, sessions)
     */
    USERS,

    /**
     * Content-related widgets (metrics, activity)
     */
    CONTENT,

    /**
     * Billing and revenue widgets
     */
    BILLING,

    /**
     * Infrastructure and system health widgets
     */
    INFRASTRUCTURE,

    /**
     * Data pipeline and processing widgets
     */
    DATA
}
