package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Character;
import com.ffl.playoffs.domain.port.CharacterRepository;

import java.util.UUID;

/**
 * Use case for recording game results for a character
 * Application layer orchestrates domain logic
 */
public class RecordGameResultUseCase {

    private final CharacterRepository characterRepository;

    public RecordGameResultUseCase(CharacterRepository characterRepository) {
        this.characterRepository = characterRepository;
    }

    /**
     * Records a game result for a character
     *
     * @param command The record game result command
     * @return The updated Character
     * @throws IllegalArgumentException if character not found
     */
    public Character execute(RecordGameResultCommand command) {
        Character character = characterRepository.findById(command.getCharacterId())
                .orElseThrow(() -> new IllegalArgumentException("Character not found: " + command.getCharacterId()));

        switch (command.getResult()) {
            case WIN -> character.recordWin(command.getPointsScored());
            case LOSS -> character.recordLoss(command.getPointsScored());
            case TIE -> character.recordTie(command.getPointsScored());
        }

        return characterRepository.save(character);
    }

    /**
     * Game result type
     */
    public enum GameResult {
        WIN, LOSS, TIE
    }

    /**
     * Command object for recording a game result
     */
    public static class RecordGameResultCommand {
        private final UUID characterId;
        private final GameResult result;
        private final double pointsScored;

        public RecordGameResultCommand(UUID characterId, GameResult result, double pointsScored) {
            this.characterId = characterId;
            this.result = result;
            this.pointsScored = pointsScored;
        }

        // Getters
        public UUID getCharacterId() { return characterId; }
        public GameResult getResult() { return result; }
        public double getPointsScored() { return pointsScored; }
    }
}
