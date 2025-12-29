package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.EventScenario;
import com.ffl.playoffs.domain.aggregate.WorldEvent;
import com.ffl.playoffs.domain.entity.EventTemplate;
import com.ffl.playoffs.domain.model.EventCategory;
import com.ffl.playoffs.domain.model.ScenarioType;
import com.ffl.playoffs.domain.model.WorldEventType;
import com.ffl.playoffs.domain.port.WorldEventRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.EventScenarioDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.EventTemplateDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldEventDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.WorldEventMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.EventScenarioMongoRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.EventTemplateMongoRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.WorldEventMongoRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of WorldEventRepository port.
 * Infrastructure layer adapter.
 */
@Repository
public class WorldEventRepositoryImpl implements WorldEventRepository {

    private static final Logger log = LoggerFactory.getLogger(WorldEventRepositoryImpl.class);

    private final WorldEventMongoRepository eventMongoRepository;
    private final EventScenarioMongoRepository scenarioMongoRepository;
    private final EventTemplateMongoRepository templateMongoRepository;
    private final WorldEventMapper mapper;

    public WorldEventRepositoryImpl(WorldEventMongoRepository eventMongoRepository,
                                     EventScenarioMongoRepository scenarioMongoRepository,
                                     EventTemplateMongoRepository templateMongoRepository,
                                     WorldEventMapper mapper) {
        this.eventMongoRepository = eventMongoRepository;
        this.scenarioMongoRepository = scenarioMongoRepository;
        this.templateMongoRepository = templateMongoRepository;
        this.mapper = mapper;
    }

    // ==================== WorldEvent Operations ====================

    @Override
    public WorldEvent save(WorldEvent event) {
        log.debug("Saving world event: {}", event.getId());
        WorldEventDocument document = mapper.toDocument(event);
        WorldEventDocument saved = eventMongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<WorldEvent> findById(UUID id) {
        log.debug("Finding world event by id: {}", id);
        return eventMongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public void delete(UUID id) {
        log.debug("Deleting world event: {}", id);
        eventMongoRepository.deleteById(id.toString());
    }

    @Override
    public List<WorldEvent> findBySimulationWorld(UUID worldId) {
        log.debug("Finding events by simulation world: {}", worldId);
        return eventMongoRepository.findBySimulationWorldId(worldId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WorldEvent> findBySimulationRun(UUID runId) {
        log.debug("Finding events by simulation run: {}", runId);
        return eventMongoRepository.findBySimulationRunId(runId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WorldEvent> findActiveEvents(UUID simulationRunId, Integer week) {
        log.debug("Finding active events for run {} week {}", simulationRunId, week);
        return eventMongoRepository.findActiveEventsForWeek(simulationRunId.toString(), week)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WorldEvent> findScheduledEvents(UUID worldId) {
        log.debug("Finding scheduled events for world: {}", worldId);
        return eventMongoRepository.findBySimulationWorldIdAndStatus(worldId.toString(), "SCHEDULED")
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WorldEvent> findExpiredEvents(UUID simulationRunId) {
        log.debug("Finding expired events for run: {}", simulationRunId);
        return eventMongoRepository.findExpiredEvents(simulationRunId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WorldEvent> findActiveEventsForPlayer(UUID runId, Long playerId, Integer week) {
        log.debug("Finding active events for player {} in run {} week {}", playerId, runId, week);
        return eventMongoRepository.findActiveEventsForPlayer(runId.toString(), playerId.toString(), week)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WorldEvent> findActiveEventsForTeam(UUID runId, String teamAbbr, Integer week) {
        log.debug("Finding active events for team {} in run {} week {}", teamAbbr, runId, week);
        return eventMongoRepository.findActiveEventsForTeam(runId.toString(), teamAbbr, week)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WorldEvent> findActiveEventsForGame(UUID runId, UUID gameId) {
        log.debug("Finding active events for game {} in run {}", gameId, runId);
        return eventMongoRepository.findEventsForGame(runId.toString(), gameId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WorldEvent> findByType(UUID simulationRunId, WorldEventType type) {
        log.debug("Finding events by type {} for run {}", type, simulationRunId);
        return eventMongoRepository.findBySimulationRunIdAndType(simulationRunId.toString(), type.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WorldEvent> findByCategory(UUID simulationRunId, EventCategory category) {
        log.debug("Finding events by category {} for run {}", category, simulationRunId);
        return eventMongoRepository.findBySimulationRunIdAndCategory(simulationRunId.toString(), category.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    // ==================== EventScenario Operations ====================

    @Override
    public EventScenario saveScenario(EventScenario scenario) {
        log.debug("Saving event scenario: {}", scenario.getId());
        EventScenarioDocument document = mapper.toScenarioDocument(scenario);
        EventScenarioDocument saved = scenarioMongoRepository.save(document);
        return mapper.toScenarioDomain(saved);
    }

    @Override
    public Optional<EventScenario> findScenarioById(UUID id) {
        log.debug("Finding scenario by id: {}", id);
        return scenarioMongoRepository.findById(id.toString())
                .map(mapper::toScenarioDomain);
    }

    @Override
    public List<EventScenario> findScenariosByType(ScenarioType type) {
        log.debug("Finding scenarios by type: {}", type);
        return scenarioMongoRepository.findByType(type.name())
                .stream()
                .map(mapper::toScenarioDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<EventScenario> findAllScenarios() {
        log.debug("Finding all scenarios");
        return scenarioMongoRepository.findAll()
                .stream()
                .map(mapper::toScenarioDomain)
                .collect(Collectors.toList());
    }

    // ==================== EventTemplate Operations ====================

    @Override
    public EventTemplate saveTemplate(EventTemplate template) {
        log.debug("Saving event template: {}", template.getId());
        EventTemplateDocument document = mapper.toTemplateDocument(template);
        EventTemplateDocument saved = templateMongoRepository.save(document);
        return mapper.toTemplateDomain(saved);
    }

    @Override
    public Optional<EventTemplate> findTemplateById(UUID id) {
        log.debug("Finding template by id: {}", id);
        return templateMongoRepository.findById(id.toString())
                .map(mapper::toTemplateDomain);
    }

    @Override
    public List<EventTemplate> findTemplatesByType(WorldEventType type) {
        log.debug("Finding templates by type: {}", type);
        return templateMongoRepository.findByEventType(type.name())
                .stream()
                .map(mapper::toTemplateDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<EventTemplate> findAllTemplates() {
        log.debug("Finding all templates");
        return templateMongoRepository.findAll()
                .stream()
                .map(mapper::toTemplateDomain)
                .collect(Collectors.toList());
    }
}
