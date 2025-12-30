package com.ffl.playoffs.domain.model;

/**
 * Value object representing permission requirements for an endpoint.
 * Defines minimum role for users and minimum scope for PATs.
 */
public class RequiredPermission {

    private final Role minimumRole;
    private final PATScope minimumScope;
    private final boolean publicAccess;

    private RequiredPermission(Role minimumRole, PATScope minimumScope, boolean publicAccess) {
        this.minimumRole = minimumRole;
        this.minimumScope = minimumScope;
        this.publicAccess = publicAccess;
    }

    /**
     * Super admin endpoints - requires SUPER_ADMIN role or ADMIN scope
     */
    public static RequiredPermission superAdmin() {
        return new RequiredPermission(Role.SUPER_ADMIN, PATScope.ADMIN, false);
    }

    /**
     * Admin endpoints - requires ADMIN+ role or WRITE+ scope
     */
    public static RequiredPermission admin() {
        return new RequiredPermission(Role.ADMIN, PATScope.WRITE, false);
    }

    /**
     * Player endpoints - requires PLAYER+ role or READ_ONLY+ scope
     */
    public static RequiredPermission player() {
        return new RequiredPermission(Role.PLAYER, PATScope.READ_ONLY, false);
    }

    /**
     * Public endpoints - no authentication required
     */
    public static RequiredPermission publicAccess() {
        return new RequiredPermission(null, null, true);
    }

    /**
     * Custom permission with specific role and scope requirements
     */
    public static RequiredPermission custom(Role minimumRole, PATScope minimumScope) {
        return new RequiredPermission(minimumRole, minimumScope, false);
    }

    /**
     * Checks if this endpoint is public (no auth required)
     */
    public boolean isPublic() {
        return publicAccess;
    }

    /**
     * Checks if the given role meets the minimum requirement
     */
    public boolean allowsRole(Role role) {
        if (publicAccess || minimumRole == null) {
            return true;
        }
        return hasRoleAtLeast(role, minimumRole);
    }

    /**
     * Checks if the given scope meets the minimum requirement
     */
    public boolean allowsScope(PATScope scope) {
        if (publicAccess || minimumScope == null) {
            return true;
        }
        return hasScopeAtLeast(scope, minimumScope);
    }

    /**
     * Role hierarchy: SUPER_ADMIN > ADMIN > PLAYER
     */
    private boolean hasRoleAtLeast(Role actual, Role required) {
        if (actual == null) return false;

        return switch (required) {
            case PLAYER -> true; // Any role can access player endpoints
            case ADMIN -> actual == Role.ADMIN || actual == Role.SUPER_ADMIN;
            case SUPER_ADMIN -> actual == Role.SUPER_ADMIN;
        };
    }

    /**
     * Scope hierarchy: ADMIN > WRITE > READ_ONLY
     */
    private boolean hasScopeAtLeast(PATScope actual, PATScope required) {
        if (actual == null) return false;

        return switch (required) {
            case READ_ONLY -> true; // Any scope can access read-only endpoints
            case WRITE -> actual == PATScope.WRITE || actual == PATScope.ADMIN;
            case ADMIN -> actual == PATScope.ADMIN;
        };
    }

    public Role getMinimumRole() {
        return minimumRole;
    }

    public PATScope getMinimumScope() {
        return minimumScope;
    }
}
