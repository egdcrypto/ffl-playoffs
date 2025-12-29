package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldEvent;
import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.domain.port.WorldEventRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.UUID;

/**
 * Use case for creating a new world event.
 */
public class CreateWorldEventUseCase {

    private static final Logger log = LoggerFactory.getLogger(CreateWorldEventUseCase.class);

    private final WorldEventRepository eventRepository;

    public CreateWorldEventUseCase(WorldEventRepository eventRepository) {
        this.eventRepository = eventRepository;
    }

    public WorldEvent execute(CreateWorldEventCommand command) {
        log.info("Creating world event: type={}, target={}", command.type(), command.targetName());

        WorldEvent event = new WorldEvent();
        event.setSimulationWorldId(command.simulationWorldId());
        event.setType(command.type());
        event.setCategory(command.category());
        event.setName(command.name());
        event.setDescription(command.description());
        event.setStartWeek(command.startWeek());
        event.setEndWeek(command.endWeek());
        event.setSeverity(command.severity());
        event.setImpactType(command.impactType());
        event.setSource(EventSource.CURATED);
        event.setCreatedBy(command.createdBy());

        // Set timing
        if (command.startWeek() != null && command.endWeek() != null) {
            event.setTiming(EventTiming.weekRange(command.startWeek(), command.endWeek()));
        } else if (command.startWeek() != null) {
            event.setTiming(EventTiming.singleWeek(command.startWeek()));
        }

        // Add target
        EventTarget target = createTarget(command);
        event.addTarget(target);
        event.setScope(determineScope(command.targetType()));

        // Add effects based on type and severity
        addDefaultEffects(event, command);

        // Narrative settings
        event.setTriggerNarrative(command.triggerNarrative());
        if (command.narrativeHeadline() != null) {
            event.setNarrativeHeadline(command.narrativeHeadline());
        }

        WorldEvent saved = eventRepository.save(event);
        log.info("Created world event: id={}", saved.getId());

        return saved;
    }

    private EventTarget createTarget(CreateWorldEventCommand command) {
        return switch (command.targetType()) {
            case PLAYER -> EventTarget.player(command.targetPlayerId(), command.targetName());
            case TEAM -> EventTarget.team(command.targetTeamAbbr(), command.targetName());
            case GAME -> EventTarget.game(command.targetGameId(), command.targetName());
            case LEAGUE -> EventTarget.league();
            default -> EventTarget.team(command.targetTeamAbbr(), command.targetName());
        };
    }

    private EventScope determineScope(EventTargetType targetType) {
        return switch (targetType) {
            case PLAYER -> EventScope.INDIVIDUAL;
            case TEAM, MATCHUP -> EventScope.TEAM;
            case LEAGUE -> EventScope.LEAGUE;
            default -> EventScope.INDIVIDUAL;
        };
    }

    private void addDefaultEffects(WorldEvent event, CreateWorldEventCommand command) {
        if (command.customEffect() != null) {
            event.addEffect(command.customEffect());
            return;
        }

        // Add default effects based on type and severity
        Double severity = command.severity() != null ? command.severity() : 0.5;

        switch (command.type()) {
            case INJURY -> {
                if (severity >= 0.9) {
                    event.addEffect(EventEffect.injuryOut());
                } else if (severity >= 0.5) {
                    event.addEffect(EventEffect.injuryMajor());
                } else {
                    event.addEffect(EventEffect.injuryMinor());
                }
            }
            case BREAKOUT -> event.addEffect(EventEffect.hotStreak());
            case SLUMP -> event.addEffect(EventEffect.coldStreak());
            case WEATHER_SNOW -> event.addEffect(EventEffect.weatherSnow());
            case WEATHER_RAIN -> event.addEffect(EventEffect.weatherRain());
            case PRIME_TIME -> event.addEffect(EventEffect.primeTime());
            default -> {
                // For other types, create a generic effect based on impact type
                if (command.impactType() == EventImpactType.POSITIVE) {
                    event.addEffect(EventEffect.builder()
                            .type(EffectType.BOOST)
                            .statModifier(StatCategory.ALL_STATS, 1.0 + (severity * 0.3))
                            .build());
                } else if (command.impactType() == EventImpactType.NEGATIVE) {
                    event.addEffect(EventEffect.builder()
                            .type(EffectType.REDUCTION)
                            .statModifier(StatCategory.ALL_STATS, 1.0 - (severity * 0.3))
                            .build());
                }
            }
        }
    }

    public record CreateWorldEventCommand(
            UUID simulationWorldId,
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
            EventEffect customEffect,
            boolean triggerNarrative,
            String narrativeHeadline,
            String createdBy
    ) {
        public static Builder builder() {
            return new Builder();
        }

        public static class Builder {
            private UUID simulationWorldId;
            private WorldEventType type;
            private EventCategory category;
            private String name;
            private String description;
            private EventTargetType targetType;
            private Long targetPlayerId;
            private String targetTeamAbbr;
            private UUID targetGameId;
            private String targetName;
            private Integer startWeek;
            private Integer endWeek;
            private Double severity;
            private EventImpactType impactType;
            private EventEffect customEffect;
            private boolean triggerNarrative;
            private String narrativeHeadline;
            private String createdBy;

            public Builder simulationWorldId(UUID id) { this.simulationWorldId = id; return this; }
            public Builder type(WorldEventType type) { this.type = type; return this; }
            public Builder category(EventCategory category) { this.category = category; return this; }
            public Builder name(String name) { this.name = name; return this; }
            public Builder description(String description) { this.description = description; return this; }
            public Builder targetType(EventTargetType type) { this.targetType = type; return this; }
            public Builder targetPlayerId(Long id) { this.targetPlayerId = id; return this; }
            public Builder targetTeamAbbr(String abbr) { this.targetTeamAbbr = abbr; return this; }
            public Builder targetGameId(UUID id) { this.targetGameId = id; return this; }
            public Builder targetName(String name) { this.targetName = name; return this; }
            public Builder startWeek(Integer week) { this.startWeek = week; return this; }
            public Builder endWeek(Integer week) { this.endWeek = week; return this; }
            public Builder severity(Double severity) { this.severity = severity; return this; }
            public Builder impactType(EventImpactType type) { this.impactType = type; return this; }
            public Builder customEffect(EventEffect effect) { this.customEffect = effect; return this; }
            public Builder triggerNarrative(boolean trigger) { this.triggerNarrative = trigger; return this; }
            public Builder narrativeHeadline(String headline) { this.narrativeHeadline = headline; return this; }
            public Builder createdBy(String user) { this.createdBy = user; return this; }

            public CreateWorldEventCommand build() {
                return new CreateWorldEventCommand(
                        simulationWorldId, type, category, name, description, targetType,
                        targetPlayerId, targetTeamAbbr, targetGameId, targetName,
                        startWeek, endWeek, severity, impactType, customEffect,
                        triggerNarrative, narrativeHeadline, createdBy
                );
            }
        }
    }
}
