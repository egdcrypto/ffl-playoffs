package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.PlayerInvitationDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for PlayerInvitationDocument.
 * Infrastructure layer - MongoDB specific.
 */
@Repository
public interface PlayerInvitationMongoRepository extends MongoRepository<PlayerInvitationDocument, String> {

    /**
     * Find invitation by token
     *
     * @param invitationToken the invitation token
     * @return Optional containing the invitation if found
     */
    Optional<PlayerInvitationDocument> findByInvitationToken(String invitationToken);

    /**
     * Find all pending invitations for an email
     *
     * @param email the email address
     * @return list of pending invitations
     */
    @Query("{'email': ?0, 'status': 'PENDING'}")
    List<PlayerInvitationDocument> findPendingByEmail(String email);

    /**
     * Find pending invitation for a specific email and league
     *
     * @param email the email address
     * @param leagueId the league ID
     * @return Optional containing the invitation if found
     */
    @Query("{'email': ?0, 'leagueId': ?1, 'status': 'PENDING'}")
    Optional<PlayerInvitationDocument> findPendingByEmailAndLeagueId(String email, String leagueId);

    /**
     * Find all invitations for a league
     *
     * @param leagueId the league ID
     * @return list of invitations
     */
    List<PlayerInvitationDocument> findByLeagueId(String leagueId);

    /**
     * Find all pending invitations for a league
     *
     * @param leagueId the league ID
     * @return list of pending invitations
     */
    @Query("{'leagueId': ?0, 'status': 'PENDING'}")
    List<PlayerInvitationDocument> findPendingByLeagueId(String leagueId);

    /**
     * Check if a pending invitation exists for email and league
     *
     * @param email the email address
     * @param leagueId the league ID
     * @return true if pending invitation exists
     */
    @Query(value = "{'email': ?0, 'leagueId': ?1, 'status': 'PENDING'}", exists = true)
    boolean existsPendingByEmailAndLeagueId(String email, String leagueId);

    /**
     * Find all expired pending invitations
     *
     * @param now the current time
     * @return list of expired invitations that are still marked as pending
     */
    @Query("{'status': 'PENDING', 'expiresAt': {'$lt': ?0}}")
    List<PlayerInvitationDocument> findExpiredPendingInvitations(LocalDateTime now);
}
