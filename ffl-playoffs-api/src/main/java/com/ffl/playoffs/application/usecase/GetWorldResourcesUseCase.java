package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldResources;
import com.ffl.playoffs.domain.port.WorldResourcesRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for retrieving world resources information.
 */
public class GetWorldResourcesUseCase {

    private final WorldResourcesRepository worldResourcesRepository;

    public GetWorldResourcesUseCase(WorldResourcesRepository worldResourcesRepository) {
        this.worldResourcesRepository = worldResourcesRepository;
    }

    /**
     * Gets resources for a specific world.
     *
     * @param worldId The world ID
     * @return Optional containing the WorldResources if found
     */
    public Optional<WorldResources> getByWorldId(UUID worldId) {
        return worldResourcesRepository.findByWorldId(worldId);
    }

    /**
     * Gets all resources for an owner.
     *
     * @param ownerId The owner ID
     * @return List of WorldResources for the owner
     */
    public List<WorldResources> getByOwnerId(UUID ownerId) {
        return worldResourcesRepository.findByOwnerId(ownerId);
    }

    /**
     * Gets resource summary with threshold status.
     *
     * @param worldId The world ID
     * @return ResourceSummary if world resources found
     * @throws IllegalArgumentException if world resources not found
     */
    public ResourceSummary getResourceSummary(UUID worldId) {
        WorldResources resources = worldResourcesRepository.findByWorldId(worldId)
                .orElseThrow(() -> new IllegalArgumentException("World resources not found: " + worldId));

        return ResourceSummary.builder()
                .worldId(resources.getWorldId())
                .worldName(resources.getWorldName())
                .priority(resources.getPriority())
                .resourcesAtWarning(resources.getResourcesAtWarningLevel())
                .resourcesAtCritical(resources.getResourcesAtCriticalLevel())
                .autoScalingEnabled(resources.isAutoScalingEnabled())
                .sharingEnabled(resources.isSharingEnabled())
                .build();
    }

    @Getter
    @Builder
    public static class ResourceSummary {
        private final UUID worldId;
        private final String worldName;
        private final com.ffl.playoffs.domain.model.resource.ResourcePriority priority;
        private final List<com.ffl.playoffs.domain.model.resource.ResourceType> resourcesAtWarning;
        private final List<com.ffl.playoffs.domain.model.resource.ResourceType> resourcesAtCritical;
        private final boolean autoScalingEnabled;
        private final boolean sharingEnabled;
    }
}
