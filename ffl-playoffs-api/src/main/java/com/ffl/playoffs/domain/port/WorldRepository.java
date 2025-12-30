package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.world.World;
import com.ffl.playoffs.domain.model.world.WorldStatus;
import com.ffl.playoffs.domain.model.world.WorldVisibility;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository port for World persistence.
 * Defines the contract for World data access following hexagonal architecture.
 */
public interface WorldRepository {

    /**
     * Save a world.
     */
    World save(World world);

    /**
     * Find a world by ID.
     */
    Optional<World> findById(UUID id);

    /**
     * Find a world by its unique code.
     */
    Optional<World> findByCode(String code);

    /**
     * Find all worlds by primary owner.
     */
    List<World> findByPrimaryOwnerId(UUID primaryOwnerId);

    /**
     * Find all worlds by status.
     */
    List<World> findByStatus(WorldStatus status);

    /**
     * Find all active worlds.
     */
    List<World> findActiveWorlds();

    /**
     * Find all public or invite-only worlds (visible to non-members).
     */
    List<World> findPubliclyVisibleWorlds();

    /**
     * Find worlds by visibility.
     */
    List<World> findByVisibility(WorldVisibility visibility);

    /**
     * Check if a world code exists.
     */
    boolean existsByCode(String code);

    /**
     * Check if a world exists by ID.
     */
    boolean existsById(UUID id);

    /**
     * Delete a world by ID.
     */
    void deleteById(UUID id);

    /**
     * Count worlds by primary owner.
     */
    long countByPrimaryOwnerId(UUID primaryOwnerId);

    /**
     * Count active worlds.
     */
    long countActiveWorlds();

    /**
     * Search worlds by name (case-insensitive partial match).
     */
    List<World> searchByName(String namePart);

    /**
     * Find worlds that have available capacity for new members.
     */
    List<World> findWorldsWithMemberCapacity();
}
