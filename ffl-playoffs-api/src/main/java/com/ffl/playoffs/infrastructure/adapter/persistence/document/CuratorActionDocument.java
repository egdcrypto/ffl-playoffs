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
 * MongoDB document for Curator Action
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "curator_actions")
@CompoundIndexes({
        @CompoundIndex(name = "league_type_idx", def = "{'leagueId': 1, 'type': 1}"),
        @CompoundIndex(name = "league_status_idx", def = "{'leagueId': 1, 'status': 1}"),
        @CompoundIndex(name = "league_created_idx", def = "{'leagueId': 1, 'createdAt': -1}")
})
public class CuratorActionDocument {

    @Id
    private UUID id;

    @Indexed
    private UUID leagueId;

    private String type;
    private String description;
    private boolean automated;

    @Indexed
    private UUID initiatedBy;

    private Instant createdAt;
    private Instant executedAt;
    private Instant completedAt;

    @Indexed
    private String status;
    private String statusMessage;

    private UUID relatedStallConditionId;
    private UUID relatedStoryArcId;
    private Set<UUID> targetPlayerIds;
    private Map<String, Object> parameters;
    private Map<String, Object> results;
}
