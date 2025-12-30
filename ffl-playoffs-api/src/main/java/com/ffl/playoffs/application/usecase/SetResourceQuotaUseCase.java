package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldResources;
import com.ffl.playoffs.domain.model.resource.ResourceType;
import com.ffl.playoffs.domain.port.WorldResourcesRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.Map;
import java.util.UUID;

/**
 * Use case for setting resource quotas for a world.
 */
public class SetResourceQuotaUseCase {

    private final WorldResourcesRepository worldResourcesRepository;

    public SetResourceQuotaUseCase(WorldResourcesRepository worldResourcesRepository) {
        this.worldResourcesRepository = worldResourcesRepository;
    }

    /**
     * Sets quotas for resources on a world.
     *
     * @param command The set quota command
     * @return The updated WorldResources
     * @throws IllegalArgumentException if world resources not found
     */
    public WorldResources execute(SetResourceQuotaCommand command) {
        // Find world resources
        WorldResources worldResources = worldResourcesRepository.findByWorldId(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World resources not found: " + command.getWorldId()));

        // Set quotas
        for (Map.Entry<ResourceType, Double> entry : command.getQuotas().entrySet()) {
            worldResources.setQuota(entry.getKey(), entry.getValue());
        }

        // Set thresholds if provided
        if (command.getThresholds() != null) {
            for (Map.Entry<ResourceType, ThresholdConfig> entry : command.getThresholds().entrySet()) {
                ThresholdConfig config = entry.getValue();
                worldResources.setThreshold(
                        entry.getKey(),
                        config.getWarningPercent(),
                        config.getCriticalPercent()
                );
            }
        }

        // Save and return
        return worldResourcesRepository.save(worldResources);
    }

    @Getter
    @Builder
    public static class SetResourceQuotaCommand {
        private final UUID worldId;
        private final Map<ResourceType, Double> quotas;
        private final Map<ResourceType, ThresholdConfig> thresholds;
    }

    @Getter
    @Builder
    public static class ThresholdConfig {
        private final Double warningPercent;
        private final Double criticalPercent;
    }
}
