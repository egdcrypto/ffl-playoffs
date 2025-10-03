package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.event.GameCreatedEvent;
import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.port.GameRepository;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Use case for creating a new game.
 */
public class CreateGameUseCase {
    
    private final GameRepository gameRepository;

    public CreateGameUseCase(GameRepository gameRepository) {
        this.gameRepository = gameRepository;
    }

    public Game execute(String name, LocalDateTime startDate, LocalDateTime endDate, UUID creatorId) {
        // Create new game
        Game game = new Game(name, startDate, endDate, creatorId);
        
        // Save game
        Game savedGame = gameRepository.save(game);
        
        // Publish event (in a real implementation, this would use an event bus)
        GameCreatedEvent event = new GameCreatedEvent(savedGame.getId(), name, creatorId);
        
        return savedGame;
    }
}
