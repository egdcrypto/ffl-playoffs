package com.ffl.playoffs.domain.model;

/**
 * Types of effects that events can have on players/teams.
 */
public enum EffectType {
    // Availability effects
    OUT("Player unavailable"),
    LIMITED("Reduced snap count"),
    FULL("Normal availability"),

    // Performance effects
    BOOST("Enhanced performance"),
    REDUCTION("Reduced performance"),
    VARIANCE_HIGH("Increased variance/volatility"),
    VARIANCE_LOW("Decreased variance/consistency"),

    // Specific stat effects
    PASSING_MODIFIER("Affects passing stats"),
    RUSHING_MODIFIER("Affects rushing stats"),
    RECEIVING_MODIFIER("Affects receiving stats"),
    SCORING_MODIFIER("Affects scoring stats"),

    // Game flow effects
    GAME_SCRIPT_PASS("Increased passing due to game script"),
    GAME_SCRIPT_RUN("Increased rushing due to game script"),

    // Usage effects
    TARGET_SHARE("Modified target share"),
    SNAP_COUNT("Modified snap count"),
    RED_ZONE_USAGE("Modified red zone usage");

    private final String description;

    EffectType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
