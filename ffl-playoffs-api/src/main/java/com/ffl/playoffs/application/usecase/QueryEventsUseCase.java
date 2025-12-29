package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldEvent;
import com.ffl.playoffs.domain.model.EventCategory;
import com.ffl.playoffs.domain.model.WorldEventType;
import com.ffl.playoffs.domain.port.WorldEventRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for querying world events.
 */
public class QueryEventsUseCase {

    private static final Logger log = LoggerFactory.getLogger(QueryEventsUseCase.class);

    private final WorldEventRepository eventRepository;

    public QueryEventsUseCase(WorldEventRepository eventRepository) {
        this.eventRepository = eventRepository;
    }

    public Optional<WorldEvent> findById(UUID eventId) {
        return eventRepository.findById(eventId);
    }

    public List<WorldEvent> findBySimulationWorld(UUID worldId) {
        return eventRepository.findBySimulationWorld(worldId);
    }

    public List<WorldEvent> findBySimulationRun(UUID runId) {
        return eventRepository.findBySimulationRun(runId);
    }

    public List<WorldEvent> findActiveEvents(UUID simulationRunId, Integer week) {
        return eventRepository.findActiveEvents(simulationRunId, week);
    }

    public List<WorldEvent> findEventsForPlayer(UUID runId, Long playerId, Integer week) {
        return eventRepository.findActiveEventsForPlayer(runId, playerId, week);
    }

    public List<WorldEvent> findEventsForTeam(UUID runId, String teamAbbr, Integer week) {
        return eventRepository.findActiveEventsForTeam(runId, teamAbbr, week);
    }

    public List<WorldEvent> findEventsForGame(UUID runId, UUID gameId) {
        return eventRepository.findActiveEventsForGame(runId, gameId);
    }

    public List<WorldEvent> findByType(UUID runId, WorldEventType type) {
        return eventRepository.findByType(runId, type);
    }

    public List<WorldEvent> findByCategory(UUID runId, EventCategory category) {
        return eventRepository.findByCategory(runId, category);
    }

    public WeeklyEventSummary getWeeklySummary(UUID simulationRunId, Integer week) {
        List<WorldEvent> events = findActiveEvents(simulationRunId, week);

        long injuries = events.stream()
                .filter(e -> e.getType().isPlayerEvent() && e.getType().isNegative())
                .count();
        long weather = events.stream()
                .filter(e -> e.getType().isWeatherEvent())
                .count();
        long positive = events.stream()
                .filter(e -> !e.getType().isNegative())
                .count();

        return new WeeklyEventSummary(week, events.size(), injuries, weather, positive, events);
    }

    public record WeeklyEventSummary(
            Integer week,
            int totalEvents,
            long injuryEvents,
            long weatherEvents,
            long positiveEvents,
            List<WorldEvent> events
    ) {}
}
