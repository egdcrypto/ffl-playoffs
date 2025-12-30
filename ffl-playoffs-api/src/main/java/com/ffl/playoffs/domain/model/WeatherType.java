package com.ffl.playoffs.domain.model;

/**
 * Types of weather conditions.
 */
public enum WeatherType {
    CLEAR("Clear skies", 1.0, 1.0),
    PARTLY_CLOUDY("Partly cloudy", 1.0, 1.0),
    CLOUDY("Overcast", 1.0, 1.0),
    LIGHT_RAIN("Light rain", 0.95, 0.98),
    RAIN("Rain", 0.90, 0.95),
    HEAVY_RAIN("Heavy rain", 0.80, 0.85),
    THUNDERSTORM("Thunderstorm", 0.75, 0.80),
    LIGHT_SNOW("Light snow", 0.90, 0.92),
    SNOW("Snow", 0.80, 0.85),
    HEAVY_SNOW("Heavy snow", 0.65, 0.75),
    SLEET("Sleet/ice", 0.70, 0.80),
    FOG("Fog", 0.85, 0.90),
    WIND("High winds", 0.85, 0.75);

    private final String description;
    private final double passingModifier;
    private final double kickingModifier;

    WeatherType(String description, double passingModifier, double kickingModifier) {
        this.description = description;
        this.passingModifier = passingModifier;
        this.kickingModifier = kickingModifier;
    }

    public String getDescription() {
        return description;
    }

    public double getPassingModifier() {
        return passingModifier;
    }

    public double getKickingModifier() {
        return kickingModifier;
    }

    public boolean isPrecipitating() {
        return this == LIGHT_RAIN || this == RAIN || this == HEAVY_RAIN ||
               this == THUNDERSTORM || this == LIGHT_SNOW || this == SNOW ||
               this == HEAVY_SNOW || this == SLEET;
    }

    public boolean isWintry() {
        return this == LIGHT_SNOW || this == SNOW || this == HEAVY_SNOW || this == SLEET;
    }

    public boolean isSevere() {
        return this == HEAVY_RAIN || this == THUNDERSTORM || this == HEAVY_SNOW || this == SLEET;
    }
}
