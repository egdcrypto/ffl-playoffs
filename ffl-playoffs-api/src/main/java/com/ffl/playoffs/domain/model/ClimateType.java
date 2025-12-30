package com.ffl.playoffs.domain.model;

/**
 * Climate classification for weather zones.
 */
public enum ClimateType {
    CONTINENTAL("Cold winters, warm summers", true, true),
    HUMID_CONTINENTAL("Cold winters, warm humid summers", true, true),
    HUMID_SUBTROPICAL("Mild winters, hot humid summers", false, true),
    MEDITERRANEAN("Mild, dry summers", false, false),
    SEMI_ARID("Low precipitation, wide temp range", false, false),
    ARID("Hot, minimal precipitation", false, false),
    OCEANIC("Mild, frequent rain", false, true),
    TROPICAL("Warm year-round, high humidity", false, true),
    DESERT("Hot, minimal precipitation", false, false),
    ALPINE("Cold, high altitude effects", true, true);

    private final String description;
    private final boolean snowPossible;
    private final boolean rainCommon;

    ClimateType(String description, boolean snowPossible, boolean rainCommon) {
        this.description = description;
        this.snowPossible = snowPossible;
        this.rainCommon = rainCommon;
    }

    public String getDescription() {
        return description;
    }

    public boolean isSnowPossible() {
        return snowPossible;
    }

    public boolean isRainCommon() {
        return rainCommon;
    }

    public boolean hasColdWinters() {
        return snowPossible;
    }

    public boolean isHumid() {
        return this == HUMID_SUBTROPICAL || this == TROPICAL;
    }
}
