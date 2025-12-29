package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.AdminInvitationDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for AdminInvitation documents
 */
@Repository
public interface AdminInvitationMongoRepository extends MongoRepository<AdminInvitationDocument, String> {

    /**
     * Find invitation by token
     */
    Optional<AdminInvitationDocument> findByInvitationToken(String token);

    /**
     * Find pending invitation by email
     */
    @Query("{ 'email': ?0, 'status': 'PENDING' }")
    Optional<AdminInvitationDocument> findPendingByEmail(String email);

    /**
     * Find all invitations by email
     */
    List<AdminInvitationDocument> findByEmail(String email);

    /**
     * Find all invitations by status
     */
    List<AdminInvitationDocument> findByStatus(String status);

    /**
     * Find expired pending invitations
     */
    @Query("{ 'status': 'PENDING', 'expiresAt': { $lt: ?0 } }")
    List<AdminInvitationDocument> findExpiredPending(LocalDateTime now);

    /**
     * Check if pending invitation exists for email
     */
    @Query(value = "{ 'email': ?0, 'status': 'PENDING' }", exists = true)
    boolean existsPendingByEmail(String email);
}
