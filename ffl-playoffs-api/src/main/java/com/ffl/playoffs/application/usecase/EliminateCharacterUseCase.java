package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.character.Character;
import com.ffl.playoffs.domain.port.CharacterRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Use case for eliminating characters (ACTIVE -> ELIMINATED transition)
 * Characters are eliminated based on lowest weekly score
 */
public class EliminateCharacterUseCase {

    private final CharacterRepository characterRepository;

    public EliminateCharacterUseCase(CharacterRepository characterRepository) {
        this.characterRepository = characterRepository;
    }

    /**
     * Eliminate a single character
     * @param command the elimination command
     * @return the eliminated character
     * @throws IllegalArgumentException if character not found
     * @throws IllegalStateException if character cannot be eliminated
     */
    public Character execute(EliminateCharacterCommand command) {
        // Find the character
        Character character = characterRepository.findById(command.getCharacterId())
                .orElseThrow(() -> new IllegalArgumentException(
                        "Character not found: " + command.getCharacterId()));

        // Eliminate the character
        character.eliminate(command.getWeek(), command.getRank(), command.getReason());

        // Save and return
        return characterRepository.save(character);
    }

    /**
     * Eliminate the lowest scoring characters in a league
     * @param command the elimination command
     * @return list of eliminated characters
     */
    public List<Character> executeLowestScoring(EliminateLowestScoringCommand command) {
        // Find the lowest scoring active characters
        List<Character> lowestScoring = characterRepository.findLowestScoringActiveCharacters(
                command.getLeagueId(), command.getCount());

        List<Character> eliminated = new ArrayList<>();
        int rank = (int) characterRepository.countActiveByLeagueId(command.getLeagueId());

        for (Character character : lowestScoring) {
            try {
                character.eliminate(command.getWeek(), rank,
                        "Lowest score in week " + command.getWeek());
                characterRepository.save(character);
                eliminated.add(character);
                rank--;
            } catch (IllegalStateException e) {
                // Skip if cannot be eliminated
            }
        }

        return eliminated;
    }

    /**
     * Command for eliminating a single character
     */
    public static class EliminateCharacterCommand {
        private final UUID characterId;
        private final Integer week;
        private final Integer rank;
        private final String reason;

        public EliminateCharacterCommand(UUID characterId, Integer week, Integer rank) {
            this(characterId, week, rank, null);
        }

        public EliminateCharacterCommand(UUID characterId, Integer week, Integer rank, String reason) {
            this.characterId = characterId;
            this.week = week;
            this.rank = rank;
            this.reason = reason;
        }

        public UUID getCharacterId() {
            return characterId;
        }

        public Integer getWeek() {
            return week;
        }

        public Integer getRank() {
            return rank;
        }

        public String getReason() {
            return reason;
        }
    }

    /**
     * Command for eliminating lowest scoring characters
     */
    public static class EliminateLowestScoringCommand {
        private final UUID leagueId;
        private final Integer week;
        private final int count;

        public EliminateLowestScoringCommand(UUID leagueId, Integer week, int count) {
            this.leagueId = leagueId;
            this.week = week;
            this.count = count;
        }

        public UUID getLeagueId() {
            return leagueId;
        }

        public Integer getWeek() {
            return week;
        }

        public int getCount() {
            return count;
        }
    }
}
