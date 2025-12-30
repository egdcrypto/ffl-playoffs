package com.ffl.playoffs.domain.model;

/**
 * Synthetic test type enumeration
 * Defines the type of synthetic monitoring test
 */
public enum SyntheticTestType {
    /**
     * HTTP - simple HTTP request test
     */
    HTTP,

    /**
     * API - API endpoint test with assertions
     */
    API,

    /**
     * BROWSER - browser-based multi-step user journey test
     */
    BROWSER,

    /**
     * TCP - TCP connectivity test
     */
    TCP,

    /**
     * DNS - DNS resolution test
     */
    DNS
}
