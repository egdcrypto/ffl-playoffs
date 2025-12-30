package com.ffl.playoffs.domain.worldbuilding;

/**
 * Era Enum
 * Represents the base time period/aesthetic for world configuration.
 * Part of the Chronos Engine integration for narrative generation.
 */
public enum Era {
    PREHISTORIC("Prehistoric", "Before recorded history, tribal societies"),
    ANCIENT("Ancient", "Classical civilizations (Egypt, Greece, Rome)"),
    MEDIEVAL("Medieval", "Middle Ages, feudal societies, castles"),
    RENAISSANCE("Renaissance", "Cultural rebirth, early modern period"),
    INDUSTRIAL("Industrial", "Industrial revolution, Victorian era"),
    MODERN("Modern", "Contemporary era, current technology"),
    FUTURISTIC("Futuristic", "Science fiction, advanced technology");

    private final String displayName;
    private final String description;

    Era(String displayName, String description) {
        this.displayName = displayName;
        this.description = description;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getDescription() {
        return description;
    }

    /**
     * Check if this era is before another era chronologically
     */
    public boolean isBefore(Era other) {
        return this.ordinal() < other.ordinal();
    }

    /**
     * Check if this era is after another era chronologically
     */
    public boolean isAfter(Era other) {
        return this.ordinal() > other.ordinal();
    }

    /**
     * Check if this is a historical era (before Modern)
     */
    public boolean isHistorical() {
        return this.ordinal() < MODERN.ordinal();
    }

    /**
     * Check if this is a fantasy-friendly era (Medieval or Renaissance)
     */
    public boolean isFantasyFriendly() {
        return this == MEDIEVAL || this == RENAISSANCE || this == ANCIENT;
    }
}
