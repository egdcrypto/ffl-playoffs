package com.ffl.playoffs.infrastructure.persistence.mongodb.repository;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLPlayerDocument;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for NFL Player documents
 * Provides access to the 'nfl_players' collection
 */
@Repository
public interface MongoNFLPlayerRepository extends MongoRepository<NFLPlayerDocument, String> {

    /**
     * Find a player by their external player ID
     * @param playerId the external player ID
     * @return Optional containing the player if found
     */
    Optional<NFLPlayerDocument> findByPlayerId(String playerId);

    /**
     * Find all players on a specific team
     * @param team the team abbreviation (e.g., "KC")
     * @return list of players on the team
     */
    List<NFLPlayerDocument> findByTeam(String team);

    /**
     * Find all players on a specific team with pagination
     * @param team the team abbreviation
     * @param pageable pagination info
     * @return page of players on the team
     */
    Page<NFLPlayerDocument> findByTeam(String team, Pageable pageable);

    /**
     * Find all players at a specific position
     * @param position the position (e.g., "QB", "RB")
     * @return list of players at that position
     */
    List<NFLPlayerDocument> findByPosition(String position);

    /**
     * Find all players at a specific position with pagination
     * @param position the position
     * @param pageable pagination info
     * @return page of players at that position
     */
    Page<NFLPlayerDocument> findByPosition(String position, Pageable pageable);

    /**
     * Find all players with a specific status
     * @param status the player status (e.g., "ACTIVE")
     * @return list of players with that status
     */
    List<NFLPlayerDocument> findByStatus(String status);

    /**
     * Find players by team and position
     * @param team the team abbreviation
     * @param position the position
     * @return list of matching players
     */
    List<NFLPlayerDocument> findByTeamAndPosition(String team, String position);

    /**
     * Search players by name (case-insensitive, contains)
     * @param name the search string
     * @param pageable pagination info
     * @return page of matching players
     */
    @Query("{ 'name': { $regex: ?0, $options: 'i' } }")
    Page<NFLPlayerDocument> findByNameContainingIgnoreCase(String name, Pageable pageable);

    /**
     * Count players by team
     * @param team the team abbreviation
     * @return count of players on the team
     */
    long countByTeam(String team);

    /**
     * Count players by position
     * @param position the position
     * @return count of players at that position
     */
    long countByPosition(String position);

    /**
     * Check if a player exists by player ID
     * @param playerId the external player ID
     * @return true if the player exists
     */
    boolean existsByPlayerId(String playerId);
}
