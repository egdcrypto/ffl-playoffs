package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.ResourcePool;
import com.ffl.playoffs.domain.model.resource.ResourceType;
import com.ffl.playoffs.domain.port.ResourcePoolRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.Map;
import java.util.UUID;

/**
 * Use case for updating resource pool limits and configuration.
 */
public class UpdateResourcePoolUseCase {

    private final ResourcePoolRepository resourcePoolRepository;

    public UpdateResourcePoolUseCase(ResourcePoolRepository resourcePoolRepository) {
        this.resourcePoolRepository = resourcePoolRepository;
    }

    /**
     * Updates a resource pool's limits and configuration.
     *
     * @param command The update resource pool command
     * @return The updated ResourcePool
     * @throws IllegalArgumentException if pool not found
     */
    public ResourcePool execute(UpdateResourcePoolCommand command) {
        // Find resource pool
        ResourcePool pool = resourcePoolRepository.findByOwnerId(command.getOwnerId())
                .orElseThrow(() -> new IllegalArgumentException("Resource pool not found for owner: " + command.getOwnerId()));

        // Update subscription tier if provided
        if (command.getSubscriptionTier() != null) {
            pool.setSubscriptionTier(command.getSubscriptionTier());
        }

        // Update limits if provided
        if (command.getLimits() != null) {
            for (Map.Entry<ResourceType, Double> entry : command.getLimits().entrySet()) {
                pool.setLimit(entry.getKey(), entry.getValue());
            }
        }

        // Update burst limits if provided
        if (command.getBurstLimits() != null) {
            for (Map.Entry<ResourceType, Double> entry : command.getBurstLimits().entrySet()) {
                pool.setBurstLimit(entry.getKey(), entry.getValue());
            }
        }

        // Update thresholds if provided
        if (command.getThresholds() != null) {
            for (Map.Entry<ResourceType, ThresholdConfig> entry : command.getThresholds().entrySet()) {
                ThresholdConfig config = entry.getValue();
                pool.setThreshold(entry.getKey(), config.getWarningPercent(), config.getCriticalPercent());
            }
        }

        // Update budget if provided
        if (command.getMonthlyBudget() != null) {
            pool.configureBudget(ResourcePool.BudgetConfig.create(command.getMonthlyBudget()));
        }

        // Save and return
        return resourcePoolRepository.save(pool);
    }

    @Getter
    @Builder
    public static class UpdateResourcePoolCommand {
        private final UUID ownerId;
        private final String subscriptionTier;
        private final Map<ResourceType, Double> limits;
        private final Map<ResourceType, Double> burstLimits;
        private final Map<ResourceType, ThresholdConfig> thresholds;
        private final Double monthlyBudget;
    }

    @Getter
    @Builder
    public static class ThresholdConfig {
        private final Double warningPercent;
        private final Double criticalPercent;
    }
}
