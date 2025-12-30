package com.ffl.playoffs.domain.model.narrative;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Represents the current tension level in the narrative.
 * Used by the AI Director to modulate story beats and curator actions.
 */
@Getter
@RequiredArgsConstructor
public enum TensionLevel {

    MINIMAL("minimal", "Minimal", "Very low stakes, routine activity", 0, 20),
    LOW("low", "Low", "Below average tension, normal competition", 20, 40),
    MODERATE("moderate", "Moderate", "Average tension, engaged competition", 40, 60),
    HIGH("high", "High", "Above average tension, intense moments", 60, 80),
    CRITICAL("critical", "Critical", "Maximum tension, elimination or victory imminent", 80, 100);

    private final String code;
    private final String displayName;
    private final String description;
    private final int minScore;
    private final int maxScore;

    /**
     * Check if this tension level requires immediate attention
     */
    public boolean requiresAttention() {
        return this == HIGH || this == CRITICAL;
    }

    /**
     * Check if this tension level indicates a stall risk
     */
    public boolean isStallRisk() {
        return this == MINIMAL || this == LOW;
    }

    /**
     * Check if curator intervention is recommended
     */
    public boolean recommendsCuratorIntervention() {
        return this == MINIMAL || this == CRITICAL;
    }

    /**
     * Get the next higher tension level
     */
    public TensionLevel escalate() {
        return switch (this) {
            case MINIMAL -> LOW;
            case LOW -> MODERATE;
            case MODERATE -> HIGH;
            case HIGH, CRITICAL -> CRITICAL;
        };
    }

    /**
     * Get the next lower tension level
     */
    public TensionLevel deescalate() {
        return switch (this) {
            case MINIMAL, LOW -> MINIMAL;
            case MODERATE -> LOW;
            case HIGH -> MODERATE;
            case CRITICAL -> HIGH;
        };
    }

    /**
     * Check if tension score falls within this level's range
     */
    public boolean containsScore(int score) {
        return score >= minScore && score < maxScore;
    }

    /**
     * Get the midpoint score for this level
     */
    public int getMidpointScore() {
        return (minScore + maxScore) / 2;
    }

    /**
     * Resolve from tension score (0-100)
     */
    public static TensionLevel fromScore(int score) {
        if (score < 0) score = 0;
        if (score > 100) score = 100;

        for (TensionLevel level : values()) {
            if (level.containsScore(score)) {
                return level;
            }
        }
        return CRITICAL; // Score of exactly 100
    }

    /**
     * Resolve from code string
     */
    public static TensionLevel fromCode(String code) {
        for (TensionLevel level : values()) {
            if (level.code.equalsIgnoreCase(code)) {
                return level;
            }
        }
        throw new IllegalArgumentException("Unknown tension level code: " + code);
    }
}
