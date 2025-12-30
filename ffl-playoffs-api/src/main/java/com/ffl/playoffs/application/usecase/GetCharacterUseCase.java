package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.character.Character;
import com.ffl.playoffs.domain.model.character.CharacterStatus;
import com.ffl.playoffs.domain.port.CharacterRepository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for retrieving character information
 */
public class GetCharacterUseCase {

    private final CharacterRepository characterRepository;

    public GetCharacterUseCase(CharacterRepository characterRepository) {
        this.characterRepository = characterRepository;
    }

    /**
     * Get a character by ID
     * @param characterId the character ID
     * @return Optional containing the character if found
     */
    public Optional<Character> getById(UUID characterId) {
        return characterRepository.findById(characterId);
    }

    /**
     * Get a user's character in a specific league
     * @param userId the user ID
     * @param leagueId the league ID
     * @return Optional containing the character if found
     */
    public Optional<Character> getByUserAndLeague(UUID userId, UUID leagueId) {
        return characterRepository.findByUserIdAndLeagueId(userId, leagueId);
    }

    /**
     * Get all characters for a user
     * @param userId the user ID
     * @return list of characters
     */
    public List<Character> getByUser(UUID userId) {
        return characterRepository.findByUserId(userId);
    }

    /**
     * Get all characters in a league
     * @param leagueId the league ID
     * @return list of characters
     */
    public List<Character> getByLeague(UUID leagueId) {
        return characterRepository.findByLeagueId(leagueId);
    }

    /**
     * Get all characters in a league with a specific status
     * @param leagueId the league ID
     * @param status the character status
     * @return list of characters
     */
    public List<Character> getByLeagueAndStatus(UUID leagueId, CharacterStatus status) {
        return characterRepository.findByLeagueIdAndStatus(leagueId, status);
    }

    /**
     * Get active characters in a league
     * @param leagueId the league ID
     * @return list of active characters
     */
    public List<Character> getActiveByLeague(UUID leagueId) {
        return characterRepository.findActiveByLeagueId(leagueId);
    }

    /**
     * Get eliminated characters in a league
     * @param leagueId the league ID
     * @return list of eliminated characters
     */
    public List<Character> getEliminatedByLeague(UUID leagueId) {
        return characterRepository.findEliminatedByLeagueId(leagueId);
    }

    /**
     * Get league standings (characters ordered by score)
     * @param leagueId the league ID
     * @return list of characters ordered by total score descending
     */
    public List<Character> getLeagueStandings(UUID leagueId) {
        return characterRepository.findByLeagueIdOrderByTotalScoreDesc(leagueId);
    }

    /**
     * Get league rankings (characters ordered by rank)
     * @param leagueId the league ID
     * @return list of characters ordered by overall rank ascending
     */
    public List<Character> getLeagueRankings(UUID leagueId) {
        return characterRepository.findByLeagueIdOrderByOverallRankAsc(leagueId);
    }

    /**
     * Get characters eliminated in a specific week
     * @param leagueId the league ID
     * @param week the elimination week
     * @return list of characters eliminated that week
     */
    public List<Character> getEliminatedByWeek(UUID leagueId, Integer week) {
        return characterRepository.findByLeagueIdAndEliminationWeek(leagueId, week);
    }

    /**
     * Get league character count
     * @param leagueId the league ID
     * @return character count
     */
    public long getLeagueCharacterCount(UUID leagueId) {
        return characterRepository.countByLeagueId(leagueId);
    }

    /**
     * Get active character count in league
     * @param leagueId the league ID
     * @return active character count
     */
    public long getActiveCharacterCount(UUID leagueId) {
        return characterRepository.countActiveByLeagueId(leagueId);
    }
}
