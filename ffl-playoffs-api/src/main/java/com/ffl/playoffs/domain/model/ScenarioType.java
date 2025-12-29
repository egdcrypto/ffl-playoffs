package com.ffl.playoffs.domain.model;

/**
 * Types of curated event scenarios.
 */
public enum ScenarioType {
    HISTORICAL("Based on real NFL season events"),
    INJURY_HEAVY("High injury frequency"),
    INJURY_LIGHT("Minimal injuries"),
    WEATHER_EXTREME("Frequent severe weather"),
    CHAOS("Maximum unpredictability"),
    STABLE("Minimal disruptions"),
    CUSTOM("User-defined event mix"),
    NARRATIVE("Designed for storyline purposes");

    private final String description;

    ScenarioType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
