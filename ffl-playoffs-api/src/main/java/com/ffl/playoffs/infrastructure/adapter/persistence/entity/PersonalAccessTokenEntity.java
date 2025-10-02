package com.ffl.playoffs.infrastructure.adapter.persistence.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * JPA entity for PersonalAccessToken
 * Infrastructure layer persistence model
 */
@Entity
@Table(name = "personal_access_tokens", indexes = {
    @Index(name = "idx_pat_name", columnList = "name", unique = true),
    @Index(name = "idx_pat_token_identifier", columnList = "token_identifier", unique = true)
})
public class PersonalAccessTokenEntity {

    @Id
    @Column(name = "id", length = 36)
    private String id;

    @Column(name = "name", nullable = false, unique = true)
    private String name;

    @Column(name = "token_identifier", nullable = false, unique = true)
    private String tokenIdentifier;

    @Column(name = "token_hash", nullable = false)
    private String tokenHash;

    @Column(name = "scope")
    private String scope;  // ADMIN, WRITE, READ_ONLY

    @Column(name = "expires_at")
    private LocalDateTime expiresAt;

    @Column(name = "created_by")
    private String createdBy;  // User ID

    @Column(name = "created_at")
    private LocalDateTime createdAt;

    @Column(name = "last_used_at")
    private LocalDateTime lastUsedAt;

    @Column(name = "revoked")
    private boolean revoked;

    public PersonalAccessTokenEntity() {
    }

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
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

    public String getScope() {
        return scope;
    }

    public void setScope(String scope) {
        this.scope = scope;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
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
}
