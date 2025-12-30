package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.RosterDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for RosterDocument.
 * Infrastructure layer - MongoDB specific.
 */
@Repository
public interface RosterMongoRepository extends MongoRepository<RosterDocument, String> {

    /**
     * Find roster by league player ID.
     *
     * @param leaguePlayerId the league player ID
     * @return Optional containing the roster document if found
     */
    Optional<RosterDocument> findByLeaguePlayerId(String leaguePlayerId);

    /**
     * Find all rosters for a game/league.
     *
     * @param gameId the game/league ID
     * @return list of roster documents
     */
    List<RosterDocument> findByGameId(String gameId);

    /**
     * Find all rosters by lock status.
     *
     * @param lockStatus the lock status (UNLOCKED, LOCKED, LOCKED_INCOMPLETE)
     * @return list of roster documents
     */
    List<RosterDocument> findByLockStatus(String lockStatus);

    /**
     * Find all locked rosters (including incomplete).
     *
     * @param isLocked the lock flag
     * @return list of roster documents
     */
    List<RosterDocument> findByIsLocked(Boolean isLocked);

    /**
     * Find all rosters in a game/league with a specific lock status.
     *
     * @param gameId the game/league ID
     * @param lockStatus the lock status
     * @return list of roster documents
     */
    List<RosterDocument> findByGameIdAndLockStatus(String gameId, String lockStatus);

    /**
     * Count rosters by game ID and lock status.
     *
     * @param gameId the game/league ID
     * @param lockStatus the lock status
     * @return count of matching rosters
     */
    long countByGameIdAndLockStatus(String gameId, String lockStatus);

    /**
     * Check if a roster exists for a league player.
     *
     * @param leaguePlayerId the league player ID
     * @return true if roster exists
     */
    boolean existsByLeaguePlayerId(String leaguePlayerId);
}
