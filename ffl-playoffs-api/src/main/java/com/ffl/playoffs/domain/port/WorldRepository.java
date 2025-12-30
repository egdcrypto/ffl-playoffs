package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.World;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for World aggregate.
 * Port in hexagonal architecture - defines the contract for world persistence.
 */
public interface WorldRepository {

    /**
     * Find world by ID
     * @param id the world ID
     * @return Optional containing the world if found
     */
    Optional<World> findById(UUID id);

    /**
     * Find all worlds
     * @return list of all worlds
     */
    List<World> findAll();

    /**
     * Find all worlds owned by a user
     * @param ownerId the owner's user ID
     * @return list of worlds owned by the user
     */
    List<World> findByOwnerId(UUID ownerId);

    /**
     * Find worlds by status
     * @param status the world status
     * @return list of worlds with the given status
     */
    List<World> findByStatus(World.WorldStatus status);

    /**
     * Find all public worlds
     * @return list of public worlds
     */
    List<World> findPublicWorlds();

    /**
     * Find all deployed worlds
     * @return list of deployed worlds
     */
    List<World> findDeployedWorlds();

    /**
     * Check if a world exists by ID
     * @param id the world ID
     * @return true if world exists
     */
    boolean existsById(UUID id);

    /**
     * Save a world
     * @param world the world to save
     * @return the saved world
     */
    World save(World world);

    /**
     * Delete a world by ID
     * @param id the world ID
     */
    void deleteById(UUID id);

    /**
     * Count worlds by owner
     * @param ownerId the owner's user ID
     * @return the count of worlds
     */
    long countByOwnerId(UUID ownerId);
}
