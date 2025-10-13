package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.model.LeaguePlayer.LeaguePlayerStatus;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Port interface for LeaguePlayer persistence.
 * Domain defines the contract, infrastructure implements it.
 *
 * IMPORTANT: This is a DOMAIN PORT and must only depend on domain entities.
 * NO dependencies on application layer (DTOs, Page, PageRequest).
 *
 * Pagination and DTO mapping should be handled in the application layer.
 *
 * LeaguePlayer is a junction entity linking User to League/Game,
 * supporting multi-league membership for users.
 */
public interface LeaguePlayerRepository {

    /**
     * Save or update a league player
     *
     * @param leaguePlayer the league player to save
     * @return the saved league player
     */
    LeaguePlayer save(LeaguePlayer leaguePlayer);

    /**
     * Find league player by ID
     *
     * @param id the league player ID
     * @return optional containing the league player if found
     */
    Optional<LeaguePlayer> findById(UUID id);

    /**
     * Find league player by user ID and league ID.
     * Used to check if a user is already a member of a specific league.
     *
     * @param userId the user ID
     * @param leagueId the league/game ID
     * @return optional containing the league player if found
     */
    Optional<LeaguePlayer> findByUserIdAndLeagueId(UUID userId, UUID leagueId);

    /**
     * Find all leagues a user is a member of.
     * Application layer handles pagination if needed.
     *
     * @param userId the user ID
     * @return list of all league players for the user
     */
    List<LeaguePlayer> findByUserId(UUID userId);

    /**
     * Find all active leagues for a user.
     * Returns only leagues where status is ACTIVE.
     *
     * @param userId the user ID
     * @return list of active league memberships
     */
    List<LeaguePlayer> findActiveLeaguesByUserId(UUID userId);

    /**
     * Find all members of a league.
     * Application layer handles pagination if needed.
     *
     * @param leagueId the league/game ID
     * @return list of all league players in the league
     */
    List<LeaguePlayer> findByLeagueId(UUID leagueId);

    /**
     * Find active members of a league.
     * Returns only members where status is ACTIVE.
     *
     * @param leagueId the league/game ID
     * @return list of active league players
     */
    List<LeaguePlayer> findActivePlayersByLeagueId(UUID leagueId);

    /**
     * Find league players by status in a specific league.
     * Application layer handles pagination if needed.
     *
     * @param leagueId the league/game ID
     * @param status the player status
     * @return list of league players with the specified status
     */
    List<LeaguePlayer> findByLeagueIdAndStatus(UUID leagueId, LeaguePlayerStatus status);

    /**
     * Find league player by invitation token.
     * Used during invitation acceptance flow.
     *
     * @param invitationToken the invitation token
     * @return optional containing the league player if found
     */
    Optional<LeaguePlayer> findByInvitationToken(String invitationToken);

    /**
     * Check if a user is already a member of a league.
     *
     * @param userId the user ID
     * @param leagueId the league/game ID
     * @return true if user is a member, false otherwise
     */
    boolean existsByUserIdAndLeagueId(UUID userId, UUID leagueId);

    /**
     * Check if a user is an active member of a league.
     *
     * @param userId the user ID
     * @param leagueId the league/game ID
     * @return true if user is an active member, false otherwise
     */
    boolean isActivePlayer(UUID userId, UUID leagueId);

    /**
     * Count total members in a league.
     *
     * @param leagueId the league/game ID
     * @return total number of members
     */
    long countByLeagueId(UUID leagueId);

    /**
     * Count active members in a league.
     *
     * @param leagueId the league/game ID
     * @return number of active members
     */
    long countActivePlayersByLeagueId(UUID leagueId);

    /**
     * Count pending invitations for a league.
     *
     * @param leagueId the league/game ID
     * @return number of pending invitations
     */
    long countPendingInvitationsByLeagueId(UUID leagueId);

    /**
     * Delete a league player membership.
     *
     * @param id the league player ID
     */
    void delete(UUID id);

    /**
     * Delete all league players for a specific league.
     * Used when deleting a league.
     *
     * @param leagueId the league/game ID
     */
    void deleteByLeagueId(UUID leagueId);

    /**
     * Delete all league memberships for a specific user.
     * Used when deleting a user.
     *
     * @param userId the user ID
     */
    void deleteByUserId(UUID userId);
}
