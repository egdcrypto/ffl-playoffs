package com.ffl.playoffs.domain.model;

import java.util.EnumSet;
import java.util.Set;

/**
 * RoleHierarchy - Domain service for role-based access control
 * Defines the three-tier role hierarchy: SUPER_ADMIN > ADMIN > PLAYER
 */
public final class RoleHierarchy {

    private RoleHierarchy() {
        // Utility class - no instantiation
    }

    /**
     * Gets the hierarchy level of a role (higher = more permissions)
     * @param role the role to check
     * @return hierarchy level (0 = PLAYER, 1 = ADMIN, 2 = SUPER_ADMIN)
     */
    public static int getLevel(Role role) {
        return switch (role) {
            case PLAYER -> 0;
            case ADMIN -> 1;
            case SUPER_ADMIN -> 2;
        };
    }

    /**
     * Checks if role1 is at least as high as role2 in the hierarchy
     * @param role1 the role to check
     * @param role2 the role to compare against
     * @return true if role1 is at least role2's level
     */
    public static boolean isAtLeast(Role role1, Role role2) {
        return getLevel(role1) >= getLevel(role2);
    }

    /**
     * Checks if role1 is higher than role2 in the hierarchy
     * @param role1 the role to check
     * @param role2 the role to compare against
     * @return true if role1 is strictly higher
     */
    public static boolean isHigherThan(Role role1, Role role2) {
        return getLevel(role1) > getLevel(role2);
    }

    /**
     * Checks if a role has a specific permission
     * @param role the role to check
     * @param permission the permission required
     * @return true if the role has the permission
     */
    public static boolean hasPermission(Role role, Permission permission) {
        return isAtLeast(role, permission.getMinimumRole());
    }

    /**
     * Gets all permissions granted to a role
     * @param role the role
     * @return set of permissions granted to the role
     */
    public static Set<Permission> getPermissions(Role role) {
        Set<Permission> permissions = EnumSet.noneOf(Permission.class);
        for (Permission permission : Permission.values()) {
            if (hasPermission(role, permission)) {
                permissions.add(permission);
            }
        }
        return permissions;
    }

    /**
     * Gets all roles that a role can manage (roles below it in hierarchy)
     * @param role the role
     * @return set of roles that can be managed
     */
    public static Set<Role> getManageableRoles(Role role) {
        Set<Role> manageable = EnumSet.noneOf(Role.class);
        for (Role r : Role.values()) {
            if (isHigherThan(role, r)) {
                manageable.add(r);
            }
        }
        return manageable;
    }

    /**
     * Checks if a role can be assigned by another role
     * Only SUPER_ADMIN can assign any role
     * @param assignerRole the role of the user assigning
     * @param roleToAssign the role being assigned
     * @return true if the assignment is allowed
     */
    public static boolean canAssignRole(Role assignerRole, Role roleToAssign) {
        // Only SUPER_ADMIN can assign roles
        if (assignerRole != Role.SUPER_ADMIN) {
            return false;
        }
        // Can assign any role except SUPER_ADMIN (which is bootstrapped)
        return roleToAssign != Role.SUPER_ADMIN;
    }

    /**
     * Checks if a role can invite users with a specific role
     * @param inviterRole the role of the user inviting
     * @param inviteeRole the role being invited to
     * @return true if the invitation is allowed
     */
    public static boolean canInvite(Role inviterRole, Role inviteeRole) {
        return switch (inviterRole) {
            case SUPER_ADMIN -> inviteeRole == Role.ADMIN;  // Super admin can invite admins
            case ADMIN -> inviteeRole == Role.PLAYER;        // Admin can invite players
            case PLAYER -> false;                             // Players cannot invite
        };
    }
}
