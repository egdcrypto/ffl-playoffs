package com.ffl.playoffs.domain.model.auth;

import java.util.Objects;

/**
 * Value object representing an authentication token.
 * Immutable and encapsulates token data.
 */
public final class AuthToken {

    private static final String BEARER_PREFIX = "Bearer ";
    private static final String PAT_PREFIX = "pat_";

    private final String rawToken;
    private final AuthenticationType type;

    private AuthToken(String rawToken, AuthenticationType type) {
        this.rawToken = Objects.requireNonNull(rawToken, "Token cannot be null");
        this.type = Objects.requireNonNull(type, "Type cannot be null");
    }

    /**
     * Create an AuthToken from a raw token string.
     * Automatically detects the token type based on prefix.
     */
    public static AuthToken of(String token) {
        if (token == null || token.isBlank()) {
            throw new IllegalArgumentException("Token cannot be null or blank");
        }

        String rawToken = token.trim();

        // Remove Bearer prefix if present
        if (rawToken.startsWith(BEARER_PREFIX)) {
            rawToken = rawToken.substring(BEARER_PREFIX.length()).trim();
        }

        if (rawToken.isEmpty()) {
            throw new IllegalArgumentException("Token cannot be empty after processing");
        }

        // Detect token type
        AuthenticationType type = rawToken.startsWith(PAT_PREFIX)
                ? AuthenticationType.PAT
                : AuthenticationType.GOOGLE_OAUTH;

        return new AuthToken(rawToken, type);
    }

    /**
     * Create a PAT token explicitly
     */
    public static AuthToken pat(String token) {
        if (token == null || !token.startsWith(PAT_PREFIX)) {
            throw new IllegalArgumentException("PAT token must start with 'pat_' prefix");
        }
        return new AuthToken(token, AuthenticationType.PAT);
    }

    /**
     * Create a Google OAuth JWT token explicitly
     */
    public static AuthToken googleJwt(String token) {
        if (token == null || token.isBlank()) {
            throw new IllegalArgumentException("JWT token cannot be null or blank");
        }
        return new AuthToken(token, AuthenticationType.GOOGLE_OAUTH);
    }

    public String getRawToken() {
        return rawToken;
    }

    public AuthenticationType getType() {
        return type;
    }

    public boolean isPAT() {
        return type == AuthenticationType.PAT;
    }

    public boolean isGoogleOAuth() {
        return type == AuthenticationType.GOOGLE_OAUTH;
    }

    /**
     * Get a masked version of the token for logging
     */
    public String getMaskedToken() {
        if (rawToken.length() <= 8) {
            return "***";
        }
        return rawToken.substring(0, 4) + "..." + rawToken.substring(rawToken.length() - 4);
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AuthToken authToken = (AuthToken) o;
        return Objects.equals(rawToken, authToken.rawToken) && type == authToken.type;
    }

    @Override
    public int hashCode() {
        return Objects.hash(rawToken, type);
    }

    @Override
    public String toString() {
        return "AuthToken{type=" + type + ", token=" + getMaskedToken() + "}";
    }
}
