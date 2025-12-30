package com.ffl.playoffs.domain.model.world;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Status of a World's lifecycle.
 */
@Getter
@RequiredArgsConstructor
public enum WorldStatus {
    DRAFT("draft", "Draft", "World is being set up"),
    ACTIVE("active", "Active", "World is active and operational"),
    SUSPENDED("suspended", "Suspended", "World is temporarily suspended"),
    ARCHIVED("archived", "Archived", "World is archived and read-only"),
    DELETED("deleted", "Deleted", "World is marked for deletion");

    private final String code;
    private final String displayName;
    private final String description;

    /**
     * Check if this status allows modifications.
     */
    public boolean isModifiable() {
        return this == DRAFT || this == ACTIVE;
    }

    /**
     * Check if this status allows new members.
     */
    public boolean allowsNewMembers() {
        return this == ACTIVE;
    }

    /**
     * Check if this is a terminal status.
     */
    public boolean isTerminal() {
        return this == ARCHIVED || this == DELETED;
    }

    /**
     * Check if the world is operational.
     */
    public boolean isOperational() {
        return this == ACTIVE;
    }

    /**
     * Check if the world can be activated.
     */
    public boolean canActivate() {
        return this == DRAFT || this == SUSPENDED;
    }

    /**
     * Check if the world can be suspended.
     */
    public boolean canSuspend() {
        return this == ACTIVE;
    }

    /**
     * Check if the world can be archived.
     */
    public boolean canArchive() {
        return this == ACTIVE || this == SUSPENDED;
    }

    public static WorldStatus fromCode(String code) {
        for (WorldStatus status : values()) {
            if (status.code.equalsIgnoreCase(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Unknown world status code: " + code);
    }
}
