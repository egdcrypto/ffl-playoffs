package com.ffl.playoffs.domain.model;

/**
 * Types of admin actions for audit logging
 */
public enum AdminAction {
    /**
     * Admin created a new league
     */
    LEAGUE_CREATED,

    /**
     * Admin configured league settings
     */
    LEAGUE_CONFIGURED,

    /**
     * Admin invited a player to a league
     */
    PLAYER_INVITED,

    /**
     * Admin removed a player from a league
     */
    PLAYER_REMOVED,

    /**
     * Admin changed configuration settings
     */
    CONFIGURATION_CHANGED,

    /**
     * Admin activated a league
     */
    LEAGUE_ACTIVATED,

    /**
     * Admin deactivated a league
     */
    LEAGUE_DEACTIVATED,

    /**
     * Admin archived a league
     */
    LEAGUE_ARCHIVED
}
