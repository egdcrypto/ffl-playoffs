package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.CompoundIndexes;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

/**
 * MongoDB document for Story Beat
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "story_beats")
@CompoundIndexes({
        @CompoundIndex(name = "league_type_idx", def = "{'leagueId': 1, 'type': 1}"),
        @CompoundIndex(name = "league_phase_idx", def = "{'leagueId': 1, 'phase': 1}"),
        @CompoundIndex(name = "league_week_idx", def = "{'leagueId': 1, 'weekNumber': 1}"),
        @CompoundIndex(name = "league_published_idx", def = "{'leagueId': 1, 'published': 1}"),
        @CompoundIndex(name = "league_occurred_idx", def = "{'leagueId': 1, 'occurredAt': -1}")
})
public class StoryBeatDocument {

    @Id
    private UUID id;

    @Indexed
    private UUID leagueId;

    private String type;
    private String title;
    private String description;
    private String phase;
    private int tensionImpact;
    private Instant occurredAt;
    private Instant createdAt;

    private Set<UUID> parentBeatIds;
    private Set<UUID> childBeatIds;

    @Indexed
    private UUID storyArcId;
    private Integer weekNumber;
    private Set<UUID> involvedPlayerIds;
    private Map<String, Object> metadata;

    private boolean published;
    private Instant publishedAt;
}
