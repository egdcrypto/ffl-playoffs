package com.ffl.playoffs.domain.model;

/**
 * Role filter for event targeting.
 */
public enum TargetRole {
    STARTER,        // Only starting players
    BACKUP,         // Only backup players
    ALL             // All players regardless of role
}
