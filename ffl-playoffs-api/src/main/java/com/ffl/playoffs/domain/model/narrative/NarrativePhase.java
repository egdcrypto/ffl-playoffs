package com.ffl.playoffs.domain.model.narrative;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Represents the phases of a narrative arc in the game.
 * Follows classic story structure for engagement.
 */
@Getter
@RequiredArgsConstructor
public enum NarrativePhase {

    SETUP("setup", "Setup", "Initial phase where context is established"),
    RISING_ACTION("rising_action", "Rising Action", "Tension builds as competition intensifies"),
    CLIMAX("climax", "Climax", "Peak tension - critical moments and eliminations"),
    FALLING_ACTION("falling_action", "Falling Action", "Resolution of major conflicts"),
    RESOLUTION("resolution", "Resolution", "Final outcomes and conclusions");

    private final String code;
    private final String displayName;
    private final String description;

    /**
     * Check if this is an early phase (setup or rising action)
     */
    public boolean isEarlyPhase() {
        return this == SETUP || this == RISING_ACTION;
    }

    /**
     * Check if this is a peak tension phase
     */
    public boolean isPeakPhase() {
        return this == CLIMAX;
    }

    /**
     * Check if this is a concluding phase
     */
    public boolean isConcludingPhase() {
        return this == FALLING_ACTION || this == RESOLUTION;
    }

    /**
     * Check if this phase allows major narrative events
     */
    public boolean allowsMajorEvents() {
        return this != RESOLUTION;
    }

    /**
     * Get the next phase in the narrative progression
     */
    public NarrativePhase getNextPhase() {
        return switch (this) {
            case SETUP -> RISING_ACTION;
            case RISING_ACTION -> CLIMAX;
            case CLIMAX -> FALLING_ACTION;
            case FALLING_ACTION -> RESOLUTION;
            case RESOLUTION -> null;
        };
    }

    /**
     * Get the previous phase in the narrative progression
     */
    public NarrativePhase getPreviousPhase() {
        return switch (this) {
            case SETUP -> null;
            case RISING_ACTION -> SETUP;
            case CLIMAX -> RISING_ACTION;
            case FALLING_ACTION -> CLIMAX;
            case RESOLUTION -> FALLING_ACTION;
        };
    }

    /**
     * Get the base tension multiplier for this phase
     */
    public double getTensionMultiplier() {
        return switch (this) {
            case SETUP -> 0.5;
            case RISING_ACTION -> 1.0;
            case CLIMAX -> 1.5;
            case FALLING_ACTION -> 1.2;
            case RESOLUTION -> 0.8;
        };
    }

    /**
     * Resolve from code string
     */
    public static NarrativePhase fromCode(String code) {
        for (NarrativePhase phase : values()) {
            if (phase.code.equalsIgnoreCase(code)) {
                return phase;
            }
        }
        throw new IllegalArgumentException("Unknown narrative phase code: " + code);
    }
}
