package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.worldowner.OwnershipRole;
import com.ffl.playoffs.domain.model.worldowner.OwnershipStatus;
import com.ffl.playoffs.domain.model.worldowner.WorldOwnerPlayer;
import com.ffl.playoffs.domain.port.WorldOwnerPlayerRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for retrieving world owner information.
 */
public class GetWorldOwnersUseCase {

    private final WorldOwnerPlayerRepository repository;

    public GetWorldOwnersUseCase(WorldOwnerPlayerRepository repository) {
        this.repository = repository;
    }

    /**
     * Get all owners for a world.
     */
    public List<WorldOwnerPlayer> getAllOwners(UUID worldId) {
        return repository.findByWorldId(worldId);
    }

    /**
     * Get active owners for a world.
     */
    public List<WorldOwnerPlayer> getActiveOwners(UUID worldId) {
        return repository.findActiveByWorldId(worldId);
    }

    /**
     * Get owners by role.
     */
    public List<WorldOwnerPlayer> getOwnersByRole(UUID worldId, OwnershipRole role) {
        return repository.findByWorldIdAndRole(worldId, role);
    }

    /**
     * Get owners by status.
     */
    public List<WorldOwnerPlayer> getOwnersByStatus(UUID worldId, OwnershipStatus status) {
        return repository.findByWorldIdAndStatus(worldId, status);
    }

    /**
     * Get a specific owner.
     */
    public Optional<WorldOwnerPlayer> getOwner(UUID userId, UUID worldId) {
        return repository.findByUserIdAndWorldId(userId, worldId);
    }

    /**
     * Get the primary owner of a world.
     */
    public Optional<WorldOwnerPlayer> getPrimaryOwner(UUID worldId) {
        return repository.findByWorldIdAndRole(worldId, OwnershipRole.PRIMARY_OWNER)
                .stream()
                .findFirst();
    }

    /**
     * Get all worlds a user owns.
     */
    public List<WorldOwnerPlayer> getWorldsOwnedByUser(UUID userId) {
        return repository.findByUserId(userId);
    }

    /**
     * Get all worlds a user actively owns.
     */
    public List<WorldOwnerPlayer> getActiveWorldsOwnedByUser(UUID userId) {
        return repository.findActiveByUserId(userId);
    }

    /**
     * Check if a user is an active owner of a world.
     */
    public boolean isActiveOwner(UUID userId, UUID worldId) {
        return repository.isActiveOwner(userId, worldId);
    }

    /**
     * Get pending invitations for a world.
     */
    public List<WorldOwnerPlayer> getPendingInvitations(UUID worldId) {
        return repository.findByWorldIdAndStatus(worldId, OwnershipStatus.INVITED);
    }

    /**
     * Get count of active owners.
     */
    public long getActiveOwnerCount(UUID worldId) {
        return repository.countActiveByWorldId(worldId);
    }
}
