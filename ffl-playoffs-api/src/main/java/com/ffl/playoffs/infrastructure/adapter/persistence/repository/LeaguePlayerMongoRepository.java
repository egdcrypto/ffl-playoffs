package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.LeaguePlayerDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for LeaguePlayerDocument
 * Infrastructure layer - MongoDB specific
 */
@Repository
public interface LeaguePlayerMongoRepository extends MongoRepository<LeaguePlayerDocument, String> {

    /**
     * Find league player by user ID and league ID
     */
    Optional<LeaguePlayerDocument> findByUserIdAndLeagueId(String userId, String leagueId);

    /**
     * Find all league memberships for a user
     */
    List<LeaguePlayerDocument> findByUserId(String userId);

    /**
     * Find active leagues for a user
     */
    @Query("{ 'userId': ?0, 'status': 'ACTIVE' }")
    List<LeaguePlayerDocument> findActiveLeaguesByUserId(String userId);

    /**
     * Find all members of a league
     */
    List<LeaguePlayerDocument> findByLeagueId(String leagueId);

    /**
     * Find active players in a league
     */
    @Query("{ 'leagueId': ?0, 'status': 'ACTIVE' }")
    List<LeaguePlayerDocument> findActivePlayersByLeagueId(String leagueId);

    /**
     * Find league players by league and status
     */
    List<LeaguePlayerDocument> findByLeagueIdAndStatus(String leagueId, String status);

    /**
     * Find league player by invitation token
     */
    Optional<LeaguePlayerDocument> findByInvitationToken(String invitationToken);

    /**
     * Check if user is a member of league
     */
    boolean existsByUserIdAndLeagueId(String userId, String leagueId);

    /**
     * Check if user is an active member
     */
    @Query(value = "{ 'userId': ?0, 'leagueId': ?1, 'status': 'ACTIVE' }", exists = true)
    boolean isActivePlayer(String userId, String leagueId);

    /**
     * Count total members in league
     */
    long countByLeagueId(String leagueId);

    /**
     * Count active players in league
     */
    @Query(value = "{ 'leagueId': ?0, 'status': 'ACTIVE' }", count = true)
    long countActivePlayersByLeagueId(String leagueId);

    /**
     * Count pending invitations for league
     */
    @Query(value = "{ 'leagueId': ?0, 'status': 'INVITED' }", count = true)
    long countPendingInvitationsByLeagueId(String leagueId);

    /**
     * Delete all league players for a league
     */
    void deleteByLeagueId(String leagueId);

    /**
     * Delete all league memberships for a user
     */
    void deleteByUserId(String userId);
}
