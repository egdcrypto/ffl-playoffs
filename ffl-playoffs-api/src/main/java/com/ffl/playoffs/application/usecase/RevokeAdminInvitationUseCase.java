package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.invitation.AdminInvitation;
import com.ffl.playoffs.domain.port.AdminInvitationRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for revoking an admin invitation.
 * Only SUPER_ADMIN can revoke invitations.
 */
public class RevokeAdminInvitationUseCase {

    private final AdminInvitationRepository invitationRepository;
    private final UserRepository userRepository;

    public RevokeAdminInvitationUseCase(AdminInvitationRepository invitationRepository,
                                         UserRepository userRepository) {
        this.invitationRepository = invitationRepository;
        this.userRepository = userRepository;
    }

    /**
     * Revokes a pending admin invitation.
     *
     * @param command The revoke command
     * @return The revoked AdminInvitation
     * @throws IllegalArgumentException if invitation not found or revoker not found
     * @throws IllegalStateException if revoker is not SUPER_ADMIN or invitation cannot be revoked
     */
    public AdminInvitation execute(RevokeInvitationCommand command) {
        // Verify revoker is SUPER_ADMIN
        User revoker = userRepository.findById(command.getRevokedBy())
                .orElseThrow(() -> new IllegalArgumentException("Revoker not found"));

        if (!revoker.isSuperAdmin()) {
            throw new IllegalStateException("Only SUPER_ADMIN can revoke admin invitations");
        }

        // Find the invitation
        AdminInvitation invitation = invitationRepository.findById(command.getInvitationId())
                .orElseThrow(() -> new IllegalArgumentException("Invitation not found"));

        // Revoke the invitation
        invitation.revoke(command.getReason());

        return invitationRepository.save(invitation);
    }

    @Getter
    @Builder
    public static class RevokeInvitationCommand {
        private final UUID invitationId;
        private final UUID revokedBy;
        private final String reason;
    }
}
