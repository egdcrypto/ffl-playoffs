package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldAccessControl;
import com.ffl.playoffs.domain.port.WorldAccessControlRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for accepting or declining a world invitation.
 */
public class AcceptWorldInvitationUseCase {

    private final WorldAccessControlRepository repository;

    public AcceptWorldInvitationUseCase(WorldAccessControlRepository repository) {
        this.repository = repository;
    }

    /**
     * Accepts a world invitation.
     *
     * @param command The accept invitation command
     * @return The updated WorldAccessControl
     * @throws IllegalArgumentException if world not found or invalid token
     */
    public WorldAccessControl accept(AcceptInvitationCommand command) {
        // Find the access control
        WorldAccessControl accessControl = repository.findByWorldId(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World access control not found: " + command.getWorldId()));

        // Accept invitation
        accessControl.acceptInvitation(command.getUserId(), command.getInvitationToken());

        // Save and return
        return repository.save(accessControl);
    }

    /**
     * Declines a world invitation.
     *
     * @param command The decline invitation command
     * @return The updated WorldAccessControl
     * @throws IllegalArgumentException if world not found or user not invited
     */
    public WorldAccessControl decline(DeclineInvitationCommand command) {
        // Find the access control
        WorldAccessControl accessControl = repository.findByWorldId(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World access control not found: " + command.getWorldId()));

        // Decline invitation
        accessControl.declineInvitation(command.getUserId());

        // Save and return
        return repository.save(accessControl);
    }

    @Getter
    @Builder
    public static class AcceptInvitationCommand {
        private final UUID worldId;
        private final UUID userId;
        private final String invitationToken;
    }

    @Getter
    @Builder
    public static class DeclineInvitationCommand {
        private final UUID worldId;
        private final UUID userId;
    }
}
