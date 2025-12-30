package com.ffl.playoffs.domain.model.accesscontrol;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Status of a member's access to a world.
 */
@Getter
@RequiredArgsConstructor
public enum MembershipStatus {
    PENDING("pending", "Pending", "Invitation pending acceptance"),
    ACTIVE("active", "Active", "Active member with access"),
    SUSPENDED("suspended", "Suspended", "Temporarily suspended access"),
    EXPIRED("expired", "Expired", "Access has expired"),
    REVOKED("revoked", "Revoked", "Access has been revoked"),
    DECLINED("declined", "Declined", "Invitation was declined");

    private final String code;
    private final String displayName;
    private final String description;

    /**
     * Check if this status allows access.
     */
    public boolean hasAccess() {
        return this == ACTIVE;
    }

    /**
     * Check if this status can transition to active.
     */
    public boolean canActivate() {
        return this == PENDING || this == SUSPENDED || this == EXPIRED;
    }

    /**
     * Check if this is a terminal status (cannot change).
     */
    public boolean isTerminal() {
        return this == REVOKED || this == DECLINED;
    }

    public static MembershipStatus fromCode(String code) {
        for (MembershipStatus status : values()) {
            if (status.code.equalsIgnoreCase(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Unknown membership status code: " + code);
    }
}
