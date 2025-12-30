package com.ffl.playoffs.domain.model.accesscontrol;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Defines roles within a World context for access control.
 * Roles follow a hierarchy where higher roles include lower role permissions.
 */
@Getter
@RequiredArgsConstructor
public enum WorldRole {
    VIEWER("viewer", "Viewer", "Can view world content", 1),
    EDITOR("editor", "Editor", "Can edit world content", 2),
    MODERATOR("moderator", "Moderator", "Can manage members and content", 3),
    ADMIN("admin", "Administrator", "Can manage world settings", 4),
    OWNER("owner", "Owner", "Full control of the world", 5);

    private final String code;
    private final String displayName;
    private final String description;
    private final int level;

    /**
     * Check if this role has at least the same permissions as the required role.
     */
    public boolean hasPermission(WorldRole requiredRole) {
        return this.level >= requiredRole.level;
    }

    /**
     * Check if this role can grant the specified role to others.
     * A role can only grant roles lower than itself.
     */
    public boolean canGrantRole(WorldRole roleToGrant) {
        return this.level > roleToGrant.level;
    }

    /**
     * Check if this role can manage members (MODERATOR or higher).
     */
    public boolean canManageMembers() {
        return hasPermission(MODERATOR);
    }

    /**
     * Check if this role can modify settings (ADMIN or higher).
     */
    public boolean canModifySettings() {
        return hasPermission(ADMIN);
    }

    /**
     * Check if this is the owner role.
     */
    public boolean isOwner() {
        return this == OWNER;
    }

    public static WorldRole fromCode(String code) {
        for (WorldRole role : values()) {
            if (role.code.equalsIgnoreCase(code)) {
                return role;
            }
        }
        throw new IllegalArgumentException("Unknown world role code: " + code);
    }
}
