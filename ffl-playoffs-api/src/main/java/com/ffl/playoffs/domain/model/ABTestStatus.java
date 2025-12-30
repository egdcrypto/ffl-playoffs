package com.ffl.playoffs.domain.model;

/**
 * A/B test status enumeration
 * Defines the lifecycle states of an A/B test
 */
public enum ABTestStatus {
    /**
     * Test is being configured but not yet running
     */
    DRAFT,

    /**
     * Test is actively running and collecting data
     */
    RUNNING,

    /**
     * Test has been paused
     */
    PAUSED,

    /**
     * Test has concluded with results
     */
    CONCLUDED,

    /**
     * Test was cancelled before completion
     */
    CANCELLED
}
