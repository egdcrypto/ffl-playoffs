package com.ffl.playoffs.domain.model.invitation;

import lombok.*;

import java.time.Instant;
import java.util.Objects;
import java.util.UUID;

/**
 * Admin Invitation entity - represents an invitation for a user to become an admin.
 *
 * This entity tracks the full lifecycle of an admin invitation from creation to acceptance/expiration.
 * Only SUPER_ADMIN users can create admin invitations.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AdminInvitation {
    private UUID id;
    private String email;
    private String name;
    private UUID invitedBy; // The SUPER_ADMIN who sent the invitation
    private String invitationToken;
    private AdminInvitationStatus status;
    private Instant expiresAt;
    private Instant createdAt;
    private Instant updatedAt;
    private Instant acceptedAt;
    private Instant revokedAt;
    private UUID acceptedUserId; // The User ID created when invitation is accepted
    private String revokeReason;
    private Integer resendCount;

    /** Default invitation validity period in days */
    private static final int DEFAULT_EXPIRY_DAYS = 7;

    /**
     * Create a new admin invitation.
     */
    public static AdminInvitation create(String email, String name, UUID invitedBy) {
        Objects.requireNonNull(email, "Email is required");
        Objects.requireNonNull(name, "Name is required");
        Objects.requireNonNull(invitedBy, "InvitedBy is required");

        if (email.isBlank()) {
            throw new IllegalArgumentException("Email cannot be blank");
        }
        if (name.isBlank()) {
            throw new IllegalArgumentException("Name cannot be blank");
        }

        AdminInvitation invitation = new AdminInvitation();
        invitation.id = UUID.randomUUID();
        invitation.email = email.trim().toLowerCase();
        invitation.name = name.trim();
        invitation.invitedBy = invitedBy;
        invitation.invitationToken = generateToken();
        invitation.status = AdminInvitationStatus.PENDING;
        invitation.expiresAt = Instant.now().plusSeconds(DEFAULT_EXPIRY_DAYS * 24 * 60 * 60);
        invitation.createdAt = Instant.now();
        invitation.updatedAt = Instant.now();
        invitation.resendCount = 0;

        return invitation;
    }

    /**
     * Accept the invitation.
     */
    public void accept(String token, UUID userId) {
        Objects.requireNonNull(token, "Token is required");
        Objects.requireNonNull(userId, "User ID is required");

        if (!status.canAccept()) {
            throw new IllegalStateException("Cannot accept invitation in status: " + status);
        }

        if (!token.equals(this.invitationToken)) {
            throw new IllegalArgumentException("Invalid invitation token");
        }

        if (isExpired()) {
            this.status = AdminInvitationStatus.EXPIRED;
            this.updatedAt = Instant.now();
            throw new IllegalStateException("Invitation has expired");
        }

        this.status = AdminInvitationStatus.ACCEPTED;
        this.acceptedAt = Instant.now();
        this.acceptedUserId = userId;
        this.invitationToken = null; // Clear token after use
        this.updatedAt = Instant.now();
    }

    /**
     * Decline the invitation.
     */
    public void decline() {
        if (!status.canDecline()) {
            throw new IllegalStateException("Cannot decline invitation in status: " + status);
        }

        this.status = AdminInvitationStatus.DECLINED;
        this.invitationToken = null;
        this.updatedAt = Instant.now();
    }

    /**
     * Revoke the invitation.
     */
    public void revoke(String reason) {
        if (!status.canRevoke()) {
            throw new IllegalStateException("Cannot revoke invitation in status: " + status);
        }

        this.status = AdminInvitationStatus.REVOKED;
        this.revokeReason = reason;
        this.revokedAt = Instant.now();
        this.invitationToken = null;
        this.updatedAt = Instant.now();
    }

    /**
     * Mark as expired.
     */
    public void markExpired() {
        if (status != AdminInvitationStatus.PENDING) {
            return; // Only pending invitations can expire
        }

        this.status = AdminInvitationStatus.EXPIRED;
        this.invitationToken = null;
        this.updatedAt = Instant.now();
    }

    /**
     * Resend the invitation with a new token.
     */
    public void resend() {
        if (status != AdminInvitationStatus.PENDING && status != AdminInvitationStatus.EXPIRED) {
            throw new IllegalStateException("Can only resend pending or expired invitations");
        }

        this.invitationToken = generateToken();
        this.status = AdminInvitationStatus.PENDING;
        this.expiresAt = Instant.now().plusSeconds(DEFAULT_EXPIRY_DAYS * 24 * 60 * 60);
        this.resendCount = (resendCount != null ? resendCount : 0) + 1;
        this.updatedAt = Instant.now();
    }

    /**
     * Check if the invitation has expired.
     */
    public boolean isExpired() {
        return status == AdminInvitationStatus.EXPIRED ||
               (status == AdminInvitationStatus.PENDING &&
                expiresAt != null &&
                Instant.now().isAfter(expiresAt));
    }

    /**
     * Check if the invitation is still valid (pending and not expired).
     */
    public boolean isValid() {
        return status == AdminInvitationStatus.PENDING && !isExpired();
    }

    /**
     * Check if the invitation was accepted.
     */
    public boolean isAccepted() {
        return status == AdminInvitationStatus.ACCEPTED;
    }

    /**
     * Validate the invitation token.
     */
    public boolean validateToken(String token) {
        return token != null && token.equals(this.invitationToken) && isValid();
    }

    /**
     * Get remaining validity in hours.
     */
    public long getRemainingHours() {
        if (!isValid()) {
            return 0;
        }
        long remainingSeconds = expiresAt.getEpochSecond() - Instant.now().getEpochSecond();
        return Math.max(0, remainingSeconds / 3600);
    }

    /**
     * Generate a secure invitation token.
     */
    private static String generateToken() {
        return UUID.randomUUID().toString().replace("-", "") +
               UUID.randomUUID().toString().replace("-", "").substring(0, 16);
    }

    @Override
    public String toString() {
        return String.format(
            "AdminInvitation{id=%s, email='%s', status=%s, invitedBy=%s, expiresAt=%s}",
            id, email, status, invitedBy, expiresAt
        );
    }
}
