package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.service.ScoringService;
import com.ffl.playoffs.domain.service.SpelScoringEngine;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.ScoreAuditDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.ScoringConfigurationDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoScoreAuditRepository;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoScoringConfigurationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/**
 * MongoDB-based implementation of ScoringService
 * Uses SpEL Scoring Engine for formula evaluation
 * Stores all calculations in MongoDB for audit trail
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class ScoringServiceImpl implements ScoringService {

    private final SpelScoringEngine scoringEngine;
    private final MongoScoringConfigurationRepository configurationRepository;
    private final MongoScoreAuditRepository auditRepository;

    @Override
    public Double calculateTeamScore(TeamSelection selection, Map<String, Object> playerStats) {
        log.debug("Calculating score for team selection {} with stats: {}", selection.getId(), playerStats);

        // Get scoring configuration
        ScoringConfigurationDocument config = getActiveScoringConfiguration(1L, 2024); // TODO: Get from context

        // Determine position from stats
        Position position = determinePosition(playerStats);

        // Get formula for position
        String formula = config.getScoringRules().get(position);
        if (formula == null) {
            log.warn("No scoring formula found for position: {}", position);
            return 0.0;
        }

        // Calculate score using SpEL engine
        Double score = scoringEngine.calculate(formula, playerStats);

        // Apply any multiplier bonuses
        Double bonuses = applyBonuses(playerStats, config.getMultipliers());
        Double totalScore = score + bonuses;

        // Create audit record
        ScoreAuditDocument audit = ScoreAuditDocument.create(
                selection.getPlayerId(),
                selection.getWeekId(),
                selection.getId(),
                formula,
                playerStats,
                position,
                totalScore,
                config.getId()
        );

        // Add bonus information if any bonuses were applied
        if (bonuses > 0) {
            Map<String, Double> bonusMap = new HashMap<>();
            config.getMultipliers().forEach((bonusName, bonusValue) -> {
                if (shouldApplyBonus(bonusName, playerStats)) {
                    bonusMap.put(bonusName, bonusValue);
                }
            });
            audit.addBonuses(bonusMap);
        }

        auditRepository.save(audit);

        log.info("Calculated score {} for team selection {} (position: {})", totalScore, selection.getId(), position);
        return totalScore;
    }

    @Override
    public List<Score> calculateWeekScores(Long weekId, Map<Long, Map<String, Object>> selectionStats) {
        log.info("Calculating scores for week {} with {} selections", weekId, selectionStats.size());

        List<Score> scores = new ArrayList<>();

        selectionStats.forEach((selectionId, stats) -> {
            // Extract player ID from stats or use selection ID (simplified)
            Long playerId = ((Number) stats.getOrDefault("playerId", selectionId)).longValue();

            // Create temporary TeamSelection for calculation
            TeamSelection selection = TeamSelection.builder()
                    .id(selectionId)
                    .playerId(playerId)
                    .weekId(weekId)
                    .build();

            Double totalScore = calculateTeamScore(selection, stats);

            Score score = Score.builder()
                    .id(selectionId)
                    .playerId(playerId)
                    .weekId(weekId)
                    .totalScore(totalScore)
                    .calculatedAt(LocalDateTime.now())
                    .build();

            scores.add(score);
        });

        log.info("Calculated {} scores for week {}", scores.size(), weekId);
        return scores;
    }

    @Override
    public List<Long> determineEliminatedPlayers(List<Score> scores) {
        log.info("Determining eliminated players from {} scores", scores.size());

        if (scores.isEmpty()) {
            return Collections.emptyList();
        }

        // Get scoring configuration
        ScoringConfigurationDocument config = getActiveScoringConfiguration(1L, 2024); // TODO: Get from context
        ScoringConfigurationDocument.EliminationRulesDocument rules = config.getEliminationRules();

        // Sort scores by total score (ascending - lowest first)
        List<Score> sortedScores = new ArrayList<>(scores);
        sortedScores.sort(Comparator.comparing(Score::getTotalScore));

        // Determine how many to eliminate for this week
        Long weekId = scores.get(0).getWeekId();
        int weekNumber = weekId.intValue(); // Simplified - would need proper week mapping
        int eliminationCount = rules.getPlayersPerWeek();

        // Check for week-specific overrides
        if (rules.getWeekOverrides() != null && rules.getWeekOverrides().containsKey(weekNumber)) {
            eliminationCount = rules.getWeekOverrides().get(weekNumber);
        }

        // Calculate remaining players after elimination
        int remainingPlayers = scores.size() - eliminationCount;
        if (remainingPlayers < rules.getMinimumPlayers()) {
            log.warn("Cannot eliminate {} players - would leave only {} (minimum: {})",
                    eliminationCount, remainingPlayers, rules.getMinimumPlayers());
            eliminationCount = Math.max(0, scores.size() - rules.getMinimumPlayers());
        }

        // Select players to eliminate
        List<Long> eliminatedPlayerIds = new ArrayList<>();

        if (rules.isEliminateOnTies()) {
            // Simple elimination - just take the lowest N scores
            for (int i = 0; i < Math.min(eliminationCount, sortedScores.size()); i++) {
                eliminatedPlayerIds.add(sortedScores.get(i).getPlayerId());
            }
        } else {
            // Don't eliminate tied players - only eliminate if there's a clear gap
            if (eliminationCount > 0 && sortedScores.size() > eliminationCount) {
                Double cutoffScore = sortedScores.get(eliminationCount - 1).getTotalScore();
                Double nextScore = sortedScores.get(eliminationCount).getTotalScore();

                // Only eliminate if there's no tie at the cutoff
                if (!cutoffScore.equals(nextScore)) {
                    for (int i = 0; i < eliminationCount; i++) {
                        if (sortedScores.get(i).getTotalScore() < cutoffScore) {
                            eliminatedPlayerIds.add(sortedScores.get(i).getPlayerId());
                        }
                    }
                } else {
                    log.info("Tie detected at elimination cutoff - no players eliminated");
                }
            }
        }

        // Update audit records to mark eliminated players
        if (!eliminatedPlayerIds.isEmpty()) {
            eliminatedPlayerIds.forEach(playerId -> {
                auditRepository.findByPlayerIdAndWeekId(playerId, weekId)
                        .ifPresent(audit -> {
                            audit.markAsEliminated();
                            auditRepository.save(audit);
                        });
            });
        }

        log.info("Eliminated {} players: {}", eliminatedPlayerIds.size(), eliminatedPlayerIds);
        return eliminatedPlayerIds;
    }

    @Override
    public void rankScores(List<Score> scores) {
        log.info("Ranking {} scores", scores.size());

        // Sort by total score (descending - highest first)
        List<Score> sortedScores = new ArrayList<>(scores);
        sortedScores.sort(Comparator.comparing(Score::getTotalScore).reversed());

        // Assign ranks (1 = highest)
        int currentRank = 1;
        Double previousScore = null;
        int playersAtRank = 0;

        for (Score score : sortedScores) {
            if (previousScore != null && !score.getTotalScore().equals(previousScore)) {
                currentRank += playersAtRank;
                playersAtRank = 0;
            }

            score.setRank(currentRank);
            playersAtRank++;
            previousScore = score.getTotalScore();

            // Update audit record with rank
            auditRepository.findByPlayerIdAndWeekId(score.getPlayerId(), score.getWeekId())
                    .ifPresent(audit -> {
                        audit.setRank(currentRank);
                        auditRepository.save(audit);
                    });
        }

        log.info("Ranked {} scores (ranks 1-{})", scores.size(), currentRank);
    }

    /**
     * Get active scoring configuration for a league and season
     */
    private ScoringConfigurationDocument getActiveScoringConfiguration(Long leagueId, Integer season) {
        return configurationRepository.findByLeagueIdAndSeasonAndActiveTrue(leagueId, season)
                .orElseGet(() -> {
                    log.warn("No active scoring configuration found for league {} season {} - creating default",
                            leagueId, season);
                    ScoringConfigurationDocument defaultConfig = ScoringConfigurationDocument.createDefault(leagueId, season);
                    return configurationRepository.save(defaultConfig);
                });
    }

    /**
     * Determine position from player stats
     */
    private Position determinePosition(Map<String, Object> stats) {
        // Check for position in stats
        Object positionObj = stats.get("position");
        if (positionObj instanceof Position) {
            return (Position) positionObj;
        }
        if (positionObj instanceof String) {
            try {
                return Position.valueOf((String) positionObj);
            } catch (IllegalArgumentException e) {
                log.warn("Invalid position string: {}", positionObj);
            }
        }

        // Infer position from stats
        if (hasValue(stats, "passingYards") || hasValue(stats, "passingTDs")) {
            return Position.QB;
        } else if (hasValue(stats, "rushingYards") && hasValue(stats, "receivingYards")) {
            return Position.RB; // Could be RB or WR - default to RB
        } else if (hasValue(stats, "receivingYards")) {
            return Position.WR;
        } else if (hasValue(stats, "fgMade") || hasValue(stats, "xpMade")) {
            return Position.K;
        } else if (hasValue(stats, "sacks") || hasValue(stats, "defensiveTDs")) {
            return Position.DEF;
        }

        log.warn("Could not determine position from stats - defaulting to WR");
        return Position.WR;
    }

    /**
     * Check if a stat has a non-zero value
     */
    private boolean hasValue(Map<String, Object> stats, String key) {
        Object value = stats.get(key);
        if (value instanceof Number) {
            return ((Number) value).doubleValue() > 0;
        }
        return false;
    }

    /**
     * Apply bonus multipliers based on performance milestones
     */
    private Double applyBonuses(Map<String, Object> stats, Map<String, Double> multipliers) {
        double totalBonus = 0.0;

        for (Map.Entry<String, Double> entry : multipliers.entrySet()) {
            if (shouldApplyBonus(entry.getKey(), stats)) {
                totalBonus += entry.getValue();
            }
        }

        return totalBonus;
    }

    /**
     * Determine if a bonus should be applied based on stats
     */
    private boolean shouldApplyBonus(String bonusName, Map<String, Object> stats) {
        return switch (bonusName) {
            case "100_yard_rushing_bonus" -> getStatValue(stats, "rushingYards") >= 100;
            case "100_yard_receiving_bonus" -> getStatValue(stats, "receivingYards") >= 100;
            case "300_yard_passing_bonus" -> getStatValue(stats, "passingYards") >= 300;
            case "400_yard_passing_bonus" -> getStatValue(stats, "passingYards") >= 400;
            case "200_yard_rushing_bonus" -> getStatValue(stats, "rushingYards") >= 200;
            case "200_yard_receiving_bonus" -> getStatValue(stats, "receivingYards") >= 200;
            default -> false;
        };
    }

    /**
     * Get stat value as double
     */
    private double getStatValue(Map<String, Object> stats, String key) {
        Object value = stats.get(key);
        if (value instanceof Number) {
            return ((Number) value).doubleValue();
        }
        return 0.0;
    }
}
