package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.model.RosterScore;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.PlayoffScoreRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Use case for retrieving head-to-head matchups
 * Shows how each player compares against others in a week
 */
@Service
@RequiredArgsConstructor
public class GetMatchupsUseCase {

    private final LeaguePlayerRepository leaguePlayerRepository;
    private final PlayoffScoreRepository scoreRepository;

    /**
     * Execute the use case to get matchups
     * @param command the command containing league ID and week
     * @return the matchups result
     */
    public MatchupsResult execute(GetMatchupsCommand command) {
        // Get all league players
        List<LeaguePlayer> players = leaguePlayerRepository.findByLeagueId(command.getLeagueId());

        // Convert week to playoff round
        PlayoffRound round = PlayoffRound.fromWeekNumber(command.getWeek());

        // Get scores for the week
        List<RosterScore> weekScores = scoreRepository.findByLeagueIdAndRound(command.getLeagueId(), round);

        // Map scores by player ID
        Map<UUID, BigDecimal> scoreMap = weekScores.stream()
                .collect(Collectors.toMap(
                        RosterScore::getLeaguePlayerId,
                        s -> s.getTotalScore() != null ? s.getTotalScore() : BigDecimal.ZERO
                ));

        // Build matchup comparisons - compare each player against all others
        List<PlayerMatchupRecord> matchupRecords = new ArrayList<>();

        for (LeaguePlayer player : players) {
            if (player.getStatus() == LeaguePlayer.LeaguePlayerStatus.INACTIVE
                    || player.getStatus() == LeaguePlayer.LeaguePlayerStatus.REMOVED) continue;

            BigDecimal playerScore = scoreMap.getOrDefault(player.getId(), BigDecimal.ZERO);
            int wins = 0;
            int losses = 0;
            int ties = 0;

            List<HeadToHeadResult> headToHeadResults = new ArrayList<>();

            for (LeaguePlayer opponent : players) {
                if (opponent.getId().equals(player.getId())) continue;
                if (opponent.getStatus() == LeaguePlayer.LeaguePlayerStatus.INACTIVE
                        || opponent.getStatus() == LeaguePlayer.LeaguePlayerStatus.REMOVED) continue;

                BigDecimal opponentScore = scoreMap.getOrDefault(opponent.getId(), BigDecimal.ZERO);
                String result;

                if (playerScore.compareTo(opponentScore) > 0) {
                    result = "WIN";
                    wins++;
                } else if (playerScore.compareTo(opponentScore) < 0) {
                    result = "LOSS";
                    losses++;
                } else {
                    result = "TIE";
                    ties++;
                }

                HeadToHeadResult h2h = new HeadToHeadResult(
                        opponent.getId(),
                        "Player " + opponent.getId().toString().substring(0, 8),
                        opponentScore,
                        result,
                        playerScore.subtract(opponentScore)
                );
                headToHeadResults.add(h2h);
            }

            PlayerMatchupRecord record = new PlayerMatchupRecord(
                    player.getId(),
                    "Player " + player.getId().toString().substring(0, 8),
                    playerScore,
                    wins,
                    losses,
                    ties,
                    headToHeadResults
            );
            matchupRecords.add(record);
        }

        // Sort by wins descending
        matchupRecords.sort((a, b) -> {
            int winsCompare = Integer.compare(b.getWins(), a.getWins());
            if (winsCompare != 0) return winsCompare;
            return b.getWeekScore().compareTo(a.getWeekScore());
        });

        return new MatchupsResult(command.getLeagueId(), command.getWeek(), matchupRecords);
    }

    /**
     * Command for getting matchups
     */
    public static class GetMatchupsCommand {
        private final UUID leagueId;
        private final int week;

        public GetMatchupsCommand(UUID leagueId, int week) {
            this.leagueId = leagueId;
            this.week = week;
        }

        public UUID getLeagueId() { return leagueId; }
        public int getWeek() { return week; }
    }

    /**
     * Result containing matchups
     */
    public static class MatchupsResult {
        private final UUID leagueId;
        private final int week;
        private final List<PlayerMatchupRecord> matchupRecords;

        public MatchupsResult(UUID leagueId, int week, List<PlayerMatchupRecord> matchupRecords) {
            this.leagueId = leagueId;
            this.week = week;
            this.matchupRecords = matchupRecords;
        }

        public UUID getLeagueId() { return leagueId; }
        public int getWeek() { return week; }
        public List<PlayerMatchupRecord> getMatchupRecords() { return matchupRecords; }
    }

    /**
     * Matchup record for a player
     */
    public static class PlayerMatchupRecord {
        private final UUID playerId;
        private final String playerName;
        private final BigDecimal weekScore;
        private final int wins;
        private final int losses;
        private final int ties;
        private final List<HeadToHeadResult> headToHeadResults;

        public PlayerMatchupRecord(UUID playerId, String playerName, BigDecimal weekScore,
                                   int wins, int losses, int ties,
                                   List<HeadToHeadResult> headToHeadResults) {
            this.playerId = playerId;
            this.playerName = playerName;
            this.weekScore = weekScore;
            this.wins = wins;
            this.losses = losses;
            this.ties = ties;
            this.headToHeadResults = headToHeadResults;
        }

        public UUID getPlayerId() { return playerId; }
        public String getPlayerName() { return playerName; }
        public BigDecimal getWeekScore() { return weekScore; }
        public int getWins() { return wins; }
        public int getLosses() { return losses; }
        public int getTies() { return ties; }
        public List<HeadToHeadResult> getHeadToHeadResults() { return headToHeadResults; }
    }

    /**
     * Head-to-head comparison result
     */
    public static class HeadToHeadResult {
        private final UUID opponentId;
        private final String opponentName;
        private final BigDecimal opponentScore;
        private final String result;
        private final BigDecimal margin;

        public HeadToHeadResult(UUID opponentId, String opponentName, BigDecimal opponentScore,
                                String result, BigDecimal margin) {
            this.opponentId = opponentId;
            this.opponentName = opponentName;
            this.opponentScore = opponentScore;
            this.result = result;
            this.margin = margin;
        }

        public UUID getOpponentId() { return opponentId; }
        public String getOpponentName() { return opponentName; }
        public BigDecimal getOpponentScore() { return opponentScore; }
        public String getResult() { return result; }
        public BigDecimal getMargin() { return margin; }
    }
}
