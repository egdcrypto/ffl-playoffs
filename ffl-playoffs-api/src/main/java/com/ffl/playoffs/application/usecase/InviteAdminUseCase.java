package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.model.User;
import com.ffl.playoffs.domain.port.UserRepository;

import java.util.UUID;

/**
 * Use case for inviting an admin user to the system
 * Only SUPER_ADMIN can invite admins
 */
public class InviteAdminUseCase {

    private final UserRepository userRepository;

    public InviteAdminUseCase(UserRepository userRepository) {
        this.userRepository = userRepository;
    }

    /**
     * Invites a new admin to the system
     * Creates a user account with ADMIN role
     *
     * @param command The invite admin command
     * @return The newly created admin User
     * @throws IllegalStateException if inviter is not SUPER_ADMIN
     * @throws IllegalStateException if user already exists
     */
    public InviteAdminResult execute(InviteAdminCommand command) {
        // Verify inviter is SUPER_ADMIN
        User inviter = userRepository.findById(command.getInvitedBy())
                .orElseThrow(() -> new IllegalArgumentException("Inviter not found"));

        if (!inviter.isSuperAdmin()) {
            throw new IllegalStateException("Only SUPER_ADMIN can invite admins");
        }

        // Check if user already exists
        if (userRepository.findByEmail(command.getEmail()).isPresent()) {
            throw new IllegalStateException("User with email already exists: " + command.getEmail());
        }

        // Create admin user account
        // In a real system, this would send an email invitation
        // For now, we create the account directly with ADMIN role
        User admin = new User(
                command.getEmail(),
                command.getName(),
                null,  // Google ID will be set when they first login
                Role.ADMIN
        );

        admin = userRepository.save(admin);

        // In production, would generate and send invitation token via email
        String invitationToken = "admin_invite_" + UUID.randomUUID();

        return new InviteAdminResult(admin, invitationToken);
    }

    /**
     * Command object for inviting an admin
     */
    public static class InviteAdminCommand {
        private final String email;
        private final String name;
        private final UUID invitedBy;

        public InviteAdminCommand(String email, String name, UUID invitedBy) {
            this.email = email;
            this.name = name;
            this.invitedBy = invitedBy;
        }

        public String getEmail() {
            return email;
        }

        public String getName() {
            return name;
        }

        public UUID getInvitedBy() {
            return invitedBy;
        }
    }

    /**
     * Result object containing the invited admin and invitation token
     */
    public static class InviteAdminResult {
        private final User admin;
        private final String invitationToken;

        public InviteAdminResult(User admin, String invitationToken) {
            this.admin = admin;
            this.invitationToken = invitationToken;
        }

        public User getAdmin() {
            return admin;
        }

        public String getInvitationToken() {
            return invitationToken;
        }
    }
}
