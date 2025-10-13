package com.ffl.playoffs.domain.model;

/**
 * Personal Access Token scope enumeration
 * Defines access levels for API tokens
 */
public enum PATScope {
    /**
     * Read-only access - can only read data
     */
    READ_ONLY,

    /**
     * Write access - can read and modify data
     */
    WRITE,

    /**
     * Admin access - full access including administrative operations
     */
    ADMIN
}
