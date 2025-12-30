package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Character;
import com.ffl.playoffs.domain.port.CharacterRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for retrieving character information
 * Application layer orchestrates domain logic
 */
public class GetCharacterUseCase {

    private final CharacterRepository characterRepository;

    public GetCharacterUseCase(CharacterRepository characterRepository) {
        this.characterRepository = characterRepository;
    }

    /**
     * Get a character by ID
     *
     * @param characterId The character ID
     * @return Optional containing the character if found
     */
    public Optional<Character> getById(UUID characterId) {
        return characterRepository.findById(characterId);
    }

    /**
     * Get a character by user ID and league ID
     *
     * @param userId The user ID
     * @param leagueId The league ID
     * @return Optional containing the character if found
     */
    public Optional<Character> getByUserAndLeague(UUID userId, UUID leagueId) {
        return characterRepository.findByUserIdAndLeagueId(userId, leagueId);
    }

    /**
     * Get all characters for a user
     *
     * @param userId The user ID
     * @return List of characters
     */
    public List<Character> getByUser(UUID userId) {
        return characterRepository.findByUserId(userId);
    }

    /**
     * Get all characters in a league
     *
     * @param leagueId The league ID
     * @return List of characters
     */
    public List<Character> getByLeague(UUID leagueId) {
        return characterRepository.findByLeagueId(leagueId);
    }

    /**
     * Search characters by team name
     *
     * @param teamName The team name to search
     * @return List of matching characters
     */
    public List<Character> searchByTeamName(String teamName) {
        return characterRepository.findByTeamNameContaining(teamName);
    }

    /**
     * Get top characters by level (leaderboard)
     *
     * @param limit Maximum number of characters to return
     * @return List of characters sorted by level descending
     */
    public List<Character> getLeaderboard(int limit) {
        return characterRepository.findTopByLevel(limit);
    }

    /**
     * Get top characters in a league by level
     *
     * @param leagueId The league ID
     * @param limit Maximum number of characters to return
     * @return List of characters sorted by level descending
     */
    public List<Character> getLeagueLeaderboard(UUID leagueId, int limit) {
        return characterRepository.findTopByLevelInLeague(leagueId, limit);
    }
}
