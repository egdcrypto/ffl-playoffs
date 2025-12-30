package com.ffl.playoffs.domain.model.resource;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.time.Duration;
import java.util.Objects;
import java.util.UUID;

/**
 * Immutable value object representing an auto-scaling rule.
 */
@Getter
@ToString
@EqualsAndHashCode
public final class AutoScalingRule {
    private final UUID id;
    private final String metricName;
    private final Double threshold;
    private final ScalingAction action;
    private final Duration cooldown;
    private final boolean enabled;

    private AutoScalingRule(UUID id, String metricName, Double threshold,
                           ScalingAction action, Duration cooldown, boolean enabled) {
        this.id = id != null ? id : UUID.randomUUID();
        this.metricName = Objects.requireNonNull(metricName, "Metric name is required");
        this.threshold = Objects.requireNonNull(threshold, "Threshold is required");
        this.action = Objects.requireNonNull(action, "Action is required");
        this.cooldown = cooldown != null ? cooldown : Duration.ofMinutes(5);
        this.enabled = enabled;

        if (this.threshold < 0 || this.threshold > 100) {
            throw new IllegalArgumentException("Threshold must be between 0 and 100");
        }
    }

    public static AutoScalingRule create(String metricName, Double threshold, ScalingAction action) {
        return new AutoScalingRule(null, metricName, threshold, action, Duration.ofMinutes(5), true);
    }

    public static AutoScalingRule create(String metricName, Double threshold, ScalingAction action,
                                         Duration cooldown) {
        return new AutoScalingRule(null, metricName, threshold, action, cooldown, true);
    }

    /**
     * Check if this rule should trigger based on current value.
     */
    public boolean shouldTrigger(Double currentValue) {
        if (!enabled || currentValue == null) {
            return false;
        }

        return switch (action) {
            case SCALE_UP -> currentValue >= threshold;
            case SCALE_DOWN -> currentValue <= threshold;
            case NO_ACTION -> false;
        };
    }

    /**
     * Create a copy with enabled state.
     */
    public AutoScalingRule withEnabled(boolean enabled) {
        return new AutoScalingRule(this.id, this.metricName, this.threshold,
                                   this.action, this.cooldown, enabled);
    }

    /**
     * Create a copy with new threshold.
     */
    public AutoScalingRule withThreshold(Double newThreshold) {
        return new AutoScalingRule(this.id, this.metricName, newThreshold,
                                   this.action, this.cooldown, this.enabled);
    }

    /**
     * Create a copy with new cooldown.
     */
    public AutoScalingRule withCooldown(Duration newCooldown) {
        return new AutoScalingRule(this.id, this.metricName, this.threshold,
                                   this.action, newCooldown, this.enabled);
    }
}
