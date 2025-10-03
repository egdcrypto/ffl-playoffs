package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.port.GameRepository;
import com.ffl.playoffs.domain.port.PlayerRepository;

import java.util.UUID;

/**
 * Use case for inviting a player to a game.
 */
public class InvitePlayerUseCase {
    
    private final GameRepository gameRepository;
    private final PlayerRepository playerRepository;

    public InvitePlayerUseCase(GameRepository gameRepository, PlayerRepository playerRepository) {
        this.gameRepository = gameRepository;
        this.playerRepository = playerRepository;
    }

    public Player execute(UUID gameId, String playerName, String playerEmail) {
        // Validate game exists
        Game game = gameRepository.findById(gameId)
                .orElseThrow(() -> new IllegalArgumentException("Game not found"));
        
        // Check if player already exists in game
        if (playerRepository.existsByEmailAndGameId(playerEmail, gameId)) {
            throw new IllegalStateException("Player already invited to this game");
        }
        
        // Create and save player
        Player player = new Player(playerName, playerEmail, gameId);
        Player savedPlayer = playerRepository.save(player);
        
        // Add player to game
        game.addPlayer(savedPlayer);
        gameRepository.save(game);
        
        return savedPlayer;
    }
}
