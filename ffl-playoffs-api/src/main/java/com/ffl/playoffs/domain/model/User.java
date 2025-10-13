package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * User aggregate root
 * Represents a user in the system with role-based access
 */
public class User {
    private UUID id;
    private String email;
    private String name;
    private String googleId;  // Google OAuth ID
    private Role role;
    private LocalDateTime createdAt;
    private LocalDateTime lastLoginAt;
    private boolean active;

    public User() {
        this.id = UUID.randomUUID();
        this.createdAt = LocalDateTime.now();
        this.active = true;
    }

    public User(String email, String name, String googleId, Role role) {
        this();
        this.email = email;
        this.name = name;
        this.googleId = googleId;
        this.role = role;
    }

    // Business methods

    /**
     * Updates the last login timestamp
     */
    public void updateLastLogin() {
        this.lastLoginAt = LocalDateTime.now();
    }

    /**
     * Checks if user has the required role
     * @param requiredRole the required role
     * @return true if user has the role
     */
    public boolean hasRole(Role requiredRole) {
        if (this.role == Role.SUPER_ADMIN) {
            return true;  // Super admin has all permissions
        }
        if (this.role == Role.ADMIN && requiredRole != Role.SUPER_ADMIN) {
            return true;  // Admin can access ADMIN and PLAYER endpoints
        }
        return this.role == requiredRole;
    }

    /**
     * Checks if user is a super admin
     * @return true if user is super admin
     */
    public boolean isSuperAdmin() {
        return this.role == Role.SUPER_ADMIN;
    }

    /**
     * Checks if user is an admin (includes super admin)
     * @return true if user is admin or super admin
     */
    public boolean isAdmin() {
        return this.role == Role.ADMIN || this.role == Role.SUPER_ADMIN;
    }

    /**
     * Deactivates the user account
     */
    public void deactivate() {
        this.active = false;
    }

    /**
     * Activates the user account
     */
    public void activate() {
        this.active = true;
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getGoogleId() {
        return googleId;
    }

    public void setGoogleId(String googleId) {
        this.googleId = googleId;
    }

    public Role getRole() {
        return role;
    }

    public void setRole(Role role) {
        this.role = role;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getLastLoginAt() {
        return lastLoginAt;
    }

    public void setLastLoginAt(LocalDateTime lastLoginAt) {
        this.lastLoginAt = lastLoginAt;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }
}
