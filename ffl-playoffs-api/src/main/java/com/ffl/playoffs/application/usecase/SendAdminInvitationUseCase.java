package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.entity.AdminInvitation;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.AdminInvitationRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Use case for sending admin invitations.
 * Only SUPER_ADMIN can invite admins.
 * Creates an AdminInvitation with PENDING status and 7-day expiration.
 */
@Service
public class SendAdminInvitationUseCase {

    private final UserRepository userRepository;
    private final AdminInvitationRepository invitationRepository;

    public SendAdminInvitationUseCase(UserRepository userRepository,
                                       AdminInvitationRepository invitationRepository) {
        this.userRepository = userRepository;
        this.invitationRepository = invitationRepository;
    }

    /**
     * Sends an admin invitation to the specified email.
     *
     * @param command the invitation command
     * @return the result containing the invitation details
     * @throws IllegalStateException if inviter is not SUPER_ADMIN
     * @throws InvitationException for validation errors
     */
    @Transactional
    public SendAdminInvitationResult execute(SendAdminInvitationCommand command) {
        // Verify inviter is SUPER_ADMIN
        User inviter = userRepository.findById(command.getInvitedBy())
                .orElseThrow(() -> new IllegalArgumentException("Inviter not found"));

        if (!inviter.isSuperAdmin()) {
            throw new InvitationException("FORBIDDEN",
                    "Only SUPER_ADMIN can invite admins");
        }

        // Validate target role is not SUPER_ADMIN
        if (command.getTargetRole() == Role.SUPER_ADMIN) {
            throw new InvitationException("INVALID_ROLE",
                    "Cannot create SUPER_ADMIN invitation. SUPER_ADMIN can only be bootstrapped via configuration.");
        }

        // Check if user already exists with ADMIN or higher role
        userRepository.findByEmail(command.getEmail()).ifPresent(existingUser -> {
            if (existingUser.getRole() == Role.ADMIN || existingUser.getRole() == Role.SUPER_ADMIN) {
                throw new InvitationException("USER_ALREADY_ADMIN",
                        "User is already an admin: " + command.getEmail());
            }
        });

        // Check for pending invitation
        if (invitationRepository.existsPendingByEmail(command.getEmail())) {
            throw new InvitationException("PENDING_INVITATION_EXISTS",
                    "A pending invitation already exists for: " + command.getEmail());
        }

        // Create the invitation
        AdminInvitation invitation = AdminInvitation.create(command.getEmail(), command.getInvitedBy());
        invitation = invitationRepository.save(invitation);

        return new SendAdminInvitationResult(
                invitation.getId(),
                invitation.getEmail(),
                invitation.getInvitationToken(),
                invitation.getExpiresAt(),
                "Admin invitation created successfully. Email will be sent to: " + command.getEmail()
        );
    }

    /**
     * Exception for invitation-related errors
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
     * Command for sending an admin invitation
     */
    public static class SendAdminInvitationCommand {
        private final String email;
        private final UUID invitedBy;
        private final Role targetRole;

        public SendAdminInvitationCommand(String email, UUID invitedBy) {
            this(email, invitedBy, Role.ADMIN);
        }

        public SendAdminInvitationCommand(String email, UUID invitedBy, Role targetRole) {
            this.email = email;
            this.invitedBy = invitedBy;
            this.targetRole = targetRole;
        }

        public String getEmail() {
            return email;
        }

        public UUID getInvitedBy() {
            return invitedBy;
        }

        public Role getTargetRole() {
            return targetRole;
        }
    }

    /**
     * Result of sending an admin invitation
     */
    public static class SendAdminInvitationResult {
        private final UUID invitationId;
        private final String email;
        private final String invitationToken;
        private final LocalDateTime expiresAt;
        private final String message;

        public SendAdminInvitationResult(UUID invitationId, String email, String invitationToken,
                                         LocalDateTime expiresAt, String message) {
            this.invitationId = invitationId;
            this.email = email;
            this.invitationToken = invitationToken;
            this.expiresAt = expiresAt;
            this.message = message;
        }

        public UUID getInvitationId() {
            return invitationId;
        }

        public String getEmail() {
            return email;
        }

        public String getInvitationToken() {
            return invitationToken;
        }

        public LocalDateTime getExpiresAt() {
            return expiresAt;
        }

        public String getMessage() {
            return message;
        }
    }
}
