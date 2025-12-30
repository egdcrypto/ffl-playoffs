package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.util.Set;
import java.util.UUID;

/**
 * MongoDB document for AI Director
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "ai_directors")
public class AIDirectorDocument {

    @Id
    private UUID id;

    @Indexed(unique = true)
    private UUID leagueId;

    private String currentPhase;
    private String currentTensionLevel;
    private int tensionScore;

    @Indexed
    private String status;
    private boolean automationEnabled;

    private Instant createdAt;
    private Instant updatedAt;
    private Instant lastActivityAt;

    private UUID activeStoryArcId;
    private Set<UUID> activeStallConditionIds;
    private Set<UUID> pendingActionIds;

    private int stallDetectionThresholdHours;
    private int tensionTargetScore;
    private boolean autoGenerateStoryBeats;
    private boolean autoResolveStalls;

    private int totalStoryBeatsGenerated;
    private int totalStallsDetected;
    private int totalActionsExecuted;
}
