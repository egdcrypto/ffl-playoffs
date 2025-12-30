package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.worldowner.OwnershipRole;
import com.ffl.playoffs.domain.model.worldowner.WorldOwnerPermission;
import com.ffl.playoffs.domain.model.worldowner.WorldOwnerPlayer;
import com.ffl.playoffs.domain.port.WorldOwnerPlayerRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for inviting a new owner to a world.
 */
public class InviteWorldOwnerUseCase {

    private final WorldOwnerPlayerRepository repository;

    public InviteWorldOwnerUseCase(WorldOwnerPlayerRepository repository) {
        this.repository = repository;
    }

    /**
     * Invites a new owner to a world.
     *
     * @param command The invite command
     * @return The created WorldOwnerPlayer with pending status
     * @throws IllegalArgumentException if user is already an owner
     * @throws IllegalStateException if inviter lacks permission
     */
    public WorldOwnerPlayer execute(InviteOwnerCommand command) {
        // Verify inviter has permission
        WorldOwnerPlayer inviter = repository.findByUserIdAndWorldId(command.getInvitedBy(), command.getWorldId())
                .orElseThrow(() -> new IllegalStateException("Inviter is not an owner of this world"));

        if (!inviter.hasPermission(WorldOwnerPermission.INVITE_OWNERS)) {
            throw new IllegalStateException("Inviter does not have permission to invite owners");
        }

        // Check if inviter can grant the requested role
        if (!inviter.getRole().canGrantRole(command.getRole())) {
            throw new IllegalStateException("Cannot invite with role equal to or higher than own role");
        }

        // Check if user is already an owner
        if (repository.existsByUserIdAndWorldId(command.getUserId(), command.getWorldId())) {
            throw new IllegalArgumentException("User is already an owner of this world");
        }

        // Create invitation
        WorldOwnerPlayer ownerPlayer = WorldOwnerPlayer.createInvitation(
                command.getUserId(),
                command.getWorldId(),
                command.getRole(),
                command.getInvitedBy()
        );

        // Save and return
        return repository.save(ownerPlayer);
    }

    @Getter
    @Builder
    public static class InviteOwnerCommand {
        private final UUID userId;
        private final UUID worldId;
        private final OwnershipRole role;
        private final UUID invitedBy;
    }
}
