package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.LeaguePlayer;
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

/**
 * Use case for retrieving league standings
 * Returns players ranked by total points across all weeks
 */
@Service
@RequiredArgsConstructor
public class GetLeagueStandingsUseCase {

    private final LeaguePlayerRepository leaguePlayerRepository;
    private final PlayoffScoreRepository scoreRepository;

    /**
     * Execute the use case to get league standings
     * @param command the command containing league ID and filter options
     * @return the standings result
     */
    public StandingsResult execute(GetStandingsCommand command) {
        // Get all league players
        List<LeaguePlayer> players = leaguePlayerRepository.findByLeagueId(command.getLeagueId());

        // Get cumulative scores for all players
        Map<UUID, BigDecimal> cumulativeScores = scoreRepository.getCumulativeScores(command.getLeagueId());

        // Build standings entries
        List<StandingEntry> entries = new ArrayList<>();
        for (LeaguePlayer player : players) {
            boolean isEliminated = player.getStatus() == LeaguePlayer.LeaguePlayerStatus.INACTIVE
                    || player.getStatus() == LeaguePlayer.LeaguePlayerStatus.REMOVED;

            // Skip eliminated players if not including them
            if (!command.isIncludeEliminated() && isEliminated) {
                continue;
            }

            BigDecimal totalScore = cumulativeScores.getOrDefault(player.getId(), BigDecimal.ZERO);
            String displayName = "Player " + player.getId().toString().substring(0, 8);

            StandingEntry entry = new StandingEntry(
                    player.getId(),
                    displayName,
                    totalScore,
                    isEliminated,
                    null // Week tracking not available in current model
            );
            entries.add(entry);
        }

        // Sort by total score descending
        entries.sort(Comparator.comparing(StandingEntry::getTotalScore).reversed());

        // Assign ranks
        int rank = 1;
        for (StandingEntry entry : entries) {
            entry.setRank(rank++);
        }

        return new StandingsResult(command.getLeagueId(), entries, entries.size());
    }

    /**
     * Command for getting standings
     */
    public static class GetStandingsCommand {
        private final UUID leagueId;
        private final boolean includeEliminated;

        public GetStandingsCommand(UUID leagueId, boolean includeEliminated) {
            this.leagueId = leagueId;
            this.includeEliminated = includeEliminated;
        }

        public UUID getLeagueId() { return leagueId; }
        public boolean isIncludeEliminated() { return includeEliminated; }
    }

    /**
     * Result containing standings
     */
    public static class StandingsResult {
        private final UUID leagueId;
        private final List<StandingEntry> standings;
        private final int totalPlayers;

        public StandingsResult(UUID leagueId, List<StandingEntry> standings, int totalPlayers) {
            this.leagueId = leagueId;
            this.standings = standings;
            this.totalPlayers = totalPlayers;
        }

        public UUID getLeagueId() { return leagueId; }
        public List<StandingEntry> getStandings() { return standings; }
        public int getTotalPlayers() { return totalPlayers; }
    }

    /**
     * Individual standing entry
     */
    public static class StandingEntry {
        private int rank;
        private final UUID playerId;
        private final String playerName;
        private final BigDecimal totalScore;
        private final boolean eliminated;
        private final Integer eliminatedWeek;

        public StandingEntry(UUID playerId, String playerName, BigDecimal totalScore,
                             boolean eliminated, Integer eliminatedWeek) {
            this.playerId = playerId;
            this.playerName = playerName;
            this.totalScore = totalScore;
            this.eliminated = eliminated;
            this.eliminatedWeek = eliminatedWeek;
        }

        public int getRank() { return rank; }
        public void setRank(int rank) { this.rank = rank; }
        public UUID getPlayerId() { return playerId; }
        public String getPlayerName() { return playerName; }
        public BigDecimal getTotalScore() { return totalScore; }
        public boolean isEliminated() { return eliminated; }
        public Integer getEliminatedWeek() { return eliminatedWeek; }
    }
}
