package com.ffl.playoffs.domain.model;

/**
 * Status tracking for league ownership
 * Used when admin privileges are revoked
 */
public enum LeagueOwnerStatus {
    /**
     * Normal operation - owner has active admin privileges
     */
    ACTIVE,

    /**
     * Owner's admin privileges were revoked
     * League remains visible but cannot be modified
     */
    ADMIN_REVOKED
}
