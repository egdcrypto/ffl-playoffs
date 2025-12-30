package com.ffl.playoffs.domain.model.auth;

import com.ffl.playoffs.domain.model.Role;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.Arrays;
import java.util.EnumSet;
import java.util.Set;

/**
 * Fine-grained permission enumeration for authorization
 * Maps to roles and provides granular access control
 */
@Getter
@RequiredArgsConstructor
public enum Permission {

    // ===================
    // User Management Permissions
    // ===================
    VIEW_USERS("view_users", "View Users", "Can view user information", PermissionCategory.USER_MANAGEMENT),
    CREATE_USERS("create_users", "Create Users", "Can create new users", PermissionCategory.USER_MANAGEMENT),
    UPDATE_USERS("update_users", "Update Users", "Can update user information", PermissionCategory.USER_MANAGEMENT),
    DELETE_USERS("delete_users", "Delete Users", "Can delete users", PermissionCategory.USER_MANAGEMENT),
    ASSIGN_ROLES("assign_roles", "Assign Roles", "Can assign roles to users", PermissionCategory.USER_MANAGEMENT),

    // ===================
    // Admin Permissions
    // ===================
    INVITE_ADMINS("invite_admins", "Invite Admins", "Can invite new administrators", PermissionCategory.ADMIN),
    REVOKE_ADMIN_ACCESS("revoke_admin_access", "Revoke Admin Access", "Can revoke admin access", PermissionCategory.ADMIN),
    VIEW_ADMIN_INVITATIONS("view_admin_invitations", "View Admin Invitations", "Can view admin invitations", PermissionCategory.ADMIN),

    // ===================
    // PAT Management Permissions
    // ===================
    CREATE_PAT("create_pat", "Create PAT", "Can create personal access tokens", PermissionCategory.PAT_MANAGEMENT),
    VIEW_PATS("view_pats", "View PATs", "Can view personal access tokens", PermissionCategory.PAT_MANAGEMENT),
    REVOKE_PAT("revoke_pat", "Revoke PAT", "Can revoke personal access tokens", PermissionCategory.PAT_MANAGEMENT),
    CREATE_BOOTSTRAP_PAT("create_bootstrap_pat", "Create Bootstrap PAT", "Can create bootstrap PATs", PermissionCategory.PAT_MANAGEMENT),

    // ===================
    // League Management Permissions
    // ===================
    CREATE_LEAGUE("create_league", "Create League", "Can create new leagues", PermissionCategory.LEAGUE_MANAGEMENT),
    VIEW_LEAGUES("view_leagues", "View Leagues", "Can view leagues", PermissionCategory.LEAGUE_MANAGEMENT),
    UPDATE_LEAGUE("update_league", "Update League", "Can update league settings", PermissionCategory.LEAGUE_MANAGEMENT),
    DELETE_LEAGUE("delete_league", "Delete League", "Can delete leagues", PermissionCategory.LEAGUE_MANAGEMENT),
    CONFIGURE_LEAGUE("configure_league", "Configure League", "Can configure league settings", PermissionCategory.LEAGUE_MANAGEMENT),
    INVITE_PLAYERS("invite_players", "Invite Players", "Can invite players to leagues", PermissionCategory.LEAGUE_MANAGEMENT),

    // ===================
    // Player Permissions
    // ===================
    VIEW_ROSTER("view_roster", "View Roster", "Can view rosters", PermissionCategory.PLAYER),
    BUILD_ROSTER("build_roster", "Build Roster", "Can build and modify rosters", PermissionCategory.PLAYER),
    VIEW_STANDINGS("view_standings", "View Standings", "Can view league standings", PermissionCategory.PLAYER),
    VIEW_SCORES("view_scores", "View Scores", "Can view scores", PermissionCategory.PLAYER),

    // ===================
    // System Permissions
    // ===================
    VIEW_SYSTEM_CONFIG("view_system_config", "View System Config", "Can view system configuration", PermissionCategory.SYSTEM),
    UPDATE_SYSTEM_CONFIG("update_system_config", "Update System Config", "Can update system configuration", PermissionCategory.SYSTEM),
    SYNC_NFL_DATA("sync_nfl_data", "Sync NFL Data", "Can trigger NFL data synchronization", PermissionCategory.SYSTEM),
    VIEW_AUDIT_LOGS("view_audit_logs", "View Audit Logs", "Can view audit logs", PermissionCategory.SYSTEM);

    private final String code;
    private final String displayName;
    private final String description;
    private final PermissionCategory category;

    /**
     * Find permission by code
     * @param code the permission code
     * @return the Permission
     * @throws IllegalArgumentException if code not found
     */
    public static Permission fromCode(String code) {
        return Arrays.stream(values())
                .filter(p -> p.getCode().equalsIgnoreCase(code))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Unknown permission code: " + code));
    }

    /**
     * Get all permissions for a given category
     * @param category the permission category
     * @return set of permissions
     */
    public static Set<Permission> getByCategory(PermissionCategory category) {
        EnumSet<Permission> permissions = EnumSet.noneOf(Permission.class);
        for (Permission p : values()) {
            if (p.getCategory() == category) {
                permissions.add(p);
            }
        }
        return permissions;
    }

    /**
     * Get default permissions for a role
     * @param role the user role
     * @return set of permissions granted to this role
     */
    public static Set<Permission> getDefaultPermissionsForRole(Role role) {
        EnumSet<Permission> permissions = EnumSet.noneOf(Permission.class);

        switch (role) {
            case SUPER_ADMIN:
                // Super admin has all permissions
                permissions.addAll(EnumSet.allOf(Permission.class));
                break;

            case ADMIN:
                // Admin has league management, player management, and some user permissions
                permissions.addAll(getByCategory(PermissionCategory.LEAGUE_MANAGEMENT));
                permissions.addAll(getByCategory(PermissionCategory.PLAYER));
                permissions.add(VIEW_USERS);
                permissions.add(CREATE_PAT);
                permissions.add(VIEW_PATS);
                permissions.add(REVOKE_PAT);
                break;

            case PLAYER:
                // Player has basic player permissions
                permissions.addAll(getByCategory(PermissionCategory.PLAYER));
                break;
        }

        return permissions;
    }

    /**
     * Check if this permission is a system-level permission
     * @return true if system permission
     */
    public boolean isSystemPermission() {
        return category == PermissionCategory.SYSTEM;
    }

    /**
     * Check if this permission is an admin-only permission
     * @return true if admin-only
     */
    public boolean isAdminOnly() {
        return category == PermissionCategory.ADMIN ||
               category == PermissionCategory.USER_MANAGEMENT ||
               category == PermissionCategory.SYSTEM;
    }

    /**
     * Permission categories for grouping
     */
    public enum PermissionCategory {
        USER_MANAGEMENT("User Management"),
        ADMIN("Administration"),
        PAT_MANAGEMENT("PAT Management"),
        LEAGUE_MANAGEMENT("League Management"),
        PLAYER("Player"),
        SYSTEM("System");

        private final String displayName;

        PermissionCategory(String displayName) {
            this.displayName = displayName;
        }

        public String getDisplayName() {
            return displayName;
        }
    }
}
