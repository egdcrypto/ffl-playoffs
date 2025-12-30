package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldResources;
import com.ffl.playoffs.domain.model.resource.ResourceSharingConfig;
import com.ffl.playoffs.domain.port.WorldResourcesRepository;
import lombok.Builder;
import lombok.Getter;

import java.time.Duration;
import java.util.UUID;

/**
 * Use case for configuring resource sharing for a world.
 */
public class ConfigureResourceSharingUseCase {

    private final WorldResourcesRepository worldResourcesRepository;

    public ConfigureResourceSharingUseCase(WorldResourcesRepository worldResourcesRepository) {
        this.worldResourcesRepository = worldResourcesRepository;
    }

    /**
     * Configures resource sharing for a world.
     *
     * @param command The configure sharing command
     * @return The updated WorldResources
     * @throws IllegalArgumentException if world resources not found
     */
    public WorldResources execute(ConfigureResourceSharingCommand command) {
        // Find world resources
        WorldResources worldResources = worldResourcesRepository.findByWorldId(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World resources not found: " + command.getWorldId()));

        // Configure sharing
        if (command.isEnabled()) {
            ResourceSharingConfig config = ResourceSharingConfig.create(
                    command.getMode() != null ? command.getMode() : ResourceSharingConfig.SharingMode.DYNAMIC,
                    command.getMaxSharePercent() != null ? command.getMaxSharePercent() : 50.0,
                    command.getPriority() != null ? command.getPriority() : ResourceSharingConfig.SharingPriority.EQUAL,
                    command.getReclaimDelay() != null ? command.getReclaimDelay() : Duration.ofSeconds(60)
            );
            worldResources.configureSharingConfig(config);
        } else {
            worldResources.disableSharing();
        }

        // Save and return
        return worldResourcesRepository.save(worldResources);
    }

    @Getter
    @Builder
    public static class ConfigureResourceSharingCommand {
        private final UUID worldId;
        private final boolean enabled;
        private final ResourceSharingConfig.SharingMode mode;
        private final Double maxSharePercent;
        private final ResourceSharingConfig.SharingPriority priority;
        private final Duration reclaimDelay;
    }
}
