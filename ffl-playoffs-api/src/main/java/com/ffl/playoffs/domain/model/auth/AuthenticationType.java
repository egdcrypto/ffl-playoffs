package com.ffl.playoffs.domain.model.auth;

/**
 * Enum representing the type of authentication used.
 */
public enum AuthenticationType {

    /**
     * Authentication via Google OAuth JWT token
     */
    GOOGLE_OAUTH("google_oauth", "Google OAuth"),

    /**
     * Authentication via Personal Access Token
     */
    PAT("pat", "Personal Access Token"),

    /**
     * Anonymous/unauthenticated access (for public endpoints)
     */
    ANONYMOUS("anonymous", "Anonymous");

    private final String code;
    private final String displayName;

    AuthenticationType(String code, String displayName) {
        this.code = code;
        this.displayName = displayName;
    }

    public String getCode() {
        return code;
    }

    public String getDisplayName() {
        return displayName;
    }

    /**
     * Check if this is a valid authenticated type
     */
    public boolean isAuthenticated() {
        return this != ANONYMOUS;
    }

    /**
     * Get AuthenticationType from code
     */
    public static AuthenticationType fromCode(String code) {
        for (AuthenticationType type : values()) {
            if (type.code.equalsIgnoreCase(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown authentication type code: " + code);
    }
}
