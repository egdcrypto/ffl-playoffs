package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.EventScenario;
import com.ffl.playoffs.domain.aggregate.WorldEvent;
import com.ffl.playoffs.domain.entity.EventTemplate;
import com.ffl.playoffs.domain.model.EventCategory;
import com.ffl.playoffs.domain.model.ScenarioType;
import com.ffl.playoffs.domain.model.WorldEventType;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for WorldEvent persistence.
 * Port in hexagonal architecture.
 */
public interface WorldEventRepository {

    // WorldEvent CRUD
    WorldEvent save(WorldEvent event);
    Optional<WorldEvent> findById(UUID id);
    void delete(UUID id);

    // Query by simulation
    List<WorldEvent> findBySimulationWorld(UUID worldId);
    List<WorldEvent> findBySimulationRun(UUID runId);

    // Query by status/timing
    List<WorldEvent> findActiveEvents(UUID simulationRunId, Integer week);
    List<WorldEvent> findScheduledEvents(UUID worldId);
    List<WorldEvent> findExpiredEvents(UUID simulationRunId);

    // Query by target
    List<WorldEvent> findActiveEventsForPlayer(UUID runId, Long playerId, Integer week);
    List<WorldEvent> findActiveEventsForTeam(UUID runId, String teamAbbr, Integer week);
    List<WorldEvent> findActiveEventsForGame(UUID runId, UUID gameId);

    // Query by type
    List<WorldEvent> findByType(UUID simulationRunId, WorldEventType type);
    List<WorldEvent> findByCategory(UUID simulationRunId, EventCategory category);

    // EventScenario
    EventScenario saveScenario(EventScenario scenario);
    Optional<EventScenario> findScenarioById(UUID id);
    List<EventScenario> findScenariosByType(ScenarioType type);
    List<EventScenario> findAllScenarios();

    // EventTemplate
    EventTemplate saveTemplate(EventTemplate template);
    Optional<EventTemplate> findTemplateById(UUID id);
    List<EventTemplate> findTemplatesByType(WorldEventType type);
    List<EventTemplate> findAllTemplates();
}
