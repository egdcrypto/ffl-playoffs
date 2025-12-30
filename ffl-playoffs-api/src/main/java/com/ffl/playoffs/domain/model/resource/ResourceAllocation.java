package com.ffl.playoffs.domain.model.resource;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.util.Objects;

/**
 * Immutable value object representing a resource allocation for a world.
 */
@Getter
@ToString
@EqualsAndHashCode
public final class ResourceAllocation {
    private final ResourceType resourceType;
    private final Double allocated;
    private final Double reserved;
    private final Double used;

    private ResourceAllocation(ResourceType resourceType, Double allocated, Double reserved, Double used) {
        this.resourceType = Objects.requireNonNull(resourceType, "Resource type is required");
        this.allocated = allocated != null ? allocated : 0.0;
        this.reserved = reserved != null ? reserved : 0.0;
        this.used = used != null ? used : 0.0;

        if (this.allocated < 0) {
            throw new IllegalArgumentException("Allocated cannot be negative");
        }
        if (this.reserved < 0 || this.reserved > this.allocated) {
            throw new IllegalArgumentException("Reserved must be between 0 and allocated");
        }
    }

    public static ResourceAllocation of(ResourceType type, Double allocated) {
        return new ResourceAllocation(type, allocated, 0.0, 0.0);
    }

    public static ResourceAllocation of(ResourceType type, Double allocated, Double reserved) {
        return new ResourceAllocation(type, allocated, reserved, 0.0);
    }

    public static ResourceAllocation of(ResourceType type, Double allocated, Double reserved, Double used) {
        return new ResourceAllocation(type, allocated, reserved, used);
    }

    /**
     * Get available (unallocated and unreserved) amount.
     */
    public Double getAvailable() {
        return Math.max(0, allocated - reserved - used);
    }

    /**
     * Get usage percentage.
     */
    public Double getUsagePercentage() {
        if (allocated == 0) return 0.0;
        return (used / allocated) * 100;
    }

    /**
     * Check if usage is above a threshold percentage.
     */
    public boolean isAboveThreshold(double thresholdPercent) {
        return getUsagePercentage() >= thresholdPercent;
    }

    /**
     * Create a new allocation with updated used amount.
     */
    public ResourceAllocation withUsed(Double newUsed) {
        return new ResourceAllocation(this.resourceType, this.allocated, this.reserved, newUsed);
    }

    /**
     * Create a new allocation with updated allocated amount.
     */
    public ResourceAllocation withAllocated(Double newAllocated) {
        return new ResourceAllocation(this.resourceType, newAllocated, this.reserved, this.used);
    }

    /**
     * Create a new allocation with updated reserved amount.
     */
    public ResourceAllocation withReserved(Double newReserved) {
        return new ResourceAllocation(this.resourceType, this.allocated, newReserved, this.used);
    }

    /**
     * Add usage to this allocation.
     */
    public ResourceAllocation addUsage(Double amount) {
        return new ResourceAllocation(this.resourceType, this.allocated, this.reserved, this.used + amount);
    }
}
