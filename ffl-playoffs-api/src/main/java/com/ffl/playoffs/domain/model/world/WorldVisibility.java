package com.ffl.playoffs.domain.model.world;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Visibility settings for a World.
 */
@Getter
@RequiredArgsConstructor
public enum WorldVisibility {
    PRIVATE("private", "Private", "Only invited members can see and join"),
    INVITE_ONLY("invite_only", "Invite Only", "Visible to all but requires invitation to join"),
    PUBLIC("public", "Public", "Anyone can see and join");

    private final String code;
    private final String displayName;
    private final String description;

    /**
     * Check if this visibility allows public viewing.
     */
    public boolean isPubliclyVisible() {
        return this == INVITE_ONLY || this == PUBLIC;
    }

    /**
     * Check if this visibility requires an invitation to join.
     */
    public boolean requiresInvitation() {
        return this == PRIVATE || this == INVITE_ONLY;
    }

    public static WorldVisibility fromCode(String code) {
        for (WorldVisibility visibility : values()) {
            if (visibility.code.equalsIgnoreCase(code)) {
                return visibility;
            }
        }
        throw new IllegalArgumentException("Unknown world visibility code: " + code);
    }
}
