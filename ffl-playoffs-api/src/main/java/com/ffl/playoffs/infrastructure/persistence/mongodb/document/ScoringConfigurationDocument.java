package com.ffl.playoffs.infrastructure.persistence.mongodb.document;

import com.ffl.playoffs.domain.model.Position;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;
import java.util.Map;

/**
 * MongoDB document for Scoring Configuration
 * Stores configurable scoring rules, multipliers, and elimination rules
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "scoring_configurations")
public class ScoringConfigurationDocument {

    @Id
    private String id;

    @Field("league_id")
    @Indexed
    private Long leagueId;

    @Field("season")
    @Indexed
    private Integer season;

    /**
     * Position-based SpEL scoring formulas
     * Map of Position -> SpEL formula string
     */
    @Field("scoring_rules")
    private Map<Position, String> scoringRules;

    /**
     * Bonus multipliers for exceptional performance
     * Examples: "100_yard_rushing_bonus": 5.0, "300_yard_passing_bonus": 10.0
     */
    @Field("multipliers")
    private Map<String, Double> multipliers;

    /**
     * Rules for player elimination
     */
    @Field("elimination_rules")
    private EliminationRulesDocument eliminationRules;

    @Field("active")
    @Builder.Default
    private boolean active = true;

    @Field("created_at")
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    @Field("updated_at")
    @Builder.Default
    private LocalDateTime updatedAt = LocalDateTime.now();

    /**
     * Nested document for elimination rules
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class EliminationRulesDocument {

        /**
         * Number of lowest-scoring players to eliminate each week
         */
        @Field("players_per_week")
        @Builder.Default
        private Integer playersPerWeek = 1;

        /**
         * Minimum number of players that must remain active
         */
        @Field("minimum_players")
        @Builder.Default
        private Integer minimumPlayers = 2;

        /**
         * Week-specific elimination counts (optional override)
         * Map of week number -> number of players to eliminate
         */
        @Field("week_overrides")
        private Map<Integer, Integer> weekOverrides;

        /**
         * Whether to eliminate on ties (true) or keep all tied players (false)
         */
        @Field("eliminate_on_ties")
        @Builder.Default
        private boolean eliminateOnTies = false;
    }

    /**
     * Creates a default scoring configuration for a league
     */
    public static ScoringConfigurationDocument createDefault(Long leagueId, Integer season) {
        return ScoringConfigurationDocument.builder()
                .leagueId(leagueId)
                .season(season)
                .scoringRules(Map.of(
                        Position.QB, "#passingYards * 0.04 + #passingTDs * 4 - #interceptions * 2 + #rushingYards * 0.1 + #rushingTDs * 6",
                        Position.RB, "#rushingYards * 0.1 + #rushingTDs * 6 + #receivingYards * 0.1 + #receivingTDs * 6 + #receptions * 0.5",
                        Position.WR, "#receivingYards * 0.1 + #receivingTDs * 6 + #receptions * 0.5 + #rushingYards * 0.1 + #rushingTDs * 6",
                        Position.TE, "#receivingYards * 0.1 + #receivingTDs * 6 + #receptions * 1.0",
                        Position.K, "#xpMade * 1 + #fg0to39Made * 3 + #fg40to49Made * 4 + #fg50PlusMade * 5",
                        Position.DEF, "#sacks * 1 + #interceptions * 2 + #fumbleRecoveries * 2 + #defensiveTDs * 6"
                ))
                .multipliers(Map.of(
                        "100_yard_rushing_bonus", 5.0,
                        "100_yard_receiving_bonus", 5.0,
                        "300_yard_passing_bonus", 10.0
                ))
                .eliminationRules(EliminationRulesDocument.builder()
                        .playersPerWeek(1)
                        .minimumPlayers(2)
                        .eliminateOnTies(false)
                        .build())
                .build();
    }

    /**
     * Updates the configuration and marks timestamp
     */
    public void update() {
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Deactivates this configuration
     */
    public void deactivate() {
        this.active = false;
        this.updatedAt = LocalDateTime.now();
    }
}
