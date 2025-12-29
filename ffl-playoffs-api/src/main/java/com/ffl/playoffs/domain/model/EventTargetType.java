package com.ffl.playoffs.domain.model;

/**
 * Types of entities that can be targeted by world events.
 */
public enum EventTargetType {
    PLAYER,         // Specific NFL player
    TEAM,           // Entire team
    GAME,           // Specific game
    POSITION,       // All players at position (on team)
    MATCHUP,        // Both teams in a matchup
    LEAGUE          // All teams/players
}
