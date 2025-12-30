package com.ffl.playoffs.domain.model;

import java.util.Set;

/**
 * User role enumeration
 * Defines the three-tier role hierarchy: SUPER_ADMIN > ADMIN > PLAYER
 */
public enum Role {
    /**
     * Regular player - can build rosters, view standings
     * League-scoped permissions
     */
    PLAYER,

    /**
     * League administrator - can create leagues, invite players
     * League-scoped permissions
     */
    ADMIN,

    /**
     * System administrator - full system access
     * Can invite admins, manage PATs, view all leagues
     * Cannot be created through invitation - bootstrapped via configuration
     */
    SUPER_ADMIN;

    /**
     * Gets the hierarchy level of this role
     * @return hierarchy level (0 = PLAYER, 1 = ADMIN, 2 = SUPER_ADMIN)
     */
    public int getLevel() {
        return RoleHierarchy.getLevel(this);
    }

    /**
     * Checks if this role is at least as high as the specified role
     * @param other the role to compare against
     * @return true if this role is at least the other role's level
     */
    public boolean isAtLeast(Role other) {
        return RoleHierarchy.isAtLeast(this, other);
    }

    /**
     * Checks if this role is higher than the specified role
     * @param other the role to compare against
     * @return true if this role is strictly higher
     */
    public boolean isHigherThan(Role other) {
        return RoleHierarchy.isHigherThan(this, other);
    }

    /**
     * Checks if this role has the specified permission
     * @param permission the permission to check
     * @return true if this role has the permission
     */
    public boolean hasPermission(Permission permission) {
        return RoleHierarchy.hasPermission(this, permission);
    }

    /**
     * Gets all permissions granted to this role
     * @return set of permissions
     */
    public Set<Permission> getPermissions() {
        return RoleHierarchy.getPermissions(this);
    }

    /**
     * Checks if this role can invite users with the specified role
     * @param inviteeRole the role to invite
     * @return true if invitation is allowed
     */
    public boolean canInvite(Role inviteeRole) {
        return RoleHierarchy.canInvite(this, inviteeRole);
    }
}
