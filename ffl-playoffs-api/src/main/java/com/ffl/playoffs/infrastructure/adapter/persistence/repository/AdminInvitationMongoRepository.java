package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.AdminInvitationDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for Admin Invitation documents.
 */
@Repository
public interface AdminInvitationMongoRepository extends MongoRepository<AdminInvitationDocument, String> {

    /**
     * Find by invitation token.
     */
    Optional<AdminInvitationDocument> findByInvitationToken(String invitationToken);

    /**
     * Find by email.
     */
    Optional<AdminInvitationDocument> findByEmail(String email);

    /**
     * Find pending invitation by email.
     */
    @Query("{ 'email': ?0, 'status': 'pending' }")
    Optional<AdminInvitationDocument> findPendingByEmail(String email);

    /**
     * Find all by status.
     */
    List<AdminInvitationDocument> findByStatus(String status);

    /**
     * Find all by invitedBy.
     */
    List<AdminInvitationDocument> findByInvitedBy(String invitedBy);

    /**
     * Find all pending invitations.
     */
    @Query("{ 'status': 'pending' }")
    List<AdminInvitationDocument> findPendingInvitations();

    /**
     * Find expired invitations (pending but past expiry).
     */
    @Query("{ 'status': 'pending', 'expiresAt': { $lt: ?0 } }")
    List<AdminInvitationDocument> findExpiredInvitations(Instant now);

    /**
     * Find by email and status.
     */
    List<AdminInvitationDocument> findByEmailAndStatus(String email, String status);

    /**
     * Check if pending invitation exists for email.
     */
    @Query(value = "{ 'email': ?0, 'status': 'pending' }", exists = true)
    boolean existsPendingByEmail(String email);

    /**
     * Count by status.
     */
    long countByStatus(String status);

    /**
     * Count pending by invitedBy.
     */
    @Query(value = "{ 'invitedBy': ?0, 'status': 'pending' }", count = true)
    long countPendingByInvitedBy(String invitedBy);
}
