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
 * MongoDB document for NFL Team data
 * Maps to the 'nfl_teams' collection
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "nfl_teams")
public class NFLTeamDocument {

    @Id
    private String id;

    @Field("team_id")
    @Indexed(unique = true)
    private String teamId;

    @Field("abbreviation")
    @Indexed
    private String abbreviation;

    @Field("name")
    private String name;

    @Field("city")
    private String city;

    @Field("nickname")
    private String nickname;

    @Field("conference")
    @Indexed
    private String conference;

    @Field("division")
    @Indexed
    private String division;

    @Field("logo_url")
    private String logoUrl;

    @Field("wins")
    private Integer wins;

    @Field("losses")
    private Integer losses;

    @Field("ties")
    private Integer ties;

    @Field("win_percentage")
    private Double winPercentage;

    @Field("created_at")
    private LocalDateTime createdAt;

    @Field("updated_at")
    private LocalDateTime updatedAt;
}
