package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.CharacterDocument;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for CharacterDocument
 * Infrastructure layer - MongoDB specific
 */
@Repository
public interface CharacterMongoRepository extends MongoRepository<CharacterDocument, String> {

    /**
     * Find character by user ID and league ID
     * @param userId the user ID
     * @param leagueId the league ID
     * @return Optional containing the character if found
     */
    Optional<CharacterDocument> findByUserIdAndLeagueId(String userId, String leagueId);

    /**
     * Find all characters for a user
     * @param userId the user ID
     * @return list of characters
     */
    List<CharacterDocument> findByUserId(String userId);

    /**
     * Find all characters in a league
     * @param leagueId the league ID
     * @return list of characters
     */
    List<CharacterDocument> findByLeagueId(String leagueId);

    /**
     * Find all characters in a league with a specific status
     * @param leagueId the league ID
     * @param status the character status code
     * @return list of characters
     */
    List<CharacterDocument> findByLeagueIdAndStatus(String leagueId, String status);

    /**
     * Find characters in a league ordered by total score descending
     * @param leagueId the league ID
     * @return list of characters
     */
    List<CharacterDocument> findByLeagueIdOrderByTotalScoreDesc(String leagueId);

    /**
     * Find characters in a league ordered by overall rank ascending
     * @param leagueId the league ID
     * @return list of characters
     */
    List<CharacterDocument> findByLeagueIdOrderByOverallRankAsc(String leagueId);

    /**
     * Find characters eliminated in a specific week
     * @param leagueId the league ID
     * @param eliminationWeek the elimination week
     * @return list of characters
     */
    List<CharacterDocument> findByLeagueIdAndEliminationWeek(String leagueId, Integer eliminationWeek);

    /**
     * Delete all characters for a user
     * @param userId the user ID
     */
    void deleteByUserId(String userId);

    /**
     * Delete all characters in a league
     * @param leagueId the league ID
     */
    void deleteByLeagueId(String leagueId);

    /**
     * Count characters in a league
     * @param leagueId the league ID
     * @return number of characters
     */
    long countByLeagueId(String leagueId);

    /**
     * Count characters by status in a league
     * @param leagueId the league ID
     * @param status the character status code
     * @return number of characters
     */
    long countByLeagueIdAndStatus(String leagueId, String status);

    /**
     * Check if character exists for user in league
     * @param userId the user ID
     * @param leagueId the league ID
     * @return true if exists
     */
    boolean existsByUserIdAndLeagueId(String userId, String leagueId);

    /**
     * Check if character name exists in league
     * @param leagueId the league ID
     * @param name the character name
     * @return true if exists
     */
    boolean existsByLeagueIdAndName(String leagueId, String name);

    /**
     * Find active characters in a league ordered by total score ascending (lowest first)
     * @param leagueId the league ID
     * @param status the active status code
     * @return list of characters
     */
    @Query(value = "{ 'leagueId': ?0, 'status': ?1 }", sort = "{ 'totalScore': 1 }")
    List<CharacterDocument> findByLeagueIdAndStatusOrderByTotalScoreAsc(String leagueId, String status);
}
