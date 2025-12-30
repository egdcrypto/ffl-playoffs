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
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Use case for retrieving league history
 * Shows how standings changed week by week
 */
@Service
@RequiredArgsConstructor
public class GetLeagueHistoryUseCase {

    private final LeaguePlayerRepository leaguePlayerRepository;
    private final PlayoffScoreRepository scoreRepository;

    /**
     * Execute the use case to get league history
     * @param command the command containing league ID
     * @return the league history result
     */
    public LeagueHistoryResult execute(GetLeagueHistoryCommand command) {
        // Get all league players
        List<LeaguePlayer> players = leaguePlayerRepository.findByLeagueId(command.getLeagueId());

        // Map player IDs to names
        Map<UUID, String> playerNames = players.stream()
                .collect(Collectors.toMap(
                        LeaguePlayer::getId,
                        p -> "Player " + p.getId().toString().substring(0, 8)
                ));

        // Get eliminated players (INACTIVE or REMOVED status)
        Map<UUID, Boolean> eliminatedPlayers = players.stream()
                .filter(p -> p.getStatus() == LeaguePlayer.LeaguePlayerStatus.INACTIVE
                        || p.getStatus() == LeaguePlayer.LeaguePlayerStatus.REMOVED)
                .collect(Collectors.toMap(LeaguePlayer::getId, p -> true));

        // Build history for each week
        List<WeekHistory> weekHistories = new ArrayList<>();
        Map<UUID, BigDecimal> cumulativeScores = new HashMap<>();

        for (PlayoffRound round : PlayoffRound.values()) {
            int week = round.getWeekNumber();
            List<RosterScore> weekScores = scoreRepository.findByLeagueIdAndRound(command.getLeagueId(), round);

            if (weekScores.isEmpty()) continue;

            // Update cumulative scores
            for (RosterScore score : weekScores) {
                BigDecimal weekScore = score.getTotalScore() != null ? score.getTotalScore() : BigDecimal.ZERO;
                cumulativeScores.merge(score.getLeaguePlayerId(), weekScore, BigDecimal::add);
            }

            // Build standings for this week
            List<WeekStanding> standings = new ArrayList<>();
            for (Map.Entry<UUID, BigDecimal> entry : cumulativeScores.entrySet()) {
                UUID playerId = entry.getKey();
                BigDecimal totalScore = entry.getValue();

                // Find week score
                BigDecimal weekScore = weekScores.stream()
                        .filter(s -> s.getLeaguePlayerId().equals(playerId))
                        .findFirst()
                        .map(s -> s.getTotalScore() != null ? s.getTotalScore() : BigDecimal.ZERO)
                        .orElse(BigDecimal.ZERO);

                boolean eliminated = eliminatedPlayers.containsKey(playerId);

                WeekStanding standing = new WeekStanding(
                        playerId,
                        playerNames.getOrDefault(playerId, "Unknown"),
                        weekScore,
                        totalScore,
                        eliminated
                );
                standings.add(standing);
            }

            // Sort by cumulative score and assign ranks
            standings.sort(Comparator.comparing(WeekStanding::getCumulativeScore).reversed());
            int rank = 1;
            for (WeekStanding standing : standings) {
                standing.setRank(rank++);
            }

            // Elimination events (no specific week tracking in current model)
            List<EliminationEvent> eliminations = new ArrayList<>();

            weekHistories.add(new WeekHistory(week, round, standings, eliminations));
        }

        return new LeagueHistoryResult(command.getLeagueId(), weekHistories);
    }

    /**
     * Command for getting league history
     */
    public static class GetLeagueHistoryCommand {
        private final UUID leagueId;

        public GetLeagueHistoryCommand(UUID leagueId) {
            this.leagueId = leagueId;
        }

        public UUID getLeagueId() { return leagueId; }
    }

    /**
     * Result containing league history
     */
    public static class LeagueHistoryResult {
        private final UUID leagueId;
        private final List<WeekHistory> weekHistories;

        public LeagueHistoryResult(UUID leagueId, List<WeekHistory> weekHistories) {
            this.leagueId = leagueId;
            this.weekHistories = weekHistories;
        }

        public UUID getLeagueId() { return leagueId; }
        public List<WeekHistory> getWeekHistories() { return weekHistories; }
    }

    /**
     * History for a single week
     */
    public static class WeekHistory {
        private final int week;
        private final PlayoffRound round;
        private final List<WeekStanding> standings;
        private final List<EliminationEvent> eliminations;

        public WeekHistory(int week, PlayoffRound round, List<WeekStanding> standings,
                           List<EliminationEvent> eliminations) {
            this.week = week;
            this.round = round;
            this.standings = standings;
            this.eliminations = eliminations;
        }

        public int getWeek() { return week; }
        public PlayoffRound getRound() { return round; }
        public List<WeekStanding> getStandings() { return standings; }
        public List<EliminationEvent> getEliminations() { return eliminations; }
    }

    /**
     * Standing for a player in a specific week
     */
    public static class WeekStanding {
        private int rank;
        private final UUID playerId;
        private final String playerName;
        private final BigDecimal weekScore;
        private final BigDecimal cumulativeScore;
        private final boolean eliminated;

        public WeekStanding(UUID playerId, String playerName, BigDecimal weekScore,
                            BigDecimal cumulativeScore, boolean eliminated) {
            this.playerId = playerId;
            this.playerName = playerName;
            this.weekScore = weekScore;
            this.cumulativeScore = cumulativeScore;
            this.eliminated = eliminated;
        }

        public int getRank() { return rank; }
        public void setRank(int rank) { this.rank = rank; }
        public UUID getPlayerId() { return playerId; }
        public String getPlayerName() { return playerName; }
        public BigDecimal getWeekScore() { return weekScore; }
        public BigDecimal getCumulativeScore() { return cumulativeScore; }
        public boolean isEliminated() { return eliminated; }
    }

    /**
     * Elimination event
     */
    public static class EliminationEvent {
        private final UUID playerId;
        private final String playerName;
        private final int week;

        public EliminationEvent(UUID playerId, String playerName, int week) {
            this.playerId = playerId;
            this.playerName = playerName;
            this.week = week;
        }

        public UUID getPlayerId() { return playerId; }
        public String getPlayerName() { return playerName; }
        public int getWeek() { return week; }
    }
}
