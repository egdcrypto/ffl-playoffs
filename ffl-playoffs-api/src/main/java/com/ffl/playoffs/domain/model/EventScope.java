package com.ffl.playoffs.domain.model;

/**
 * Scope of how broadly an event affects entities.
 */
public enum EventScope {
    INDIVIDUAL,     // Single player
    TEAM,           // All players on a team
    LEAGUE,         // All teams in league
    GLOBAL          // Entire simulation
}
