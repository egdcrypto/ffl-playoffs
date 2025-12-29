package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.PlayerInvitation;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for PlayerInvitation entity.
 * Port in hexagonal architecture.
 */
public interface PlayerInvitationRepository {

    /**
     * Find invitation by ID
     *
     * @param id the invitation ID
     * @return Optional containing the invitation if found
     */
    Optional<PlayerInvitation> findById(UUID id);

    /**
     * Find invitation by token
     *
     * @param token the invitation token
     * @return Optional containing the invitation if found
     */
    Optional<PlayerInvitation> findByToken(String token);

    /**
     * Find all pending invitations for an email
     *
     * @param email the email address
     * @return list of pending invitations
     */
    List<PlayerInvitation> findPendingByEmail(String email);

    /**
     * Find pending invitation for a specific email and league
     *
     * @param email the email address
     * @param leagueId the league ID
     * @return Optional containing the invitation if found
     */
    Optional<PlayerInvitation> findPendingByEmailAndLeague(String email, UUID leagueId);

    /**
     * Find all invitations for a league
     *
     * @param leagueId the league ID
     * @return list of invitations
     */
    List<PlayerInvitation> findByLeagueId(UUID leagueId);

    /**
     * Find all pending invitations for a league
     *
     * @param leagueId the league ID
     * @return list of pending invitations
     */
    List<PlayerInvitation> findPendingByLeagueId(UUID leagueId);

    /**
     * Check if a pending invitation exists for email and league
     *
     * @param email the email address
     * @param leagueId the league ID
     * @return true if pending invitation exists
     */
    boolean existsPendingByEmailAndLeague(String email, UUID leagueId);

    /**
     * Save an invitation
     *
     * @param invitation the invitation to save
     * @return the saved invitation
     */
    PlayerInvitation save(PlayerInvitation invitation);

    /**
     * Delete an invitation
     *
     * @param id the invitation ID
     */
    void deleteById(UUID id);

    /**
     * Find all expired pending invitations
     *
     * @return list of expired invitations that are still marked as pending
     */
    List<PlayerInvitation> findExpiredPendingInvitations();
}
