package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.domain.aggregate.EventScenario;
import com.ffl.playoffs.domain.entity.EventTemplate;
import com.ffl.playoffs.domain.model.ScenarioType;
import com.ffl.playoffs.domain.model.WorldEventType;
import com.ffl.playoffs.domain.port.WorldEventRepository;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Set;
import java.util.UUID;

/**
 * REST controller for Event Scenarios and Templates.
 * Provides endpoints for querying scenarios and templates.
 */
@RestController
@RequiredArgsConstructor
public class EventScenarioController {

    private static final Logger log = LoggerFactory.getLogger(EventScenarioController.class);

    private final WorldEventRepository eventRepository;

    // ==================== Scenario Endpoints ====================

    /**
     * List all available scenarios.
     */
    @GetMapping("/api/v1/event-scenarios")
    public ResponseEntity<List<EventScenarioResponse>> listScenarios(
            @RequestParam(required = false) ScenarioType type) {
        log.info("Listing event scenarios, type filter: {}", type);

        List<EventScenario> scenarios;
        if (type != null) {
            scenarios = eventRepository.findScenariosByType(type);
        } else {
            scenarios = eventRepository.findAllScenarios();
        }

        return ResponseEntity.ok(scenarios.stream().map(this::toScenarioResponse).toList());
    }

    /**
     * Get scenario details by ID.
     */
    @GetMapping("/api/v1/event-scenarios/{id}")
    public ResponseEntity<EventScenarioResponse> getScenario(@PathVariable UUID id) {
        log.info("Getting scenario: {}", id);
        return eventRepository.findScenarioById(id)
                .map(scenario -> ResponseEntity.ok(toScenarioResponse(scenario)))
                .orElse(ResponseEntity.notFound().build());
    }

    // ==================== Template Endpoints ====================

    /**
     * List all available templates.
     */
    @GetMapping("/api/v1/event-templates")
    public ResponseEntity<List<EventTemplateResponse>> listTemplates(
            @RequestParam(required = false) WorldEventType type) {
        log.info("Listing event templates, type filter: {}", type);

        List<EventTemplate> templates;
        if (type != null) {
            templates = eventRepository.findTemplatesByType(type);
        } else {
            templates = eventRepository.findAllTemplates();
        }

        return ResponseEntity.ok(templates.stream().map(this::toTemplateResponse).toList());
    }

    /**
     * Get template details by ID.
     */
    @GetMapping("/api/v1/event-templates/{id}")
    public ResponseEntity<EventTemplateResponse> getTemplate(@PathVariable UUID id) {
        log.info("Getting template: {}", id);
        return eventRepository.findTemplateById(id)
                .map(template -> ResponseEntity.ok(toTemplateResponse(template)))
                .orElse(ResponseEntity.notFound().build());
    }

    // ==================== Response Mapping ====================

    private EventScenarioResponse toScenarioResponse(EventScenario scenario) {
        return new EventScenarioResponse(
                scenario.getId(),
                scenario.getName(),
                scenario.getDescription(),
                scenario.getType(),
                scenario.getEventCount(),
                scenario.getTemplates().size(),
                scenario.getEventDensity(),
                scenario.getSeverityScale(),
                scenario.isRandomizeTimings(),
                scenario.isAllowOverlap(),
                scenario.getTags(),
                scenario.getAuthorId(),
                scenario.getCreatedAt()
        );
    }

    private EventTemplateResponse toTemplateResponse(EventTemplate template) {
        return new EventTemplateResponse(
                template.getId(),
                template.getName(),
                template.getEventType(),
                template.getCategory(),
                template.getDefaultSeverity(),
                template.getDefaultImpact(),
                template.getDefaultTimingType(),
                template.getDefaultDuration(),
                template.getValidTargets(),
                template.getValidPositions(),
                template.getBaseProbability(),
                template.isGenerateNarrative(),
                template.getNarrativeTemplate()
        );
    }

    // ==================== Response Records ====================

    public record EventScenarioResponse(
            UUID id,
            String name,
            String description,
            ScenarioType type,
            int eventCount,
            int templateCount,
            Double eventDensity,
            Double severityScale,
            boolean randomizeTimings,
            boolean allowOverlap,
            Set<String> tags,
            String authorId,
            LocalDateTime createdAt
    ) {}

    public record EventTemplateResponse(
            UUID id,
            String name,
            WorldEventType eventType,
            com.ffl.playoffs.domain.model.EventCategory category,
            Double defaultSeverity,
            com.ffl.playoffs.domain.model.EventImpactType defaultImpact,
            com.ffl.playoffs.domain.model.TimingType defaultTimingType,
            Integer defaultDuration,
            Set<com.ffl.playoffs.domain.model.EventTargetType> validTargets,
            Set<com.ffl.playoffs.domain.model.Position> validPositions,
            Double baseProbability,
            boolean generateNarrative,
            String narrativeTemplate
    ) {}
}
