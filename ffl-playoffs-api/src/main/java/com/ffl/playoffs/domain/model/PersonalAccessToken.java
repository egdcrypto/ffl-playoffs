package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * PersonalAccessToken entity - represents an API access token for authentication
 * Domain model with no framework dependencies
 */
public class PersonalAccessToken {
    private UUID id;
    private String name;
    private String tokenIdentifier;  // Unique identifier part of token (for lookup)
    private String tokenHash;  // BCrypt hashed full token
    private PATScope scope;
    private LocalDateTime expiresAt;
    private UUID createdBy;  // User ID who created this token
    private LocalDateTime createdAt;
    private LocalDateTime lastUsedAt;
    private boolean revoked;

    public PersonalAccessToken() {
        this.id = UUID.randomUUID();
        this.createdAt = LocalDateTime.now();
        this.revoked = false;
    }

    public PersonalAccessToken(String name, String tokenIdentifier, String tokenHash, PATScope scope, LocalDateTime expiresAt, UUID createdBy) {
        this();
        this.name = name;
        this.tokenIdentifier = tokenIdentifier;
        this.tokenHash = tokenHash;
        this.scope = scope;
        this.expiresAt = expiresAt;
        this.createdBy = createdBy;
    }

    // Business methods

    /**
     * Validates if the token is currently valid
     * @return true if token is valid, false otherwise
     */
    public boolean isValid() {
        if (revoked) {
            return false;
        }
        if (expiresAt != null && LocalDateTime.now().isAfter(expiresAt)) {
            return false;
        }
        return true;
    }

    /**
     * Validates if the token has the required scope
     * @param requiredScope the minimum required scope
     * @return true if token has sufficient scope
     */
    public boolean hasScope(PATScope requiredScope) {
        if (scope == PATScope.ADMIN) {
            return true;  // Admin has all permissions
        }
        if (scope == PATScope.WRITE && requiredScope != PATScope.ADMIN) {
            return true;  // Write can do READ_ONLY and WRITE
        }
        return scope == requiredScope;
    }

    /**
     * Revokes this token
     */
    public void revoke() {
        if (this.revoked) {
            throw new IllegalStateException("Token is already revoked");
        }
        this.revoked = true;
    }

    /**
     * Updates the last used timestamp
     */
    public void updateLastUsed() {
        this.lastUsedAt = LocalDateTime.now();
    }

    /**
     * Checks if token is expired
     * @return true if expired, false otherwise
     */
    public boolean isExpired() {
        return expiresAt != null && LocalDateTime.now().isAfter(expiresAt);
    }

    /**
     * Validates token and throws exception if invalid
     * @throws InvalidTokenException if token is invalid
     */
    public void validateOrThrow() throws InvalidTokenException {
        if (revoked) {
            throw new InvalidTokenException("Token has been revoked");
        }
        if (isExpired()) {
            throw new InvalidTokenException("Token has expired");
        }
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getTokenIdentifier() {
        return tokenIdentifier;
    }

    public void setTokenIdentifier(String tokenIdentifier) {
        this.tokenIdentifier = tokenIdentifier;
    }

    public String getTokenHash() {
        return tokenHash;
    }

    public void setTokenHash(String tokenHash) {
        this.tokenHash = tokenHash;
    }

    public PATScope getScope() {
        return scope;
    }

    public void setScope(PATScope scope) {
        this.scope = scope;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public UUID getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(UUID createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getLastUsedAt() {
        return lastUsedAt;
    }

    public void setLastUsedAt(LocalDateTime lastUsedAt) {
        this.lastUsedAt = lastUsedAt;
    }

    public boolean isRevoked() {
        return revoked;
    }

    public void setRevoked(boolean revoked) {
        this.revoked = revoked;
    }

    /**
     * Exception thrown when a token is invalid
     */
    public static class InvalidTokenException extends Exception {
        public InvalidTokenException(String message) {
            super(message);
        }
    }
}
