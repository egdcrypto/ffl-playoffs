package com.ffl.playoffs.domain.model;

/**
 * Type of precipitation.
 */
public enum PrecipitationType {
    NONE("No precipitation", 0.0),
    DRIZZLE("Light drizzle", 0.1),
    LIGHT_RAIN("Light rain", 0.3),
    MODERATE_RAIN("Moderate rain", 0.5),
    HEAVY_RAIN("Heavy rain", 0.8),
    LIGHT_SNOW("Light snow", 0.3),
    MODERATE_SNOW("Moderate snow", 0.5),
    HEAVY_SNOW("Heavy snow", 0.8),
    SLEET("Sleet", 0.6),
    FREEZING_RAIN("Freezing rain", 0.7),
    HAIL("Hail", 0.9);

    private final String description;
    private final double intensity;

    PrecipitationType(String description, double intensity) {
        this.description = description;
        this.intensity = intensity;
    }

    public String getDescription() {
        return description;
    }

    /**
     * Intensity from 0.0 (none) to 1.0 (severe).
     */
    public double getIntensity() {
        return intensity;
    }

    public boolean isRain() {
        return this == DRIZZLE || this == LIGHT_RAIN || this == MODERATE_RAIN ||
               this == HEAVY_RAIN || this == FREEZING_RAIN;
    }

    public boolean isSnow() {
        return this == LIGHT_SNOW || this == MODERATE_SNOW || this == HEAVY_SNOW;
    }

    public boolean isFreezing() {
        return this == SLEET || this == FREEZING_RAIN || isSnow();
    }

    public boolean isNone() {
        return this == NONE;
    }
}
