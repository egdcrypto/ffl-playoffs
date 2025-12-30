package com.ffl.playoffs.domain.worldbuilding;

import java.time.Instant;
import java.util.Objects;
import java.util.UUID;

/**
 * WorldConfiguration Aggregate
 * Composite configuration containing DimensionalConfiguration and EraVector.
 * Controls how characters behave and respond in narrative generation.
 * Part of the Chronos Engine integration.
 * Immutable domain model with no framework dependencies.
 */
public final class WorldConfiguration {

    private final UUID id;
    private final String name;
    private final String description;
    private final DimensionalConfiguration dimensions;
    private final EraVector eraVector;
    private final Instant createdAt;

    private WorldConfiguration(Builder builder) {
        this.id = builder.id != null ? builder.id : UUID.randomUUID();
        this.name = Objects.requireNonNull(builder.name, "name is required");
        this.description = builder.description;
        this.dimensions = Objects.requireNonNull(builder.dimensions, "dimensions is required");
        this.eraVector = Objects.requireNonNull(builder.eraVector, "eraVector is required");
        this.createdAt = builder.createdAt != null ? builder.createdAt : Instant.now();
    }

    public static Builder builder() {
        return new Builder();
    }

    public UUID getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public DimensionalConfiguration getDimensions() {
        return dimensions;
    }

    public EraVector getEraVector() {
        return eraVector;
    }

    public Instant getCreatedAt() {
        return createdAt;
    }

    /**
     * Check if this configuration represents a dark fantasy setting
     */
    public boolean isDarkFantasy() {
        return dimensions.isGrimdark() && eraVector.isFantasySetting();
    }

    /**
     * Check if this configuration represents a high fantasy setting
     */
    public boolean isHighFantasy() {
        return eraVector.isHighMagic() && dimensions.isOptimistic();
    }

    /**
     * Check if this configuration represents a romantic setting
     */
    public boolean isRomantic() {
        return dimensions.isRomanceFocused();
    }

    /**
     * Check if this configuration represents a historical drama setting
     */
    public boolean isHistoricalDrama() {
        return eraVector.getBaseEra().isHistorical() &&
               eraVector.isLowMagic() &&
               dimensions.getVerisimilitude() > 0.7;
    }

    /**
     * Get overall narrative complexity score combining all factors
     */
    public double getNarrativeComplexity() {
        double dimensionIntensity = dimensions.getNarrativeIntensity();
        double worldComplexity = eraVector.getWorldComplexity();
        return (dimensionIntensity + worldComplexity) / 2.0;
    }

    /**
     * Get the base era from the era vector
     */
    public Era getBaseEra() {
        return eraVector.getBaseEra();
    }

    /**
     * Convenience method to check tragedy level
     */
    public double getTragedyLevel() {
        return dimensions.getTragedyLevel();
    }

    /**
     * Convenience method to check hope index
     */
    public double getHopeIndex() {
        return dimensions.getHopeIndex();
    }

    /**
     * Convenience method to check magic presence
     */
    public double getMagicalPresence() {
        return eraVector.getMagicalPresence();
    }

    /**
     * Creates a copy with updated dimensions
     */
    public WorldConfiguration withDimensions(DimensionalConfiguration newDimensions) {
        return builder()
            .id(this.id)
            .name(this.name)
            .description(this.description)
            .dimensions(newDimensions)
            .eraVector(this.eraVector)
            .createdAt(this.createdAt)
            .build();
    }

    /**
     * Creates a copy with updated era vector
     */
    public WorldConfiguration withEraVector(EraVector newEraVector) {
        return builder()
            .id(this.id)
            .name(this.name)
            .description(this.description)
            .dimensions(this.dimensions)
            .eraVector(newEraVector)
            .createdAt(this.createdAt)
            .build();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        WorldConfiguration that = (WorldConfiguration) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return String.format(
            "WorldConfiguration{id=%s, name='%s', era=%s, complexity=%.2f}",
            id, name, eraVector.getBaseEra().getDisplayName(), getNarrativeComplexity());
    }

    public static class Builder {
        private UUID id;
        private String name;
        private String description;
        private DimensionalConfiguration dimensions;
        private EraVector eraVector;
        private Instant createdAt;

        public Builder id(UUID id) {
            this.id = id;
            return this;
        }

        public Builder name(String name) {
            this.name = name;
            return this;
        }

        public Builder description(String description) {
            this.description = description;
            return this;
        }

        public Builder dimensions(DimensionalConfiguration dimensions) {
            this.dimensions = dimensions;
            return this;
        }

        public Builder eraVector(EraVector eraVector) {
            this.eraVector = eraVector;
            return this;
        }

        public Builder createdAt(Instant createdAt) {
            this.createdAt = createdAt;
            return this;
        }

        public WorldConfiguration build() {
            return new WorldConfiguration(this);
        }
    }
}
