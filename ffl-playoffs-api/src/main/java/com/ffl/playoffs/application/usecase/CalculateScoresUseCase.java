package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.port.GameRepository;
import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.domain.port.PlayerRepository;
import com.ffl.playoffs.domain.service.ScoringService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;

/**
 * Use case for calculating scores for a week.
 */
@Service
@RequiredArgsConstructor
public class CalculateScoresUseCase {

    private final GameRepository gameRepository;
    private final PlayerRepository playerRepository;
    private final NflDataProvider nflDataProvider;
    private final ScoringService scoringService;

    @Transactional
    public void execute(UUID gameId, Integer weekNumber) {
        Game game = gameRepository.findById(gameId)
                .orElseThrow(() -> new IllegalArgumentException("Game not found: " + gameId));

        List<Player> players = playerRepository.findActivePlayersByGameId(gameId);

        for (Player player : players) {
            TeamSelection selection = player.getTeamSelections().stream()
                    .filter(ts -> ts.getWeekNumber().equals(weekNumber))
                    .findFirst()
                    .orElse(null);

            if (selection != null && !selection.hasBeenScored()) {
                Score score = nflDataProvider.getTeamScore(selection.getNflTeam(), weekNumber);
                scoringService.applyScore(selection, score, game.getScoringRules());
                player.updateScore(selection.getPointsEarned());
                playerRepository.save(player);
            }
        }
    }
}
