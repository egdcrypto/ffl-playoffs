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
 * MongoDB document for Character aggregate
 * Maps to the 'characters' collection
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "characters")
@CompoundIndex(name = "user_league_idx", def = "{'user_id': 1, 'league_id': 1}", unique = true)
public class CharacterDocument {

    @Id
    private String id;

    @Field("user_id")
    @Indexed
    private String userId;

    @Field("league_id")
    @Indexed
    private String leagueId;

    // Branding
    @Field("team_name")
    @Indexed
    private String teamName;

    @Field("team_slogan")
    private String teamSlogan;

    @Field("avatar_url")
    private String avatarUrl;

    @Field("primary_color")
    private String primaryColor;

    @Field("secondary_color")
    private String secondaryColor;

    // Progression
    @Field("type")
    private String type;

    @Field("level")
    @Indexed
    private Integer level;

    @Field("experience_points")
    private Integer experiencePoints;

    // Achievements
    @Field("achievements")
    private List<AchievementSubDocument> achievements;

    // Statistics
    @Field("stats")
    private StatsSubDocument stats;

    // Metadata
    @Field("created_at")
    private LocalDateTime createdAt;

    @Field("updated_at")
    private LocalDateTime updatedAt;

    @Field("last_activity_at")
    private LocalDateTime lastActivityAt;

    /**
     * Embedded document for achievements
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AchievementSubDocument {
        private String id;
        private String type;
        private LocalDateTime unlockedAt;
        private String context;
        private Integer count;
    }

    /**
     * Embedded document for statistics
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class StatsSubDocument {
        private Integer gamesPlayed;
        private Integer wins;
        private Integer losses;
        private Integer ties;
        private Integer seasonsPlayed;
        private Integer seasonWins;
        private Integer currentWinStreak;
        private Integer bestWinStreak;
        private Double totalPointsScored;
        private Double highestWeeklyScore;
    }
}
