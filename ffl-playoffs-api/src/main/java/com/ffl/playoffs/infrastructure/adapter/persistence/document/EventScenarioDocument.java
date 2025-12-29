package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;

/**
 * MongoDB document for EventScenario aggregate.
 * Infrastructure layer - contains framework-specific annotations.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "event_scenarios")
public class EventScenarioDocument {

    @Id
    private String id;

    private String name;
    private String description;

    @Indexed
    private String type;

    // Events in scenario (embedded WorldEventDocument definitions)
    private List<WorldEventDocument> events;

    // Template references
    private List<String> templateIds;

    // Distribution configuration
    private DistributionDocument distribution;

    // Configuration
    private boolean randomizeTimings;
    private boolean allowOverlap;
    private Double severityScale;

    // Source
    private String source;
    private Integer historicalSeason;

    // Metadata
    @Indexed
    private Set<String> tags;
    private String authorId;
    private LocalDateTime createdAt;

    /**
     * Embedded document for EventDistribution
     */
    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class DistributionDocument {
        private String type;
        private Integer totalEvents;
        private Double eventsPerWeek;
    }
}
