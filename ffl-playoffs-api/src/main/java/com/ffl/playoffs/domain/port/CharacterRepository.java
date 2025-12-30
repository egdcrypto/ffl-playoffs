package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.Character;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for Character aggregate
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
     * Find characters by team name (partial match)
     * @param teamName the team name to search
     * @return list of matching characters
     */
    List<Character> findByTeamNameContaining(String teamName);

    /**
     * Find top characters by level
     * @param limit maximum number of characters to return
     * @return list of characters sorted by level descending
     */
    List<Character> findTopByLevel(int limit);

    /**
     * Find top characters in a league by level
     * @param leagueId the league ID
     * @param limit maximum number of characters to return
     * @return list of characters sorted by level descending
     */
    List<Character> findTopByLevelInLeague(UUID leagueId, int limit);

    /**
     * Check if character exists for user in league
     * @param userId the user ID
     * @param leagueId the league ID
     * @return true if exists
     */
    boolean existsByUserIdAndLeagueId(UUID userId, UUID leagueId);

    /**
     * Check if team name is already used in league
     * @param leagueId the league ID
     * @param teamName the team name
     * @return true if name is taken
     */
    boolean existsByLeagueIdAndTeamName(UUID leagueId, String teamName);

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
     * Delete all characters for a user in a league
     * @param userId the user ID
     * @param leagueId the league ID
     */
    void deleteByUserIdAndLeagueId(UUID userId, UUID leagueId);

    /**
     * Count characters in a league
     * @param leagueId the league ID
     * @return count
     */
    long countByLeagueId(UUID leagueId);

    /**
     * Count all characters
     * @return total count
     */
    long count();
}
