package com.ffl.playoffs.domain.model.invitation;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Status of an admin invitation.
 */
@Getter
@RequiredArgsConstructor
public enum AdminInvitationStatus {
    PENDING("pending", "Pending", "Invitation sent but not yet accepted"),
    ACCEPTED("accepted", "Accepted", "Invitation has been accepted"),
    DECLINED("declined", "Declined", "Invitation was declined by the invitee"),
    EXPIRED("expired", "Expired", "Invitation has expired"),
    REVOKED("revoked", "Revoked", "Invitation was revoked by admin");

    private final String code;
    private final String displayName;
    private final String description;

    /**
     * Check if this is a pending invitation.
     */
    public boolean isPending() {
        return this == PENDING;
    }

    /**
     * Check if this invitation can be accepted.
     */
    public boolean canAccept() {
        return this == PENDING;
    }

    /**
     * Check if this invitation can be declined.
     */
    public boolean canDecline() {
        return this == PENDING;
    }

    /**
     * Check if this invitation can be revoked.
     */
    public boolean canRevoke() {
        return this == PENDING;
    }

    /**
     * Check if this is a terminal status.
     */
    public boolean isTerminal() {
        return this == ACCEPTED || this == DECLINED || this == EXPIRED || this == REVOKED;
    }

    /**
     * Check if the invitation was successfully completed.
     */
    public boolean isSuccessful() {
        return this == ACCEPTED;
    }

    public static AdminInvitationStatus fromCode(String code) {
        for (AdminInvitationStatus status : values()) {
            if (status.code.equalsIgnoreCase(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Unknown admin invitation status code: " + code);
    }
}
