package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldResources;
import com.ffl.playoffs.domain.model.resource.ResourcePriority;
import com.ffl.playoffs.domain.port.WorldResourcesRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for creating resource allocation for a world.
 */
public class CreateWorldResourcesUseCase {

    private final WorldResourcesRepository worldResourcesRepository;

    public CreateWorldResourcesUseCase(WorldResourcesRepository worldResourcesRepository) {
        this.worldResourcesRepository = worldResourcesRepository;
    }

    /**
     * Creates world resources for a new world.
     *
     * @param command The create world resources command
     * @return The created WorldResources
     * @throws IllegalArgumentException if resources already exist for the world
     */
    public WorldResources execute(CreateWorldResourcesCommand command) {
        // Validate world doesn't already have resources
        if (worldResourcesRepository.existsByWorldId(command.getWorldId())) {
            throw new IllegalArgumentException("Resources already exist for world: " + command.getWorldId());
        }

        // Create world resources
        WorldResources resources = WorldResources.create(
                command.getWorldId(),
                command.getOwnerId(),
                command.getWorldName()
        );

        // Set initial priority if provided
        if (command.getPriority() != null) {
            resources.setPriority(command.getPriority());
        }

        // Persist and return
        return worldResourcesRepository.save(resources);
    }

    @Getter
    @Builder
    public static class CreateWorldResourcesCommand {
        private final UUID worldId;
        private final UUID ownerId;
        private final String worldName;
        private final ResourcePriority priority;
    }
}
