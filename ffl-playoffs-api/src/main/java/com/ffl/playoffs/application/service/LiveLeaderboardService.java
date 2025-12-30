package com.ffl.playoffs.application.service;

import com.ffl.playoffs.application.dto.LiveLeaderboardDTO;
import com.ffl.playoffs.application.dto.LiveLeaderboardDTO.LiveLeaderboardEntryDTO;
import com.ffl.playoffs.domain.model.LiveScoreStatus;
import com.ffl.playoffs.domain.model.RankChange;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.LiveScoreRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * Service for live leaderboard operations
 * Handles real-time ranking calculations and updates
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LiveLeaderboardService {

    private final LiveScoreRepository liveScoreRepository;
    private final LeaguePlayerRepository leaguePlayerRepository;

    // Cache for previous rankings
    private final Map<String, Map<String, Integer>> previousRankings = new ConcurrentHashMap<>();
    // Cache for score deltas since last user view
    private final Map<String, Map<String, BigDecimal>> scoreDeltaCache = new ConcurrentHashMap<>();

    private static final int DEFAULT_PAGE_SIZE = 25;

    /**
     * Get paginated live leaderboard for a league
     */
    public LiveLeaderboardDTO getLeaderboard(String leagueId, int page, int pageSize) {
        Map<String, BigDecimal> scores = liveScoreRepository.getAllScoresForLeague(leagueId);

        // Sort by score descending
        List<LeaderboardEntry> entries = scores.entrySet().stream()
                .map(e -> new LeaderboardEntry(e.getKey(), e.getValue()))
                .sorted(Comparator.comparing(LeaderboardEntry::score).reversed())
                .toList();

        return buildLeaderboardDTO(leagueId, entries, page, pageSize);
    }

    /**
     * Get leaderboard filtered to a specific matchup
     */
    public LiveLeaderboardDTO getMatchupLeaderboard(String leagueId, String player1Id, String player2Id) {
        Map<String, BigDecimal> scores = liveScoreRepository.getAllScoresForLeague(leagueId);

        List<LeaderboardEntry> entries = scores.entrySet().stream()
                .filter(e -> e.getKey().equals(player1Id) || e.getKey().equals(player2Id))
                .map(e -> new LeaderboardEntry(e.getKey(), e.getValue()))
                .sorted(Comparator.comparing(LeaderboardEntry::score).reversed())
                .toList();

        return buildLeaderboardDTO(leagueId, entries, 0, 2);
    }

    /**
     * Calculate rank changes after a score update
     */
    public List<RankChange> calculateRankChanges(String leagueId, Map<String, BigDecimal> newScores) {
        List<RankChange> changes = new ArrayList<>();
        Map<String, Integer> previousRanks = previousRankings.getOrDefault(leagueId, new HashMap<>());

        // Sort new scores
        List<Map.Entry<String, BigDecimal>> sorted = newScores.entrySet().stream()
                .sorted(Map.Entry.<String, BigDecimal>comparingByValue().reversed())
                .toList();

        BigDecimal leaderScore = sorted.isEmpty() ? BigDecimal.ZERO : sorted.get(0).getValue();
        String leaderName = sorted.isEmpty() ? "" : sorted.get(0).getKey();

        int newRank = 1;
        Map<String, Integer> newRanks = new HashMap<>();

        for (Map.Entry<String, BigDecimal> entry : sorted) {
            String playerId = entry.getKey();
            int previousRank = previousRanks.getOrDefault(playerId, newRank);
            newRanks.put(playerId, newRank);

            if (previousRank != newRank) {
                RankChange change = RankChange.builder()
                        .leaguePlayerId(playerId)
                        .leagueId(leagueId)
                        .previousRank(previousRank)
                        .newRank(newRank)
                        .leaderName(leaderName)
                        .pointsBehindLeader(leaderScore.subtract(entry.getValue()))
                        .currentScore(entry.getValue())
                        .build();
                changes.add(change);
            }
            newRank++;
        }

        // Update cached rankings
        previousRankings.put(leagueId, newRanks);

        return changes;
    }

    /**
     * Get score delta for a player since their last view
     */
    public BigDecimal getScoreDeltaSinceLastView(String leagueId, String leaguePlayerId) {
        Map<String, BigDecimal> leagueDelta = scoreDeltaCache.getOrDefault(leagueId, new HashMap<>());
        return leagueDelta.getOrDefault(leaguePlayerId, BigDecimal.ZERO);
    }

    /**
     * Record score delta when score changes
     */
    public void recordScoreDelta(String leagueId, String leaguePlayerId, BigDecimal delta) {
        scoreDeltaCache.computeIfAbsent(leagueId, k -> new ConcurrentHashMap<>())
                .merge(leaguePlayerId, delta, BigDecimal::add);
    }

    /**
     * Clear delta for player (when they view leaderboard)
     */
    public void clearScoreDelta(String leagueId, String leaguePlayerId) {
        Map<String, BigDecimal> leagueDelta = scoreDeltaCache.get(leagueId);
        if (leagueDelta != null) {
            leagueDelta.remove(leaguePlayerId);
        }
    }

    /**
     * Get players with live games (for LIVE indicator)
     */
    public List<String> getPlayersWithLiveGames(String leagueId) {
        // TODO: Implement by checking roster slots against in-progress games
        return List.of();
    }

    /**
     * Build the leaderboard DTO
     */
    private LiveLeaderboardDTO buildLeaderboardDTO(String leagueId, List<LeaderboardEntry> allEntries,
                                                    int page, int pageSize) {
        int actualPageSize = pageSize > 0 ? pageSize : DEFAULT_PAGE_SIZE;
        int start = page * actualPageSize;
        int end = Math.min(start + actualPageSize, allEntries.size());

        if (start >= allEntries.size()) {
            start = 0;
            end = Math.min(actualPageSize, allEntries.size());
        }

        List<LeaderboardEntry> pageEntries = allEntries.subList(start, end);
        BigDecimal leaderScore = allEntries.isEmpty() ? BigDecimal.ZERO : allEntries.get(0).score();
        Map<String, Integer> previousRanks = previousRankings.getOrDefault(leagueId, new HashMap<>());

        List<LiveLeaderboardEntryDTO> entries = new ArrayList<>();
        int rank = start + 1;

        for (LeaderboardEntry entry : pageEntries) {
            LiveLeaderboardEntryDTO dto = new LiveLeaderboardEntryDTO();
            dto.setRank(rank);
            dto.setPreviousRank(previousRanks.getOrDefault(entry.playerId(), rank));
            dto.setRankDelta(dto.getPreviousRank() - rank);
            dto.setLeaguePlayerId(entry.playerId());
            dto.setTotalScore(entry.score());
            dto.setScoreDelta(getScoreDeltaSinceLastView(leagueId, entry.playerId()));
            dto.setPointsBehindLeader(leaderScore.subtract(entry.score()));
            dto.setStatus(liveScoreRepository.getScoreStatus(entry.playerId()));
            dto.setLastScoreUpdate(
                    liveScoreRepository.getRecentUpdates(entry.playerId(), LocalDateTime.now().minusMinutes(30))
                            .stream()
                            .findFirst()
                            .map(u -> u.getTimestamp())
                            .orElse(null)
            );
            entries.add(dto);
            rank++;
        }

        LiveLeaderboardDTO leaderboard = new LiveLeaderboardDTO();
        leaderboard.setLeagueId(leagueId);
        leaderboard.setEntries(entries);
        leaderboard.setTotalPlayers(allEntries.size());
        leaderboard.setPage(page);
        leaderboard.setPageSize(actualPageSize);
        leaderboard.setLastUpdated(liveScoreRepository.getLastUpdateTime(leagueId).orElse(LocalDateTime.now()));
        leaderboard.setLive(entries.stream().anyMatch(e -> e.getStatus() == LiveScoreStatus.LIVE));

        return leaderboard;
    }

    /**
     * Clear cached data for a league
     */
    public void clearCache(String leagueId) {
        previousRankings.remove(leagueId);
        scoreDeltaCache.remove(leagueId);
    }

    private record LeaderboardEntry(String playerId, BigDecimal score) {}
}
