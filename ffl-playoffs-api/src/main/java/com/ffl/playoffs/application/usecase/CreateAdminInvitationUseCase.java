package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.invitation.AdminInvitation;
import com.ffl.playoffs.domain.port.AdminInvitationRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.UUID;

/**
 * Use case for creating an admin invitation.
 * Only SUPER_ADMIN can create admin invitations.
 */
public class CreateAdminInvitationUseCase {

    private final AdminInvitationRepository invitationRepository;
    private final UserRepository userRepository;

    public CreateAdminInvitationUseCase(AdminInvitationRepository invitationRepository,
                                         UserRepository userRepository) {
        this.invitationRepository = invitationRepository;
        this.userRepository = userRepository;
    }

    /**
     * Creates a new admin invitation.
     *
     * @param command The create invitation command
     * @return The created AdminInvitation
     * @throws IllegalArgumentException if inviter not found
     * @throws IllegalStateException if inviter is not SUPER_ADMIN or invitation already exists
     */
    public AdminInvitation execute(CreateInvitationCommand command) {
        // Verify inviter exists and is SUPER_ADMIN
        User inviter = userRepository.findById(command.getInvitedBy())
                .orElseThrow(() -> new IllegalArgumentException("Inviter not found"));

        if (!inviter.isSuperAdmin()) {
            throw new IllegalStateException("Only SUPER_ADMIN can invite admins");
        }

        // Check if user already exists with this email
        if (userRepository.findByEmail(command.getEmail()).isPresent()) {
            throw new IllegalStateException("User with email already exists: " + command.getEmail());
        }

        // Check if there's already a pending invitation for this email
        if (invitationRepository.existsPendingByEmail(command.getEmail())) {
            throw new IllegalStateException("Pending invitation already exists for: " + command.getEmail());
        }

        // Create the invitation
        AdminInvitation invitation = AdminInvitation.create(
                command.getEmail(),
                command.getName(),
                command.getInvitedBy()
        );

        // Save and return
        return invitationRepository.save(invitation);
    }

    @Getter
    @Builder
    public static class CreateInvitationCommand {
        private final String email;
        private final String name;
        private final UUID invitedBy;
    }
}
