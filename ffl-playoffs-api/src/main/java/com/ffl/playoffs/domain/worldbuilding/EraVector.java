package com.ffl.playoffs.domain.worldbuilding;

import java.util.Objects;

/**
 * EraVector Value Object
 * Time period/aesthetic configuration for world building.
 * Part of the Chronos Engine integration for controlling time period context.
 * Immutable domain model with no framework dependencies.
 */
public final class EraVector {

    private static final double MIN_VALUE = 0.0;
    private static final double MAX_VALUE = 1.0;

    private final Era baseEra;
    private final double technologyLevel;
    private final double magicalPresence;
    private final double culturalComplexity;

    private EraVector(Builder builder) {
        this.baseEra = Objects.requireNonNull(builder.baseEra, "baseEra is required");
        this.technologyLevel = validateRange(builder.technologyLevel, "technologyLevel");
        this.magicalPresence = validateRange(builder.magicalPresence, "magicalPresence");
        this.culturalComplexity = validateRange(builder.culturalComplexity, "culturalComplexity");
    }

    private static double validateRange(double value, String fieldName) {
        if (value < MIN_VALUE || value > MAX_VALUE) {
            throw new IllegalArgumentException(
                String.format("%s must be between %.1f and %.1f, got: %.2f",
                    fieldName, MIN_VALUE, MAX_VALUE, value));
        }
        return value;
    }

    public static Builder builder() {
        return new Builder();
    }

    /**
     * Creates a default medieval fantasy configuration
     */
    public static EraVector defaultMedieval() {
        return builder()
            .baseEra(Era.MEDIEVAL)
            .technologyLevel(0.2)
            .magicalPresence(0.5)
            .culturalComplexity(0.4)
            .build();
    }

    /**
     * The base time period for the world
     */
    public Era getBaseEra() {
        return baseEra;
    }

    /**
     * Technology advancement level (0.0 = primitive, 1.0 = advanced)
     */
    public double getTechnologyLevel() {
        return technologyLevel;
    }

    /**
     * Presence of magic in the world (0.0 = none, 1.0 = pervasive)
     */
    public double getMagicalPresence() {
        return magicalPresence;
    }

    /**
     * Societal sophistication (0.0 = tribal, 1.0 = cosmopolitan)
     */
    public double getCulturalComplexity() {
        return culturalComplexity;
    }

    /**
     * Check if this is a high-magic setting
     */
    public boolean isHighMagic() {
        return magicalPresence > 0.7;
    }

    /**
     * Check if this is a low-magic or no-magic setting
     */
    public boolean isLowMagic() {
        return magicalPresence < 0.3;
    }

    /**
     * Check if technology level is anachronistic for the base era
     */
    public boolean isAnachronistic() {
        switch (baseEra) {
            case PREHISTORIC:
                return technologyLevel > 0.1;
            case ANCIENT:
                return technologyLevel > 0.3;
            case MEDIEVAL:
                return technologyLevel > 0.4;
            case RENAISSANCE:
                return technologyLevel > 0.5;
            case INDUSTRIAL:
                return technologyLevel > 0.7;
            case MODERN:
                return technologyLevel > 0.9;
            case FUTURISTIC:
                return false; // Any tech level is fine for futuristic
            default:
                return false;
        }
    }

    /**
     * Check if this is a fantasy setting (historical era with magic)
     */
    public boolean isFantasySetting() {
        return baseEra.isHistorical() && magicalPresence > 0.2;
    }

    /**
     * Check if this is a science fiction setting
     */
    public boolean isSciFiSetting() {
        return baseEra == Era.FUTURISTIC || (baseEra == Era.MODERN && technologyLevel > 0.8);
    }

    /**
     * Get a combined "world complexity" score
     */
    public double getWorldComplexity() {
        return (technologyLevel + magicalPresence + culturalComplexity) / 3.0;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        EraVector eraVector = (EraVector) o;
        return Double.compare(eraVector.technologyLevel, technologyLevel) == 0 &&
                Double.compare(eraVector.magicalPresence, magicalPresence) == 0 &&
                Double.compare(eraVector.culturalComplexity, culturalComplexity) == 0 &&
                baseEra == eraVector.baseEra;
    }

    @Override
    public int hashCode() {
        return Objects.hash(baseEra, technologyLevel, magicalPresence, culturalComplexity);
    }

    @Override
    public String toString() {
        return String.format(
            "EraVector{era=%s, tech=%.2f, magic=%.2f, culture=%.2f}",
            baseEra.getDisplayName(), technologyLevel, magicalPresence, culturalComplexity);
    }

    public static class Builder {
        private Era baseEra = Era.MEDIEVAL;
        private double technologyLevel = 0.3;
        private double magicalPresence = 0.5;
        private double culturalComplexity = 0.5;

        public Builder baseEra(Era baseEra) {
            this.baseEra = baseEra;
            return this;
        }

        public Builder technologyLevel(double technologyLevel) {
            this.technologyLevel = technologyLevel;
            return this;
        }

        public Builder magicalPresence(double magicalPresence) {
            this.magicalPresence = magicalPresence;
            return this;
        }

        public Builder culturalComplexity(double culturalComplexity) {
            this.culturalComplexity = culturalComplexity;
            return this;
        }

        public EraVector build() {
            return new EraVector(this);
        }
    }
}
