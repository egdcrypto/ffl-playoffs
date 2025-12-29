package com.ffl.playoffs.domain.model;

/**
 * Categories of world events based on their primary effect.
 */
public enum EventCategory {
    AVAILABILITY("Affects whether player/team participates"),
    PERFORMANCE("Modifies statistical output"),
    GAME_CONTEXT("Affects game environment/conditions"),
    ROSTER("Changes team composition"),
    MOTIVATION("Affects effort/intensity levels"),
    USAGE("Changes snap count/target share");

    private final String description;

    EventCategory(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
