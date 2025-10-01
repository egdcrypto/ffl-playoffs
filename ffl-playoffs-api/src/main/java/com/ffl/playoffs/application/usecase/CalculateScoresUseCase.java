package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.port.GameRepository;
import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.domain.port.PlayerRepository;
import com.ffl.playoffs.domain.service.ScoringService;

import java.util.List;
import java.util.UUID;

/**
 * Use case for calculating scores for a game week
 * Application layer orchestrates domain logic
 */
public class CalculateScoresUseCase {

    private final GameRepository gameRepository;
    private final PlayerRepository playerRepository;
    private final NflDataProvider nflDataProvider;
    private final ScoringService scoringService;

    public CalculateScoresUseCase(
            GameRepository gameRepository,
            PlayerRepository playerRepository,
            NflDataProvider nflDataProvider,
            ScoringService scoringService) {
        this.gameRepository = gameRepository;
        this.playerRepository = playerRepository;
        this.nflDataProvider = nflDataProvider;
        this.scoringService = scoringService;
    }

    public void execute(CalculateScoresCommand command) {
        // Find game
        Game game = gameRepository.findById(command.getGameId())
                .orElseThrow(() -> new IllegalArgumentException("Game not found"));

        // Get all active players
        List<Player> players = playerRepository.findActivePlayersByGameId(game.getId());

        Integer currentSeason = nflDataProvider.getCurrentSeason();

        // Process each player's selection
        for (Player player : players) {
            TeamSelection selection = player.getSelectionForWeek(command.getWeek());

            if (selection == null) {
                // No selection - eliminate player
                player.eliminate();
                continue;
            }

            // Get game stats
            ScoringService.TeamGameStats stats = nflDataProvider.getTeamGameStats(
                    selection.getNflTeamCode(),
                    command.getWeek(),
                    currentSeason
            );

            // Calculate score
            Score score = scoringService.calculateScore(game.getScoringRules(), stats);

            // Check if team won
            boolean won = nflDataProvider.didTeamWin(
                    selection.getNflTeamCode(),
                    command.getWeek(),
                    currentSeason
            );

            if (won) {
                score.recordWin();
            } else {
                score.recordLoss();
                // Eliminate player
                player.eliminate();
            }

            // Complete selection
            selection.completeSelection(score);

            // Save player
            playerRepository.save(player);
        }

        // Advance game week
        game.advanceWeek();
        gameRepository.save(game);
    }

    public static class CalculateScoresCommand {
        private final UUID gameId;
        private final Integer week;

        public CalculateScoresCommand(UUID gameId, Integer week) {
            this.gameId = gameId;
            this.week = week;
        }

        public UUID getGameId() {
            return gameId;
        }

        public Integer getWeek() {
            return week;
        }
    }
}
