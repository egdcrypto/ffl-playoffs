package com.ffl.playoffs.domain.model;

/**
 * Categories of stats that can be modified by events.
 */
public enum StatCategory {
    // Passing
    PASSING_YARDS,
    PASSING_TOUCHDOWNS,
    INTERCEPTIONS,
    COMPLETION_PERCENTAGE,

    // Rushing
    RUSHING_YARDS,
    RUSHING_TOUCHDOWNS,
    RUSHING_ATTEMPTS,

    // Receiving
    RECEPTIONS,
    RECEIVING_YARDS,
    RECEIVING_TOUCHDOWNS,
    TARGETS,

    // Kicking
    FIELD_GOALS,
    FIELD_GOAL_PERCENTAGE,
    EXTRA_POINTS,

    // Defense
    SACKS,
    DEFENSIVE_INTERCEPTIONS,
    FUMBLE_RECOVERIES,
    POINTS_ALLOWED,

    // General
    FANTASY_POINTS,
    ALL_STATS
}
