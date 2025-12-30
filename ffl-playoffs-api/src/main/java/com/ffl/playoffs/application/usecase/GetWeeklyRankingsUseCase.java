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
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Use case for retrieving weekly rankings
 * Returns players ranked by score for a specific week
 */
@Service
@RequiredArgsConstructor
public class GetWeeklyRankingsUseCase {

    private final LeaguePlayerRepository leaguePlayerRepository;
    private final PlayoffScoreRepository scoreRepository;

    /**
     * Execute the use case to get weekly rankings
     * @param command the command containing league ID and week
     * @return the weekly rankings result
     */
    public WeeklyRankingsResult execute(GetWeeklyRankingsCommand command) {
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

        // Build ranking entries
        List<WeeklyRankingEntry> entries = new ArrayList<>();
        for (LeaguePlayer player : players) {
            // Skip inactive/removed players
            if (player.getStatus() == LeaguePlayer.LeaguePlayerStatus.INACTIVE
                    || player.getStatus() == LeaguePlayer.LeaguePlayerStatus.REMOVED) {
                continue;
            }

            BigDecimal weekScore = scoreMap.getOrDefault(player.getId(), BigDecimal.ZERO);
            String displayName = "Player " + player.getId().toString().substring(0, 8);

            WeeklyRankingEntry entry = new WeeklyRankingEntry(
                    player.getId(),
                    displayName,
                    weekScore
            );
            entries.add(entry);
        }

        // Sort by week score descending
        entries.sort(Comparator.comparing(WeeklyRankingEntry::getWeekScore).reversed());

        // Assign ranks
        int rank = 1;
        for (WeeklyRankingEntry entry : entries) {
            entry.setRank(rank++);
        }

        return new WeeklyRankingsResult(command.getLeagueId(), command.getWeek(), round, entries);
    }

    /**
     * Command for getting weekly rankings
     */
    public static class GetWeeklyRankingsCommand {
        private final UUID leagueId;
        private final int week;

        public GetWeeklyRankingsCommand(UUID leagueId, int week) {
            this.leagueId = leagueId;
            this.week = week;
        }

        public UUID getLeagueId() { return leagueId; }
        public int getWeek() { return week; }
    }

    /**
     * Result containing weekly rankings
     */
    public static class WeeklyRankingsResult {
        private final UUID leagueId;
        private final int week;
        private final PlayoffRound round;
        private final List<WeeklyRankingEntry> rankings;

        public WeeklyRankingsResult(UUID leagueId, int week, PlayoffRound round, List<WeeklyRankingEntry> rankings) {
            this.leagueId = leagueId;
            this.week = week;
            this.round = round;
            this.rankings = rankings;
        }

        public UUID getLeagueId() { return leagueId; }
        public int getWeek() { return week; }
        public PlayoffRound getRound() { return round; }
        public List<WeeklyRankingEntry> getRankings() { return rankings; }
    }

    /**
     * Individual weekly ranking entry
     */
    public static class WeeklyRankingEntry {
        private int rank;
        private final UUID playerId;
        private final String playerName;
        private final BigDecimal weekScore;

        public WeeklyRankingEntry(UUID playerId, String playerName, BigDecimal weekScore) {
            this.playerId = playerId;
            this.playerName = playerName;
            this.weekScore = weekScore;
        }

        public int getRank() { return rank; }
        public void setRank(int rank) { this.rank = rank; }
        public UUID getPlayerId() { return playerId; }
        public String getPlayerName() { return playerName; }
        public BigDecimal getWeekScore() { return weekScore; }
    }
}
