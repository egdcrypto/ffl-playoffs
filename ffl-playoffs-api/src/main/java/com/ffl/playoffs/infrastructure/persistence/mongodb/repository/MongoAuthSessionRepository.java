package com.ffl.playoffs.infrastructure.persistence.mongodb.repository;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.AuthSessionDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Spring Data MongoDB repository for AuthSessionDocument.
 */
@Repository
public interface MongoAuthSessionRepository extends MongoRepository<AuthSessionDocument, String> {

    /**
     * Find all active sessions for a principal
     */
    List<AuthSessionDocument> findByPrincipalIdAndActiveIsTrue(String principalId);

    /**
     * Find all sessions for a principal
     */
    List<AuthSessionDocument> findByPrincipalId(String principalId);

    /**
     * Find active sessions by authentication type
     */
    List<AuthSessionDocument> findByAuthenticationTypeAndActiveIsTrue(String authenticationType);

    /**
     * Find expired sessions that are still marked as active
     */
    @Query("{ 'active': true, 'expires_at': { $lt: ?0, $ne: null } }")
    List<AuthSessionDocument> findExpiredActiveSessions(LocalDateTime now);

    /**
     * Find sessions that have been idle since before the threshold
     */
    @Query("{ 'active': true, 'last_activity_at': { $lt: ?0 } }")
    List<AuthSessionDocument> findIdleSessions(LocalDateTime idleThreshold);

    /**
     * Count active sessions for a principal
     */
    long countByPrincipalIdAndActiveIsTrue(String principalId);

    /**
     * Delete all sessions for a principal
     */
    void deleteByPrincipalId(String principalId);

    /**
     * Delete sessions older than a date
     */
    long deleteByCreatedAtBefore(LocalDateTime cutoff);

    /**
     * Find all sessions created before a date
     */
    List<AuthSessionDocument> findByCreatedAtBefore(LocalDateTime cutoff);
}
