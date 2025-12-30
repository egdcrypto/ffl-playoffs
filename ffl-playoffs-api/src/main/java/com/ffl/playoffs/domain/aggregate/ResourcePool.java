package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.resource.*;
import lombok.*;

import java.time.Instant;
import java.util.*;

/**
 * Aggregate root for managing subscription-level resource pool.
 * Tracks total resources available and allocation across worlds.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ResourcePool {
    private UUID id;
    private UUID ownerId;
    private String subscriptionTier;
    private Map<ResourceType, Double> totalLimits;
    private Map<ResourceType, Double> allocatedToWorlds;
    private Map<ResourceType, Double> totalUsed;
    private Map<ResourceType, ResourceThreshold> thresholds;
    private Map<ResourceType, Double> burstLimits;
    private BudgetConfig budgetConfig;
    private Instant billingPeriodStart;
    private Instant billingPeriodEnd;
    private Instant createdAt;
    private Instant updatedAt;

    /**
     * Create a new resource pool for an owner.
     */
    public static ResourcePool create(UUID ownerId, String subscriptionTier) {
        Objects.requireNonNull(ownerId, "Owner ID is required");

        ResourcePool pool = new ResourcePool();
        pool.id = UUID.randomUUID();
        pool.ownerId = ownerId;
        pool.subscriptionTier = subscriptionTier;
        pool.totalLimits = new HashMap<>();
        pool.allocatedToWorlds = new HashMap<>();
        pool.totalUsed = new HashMap<>();
        pool.thresholds = new HashMap<>();
        pool.burstLimits = new HashMap<>();
        pool.createdAt = Instant.now();
        pool.updatedAt = Instant.now();

        return pool;
    }

    /**
     * Set the total limit for a resource type based on subscription.
     */
    public void setLimit(ResourceType type, Double limit) {
        Objects.requireNonNull(type, "Resource type is required");
        if (totalLimits == null) {
            totalLimits = new HashMap<>();
        }
        totalLimits.put(type, limit);
        this.updatedAt = Instant.now();
    }

    /**
     * Set burst limit for a resource type (e.g., 120% of normal limit).
     */
    public void setBurstLimit(ResourceType type, Double burstLimitPercent) {
        Objects.requireNonNull(type, "Resource type is required");
        if (burstLimits == null) {
            burstLimits = new HashMap<>();
        }
        burstLimits.put(type, burstLimitPercent);
        this.updatedAt = Instant.now();
    }

    /**
     * Allocate resources to a world.
     */
    public boolean allocateToWorld(ResourceType type, Double amount) {
        Objects.requireNonNull(type, "Resource type is required");

        Double available = getAvailable(type);
        if (amount > available) {
            return false;
        }

        if (allocatedToWorlds == null) {
            allocatedToWorlds = new HashMap<>();
        }

        Double current = allocatedToWorlds.getOrDefault(type, 0.0);
        allocatedToWorlds.put(type, current + amount);
        this.updatedAt = Instant.now();
        return true;
    }

    /**
     * Release allocation from a world.
     */
    public void releaseFromWorld(ResourceType type, Double amount) {
        if (allocatedToWorlds == null) return;

        Double current = allocatedToWorlds.getOrDefault(type, 0.0);
        allocatedToWorlds.put(type, Math.max(0, current - amount));
        this.updatedAt = Instant.now();
    }

    /**
     * Record usage against the pool.
     */
    public void recordUsage(ResourceType type, Double amount) {
        if (totalUsed == null) {
            totalUsed = new HashMap<>();
        }

        Double current = totalUsed.getOrDefault(type, 0.0);
        totalUsed.put(type, current + amount);
        this.updatedAt = Instant.now();
    }

    /**
     * Get total limit for a resource type.
     */
    public Double getLimit(ResourceType type) {
        if (totalLimits == null) return 0.0;
        return totalLimits.getOrDefault(type, 0.0);
    }

    /**
     * Get available (unallocated) amount for a resource type.
     */
    public Double getAvailable(ResourceType type) {
        Double limit = getLimit(type);
        Double allocated = allocatedToWorlds != null ?
                allocatedToWorlds.getOrDefault(type, 0.0) : 0.0;
        return Math.max(0, limit - allocated);
    }

    /**
     * Get total allocated amount for a resource type.
     */
    public Double getAllocated(ResourceType type) {
        if (allocatedToWorlds == null) return 0.0;
        return allocatedToWorlds.getOrDefault(type, 0.0);
    }

    /**
     * Get total used amount for a resource type.
     */
    public Double getUsed(ResourceType type) {
        if (totalUsed == null) return 0.0;
        return totalUsed.getOrDefault(type, 0.0);
    }

    /**
     * Get usage percentage for a resource type.
     */
    public Double getUsagePercentage(ResourceType type) {
        Double limit = getLimit(type);
        if (limit == 0) return 0.0;
        return (getUsed(type) / limit) * 100;
    }

    /**
     * Check if a resource limit is exceeded.
     */
    public boolean isLimitExceeded(ResourceType type) {
        return getUsed(type) >= getLimit(type);
    }

    /**
     * Check if burst limit is exceeded.
     */
    public boolean isBurstLimitExceeded(ResourceType type) {
        if (burstLimits == null || !burstLimits.containsKey(type)) {
            return isLimitExceeded(type);
        }

        Double limit = getLimit(type);
        Double burstPercent = burstLimits.get(type);
        Double burstLimit = limit * (burstPercent / 100);
        return getUsed(type) >= burstLimit;
    }

    /**
     * Set threshold for a resource type.
     */
    public void setThreshold(ResourceType type, Double warningPercent, Double criticalPercent) {
        if (thresholds == null) {
            thresholds = new HashMap<>();
        }
        thresholds.put(type, ResourceThreshold.of(type, warningPercent, criticalPercent));
        this.updatedAt = Instant.now();
    }

    /**
     * Check threshold level for a resource type.
     */
    public ResourceThreshold.ThresholdLevel checkThresholdLevel(ResourceType type) {
        if (thresholds == null || !thresholds.containsKey(type)) {
            return ResourceThreshold.ThresholdLevel.NORMAL;
        }
        return thresholds.get(type).checkLevel(getUsagePercentage(type));
    }

    /**
     * Get resources at warning level.
     */
    public List<ResourceType> getResourcesAtWarningLevel() {
        List<ResourceType> warningResources = new ArrayList<>();
        if (thresholds == null) return warningResources;

        for (ResourceType type : thresholds.keySet()) {
            if (checkThresholdLevel(type) == ResourceThreshold.ThresholdLevel.WARNING) {
                warningResources.add(type);
            }
        }
        return warningResources;
    }

    /**
     * Get resources at critical level.
     */
    public List<ResourceType> getResourcesAtCriticalLevel() {
        List<ResourceType> criticalResources = new ArrayList<>();
        if (thresholds == null) return criticalResources;

        for (ResourceType type : thresholds.keySet()) {
            if (checkThresholdLevel(type) == ResourceThreshold.ThresholdLevel.CRITICAL) {
                criticalResources.add(type);
            }
        }
        return criticalResources;
    }

    /**
     * Configure budget settings.
     */
    public void configureBudget(BudgetConfig config) {
        this.budgetConfig = config;
        this.updatedAt = Instant.now();
    }

    /**
     * Set billing period.
     */
    public void setBillingPeriod(Instant start, Instant end) {
        this.billingPeriodStart = start;
        this.billingPeriodEnd = end;
        this.updatedAt = Instant.now();
    }

    /**
     * Reset usage for new billing period.
     */
    public void resetUsageForNewPeriod() {
        if (totalUsed != null) {
            totalUsed.clear();
        }
        this.updatedAt = Instant.now();
    }

    /**
     * Check if allocation would exceed limit.
     */
    public boolean canAllocate(ResourceType type, Double amount) {
        return amount <= getAvailable(type);
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class BudgetConfig {
        private Double monthlyBudget;
        private Double alertAt80Percent;
        private Double alertAt100Percent;
        private boolean hardLimitEnabled;

        public static BudgetConfig create(Double monthlyBudget) {
            return BudgetConfig.builder()
                    .monthlyBudget(monthlyBudget)
                    .alertAt80Percent(monthlyBudget * 0.8)
                    .alertAt100Percent(monthlyBudget)
                    .hardLimitEnabled(false)
                    .build();
        }
    }
}
