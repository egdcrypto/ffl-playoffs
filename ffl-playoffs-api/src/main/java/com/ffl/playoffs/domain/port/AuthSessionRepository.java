package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.AuthSession;
import com.ffl.playoffs.domain.model.auth.AuthenticationType;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Port interface for AuthSession persistence.
 * Domain defines the contract, infrastructure implements it.
 */
public interface AuthSessionRepository {

    /**
     * Save an auth session
     * @param session the session to save
     * @return the saved session
     */
    AuthSession save(AuthSession session);

    /**
     * Find a session by ID
     * @param id the session ID
     * @return Optional containing the session if found
     */
    Optional<AuthSession> findById(UUID id);

    /**
     * Find all active sessions for a principal
     * @param principalId the user or PAT ID
     * @return list of active sessions
     */
    List<AuthSession> findActiveByPrincipalId(UUID principalId);

    /**
     * Find all sessions for a principal
     * @param principalId the user or PAT ID
     * @return list of all sessions
     */
    List<AuthSession> findByPrincipalId(UUID principalId);

    /**
     * Find active sessions by authentication type
     * @param authenticationType the type of authentication
     * @return list of active sessions of that type
     */
    List<AuthSession> findActiveByType(AuthenticationType authenticationType);

    /**
     * Find expired sessions that are still marked as active
     * @return list of expired but active sessions
     */
    List<AuthSession> findExpiredActiveSessions();

    /**
     * Find sessions that have been idle for too long
     * @param idleThreshold the idle threshold time
     * @return list of idle sessions
     */
    List<AuthSession> findIdleSessions(LocalDateTime idleThreshold);

    /**
     * Count active sessions for a principal
     * @param principalId the user or PAT ID
     * @return count of active sessions
     */
    long countActiveByPrincipalId(UUID principalId);

    /**
     * Delete a session by ID
     * @param id the session ID to delete
     */
    void deleteById(UUID id);

    /**
     * Delete all sessions for a principal
     * @param principalId the user or PAT ID
     */
    void deleteByPrincipalId(UUID principalId);

    /**
     * Delete sessions older than a specified date
     * @param olderThan the cutoff date
     * @return number of sessions deleted
     */
    long deleteOlderThan(LocalDateTime olderThan);

    /**
     * Check if a session exists
     * @param id the session ID
     * @return true if exists
     */
    boolean existsById(UUID id);
}
