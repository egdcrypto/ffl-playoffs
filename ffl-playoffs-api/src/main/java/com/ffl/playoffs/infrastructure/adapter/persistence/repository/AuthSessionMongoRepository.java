package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.AuthSessionDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for AuthSessionDocument
 * Infrastructure layer - MongoDB specific
 */
@Repository
public interface AuthSessionMongoRepository extends MongoRepository<AuthSessionDocument, String> {

    /**
     * Find session by session token
     * @param sessionToken the session token
     * @return Optional containing the session if found
     */
    Optional<AuthSessionDocument> findBySessionToken(String sessionToken);

    /**
     * Find session by refresh token
     * @param refreshToken the refresh token
     * @return Optional containing the session if found
     */
    Optional<AuthSessionDocument> findByRefreshToken(String refreshToken);

    /**
     * Find all sessions for a user
     * @param userId the user ID
     * @return list of sessions
     */
    List<AuthSessionDocument> findByUserId(String userId);

    /**
     * Find all active sessions for a user
     * @param userId the user ID
     * @param status the active status
     * @return list of active sessions
     */
    List<AuthSessionDocument> findByUserIdAndStatus(String userId, String status);

    /**
     * Find all sessions with a specific status
     * @param status the session status
     * @return list of sessions
     */
    List<AuthSessionDocument> findByStatus(String status);

    /**
     * Find all sessions expiring before a given time
     * @param expirationTime the expiration cutoff time
     * @return list of sessions
     */
    @Query("{ 'expiresAt': { $lt: ?0 }, 'status': 'active' }")
    List<AuthSessionDocument> findExpiringBefore(Instant expirationTime);

    /**
     * Find sessions by PAT ID
     * @param patId the PAT ID
     * @return list of sessions
     */
    List<AuthSessionDocument> findByPatId(String patId);

    /**
     * Find sessions by Google ID
     * @param googleId the Google ID
     * @return list of sessions
     */
    List<AuthSessionDocument> findByGoogleId(String googleId);

    /**
     * Find session by device ID and user ID
     * @param deviceId the device ID
     * @param userId the user ID
     * @return Optional containing the session if found
     */
    Optional<AuthSessionDocument> findByDeviceIdAndUserId(String deviceId, String userId);

    /**
     * Delete all sessions for a user
     * @param userId the user ID
     */
    void deleteByUserId(String userId);

    /**
     * Delete all sessions with status and expiry before given time
     * @param status the session status
     * @param expiresAt the expiration cutoff time
     * @return number of deleted sessions
     */
    long deleteByStatusAndExpiresAtBefore(String status, Instant expiresAt);

    /**
     * Count active sessions for a user
     * @param userId the user ID
     * @param status the active status
     * @return number of active sessions
     */
    long countByUserIdAndStatus(String userId, String status);

    /**
     * Check if a session exists by token
     * @param sessionToken the session token
     * @return true if session exists
     */
    boolean existsBySessionToken(String sessionToken);

    /**
     * Find all sessions with activity after a given time
     * @param after the time threshold
     * @return list of sessions
     */
    @Query("{ 'lastActivityAt': { $gt: ?0 } }")
    List<AuthSessionDocument> findWithActivityAfter(Instant after);
}
