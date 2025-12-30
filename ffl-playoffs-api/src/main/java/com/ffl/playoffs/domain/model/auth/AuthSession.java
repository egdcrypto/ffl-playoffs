package com.ffl.playoffs.domain.model.auth;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;

/**
 * Authentication session entity
 * Represents an active authentication session for a user
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class AuthSession {

    private static final int DEFAULT_SESSION_DURATION_HOURS = 24;
    private static final int DEFAULT_REFRESH_DURATION_HOURS = 168; // 7 days

    private UUID id;
    private UUID userId;
    private String sessionToken;
    private String refreshToken;
    private AuthType authType;
    private SessionStatus status;
    private Set<Permission> permissions;

    // Timestamps
    private Instant createdAt;
    private Instant expiresAt;
    private Instant refreshExpiresAt;
    private Instant lastActivityAt;
    private Instant invalidatedAt;

    // Session metadata
    private String ipAddress;
    private String userAgent;
    private String deviceId;

    // Linked identifiers
    private String googleId;      // For Google OAuth sessions
    private UUID patId;           // For PAT-based sessions

    /**
     * Create a new session for Google OAuth authentication
     * @param userId the authenticated user's ID
     * @param googleId the Google ID
     * @param permissions the user's permissions
     * @param ipAddress client IP address
     * @param userAgent client user agent
     * @return new AuthSession
     */
    public static AuthSession createGoogleSession(UUID userId, String googleId,
                                                   Set<Permission> permissions,
                                                   String ipAddress, String userAgent) {
        Objects.requireNonNull(userId, "User ID cannot be null");
        Objects.requireNonNull(googleId, "Google ID cannot be null");

        Instant now = Instant.now();

        return AuthSession.builder()
                .id(UUID.randomUUID())
                .userId(userId)
                .sessionToken(generateToken())
                .refreshToken(generateToken())
                .authType(AuthType.GOOGLE_OAUTH)
                .status(SessionStatus.ACTIVE)
                .permissions(permissions)
                .createdAt(now)
                .expiresAt(now.plus(DEFAULT_SESSION_DURATION_HOURS, ChronoUnit.HOURS))
                .refreshExpiresAt(now.plus(DEFAULT_REFRESH_DURATION_HOURS, ChronoUnit.HOURS))
                .lastActivityAt(now)
                .ipAddress(ipAddress)
                .userAgent(userAgent)
                .googleId(googleId)
                .build();
    }

    /**
     * Create a new session for PAT authentication
     * @param patId the PAT ID
     * @param permissions the PAT's permissions
     * @param ipAddress client IP address
     * @param userAgent client user agent
     * @return new AuthSession
     */
    public static AuthSession createPATSession(UUID patId, Set<Permission> permissions,
                                                String ipAddress, String userAgent) {
        Objects.requireNonNull(patId, "PAT ID cannot be null");

        Instant now = Instant.now();

        return AuthSession.builder()
                .id(UUID.randomUUID())
                .sessionToken(generateToken())
                .authType(AuthType.PAT)
                .status(SessionStatus.ACTIVE)
                .permissions(permissions)
                .createdAt(now)
                .expiresAt(now.plus(DEFAULT_SESSION_DURATION_HOURS, ChronoUnit.HOURS))
                .lastActivityAt(now)
                .ipAddress(ipAddress)
                .userAgent(userAgent)
                .patId(patId)
                .build();
    }

    /**
     * Check if session is valid and not expired
     * @return true if session is valid
     */
    public boolean isValid() {
        if (status != SessionStatus.ACTIVE) {
            return false;
        }
        return !isExpired();
    }

    /**
     * Check if session has expired
     * @return true if session is expired
     */
    public boolean isExpired() {
        return expiresAt != null && Instant.now().isAfter(expiresAt);
    }

    /**
     * Check if refresh token has expired
     * @return true if refresh token is expired
     */
    public boolean isRefreshExpired() {
        return refreshExpiresAt == null || Instant.now().isAfter(refreshExpiresAt);
    }

    /**
     * Update the session's last activity timestamp
     */
    public void updateLastActivity() {
        this.lastActivityAt = Instant.now();
    }

    /**
     * Invalidate the session (user logout)
     */
    public void invalidate() {
        if (!status.canInvalidate()) {
            throw new IllegalStateException("Cannot invalidate session in status: " + status);
        }
        this.status = SessionStatus.INVALIDATED;
        this.invalidatedAt = Instant.now();
    }

    /**
     * Revoke the session (admin action)
     */
    public void revoke() {
        if (!status.canRevoke()) {
            throw new IllegalStateException("Cannot revoke session in status: " + status);
        }
        this.status = SessionStatus.REVOKED;
        this.invalidatedAt = Instant.now();
    }

    /**
     * Mark session as expired
     */
    public void markExpired() {
        if (status == SessionStatus.ACTIVE) {
            this.status = SessionStatus.EXPIRED;
        }
    }

    /**
     * Refresh the session with new tokens
     * @return new session token
     */
    public String refresh() {
        if (!status.canRefresh()) {
            throw new IllegalStateException("Cannot refresh session in status: " + status);
        }
        if (isRefreshExpired()) {
            throw new IllegalStateException("Refresh token has expired");
        }

        Instant now = Instant.now();
        this.sessionToken = generateToken();
        this.expiresAt = now.plus(DEFAULT_SESSION_DURATION_HOURS, ChronoUnit.HOURS);
        this.lastActivityAt = now;

        return this.sessionToken;
    }

    /**
     * Check if session has a specific permission
     * @param permission the permission to check
     * @return true if session has the permission
     */
    public boolean hasPermission(Permission permission) {
        return permissions != null && permissions.contains(permission);
    }

    /**
     * Check if session has all specified permissions
     * @param requiredPermissions the permissions to check
     * @return true if session has all permissions
     */
    public boolean hasAllPermissions(Set<Permission> requiredPermissions) {
        return permissions != null && permissions.containsAll(requiredPermissions);
    }

    /**
     * Check if session has any of the specified permissions
     * @param requiredPermissions the permissions to check
     * @return true if session has at least one permission
     */
    public boolean hasAnyPermission(Set<Permission> requiredPermissions) {
        if (permissions == null || requiredPermissions == null) {
            return false;
        }
        for (Permission p : requiredPermissions) {
            if (permissions.contains(p)) {
                return true;
            }
        }
        return false;
    }

    /**
     * Get remaining session time in seconds
     * @return remaining seconds, 0 if expired
     */
    public long getRemainingSeconds() {
        if (expiresAt == null || isExpired()) {
            return 0;
        }
        return ChronoUnit.SECONDS.between(Instant.now(), expiresAt);
    }

    /**
     * Check if this is a user session (Google OAuth)
     * @return true if user session
     */
    public boolean isUserSession() {
        return authType == AuthType.GOOGLE_OAUTH;
    }

    /**
     * Check if this is a PAT session
     * @return true if PAT session
     */
    public boolean isPATSession() {
        return authType == AuthType.PAT;
    }

    /**
     * Validate session token
     * @param token the token to validate
     * @return true if token matches
     */
    public boolean validateToken(String token) {
        return sessionToken != null && sessionToken.equals(token);
    }

    /**
     * Validate refresh token
     * @param token the token to validate
     * @return true if token matches
     */
    public boolean validateRefreshToken(String token) {
        return refreshToken != null && refreshToken.equals(token);
    }

    /**
     * Generate a secure random token
     * @return the generated token
     */
    private static String generateToken() {
        return UUID.randomUUID().toString().replace("-", "") +
               UUID.randomUUID().toString().replace("-", "");
    }

    /**
     * Authentication types
     */
    public enum AuthType {
        GOOGLE_OAUTH("google_oauth", "Google OAuth"),
        PAT("pat", "Personal Access Token");

        private final String code;
        private final String displayName;

        AuthType(String code, String displayName) {
            this.code = code;
            this.displayName = displayName;
        }

        public String getCode() {
            return code;
        }

        public String getDisplayName() {
            return displayName;
        }

        public static AuthType fromCode(String code) {
            for (AuthType type : values()) {
                if (type.code.equalsIgnoreCase(code)) {
                    return type;
                }
            }
            throw new IllegalArgumentException("Unknown auth type code: " + code);
        }
    }
}
