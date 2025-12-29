package com.ffl.playoffs.domain.entity;

import com.ffl.playoffs.domain.model.AdminInvitationStatus;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Domain entity representing an admin invitation.
 * Tracks the lifecycle of inviting a user to become an admin.
 */
public class AdminInvitation {

    private static final int EXPIRATION_DAYS = 7;

    private UUID id;
    private String email;
    private AdminInvitationStatus status;
    private String invitationToken;
    private UUID invitedBy;
    private LocalDateTime createdAt;
    private LocalDateTime expiresAt;
    private LocalDateTime acceptedAt;
    private UUID acceptedByUserId;

    /**
     * Default constructor for persistence frameworks
     */
    public AdminInvitation() {
    }

    /**
     * Creates a new admin invitation
     *
     * @param email the email address to invite
     * @param invitedBy the ID of the super admin sending the invitation
     * @return a new AdminInvitation with PENDING status
     */
    public static AdminInvitation create(String email, UUID invitedBy) {
        AdminInvitation invitation = new AdminInvitation();
        invitation.id = UUID.randomUUID();
        invitation.email = email.toLowerCase();
        invitation.status = AdminInvitationStatus.PENDING;
        invitation.invitationToken = generateToken();
        invitation.invitedBy = invitedBy;
        invitation.createdAt = LocalDateTime.now();
        invitation.expiresAt = invitation.createdAt.plusDays(EXPIRATION_DAYS);
        return invitation;
    }

    /**
     * Generates a secure invitation token
     */
    private static String generateToken() {
        return "admin_inv_" + UUID.randomUUID().toString().replace("-", "");
    }

    // Business methods

    /**
     * Checks if the invitation is still valid (pending and not expired)
     *
     * @return true if invitation can be accepted
     */
    public boolean isValid() {
        return status == AdminInvitationStatus.PENDING && !isExpired();
    }

    /**
     * Checks if the invitation has expired
     *
     * @return true if past expiration date
     */
    public boolean isExpired() {
        return LocalDateTime.now().isAfter(expiresAt);
    }

    /**
     * Accepts the invitation and links to the user
     *
     * @param userId the ID of the user accepting
     * @throws InvitationException if invitation is not valid
     */
    public void accept(UUID userId) {
        if (isExpired()) {
            this.status = AdminInvitationStatus.EXPIRED;
            throw new InvitationException("INVITATION_EXPIRED",
                    "This invitation has expired. Please request a new invitation.");
        }
        if (status != AdminInvitationStatus.PENDING) {
            throw new InvitationException("INVALID_STATUS",
                    "Invitation is not pending. Current status: " + status);
        }

        this.status = AdminInvitationStatus.ACCEPTED;
        this.acceptedAt = LocalDateTime.now();
        this.acceptedByUserId = userId;
    }

    /**
     * Marks the invitation as expired
     */
    public void markExpired() {
        this.status = AdminInvitationStatus.EXPIRED;
    }

    /**
     * Rejects the invitation (e.g., email mismatch)
     */
    public void reject() {
        this.status = AdminInvitationStatus.REJECTED;
    }

    /**
     * Cancels the invitation
     */
    public void cancel() {
        if (status != AdminInvitationStatus.PENDING) {
            throw new InvitationException("INVALID_STATUS",
                    "Can only cancel pending invitations");
        }
        this.status = AdminInvitationStatus.CANCELLED;
    }

    /**
     * Validates that the provided email matches the invitation email
     *
     * @param providedEmail the email to validate
     * @throws InvitationException if emails don't match
     */
    public void validateEmail(String providedEmail) {
        if (!this.email.equalsIgnoreCase(providedEmail)) {
            this.reject();
            throw new InvitationException("EMAIL_MISMATCH",
                    "The email address does not match the invitation");
        }
    }

    // Exception class

    /**
     * Exception thrown for invitation-related errors
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

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public AdminInvitationStatus getStatus() {
        return status;
    }

    public void setStatus(AdminInvitationStatus status) {
        this.status = status;
    }

    public String getInvitationToken() {
        return invitationToken;
    }

    public void setInvitationToken(String invitationToken) {
        this.invitationToken = invitationToken;
    }

    public UUID getInvitedBy() {
        return invitedBy;
    }

    public void setInvitedBy(UUID invitedBy) {
        this.invitedBy = invitedBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public LocalDateTime getAcceptedAt() {
        return acceptedAt;
    }

    public void setAcceptedAt(LocalDateTime acceptedAt) {
        this.acceptedAt = acceptedAt;
    }

    public UUID getAcceptedByUserId() {
        return acceptedByUserId;
    }

    public void setAcceptedByUserId(UUID acceptedByUserId) {
        this.acceptedByUserId = acceptedByUserId;
    }
}
