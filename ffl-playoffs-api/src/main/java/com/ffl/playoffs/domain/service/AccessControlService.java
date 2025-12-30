package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Permission;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.model.RoleHierarchy;

import java.util.UUID;

/**
 * Domain service for resource-level access control
 * Handles league-scoped and resource-specific permission checks
 */
public class AccessControlService {

    /**
     * Checks if user has a specific permission
     * @param user the user to check
     * @param permission the permission required
     * @return true if user has the permission
     */
    public boolean hasPermission(User user, Permission permission) {
        if (user == null || !user.isActive()) {
            return false;
        }
        return RoleHierarchy.hasPermission(user.getRole(), permission);
    }

    /**
     * Checks if user can access a specific league
     * @param user the user to check
     * @param leagueId the league ID
     * @param isOwner true if user is the league owner
     * @param isMember true if user is a league member
     * @return true if user can access the league
     */
    public boolean canAccessLeague(User user, UUID leagueId, boolean isOwner, boolean isMember) {
        if (user == null || !user.isActive()) {
            return false;
        }

        // Super admin can access all leagues
        if (user.isSuperAdmin()) {
            return true;
        }

        // Admin can access leagues they own
        if (user.getRole() == Role.ADMIN && isOwner) {
            return true;
        }

        // Players can access leagues they are members of
        if (user.getRole() == Role.PLAYER && isMember) {
            return true;
        }

        // Admins who are members can also view
        if (user.getRole() == Role.ADMIN && isMember) {
            return true;
        }

        return false;
    }

    /**
     * Checks if user can manage a specific league (modify settings, invite players, etc.)
     * @param user the user to check
     * @param leagueId the league ID
     * @param isOwner true if user is the league owner
     * @return true if user can manage the league
     */
    public boolean canManageLeague(User user, UUID leagueId, boolean isOwner) {
        if (user == null || !user.isActive()) {
            return false;
        }

        // Super admin can manage all leagues
        if (user.isSuperAdmin()) {
            return true;
        }

        // Admin can only manage their own leagues
        return user.getRole() == Role.ADMIN && isOwner;
    }

    /**
     * Checks if user can invite players to a league
     * @param user the user to check
     * @param isOwner true if user is the league owner
     * @return true if user can invite players
     */
    public boolean canInviteToLeague(User user, boolean isOwner) {
        if (user == null || !user.isActive()) {
            return false;
        }

        // Super admin can invite to any league
        if (user.isSuperAdmin()) {
            return true;
        }

        // Admin can only invite to their own leagues
        return user.isAdmin() && isOwner;
    }

    /**
     * Checks if user can view system-wide data
     * @param user the user to check
     * @return true if user can view system-wide data
     */
    public boolean canViewSystemWideData(User user) {
        if (user == null || !user.isActive()) {
            return false;
        }
        return user.isSuperAdmin();
    }

    /**
     * Checks if user can manage admin accounts
     * @param user the user to check
     * @return true if user can manage admins
     */
    public boolean canManageAdmins(User user) {
        if (user == null || !user.isActive()) {
            return false;
        }
        return user.isSuperAdmin();
    }

    /**
     * Checks if user can create leagues
     * @param user the user to check
     * @return true if user can create leagues
     */
    public boolean canCreateLeagues(User user) {
        if (user == null || !user.isActive()) {
            return false;
        }
        return user.isAdmin();
    }

    /**
     * Checks if user can build roster in a league
     * @param user the user to check
     * @param isMember true if user is a league member
     * @return true if user can build roster
     */
    public boolean canBuildRoster(User user, boolean isMember) {
        if (user == null || !user.isActive()) {
            return false;
        }
        // Any role can build roster if they are a member
        return isMember;
    }

    /**
     * Validates that user has the required role, throws exception if not
     * @param user the user to check
     * @param requiredRole the minimum required role
     * @throws AccessDeniedException if user doesn't have the required role
     */
    public void requireRole(User user, Role requiredRole) {
        if (user == null || !user.isActive()) {
            throw new AccessDeniedException("User is not authenticated or inactive");
        }
        if (!RoleHierarchy.isAtLeast(user.getRole(), requiredRole)) {
            throw new AccessDeniedException(
                    String.format("Access denied. Required role: %s, User role: %s",
                            requiredRole, user.getRole()));
        }
    }

    /**
     * Validates that user has the required permission, throws exception if not
     * @param user the user to check
     * @param permission the required permission
     * @throws AccessDeniedException if user doesn't have the permission
     */
    public void requirePermission(User user, Permission permission) {
        if (!hasPermission(user, permission)) {
            throw new AccessDeniedException(
                    String.format("Access denied. Required permission: %s", permission));
        }
    }

    /**
     * Exception thrown when access is denied
     */
    public static class AccessDeniedException extends RuntimeException {
        public AccessDeniedException(String message) {
            super(message);
        }
    }
}
