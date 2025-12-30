package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.ResourcePool;
import com.ffl.playoffs.domain.model.resource.ResourceType;
import com.ffl.playoffs.domain.port.ResourcePoolRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for retrieving resource pool information.
 */
public class GetResourcePoolUseCase {

    private final ResourcePoolRepository resourcePoolRepository;

    public GetResourcePoolUseCase(ResourcePoolRepository resourcePoolRepository) {
        this.resourcePoolRepository = resourcePoolRepository;
    }

    /**
     * Gets resource pool for an owner.
     *
     * @param ownerId The owner ID
     * @return Optional containing the ResourcePool if found
     */
    public Optional<ResourcePool> getByOwnerId(UUID ownerId) {
        return resourcePoolRepository.findByOwnerId(ownerId);
    }

    /**
     * Gets resource pool summary with threshold status.
     *
     * @param ownerId The owner ID
     * @return ResourcePoolSummary if pool found
     * @throws IllegalArgumentException if pool not found
     */
    public ResourcePoolSummary getResourcePoolSummary(UUID ownerId) {
        ResourcePool pool = resourcePoolRepository.findByOwnerId(ownerId)
                .orElseThrow(() -> new IllegalArgumentException("Resource pool not found for owner: " + ownerId));

        return ResourcePoolSummary.builder()
                .ownerId(pool.getOwnerId())
                .subscriptionTier(pool.getSubscriptionTier())
                .resourcesAtWarning(pool.getResourcesAtWarningLevel())
                .resourcesAtCritical(pool.getResourcesAtCriticalLevel())
                .billingPeriodStart(pool.getBillingPeriodStart())
                .billingPeriodEnd(pool.getBillingPeriodEnd())
                .build();
    }

    @Getter
    @Builder
    public static class ResourcePoolSummary {
        private final UUID ownerId;
        private final String subscriptionTier;
        private final List<ResourceType> resourcesAtWarning;
        private final List<ResourceType> resourcesAtCritical;
        private final java.time.Instant billingPeriodStart;
        private final java.time.Instant billingPeriodEnd;
    }
}
