package com.ffl.playoffs.domain.model.loadtest;

/**
 * Status of a load test execution.
 */
public enum LoadTestStatus {
    PENDING,
    SCHEDULED,
    RUNNING,
    COMPLETED,
    FAILED,
    CANCELLED,
    TIMED_OUT
}
