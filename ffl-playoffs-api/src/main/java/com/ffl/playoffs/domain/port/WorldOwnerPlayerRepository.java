package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.worldowner.OwnershipRole;
import com.ffl.playoffs.domain.model.worldowner.OwnershipStatus;
import com.ffl.playoffs.domain.model.worldowner.WorldOwnerPermission;
import com.ffl.playoffs.domain.model.worldowner.WorldOwnerPlayer;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository port for WorldOwnerPlayer.
 */
public interface WorldOwnerPlayerRepository {

    /**
     * Save a world owner player.
     */
    WorldOwnerPlayer save(WorldOwnerPlayer ownerPlayer);

    /**
     * Find by ID.
     */
    Optional<WorldOwnerPlayer> findById(UUID id);

    /**
     * Find by user ID and world ID.
     */
    Optional<WorldOwnerPlayer> findByUserIdAndWorldId(UUID userId, UUID worldId);

    /**
     * Find all owners for a world.
     */
    List<WorldOwnerPlayer> findByWorldId(UUID worldId);

    /**
     * Find active owners for a world.
     */
    List<WorldOwnerPlayer> findActiveByWorldId(UUID worldId);

    /**
     * Find owners by world ID and role.
     */
    List<WorldOwnerPlayer> findByWorldIdAndRole(UUID worldId, OwnershipRole role);

    /**
     * Find owners by world ID and status.
     */
    List<WorldOwnerPlayer> findByWorldIdAndStatus(UUID worldId, OwnershipStatus status);

    /**
     * Find all worlds where a user is an owner.
     */
    List<WorldOwnerPlayer> findByUserId(UUID userId);

    /**
     * Find all worlds where a user is an active owner.
     */
    List<WorldOwnerPlayer> findActiveByUserId(UUID userId);

    /**
     * Find by invitation token.
     */
    Optional<WorldOwnerPlayer> findByInvitationToken(String token);

    /**
     * Check if a user is an owner of a world (any status).
     */
    boolean existsByUserIdAndWorldId(UUID userId, UUID worldId);

    /**
     * Check if a user is an active owner of a world.
     */
    boolean isActiveOwner(UUID userId, UUID worldId);

    /**
     * Check if a user has a specific permission in a world.
     */
    boolean hasPermission(UUID userId, UUID worldId, WorldOwnerPermission permission);

    /**
     * Count active owners for a world.
     */
    long countActiveByWorldId(UUID worldId);

    /**
     * Count primary owners for a world.
     */
    long countPrimaryOwnersByWorldId(UUID worldId);

    /**
     * Delete by ID.
     */
    void deleteById(UUID id);

    /**
     * Delete all owners for a world.
     */
    void deleteByWorldId(UUID worldId);
}
