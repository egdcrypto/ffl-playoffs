package com.ffl.playoffs.domain.model;

/**
 * Test case status enumeration
 * Defines the possible states of a conversation test case
 */
public enum TestCaseStatus {
    /**
     * Test case has not yet been executed
     */
    PENDING,

    /**
     * Test case passed all assertions
     */
    PASSED,

    /**
     * Test case failed one or more assertions
     */
    FAILED,

    /**
     * Test case was skipped (e.g., due to dependencies)
     */
    SKIPPED,

    /**
     * Test case execution encountered an error
     */
    ERROR
}
