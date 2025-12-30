package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldResources;
import com.ffl.playoffs.domain.model.resource.AutoScalingRule;
import com.ffl.playoffs.domain.model.resource.ScalingAction;
import com.ffl.playoffs.domain.port.WorldResourcesRepository;
import lombok.Builder;
import lombok.Getter;

import java.time.Duration;
import java.util.List;
import java.util.UUID;

/**
 * Use case for configuring auto-scaling for a world's resources.
 */
public class ConfigureAutoScalingUseCase {

    private final WorldResourcesRepository worldResourcesRepository;

    public ConfigureAutoScalingUseCase(WorldResourcesRepository worldResourcesRepository) {
        this.worldResourcesRepository = worldResourcesRepository;
    }

    /**
     * Configures auto-scaling for a world.
     *
     * @param command The configure auto-scaling command
     * @return The updated WorldResources
     * @throws IllegalArgumentException if world resources not found
     */
    public WorldResources execute(ConfigureAutoScalingCommand command) {
        // Find world resources
        WorldResources worldResources = worldResourcesRepository.findByWorldId(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World resources not found: " + command.getWorldId()));

        // Configure auto-scaling
        if (command.isEnabled()) {
            WorldResources.AutoScalingConfig config = WorldResources.AutoScalingConfig.builder()
                    .enabled(true)
                    .minInstances(command.getMinInstances() != null ? command.getMinInstances() : 1)
                    .maxInstances(command.getMaxInstances() != null ? command.getMaxInstances() : 10)
                    .maxCostPerHour(command.getMaxCostPerHour())
                    .paused(false)
                    .build();
            worldResources.configureAutoScaling(config);

            // Add scaling rules if provided
            if (command.getRules() != null) {
                for (AutoScalingRuleConfig ruleConfig : command.getRules()) {
                    AutoScalingRule rule = AutoScalingRule.create(
                            ruleConfig.getMetricName(),
                            ruleConfig.getThreshold(),
                            ruleConfig.getAction(),
                            ruleConfig.getCooldown() != null ? ruleConfig.getCooldown() : Duration.ofMinutes(5)
                    );
                    worldResources.addAutoScalingRule(rule);
                }
            }
        } else {
            worldResources.disableAutoScaling();
        }

        // Save and return
        return worldResourcesRepository.save(worldResources);
    }

    @Getter
    @Builder
    public static class ConfigureAutoScalingCommand {
        private final UUID worldId;
        private final boolean enabled;
        private final Integer minInstances;
        private final Integer maxInstances;
        private final Double maxCostPerHour;
        private final List<AutoScalingRuleConfig> rules;
    }

    @Getter
    @Builder
    public static class AutoScalingRuleConfig {
        private final String metricName;
        private final Double threshold;
        private final ScalingAction action;
        private final Duration cooldown;
    }
}
