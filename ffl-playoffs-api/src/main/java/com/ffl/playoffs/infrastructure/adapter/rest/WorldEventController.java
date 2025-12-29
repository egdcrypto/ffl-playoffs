package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.usecase.*;
import com.ffl.playoffs.application.usecase.CreateWorldEventUseCase.CreateWorldEventCommand;
import com.ffl.playoffs.domain.aggregate.WorldEvent;
import com.ffl.playoffs.domain.model.*;
import lombok.RequiredArgsConstructor;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

/**
 * REST controller for World Event operations.
 * Provides endpoints for creating, querying, and managing world events.
 */
@RestController
@RequiredArgsConstructor
public class WorldEventController {

    private static final Logger log = LoggerFactory.getLogger(WorldEventController.class);

    private final CreateWorldEventUseCase createWorldEventUseCase;
    private final ActivateEventUseCase activateEventUseCase;
    private final CancelEventUseCase cancelEventUseCase;
    private final QueryEventsUseCase queryEventsUseCase;
    private final ApplyEventScenarioUseCase applyEventScenarioUseCase;

    // ==================== Admin Event Management ====================

    /**
     * Create a new world event for a simulation world.
     */
    @PostMapping("/api/v1/admin/worlds/{worldId}/events")
    public ResponseEntity<WorldEventResponse> createEvent(
            @PathVariable UUID worldId,
            @RequestBody CreateEventRequest request) {
        log.info("Creating event for world: {}", worldId);

        CreateWorldEventCommand command = CreateWorldEventCommand.builder()
                .simulationWorldId(worldId)
                .type(request.type())
                .category(request.category())
                .name(request.name())
                .description(request.description())
                .targetType(request.targetType())
                .targetPlayerId(request.targetPlayerId())
                .targetTeamAbbr(request.targetTeamAbbr())
                .targetGameId(request.targetGameId())
                .targetName(request.targetName())
                .startWeek(request.startWeek())
                .endWeek(request.endWeek())
                .severity(request.severity())
                .impactType(request.impactType())
                .triggerNarrative(request.triggerNarrative() != null && request.triggerNarrative())
                .narrativeHeadline(request.narrativeHeadline())
                .createdBy(request.createdBy())
                .build();

        WorldEvent event = createWorldEventUseCase.execute(command);
        return ResponseEntity.status(HttpStatus.CREATED).body(toResponse(event));
    }

    /**
     * Get all events for a simulation world.
     */
    @GetMapping("/api/v1/admin/worlds/{worldId}/events")
    public ResponseEntity<List<WorldEventResponse>> getEventsForWorld(@PathVariable UUID worldId) {
        log.info("Getting events for world: {}", worldId);
        List<WorldEvent> events = queryEventsUseCase.findBySimulationWorld(worldId);
        return ResponseEntity.ok(events.stream().map(this::toResponse).toList());
    }

    /**
     * Get event details by ID.
     */
    @GetMapping("/api/v1/admin/events/{eventId}")
    public ResponseEntity<WorldEventResponse> getEvent(@PathVariable UUID eventId) {
        log.info("Getting event: {}", eventId);
        return queryEventsUseCase.findById(eventId)
                .map(event -> ResponseEntity.ok(toResponse(event)))
                .orElse(ResponseEntity.notFound().build());
    }

    /**
     * Activate a scheduled event.
     */
    @PostMapping("/api/v1/admin/events/{eventId}/activate")
    public ResponseEntity<WorldEventResponse> activateEvent(@PathVariable UUID eventId) {
        log.info("Activating event: {}", eventId);
        WorldEvent event = activateEventUseCase.execute(eventId);
        return ResponseEntity.ok(toResponse(event));
    }

    /**
     * Cancel an active or scheduled event.
     */
    @PostMapping("/api/v1/admin/events/{eventId}/cancel")
    public ResponseEntity<WorldEventResponse> cancelEvent(
            @PathVariable UUID eventId,
            @RequestBody(required = false) CancelEventRequest request) {
        log.info("Cancelling event: {}", eventId);
        String reason = request != null && request.reason() != null ? request.reason() : "Cancelled by admin";
        WorldEvent event = cancelEventUseCase.execute(eventId, reason);
        return ResponseEntity.ok(toResponse(event));
    }

    /**
     * Create an event from a template.
     */
    @PostMapping("/api/v1/admin/worlds/{worldId}/events/from-template")
    public ResponseEntity<WorldEventResponse> createEventFromTemplate(
            @PathVariable UUID worldId,
            @RequestBody CreateFromTemplateRequest request) {
        log.info("Creating event from template {} for world {}", request.templateId(), worldId);

        WorldEvent event = applyEventScenarioUseCase.createEventFromTemplate(
                request.templateId(),
                worldId,
                request.targetPlayerId(),
                request.targetName(),
                request.startWeek(),
                request.durationWeeks()
        );

        return ResponseEntity.status(HttpStatus.CREATED).body(toResponse(event));
    }

    /**
     * Apply a scenario to a simulation world.
     */
    @PostMapping("/api/v1/admin/worlds/{worldId}/apply-scenario")
    public ResponseEntity<List<WorldEventResponse>> applyScenario(
            @PathVariable UUID worldId,
            @RequestBody ApplyScenarioRequest request) {
        log.info("Applying scenario {} to world {}", request.scenarioId(), worldId);

        List<WorldEvent> events = applyEventScenarioUseCase.execute(request.scenarioId(), worldId);
        return ResponseEntity.status(HttpStatus.CREATED)
                .body(events.stream().map(this::toResponse).toList());
    }

    // ==================== Query Endpoints ====================

    /**
     * Get events for a simulation run.
     */
    @GetMapping("/api/v1/simulations/{runId}/events")
    public ResponseEntity<List<WorldEventResponse>> getEventsForRun(@PathVariable UUID runId) {
        log.info("Getting events for simulation run: {}", runId);
        List<WorldEvent> events = queryEventsUseCase.findBySimulationRun(runId);
        return ResponseEntity.ok(events.stream().map(this::toResponse).toList());
    }

    /**
     * Get active events for a specific week.
     */
    @GetMapping("/api/v1/simulations/{runId}/events/week/{week}")
    public ResponseEntity<WeeklySummaryResponse> getEventsForWeek(
            @PathVariable UUID runId,
            @PathVariable Integer week) {
        log.info("Getting events for run {} week {}", runId, week);
        QueryEventsUseCase.WeeklyEventSummary summary = queryEventsUseCase.getWeeklySummary(runId, week);
        return ResponseEntity.ok(toWeeklySummaryResponse(summary));
    }

    /**
     * Get events affecting a specific player.
     */
    @GetMapping("/api/v1/simulations/{runId}/events/player/{playerId}")
    public ResponseEntity<List<WorldEventResponse>> getEventsForPlayer(
            @PathVariable UUID runId,
            @PathVariable Long playerId,
            @RequestParam(required = false) Integer week) {
        log.info("Getting events for player {} in run {}", playerId, runId);
        Integer activeWeek = week != null ? week : 1;
        List<WorldEvent> events = queryEventsUseCase.findEventsForPlayer(runId, playerId, activeWeek);
        return ResponseEntity.ok(events.stream().map(this::toResponse).toList());
    }

    /**
     * Get events affecting a specific team.
     */
    @GetMapping("/api/v1/simulations/{runId}/events/team/{teamAbbr}")
    public ResponseEntity<List<WorldEventResponse>> getEventsForTeam(
            @PathVariable UUID runId,
            @PathVariable String teamAbbr,
            @RequestParam(required = false) Integer week) {
        log.info("Getting events for team {} in run {}", teamAbbr, runId);
        Integer activeWeek = week != null ? week : 1;
        List<WorldEvent> events = queryEventsUseCase.findEventsForTeam(runId, teamAbbr, activeWeek);
        return ResponseEntity.ok(events.stream().map(this::toResponse).toList());
    }

    // ==================== Response Mapping ====================

    private WorldEventResponse toResponse(WorldEvent event) {
        return new WorldEventResponse(
                event.getId(),
                event.getSimulationWorldId(),
                event.getSimulationRunId(),
                event.getType(),
                event.getCategory(),
                event.getName(),
                event.getDescription(),
                event.getStartWeek(),
                event.getEndWeek(),
                event.getStatus(),
                event.getSource(),
                event.getSeverity(),
                event.getImpactType(),
                event.isTriggerNarrative(),
                event.getNarrativeHeadline(),
                event.getCreatedBy(),
                event.getCreatedAt()
        );
    }

    private WeeklySummaryResponse toWeeklySummaryResponse(QueryEventsUseCase.WeeklyEventSummary summary) {
        return new WeeklySummaryResponse(
                summary.week(),
                summary.totalEvents(),
                summary.injuryEvents(),
                summary.weatherEvents(),
                summary.positiveEvents(),
                summary.events().stream().map(this::toResponse).toList()
        );
    }

    // ==================== Request/Response Records ====================

    public record CreateEventRequest(
            WorldEventType type,
            EventCategory category,
            String name,
            String description,
            EventTargetType targetType,
            Long targetPlayerId,
            String targetTeamAbbr,
            UUID targetGameId,
            String targetName,
            Integer startWeek,
            Integer endWeek,
            Double severity,
            EventImpactType impactType,
            Boolean triggerNarrative,
            String narrativeHeadline,
            String createdBy
    ) {}

    public record CancelEventRequest(String reason) {}

    public record CreateFromTemplateRequest(
            UUID templateId,
            Long targetPlayerId,
            String targetName,
            Integer startWeek,
            Integer durationWeeks
    ) {}

    public record ApplyScenarioRequest(UUID scenarioId) {}

    public record WorldEventResponse(
            UUID id,
            UUID simulationWorldId,
            UUID simulationRunId,
            WorldEventType type,
            EventCategory category,
            String name,
            String description,
            Integer startWeek,
            Integer endWeek,
            EventStatus status,
            EventSource source,
            Double severity,
            EventImpactType impactType,
            boolean triggerNarrative,
            String narrativeHeadline,
            String createdBy,
            java.time.LocalDateTime createdAt
    ) {}

    public record WeeklySummaryResponse(
            Integer week,
            int totalEvents,
            long injuryEvents,
            long weatherEvents,
            long positiveEvents,
            List<WorldEventResponse> events
    ) {}
}
