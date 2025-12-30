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
import java.util.List;

/**
 * MongoDB document for World aggregate
 * Maps to the 'worlds' collection
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "worlds")
@CompoundIndex(name = "season_status_idx", def = "{'season': 1, 'status': 1}")
public class WorldDocument {

    @Id
    private String id;

    @Field("name")
    @Indexed(unique = true)
    private String name;

    @Field("description")
    private String description;

    @Field("status")
    @Indexed
    private String status;

    // Configuration
    @Field("season")
    @Indexed
    private Integer season;

    @Field("starting_nfl_week")
    private Integer startingNflWeek;

    @Field("ending_nfl_week")
    private Integer endingNflWeek;

    @Field("max_leagues")
    private Integer maxLeagues;

    @Field("max_players_per_league")
    private Integer maxPlayersPerLeague;

    @Field("allow_late_registration")
    private Boolean allowLateRegistration;

    @Field("auto_advance_weeks")
    private Boolean autoAdvanceWeeks;

    @Field("timezone")
    private String timezone;

    // Season Info
    @Field("current_week")
    private Integer currentWeek;

    @Field("total_weeks")
    private Integer totalWeeks;

    @Field("season_start_date")
    private LocalDateTime seasonStartDate;

    @Field("season_end_date")
    private LocalDateTime seasonEndDate;

    @Field("current_week_start_date")
    private LocalDateTime currentWeekStartDate;

    @Field("current_week_end_date")
    private LocalDateTime currentWeekEndDate;

    // League management
    @Field("league_ids")
    private List<String> leagueIds;

    @Field("active_league_count")
    private Integer activeLeagueCount;

    // Lifecycle
    @Field("created_by")
    @Indexed
    private String createdBy;

    @Field("created_at")
    private LocalDateTime createdAt;

    @Field("updated_at")
    private LocalDateTime updatedAt;

    @Field("activated_at")
    private LocalDateTime activatedAt;

    @Field("completed_at")
    private LocalDateTime completedAt;

    @Field("completion_reason")
    private String completionReason;

    // Statistics
    @Field("total_participants")
    private Integer totalParticipants;

    @Field("total_games_played")
    private Integer totalGamesPlayed;
}
