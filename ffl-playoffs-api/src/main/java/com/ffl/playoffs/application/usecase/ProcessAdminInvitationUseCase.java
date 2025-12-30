package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.model.invitation.AdminInvitation;
import com.ffl.playoffs.domain.port.AdminInvitationRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import lombok.Builder;
import lombok.Getter;

/**
 * Use case for processing (accepting/declining) an admin invitation.
 */
public class ProcessAdminInvitationUseCase {

    private final AdminInvitationRepository invitationRepository;
    private final UserRepository userRepository;

    public ProcessAdminInvitationUseCase(AdminInvitationRepository invitationRepository,
                                          UserRepository userRepository) {
        this.invitationRepository = invitationRepository;
        this.userRepository = userRepository;
    }

    /**
     * Accepts an admin invitation and creates the admin user.
     *
     * @param command The accept command
     * @return The result containing the invitation and created user
     * @throws IllegalArgumentException if invitation not found or token invalid
     * @throws IllegalStateException if invitation cannot be accepted
     */
    public AcceptResult accept(AcceptInvitationCommand command) {
        // Find invitation by token
        AdminInvitation invitation = invitationRepository.findByToken(command.getToken())
                .orElseThrow(() -> new IllegalArgumentException("Invalid invitation token"));

        // Check if user already exists (e.g., from a previous partial registration)
        if (userRepository.findByEmail(invitation.getEmail()).isPresent()) {
            throw new IllegalStateException("User with email already exists");
        }

        // Create the admin user
        User admin = new User(
                invitation.getEmail(),
                invitation.getName(),
                command.getGoogleId(),
                Role.ADMIN
        );
        admin = userRepository.save(admin);

        // Accept the invitation
        invitation.accept(command.getToken(), admin.getId());
        invitation = invitationRepository.save(invitation);

        return new AcceptResult(invitation, admin);
    }

    /**
     * Declines an admin invitation.
     *
     * @param command The decline command
     * @return The updated invitation
     * @throws IllegalArgumentException if invitation not found
     * @throws IllegalStateException if invitation cannot be declined
     */
    public AdminInvitation decline(DeclineInvitationCommand command) {
        // Find invitation by token
        AdminInvitation invitation = invitationRepository.findByToken(command.getToken())
                .orElseThrow(() -> new IllegalArgumentException("Invalid invitation token"));

        // Decline the invitation
        invitation.decline();

        return invitationRepository.save(invitation);
    }

    @Getter
    @Builder
    public static class AcceptInvitationCommand {
        private final String token;
        private final String googleId;
    }

    @Getter
    @Builder
    public static class DeclineInvitationCommand {
        private final String token;
    }

    @Getter
    public static class AcceptResult {
        private final AdminInvitation invitation;
        private final User admin;

        public AcceptResult(AdminInvitation invitation, User admin) {
            this.invitation = invitation;
            this.admin = admin;
        }
    }
}
