package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.User;
import com.ffl.playoffs.domain.port.UserRepository;

/**
 * Use case for accepting an admin invitation
 * Links the invited admin email to their Google account
 */
public class AcceptAdminInvitationUseCase {

    private final UserRepository userRepository;

    public AcceptAdminInvitationUseCase(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * Accepts an admin invitation by linking email to Google ID
     *
     * @param command The accept invitation command
     * @return The updated admin User
     * @throws IllegalArgumentException if user not found
     * @throws IllegalStateException if user already has a Google ID
     */
    public User execute(AcceptAdminInvitationCommand command) {
        // Find user by email (created during invitation)
        User admin = userRepository.findByEmail(command.getEmail())
                .orElseThrow(() -> new IllegalArgumentException("Invitation not found for email: " + command.getEmail()));

        // Verify user doesn't already have a Google ID
        if (admin.getGoogleId() != null) {
            throw new IllegalStateException("This admin account is already linked to a Google account");
        }

        // Link Google ID from their first login
        admin.setGoogleId(command.getGoogleId());
        admin.updateLastLogin();

        // Save and return
        return userRepository.save(admin);
    }

    /**
     * Command object for accepting admin invitation
     */
    public static class AcceptAdminInvitationCommand {
        private final String email;
        private final String googleId;
        private final String invitationToken;

        public AcceptAdminInvitationCommand(String email, String googleId, String invitationToken) {
            this.email = email;
            this.googleId = googleId;
            this.invitationToken = invitationToken;
        }

        public String getEmail() {
            return email;
        }

        public String getGoogleId() {
            return googleId;
        }

        public String getInvitationToken() {
            return invitationToken;
        }
    }
}
