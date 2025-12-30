package com.ffl.playoffs.domain.model.resource;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.util.Objects;

/**
 * Immutable value object representing warning and critical thresholds for a resource.
 */
@Getter
@ToString
@EqualsAndHashCode
public final class ResourceThreshold {
    private final ResourceType resourceType;
    private final Double warningPercent;
    private final Double criticalPercent;

    private ResourceThreshold(ResourceType resourceType, Double warningPercent, Double criticalPercent) {
        this.resourceType = Objects.requireNonNull(resourceType, "Resource type is required");
        this.warningPercent = warningPercent != null ? warningPercent : 75.0;
        this.criticalPercent = criticalPercent != null ? criticalPercent : 90.0;

        if (this.warningPercent < 0 || this.warningPercent > 100) {
            throw new IllegalArgumentException("Warning percent must be between 0 and 100");
        }
        if (this.criticalPercent < 0 || this.criticalPercent > 100) {
            throw new IllegalArgumentException("Critical percent must be between 0 and 100");
        }
        if (this.warningPercent >= this.criticalPercent) {
            throw new IllegalArgumentException("Warning percent must be less than critical percent");
        }
    }

    public static ResourceThreshold of(ResourceType type, Double warningPercent, Double criticalPercent) {
        return new ResourceThreshold(type, warningPercent, criticalPercent);
    }

    public static ResourceThreshold defaultFor(ResourceType type) {
        return new ResourceThreshold(type, 75.0, 90.0);
    }

    /**
     * Check threshold level based on current usage percentage.
     */
    public ThresholdLevel checkLevel(Double usagePercent) {
        if (usagePercent == null) {
            return ThresholdLevel.NORMAL;
        }
        if (usagePercent >= criticalPercent) {
            return ThresholdLevel.CRITICAL;
        }
        if (usagePercent >= warningPercent) {
            return ThresholdLevel.WARNING;
        }
        return ThresholdLevel.NORMAL;
    }

    /**
     * Check if usage is at warning level.
     */
    public boolean isWarning(Double usagePercent) {
        return checkLevel(usagePercent) == ThresholdLevel.WARNING;
    }

    /**
     * Check if usage is at critical level.
     */
    public boolean isCritical(Double usagePercent) {
        return checkLevel(usagePercent) == ThresholdLevel.CRITICAL;
    }

    public enum ThresholdLevel {
        NORMAL,
        WARNING,
        CRITICAL
    }
}
