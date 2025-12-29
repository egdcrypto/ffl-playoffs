package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.List;
import java.util.Map;
import java.util.Set;

/**
 * MongoDB document for EventTemplate entity.
 * Infrastructure layer - contains framework-specific annotations.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "event_templates")
public class EventTemplateDocument {

    @Id
    private String id;

    private String name;

    @Indexed
    private String eventType;

    @Indexed
    private String category;

    // Default effects
    private List<WorldEventDocument.EffectDocument> defaultEffects;
    private Double defaultSeverity;
    private String defaultImpact;

    // Timing defaults
    private String defaultTimingType;
    private Integer defaultDuration;

    // Target constraints
    private Set<String> validTargets;
    private Set<String> validPositions;

    // Probability
    private Double baseProbability;
    private Map<String, Double> positionProbabilities;

    // Narrative
    private boolean generateNarrative;
    private String narrativeTemplate;
}
