package com.ffl.playoffs.domain.model.resource;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.util.Objects;

/**
 * Immutable value object representing a resource quota (limit) for a world.
 */
@Getter
@ToString
@EqualsAndHashCode
public final class ResourceQuota {
    private final ResourceType resourceType;
    private final Double limit;
    private final Double used;
    private final QuotaPeriod period;
    private final boolean enforced;

    private ResourceQuota(ResourceType resourceType, Double limit, Double used, QuotaPeriod period, boolean enforced) {
        this.resourceType = Objects.requireNonNull(resourceType, "Resource type is required");
        this.limit = Objects.requireNonNull(limit, "Limit is required");
        this.used = used != null ? used : 0.0;
        this.period = period != null ? period : QuotaPeriod.MONTHLY;
        this.enforced = enforced;

        if (this.limit < 0) {
            throw new IllegalArgumentException("Limit cannot be negative");
        }
    }

    public static ResourceQuota of(ResourceType type, Double limit) {
        return new ResourceQuota(type, limit, 0.0, QuotaPeriod.MONTHLY, true);
    }

    public static ResourceQuota of(ResourceType type, Double limit, boolean enforced) {
        return new ResourceQuota(type, limit, 0.0, QuotaPeriod.MONTHLY, enforced);
    }

    public static ResourceQuota create(ResourceType type, Double limit, QuotaPeriod period, boolean enforced) {
        return new ResourceQuota(type, limit, 0.0, period, enforced);
    }

    public enum QuotaPeriod {
        HOURLY,
        DAILY,
        WEEKLY,
        MONTHLY,
        YEARLY
    }

    /**
     * Get remaining quota.
     */
    public Double getRemaining() {
        return Math.max(0, limit - used);
    }

    /**
     * Get usage percentage.
     */
    public Double getUsagePercentage() {
        if (limit == 0) return 0.0;
        return (used / limit) * 100;
    }

    /**
     * Check if quota is exceeded.
     */
    public boolean isExceeded() {
        return used >= limit;
    }

    /**
     * Check if quota would be exceeded by additional usage.
     */
    public boolean wouldExceed(Double additionalUsage) {
        return (used + additionalUsage) > limit;
    }

    /**
     * Create a new quota with updated used amount.
     */
    public ResourceQuota withUsed(Double newUsed) {
        return new ResourceQuota(this.resourceType, this.limit, newUsed, this.period, this.enforced);
    }

    /**
     * Create a new quota with updated limit.
     */
    public ResourceQuota withLimit(Double newLimit) {
        return new ResourceQuota(this.resourceType, newLimit, this.used, this.period, this.enforced);
    }

    /**
     * Add usage to this quota.
     */
    public ResourceQuota addUsage(Double amount) {
        return new ResourceQuota(this.resourceType, this.limit, this.used + amount, this.period, this.enforced);
    }
}
