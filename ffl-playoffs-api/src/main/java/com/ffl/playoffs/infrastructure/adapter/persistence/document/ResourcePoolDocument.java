package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.util.Map;

/**
 * MongoDB document for ResourcePool aggregate.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "resource_pools")
public class ResourcePoolDocument {

    @Id
    private String id;

    @Indexed(unique = true)
    private String ownerId;

    @Indexed
    private String subscriptionTier;

    private Map<String, Double> totalLimits;
    private Map<String, Double> allocatedToWorlds;
    private Map<String, Double> totalUsed;
    private Map<String, ResourceThresholdEmbedded> thresholds;
    private Map<String, Double> burstLimits;
    private BudgetConfigEmbedded budgetConfig;
    private Instant billingPeriodStart;
    private Instant billingPeriodEnd;
    private Instant createdAt;
    private Instant updatedAt;

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
    public static class BudgetConfigEmbedded {
        private Double monthlyBudget;
        private Double alertAt80Percent;
        private Double alertAt100Percent;
        private boolean hardLimitEnabled;
    }
}
