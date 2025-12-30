package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.character.Character;
import com.ffl.playoffs.domain.model.character.CharacterStatus;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for Character entity
 * Port in hexagonal architecture
 */
public interface CharacterRepository {

    /**
     * Find character by ID
     * @param id the character ID
     * @return Optional containing the character if found
     */
    Optional<Character> findById(UUID id);

    /**
     * Find character by user ID and league ID
     * @param userId the user ID
     * @param leagueId the league ID
     * @return Optional containing the character if found
     */
    Optional<Character> findByUserIdAndLeagueId(UUID userId, UUID leagueId);

    /**
     * Find all characters for a user
     * @param userId the user ID
     * @return list of characters
     */
    List<Character> findByUserId(UUID userId);

    /**
     * Find all characters in a league
     * @param leagueId the league ID
     * @return list of characters
     */
    List<Character> findByLeagueId(UUID leagueId);

    /**
     * Find all characters in a league with a specific status
     * @param leagueId the league ID
     * @param status the character status
     * @return list of characters
     */
    List<Character> findByLeagueIdAndStatus(UUID leagueId, CharacterStatus status);

    /**
     * Find all active characters in a league
     * @param leagueId the league ID
     * @return list of active characters
     */
    List<Character> findActiveByLeagueId(UUID leagueId);

    /**
     * Find all eliminated characters in a league
     * @param leagueId the league ID
     * @return list of eliminated characters
     */
    List<Character> findEliminatedByLeagueId(UUID leagueId);

    /**
     * Find characters in a league ordered by total score
     * @param leagueId the league ID
     * @return list of characters ordered by score descending
     */
    List<Character> findByLeagueIdOrderByTotalScoreDesc(UUID leagueId);

    /**
     * Find characters in a league ordered by overall rank
     * @param leagueId the league ID
     * @return list of characters ordered by rank ascending
     */
    List<Character> findByLeagueIdOrderByOverallRankAsc(UUID leagueId);

    /**
     * Find characters eliminated in a specific week
     * @param leagueId the league ID
     * @param week the elimination week
     * @return list of characters eliminated that week
     */
    List<Character> findByLeagueIdAndEliminationWeek(UUID leagueId, Integer week);

    /**
     * Save a character
     * @param character the character to save
     * @return the saved character
     */
    Character save(Character character);

    /**
     * Delete a character by ID
     * @param id the character ID
     */
    void deleteById(UUID id);

    /**
     * Delete all characters for a user
     * @param userId the user ID
     */
    void deleteByUserId(UUID userId);

    /**
     * Delete all characters in a league
     * @param leagueId the league ID
     */
    void deleteByLeagueId(UUID leagueId);

    /**
     * Count characters in a league
     * @param leagueId the league ID
     * @return number of characters
     */
    long countByLeagueId(UUID leagueId);

    /**
     * Count active characters in a league
     * @param leagueId the league ID
     * @return number of active characters
     */
    long countActiveByLeagueId(UUID leagueId);

    /**
     * Count characters by status in a league
     * @param leagueId the league ID
     * @param status the character status
     * @return number of characters with that status
     */
    long countByLeagueIdAndStatus(UUID leagueId, CharacterStatus status);

    /**
     * Check if a character exists for a user in a league
     * @param userId the user ID
     * @param leagueId the league ID
     * @return true if character exists
     */
    boolean existsByUserIdAndLeagueId(UUID userId, UUID leagueId);

    /**
     * Check if a character name is taken in a league
     * @param leagueId the league ID
     * @param name the character name
     * @return true if name is taken
     */
    boolean existsByLeagueIdAndName(UUID leagueId, String name);

    /**
     * Find characters with the lowest score in a league (for elimination)
     * @param leagueId the league ID
     * @param limit the number of characters to return
     * @return list of characters with lowest scores
     */
    List<Character> findLowestScoringActiveCharacters(UUID leagueId, int limit);
}
