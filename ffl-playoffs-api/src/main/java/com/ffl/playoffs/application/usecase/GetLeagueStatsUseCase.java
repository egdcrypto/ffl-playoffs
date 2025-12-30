package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.LeagueStatsDTO;
import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.UUID;

/**
 * Use case for retrieving aggregate league statistics.
 * Provides high-level statistics about a league's performance.
 *
 * Hexagonal Architecture: Application layer use case
 */
@Service
@RequiredArgsConstructor
@Slf4j
public class GetLeagueStatsUseCase {

    private final LeaguePlayerRepository leaguePlayerRepository;

    /**
     * Execute the use case to get league statistics
     *
     * @param leagueId the league ID
     * @return aggregate league statistics
     */
    public LeagueStatsDTO execute(UUID leagueId) {
        log.info("Getting league statistics for leagueId={}", leagueId);

        List<LeaguePlayer> allPlayers = leaguePlayerRepository.findByLeagueId(leagueId);
        List<LeaguePlayer> activePlayers = leaguePlayerRepository.findActivePlayersByLeagueId(leagueId);

        int totalPlayers = allPlayers.size();
        int activePlayersCount = activePlayers.size();
        int eliminatedPlayersCount = totalPlayers - activePlayersCount;

        // Calculate scoring statistics
        double highestScore = 0;
        double lowestScore = Double.MAX_VALUE;
        double totalScoreSum = 0;
        String currentLeader = null;
        double leaderScore = 0;

        for (LeaguePlayer player : allPlayers) {
            Double playerScore = player.getTotalScore();
            double score = playerScore != null ? playerScore : 0;
            totalScoreSum += score;

            if (score > highestScore) {
                highestScore = score;
            }
            if (score > 0 && score < lowestScore) {
                lowestScore = score;
            }
            if (score > leaderScore) {
                leaderScore = score;
                currentLeader = player.getDisplayName() != null ? player.getDisplayName() : "Unknown";
            }
        }

        double averageScore = totalPlayers > 0 ? totalScoreSum / totalPlayers : 0;

        if (lowestScore == Double.MAX_VALUE) {
            lowestScore = 0;
        }

        LeagueStatsDTO stats = new LeagueStatsDTO();
        stats.setLeagueId(leagueId);
        stats.setTotalPlayers(totalPlayers);
        stats.setActivePlayers(activePlayersCount);
        stats.setEliminatedPlayers(eliminatedPlayersCount);
        stats.setHighestScore(highestScore);
        stats.setLowestScore(lowestScore);
        stats.setAverageScore(averageScore);
        stats.setCurrentLeader(currentLeader);
        stats.setLeaderScore(leaderScore);

        log.info("Retrieved league statistics: {} total players, {} active", totalPlayers, activePlayersCount);
        return stats;
    }
}
