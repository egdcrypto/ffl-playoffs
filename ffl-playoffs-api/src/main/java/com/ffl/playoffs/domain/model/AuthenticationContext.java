package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Value object representing the authenticated principal context.
 * Contains either user context (from Google OAuth) or PAT context (from service token).
 * This context is passed to the API after Envoy authentication.
 */
public class AuthenticationContext {

    private final AuthenticationType type;

    // For USER authentication
    private final UUID userId;
    private final String email;
    private final Role role;
    private final String googleId;

    // For PAT authentication
    private final UUID patId;
    private final String serviceName;
    private final PATScope scope;

    // Common
    private final LocalDateTime authenticatedAt;

    private AuthenticationContext(AuthenticationType type, UUID userId, String email, Role role,
                                   String googleId, UUID patId, String serviceName, PATScope scope) {
        this.type = type;
        this.userId = userId;
        this.email = email;
        this.role = role;
        this.googleId = googleId;
        this.patId = patId;
        this.serviceName = serviceName;
        this.scope = scope;
        this.authenticatedAt = LocalDateTime.now();
    }

    /**
     * Creates a user authentication context from Google OAuth
     */
    public static AuthenticationContext forUser(UUID userId, String email, Role role, String googleId) {
        return new AuthenticationContext(AuthenticationType.USER, userId, email, role, googleId,
                null, null, null);
    }

    /**
     * Creates a PAT authentication context for a service
     */
    public static AuthenticationContext forPAT(UUID patId, String serviceName, PATScope scope) {
        return new AuthenticationContext(AuthenticationType.PAT, null, null, null, null,
                patId, serviceName, scope);
    }

    /**
     * Checks if this context has permission to access an endpoint with the given required permission
     */
    public boolean canAccess(RequiredPermission permission) {
        if (permission.isPublic()) {
            return true;
        }

        if (isUser()) {
            return permission.allowsRole(this.role);
        } else if (isPAT()) {
            return permission.allowsScope(this.scope);
        }

        return false;
    }

    /**
     * Checks if this is a user authentication (Google OAuth)
     */
    public boolean isUser() {
        return type == AuthenticationType.USER;
    }

    /**
     * Checks if this is a PAT authentication (service)
     */
    public boolean isPAT() {
        return type == AuthenticationType.PAT;
    }

    /**
     * Checks if this user is a super admin
     */
    public boolean isSuperAdmin() {
        return isUser() && role == Role.SUPER_ADMIN;
    }

    /**
     * Checks if this user is an admin (includes super admin)
     */
    public boolean isAdmin() {
        return isUser() && (role == Role.ADMIN || role == Role.SUPER_ADMIN);
    }

    // Getters

    public AuthenticationType getType() {
        return type;
    }

    public UUID getUserId() {
        return userId;
    }

    public String getEmail() {
        return email;
    }

    public Role getRole() {
        return role;
    }

    public String getGoogleId() {
        return googleId;
    }

    public UUID getPatId() {
        return patId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public PATScope getScope() {
        return scope;
    }

    public LocalDateTime getAuthenticatedAt() {
        return authenticatedAt;
    }
}
