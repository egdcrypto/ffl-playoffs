package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;

/**
 * MongoDB document for World entity.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "worlds")
public class WorldDocument {
    @Id
    private String id;

    @Indexed
    private String name;

    private String description;

    @Indexed(unique = true)
    private String code;

    @Indexed
    private String primaryOwnerId;

    @Indexed
    private String status;

    private String visibility;

    // Settings (embedded)
    private WorldSettingsDocument settings;

    // Statistics
    private Integer leagueCount;
    private Integer ownerCount;
    private Integer memberCount;

    // Metadata
    private Instant createdAt;
    private Instant updatedAt;
    private Instant activatedAt;
    private Instant archivedAt;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class WorldSettingsDocument {
        private Integer maxLeagues;
        private Integer maxOwners;
        private Integer maxMembers;
        private Boolean leagueCreationEnabled;
        private Boolean invitationsEnabled;
        private Boolean publicLeaderboard;
        private String defaultScoringTemplate;
        private String defaultRosterTemplate;
        private String theme;
        private String welcomeMessage;
    }
}
