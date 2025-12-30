package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.ResourcePool;
import com.ffl.playoffs.domain.model.resource.ResourceThreshold;
import com.ffl.playoffs.domain.model.resource.ResourceType;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.ResourcePoolDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.ResourcePoolDocument.*;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Mapper to convert between ResourcePool domain aggregate and ResourcePoolDocument.
 */
@Component
public class ResourcePoolMapper {

    public ResourcePoolDocument toDocument(ResourcePool domain) {
        if (domain == null) {
            return null;
        }

        return ResourcePoolDocument.builder()
                .id(domain.getId() != null ? domain.getId().toString() : null)
                .ownerId(domain.getOwnerId() != null ? domain.getOwnerId().toString() : null)
                .subscriptionTier(domain.getSubscriptionTier())
                .totalLimits(toStringKeyMap(domain.getTotalLimits()))
                .allocatedToWorlds(toStringKeyMap(domain.getAllocatedToWorlds()))
                .totalUsed(toStringKeyMap(domain.getTotalUsed()))
                .thresholds(toThresholdDocuments(domain.getThresholds()))
                .burstLimits(toStringKeyMap(domain.getBurstLimits()))
                .budgetConfig(toBudgetConfigDocument(domain.getBudgetConfig()))
                .billingPeriodStart(domain.getBillingPeriodStart())
                .billingPeriodEnd(domain.getBillingPeriodEnd())
                .createdAt(domain.getCreatedAt())
                .updatedAt(domain.getUpdatedAt())
                .build();
    }

    public ResourcePool toDomain(ResourcePoolDocument document) {
        if (document == null) {
            return null;
        }

        return ResourcePool.builder()
                .id(document.getId() != null ? UUID.fromString(document.getId()) : null)
                .ownerId(document.getOwnerId() != null ? UUID.fromString(document.getOwnerId()) : null)
                .subscriptionTier(document.getSubscriptionTier())
                .totalLimits(toResourceTypeKeyMap(document.getTotalLimits()))
                .allocatedToWorlds(toResourceTypeKeyMap(document.getAllocatedToWorlds()))
                .totalUsed(toResourceTypeKeyMap(document.getTotalUsed()))
                .thresholds(toThresholdDomains(document.getThresholds()))
                .burstLimits(toResourceTypeKeyMap(document.getBurstLimits()))
                .budgetConfig(toBudgetConfigDomain(document.getBudgetConfig()))
                .billingPeriodStart(document.getBillingPeriodStart())
                .billingPeriodEnd(document.getBillingPeriodEnd())
                .createdAt(document.getCreatedAt())
                .updatedAt(document.getUpdatedAt())
                .build();
    }

    private Map<String, Double> toStringKeyMap(Map<ResourceType, Double> map) {
        if (map == null) {
            return null;
        }
        Map<String, Double> result = new HashMap<>();
        for (Map.Entry<ResourceType, Double> entry : map.entrySet()) {
            result.put(entry.getKey().name(), entry.getValue());
        }
        return result;
    }

    private Map<ResourceType, Double> toResourceTypeKeyMap(Map<String, Double> map) {
        if (map == null) {
            return new HashMap<>();
        }
        Map<ResourceType, Double> result = new HashMap<>();
        for (Map.Entry<String, Double> entry : map.entrySet()) {
            result.put(ResourceType.valueOf(entry.getKey()), entry.getValue());
        }
        return result;
    }

    private Map<String, ResourceThresholdEmbedded> toThresholdDocuments(Map<ResourceType, ResourceThreshold> thresholds) {
        if (thresholds == null) {
            return null;
        }
        Map<String, ResourceThresholdEmbedded> result = new HashMap<>();
        for (Map.Entry<ResourceType, ResourceThreshold> entry : thresholds.entrySet()) {
            ResourceThreshold threshold = entry.getValue();
            result.put(entry.getKey().name(), ResourceThresholdEmbedded.builder()
                    .resourceType(threshold.getResourceType().name())
                    .warningPercent(threshold.getWarningPercent())
                    .criticalPercent(threshold.getCriticalPercent())
                    .build());
        }
        return result;
    }

    private Map<ResourceType, ResourceThreshold> toThresholdDomains(Map<String, ResourceThresholdEmbedded> documents) {
        if (documents == null) {
            return new HashMap<>();
        }
        Map<ResourceType, ResourceThreshold> result = new HashMap<>();
        for (Map.Entry<String, ResourceThresholdEmbedded> entry : documents.entrySet()) {
            ResourceThresholdEmbedded doc = entry.getValue();
            ResourceType type = ResourceType.valueOf(entry.getKey());
            result.put(type, ResourceThreshold.of(type, doc.getWarningPercent(), doc.getCriticalPercent()));
        }
        return result;
    }

    private BudgetConfigEmbedded toBudgetConfigDocument(ResourcePool.BudgetConfig config) {
        if (config == null) {
            return null;
        }
        return BudgetConfigEmbedded.builder()
                .monthlyBudget(config.getMonthlyBudget())
                .alertAt80Percent(config.getAlertAt80Percent())
                .alertAt100Percent(config.getAlertAt100Percent())
                .hardLimitEnabled(config.isHardLimitEnabled())
                .build();
    }

    private ResourcePool.BudgetConfig toBudgetConfigDomain(BudgetConfigEmbedded document) {
        if (document == null) {
            return null;
        }
        return ResourcePool.BudgetConfig.builder()
                .monthlyBudget(document.getMonthlyBudget())
                .alertAt80Percent(document.getAlertAt80Percent())
                .alertAt100Percent(document.getAlertAt100Percent())
                .hardLimitEnabled(document.isHardLimitEnabled())
                .build();
    }
}
