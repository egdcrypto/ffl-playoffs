package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.auth.AuthSession;
import com.ffl.playoffs.domain.model.auth.SessionStatus;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for AuthSession
 * Port in hexagonal architecture
 */
public interface AuthSessionRepository {

    /**
     * Find session by ID
     * @param id the session ID
     * @return Optional containing the session if found
     */
    Optional<AuthSession> findById(UUID id);

    /**
     * Find session by session token
     * @param sessionToken the session token
     * @return Optional containing the session if found
     */
    Optional<AuthSession> findBySessionToken(String sessionToken);

    /**
     * Find session by refresh token
     * @param refreshToken the refresh token
     * @return Optional containing the session if found
     */
    Optional<AuthSession> findByRefreshToken(String refreshToken);

    /**
     * Find all sessions for a user
     * @param userId the user ID
     * @return list of sessions
     */
    List<AuthSession> findByUserId(UUID userId);

    /**
     * Find all active sessions for a user
     * @param userId the user ID
     * @return list of active sessions
     */
    List<AuthSession> findActiveByUserId(UUID userId);

    /**
     * Find all sessions with a specific status
     * @param status the session status
     * @return list of sessions
     */
    List<AuthSession> findByStatus(SessionStatus status);

    /**
     * Find all sessions expiring before a given time
     * @param expirationTime the expiration cutoff time
     * @return list of sessions expiring before the given time
     */
    List<AuthSession> findExpiringBefore(Instant expirationTime);

    /**
     * Find sessions by PAT ID
     * @param patId the PAT ID
     * @return list of sessions
     */
    List<AuthSession> findByPatId(UUID patId);

    /**
     * Find sessions by Google ID
     * @param googleId the Google ID
     * @return list of sessions
     */
    List<AuthSession> findByGoogleId(String googleId);

    /**
     * Find session by device ID and user ID
     * @param deviceId the device ID
     * @param userId the user ID
     * @return Optional containing the session if found
     */
    Optional<AuthSession> findByDeviceIdAndUserId(String deviceId, UUID userId);

    /**
     * Save a session
     * @param session the session to save
     * @return the saved session
     */
    AuthSession save(AuthSession session);

    /**
     * Delete a session by ID
     * @param id the session ID
     */
    void deleteById(UUID id);

    /**
     * Delete all sessions for a user
     * @param userId the user ID
     */
    void deleteByUserId(UUID userId);

    /**
     * Delete all expired sessions
     * @return number of deleted sessions
     */
    int deleteExpiredSessions();

    /**
     * Count active sessions for a user
     * @param userId the user ID
     * @return number of active sessions
     */
    long countActiveByUserId(UUID userId);

    /**
     * Check if a session exists by token
     * @param sessionToken the session token
     * @return true if session exists
     */
    boolean existsBySessionToken(String sessionToken);

    /**
     * Invalidate all sessions for a user (bulk operation)
     * @param userId the user ID
     * @return number of invalidated sessions
     */
    int invalidateAllByUserId(UUID userId);

    /**
     * Find all sessions with activity after a given time
     * @param after the time threshold
     * @return list of sessions
     */
    List<AuthSession> findWithActivityAfter(Instant after);
}
