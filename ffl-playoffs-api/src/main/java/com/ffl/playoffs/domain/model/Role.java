package com.ffl.playoffs.domain.model;

/**
 * User role enumeration
 * Defines the three-tier role hierarchy
 */
public enum Role {
    /**
     * Regular player - can build rosters, view standings
     * League-scoped permissions
     */
    PLAYER,

    /**
     * League administrator - can create leagues, invite players
     * League-scoped permissions
     */
    ADMIN,

    /**
     * System administrator - full system access
     * Can invite admins, manage PATs, view all leagues
     */
    SUPER_ADMIN
}
