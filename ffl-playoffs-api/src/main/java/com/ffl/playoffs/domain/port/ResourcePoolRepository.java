package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.ResourcePool;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for ResourcePool aggregate.
 * Port in hexagonal architecture.
 */
public interface ResourcePoolRepository {

    /**
     * Find resource pool by ID.
     * @param id the resource pool ID
     * @return Optional containing the resource pool if found
     */
    Optional<ResourcePool> findById(UUID id);

    /**
     * Find resource pool by owner ID.
     * @param ownerId the owner ID
     * @return Optional containing the resource pool if found
     */
    Optional<ResourcePool> findByOwnerId(UUID ownerId);

    /**
     * Find all resource pools.
     * @return list of all resource pools
     */
    List<ResourcePool> findAll();

    /**
     * Find resource pools by subscription tier.
     * @param subscriptionTier the subscription tier
     * @return list of resource pools
     */
    List<ResourcePool> findBySubscriptionTier(String subscriptionTier);

    /**
     * Check if resource pool exists for owner.
     * @param ownerId the owner ID
     * @return true if exists
     */
    boolean existsByOwnerId(UUID ownerId);

    /**
     * Save resource pool.
     * @param resourcePool the resource pool to save
     * @return the saved resource pool
     */
    ResourcePool save(ResourcePool resourcePool);

    /**
     * Delete resource pool by ID.
     * @param id the resource pool ID
     */
    void deleteById(UUID id);
}
