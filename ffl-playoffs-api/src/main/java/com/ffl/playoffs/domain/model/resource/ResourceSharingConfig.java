package com.ffl.playoffs.domain.model.resource;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.time.Duration;
import java.util.Objects;

/**
 * Immutable value object representing resource sharing configuration between worlds.
 */
@Getter
@ToString
@EqualsAndHashCode
public final class ResourceSharingConfig {
    private final boolean enabled;
    private final SharingMode mode;
    private final Double maxSharePercent;
    private final SharingPriority priority;
    private final Duration reclaimDelay;

    private ResourceSharingConfig(boolean enabled, SharingMode mode, Double maxSharePercent,
                                  SharingPriority priority, Duration reclaimDelay) {
        this.enabled = enabled;
        this.mode = mode != null ? mode : SharingMode.DISABLED;
        this.maxSharePercent = maxSharePercent != null ? maxSharePercent : 50.0;
        this.priority = priority != null ? priority : SharingPriority.EQUAL;
        this.reclaimDelay = reclaimDelay != null ? reclaimDelay : Duration.ofSeconds(60);

        if (this.maxSharePercent < 0 || this.maxSharePercent > 100) {
            throw new IllegalArgumentException("Max share percent must be between 0 and 100");
        }
    }

    public static ResourceSharingConfig disabled() {
        return new ResourceSharingConfig(false, SharingMode.DISABLED, 0.0,
                                         SharingPriority.EQUAL, Duration.ZERO);
    }

    public static ResourceSharingConfig dynamic(Double maxSharePercent) {
        return new ResourceSharingConfig(true, SharingMode.DYNAMIC, maxSharePercent,
                                         SharingPriority.EQUAL, Duration.ofSeconds(60));
    }

    public static ResourceSharingConfig create(SharingMode mode, Double maxSharePercent,
                                               SharingPriority priority, Duration reclaimDelay) {
        return new ResourceSharingConfig(mode != SharingMode.DISABLED, mode, maxSharePercent,
                                         priority, reclaimDelay);
    }

    /**
     * Calculate shareable amount based on available resources.
     */
    public Double calculateShareableAmount(Double availableResources) {
        if (!enabled || availableResources == null) {
            return 0.0;
        }
        return availableResources * (maxSharePercent / 100.0);
    }

    /**
     * Create a copy with enabled state.
     */
    public ResourceSharingConfig withEnabled(boolean enabled) {
        return new ResourceSharingConfig(enabled, this.mode, this.maxSharePercent,
                                         this.priority, this.reclaimDelay);
    }

    public enum SharingMode {
        DISABLED,
        STATIC,
        DYNAMIC
    }

    public enum SharingPriority {
        EQUAL,
        OWNER_FIRST,
        BORROWER_FIRST
    }
}
