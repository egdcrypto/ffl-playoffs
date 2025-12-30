package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.character.Character;
import com.ffl.playoffs.domain.model.character.CharacterStatus;
import com.ffl.playoffs.domain.port.CharacterRepository;

import java.util.List;
import java.util.UUID;

/**
 * Use case for activating characters (DRAFT -> ACTIVE transition)
 * Characters are activated when the league starts
 */
public class ActivateCharacterUseCase {

    private final CharacterRepository characterRepository;

    public ActivateCharacterUseCase(CharacterRepository characterRepository) {
        this.characterRepository = characterRepository;
    }

    /**
     * Activate a single character
     * @param command the activation command
     * @return the activated character
     * @throws IllegalArgumentException if character not found
     * @throws IllegalStateException if character cannot be activated
     */
    public Character execute(ActivateCharacterCommand command) {
        // Find the character
        Character character = characterRepository.findById(command.getCharacterId())
                .orElseThrow(() -> new IllegalArgumentException(
                        "Character not found: " + command.getCharacterId()));

        // Activate the character
        character.activate();

        // Save and return
        return characterRepository.save(character);
    }

    /**
     * Activate all draft characters in a league
     * @param command the activation command
     * @return result with count of activated characters
     */
    public ActivateAllResult executeAll(ActivateAllInLeagueCommand command) {
        // Find all draft characters in the league
        List<Character> draftCharacters = characterRepository.findByLeagueIdAndStatus(
                command.getLeagueId(), CharacterStatus.DRAFT);

        int activatedCount = 0;
        int failedCount = 0;

        for (Character character : draftCharacters) {
            try {
                character.activate();
                characterRepository.save(character);
                activatedCount++;
            } catch (IllegalStateException e) {
                failedCount++;
            }
        }

        return new ActivateAllResult(activatedCount, failedCount, draftCharacters.size());
    }

    /**
     * Command for activating a single character
     */
    public static class ActivateCharacterCommand {
        private final UUID characterId;

        public ActivateCharacterCommand(UUID characterId) {
            this.characterId = characterId;
        }

        public UUID getCharacterId() {
            return characterId;
        }
    }

    /**
     * Command for activating all characters in a league
     */
    public static class ActivateAllInLeagueCommand {
        private final UUID leagueId;

        public ActivateAllInLeagueCommand(UUID leagueId) {
            this.leagueId = leagueId;
        }

        public UUID getLeagueId() {
            return leagueId;
        }
    }

    /**
     * Result of activating all characters
     */
    public static class ActivateAllResult {
        private final int activatedCount;
        private final int failedCount;
        private final int totalCount;

        public ActivateAllResult(int activatedCount, int failedCount, int totalCount) {
            this.activatedCount = activatedCount;
            this.failedCount = failedCount;
            this.totalCount = totalCount;
        }

        public int getActivatedCount() {
            return activatedCount;
        }

        public int getFailedCount() {
            return failedCount;
        }

        public int getTotalCount() {
            return totalCount;
        }

        public boolean isSuccess() {
            return failedCount == 0;
        }
    }
}
