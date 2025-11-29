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

    @Field("created_at")
    private LocalDateTime createdAt;

    @Field("updated_at")
    private LocalDateTime updatedAt;
}
