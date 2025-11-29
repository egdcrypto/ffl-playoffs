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
 * MongoDB document for NFL Game data
 * Maps to the 'nfl_games' collection synced by the Python nfl-data-sync service
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "nfl_games")
@CompoundIndex(name = "season_week_idx", def = "{'season': 1, 'week': 1}")
public class NFLGameDocument {

    @Id
    private String id;

    @Field("game_id")
    @Indexed(unique = true)
    private String gameId;

    @Field("season")
    @Indexed
    private Integer season;

    @Field("week")
    @Indexed
    private Integer week;

    @Field("home_team")
    @Indexed
    private String homeTeam;

    @Field("away_team")
    @Indexed
    private String awayTeam;

    @Field("home_score")
    private Integer homeScore;

    @Field("away_score")
    private Integer awayScore;

    @Field("game_time")
    private LocalDateTime gameTime;

    @Field("game_date")
    private LocalDateTime gameDate;

    @Field("status")
    @Builder.Default
    private String status = "SCHEDULED";

    @Field("quarter")
    private String quarter;

    @Field("time_remaining")
    private String timeRemaining;

    @Field("venue")
    private String venue;

    @Field("broadcast_network")
    private String broadcastNetwork;

    @Field("created_at")
    private LocalDateTime createdAt;

    @Field("updated_at")
    private LocalDateTime updatedAt;
}
