package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.model.RosterScore;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.PlayoffScoreRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;
import java.util.Map;
import java.util.UUID;

/**
 * Use case for retrieving aggregate league statistics
 * Provides league-wide metrics and trends
 */
@Service
@RequiredArgsConstructor
public class GetLeagueStatsUseCase {

    private final LeaguePlayerRepository leaguePlayerRepository;
    private final PlayoffScoreRepository scoreRepository;

    /**
     * Execute the use case to get league statistics
     * @param command the command containing league ID
     * @return the league stats result
     */
    public LeagueStatsResult execute(GetLeagueStatsCommand command) {
        // Get all league players
        List<LeaguePlayer> players = leaguePlayerRepository.findByLeagueId(command.getLeagueId());

        int totalPlayers = players.size();
        int activePlayers = (int) players.stream()
                .filter(p -> p.getStatus() == LeaguePlayer.LeaguePlayerStatus.ACTIVE)
                .count();
        int eliminatedPlayers = (int) players.stream()
                .filter(p -> p.getStatus() == LeaguePlayer.LeaguePlayerStatus.INACTIVE
                        || p.getStatus() == LeaguePlayer.LeaguePlayerStatus.REMOVED)
                .count();

        // Get cumulative scores
        Map<UUID, BigDecimal> cumulativeScores = scoreRepository.getCumulativeScores(command.getLeagueId());

        // Find highest and lowest scores
        BigDecimal highestScore = BigDecimal.ZERO;
        BigDecimal lowestScore = null;
        BigDecimal totalScore = BigDecimal.ZERO;
        UUID leaderId = null;
        String leaderName = null;

        for (LeaguePlayer player : players) {
            BigDecimal score = cumulativeScores.getOrDefault(player.getId(), BigDecimal.ZERO);
            totalScore = totalScore.add(score);

            if (score.compareTo(highestScore) > 0) {
                highestScore = score;
                leaderId = player.getId();
                leaderName = "Player " + player.getId().toString().substring(0, 8);
            }

            if (lowestScore == null || (score.compareTo(BigDecimal.ZERO) > 0 && score.compareTo(lowestScore) < 0)) {
                lowestScore = score;
            }
        }

        // Calculate average score
        BigDecimal averageScore = totalPlayers > 0 ?
                totalScore.divide(BigDecimal.valueOf(totalPlayers), 2, RoundingMode.HALF_UP) :
                BigDecimal.ZERO;

        // Find highest single-week score across all players
        BigDecimal highestWeeklyScore = BigDecimal.ZERO;
        BigDecimal lowestWeeklyScore = null;

        for (LeaguePlayer player : players) {
            List<RosterScore> playerScores = scoreRepository.findByPlayerId(player.getId());
            for (RosterScore score : playerScores) {
                BigDecimal weekScore = score.getTotalScore() != null ? score.getTotalScore() : BigDecimal.ZERO;

                if (weekScore.compareTo(highestWeeklyScore) > 0) {
                    highestWeeklyScore = weekScore;
                }
                if (lowestWeeklyScore == null ||
                        (weekScore.compareTo(BigDecimal.ZERO) > 0 && weekScore.compareTo(lowestWeeklyScore) < 0)) {
                    lowestWeeklyScore = weekScore;
                }
            }
        }

        return new LeagueStatsResult(
                command.getLeagueId(),
                totalPlayers,
                activePlayers,
                eliminatedPlayers,
                highestWeeklyScore,
                lowestWeeklyScore != null ? lowestWeeklyScore : BigDecimal.ZERO,
                averageScore,
                highestScore,
                leaderId,
                leaderName
        );
    }

    /**
     * Command for getting league stats
     */
    public static class GetLeagueStatsCommand {
        private final UUID leagueId;

        public GetLeagueStatsCommand(UUID leagueId) {
            this.leagueId = leagueId;
        }

        public UUID getLeagueId() { return leagueId; }
    }

    /**
     * Result containing league statistics
     */
    public static class LeagueStatsResult {
        private final UUID leagueId;
        private final int totalPlayers;
        private final int activePlayers;
        private final int eliminatedPlayers;
        private final BigDecimal highestSingleWeekScore;
        private final BigDecimal lowestSingleWeekScore;
        private final BigDecimal averageScore;
        private final BigDecimal highestTotalScore;
        private final UUID currentLeaderId;
        private final String currentLeaderName;

        public LeagueStatsResult(UUID leagueId, int totalPlayers, int activePlayers,
                                 int eliminatedPlayers, BigDecimal highestSingleWeekScore,
                                 BigDecimal lowestSingleWeekScore, BigDecimal averageScore,
                                 BigDecimal highestTotalScore, UUID currentLeaderId,
                                 String currentLeaderName) {
            this.leagueId = leagueId;
            this.totalPlayers = totalPlayers;
            this.activePlayers = activePlayers;
            this.eliminatedPlayers = eliminatedPlayers;
            this.highestSingleWeekScore = highestSingleWeekScore;
            this.lowestSingleWeekScore = lowestSingleWeekScore;
            this.averageScore = averageScore;
            this.highestTotalScore = highestTotalScore;
            this.currentLeaderId = currentLeaderId;
            this.currentLeaderName = currentLeaderName;
        }

        public UUID getLeagueId() { return leagueId; }
        public int getTotalPlayers() { return totalPlayers; }
        public int getActivePlayers() { return activePlayers; }
        public int getEliminatedPlayers() { return eliminatedPlayers; }
        public BigDecimal getHighestSingleWeekScore() { return highestSingleWeekScore; }
        public BigDecimal getLowestSingleWeekScore() { return lowestSingleWeekScore; }
        public BigDecimal getAverageScore() { return averageScore; }
        public BigDecimal getHighestTotalScore() { return highestTotalScore; }
        public UUID getCurrentLeaderId() { return currentLeaderId; }
        public String getCurrentLeaderName() { return currentLeaderName; }
    }
}
