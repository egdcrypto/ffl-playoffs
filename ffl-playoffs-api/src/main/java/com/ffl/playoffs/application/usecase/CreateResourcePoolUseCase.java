package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.ResourcePool;
import com.ffl.playoffs.domain.model.resource.ResourceType;
import com.ffl.playoffs.domain.port.ResourcePoolRepository;
import lombok.Builder;
import lombok.Getter;

import java.time.Instant;
import java.util.Map;
import java.util.UUID;

/**
 * Use case for creating a resource pool for a subscription.
 */
public class CreateResourcePoolUseCase {

    private final ResourcePoolRepository resourcePoolRepository;

    public CreateResourcePoolUseCase(ResourcePoolRepository resourcePoolRepository) {
        this.resourcePoolRepository = resourcePoolRepository;
    }

    /**
     * Creates a resource pool for an owner.
     *
     * @param command The create resource pool command
     * @return The created ResourcePool
     * @throws IllegalArgumentException if pool already exists for owner
     */
    public ResourcePool execute(CreateResourcePoolCommand command) {
        // Validate owner doesn't already have a pool
        if (resourcePoolRepository.existsByOwnerId(command.getOwnerId())) {
            throw new IllegalArgumentException("Resource pool already exists for owner: " + command.getOwnerId());
        }

        // Create resource pool
        ResourcePool pool = ResourcePool.create(command.getOwnerId(), command.getSubscriptionTier());

        // Set limits based on subscription tier
        if (command.getLimits() != null) {
            for (Map.Entry<ResourceType, Double> entry : command.getLimits().entrySet()) {
                pool.setLimit(entry.getKey(), entry.getValue());
            }
        }

        // Set burst limits if provided
        if (command.getBurstLimits() != null) {
            for (Map.Entry<ResourceType, Double> entry : command.getBurstLimits().entrySet()) {
                pool.setBurstLimit(entry.getKey(), entry.getValue());
            }
        }

        // Set billing period if provided
        if (command.getBillingPeriodStart() != null && command.getBillingPeriodEnd() != null) {
            pool.setBillingPeriod(command.getBillingPeriodStart(), command.getBillingPeriodEnd());
        }

        // Configure budget if provided
        if (command.getMonthlyBudget() != null) {
            pool.configureBudget(ResourcePool.BudgetConfig.create(command.getMonthlyBudget()));
        }

        // Persist and return
        return resourcePoolRepository.save(pool);
    }

    @Getter
    @Builder
    public static class CreateResourcePoolCommand {
        private final UUID ownerId;
        private final String subscriptionTier;
        private final Map<ResourceType, Double> limits;
        private final Map<ResourceType, Double> burstLimits;
        private final Instant billingPeriodStart;
        private final Instant billingPeriodEnd;
        private final Double monthlyBudget;
    }
}
