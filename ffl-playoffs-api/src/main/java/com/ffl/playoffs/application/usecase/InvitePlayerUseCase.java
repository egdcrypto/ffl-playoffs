package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.port.GameRepository;
import com.ffl.playoffs.domain.port.PlayerRepository;

import java.util.UUID;

/**
 * Use case for inviting a player to a game
 * Application layer orchestrates domain logic
 */
public class InvitePlayerUseCase {

    private final GameRepository gameRepository;
    private final PlayerRepository playerRepository;

    public InvitePlayerUseCase(GameRepository gameRepository, PlayerRepository playerRepository) {
        this.gameRepository = gameRepository;
        this.playerRepository = playerRepository;
    }

    public Player execute(InvitePlayerCommand command) {
        // Find game
        Game game = gameRepository.findById(command.getGameId())
                .orElseThrow(() -> new IllegalArgumentException("Game not found"));

        // Check if player already exists
        if (playerRepository.existsByGameIdAndEmail(command.getGameId(), command.getEmail())) {
            throw new IllegalStateException("Player already invited to this game");
        }

        // Create player
        Player player = new Player(command.getGameId(), command.getName(), command.getEmail());

        // Add to game
        game.addPlayer(player);

        // Save both
        playerRepository.save(player);
        gameRepository.save(game);

        return player;
    }

    public static class InvitePlayerCommand {
        private final UUID gameId;
        private final String name;
        private final String email;

        public InvitePlayerCommand(UUID gameId, String name, String email) {
            this.gameId = gameId;
            this.name = name;
            this.email = email;
        }

        public UUID getGameId() {
            return gameId;
        }

        public String getName() {
            return name;
        }

        public String getEmail() {
            return email;
        }
    }
}
