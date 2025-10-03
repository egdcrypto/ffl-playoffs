package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.event.TeamEliminatedEvent;
import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.model.Week;
import com.ffl.playoffs.domain.port.GameRepository;
import com.ffl.playoffs.domain.port.PlayerRepository;
import com.ffl.playoffs.domain.service.ScoringService;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Use case for calculating scores and determining eliminations for a week.
 */
public class CalculateScoresUseCase {
    
    private final GameRepository gameRepository;
    private final PlayerRepository playerRepository;
    private final ScoringService scoringService;

    public CalculateScoresUseCase(GameRepository gameRepository,
                                 PlayerRepository playerRepository,
                                 ScoringService scoringService) {
        this.gameRepository = gameRepository;
        this.playerRepository = playerRepository;
        this.scoringService = scoringService;
    }

    public Map<UUID, Score> execute(UUID gameId, Integer weekNumber, Integer nflWeek, Integer season) {
        // Get game
        Game game = gameRepository.findById(gameId)
                .orElseThrow(() -> new IllegalArgumentException("Game not found"));
        
        // Get all active players for this game
        List<Player> activePlayers = playerRepository.findByGameId(gameId).stream()
                .filter(p -> !p.isEliminated())
                .collect(Collectors.toList());
        
        if (activePlayers.isEmpty()) {
            return Collections.emptyMap();
        }
        
        // Calculate scores for each player's selection
        Map<UUID, Score> playerScores = new HashMap<>();
        for (Player player : activePlayers) {
            TeamSelection selection = findSelectionForWeek(player, weekNumber);
            if (selection != null) {
                Score score = scoringService.calculateScore(
                    selection.getId(),
                    selection.getTeamCode(),
                    nflWeek,
                    season
                );
                selection.setScore(score.getTotalScore());
                playerScores.put(player.getId(), score);
            }
        }
        
        // Determine lowest score(s) and eliminate
        if (!playerScores.isEmpty()) {
            double lowestScore = playerScores.values().stream()
                    .mapToDouble(Score::getTotalScore)
                    .min()
                    .orElse(0.0);
            
            // Eliminate all players with lowest score
            for (Player player : activePlayers) {
                Score score = playerScores.get(player.getId());
                if (score != null && score.getTotalScore() == lowestScore) {
                    player.eliminate();
                    playerRepository.save(player);
                    
                    // Publish elimination event
                    TeamEliminatedEvent event = new TeamEliminatedEvent(
                        player.getId(),
                        gameId,
                        weekNumber,
                        "Lowest score in week " + weekNumber
                    );
                }
            }
        }
        
        return playerScores;
    }

    private TeamSelection findSelectionForWeek(Player player, Integer weekNumber) {
        // In a real implementation, we'd match by week ID
        // For now, we'll use a simple index-based approach
        List<TeamSelection> selections = player.getTeamSelections();
        if (selections.size() > weekNumber - 1) {
            return selections.get(weekNumber - 1);
        }
        return null;
    }
}
