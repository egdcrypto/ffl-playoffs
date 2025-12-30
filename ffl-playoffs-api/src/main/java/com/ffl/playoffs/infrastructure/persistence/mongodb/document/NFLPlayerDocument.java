package com.ffl.playoffs.infrastructure.persistence.mongodb.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;

/**
 * MongoDB document for NFL Player data
 * Maps to the 'nfl_players' collection synced by the Python nfl-data-sync service
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "nfl_players")
public class NFLPlayerDocument {

    @Id
    private String id;

    @Field("player_id")
    @Indexed(unique = true)
    private String playerId;

    @Field("name")
    private String name;

    @Field("first_name")
    private String firstName;

    @Field("last_name")
    private String lastName;

    @Field("position")
    @Indexed
    private String position;

    @Field("team")
    @Indexed
    private String team;

    @Field("jersey_number")
    private Integer jerseyNumber;

    @Field("status")
    @Builder.Default
    private String status = "ACTIVE";

    // Physical attributes
    @Field("height")
    private Integer height; // in inches

    @Field("weight")
    private Integer weight; // in pounds

    @Field("birth_date")
    private String birthDate;

    @Field("college")
    private String college;

    @Field("experience")
    private Integer experience; // years in NFL

    // Injury information
    @Field("injury_status")
    private String injuryStatus; // Healthy, Questionable, Doubtful, Out, IR

    @Field("injury_body_part")
    private String injuryBodyPart;

    @Field("injury_start_date")
    private String injuryStartDate;

    @Field("injury_notes")
    private String injuryNotes;

    // Fantasy-specific fields
    @Field("bye_week")
    private Integer byeWeek;

    @Field("fantasy_position")
    private String fantasyPosition;

    @Field("depth_chart_order")
    private Integer depthChartOrder;

    @Field("photo_url")
    private String photoUrl;

    // Draft information
    @Field("draft_year")
    private Integer draftYear;

    @Field("draft_round")
    private Integer draftRound;

    @Field("draft_pick")
    private Integer draftPick;

    @Field("draft_team")
    private String draftTeam;

    // Season stats
    @Field("games_played")
    private Integer gamesPlayed;

    @Field("fantasy_points")
    private Double fantasyPoints;

    @Field("fantasy_points_ppr")
    private Double fantasyPointsPPR;

    @Field("average_points_per_game")
    private Double averagePointsPerGame;

    @Field("created_at")
    private LocalDateTime createdAt;

    @Field("updated_at")
    private LocalDateTime updatedAt;
}
