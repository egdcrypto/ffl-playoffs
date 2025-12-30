package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.worldowner.WorldOwnerPlayer;
import com.ffl.playoffs.domain.port.WorldOwnerPlayerRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for accepting or declining a world owner invitation.
 */
public class AcceptWorldOwnerInvitationUseCase {

    private final WorldOwnerPlayerRepository repository;

    public AcceptWorldOwnerInvitationUseCase(WorldOwnerPlayerRepository repository) {
        this.repository = repository;
    }

    /**
     * Accepts an invitation using the invitation token.
     *
     * @param command The accept command
     * @return The updated WorldOwnerPlayer
     * @throws IllegalArgumentException if token is invalid
     * @throws IllegalStateException if invitation is expired or already accepted
     */
    public WorldOwnerPlayer accept(AcceptInvitationCommand command) {
        // Find by token
        WorldOwnerPlayer ownerPlayer = repository.findByInvitationToken(command.getInvitationToken())
                .orElseThrow(() -> new IllegalArgumentException("Invalid invitation token"));

        // Accept invitation
        ownerPlayer.acceptInvitation(command.getInvitationToken());

        // Save and return
        return repository.save(ownerPlayer);
    }

    /**
     * Declines an invitation.
     *
     * @param command The decline command
     * @return The updated WorldOwnerPlayer
     * @throws IllegalArgumentException if owner not found
     * @throws IllegalStateException if not in invited status
     */
    public WorldOwnerPlayer decline(DeclineInvitationCommand command) {
        // Find the owner
        WorldOwnerPlayer ownerPlayer = repository.findByUserIdAndWorldId(command.getUserId(), command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("User is not invited to this world"));

        // Decline invitation
        ownerPlayer.declineInvitation();

        // Save and return
        return repository.save(ownerPlayer);
    }

    @Getter
    @Builder
    public static class AcceptInvitationCommand {
        private final String invitationToken;
    }

    @Getter
    @Builder
    public static class DeclineInvitationCommand {
        private final UUID userId;
        private final UUID worldId;
    }
}
