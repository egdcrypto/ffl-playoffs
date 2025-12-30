package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.AuthSession;
import com.ffl.playoffs.domain.model.auth.AuthenticationType;
import com.ffl.playoffs.domain.port.AuthSessionRepository;

import java.util.List;
import java.util.Objects;
import java.util.UUID;

/**
 * Use case for retrieving active authentication sessions.
 * Useful for security dashboards and session management.
 */
public class GetActiveSessionsUseCase {

    private final AuthSessionRepository authSessionRepository;

    public GetActiveSessionsUseCase(AuthSessionRepository authSessionRepository) {
        this.authSessionRepository = authSessionRepository;
    }

    /**
     * Get all active sessions for a user
     */
    public List<AuthSession> getSessionsForUser(UUID userId) {
        Objects.requireNonNull(userId, "userId cannot be null");
        return authSessionRepository.findActiveByPrincipalId(userId);
    }

    /**
     * Get all active sessions by authentication type
     */
    public List<AuthSession> getSessionsByType(AuthenticationType type) {
        Objects.requireNonNull(type, "type cannot be null");
        return authSessionRepository.findActiveByType(type);
    }

    /**
     * Get session count for a user
     */
    public long getSessionCount(UUID userId) {
        Objects.requireNonNull(userId, "userId cannot be null");
        return authSessionRepository.countActiveByPrincipalId(userId);
    }

    /**
     * Get all session history for a user (including terminated)
     */
    public List<AuthSession> getSessionHistory(UUID userId) {
        Objects.requireNonNull(userId, "userId cannot be null");
        return authSessionRepository.findByPrincipalId(userId);
    }
}
