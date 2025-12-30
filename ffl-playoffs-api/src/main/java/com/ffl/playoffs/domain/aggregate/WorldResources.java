package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.resource.*;
import lombok.*;

import java.time.Instant;
import java.util.*;

/**
 * Aggregate root for managing resources allocated to a world.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WorldResources {
    private UUID id;
    private UUID worldId;
    private UUID ownerId;
    private String worldName;
    private ResourcePriority priority;
    private Map<ResourceType, ResourceAllocation> allocations;
    private Map<ResourceType, ResourceQuota> quotas;
    private Map<ResourceType, ResourceThreshold> thresholds;
    private List<AutoScalingRule> autoScalingRules;
    private AutoScalingConfig autoScalingConfig;
    private ResourceSharingConfig sharingConfig;
    private OverLimitConfig overLimitConfig;
    private Instant createdAt;
    private Instant updatedAt;

    /**
     * Create a new WorldResources for a world.
     */
    public static WorldResources create(UUID worldId, UUID ownerId, String worldName) {
        Objects.requireNonNull(worldId, "World ID is required");
        Objects.requireNonNull(ownerId, "Owner ID is required");

        WorldResources resources = new WorldResources();
        resources.id = UUID.randomUUID();
        resources.worldId = worldId;
        resources.ownerId = ownerId;
        resources.worldName = worldName;
        resources.priority = ResourcePriority.NORMAL;
        resources.allocations = new HashMap<>();
        resources.quotas = new HashMap<>();
        resources.thresholds = new HashMap<>();
        resources.autoScalingRules = new ArrayList<>();
        resources.autoScalingConfig = AutoScalingConfig.disabled();
        resources.sharingConfig = ResourceSharingConfig.disabled();
        resources.overLimitConfig = OverLimitConfig.defaultConfig();
        resources.createdAt = Instant.now();
        resources.updatedAt = Instant.now();

        return resources;
    }

    /**
     * Set resource allocation for a type.
     */
    public void setAllocation(ResourceType type, Double allocated) {
        Objects.requireNonNull(type, "Resource type is required");
        if (allocations == null) {
            allocations = new HashMap<>();
        }

        ResourceAllocation existing = allocations.get(type);
        if (existing != null) {
            allocations.put(type, existing.withAllocated(allocated));
        } else {
            allocations.put(type, ResourceAllocation.of(type, allocated));
        }
        this.updatedAt = Instant.now();
    }

    /**
     * Set resource reservation for a type.
     */
    public void setReservation(ResourceType type, Double reserved) {
        Objects.requireNonNull(type, "Resource type is required");
        if (allocations == null) {
            allocations = new HashMap<>();
        }

        ResourceAllocation existing = allocations.get(type);
        if (existing != null) {
            allocations.put(type, existing.withReserved(reserved));
        } else {
            allocations.put(type, ResourceAllocation.of(type, 0.0, reserved));
        }
        this.updatedAt = Instant.now();
    }

    /**
     * Record resource usage.
     */
    public void recordUsage(ResourceType type, Double amount) {
        Objects.requireNonNull(type, "Resource type is required");

        if (allocations == null) {
            allocations = new HashMap<>();
        }

        ResourceAllocation existing = allocations.get(type);
        if (existing != null) {
            allocations.put(type, existing.addUsage(amount));
        }

        // Update quota usage if enforced
        if (quotas != null && quotas.containsKey(type)) {
            ResourceQuota quota = quotas.get(type);
            quotas.put(type, quota.addUsage(amount));
        }

        this.updatedAt = Instant.now();
    }

    /**
     * Set quota for a resource type.
     */
    public void setQuota(ResourceType type, Double limit) {
        Objects.requireNonNull(type, "Resource type is required");
        if (quotas == null) {
            quotas = new HashMap<>();
        }
        quotas.put(type, ResourceQuota.of(type, limit));
        this.updatedAt = Instant.now();
    }

    /**
     * Set threshold for a resource type.
     */
    public void setThreshold(ResourceType type, Double warningPercent, Double criticalPercent) {
        Objects.requireNonNull(type, "Resource type is required");
        if (thresholds == null) {
            thresholds = new HashMap<>();
        }
        thresholds.put(type, ResourceThreshold.of(type, warningPercent, criticalPercent));
        this.updatedAt = Instant.now();
    }

    /**
     * Set priority for this world's resources.
     */
    public void setPriority(ResourcePriority priority) {
        this.priority = Objects.requireNonNull(priority, "Priority is required");
        this.updatedAt = Instant.now();
    }

    /**
     * Add an auto-scaling rule.
     */
    public void addAutoScalingRule(AutoScalingRule rule) {
        Objects.requireNonNull(rule, "Rule is required");
        if (autoScalingRules == null) {
            autoScalingRules = new ArrayList<>();
        }
        autoScalingRules.add(rule);
        this.updatedAt = Instant.now();
    }

    /**
     * Remove an auto-scaling rule.
     */
    public boolean removeAutoScalingRule(UUID ruleId) {
        if (autoScalingRules == null || ruleId == null) {
            return false;
        }
        boolean removed = autoScalingRules.removeIf(r -> r.getId().equals(ruleId));
        if (removed) {
            this.updatedAt = Instant.now();
        }
        return removed;
    }

    /**
     * Configure auto-scaling.
     */
    public void configureAutoScaling(AutoScalingConfig config) {
        this.autoScalingConfig = Objects.requireNonNull(config, "Config is required");
        this.updatedAt = Instant.now();
    }

    /**
     * Enable auto-scaling.
     */
    public void enableAutoScaling() {
        if (autoScalingConfig == null) {
            autoScalingConfig = AutoScalingConfig.enabled();
        } else {
            autoScalingConfig = autoScalingConfig.withEnabled(true);
        }
        this.updatedAt = Instant.now();
    }

    /**
     * Disable auto-scaling.
     */
    public void disableAutoScaling() {
        if (autoScalingConfig != null) {
            autoScalingConfig = autoScalingConfig.withEnabled(false);
        }
        this.updatedAt = Instant.now();
    }

    /**
     * Configure resource sharing.
     */
    public void configureSharingConfig(ResourceSharingConfig config) {
        this.sharingConfig = Objects.requireNonNull(config, "Config is required");
        this.updatedAt = Instant.now();
    }

    /**
     * Enable resource sharing.
     */
    public void enableSharing() {
        if (sharingConfig == null) {
            sharingConfig = ResourceSharingConfig.dynamic(50.0);
        } else {
            sharingConfig = sharingConfig.withEnabled(true);
        }
        this.updatedAt = Instant.now();
    }

    /**
     * Disable resource sharing.
     */
    public void disableSharing() {
        sharingConfig = ResourceSharingConfig.disabled();
        this.updatedAt = Instant.now();
    }

    /**
     * Configure over-limit behavior.
     */
    public void configureOverLimitBehavior(OverLimitConfig config) {
        this.overLimitConfig = Objects.requireNonNull(config, "Config is required");
        this.updatedAt = Instant.now();
    }

    /**
     * Get allocation for a resource type.
     */
    public Optional<ResourceAllocation> getAllocation(ResourceType type) {
        if (allocations == null) {
            return Optional.empty();
        }
        return Optional.ofNullable(allocations.get(type));
    }

    /**
     * Get quota for a resource type.
     */
    public Optional<ResourceQuota> getQuota(ResourceType type) {
        if (quotas == null) {
            return Optional.empty();
        }
        return Optional.ofNullable(quotas.get(type));
    }

    /**
     * Get threshold for a resource type.
     */
    public Optional<ResourceThreshold> getThreshold(ResourceType type) {
        if (thresholds == null) {
            return Optional.empty();
        }
        return Optional.ofNullable(thresholds.get(type));
    }

    /**
     * Check if any resource exceeds its warning threshold.
     */
    public List<ResourceType> getResourcesAtWarningLevel() {
        List<ResourceType> warningResources = new ArrayList<>();
        if (allocations == null || thresholds == null) {
            return warningResources;
        }

        for (Map.Entry<ResourceType, ResourceAllocation> entry : allocations.entrySet()) {
            ResourceThreshold threshold = thresholds.get(entry.getKey());
            if (threshold != null && threshold.isWarning(entry.getValue().getUsagePercentage())) {
                warningResources.add(entry.getKey());
            }
        }
        return warningResources;
    }

    /**
     * Check if any resource exceeds its critical threshold.
     */
    public List<ResourceType> getResourcesAtCriticalLevel() {
        List<ResourceType> criticalResources = new ArrayList<>();
        if (allocations == null || thresholds == null) {
            return criticalResources;
        }

        for (Map.Entry<ResourceType, ResourceAllocation> entry : allocations.entrySet()) {
            ResourceThreshold threshold = thresholds.get(entry.getKey());
            if (threshold != null && threshold.isCritical(entry.getValue().getUsagePercentage())) {
                criticalResources.add(entry.getKey());
            }
        }
        return criticalResources;
    }

    /**
     * Get total allocated amount for a resource type.
     */
    public Double getTotalAllocated(ResourceType type) {
        return getAllocation(type).map(ResourceAllocation::getAllocated).orElse(0.0);
    }

    /**
     * Get total used amount for a resource type.
     */
    public Double getTotalUsed(ResourceType type) {
        return getAllocation(type).map(ResourceAllocation::getUsed).orElse(0.0);
    }

    /**
     * Check if auto-scaling is enabled.
     */
    public boolean isAutoScalingEnabled() {
        return autoScalingConfig != null && autoScalingConfig.isEnabled();
    }

    /**
     * Check if sharing is enabled.
     */
    public boolean isSharingEnabled() {
        return sharingConfig != null && sharingConfig.isEnabled();
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AutoScalingConfig {
        private boolean enabled;
        private Integer minInstances;
        private Integer maxInstances;
        private Double maxCostPerHour;
        private boolean paused;

        public static AutoScalingConfig disabled() {
            return AutoScalingConfig.builder()
                    .enabled(false)
                    .minInstances(1)
                    .maxInstances(1)
                    .paused(false)
                    .build();
        }

        public static AutoScalingConfig enabled() {
            return AutoScalingConfig.builder()
                    .enabled(true)
                    .minInstances(1)
                    .maxInstances(10)
                    .paused(false)
                    .build();
        }

        public AutoScalingConfig withEnabled(boolean enabled) {
            return AutoScalingConfig.builder()
                    .enabled(enabled)
                    .minInstances(this.minInstances)
                    .maxInstances(this.maxInstances)
                    .maxCostPerHour(this.maxCostPerHour)
                    .paused(this.paused)
                    .build();
        }
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OverLimitConfig {
        private OverLimitBehavior behavior;
        private Integer gracePeriodMinutes;
        private boolean autoUpgradePrompt;
        private boolean burstEnabled;
        private Double burstLimitPercent;

        public static OverLimitConfig defaultConfig() {
            return OverLimitConfig.builder()
                    .behavior(OverLimitBehavior.THROTTLE)
                    .gracePeriodMinutes(60)
                    .autoUpgradePrompt(true)
                    .burstEnabled(false)
                    .burstLimitPercent(100.0)
                    .build();
        }
    }
}
