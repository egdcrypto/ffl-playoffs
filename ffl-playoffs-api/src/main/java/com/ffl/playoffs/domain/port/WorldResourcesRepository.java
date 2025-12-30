package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.WorldResources;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for WorldResources aggregate.
 * Port in hexagonal architecture.
 */
public interface WorldResourcesRepository {

    /**
     * Find world resources by ID.
     * @param id the world resources ID
     * @return Optional containing the world resources if found
     */
    Optional<WorldResources> findById(UUID id);

    /**
     * Find world resources by world ID.
     * @param worldId the world ID
     * @return Optional containing the world resources if found
     */
    Optional<WorldResources> findByWorldId(UUID worldId);

    /**
     * Find all world resources for an owner.
     * @param ownerId the owner ID
     * @return list of world resources
     */
    List<WorldResources> findByOwnerId(UUID ownerId);

    /**
     * Find all world resources.
     * @return list of all world resources
     */
    List<WorldResources> findAll();

    /**
     * Check if world resources exist for a world.
     * @param worldId the world ID
     * @return true if exists
     */
    boolean existsByWorldId(UUID worldId);

    /**
     * Save world resources.
     * @param worldResources the world resources to save
     * @return the saved world resources
     */
    WorldResources save(WorldResources worldResources);

    /**
     * Delete world resources by ID.
     * @param id the world resources ID
     */
    void deleteById(UUID id);

    /**
     * Delete world resources by world ID.
     * @param worldId the world ID
     */
    void deleteByWorldId(UUID worldId);
}
