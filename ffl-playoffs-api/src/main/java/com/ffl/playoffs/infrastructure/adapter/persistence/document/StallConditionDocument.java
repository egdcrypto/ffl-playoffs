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
 * MongoDB document for Stall Condition
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "stall_conditions")
@CompoundIndexes({
        @CompoundIndex(name = "league_type_idx", def = "{'leagueId': 1, 'type': 1}"),
        @CompoundIndex(name = "league_resolved_idx", def = "{'leagueId': 1, 'resolved': 1}"),
        @CompoundIndex(name = "league_severity_idx", def = "{'leagueId': 1, 'severity': 1}")
})
public class StallConditionDocument {

    @Id
    private UUID id;

    @Indexed
    private UUID leagueId;

    private String type;
    private String description;
    private Instant detectedAt;
    private Instant stallStartedAt;
    private Instant resolvedAt;

    private String severity;
    private int stallDurationHours;

    private Set<UUID> affectedPlayerIds;
    private Map<String, Object> diagnosticData;

    @Indexed
    private boolean resolved;
    private String resolutionAction;
    private String resolutionNotes;
}
