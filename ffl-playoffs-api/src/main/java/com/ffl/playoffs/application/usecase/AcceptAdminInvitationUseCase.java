package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.entity.AdminInvitation;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.AdminInvitationRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for accepting an admin invitation.
 * Handles both new user creation and existing user role upgrade.
 */
@Service
public class AcceptAdminInvitationUseCase {

    private final UserRepository userRepository;
    private final AdminInvitationRepository invitationRepository;

    public AcceptAdminInvitationUseCase(UserRepository userRepository,
                                         AdminInvitationRepository invitationRepository) {
        this.userRepository = userRepository;
        this.invitationRepository = invitationRepository;
    }

    /**
     * Accepts an admin invitation by token.
     * Creates a new user or upgrades an existing player to admin.
     *
     * @param command the acceptance command
     * @return the result containing user information
     * @throws InvitationException for validation errors
     */
    @Transactional
    public AcceptAdminInvitationResult execute(AcceptAdminInvitationCommand command) {
        // Find invitation by token
        AdminInvitation invitation = invitationRepository.findByInvitationToken(command.getInvitationToken())
                .orElseThrow(() -> new InvitationException("INVITATION_NOT_FOUND",
                        "Invalid invitation token"));

        // Check if expired
        if (invitation.isExpired()) {
            invitation.markExpired();
            invitationRepository.save(invitation);
            throw new InvitationException("INVITATION_EXPIRED",
                    "This invitation has expired. Please request a new invitation.");
        }

        // Validate email matches
        try {
            invitation.validateEmail(command.getGoogleEmail());
        } catch (AdminInvitation.InvitationException e) {
            invitationRepository.save(invitation);
            throw new InvitationException(e.getErrorCode(), e.getMessage());
        }

        // Check if user already exists
        Optional<User> existingUser = userRepository.findByEmail(command.getGoogleEmail());
        User user;
        boolean isNewUser;
        boolean wasUpgraded = false;

        if (existingUser.isPresent()) {
            user = existingUser.get();

            // Check if already admin
            if (user.getRole() == Role.ADMIN || user.getRole() == Role.SUPER_ADMIN) {
                throw new InvitationException("USER_ALREADY_ADMIN",
                        "User already has admin privileges");
            }

            // Upgrade from PLAYER to ADMIN
            user.upgradeToAdmin();
            if (command.getGoogleId() != null && user.getGoogleId() == null) {
                user.setGoogleId(command.getGoogleId());
            }
            user.updateLastLogin();
            user = userRepository.save(user);
            isNewUser = false;
            wasUpgraded = true;
        } else {
            // Create new user with ADMIN role
            user = new User(
                    command.getGoogleEmail(),
                    command.getDisplayName(),
                    command.getGoogleId(),
                    Role.ADMIN
            );
            user.updateLastLogin();
            user = userRepository.save(user);
            isNewUser = true;
        }

        // Accept the invitation
        invitation.accept(user.getId());
        invitationRepository.save(invitation);

        return new AcceptAdminInvitationResult(
                user.getId(),
                user.getEmail(),
                user.getName(),
                user.getRole(),
                isNewUser,
                wasUpgraded,
                invitation.getAcceptedAt()
        );
    }

    /**
     * Exception for invitation acceptance errors
     */
    public static class InvitationException extends RuntimeException {
        private final String errorCode;

        public InvitationException(String errorCode, String message) {
            super(message);
            this.errorCode = errorCode;
        }

        public String getErrorCode() {
            return errorCode;
        }
    }

    /**
     * Command for accepting an admin invitation
     */
    public static class AcceptAdminInvitationCommand {
        private final String invitationToken;
        private final String googleEmail;
        private final String googleId;
        private final String displayName;

        public AcceptAdminInvitationCommand(String invitationToken, String googleEmail,
                                             String googleId, String displayName) {
            this.invitationToken = invitationToken;
            this.googleEmail = googleEmail;
            this.googleId = googleId;
            this.displayName = displayName;
        }

        public String getInvitationToken() {
            return invitationToken;
        }

        public String getGoogleEmail() {
            return googleEmail;
        }

        public String getGoogleId() {
            return googleId;
        }

        public String getDisplayName() {
            return displayName;
        }
    }

    /**
     * Result of accepting an admin invitation
     */
    public static class AcceptAdminInvitationResult {
        private final UUID userId;
        private final String email;
        private final String name;
        private final Role role;
        private final boolean newUser;
        private final boolean upgraded;
        private final LocalDateTime acceptedAt;

        public AcceptAdminInvitationResult(UUID userId, String email, String name, Role role,
                                           boolean newUser, boolean upgraded, LocalDateTime acceptedAt) {
            this.userId = userId;
            this.email = email;
            this.name = name;
            this.role = role;
            this.newUser = newUser;
            this.upgraded = upgraded;
            this.acceptedAt = acceptedAt;
        }

        public UUID getUserId() {
            return userId;
        }

        public String getEmail() {
            return email;
        }

        public String getName() {
            return name;
        }

        public Role getRole() {
            return role;
        }

        public boolean isNewUser() {
            return newUser;
        }

        public boolean isUpgraded() {
            return upgraded;
        }

        public LocalDateTime getAcceptedAt() {
            return acceptedAt;
        }
    }
}
