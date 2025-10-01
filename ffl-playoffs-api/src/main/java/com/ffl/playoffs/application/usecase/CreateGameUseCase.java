package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.port.GameRepository;

import java.util.UUID;

/**
 * Use case for creating a new game
 * Application layer orchestrates domain logic
 */
public class CreateGameUseCase {

    private final GameRepository gameRepository;

    public CreateGameUseCase(GameRepository gameRepository) {
        this.gameRepository = gameRepository;
    }

    public Game execute(CreateGameCommand command) {
        // Generate unique game code
        String gameCode = generateUniqueGameCode();

        // Create game domain entity
        Game game = new Game(
                command.getName(),
                gameCode,
                command.getCreatorId(),
                command.getStartingWeek()
        );

        // Save and return
        return gameRepository.save(game);
    }

    private String generateUniqueGameCode() {
        String code;
        do {
            code = generateRandomCode();
        } while (gameRepository.existsByCode(code));
        return code;
    }

    private String generateRandomCode() {
        // Generate a 6-character alphanumeric code
        return UUID.randomUUID().toString().substring(0, 6).toUpperCase();
    }

    public static class CreateGameCommand {
        private final String name;
        private final UUID creatorId;
        private final Integer startingWeek;

        public CreateGameCommand(String name, UUID creatorId, Integer startingWeek) {
            this.name = name;
            this.creatorId = creatorId;
            this.startingWeek = startingWeek;
        }

        public String getName() {
            return name;
        }

        public UUID getCreatorId() {
            return creatorId;
        }

        public Integer getStartingWeek() {
            return startingWeek;
        }
    }
}
