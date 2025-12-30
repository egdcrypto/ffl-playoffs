package com.ffl.playoffs.domain.model;

/**
 * Condition of the playing field.
 */
public enum FieldCondition {
    DRY("Dry field, optimal conditions", 1.0, 1.0),
    WET("Wet from rain", 0.95, 1.1),
    MUDDY("Muddy conditions", 0.90, 1.15),
    FROZEN("Frozen/hard field", 0.93, 1.2),
    SNOWY("Snow-covered field", 0.85, 1.25),
    SLIPPERY("Icy/slippery conditions", 0.80, 1.3);

    private final String description;
    private final double footingModifier;
    private final double injuryMultiplier;

    FieldCondition(String description, double footingModifier, double injuryMultiplier) {
        this.description = description;
        this.footingModifier = footingModifier;
        this.injuryMultiplier = injuryMultiplier;
    }

    public String getDescription() {
        return description;
    }

    /**
     * Modifier affecting player movement/footing (1.0 = normal).
     */
    public double getFootingModifier() {
        return footingModifier;
    }

    /**
     * Multiplier for injury probability (1.0 = baseline).
     */
    public double getInjuryMultiplier() {
        return injuryMultiplier;
    }

    public boolean isSlippery() {
        return this == WET || this == MUDDY || this == FROZEN || this == SNOWY || this == SLIPPERY;
    }

    public boolean affectsPassing() {
        return this == WET || this == SNOWY;
    }

    public static FieldCondition fromWeather(WeatherType weather, int temperature) {
        if (weather.isWintry()) {
            return temperature < 32 ? FROZEN : SNOWY;
        } else if (weather.isPrecipitating()) {
            return temperature < 35 ? SLIPPERY : WET;
        }
        return DRY;
    }
}
