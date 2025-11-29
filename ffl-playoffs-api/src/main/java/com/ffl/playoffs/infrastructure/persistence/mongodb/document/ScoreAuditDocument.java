package com.ffl.playoffs.infrastructure.persistence.mongodb.document;

import com.ffl.playoffs.domain.model.Position;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * MongoDB document for Score Audit Trail
 * Stores historical record of all score calculations for transparency and debugging
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "score_audits")
@CompoundIndex(name = "player_week_idx", def = "{'player_id': 1, 'week_id': 1}")
public class ScoreAuditDocument {

    @Id
    private String id;

    @Field("player_id")
    @Indexed
    private Long playerId;

    @Field("week_id")
    @Indexed
    private Long weekId;

    @Field("team_selection_id")
    private Long teamSelectionId;

    @Field("nfl_team")
    private String nflTeam;

    /**
     * The scoring formula used for calculation (SpEL expression)
     */
    @Field("formula_used")
    private String formulaUsed;

    /**
     * Player stats that were used in the calculation
     */
    @Field("player_stats")
    private Map<String, Object> playerStats;

    /**
     * Position of the player for this calculation
     */
    @Field("position")
    private Position position;

    /**
     * The calculated score
     */
    @Field("calculated_score")
    private Double calculatedScore;

    /**
     * Breakdown of score components for transparency
     * Example: {"rushing_yards": 8.5, "rushing_tds": 12.0, "receptions": 3.5}
     */
    @Field("score_breakdown")
    private Map<String, Double> scoreBreakdown;

    /**
     * Any bonuses applied
     */
    @Field("bonuses_applied")
    private Map<String, Double> bonusesApplied;

    /**
     * Total bonuses
     */
    @Field("total_bonus")
    @Builder.Default
    private Double totalBonus = 0.0;

    /**
     * Configuration ID used for this calculation
     */
    @Field("configuration_id")
    private String configurationId;

    /**
     * When the score was calculated
     */
    @Field("calculated_at")
    @Builder.Default
    private LocalDateTime calculatedAt = LocalDateTime.now();

    /**
     * The rank assigned (if applicable)
     */
    @Field("rank")
    private Integer rank;

    /**
     * Whether this player was eliminated based on this score
     */
    @Field("eliminated")
    @Builder.Default
    private boolean eliminated = false;

    /**
     * Any notes or remarks about the calculation
     */
    @Field("notes")
    private String notes;

    /**
     * Creates an audit record for a score calculation
     */
    public static ScoreAuditDocument create(
            Long playerId,
            Long weekId,
            Long teamSelectionId,
            String formula,
            Map<String, Object> stats,
            Position position,
            Double score,
            String configurationId) {

        return ScoreAuditDocument.builder()
                .playerId(playerId)
                .weekId(weekId)
                .teamSelectionId(teamSelectionId)
                .formulaUsed(formula)
                .playerStats(stats)
                .position(position)
                .calculatedScore(score)
                .configurationId(configurationId)
                .build();
    }

    /**
     * Marks this player as eliminated
     */
    public void markAsEliminated() {
        this.eliminated = true;
    }

    /**
     * Sets the rank for this score
     */
    public void setRank(Integer rank) {
        this.rank = rank;
    }

    /**
     * Adds score breakdown details
     */
    public void addScoreBreakdown(Map<String, Double> breakdown) {
        this.scoreBreakdown = breakdown;
    }

    /**
     * Adds bonus information
     */
    public void addBonuses(Map<String, Double> bonuses) {
        this.bonusesApplied = bonuses;
        this.totalBonus = bonuses.values().stream().mapToDouble(Double::doubleValue).sum();
    }
}
