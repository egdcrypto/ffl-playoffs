package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.invitation.AdminInvitation;
import com.ffl.playoffs.domain.port.AdminInvitationRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for resending an admin invitation.
 * Only SUPER_ADMIN can resend invitations.
 */
public class ResendAdminInvitationUseCase {

    private final AdminInvitationRepository invitationRepository;
    private final UserRepository userRepository;

    public ResendAdminInvitationUseCase(AdminInvitationRepository invitationRepository,
                                         UserRepository userRepository) {
        this.invitationRepository = invitationRepository;
        this.userRepository = userRepository;
    }

    /**
     * Resends an admin invitation with a new token.
     *
     * @param command The resend command
     * @return The updated AdminInvitation with new token
     * @throws IllegalArgumentException if invitation not found or resender not found
     * @throws IllegalStateException if resender is not SUPER_ADMIN or invitation cannot be resent
     */
    public AdminInvitation execute(ResendInvitationCommand command) {
        // Verify resender is SUPER_ADMIN
        User resender = userRepository.findById(command.getResentBy())
                .orElseThrow(() -> new IllegalArgumentException("Resender not found"));

        if (!resender.isSuperAdmin()) {
            throw new IllegalStateException("Only SUPER_ADMIN can resend admin invitations");
        }

        // Find the invitation
        AdminInvitation invitation = invitationRepository.findById(command.getInvitationId())
                .orElseThrow(() -> new IllegalArgumentException("Invitation not found"));

        // Resend the invitation (generates new token and extends expiry)
        invitation.resend();

        // Save and return (in production, would also trigger email sending)
        return invitationRepository.save(invitation);
    }

    @Getter
    @Builder
    public static class ResendInvitationCommand {
        private final UUID invitationId;
        private final UUID resentBy;
    }
}
