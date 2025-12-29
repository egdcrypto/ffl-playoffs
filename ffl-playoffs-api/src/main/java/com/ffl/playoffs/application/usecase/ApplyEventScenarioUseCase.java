package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.EventScenario;
import com.ffl.playoffs.domain.aggregate.WorldEvent;
import com.ffl.playoffs.domain.entity.EventTemplate;
import com.ffl.playoffs.domain.model.EventSource;
import com.ffl.playoffs.domain.model.EventTiming;
import com.ffl.playoffs.domain.port.WorldEventRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Use case for applying an event scenario to a simulation world.
 */
public class ApplyEventScenarioUseCase {

    private static final Logger log = LoggerFactory.getLogger(ApplyEventScenarioUseCase.class);

    private final WorldEventRepository eventRepository;

    public ApplyEventScenarioUseCase(WorldEventRepository eventRepository) {
        this.eventRepository = eventRepository;
    }

    public List<WorldEvent> execute(UUID scenarioId, UUID simulationWorldId) {
        log.info("Applying scenario {} to world {}", scenarioId, simulationWorldId);

        EventScenario scenario = eventRepository.findScenarioById(scenarioId)
                .orElseThrow(() -> new ScenarioNotFoundException("Scenario not found: " + scenarioId));

        List<WorldEvent> appliedEvents = new ArrayList<>();

        // Apply existing events from scenario
        for (WorldEvent event : scenario.getEvents()) {
            WorldEvent copy = copyEventForWorld(event, simulationWorldId);
            WorldEvent saved = eventRepository.save(copy);
            appliedEvents.add(saved);
        }

        log.info("Applied {} events from scenario '{}' to world {}",
                appliedEvents.size(), scenario.getName(), simulationWorldId);

        return appliedEvents;
    }

    public WorldEvent createEventFromTemplate(UUID templateId, UUID simulationWorldId,
                                               Long targetPlayerId, String targetName,
                                               Integer startWeek, Integer durationWeeks) {
        log.info("Creating event from template {} for player {}", templateId, targetPlayerId);

        EventTemplate template = eventRepository.findTemplateById(templateId)
                .orElseThrow(() -> new TemplateNotFoundException("Template not found: " + templateId));

        var target = com.ffl.playoffs.domain.model.EventTarget.player(targetPlayerId, targetName);

        EventTiming timing;
        if (durationWeeks != null && durationWeeks > 1) {
            timing = EventTiming.weekRange(startWeek, startWeek + durationWeeks - 1);
        } else {
            timing = EventTiming.singleWeek(startWeek);
        }

        WorldEvent event = template.instantiate(target, timing);
        event.setSimulationWorldId(simulationWorldId);
        event.setSource(EventSource.CURATED);

        WorldEvent saved = eventRepository.save(event);
        log.info("Created event {} from template {}", saved.getId(), templateId);

        return saved;
    }

    private WorldEvent copyEventForWorld(WorldEvent source, UUID worldId) {
        WorldEvent copy = new WorldEvent();
        copy.setSimulationWorldId(worldId);
        copy.setType(source.getType());
        copy.setCategory(source.getCategory());
        copy.setName(source.getName());
        copy.setDescription(source.getDescription());
        copy.setTiming(source.getTiming());
        copy.setStartWeek(source.getStartWeek());
        copy.setEndWeek(source.getEndWeek());
        copy.setTargets(source.getTargets());
        copy.setScope(source.getScope());
        copy.setEffects(source.getEffects());
        copy.setSeverity(source.getSeverity());
        copy.setImpactType(source.getImpactType());
        copy.setSource(EventSource.CURATED);
        copy.setTriggerNarrative(source.isTriggerNarrative());
        copy.setNarrativeHeadline(source.getNarrativeHeadline());
        return copy;
    }

    public static class ScenarioNotFoundException extends RuntimeException {
        public ScenarioNotFoundException(String message) {
            super(message);
        }
    }

    public static class TemplateNotFoundException extends RuntimeException {
        public TemplateNotFoundException(String message) {
            super(message);
        }
    }
}
