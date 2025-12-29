package com.ffl.playoffs.domain.model;

import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

/**
 * Value object defining the statistical/performance impact of an event.
 */
public class EventEffect {

    private final EffectType type;
    private final EffectApplication application;

    // Stat modifications
    private final Map<StatCategory, Double> statModifiers;

    // Availability
    private final Double availabilityChance;
    private final Boolean forceOut;

    // Performance envelope
    private final Double ceilingModifier;
    private final Double floorModifier;
    private final Double varianceModifier;

    // Scoring impact
    private final Double fantasyPointsModifier;
    private final Map<String, Double> bonusModifiers;

    // Probability
    private final Double effectProbability;

    private EventEffect(EffectType type, EffectApplication application,
                        Map<StatCategory, Double> statModifiers,
                        Double availabilityChance, Boolean forceOut,
                        Double ceilingModifier, Double floorModifier, Double varianceModifier,
                        Double fantasyPointsModifier, Map<String, Double> bonusModifiers,
                        Double effectProbability) {
        this.type = type;
        this.application = application;
        this.statModifiers = statModifiers != null ? new HashMap<>(statModifiers) : new HashMap<>();
        this.availabilityChance = availabilityChance;
        this.forceOut = forceOut;
        this.ceilingModifier = ceilingModifier;
        this.floorModifier = floorModifier;
        this.varianceModifier = varianceModifier;
        this.fantasyPointsModifier = fantasyPointsModifier;
        this.bonusModifiers = bonusModifiers != null ? new HashMap<>(bonusModifiers) : new HashMap<>();
        this.effectProbability = effectProbability;
    }

    // Factory methods for common effects

    public static EventEffect injuryMinor() {
        Map<StatCategory, Double> mods = new HashMap<>();
        mods.put(StatCategory.ALL_STATS, 0.8); // -20%
        return new EventEffect(EffectType.REDUCTION, EffectApplication.MULTIPLIER,
                mods, 0.9, false, null, null, null, null, null, 1.0);
    }

    public static EventEffect injuryMajor() {
        Map<StatCategory, Double> mods = new HashMap<>();
        mods.put(StatCategory.ALL_STATS, 0.5); // -50%
        return new EventEffect(EffectType.REDUCTION, EffectApplication.MULTIPLIER,
                mods, 0.6, false, null, null, null, null, null, 1.0);
    }

    public static EventEffect injuryOut() {
        return new EventEffect(EffectType.OUT, EffectApplication.REPLACEMENT,
                null, 0.0, true, null, null, null, null, null, 1.0);
    }

    public static EventEffect hotStreak() {
        Map<StatCategory, Double> mods = new HashMap<>();
        mods.put(StatCategory.ALL_STATS, 1.25); // +25%
        return new EventEffect(EffectType.BOOST, EffectApplication.MULTIPLIER,
                mods, 1.0, false, 1.2, null, 0.8, null, null, 1.0);
    }

    public static EventEffect coldStreak() {
        Map<StatCategory, Double> mods = new HashMap<>();
        mods.put(StatCategory.ALL_STATS, 0.75); // -25%
        return new EventEffect(EffectType.REDUCTION, EffectApplication.MULTIPLIER,
                mods, 1.0, false, 0.9, null, 1.2, null, null, 1.0);
    }

    public static EventEffect weatherRain() {
        Map<StatCategory, Double> mods = new HashMap<>();
        mods.put(StatCategory.PASSING_YARDS, 0.9); // -10%
        mods.put(StatCategory.RUSHING_YARDS, 1.05); // +5%
        mods.put(StatCategory.INTERCEPTIONS, 1.2); // +20%
        return new EventEffect(EffectType.PASSING_MODIFIER, EffectApplication.MULTIPLIER,
                mods, 1.0, false, null, null, 1.1, null, null, 1.0);
    }

    public static EventEffect weatherSnow() {
        Map<StatCategory, Double> mods = new HashMap<>();
        mods.put(StatCategory.PASSING_YARDS, 0.8); // -20%
        mods.put(StatCategory.ALL_STATS, 0.9); // -10%
        mods.put(StatCategory.FIELD_GOAL_PERCENTAGE, 0.7); // -30%
        return new EventEffect(EffectType.PASSING_MODIFIER, EffectApplication.MULTIPLIER,
                mods, 1.0, false, null, null, 1.2, null, null, 1.0);
    }

    public static EventEffect primeTime() {
        Map<StatCategory, Double> mods = new HashMap<>();
        mods.put(StatCategory.ALL_STATS, 1.1); // +10% for elite players
        return new EventEffect(EffectType.BOOST, EffectApplication.MULTIPLIER,
                mods, 1.0, false, 1.15, null, 1.1, null, null, 1.0);
    }

    public static EventEffect custom(EffectType type, Map<StatCategory, Double> modifiers) {
        return new EventEffect(type, EffectApplication.MULTIPLIER,
                modifiers, 1.0, false, null, null, null, null, null, 1.0);
    }

    // Builder for complex effects
    public static Builder builder() {
        return new Builder();
    }

    // Getters

    public EffectType getType() {
        return type;
    }

    public EffectApplication getApplication() {
        return application;
    }

    public Map<StatCategory, Double> getStatModifiers() {
        return new HashMap<>(statModifiers);
    }

    public Double getAvailabilityChance() {
        return availabilityChance;
    }

    public Boolean getForceOut() {
        return forceOut;
    }

    public Double getCeilingModifier() {
        return ceilingModifier;
    }

    public Double getFloorModifier() {
        return floorModifier;
    }

    public Double getVarianceModifier() {
        return varianceModifier;
    }

    public Double getFantasyPointsModifier() {
        return fantasyPointsModifier;
    }

    public Map<String, Double> getBonusModifiers() {
        return new HashMap<>(bonusModifiers);
    }

    public Double getEffectProbability() {
        return effectProbability;
    }

    public boolean causesUnavailability() {
        return (forceOut != null && forceOut) ||
               (availabilityChance != null && availabilityChance == 0.0);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        EventEffect that = (EventEffect) o;
        return type == that.type &&
                application == that.application &&
                Objects.equals(statModifiers, that.statModifiers);
    }

    @Override
    public int hashCode() {
        return Objects.hash(type, application, statModifiers);
    }

    public static class Builder {
        private EffectType type;
        private EffectApplication application = EffectApplication.MULTIPLIER;
        private Map<StatCategory, Double> statModifiers = new HashMap<>();
        private Double availabilityChance = 1.0;
        private Boolean forceOut = false;
        private Double ceilingModifier;
        private Double floorModifier;
        private Double varianceModifier;
        private Double fantasyPointsModifier;
        private Map<String, Double> bonusModifiers = new HashMap<>();
        private Double effectProbability = 1.0;

        public Builder type(EffectType type) {
            this.type = type;
            return this;
        }

        public Builder application(EffectApplication application) {
            this.application = application;
            return this;
        }

        public Builder statModifier(StatCategory category, Double modifier) {
            this.statModifiers.put(category, modifier);
            return this;
        }

        public Builder availabilityChance(Double chance) {
            this.availabilityChance = chance;
            return this;
        }

        public Builder forceOut(Boolean forceOut) {
            this.forceOut = forceOut;
            return this;
        }

        public Builder ceilingModifier(Double modifier) {
            this.ceilingModifier = modifier;
            return this;
        }

        public Builder floorModifier(Double modifier) {
            this.floorModifier = modifier;
            return this;
        }

        public Builder varianceModifier(Double modifier) {
            this.varianceModifier = modifier;
            return this;
        }

        public Builder fantasyPointsModifier(Double modifier) {
            this.fantasyPointsModifier = modifier;
            return this;
        }

        public Builder effectProbability(Double probability) {
            this.effectProbability = probability;
            return this;
        }

        public EventEffect build() {
            return new EventEffect(type, application, statModifiers, availabilityChance,
                    forceOut, ceilingModifier, floorModifier, varianceModifier,
                    fantasyPointsModifier, bonusModifiers, effectProbability);
        }
    }
}
