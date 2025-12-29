package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.annotation.Version;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.CompoundIndexes;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;

/**
 * MongoDB document for WorldEvent aggregate.
 * Infrastructure layer - contains framework-specific annotations.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "world_events")
@CompoundIndexes({
        @CompoundIndex(name = "run_status_idx", def = "{'simulationRunId': 1, 'status': 1}"),
        @CompoundIndex(name = "run_week_idx", def = "{'simulationRunId': 1, 'startWeek': 1}"),
        @CompoundIndex(name = "run_target_idx", def = "{'simulationRunId': 1, 'targets.targetId': 1}")
})
public class WorldEventDocument {

    @Id
    private String id;

    @Indexed
    private String simulationWorldId;

    @Indexed
    private String simulationRunId;

    // Event identity
    private String type;
    private String category;
    private String name;
    private String description;

    // Timing
    private TimingDocument timing;
    private Integer startWeek;
    private Integer endWeek;
    private Instant scheduledAt;
    private Instant activatedAt;
    private Instant expiredAt;

    // Affected entities
    private List<TargetDocument> targets;
    private String scope;

    // Effects
    private List<EffectDocument> effects;
    private Double severity;
    private String impactType;

    // State
    @Indexed
    private String status;
    private String source;
    private String cancellationReason;

    // Narrative integration
    private boolean triggerNarrative;
    private String narrativeType;
    private String narrativeHeadline;

    // Metadata
    private String createdBy;
    private LocalDateTime createdAt;

    @Version
    private Long version;

    /**
     * Embedded document for EventTiming
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TimingDocument {
        private String type;
        private Integer weekStart;
        private Integer weekEnd;
        private String specificGameId;
        private boolean recurring;
        private String recurrencePattern;
        private List<Integer> recurringWeeks;
    }

    /**
     * Embedded document for EventTarget
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class TargetDocument {
        private String type;
        private String targetId;
        private String targetName;
        private String position;
        private String teamContext;
        private String role;
        private Integer limit;
    }

    /**
     * Embedded document for EventEffect
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class EffectDocument {
        private String type;
        private String application;
        private Map<String, Double> statModifiers;
        private Double availabilityChance;
        private Boolean forceOut;
        private Double ceilingModifier;
        private Double floorModifier;
        private Double varianceModifier;
        private Double fantasyPointsModifier;
        private Double effectProbability;
    }
}
