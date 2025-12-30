package com.ffl.playoffs.domain.model;

/**
 * Severity classification for weather conditions.
 */
public enum WeatherSeverity {
    IDEAL("Perfect conditions", 1.0),
    NORMAL("Typical game conditions", 1.0),
    MILD("Slightly adverse conditions", 0.97),
    MODERATE("Noticeable weather impact", 0.93),
    SEVERE("Significant weather impact", 0.85),
    EXTREME("Dangerous weather conditions", 0.75);

    private final String description;
    private final double basePerformanceModifier;

    WeatherSeverity(String description, double basePerformanceModifier) {
        this.description = description;
        this.basePerformanceModifier = basePerformanceModifier;
    }

    public String getDescription() {
        return description;
    }

    public double getBasePerformanceModifier() {
        return basePerformanceModifier;
    }

    public boolean affectsPlay() {
        return this != IDEAL && this != NORMAL;
    }

    public boolean isDangerous() {
        return this == SEVERE || this == EXTREME;
    }

    public boolean requiresNarrative() {
        return this == MODERATE || this == SEVERE || this == EXTREME;
    }
}
