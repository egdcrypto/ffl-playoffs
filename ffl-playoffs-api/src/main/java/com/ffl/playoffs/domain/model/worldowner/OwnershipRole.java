package com.ffl.playoffs.domain.model.worldowner;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Defines ownership roles within a World context.
 * Roles follow a hierarchy where higher roles include lower role capabilities.
 */
@Getter
@RequiredArgsConstructor
public enum OwnershipRole {
    MANAGER("manager", "Manager", "Limited permissions for player and roster management", 1),
    CO_OWNER("co_owner", "Co-Owner", "Most permissions except owner management", 2),
    PRIMARY_OWNER("primary_owner", "Primary Owner", "Full control including owner management", 3);

    private final String code;
    private final String displayName;
    private final String description;
    private final int level;

    /**
     * Check if this role has at least the same permissions as the required role.
     */
    public boolean hasPermission(OwnershipRole requiredRole) {
        return this.level >= requiredRole.level;
    }

    /**
     * Check if this role can grant the specified role to others.
     */
    public boolean canGrantRole(OwnershipRole roleToGrant) {
        // Only PRIMARY_OWNER can grant roles
        if (this != PRIMARY_OWNER) {
            return false;
        }
        // PRIMARY_OWNER can grant any role except PRIMARY_OWNER
        return roleToGrant != PRIMARY_OWNER;
    }

    /**
     * Check if this role can manage other owners.
     */
    public boolean canManageOwners() {
        return this == PRIMARY_OWNER;
    }

    /**
     * Check if this role can manage world settings.
     */
    public boolean canManageSettings() {
        return hasPermission(CO_OWNER);
    }

    /**
     * Check if this role can manage players.
     */
    public boolean canManagePlayers() {
        return true; // All ownership roles can manage players
    }

    /**
     * Check if this is the primary owner role.
     */
    public boolean isPrimaryOwner() {
        return this == PRIMARY_OWNER;
    }

    public static OwnershipRole fromCode(String code) {
        for (OwnershipRole role : values()) {
            if (role.code.equalsIgnoreCase(code)) {
                return role;
            }
        }
        throw new IllegalArgumentException("Unknown ownership role code: " + code);
    }
}
