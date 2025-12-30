package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldResources;
import com.ffl.playoffs.domain.model.resource.ResourcePriority;
import com.ffl.playoffs.domain.port.WorldResourcesRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for setting resource priority for a world.
 */
public class SetResourcePriorityUseCase {

    private final WorldResourcesRepository worldResourcesRepository;

    public SetResourcePriorityUseCase(WorldResourcesRepository worldResourcesRepository) {
        this.worldResourcesRepository = worldResourcesRepository;
    }

    /**
     * Sets the priority for a world's resources.
     *
     * @param command The set priority command
     * @return The updated WorldResources
     * @throws IllegalArgumentException if world resources not found
     */
    public WorldResources execute(SetResourcePriorityCommand command) {
        // Find world resources
        WorldResources worldResources = worldResourcesRepository.findByWorldId(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World resources not found: " + command.getWorldId()));

        // Set priority
        worldResources.setPriority(command.getPriority());

        // Save and return
        return worldResourcesRepository.save(worldResources);
    }

    @Getter
    @Builder
    public static class SetResourcePriorityCommand {
        private final UUID worldId;
        private final ResourcePriority priority;
    }
}
