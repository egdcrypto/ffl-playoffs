package com.ffl.playoffs.domain.model;

/**
 * Type of authentication used to access the system
 */
public enum AuthenticationType {
    /**
     * User authenticated via Google OAuth
     */
    USER,

    /**
     * Service authenticated via Personal Access Token
     */
    PAT
}
