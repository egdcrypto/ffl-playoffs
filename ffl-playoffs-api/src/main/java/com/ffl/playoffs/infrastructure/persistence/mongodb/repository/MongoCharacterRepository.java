package com.ffl.playoffs.infrastructure.persistence.mongodb.repository;

import com.ffl.playoffs.infrastructure.persistence.mongodb.document.CharacterDocument;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.data.mongodb.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Spring Data MongoDB repository for Character documents
 */
@Repository
public interface MongoCharacterRepository extends MongoRepository<CharacterDocument, String> {

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
     * Find characters by team name containing (case-insensitive)
     * @param teamName the team name to search
     * @return list of matching characters
     */
    @Query("{'team_name': {$regex: ?0, $options: 'i'}}")
    List<CharacterDocument> findByTeamNameContainingIgnoreCase(String teamName);

    /**
     * Find top characters by level
     * @param pageable pagination with limit
     * @return list of characters sorted by level descending
     */
    List<CharacterDocument> findAllByOrderByLevelDesc(Pageable pageable);

    /**
     * Find top characters in a league by level
     * @param leagueId the league ID
     * @param pageable pagination with limit
     * @return list of characters sorted by level descending
     */
    List<CharacterDocument> findByLeagueIdOrderByLevelDesc(String leagueId, Pageable pageable);

    /**
     * Check if character exists for user in league
     * @param userId the user ID
     * @param leagueId the league ID
     * @return true if exists
     */
    boolean existsByUserIdAndLeagueId(String userId, String leagueId);

    /**
     * Check if team name exists in league
     * @param leagueId the league ID
     * @param teamName the team name
     * @return true if exists
     */
    @Query(value = "{'league_id': ?0, 'team_name': ?1}", exists = true)
    boolean existsByLeagueIdAndTeamName(String leagueId, String teamName);

    /**
     * Delete characters by user ID and league ID
     * @param userId the user ID
     * @param leagueId the league ID
     */
    void deleteByUserIdAndLeagueId(String userId, String leagueId);

    /**
     * Count characters in a league
     * @param leagueId the league ID
     * @return count
     */
    long countByLeagueId(String leagueId);
}
