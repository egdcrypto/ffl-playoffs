package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.TeamSelectionDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for TeamSelectionDocument
 * Infrastructure layer - MongoDB specific
 */
@Repository
public interface TeamSelectionMongoRepository extends MongoRepository<TeamSelectionDocument, String> {

    /**
     * Find all selections for a player
     */
    List<TeamSelectionDocument> findByPlayerId(String playerId);

    /**
     * Find selection for a specific player and week
     */
    Optional<TeamSelectionDocument> findByPlayerIdAndWeek(String playerId, int week);

    /**
     * Find all selections for a game
     */
    List<TeamSelectionDocument> findByGameId(String gameId);

    /**
     * Find all selections for a game and week
     */
    List<TeamSelectionDocument> findByGameIdAndWeek(String gameId, int week);

    /**
     * Check if a player has already selected a specific team
     */
    @Query(value = "{ 'playerId': ?0, 'teamName': ?1 }", exists = true)
    boolean hasPlayerSelectedTeam(String playerId, String teamName);

    /**
     * Count selections for a player
     */
    long countByPlayerId(String playerId);

    /**
     * Delete all selections for a player
     */
    void deleteByPlayerId(String playerId);
}
