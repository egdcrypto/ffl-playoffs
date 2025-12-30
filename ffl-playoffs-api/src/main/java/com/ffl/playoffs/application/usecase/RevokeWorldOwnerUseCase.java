package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.worldowner.OwnershipRole;
import com.ffl.playoffs.domain.model.worldowner.WorldOwnerPermission;
import com.ffl.playoffs.domain.model.worldowner.WorldOwnerPlayer;
import com.ffl.playoffs.domain.port.WorldOwnerPlayerRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for revoking an owner from a world.
 */
public class RevokeWorldOwnerUseCase {

    private final WorldOwnerPlayerRepository repository;

    public RevokeWorldOwnerUseCase(WorldOwnerPlayerRepository repository) {
        this.repository = repository;
    }

    /**
     * Revokes an owner from a world.
     *
     * @param command The revoke command
     * @return The updated WorldOwnerPlayer
     * @throws IllegalArgumentException if owner not found
     * @throws IllegalStateException if revoker lacks permission or trying to revoke primary owner
     */
    public WorldOwnerPlayer execute(RevokeOwnerCommand command) {
        // Get the owner to be revoked
        WorldOwnerPlayer ownerToRevoke = repository.findByUserIdAndWorldId(command.getUserId(), command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("User is not an owner of this world"));

        // Cannot revoke primary owner
        if (ownerToRevoke.getRole() == OwnershipRole.PRIMARY_OWNER) {
            throw new IllegalStateException("Cannot revoke PRIMARY_OWNER; transfer ownership first");
        }

        // Check if self-revocation
        if (!command.getUserId().equals(command.getRevokedBy())) {
            // Verify revoker has permission
            WorldOwnerPlayer revoker = repository.findByUserIdAndWorldId(command.getRevokedBy(), command.getWorldId())
                    .orElseThrow(() -> new IllegalStateException("Revoker is not an owner of this world"));

            if (!revoker.hasPermission(WorldOwnerPermission.REMOVE_OWNERS)) {
                throw new IllegalStateException("Revoker does not have permission to remove owners");
            }

            // Cannot revoke someone with same or higher role
            if (ownerToRevoke.getRole().getLevel() >= revoker.getRole().getLevel()) {
                throw new IllegalStateException("Cannot revoke owner with same or higher role");
            }
        }

        // Revoke
        ownerToRevoke.remove();

        // Save and return
        return repository.save(ownerToRevoke);
    }

    @Getter
    @Builder
    public static class RevokeOwnerCommand {
        private final UUID userId;
        private final UUID worldId;
        private final UUID revokedBy;
    }
}
