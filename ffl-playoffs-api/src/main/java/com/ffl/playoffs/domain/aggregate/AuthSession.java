package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.auth.AuthenticationType;

import java.time.LocalDateTime;
import java.util.Objects;
import java.util.UUID;

/**
 * Aggregate root for authentication sessions.
 * Tracks user login sessions for audit and security purposes.
 */
public class AuthSession {

    private UUID id;
    private UUID principalId;  // User ID or PAT ID
    private AuthenticationType authenticationType;
    private String identifier;  // Email or PAT name
    private String ipAddress;
    private String userAgent;
    private LocalDateTime createdAt;
    private LocalDateTime expiresAt;
    private LocalDateTime lastActivityAt;
    private boolean active;
    private String terminationReason;
    private LocalDateTime terminatedAt;

    public AuthSession() {
        this.id = UUID.randomUUID();
        this.createdAt = LocalDateTime.now();
        this.lastActivityAt = LocalDateTime.now();
        this.active = true;
    }

    public AuthSession(UUID principalId, AuthenticationType authenticationType, String identifier) {
        this();
        this.principalId = Objects.requireNonNull(principalId, "principalId cannot be null");
        this.authenticationType = Objects.requireNonNull(authenticationType, "authenticationType cannot be null");
        this.identifier = Objects.requireNonNull(identifier, "identifier cannot be null");
    }

    /**
     * Factory method to create a user session
     */
    public static AuthSession forUser(User user, String ipAddress, String userAgent) {
        AuthSession session = new AuthSession(user.getId(), AuthenticationType.GOOGLE_OAUTH, user.getEmail());
        session.setIpAddress(ipAddress);
        session.setUserAgent(userAgent);
        // Default session duration: 24 hours
        session.setExpiresAt(LocalDateTime.now().plusHours(24));
        return session;
    }

    /**
     * Factory method to create a PAT session
     */
    public static AuthSession forPAT(UUID patId, String patName, String ipAddress, String userAgent) {
        AuthSession session = new AuthSession(patId, AuthenticationType.PAT, patName);
        session.setIpAddress(ipAddress);
        session.setUserAgent(userAgent);
        // PAT sessions don't expire (controlled by PAT expiration)
        session.setExpiresAt(null);
        return session;
    }

    // Business methods

    /**
     * Update the last activity timestamp
     */
    public void updateActivity() {
        if (!active) {
            throw new IllegalStateException("Cannot update activity on inactive session");
        }
        this.lastActivityAt = LocalDateTime.now();
    }

    /**
     * Check if the session is valid (active and not expired)
     */
    public boolean isValid() {
        if (!active) {
            return false;
        }
        if (expiresAt != null && LocalDateTime.now().isAfter(expiresAt)) {
            return false;
        }
        return true;
    }

    /**
     * Check if the session is expired
     */
    public boolean isExpired() {
        return expiresAt != null && LocalDateTime.now().isAfter(expiresAt);
    }

    /**
     * Terminate the session
     */
    public void terminate(String reason) {
        if (!active) {
            throw new IllegalStateException("Session is already terminated");
        }
        this.active = false;
        this.terminationReason = reason;
        this.terminatedAt = LocalDateTime.now();
    }

    /**
     * Extend the session expiration
     */
    public void extend(int hours) {
        if (!active) {
            throw new IllegalStateException("Cannot extend inactive session");
        }
        if (expiresAt == null) {
            return; // PAT sessions don't expire
        }
        this.expiresAt = LocalDateTime.now().plusHours(hours);
        this.lastActivityAt = LocalDateTime.now();
    }

    /**
     * Check if session is idle (no activity for specified minutes)
     */
    public boolean isIdle(int idleMinutes) {
        return lastActivityAt != null &&
                LocalDateTime.now().minusMinutes(idleMinutes).isAfter(lastActivityAt);
    }

    /**
     * Get session duration in minutes
     */
    public long getDurationMinutes() {
        LocalDateTime endTime = terminatedAt != null ? terminatedAt : LocalDateTime.now();
        return java.time.Duration.between(createdAt, endTime).toMinutes();
    }

    // Getters and setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getPrincipalId() {
        return principalId;
    }

    public void setPrincipalId(UUID principalId) {
        this.principalId = principalId;
    }

    public AuthenticationType getAuthenticationType() {
        return authenticationType;
    }

    public void setAuthenticationType(AuthenticationType authenticationType) {
        this.authenticationType = authenticationType;
    }

    public String getIdentifier() {
        return identifier;
    }

    public void setIdentifier(String identifier) {
        this.identifier = identifier;
    }

    public String getIpAddress() {
        return ipAddress;
    }

    public void setIpAddress(String ipAddress) {
        this.ipAddress = ipAddress;
    }

    public String getUserAgent() {
        return userAgent;
    }

    public void setUserAgent(String userAgent) {
        this.userAgent = userAgent;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getExpiresAt() {
        return expiresAt;
    }

    public void setExpiresAt(LocalDateTime expiresAt) {
        this.expiresAt = expiresAt;
    }

    public LocalDateTime getLastActivityAt() {
        return lastActivityAt;
    }

    public void setLastActivityAt(LocalDateTime lastActivityAt) {
        this.lastActivityAt = lastActivityAt;
    }

    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public String getTerminationReason() {
        return terminationReason;
    }

    public void setTerminationReason(String terminationReason) {
        this.terminationReason = terminationReason;
    }

    public LocalDateTime getTerminatedAt() {
        return terminatedAt;
    }

    public void setTerminatedAt(LocalDateTime terminatedAt) {
        this.terminatedAt = terminatedAt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AuthSession that = (AuthSession) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }

    @Override
    public String toString() {
        return "AuthSession{" +
                "id=" + id +
                ", principalId=" + principalId +
                ", type=" + authenticationType +
                ", identifier='" + identifier + '\'' +
                ", active=" + active +
                '}';
    }
}
