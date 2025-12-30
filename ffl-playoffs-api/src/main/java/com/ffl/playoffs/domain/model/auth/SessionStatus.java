package com.ffl.playoffs.domain.model.auth;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.Arrays;

/**
 * Authentication session status enumeration
 * Defines the lifecycle states of an auth session
 */
@Getter
@RequiredArgsConstructor
public enum SessionStatus {

    /**
     * Session is active and valid
     */
    ACTIVE("active", "Active", "Session is active and valid"),

    /**
     * Session has expired due to timeout
     */
    EXPIRED("expired", "Expired", "Session has expired"),

    /**
     * Session was explicitly invalidated (logout)
     */
    INVALIDATED("invalidated", "Invalidated", "Session was invalidated by user"),

    /**
     * Session was revoked by an administrator
     */
    REVOKED("revoked", "Revoked", "Session was revoked by administrator"),

    /**
     * Session was refreshed and replaced by a new session
     */
    REFRESHED("refreshed", "Refreshed", "Session was refreshed with new token");

    private final String code;
    private final String displayName;
    private final String description;

    /**
     * Find status by code
     * @param code the status code
     * @return the SessionStatus
     * @throws IllegalArgumentException if code not found
     */
    public static SessionStatus fromCode(String code) {
        return Arrays.stream(values())
                .filter(s -> s.getCode().equalsIgnoreCase(code))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Unknown session status code: " + code));
    }

    /**
     * Check if session is still active
     * @return true if session is active
     */
    public boolean isActive() {
        return this == ACTIVE;
    }

    /**
     * Check if session is in a terminal state
     * @return true if session cannot be reactivated
     */
    public boolean isTerminal() {
        return this == EXPIRED || this == INVALIDATED || this == REVOKED || this == REFRESHED;
    }

    /**
     * Check if session can be refreshed
     * Only active sessions can be refreshed
     * @return true if session can be refreshed
     */
    public boolean canRefresh() {
        return this == ACTIVE;
    }

    /**
     * Check if session can be invalidated
     * Only active sessions can be invalidated
     * @return true if session can be invalidated
     */
    public boolean canInvalidate() {
        return this == ACTIVE;
    }

    /**
     * Check if session can be revoked
     * Active sessions can be revoked by admins
     * @return true if session can be revoked
     */
    public boolean canRevoke() {
        return this == ACTIVE;
    }
}
