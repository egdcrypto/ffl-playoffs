package com.ffl.playoffs.domain.model.worldowner;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Status of an owner's relationship with a world.
 */
@Getter
@RequiredArgsConstructor
public enum OwnershipStatus {
    INVITED("invited", "Invited", "Invitation pending acceptance"),
    ACTIVE("active", "Active", "Active owner with permissions"),
    INACTIVE("inactive", "Inactive", "Temporarily inactive owner"),
    REMOVED("removed", "Removed", "Owner has been removed"),
    DECLINED("declined", "Declined", "Invitation was declined");

    private final String code;
    private final String displayName;
    private final String description;

    /**
     * Check if this status allows active ownership.
     */
    public boolean isActive() {
        return this == ACTIVE;
    }

    /**
     * Check if this status can transition to active.
     */
    public boolean canActivate() {
        return this == INVITED || this == INACTIVE;
    }

    /**
     * Check if this is a terminal status.
     */
    public boolean isTerminal() {
        return this == REMOVED || this == DECLINED;
    }

    /**
     * Check if this status can be reactivated.
     */
    public boolean canReactivate() {
        return this == INACTIVE;
    }

    public static OwnershipStatus fromCode(String code) {
        for (OwnershipStatus status : values()) {
            if (status.code.equalsIgnoreCase(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Unknown ownership status code: " + code);
    }
}
