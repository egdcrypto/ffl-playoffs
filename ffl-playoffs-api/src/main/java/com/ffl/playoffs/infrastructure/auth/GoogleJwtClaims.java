package com.ffl.playoffs.infrastructure.auth;

/**
 * Represents claims extracted from a Google JWT token
 */
public class GoogleJwtClaims {
    private final String googleId;
    private final String email;
    private final String name;

    public GoogleJwtClaims(String googleId, String email, String name) {
        this.googleId = googleId;
        this.email = email;
        this.name = name;
    }

    public String getGoogleId() {
        return googleId;
    }

    public String getEmail() {
        return email;
    }

    public String getName() {
        return name;
    }
}
