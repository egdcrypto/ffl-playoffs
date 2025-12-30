package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.util.List;
import java.util.Map;

/**
 * MongoDB document for WorldResources aggregate.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "world_resources")
public class WorldResourcesDocument {

    @Id
    private String id;

    @Indexed(unique = true)
    private String worldId;

    @Indexed
    private String ownerId;

    private String worldName;
    private String priority;
    private Map<String, ResourceAllocationEmbedded> allocations;
    private Map<String, ResourceQuotaEmbedded> quotas;
    private Map<String, ResourceThresholdEmbedded> thresholds;
    private List<AutoScalingRuleEmbedded> autoScalingRules;
    private AutoScalingConfigEmbedded autoScalingConfig;
    private ResourceSharingConfigEmbedded sharingConfig;
    private OverLimitConfigEmbedded overLimitConfig;
    private Instant createdAt;
    private Instant updatedAt;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ResourceAllocationEmbedded {
        private String resourceType;
        private Double allocated;
        private Double reserved;
        private Double used;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ResourceQuotaEmbedded {
        private String resourceType;
        private Double limit;
        private Double used;
        private String period;
        private boolean enforced;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ResourceThresholdEmbedded {
        private String resourceType;
        private Double warningPercent;
        private Double criticalPercent;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AutoScalingRuleEmbedded {
        private String id;
        private String metricName;
        private Double threshold;
        private String action;
        private Long cooldownSeconds;
        private boolean enabled;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AutoScalingConfigEmbedded {
        private boolean enabled;
        private Integer minInstances;
        private Integer maxInstances;
        private Double maxCostPerHour;
        private boolean paused;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ResourceSharingConfigEmbedded {
        private boolean enabled;
        private String mode;
        private Double maxSharePercent;
        private String priority;
        private Long reclaimDelaySeconds;
    }

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class OverLimitConfigEmbedded {
        private String behavior;
        private Integer gracePeriodMinutes;
        private boolean autoUpgradePrompt;
        private boolean burstEnabled;
        private Double burstLimitPercent;
    }
}
