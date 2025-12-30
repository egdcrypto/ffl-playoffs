package com.ffl.playoffs.application.service;

import com.ffl.playoffs.application.dto.LiveLeaderboardDTO;
import com.ffl.playoffs.application.dto.LiveScoreDTO;
import com.ffl.playoffs.domain.event.GameCompletedEvent;
import com.ffl.playoffs.domain.event.LeaderboardRankChangedEvent;
import com.ffl.playoffs.domain.event.PlayerStatsUpdatedEvent;
import com.ffl.playoffs.domain.event.RosterScoreChangedEvent;
import com.ffl.playoffs.domain.model.LiveScoreStatus;
import com.ffl.playoffs.domain.model.PlayerStats;
import com.ffl.playoffs.domain.model.RankChange;
import com.ffl.playoffs.domain.model.ScoreUpdate;
import com.ffl.playoffs.domain.model.nfl.NFLGameStatus;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.LiveScoreBroadcastPort;
import com.ffl.playoffs.domain.port.LiveScoreRepository;
import com.ffl.playoffs.domain.port.NflLiveDataPort;
import com.ffl.playoffs.domain.port.RosterRepository;
import com.ffl.playoffs.domain.service.ScoringService;
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
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Main service for live scoring operations
 * Orchestrates polling, score calculation, and broadcasts
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class LiveScoringService {

    private final NflLiveDataPort nflDataPort;
    private final LiveScoreRepository liveScoreRepository;
    private final LiveScoreBroadcastPort broadcastPort;
    private final ScoringService scoringService;
    private final RosterRepository rosterRepository;
    private final LeagueRepository leagueRepository;
    private final LeaguePlayerRepository leaguePlayerRepository;

    // Cache for previous scores to calculate deltas
    private final Map<String, BigDecimal> previousScoreCache = new ConcurrentHashMap<>();
    // Cache for previous ranks to detect changes
    private final Map<String, Integer> previousRankCache = new ConcurrentHashMap<>();

    /**
     * Poll for live stats and update scores
     * Called by scheduled task every 30 seconds
     */
    public void pollAndUpdateScores(int week, int season, String leagueId) {
        log.info("Polling live stats for week {} season {} league {}", week, season, leagueId);

        try {
            // Check if data source is available
            if (!nflDataPort.isAvailable()) {
                log.warn("NFL data source unavailable, using cached data");
                broadcastPort.broadcastDataDelayWarning(leagueId, "Data source temporarily unavailable", 60);
                return;
            }

            // Get games in progress
            List<UUID> gamesInProgress = nflDataPort.getGamesInProgress(week, season);
            if (gamesInProgress.isEmpty()) {
                log.debug("No games currently in progress for week {} season {}", week, season);
                return;
            }

            // Fetch live player stats for all in-progress games
            List<PlayerStats> liveStats = nflDataPort.fetchLivePlayerStats(week, season);
            if (liveStats.isEmpty()) {
                log.warn("No player stats returned from poll");
                return;
            }

            // Process stats and update roster scores
            List<ScoreUpdate> scoreUpdates = processLiveStats(liveStats, leagueId, week, season);

            // Save score updates in batch
            if (!scoreUpdates.isEmpty()) {
                liveScoreRepository.saveAll(scoreUpdates);
                log.info("Saved {} score updates", scoreUpdates.size());
            }

            // Update leaderboard and broadcast
            updateAndBroadcastLeaderboard(leagueId);

            // Check for game completions
            checkAndHandleGameCompletions(week, season, leagueId);

        } catch (Exception e) {
            log.error("Error polling live stats: {}", e.getMessage(), e);
            broadcastPort.broadcastDataDelayWarning(leagueId, "Error fetching live data", 30);
        }
    }

    /**
     * Process live stats and calculate roster score updates
     */
    private List<ScoreUpdate> processLiveStats(List<PlayerStats> stats, String leagueId, int week, int season) {
        List<ScoreUpdate> updates = new ArrayList<>();

        // Get all rosters for this league
        var rosters = rosterRepository.findByLeagueId(leagueId);

        for (var roster : rosters) {
            String leaguePlayerId = roster.getLeaguePlayerId().toString();

            // Calculate new score based on current stats
            BigDecimal newScore = calculateRosterScore(roster, stats, week, season);
            BigDecimal previousScore = previousScoreCache.getOrDefault(leaguePlayerId, BigDecimal.ZERO);

            if (!newScore.equals(previousScore)) {
                // Create score update
                ScoreUpdate update = ScoreUpdate.builder()
                        .leaguePlayerId(leaguePlayerId)
                        .leagueId(leagueId)
                        .previousScore(previousScore)
                        .newScore(newScore)
                        .status(LiveScoreStatus.LIVE)
                        .build();

                // Check for duplicate
                if (!liveScoreRepository.isDuplicateUpdate(update.getIdempotencyKey())) {
                    updates.add(update);
                    previousScoreCache.put(leaguePlayerId, newScore);

                    // Broadcast score update
                    broadcastScoreUpdate(update);
                }
            }
        }

        return updates;
    }

    /**
     * Calculate total roster score from current stats
     */
    private BigDecimal calculateRosterScore(Object roster, List<PlayerStats> stats, int week, int season) {
        // Use the scoring service to calculate scores
        // This is a simplified implementation - actual would use roster slots
        BigDecimal total = BigDecimal.ZERO;

        // Get roster slots and calculate each position's score
        // For now, return a placeholder
        // TODO: Integrate with actual roster structure

        return total;
    }

    /**
     * Broadcast a score update to connected clients
     */
    private void broadcastScoreUpdate(ScoreUpdate update) {
        RosterScoreChangedEvent event = RosterScoreChangedEvent.builder()
                .leaguePlayerId(update.getLeaguePlayerId())
                .leagueId(update.getLeagueId())
                .previousScore(update.getPreviousScore())
                .newScore(update.getNewScore())
                .status(update.getStatus())
                .build();

        broadcastPort.broadcastScoreUpdate(event);
    }

    /**
     * Update leaderboard and broadcast to all connected clients
     */
    private void updateAndBroadcastLeaderboard(String leagueId) {
        // Get all current scores
        Map<String, BigDecimal> scores = liveScoreRepository.getAllScoresForLeague(leagueId);

        // Sort by score descending
        List<Map.Entry<String, BigDecimal>> sortedScores = scores.entrySet().stream()
                .sorted(Map.Entry.<String, BigDecimal>comparingByValue().reversed())
                .toList();

        // Check for rank changes
        List<RankChange> rankChanges = new ArrayList<>();
        int rank = 1;
        BigDecimal leaderScore = sortedScores.isEmpty() ? BigDecimal.ZERO : sortedScores.get(0).getValue();
        String leaderName = sortedScores.isEmpty() ? "" : sortedScores.get(0).getKey();

        for (Map.Entry<String, BigDecimal> entry : sortedScores) {
            String playerId = entry.getKey();
            int previousRank = previousRankCache.getOrDefault(playerId, rank);

            if (previousRank != rank) {
                RankChange change = RankChange.builder()
                        .leaguePlayerId(playerId)
                        .leagueId(leagueId)
                        .previousRank(previousRank)
                        .newRank(rank)
                        .leaderName(leaderName)
                        .pointsBehindLeader(leaderScore.subtract(entry.getValue()))
                        .currentScore(entry.getValue())
                        .build();
                rankChanges.add(change);
            }

            previousRankCache.put(playerId, rank);
            rank++;
        }

        // Broadcast rank changes if any
        if (!rankChanges.isEmpty()) {
            LeaderboardRankChangedEvent event = LeaderboardRankChangedEvent.builder()
                    .leagueId(leagueId)
                    .rankChanges(rankChanges)
                    .build();
            broadcastPort.broadcastRankChanges(event);
        }

        // Build and broadcast full leaderboard
        List<Map<String, Object>> leaderboard = new ArrayList<>();
        rank = 1;
        for (Map.Entry<String, BigDecimal> entry : sortedScores) {
            Map<String, Object> leaderboardEntry = new HashMap<>();
            leaderboardEntry.put("rank", rank);
            leaderboardEntry.put("leaguePlayerId", entry.getKey());
            leaderboardEntry.put("score", entry.getValue());
            leaderboardEntry.put("pointsBehindLeader", leaderScore.subtract(entry.getValue()));
            leaderboard.add(leaderboardEntry);
            rank++;
        }

        broadcastPort.broadcastLeaderboard(leagueId, leaderboard);
    }

    /**
     * Check for completed games and finalize scores
     */
    private void checkAndHandleGameCompletions(int week, int season, String leagueId) {
        Map<UUID, NFLGameStatus> gameStatuses = nflDataPort.getAllGameStatuses(week, season);

        for (Map.Entry<UUID, NFLGameStatus> entry : gameStatuses.entrySet()) {
            UUID gameId = entry.getKey();
            NFLGameStatus status = entry.getValue();

            if (status.isCompleted()) {
                handleGameCompletion(gameId, status, leagueId);
            }
        }
    }

    /**
     * Handle a game that has completed
     */
    private void handleGameCompletion(UUID gameId, NFLGameStatus status, String leagueId) {
        log.info("Handling game completion: {} status: {}", gameId, status);

        GameCompletedEvent event = GameCompletedEvent.builder()
                .nflGameId(gameId)
                .isOvertime(status == NFLGameStatus.FINAL_OVERTIME)
                .build();

        broadcastPort.broadcastGameCompleted(event);

        // TODO: Finalize player scores for this game
        // TODO: Update score status to FINAL for affected players
    }

    /**
     * Get live score for a specific player
     */
    public Optional<LiveScoreDTO> getLiveScore(String leaguePlayerId) {
        Optional<BigDecimal> currentScore = liveScoreRepository.getCurrentScore(leaguePlayerId);
        if (currentScore.isEmpty()) {
            return Optional.empty();
        }

        LiveScoreDTO dto = new LiveScoreDTO();
        dto.setLeaguePlayerId(leaguePlayerId);
        dto.setCurrentScore(currentScore.get());
        dto.setPreviousScore(previousScoreCache.getOrDefault(leaguePlayerId, BigDecimal.ZERO));
        dto.setScoreDelta(dto.getCurrentScore().subtract(dto.getPreviousScore()));
        dto.setStatus(liveScoreRepository.getScoreStatus(leaguePlayerId));
        dto.setLastUpdated(liveScoreRepository.getLastUpdateTime(leaguePlayerId).orElse(LocalDateTime.now()));
        dto.setCurrentRank(previousRankCache.getOrDefault(leaguePlayerId, 0));

        return Optional.of(dto);
    }

    /**
     * Get live leaderboard for a league
     */
    public LiveLeaderboardDTO getLiveLeaderboard(String leagueId, int page, int pageSize) {
        Map<String, BigDecimal> scores = liveScoreRepository.getAllScoresForLeague(leagueId);

        List<Map.Entry<String, BigDecimal>> sortedScores = scores.entrySet().stream()
                .sorted(Map.Entry.<String, BigDecimal>comparingByValue().reversed())
                .toList();

        BigDecimal leaderScore = sortedScores.isEmpty() ? BigDecimal.ZERO : sortedScores.get(0).getValue();

        // Paginate
        int start = page * pageSize;
        int end = Math.min(start + pageSize, sortedScores.size());
        List<Map.Entry<String, BigDecimal>> pageEntries = sortedScores.subList(start, end);

        List<LiveLeaderboardDTO.LiveLeaderboardEntryDTO> entries = new ArrayList<>();
        int rank = start + 1;
        for (Map.Entry<String, BigDecimal> entry : pageEntries) {
            LiveLeaderboardDTO.LiveLeaderboardEntryDTO dto = new LiveLeaderboardDTO.LiveLeaderboardEntryDTO();
            dto.setRank(rank);
            dto.setPreviousRank(previousRankCache.getOrDefault(entry.getKey(), rank));
            dto.setRankDelta(dto.getPreviousRank() - rank);
            dto.setLeaguePlayerId(entry.getKey());
            dto.setTotalScore(entry.getValue());
            dto.setPointsBehindLeader(leaderScore.subtract(entry.getValue()));
            dto.setStatus(liveScoreRepository.getScoreStatus(entry.getKey()));
            entries.add(dto);
            rank++;
        }

        LiveLeaderboardDTO leaderboard = new LiveLeaderboardDTO();
        leaderboard.setLeagueId(leagueId);
        leaderboard.setEntries(entries);
        leaderboard.setTotalPlayers(sortedScores.size());
        leaderboard.setPage(page);
        leaderboard.setPageSize(pageSize);
        leaderboard.setLastUpdated(liveScoreRepository.getLastUpdateTime(leagueId).orElse(LocalDateTime.now()));
        leaderboard.setLive(nflDataPort.getGamesInProgress(0, 0).size() > 0);

        return leaderboard;
    }

    /**
     * Get score snapshot for reconnecting client
     */
    public LiveScoreDTO getScoreSnapshot(String leaguePlayerId) {
        return getLiveScore(leaguePlayerId).orElseGet(() -> {
            LiveScoreDTO dto = new LiveScoreDTO();
            dto.setLeaguePlayerId(leaguePlayerId);
            dto.setCurrentScore(BigDecimal.ZERO);
            dto.setStatus(LiveScoreStatus.LIVE);
            return dto;
        });
    }

    /**
     * Clear caches (e.g., at end of week)
     */
    public void clearCaches(String leagueId) {
        previousScoreCache.clear();
        previousRankCache.clear();
        liveScoreRepository.clearCache(leagueId);
        log.info("Cleared live scoring caches for league {}", leagueId);
    }
}
