package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.WorldResources;
import com.ffl.playoffs.domain.model.resource.*;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldResourcesDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldResourcesDocument.*;
import org.springframework.stereotype.Component;

import java.time.Duration;
import java.util.*;
import java.util.stream.Collectors;

/**
 * Mapper to convert between WorldResources domain aggregate and WorldResourcesDocument.
 */
@Component
public class WorldResourcesMapper {

    public WorldResourcesDocument toDocument(WorldResources domain) {
        if (domain == null) {
            return null;
        }

        return WorldResourcesDocument.builder()
                .id(domain.getId() != null ? domain.getId().toString() : null)
                .worldId(domain.getWorldId() != null ? domain.getWorldId().toString() : null)
                .ownerId(domain.getOwnerId() != null ? domain.getOwnerId().toString() : null)
                .worldName(domain.getWorldName())
                .priority(domain.getPriority() != null ? domain.getPriority().name() : null)
                .allocations(toAllocationDocuments(domain.getAllocations()))
                .quotas(toQuotaDocuments(domain.getQuotas()))
                .thresholds(toThresholdDocuments(domain.getThresholds()))
                .autoScalingRules(toAutoScalingRuleDocuments(domain.getAutoScalingRules()))
                .autoScalingConfig(toAutoScalingConfigDocument(domain.getAutoScalingConfig()))
                .sharingConfig(toSharingConfigDocument(domain.getSharingConfig()))
                .overLimitConfig(toOverLimitConfigDocument(domain.getOverLimitConfig()))
                .createdAt(domain.getCreatedAt())
                .updatedAt(domain.getUpdatedAt())
                .build();
    }

    public WorldResources toDomain(WorldResourcesDocument document) {
        if (document == null) {
            return null;
        }

        return WorldResources.builder()
                .id(document.getId() != null ? UUID.fromString(document.getId()) : null)
                .worldId(document.getWorldId() != null ? UUID.fromString(document.getWorldId()) : null)
                .ownerId(document.getOwnerId() != null ? UUID.fromString(document.getOwnerId()) : null)
                .worldName(document.getWorldName())
                .priority(document.getPriority() != null ? ResourcePriority.valueOf(document.getPriority()) : ResourcePriority.NORMAL)
                .allocations(toAllocationDomains(document.getAllocations()))
                .quotas(toQuotaDomains(document.getQuotas()))
                .thresholds(toThresholdDomains(document.getThresholds()))
                .autoScalingRules(toAutoScalingRuleDomains(document.getAutoScalingRules()))
                .autoScalingConfig(toAutoScalingConfigDomain(document.getAutoScalingConfig()))
                .sharingConfig(toSharingConfigDomain(document.getSharingConfig()))
                .overLimitConfig(toOverLimitConfigDomain(document.getOverLimitConfig()))
                .createdAt(document.getCreatedAt())
                .updatedAt(document.getUpdatedAt())
                .build();
    }

    private Map<String, ResourceAllocationEmbedded> toAllocationDocuments(Map<ResourceType, ResourceAllocation> allocations) {
        if (allocations == null) {
            return null;
        }
        Map<String, ResourceAllocationEmbedded> result = new HashMap<>();
        for (Map.Entry<ResourceType, ResourceAllocation> entry : allocations.entrySet()) {
            ResourceAllocation alloc = entry.getValue();
            result.put(entry.getKey().name(), ResourceAllocationEmbedded.builder()
                    .resourceType(alloc.getResourceType().name())
                    .allocated(alloc.getAllocated())
                    .reserved(alloc.getReserved())
                    .used(alloc.getUsed())
                    .build());
        }
        return result;
    }

    private Map<ResourceType, ResourceAllocation> toAllocationDomains(Map<String, ResourceAllocationEmbedded> documents) {
        if (documents == null) {
            return new HashMap<>();
        }
        Map<ResourceType, ResourceAllocation> result = new HashMap<>();
        for (Map.Entry<String, ResourceAllocationEmbedded> entry : documents.entrySet()) {
            ResourceAllocationEmbedded doc = entry.getValue();
            ResourceType type = ResourceType.valueOf(entry.getKey());
            result.put(type, ResourceAllocation.of(type, doc.getAllocated(), doc.getReserved(), doc.getUsed()));
        }
        return result;
    }

    private Map<String, ResourceQuotaEmbedded> toQuotaDocuments(Map<ResourceType, ResourceQuota> quotas) {
        if (quotas == null) {
            return null;
        }
        Map<String, ResourceQuotaEmbedded> result = new HashMap<>();
        for (Map.Entry<ResourceType, ResourceQuota> entry : quotas.entrySet()) {
            ResourceQuota quota = entry.getValue();
            result.put(entry.getKey().name(), ResourceQuotaEmbedded.builder()
                    .resourceType(quota.getResourceType().name())
                    .limit(quota.getLimit())
                    .used(quota.getUsed())
                    .period(quota.getPeriod() != null ? quota.getPeriod().name() : null)
                    .enforced(quota.isEnforced())
                    .build());
        }
        return result;
    }

    private Map<ResourceType, ResourceQuota> toQuotaDomains(Map<String, ResourceQuotaEmbedded> documents) {
        if (documents == null) {
            return new HashMap<>();
        }
        Map<ResourceType, ResourceQuota> result = new HashMap<>();
        for (Map.Entry<String, ResourceQuotaEmbedded> entry : documents.entrySet()) {
            ResourceQuotaEmbedded doc = entry.getValue();
            ResourceType type = ResourceType.valueOf(entry.getKey());
            ResourceQuota.QuotaPeriod period = doc.getPeriod() != null ?
                    ResourceQuota.QuotaPeriod.valueOf(doc.getPeriod()) : ResourceQuota.QuotaPeriod.MONTHLY;
            result.put(type, ResourceQuota.create(type, doc.getLimit(), period, doc.isEnforced())
                    .addUsage(doc.getUsed() != null ? doc.getUsed() : 0.0));
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

    private List<AutoScalingRuleEmbedded> toAutoScalingRuleDocuments(List<AutoScalingRule> rules) {
        if (rules == null) {
            return null;
        }
        return rules.stream()
                .map(rule -> AutoScalingRuleEmbedded.builder()
                        .id(rule.getId() != null ? rule.getId().toString() : null)
                        .metricName(rule.getMetricName())
                        .threshold(rule.getThreshold())
                        .action(rule.getAction() != null ? rule.getAction().name() : null)
                        .cooldownSeconds(rule.getCooldown() != null ? rule.getCooldown().getSeconds() : null)
                        .enabled(rule.isEnabled())
                        .build())
                .collect(Collectors.toList());
    }

    private List<AutoScalingRule> toAutoScalingRuleDomains(List<AutoScalingRuleEmbedded> documents) {
        if (documents == null) {
            return new ArrayList<>();
        }
        return documents.stream()
                .map(doc -> AutoScalingRule.create(
                        doc.getMetricName(),
                        doc.getThreshold(),
                        doc.getAction() != null ? ScalingAction.valueOf(doc.getAction()) : ScalingAction.NO_ACTION,
                        doc.getCooldownSeconds() != null ? Duration.ofSeconds(doc.getCooldownSeconds()) : Duration.ofMinutes(5))
                        .withEnabled(doc.isEnabled()))
                .collect(Collectors.toList());
    }

    private AutoScalingConfigEmbedded toAutoScalingConfigDocument(WorldResources.AutoScalingConfig config) {
        if (config == null) {
            return null;
        }
        return AutoScalingConfigEmbedded.builder()
                .enabled(config.isEnabled())
                .minInstances(config.getMinInstances())
                .maxInstances(config.getMaxInstances())
                .maxCostPerHour(config.getMaxCostPerHour())
                .paused(config.isPaused())
                .build();
    }

    private WorldResources.AutoScalingConfig toAutoScalingConfigDomain(AutoScalingConfigEmbedded document) {
        if (document == null) {
            return WorldResources.AutoScalingConfig.disabled();
        }
        return WorldResources.AutoScalingConfig.builder()
                .enabled(document.isEnabled())
                .minInstances(document.getMinInstances())
                .maxInstances(document.getMaxInstances())
                .maxCostPerHour(document.getMaxCostPerHour())
                .paused(document.isPaused())
                .build();
    }

    private ResourceSharingConfigEmbedded toSharingConfigDocument(ResourceSharingConfig config) {
        if (config == null) {
            return null;
        }
        return ResourceSharingConfigEmbedded.builder()
                .enabled(config.isEnabled())
                .mode(config.getMode() != null ? config.getMode().name() : null)
                .maxSharePercent(config.getMaxSharePercent())
                .priority(config.getPriority() != null ? config.getPriority().name() : null)
                .reclaimDelaySeconds(config.getReclaimDelay() != null ? config.getReclaimDelay().getSeconds() : null)
                .build();
    }

    private ResourceSharingConfig toSharingConfigDomain(ResourceSharingConfigEmbedded document) {
        if (document == null) {
            return ResourceSharingConfig.disabled();
        }
        ResourceSharingConfig.SharingMode mode = document.getMode() != null ?
                ResourceSharingConfig.SharingMode.valueOf(document.getMode()) : ResourceSharingConfig.SharingMode.DISABLED;
        ResourceSharingConfig.SharingPriority priority = document.getPriority() != null ?
                ResourceSharingConfig.SharingPriority.valueOf(document.getPriority()) : ResourceSharingConfig.SharingPriority.EQUAL;
        Duration reclaimDelay = document.getReclaimDelaySeconds() != null ?
                Duration.ofSeconds(document.getReclaimDelaySeconds()) : Duration.ofSeconds(60);
        return ResourceSharingConfig.create(mode, document.getMaxSharePercent(), priority, reclaimDelay);
    }

    private OverLimitConfigEmbedded toOverLimitConfigDocument(WorldResources.OverLimitConfig config) {
        if (config == null) {
            return null;
        }
        return OverLimitConfigEmbedded.builder()
                .behavior(config.getBehavior() != null ? config.getBehavior().name() : null)
                .gracePeriodMinutes(config.getGracePeriodMinutes())
                .autoUpgradePrompt(config.isAutoUpgradePrompt())
                .burstEnabled(config.isBurstEnabled())
                .burstLimitPercent(config.getBurstLimitPercent())
                .build();
    }

    private WorldResources.OverLimitConfig toOverLimitConfigDomain(OverLimitConfigEmbedded document) {
        if (document == null) {
            return WorldResources.OverLimitConfig.defaultConfig();
        }
        return WorldResources.OverLimitConfig.builder()
                .behavior(document.getBehavior() != null ?
                        OverLimitBehavior.valueOf(document.getBehavior()) : OverLimitBehavior.THROTTLE)
                .gracePeriodMinutes(document.getGracePeriodMinutes())
                .autoUpgradePrompt(document.isAutoUpgradePrompt())
                .burstEnabled(document.isBurstEnabled())
                .burstLimitPercent(document.getBurstLimitPercent())
                .build();
    }
}
