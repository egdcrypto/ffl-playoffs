package com.ffl.playoffs.domain.worldbuilding;

import java.util.Objects;

/**
 * DimensionalConfiguration Value Object
 * Tunable parameters (0.0-1.0) that affect narrative generation.
 * Part of the Chronos Engine integration for controlling narrative tone.
 * Immutable domain model with no framework dependencies.
 */
public final class DimensionalConfiguration {

    private static final double MIN_VALUE = 0.0;
    private static final double MAX_VALUE = 1.0;

    private final double tragedyLevel;
    private final double chaosFactor;
    private final double romanceIntensity;
    private final double hopeIndex;
    private final double verisimilitude;
    private final double violenceGraphicness;

    private DimensionalConfiguration(Builder builder) {
        this.tragedyLevel = validateRange(builder.tragedyLevel, "tragedyLevel");
        this.chaosFactor = validateRange(builder.chaosFactor, "chaosFactor");
        this.romanceIntensity = validateRange(builder.romanceIntensity, "romanceIntensity");
        this.hopeIndex = validateRange(builder.hopeIndex, "hopeIndex");
        this.verisimilitude = validateRange(builder.verisimilitude, "verisimilitude");
        this.violenceGraphicness = validateRange(builder.violenceGraphicness, "violenceGraphicness");
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
     * Creates a neutral/balanced configuration with all values at 0.5
     */
    public static DimensionalConfiguration neutral() {
        return builder()
            .tragedyLevel(0.5)
            .chaosFactor(0.5)
            .romanceIntensity(0.5)
            .hopeIndex(0.5)
            .verisimilitude(0.5)
            .violenceGraphicness(0.5)
            .build();
    }

    /**
     * How often characters face irreversible loss (0.0 = never, 1.0 = constantly)
     */
    public double getTragedyLevel() {
        return tragedyLevel;
    }

    /**
     * Randomness vs logical story progression (0.0 = deterministic, 1.0 = chaotic)
     */
    public double getChaosFactor() {
        return chaosFactor;
    }

    /**
     * How prominently relationships feature (0.0 = none, 1.0 = central focus)
     */
    public double getRomanceIntensity() {
        return romanceIntensity;
    }

    /**
     * Overall tone from grimdark to optimistic (0.0 = grimdark, 1.0 = optimistic)
     */
    public double getHopeIndex() {
        return hopeIndex;
    }

    /**
     * Historical accuracy vs high fantasy (0.0 = pure fantasy, 1.0 = historically accurate)
     */
    public double getVerisimilitude() {
        return verisimilitude;
    }

    /**
     * Combat description intensity (0.0 = minimal, 1.0 = graphic)
     */
    public double getViolenceGraphicness() {
        return violenceGraphicness;
    }

    /**
     * Check if this is a dark/grimdark configuration
     */
    public boolean isGrimdark() {
        return hopeIndex < 0.3 && tragedyLevel > 0.7;
    }

    /**
     * Check if this is an optimistic/hopeful configuration
     */
    public boolean isOptimistic() {
        return hopeIndex > 0.7 && tragedyLevel < 0.3;
    }

    /**
     * Check if romance is a central theme
     */
    public boolean isRomanceFocused() {
        return romanceIntensity > 0.7;
    }

    /**
     * Get overall narrative intensity score (average of dramatic elements)
     */
    public double getNarrativeIntensity() {
        return (tragedyLevel + chaosFactor + romanceIntensity + violenceGraphicness) / 4.0;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        DimensionalConfiguration that = (DimensionalConfiguration) o;
        return Double.compare(that.tragedyLevel, tragedyLevel) == 0 &&
                Double.compare(that.chaosFactor, chaosFactor) == 0 &&
                Double.compare(that.romanceIntensity, romanceIntensity) == 0 &&
                Double.compare(that.hopeIndex, hopeIndex) == 0 &&
                Double.compare(that.verisimilitude, verisimilitude) == 0 &&
                Double.compare(that.violenceGraphicness, violenceGraphicness) == 0;
    }

    @Override
    public int hashCode() {
        return Objects.hash(tragedyLevel, chaosFactor, romanceIntensity,
                hopeIndex, verisimilitude, violenceGraphicness);
    }

    @Override
    public String toString() {
        return String.format(
            "DimensionalConfiguration{tragedy=%.2f, chaos=%.2f, romance=%.2f, hope=%.2f, verisimilitude=%.2f, violence=%.2f}",
            tragedyLevel, chaosFactor, romanceIntensity, hopeIndex, verisimilitude, violenceGraphicness);
    }

    public static class Builder {
        private double tragedyLevel = 0.5;
        private double chaosFactor = 0.5;
        private double romanceIntensity = 0.5;
        private double hopeIndex = 0.5;
        private double verisimilitude = 0.5;
        private double violenceGraphicness = 0.5;

        public Builder tragedyLevel(double tragedyLevel) {
            this.tragedyLevel = tragedyLevel;
            return this;
        }

        public Builder chaosFactor(double chaosFactor) {
            this.chaosFactor = chaosFactor;
            return this;
        }

        public Builder romanceIntensity(double romanceIntensity) {
            this.romanceIntensity = romanceIntensity;
            return this;
        }

        public Builder hopeIndex(double hopeIndex) {
            this.hopeIndex = hopeIndex;
            return this;
        }

        public Builder verisimilitude(double verisimilitude) {
            this.verisimilitude = verisimilitude;
            return this;
        }

        public Builder violenceGraphicness(double violenceGraphicness) {
            this.violenceGraphicness = violenceGraphicness;
            return this;
        }

        public DimensionalConfiguration build() {
            return new DimensionalConfiguration(this);
        }
    }
}
