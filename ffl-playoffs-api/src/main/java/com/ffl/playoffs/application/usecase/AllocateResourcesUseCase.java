package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.ResourcePool;
import com.ffl.playoffs.domain.aggregate.WorldResources;
import com.ffl.playoffs.domain.model.resource.ResourceType;
import com.ffl.playoffs.domain.port.ResourcePoolRepository;
import com.ffl.playoffs.domain.port.WorldResourcesRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.Map;
import java.util.UUID;

/**
 * Use case for allocating resources to a world from the owner's resource pool.
 */
public class AllocateResourcesUseCase {

    private final WorldResourcesRepository worldResourcesRepository;
    private final ResourcePoolRepository resourcePoolRepository;

    public AllocateResourcesUseCase(WorldResourcesRepository worldResourcesRepository,
                                    ResourcePoolRepository resourcePoolRepository) {
        this.worldResourcesRepository = worldResourcesRepository;
        this.resourcePoolRepository = resourcePoolRepository;
    }

    /**
     * Allocates resources to a world.
     *
     * @param command The allocate resources command
     * @return The updated WorldResources
     * @throws IllegalArgumentException if world resources not found
     * @throws IllegalArgumentException if resource pool not found
     * @throws IllegalStateException if insufficient resources in pool
     */
    public WorldResources execute(AllocateResourcesCommand command) {
        // Find world resources
        WorldResources worldResources = worldResourcesRepository.findByWorldId(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World resources not found: " + command.getWorldId()));

        // Find resource pool
        ResourcePool resourcePool = resourcePoolRepository.findByOwnerId(worldResources.getOwnerId())
                .orElseThrow(() -> new IllegalArgumentException("Resource pool not found for owner: " + worldResources.getOwnerId()));

        // Allocate each resource type
        for (Map.Entry<ResourceType, Double> entry : command.getAllocations().entrySet()) {
            ResourceType type = entry.getKey();
            Double amount = entry.getValue();

            // Check if pool can allocate
            if (!resourcePool.canAllocate(type, amount)) {
                throw new IllegalStateException("Insufficient " + type.getDisplayName() +
                        " in pool. Available: " + resourcePool.getAvailable(type) + ", Requested: " + amount);
            }

            // Allocate from pool
            resourcePool.allocateToWorld(type, amount);

            // Set allocation on world resources
            worldResources.setAllocation(type, amount);
        }

        // Save both
        resourcePoolRepository.save(resourcePool);
        return worldResourcesRepository.save(worldResources);
    }

    @Getter
    @Builder
    public static class AllocateResourcesCommand {
        private final UUID worldId;
        private final Map<ResourceType, Double> allocations;
    }
}
