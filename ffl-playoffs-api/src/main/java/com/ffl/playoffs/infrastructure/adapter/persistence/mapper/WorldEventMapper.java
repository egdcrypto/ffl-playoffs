package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.EventScenario;
import com.ffl.playoffs.domain.aggregate.WorldEvent;
import com.ffl.playoffs.domain.entity.EventTemplate;
import com.ffl.playoffs.domain.model.*;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.EventScenarioDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.EventTemplateDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldEventDocument;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Mapper to convert between WorldEvent domain models and MongoDB documents.
 * Infrastructure layer.
 */
@Component
public class WorldEventMapper {

    // ==================== WorldEvent Mapping ====================

    public WorldEventDocument toDocument(WorldEvent event) {
        if (event == null) {
            return null;
        }

        return WorldEventDocument.builder()
                .id(event.getId() != null ? event.getId().toString() : null)
                .simulationWorldId(event.getSimulationWorldId() != null ? event.getSimulationWorldId().toString() : null)
                .simulationRunId(event.getSimulationRunId() != null ? event.getSimulationRunId().toString() : null)
                .type(event.getType() != null ? event.getType().name() : null)
                .category(event.getCategory() != null ? event.getCategory().name() : null)
                .name(event.getName())
                .description(event.getDescription())
                .timing(toTimingDocument(event.getTiming()))
                .startWeek(event.getStartWeek())
                .endWeek(event.getEndWeek())
                .scheduledAt(event.getScheduledAt())
                .activatedAt(event.getActivatedAt())
                .expiredAt(event.getExpiredAt())
                .targets(toTargetDocuments(event.getTargets()))
                .scope(event.getScope() != null ? event.getScope().name() : null)
                .effects(toEffectDocuments(event.getEffects()))
                .severity(event.getSeverity())
                .impactType(event.getImpactType() != null ? event.getImpactType().name() : null)
                .status(event.getStatus() != null ? event.getStatus().name() : null)
                .source(event.getSource() != null ? event.getSource().name() : null)
                .cancellationReason(event.getCancellationReason())
                .triggerNarrative(event.isTriggerNarrative())
                .narrativeType(event.getNarrativeType() != null ? event.getNarrativeType().name() : null)
                .narrativeHeadline(event.getNarrativeHeadline())
                .createdBy(event.getCreatedBy())
                .createdAt(event.getCreatedAt())
                .version(event.getVersion())
                .build();
    }

    public WorldEvent toDomain(WorldEventDocument doc) {
        if (doc == null) {
            return null;
        }

        WorldEvent event = new WorldEvent();
        event.setId(doc.getId() != null ? UUID.fromString(doc.getId()) : null);
        event.setSimulationWorldId(doc.getSimulationWorldId() != null ? UUID.fromString(doc.getSimulationWorldId()) : null);
        event.setSimulationRunId(doc.getSimulationRunId() != null ? UUID.fromString(doc.getSimulationRunId()) : null);
        event.setType(doc.getType() != null ? WorldEventType.valueOf(doc.getType()) : null);
        event.setCategory(doc.getCategory() != null ? EventCategory.valueOf(doc.getCategory()) : null);
        event.setName(doc.getName());
        event.setDescription(doc.getDescription());
        event.setTiming(toTimingDomain(doc.getTiming()));
        event.setStartWeek(doc.getStartWeek());
        event.setEndWeek(doc.getEndWeek());
        event.setScheduledAt(doc.getScheduledAt());
        event.setActivatedAt(doc.getActivatedAt());
        event.setExpiredAt(doc.getExpiredAt());
        event.setTargets(toTargetDomains(doc.getTargets()));
        event.setScope(doc.getScope() != null ? EventScope.valueOf(doc.getScope()) : null);
        event.setEffects(toEffectDomains(doc.getEffects()));
        event.setSeverity(doc.getSeverity());
        event.setImpactType(doc.getImpactType() != null ? EventImpactType.valueOf(doc.getImpactType()) : null);
        event.setStatus(doc.getStatus() != null ? EventStatus.valueOf(doc.getStatus()) : null);
        event.setSource(doc.getSource() != null ? EventSource.valueOf(doc.getSource()) : null);
        event.setTriggerNarrative(doc.isTriggerNarrative());
        event.setNarrativeType(doc.getNarrativeType() != null ?
                WorldEvent.NarrativeEventType.valueOf(doc.getNarrativeType()) : null);
        event.setNarrativeHeadline(doc.getNarrativeHeadline());
        event.setCreatedBy(doc.getCreatedBy());
        event.setCreatedAt(doc.getCreatedAt());
        event.setVersion(doc.getVersion());

        return event;
    }

    // ==================== EventTiming Mapping ====================

    private WorldEventDocument.TimingDocument toTimingDocument(EventTiming timing) {
        if (timing == null) {
            return null;
        }

        return WorldEventDocument.TimingDocument.builder()
                .type(timing.getType() != null ? timing.getType().name() : null)
                .weekStart(timing.getWeekStart())
                .weekEnd(timing.getWeekEnd())
                .specificGameId(timing.getSpecificGameId() != null ? timing.getSpecificGameId().toString() : null)
                .recurring(timing.isRecurring())
                .recurrencePattern(timing.getRecurrence() != null ? timing.getRecurrence().name() : null)
                .recurringWeeks(timing.getRecurringWeeks() != null ? new ArrayList<>(timing.getRecurringWeeks()) : null)
                .build();
    }

    private EventTiming toTimingDomain(WorldEventDocument.TimingDocument doc) {
        if (doc == null) {
            return null;
        }

        TimingType type = doc.getType() != null ? TimingType.valueOf(doc.getType()) : TimingType.SINGLE_WEEK;

        return switch (type) {
            case SINGLE_WEEK -> EventTiming.singleWeek(doc.getWeekStart() != null ? doc.getWeekStart() : 1);
            case MULTI_WEEK -> EventTiming.weekRange(
                    doc.getWeekStart() != null ? doc.getWeekStart() : 1,
                    doc.getWeekEnd() != null ? doc.getWeekEnd() : 1);
            case INDEFINITE -> EventTiming.indefinite(doc.getWeekStart() != null ? doc.getWeekStart() : 1);
            case SINGLE_GAME -> EventTiming.forGame(
                    doc.getSpecificGameId() != null ? UUID.fromString(doc.getSpecificGameId()) : UUID.randomUUID());
            case INSTANT -> EventTiming.instant();
            default -> EventTiming.singleWeek(1);
        };
    }

    // ==================== EventTarget Mapping ====================

    private List<WorldEventDocument.TargetDocument> toTargetDocuments(List<EventTarget> targets) {
        if (targets == null) {
            return null;
        }

        return targets.stream()
                .map(this::toTargetDocument)
                .collect(Collectors.toList());
    }

    private WorldEventDocument.TargetDocument toTargetDocument(EventTarget target) {
        if (target == null) {
            return null;
        }

        return WorldEventDocument.TargetDocument.builder()
                .type(target.getType() != null ? target.getType().name() : null)
                .targetId(target.getTargetId())
                .targetName(target.getTargetName())
                .position(target.getPosition() != null ? target.getPosition().name() : null)
                .teamContext(target.getTeamContext())
                .role(target.getRole() != null ? target.getRole().name() : null)
                .limit(target.getLimit())
                .build();
    }

    private List<EventTarget> toTargetDomains(List<WorldEventDocument.TargetDocument> docs) {
        if (docs == null) {
            return new ArrayList<>();
        }

        return docs.stream()
                .map(this::toTargetDomain)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    private EventTarget toTargetDomain(WorldEventDocument.TargetDocument doc) {
        if (doc == null) {
            return null;
        }

        EventTargetType type = doc.getType() != null ? EventTargetType.valueOf(doc.getType()) : EventTargetType.PLAYER;

        return switch (type) {
            case PLAYER -> EventTarget.player(
                    doc.getTargetId() != null ? Long.parseLong(doc.getTargetId()) : 0L,
                    doc.getTargetName());
            case TEAM -> EventTarget.team(doc.getTargetId(), doc.getTargetName());
            case GAME -> EventTarget.game(
                    doc.getTargetId() != null ? UUID.fromString(doc.getTargetId()) : UUID.randomUUID(),
                    doc.getTargetName());
            case POSITION -> EventTarget.position(
                    doc.getPosition() != null ? Position.valueOf(doc.getPosition()) : Position.QB,
                    doc.getTeamContext(),
                    doc.getRole() != null ? TargetRole.valueOf(doc.getRole()) : TargetRole.ALL);
            case MATCHUP -> EventTarget.matchup(
                    doc.getTargetId() != null ? UUID.fromString(doc.getTargetId()) : UUID.randomUUID(),
                    doc.getTargetName());
            case LEAGUE -> EventTarget.league();
        };
    }

    // ==================== EventEffect Mapping ====================

    private List<WorldEventDocument.EffectDocument> toEffectDocuments(List<EventEffect> effects) {
        if (effects == null) {
            return null;
        }

        return effects.stream()
                .map(this::toEffectDocument)
                .collect(Collectors.toList());
    }

    private WorldEventDocument.EffectDocument toEffectDocument(EventEffect effect) {
        if (effect == null) {
            return null;
        }

        Map<String, Double> statMods = new HashMap<>();
        if (effect.getStatModifiers() != null) {
            for (var entry : effect.getStatModifiers().entrySet()) {
                statMods.put(entry.getKey().name(), entry.getValue());
            }
        }

        return WorldEventDocument.EffectDocument.builder()
                .type(effect.getType() != null ? effect.getType().name() : null)
                .application(effect.getApplication() != null ? effect.getApplication().name() : null)
                .statModifiers(statMods)
                .availabilityChance(effect.getAvailabilityChance())
                .forceOut(effect.getForceOut())
                .ceilingModifier(effect.getCeilingModifier())
                .floorModifier(effect.getFloorModifier())
                .varianceModifier(effect.getVarianceModifier())
                .fantasyPointsModifier(effect.getFantasyPointsModifier())
                .effectProbability(effect.getEffectProbability())
                .build();
    }

    private List<EventEffect> toEffectDomains(List<WorldEventDocument.EffectDocument> docs) {
        if (docs == null) {
            return new ArrayList<>();
        }

        return docs.stream()
                .map(this::toEffectDomain)
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
    }

    private EventEffect toEffectDomain(WorldEventDocument.EffectDocument doc) {
        if (doc == null) {
            return null;
        }

        EventEffect.Builder builder = EventEffect.builder()
                .type(doc.getType() != null ? EffectType.valueOf(doc.getType()) : EffectType.BOOST)
                .application(doc.getApplication() != null ?
                        EffectApplication.valueOf(doc.getApplication()) : EffectApplication.MULTIPLIER)
                .availabilityChance(doc.getAvailabilityChance())
                .forceOut(doc.getForceOut())
                .ceilingModifier(doc.getCeilingModifier())
                .floorModifier(doc.getFloorModifier())
                .varianceModifier(doc.getVarianceModifier())
                .fantasyPointsModifier(doc.getFantasyPointsModifier())
                .effectProbability(doc.getEffectProbability());

        if (doc.getStatModifiers() != null) {
            for (var entry : doc.getStatModifiers().entrySet()) {
                builder.statModifier(StatCategory.valueOf(entry.getKey()), entry.getValue());
            }
        }

        return builder.build();
    }

    // ==================== EventScenario Mapping ====================

    public EventScenarioDocument toScenarioDocument(EventScenario scenario) {
        if (scenario == null) {
            return null;
        }

        List<WorldEventDocument> eventDocs = scenario.getEvents() != null ?
                scenario.getEvents().stream().map(this::toDocument).collect(Collectors.toList()) : null;

        List<String> templateIds = scenario.getTemplates() != null ?
                scenario.getTemplates().stream()
                        .map(t -> t.getId().toString())
                        .collect(Collectors.toList()) : null;

        return EventScenarioDocument.builder()
                .id(scenario.getId() != null ? scenario.getId().toString() : null)
                .name(scenario.getName())
                .description(scenario.getDescription())
                .type(scenario.getType() != null ? scenario.getType().name() : null)
                .events(eventDocs)
                .templateIds(templateIds)
                .randomizeTimings(scenario.isRandomizeTimings())
                .allowOverlap(scenario.isAllowOverlap())
                .severityScale(scenario.getSeverityScale())
                .tags(scenario.getTags())
                .authorId(scenario.getAuthorId())
                .createdAt(scenario.getCreatedAt())
                .build();
    }

    public EventScenario toScenarioDomain(EventScenarioDocument doc) {
        if (doc == null) {
            return null;
        }

        List<WorldEvent> events = doc.getEvents() != null ?
                doc.getEvents().stream().map(this::toDomain).collect(Collectors.toList()) :
                new ArrayList<>();

        EventScenario scenario = new EventScenario();
        scenario.setId(doc.getId() != null ? UUID.fromString(doc.getId()) : null);
        scenario.setName(doc.getName());
        scenario.setDescription(doc.getDescription());
        scenario.setType(doc.getType() != null ? ScenarioType.valueOf(doc.getType()) : null);
        scenario.setEvents(events);
        scenario.setRandomizeTimings(doc.isRandomizeTimings());
        scenario.setAllowOverlap(doc.isAllowOverlap());
        scenario.setSeverityScale(doc.getSeverityScale());
        scenario.setTags(doc.getTags());
        scenario.setAuthorId(doc.getAuthorId());
        scenario.setCreatedAt(doc.getCreatedAt());

        return scenario;
    }

    // ==================== EventTemplate Mapping ====================

    public EventTemplateDocument toTemplateDocument(EventTemplate template) {
        if (template == null) {
            return null;
        }

        List<WorldEventDocument.EffectDocument> effectDocs = template.getDefaultEffects() != null ?
                template.getDefaultEffects().stream()
                        .map(this::toEffectDocument)
                        .collect(Collectors.toList()) : null;

        Set<String> validTargets = template.getValidTargets() != null ?
                template.getValidTargets().stream()
                        .map(Enum::name)
                        .collect(Collectors.toSet()) : null;

        Set<String> validPositions = template.getValidPositions() != null ?
                template.getValidPositions().stream()
                        .map(Enum::name)
                        .collect(Collectors.toSet()) : null;

        Map<String, Double> posProbabilities = null;
        if (template.getPositionProbabilities() != null) {
            posProbabilities = new HashMap<>();
            for (var entry : template.getPositionProbabilities().entrySet()) {
                posProbabilities.put(entry.getKey().name(), entry.getValue());
            }
        }

        return EventTemplateDocument.builder()
                .id(template.getId() != null ? template.getId().toString() : null)
                .name(template.getName())
                .eventType(template.getEventType() != null ? template.getEventType().name() : null)
                .category(template.getCategory() != null ? template.getCategory().name() : null)
                .defaultEffects(effectDocs)
                .defaultSeverity(template.getDefaultSeverity())
                .defaultImpact(template.getDefaultImpact() != null ? template.getDefaultImpact().name() : null)
                .defaultTimingType(template.getDefaultTimingType() != null ? template.getDefaultTimingType().name() : null)
                .defaultDuration(template.getDefaultDuration())
                .validTargets(validTargets)
                .validPositions(validPositions)
                .baseProbability(template.getBaseProbability())
                .positionProbabilities(posProbabilities)
                .generateNarrative(template.isGenerateNarrative())
                .narrativeTemplate(template.getNarrativeTemplate())
                .build();
    }

    public EventTemplate toTemplateDomain(EventTemplateDocument doc) {
        if (doc == null) {
            return null;
        }

        List<EventEffect> effects = doc.getDefaultEffects() != null ?
                doc.getDefaultEffects().stream()
                        .map(this::toEffectDomain)
                        .collect(Collectors.toList()) :
                new ArrayList<>();

        Set<EventTargetType> validTargets = doc.getValidTargets() != null ?
                doc.getValidTargets().stream()
                        .map(EventTargetType::valueOf)
                        .collect(Collectors.toSet()) : null;

        Set<Position> validPositions = doc.getValidPositions() != null ?
                doc.getValidPositions().stream()
                        .map(Position::valueOf)
                        .collect(Collectors.toSet()) : null;

        Map<Position, Double> posProbabilities = null;
        if (doc.getPositionProbabilities() != null) {
            posProbabilities = new HashMap<>();
            for (var entry : doc.getPositionProbabilities().entrySet()) {
                posProbabilities.put(Position.valueOf(entry.getKey()), entry.getValue());
            }
        }

        EventTemplate template = new EventTemplate();
        template.setId(doc.getId() != null ? UUID.fromString(doc.getId()) : null);
        template.setName(doc.getName());
        template.setEventType(doc.getEventType() != null ? WorldEventType.valueOf(doc.getEventType()) : null);
        template.setCategory(doc.getCategory() != null ? EventCategory.valueOf(doc.getCategory()) : null);
        template.setDefaultEffects(effects);
        template.setDefaultSeverity(doc.getDefaultSeverity());
        template.setDefaultImpact(doc.getDefaultImpact() != null ? EventImpactType.valueOf(doc.getDefaultImpact()) : null);
        template.setDefaultTimingType(doc.getDefaultTimingType() != null ? TimingType.valueOf(doc.getDefaultTimingType()) : null);
        template.setDefaultDuration(doc.getDefaultDuration());
        template.setValidTargets(validTargets);
        template.setValidPositions(validPositions);
        template.setBaseProbability(doc.getBaseProbability());
        template.setPositionProbabilities(posProbabilities);
        template.setGenerateNarrative(doc.isGenerateNarrative());
        template.setNarrativeTemplate(doc.getNarrativeTemplate());

        return template;
    }
}
