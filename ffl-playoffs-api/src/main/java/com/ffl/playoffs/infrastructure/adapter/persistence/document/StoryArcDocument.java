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
import java.util.List;
import java.util.Set;
import java.util.UUID;

/**
 * MongoDB document for Story Arc
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "story_arcs")
@CompoundIndexes({
        @CompoundIndex(name = "league_status_idx", def = "{'leagueId': 1, 'status': 1}"),
        @CompoundIndex(name = "league_phase_idx", def = "{'leagueId': 1, 'currentPhase': 1}")
})
public class StoryArcDocument {

    @Id
    private UUID id;

    @Indexed
    private UUID leagueId;

    private String title;
    private String description;
    private String status;
    private String currentPhase;

    private Instant createdAt;
    private Instant updatedAt;
    private Instant completedAt;

    private List<UUID> beatIds;
    private Set<UUID> involvedPlayerIds;
    private UUID rootBeatId;

    private int peakTensionLevel;
    private int beatCount;
}
