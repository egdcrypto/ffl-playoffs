package com.ffl.playoffs.domain.model;

/**
 * Permission enum defining actions that can be performed in the system
 * Each permission is associated with a minimum required role level
 */
public enum Permission {
    // Player-level permissions
    VIEW_OWN_ROSTER(Role.PLAYER),
    BUILD_ROSTER(Role.PLAYER),
    VIEW_LEAGUE_STANDINGS(Role.PLAYER),
    VIEW_LEAGUE_SCORES(Role.PLAYER),

    // Admin-level permissions
    CREATE_LEAGUE(Role.ADMIN),
    MANAGE_OWN_LEAGUE(Role.ADMIN),
    CONFIGURE_LEAGUE(Role.ADMIN),
    INVITE_PLAYERS(Role.ADMIN),
    REMOVE_PLAYERS(Role.ADMIN),
    ACTIVATE_LEAGUE(Role.ADMIN),
    DEACTIVATE_LEAGUE(Role.ADMIN),

    // Super Admin-level permissions
    VIEW_ALL_LEAGUES(Role.SUPER_ADMIN),
    MANAGE_ALL_LEAGUES(Role.SUPER_ADMIN),
    MANAGE_ADMINS(Role.SUPER_ADMIN),
    GENERATE_PAT(Role.SUPER_ADMIN),
    AUDIT_SYSTEM(Role.SUPER_ADMIN),
    BOOTSTRAP_SUPER_ADMIN(Role.SUPER_ADMIN);

    private final Role minimumRole;

    Permission(Role minimumRole) {
        this.minimumRole = minimumRole;
    }

    public Role getMinimumRole() {
        return minimumRole;
    }

    /**
     * Checks if the given role has this permission
     * @param role the role to check
     * @return true if the role has this permission
     */
    public boolean isGrantedTo(Role role) {
        return RoleHierarchy.hasPermission(role, this);
    }
}
