package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * PlayerInvitation Entity
 *
 * Represents an invitation for a player to join a specific league.
 * Invitations are league-scoped and have a 7-day expiration.
 *
 * Domain model with no framework dependencies.
 */
public class PlayerInvitation {

    private static final int EXPIRATION_DAYS = 7;

    private UUID id;
    private UUID leagueId;
    private String leagueName;
    private String email;
    private String invitationToken;
    private InvitationStatus status;
    private UUID invitedByUserId;
    private LocalDateTime createdAt;
    private LocalDateTime expiresAt;
    private LocalDateTime acceptedAt;
    private UUID acceptedByUserId;

    /**
     * Invitation status enumeration
     */
    public enum InvitationStatus {
        PENDING,    // Invitation sent but not yet accepted
        ACCEPTED,   // Invitation accepted and player joined league
        DECLINED,   // Invitation explicitly declined
        EXPIRED,    // Invitation expired after 7 days
        CANCELLED   // Invitation cancelled by admin
    }

    /**
     * Default constructor
     */
    public PlayerInvitation() {
        this.id = UUID.randomUUID();
        this.invitationToken = generateToken();
        this.status = InvitationStatus.PENDING;
        this.createdAt = LocalDateTime.now();
        this.expiresAt = this.createdAt.plusDays(EXPIRATION_DAYS);
    }

    /**
     * Constructor with required fields
     *
     * @param leagueId The league to invite the player to
     * @param leagueName The league name (for display in emails)
     * @param email The email address of the invitee
     * @param invitedByUserId The admin who sent the invitation
     */
    public PlayerInvitation(UUID leagueId, String leagueName, String email, UUID invitedByUserId) {
        this();
        this.leagueId = leagueId;
        this.leagueName = leagueName;
        this.email = email;
        this.invitedByUserId = invitedByUserId;
    }

    // ==================== Business Methods ====================

    /**
     * Checks if the invitation has expired.
     *
     * @return true if current time is past expiration time
     */
    public boolean isExpired() {
        return LocalDateTime.now().isAfter(expiresAt);
    }

    /**
     * Checks if the invitation can be accepted.
     *
     * @return true if invitation is pending and not expired
     */
    public boolean canBeAccepted() {
        return status == InvitationStatus.PENDING && !isExpired();
    }

    /**
     * Accepts the invitation.
     * Validates that invitation is still valid before accepting.
     *
     * @param userId The user ID of the player accepting
     * @throws InvitationException if invitation cannot be accepted
     */
    public void accept(UUID userId) {
        if (status != InvitationStatus.PENDING) {
            throw new InvitationException("INVITATION_ALREADY_PROCESSED",
                "Invitation has already been " + status.name().toLowerCase());
        }

        if (isExpired()) {
            this.status = InvitationStatus.EXPIRED;
            throw new InvitationException("INVITATION_EXPIRED",
                "Invitation expired on " + expiresAt);
        }

        this.status = InvitationStatus.ACCEPTED;
        this.acceptedAt = LocalDateTime.now();
        this.acceptedByUserId = userId;
    }

    /**
     * Declines the invitation.
     *
     * @throws InvitationException if invitation cannot be declined
     */
    public void decline() {
        if (status != InvitationStatus.PENDING) {
            throw new InvitationException("INVITATION_ALREADY_PROCESSED",
                "Invitation has already been " + status.name().toLowerCase());
        }

        this.status = InvitationStatus.DECLINED;
    }

    /**
     * Cancels the invitation (admin action).
     *
     * @throws InvitationException if invitation cannot be cancelled
     */
    public void cancel() {
        if (status == InvitationStatus.ACCEPTED) {
            throw new InvitationException("CANNOT_CANCEL_ACCEPTED",
                "Cannot cancel an already accepted invitation");
        }

        this.status = InvitationStatus.CANCELLED;
    }

    /**
     * Marks the invitation as expired.
     * Called by a scheduled job or validation check.
     */
    public void markExpired() {
        if (status == InvitationStatus.PENDING && isExpired()) {
            this.status = InvitationStatus.EXPIRED;
        }
    }

    /**
     * Generates a secure invitation token.
     *
     * @return A secure random token
     */
    private String generateToken() {
        return "inv_" + UUID.randomUUID().toString().replace("-", "");
    }

    /**
     * Gets the remaining time before expiration in days.
     *
     * @return Days remaining, or 0 if expired
     */
    public long getDaysUntilExpiration() {
        if (isExpired()) {
            return 0;
        }
        return java.time.Duration.between(LocalDateTime.now(), expiresAt).toDays();
    }

    // ==================== Getters and Setters ====================

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getLeagueId() {
        return leagueId;
    }

    public void setLeagueId(UUID leagueId) {
        this.leagueId = leagueId;
    }

    public String getLeagueName() {
        return leagueName;
    }

    public void setLeagueName(String leagueName) {
        this.leagueName = leagueName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getInvitationToken() {
        return invitationToken;
    }

    public void setInvitationToken(String invitationToken) {
        this.invitationToken = invitationToken;
    }

    public InvitationStatus getStatus() {
        return status;
    }

    public void setStatus(InvitationStatus status) {
        this.status = status;
    }

    public UUID getInvitedByUserId() {
        return invitedByUserId;
    }

    public void setInvitedByUserId(UUID invitedByUserId) {
        this.invitedByUserId = invitedByUserId;
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

    // ==================== Custom Exception ====================

    /**
     * Exception for invitation-related errors with error codes
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

    @Override
    public String toString() {
        return String.format(
            "PlayerInvitation{id=%s, leagueId=%s, email='%s', status=%s, expires=%s}",
            id, leagueId, email, status, expiresAt
        );
    }
}
