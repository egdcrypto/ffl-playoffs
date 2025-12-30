package com.ffl.playoffs.domain.model;

/**
 * Type of NFL venue/stadium.
 */
public enum VenueType {
    OUTDOOR("Fully exposed to weather", 1.0),
    DOME("Enclosed, climate controlled", 0.0),
    RETRACTABLE("Retractable roof, can open/close", 0.5);

    private final String description;
    private final double weatherExposure;

    VenueType(String description, double weatherExposure) {
        this.description = description;
        this.weatherExposure = weatherExposure;
    }

    public String getDescription() {
        return description;
    }

    public double getWeatherExposure() {
        return weatherExposure;
    }

    public boolean isWeatherExposed() {
        return this == OUTDOOR;
    }

    public boolean isDome() {
        return this == DOME;
    }

    public boolean hasRetractableRoof() {
        return this == RETRACTABLE;
    }
}
