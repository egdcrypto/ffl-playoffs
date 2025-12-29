package com.ffl.playoffs.domain.model;

import java.util.Objects;
import java.util.UUID;

/**
 * A calculated stat modification from an event.
 */
public class StatModifier {

    private final StatCategory category;
    private final ModifierType modifierType;
    private final Double value;

    // Source tracking
    private final UUID sourceEventId;
    private final WorldEventType sourceEventType;

    // Stacking rules
    private final boolean stackable;
    private final StackingGroup stackingGroup;

    private StatModifier(StatCategory category, ModifierType modifierType, Double value,
                         UUID sourceEventId, WorldEventType sourceEventType,
                         boolean stackable, StackingGroup stackingGroup) {
        this.category = category;
        this.modifierType = modifierType;
        this.value = value;
        this.sourceEventId = sourceEventId;
        this.sourceEventType = sourceEventType;
        this.stackable = stackable;
        this.stackingGroup = stackingGroup;
    }

    // Factory methods

    public static StatModifier multiply(StatCategory cat, double factor) {
        return new StatModifier(cat, ModifierType.MULTIPLIER, factor,
                null, null, true, null);
    }

    public static StatModifier multiply(StatCategory cat, double factor, UUID eventId, WorldEventType eventType) {
        return new StatModifier(cat, ModifierType.MULTIPLIER, factor,
                eventId, eventType, true, null);
    }

    public static StatModifier add(StatCategory cat, double amount) {
        return new StatModifier(cat, ModifierType.ADDITIVE, amount,
                null, null, true, null);
    }

    public static StatModifier cap(StatCategory cat, double max) {
        return new StatModifier(cat, ModifierType.CAP, max,
                null, null, false, StackingGroup.CAPS);
    }

    public static StatModifier floor(StatCategory cat, double min) {
        return new StatModifier(cat, ModifierType.FLOOR, min,
                null, null, false, StackingGroup.FLOORS);
    }

    // Business methods

    public Double apply(Double baseValue) {
        if (baseValue == null || value == null) {
            return baseValue;
        }

        return switch (modifierType) {
            case MULTIPLIER -> baseValue * value;
            case ADDITIVE -> baseValue + value;
            case REPLACEMENT -> value;
            case CAP -> Math.min(baseValue, value);
            case FLOOR -> Math.max(baseValue, value);
        };
    }

    public boolean conflictsWith(StatModifier other) {
        if (other == null) return false;

        // Different categories don't conflict
        if (this.category != other.category &&
            this.category != StatCategory.ALL_STATS &&
            other.category != StatCategory.ALL_STATS) {
            return false;
        }

        // Non-stackable modifiers in the same stacking group conflict
        if (!this.stackable && !other.stackable &&
            this.stackingGroup != null && this.stackingGroup == other.stackingGroup) {
            return true;
        }

        return false;
    }

    public boolean appliesToCategory(StatCategory targetCategory) {
        return this.category == targetCategory || this.category == StatCategory.ALL_STATS;
    }

    // Getters

    public StatCategory getCategory() {
        return category;
    }

    public ModifierType getModifierType() {
        return modifierType;
    }

    public Double getValue() {
        return value;
    }

    public UUID getSourceEventId() {
        return sourceEventId;
    }

    public WorldEventType getSourceEventType() {
        return sourceEventType;
    }

    public boolean isStackable() {
        return stackable;
    }

    public StackingGroup getStackingGroup() {
        return stackingGroup;
    }

    public StatModifier withSource(UUID eventId, WorldEventType eventType) {
        return new StatModifier(category, modifierType, value, eventId, eventType,
                stackable, stackingGroup);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        StatModifier that = (StatModifier) o;
        return stackable == that.stackable &&
                category == that.category &&
                modifierType == that.modifierType &&
                Objects.equals(value, that.value) &&
                Objects.equals(sourceEventId, that.sourceEventId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(category, modifierType, value, sourceEventId, stackable);
    }

    @Override
    public String toString() {
        String operation = switch (modifierType) {
            case MULTIPLIER -> String.format("×%.2f", value);
            case ADDITIVE -> String.format("%+.1f", value);
            case REPLACEMENT -> String.format("=%.1f", value);
            case CAP -> String.format("≤%.1f", value);
            case FLOOR -> String.format("≥%.1f", value);
        };
        return String.format("%s %s", category, operation);
    }

    /**
     * Groups for stacking rules - modifiers in the same group don't stack.
     */
    public enum StackingGroup {
        INJURIES,       // Multiple injuries don't stack
        WEATHER,        // Weather effects don't stack
        CAPS,           // Only one cap per stat
        FLOORS,         // Only one floor per stat
        STREAKS         // Hot/cold streaks don't stack
    }
}
