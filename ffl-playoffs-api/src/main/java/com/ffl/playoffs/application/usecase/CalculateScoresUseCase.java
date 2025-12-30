package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.LiveScoreStatus;
import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.model.ScoreUpdate;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.port.LiveScoreRepository;
import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.domain.port.TeamSelectionRepository;
import com.ffl.playoffs.domain.service.ScoringService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Service;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class CalculateScoresUseCase {
    private final ScoringService scoringService;
    private final NflDataProvider nflDataProvider;
    private final TeamSelectionRepository teamSelectionRepository;
    private final LiveScoreRepository liveScoreRepository;
    private final ApplicationEventPublisher eventPublisher;

    public List<Score> execute(Long weekId, int season) {
        log.info("Calculating scores for week {} season {}", weekId, season);

        // Fetch player stats from NFL data provider
        Map<Long, Map<String, Object>> selectionStats = fetchSelectionStats(weekId, season);

        // Calculate scores
        List<Score> scores = scoringService.calculateWeekScores(weekId, selectionStats);

        // Rank scores
        scoringService.rankScores(scores);

        // Determine eliminations
        List<Long> eliminatedPlayerIds = scoringService.determineEliminatedPlayers(scores);

        // Mark eliminated players
        scores.forEach(score -> {
            if (eliminatedPlayerIds.contains(score.getPlayerId())) {
                score.markAsEliminated();
            }
        });

        // Save scores to repository
        saveScores(scores, weekId);

        // Publish elimination events
        publishEliminationEvents(scores, eliminatedPlayerIds, weekId);

        log.info("Calculated {} scores for week {}, {} players eliminated",
                scores.size(), weekId, eliminatedPlayerIds.size());

        return scores;
    }

    private Map<Long, Map<String, Object>> fetchSelectionStats(Long weekId, int season) {
        // Get all team selections for this week
        UUID weekUuid = convertToUuid(weekId);
        List<TeamSelection> selections = teamSelectionRepository.findByWeekId(weekUuid);

        if (selections.isEmpty()) {
            log.warn("No team selections found for week {}", weekId);
            return Map.of();
        }

        // Fetch stats for each selection's NFL team
        Map<Long, Map<String, Object>> stats = new HashMap<>();
        int nflWeek = weekId.intValue(); // Assuming weekId maps to NFL week number

        for (TeamSelection selection : selections) {
            try {
                Map<String, Object> teamStats = nflDataProvider.getTeamPlayerStats(
                        selection.getNflTeam(),
                        nflWeek,
                        season
                );
                stats.put(selection.getPlayerId(), teamStats);
            } catch (Exception e) {
                log.error("Failed to fetch stats for team {} in week {}",
                        selection.getNflTeam(), nflWeek, e);
                stats.put(selection.getPlayerId(), Map.of());
            }
        }

        return stats;
    }

    private void saveScores(List<Score> scores, Long weekId) {
        List<ScoreUpdate> scoreUpdates = scores.stream()
                .map(score -> createScoreUpdate(score, weekId))
                .collect(Collectors.toList());

        liveScoreRepository.saveAll(scoreUpdates);
        log.debug("Saved {} score updates for week {}", scoreUpdates.size(), weekId);
    }

    private ScoreUpdate createScoreUpdate(Score score, Long weekId) {
        return ScoreUpdate.builder()
                .leaguePlayerId(score.getPlayerId().toString())
                .leagueId(weekId.toString())
                .newScore(BigDecimal.valueOf(score.getTotalScore()))
                .previousScore(BigDecimal.ZERO)
                .status(LiveScoreStatus.FINAL)
                .timestamp(LocalDateTime.now())
                .statUpdate("WEEK_FINAL_SCORE")
                .build();
    }

    private void publishEliminationEvents(List<Score> scores, List<Long> eliminatedPlayerIds, Long weekId) {
        for (Long playerId : eliminatedPlayerIds) {
            scores.stream()
                    .filter(s -> s.getPlayerId().equals(playerId))
                    .findFirst()
                    .ifPresent(score -> {
                        // Update score status to FINAL
                        liveScoreRepository.updateScoreStatus(
                                playerId.toString(),
                                LiveScoreStatus.FINAL
                        );

                        // Publish elimination event
                        PlayerEliminatedEvent event = new PlayerEliminatedEvent(
                                playerId,
                                weekId,
                                score.getRank(),
                                score.getTotalScore()
                        );
                        eventPublisher.publishEvent(event);
                        log.info("Published elimination event for player {} in week {}",
                                playerId, weekId);
                    });
        }
    }

    private UUID convertToUuid(Long id) {
        // Generate deterministic UUID from Long
        return new UUID(0L, id);
    }

    /**
     * Event published when a player is eliminated
     */
    public static class PlayerEliminatedEvent {
        private final Long playerId;
        private final Long weekId;
        private final Integer finalRank;
        private final Double finalScore;

        public PlayerEliminatedEvent(Long playerId, Long weekId, Integer finalRank, Double finalScore) {
            this.playerId = playerId;
            this.weekId = weekId;
            this.finalRank = finalRank;
            this.finalScore = finalScore;
        }

        public Long getPlayerId() { return playerId; }
        public Long getWeekId() { return weekId; }
        public Integer getFinalRank() { return finalRank; }
        public Double getFinalScore() { return finalScore; }
    }
}
