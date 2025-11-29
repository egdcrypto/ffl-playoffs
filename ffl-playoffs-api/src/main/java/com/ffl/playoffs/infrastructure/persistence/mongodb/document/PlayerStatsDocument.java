package com.ffl.playoffs.infrastructure.persistence.mongodb.document;

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

/**
 * MongoDB document for Player Statistics data
 * Maps to the 'player_stats' collection synced by the Python nfl-data-sync service
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "player_stats")
@CompoundIndex(name = "player_season_week_idx", def = "{'player_id': 1, 'season': 1, 'week': 1}", unique = true)
public class PlayerStatsDocument {

    @Id
    private String id;

    @Field("player_id")
    @Indexed
    private String playerId;

    @Field("player_name")
    private String playerName;

    @Field("week")
    @Indexed
    private Integer week;

    @Field("season")
    @Indexed
    private Integer season;

    @Field("team")
    private String team;

    @Field("position")
    private String position;

    // Passing stats
    @Field("passing_yards")
    @Builder.Default
    private Integer passingYards = 0;

    @Field("passing_tds")
    @Builder.Default
    private Integer passingTds = 0;

    @Field("interceptions")
    @Builder.Default
    private Integer interceptions = 0;

    @Field("passing_attempts")
    @Builder.Default
    private Integer passingAttempts = 0;

    @Field("passing_completions")
    @Builder.Default
    private Integer passingCompletions = 0;

    // Rushing stats
    @Field("rushing_yards")
    @Builder.Default
    private Integer rushingYards = 0;

    @Field("rushing_tds")
    @Builder.Default
    private Integer rushingTds = 0;

    @Field("rushing_attempts")
    @Builder.Default
    private Integer rushingAttempts = 0;

    // Receiving stats
    @Field("receptions")
    @Builder.Default
    private Integer receptions = 0;

    @Field("receiving_yards")
    @Builder.Default
    private Integer receivingYards = 0;

    @Field("receiving_tds")
    @Builder.Default
    private Integer receivingTds = 0;

    @Field("targets")
    @Builder.Default
    private Integer targets = 0;

    // Other offensive stats
    @Field("two_point_conversions")
    @Builder.Default
    private Integer twoPointConversions = 0;

    @Field("fumbles_lost")
    @Builder.Default
    private Integer fumblesLost = 0;

    // Kicker stats
    @Field("field_goals_made")
    @Builder.Default
    private Integer fieldGoalsMade = 0;

    @Field("field_goals_attempted")
    @Builder.Default
    private Integer fieldGoalsAttempted = 0;

    @Field("fg_made_0_19")
    @Builder.Default
    private Integer fgMade0To19 = 0;

    @Field("fg_made_20_29")
    @Builder.Default
    private Integer fgMade20To29 = 0;

    @Field("fg_made_30_39")
    @Builder.Default
    private Integer fgMade30To39 = 0;

    @Field("fg_made_40_49")
    @Builder.Default
    private Integer fgMade40To49 = 0;

    @Field("fg_made_50_plus")
    @Builder.Default
    private Integer fgMade50Plus = 0;

    @Field("extra_points_made")
    @Builder.Default
    private Integer extraPointsMade = 0;

    @Field("extra_points_attempted")
    @Builder.Default
    private Integer extraPointsAttempted = 0;

    @Field("created_at")
    private LocalDateTime createdAt;

    @Field("updated_at")
    private LocalDateTime updatedAt;
}
