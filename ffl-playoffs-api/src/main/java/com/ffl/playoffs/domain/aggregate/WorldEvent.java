package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.*;

import java.time.Instant;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * WorldEvent aggregate root - represents a discrete occurrence within a simulation
 * that affects player performance, team dynamics, game outcomes, and narrative progression.
 */
public class WorldEvent {

    private UUID id;
    private UUID simulationWorldId;
    private UUID simulationRunId;

    // Event identity
    private WorldEventType type;
    private EventCategory category;
    private String name;
    private String description;

    // Timing
    private EventTiming timing;
    private Integer startWeek;
    private Integer endWeek;
    private Instant scheduledAt;
    private Instant activatedAt;
    private Instant expiredAt;

    // Affected entities
    private List<EventTarget> targets;
    private EventScope scope;

    // Effects
    private List<EventEffect> effects;
    private Double severity;
    private EventImpactType impactType;

    // State
    private EventStatus status;
    private EventSource source;
    private String cancellationReason;

    // Narrative integration
    private boolean triggerNarrative;
    private NarrativeEventType narrativeType;
    private String narrativeHeadline;

    // Metadata
    private String createdBy;
    private LocalDateTime createdAt;
    private Long version;

    public WorldEvent() {
        this.id = UUID.randomUUID();
        this.targets = new ArrayList<>();
        this.effects = new ArrayList<>();
        this.status = EventStatus.SCHEDULED;
        this.createdAt = LocalDateTime.now();
        this.version = 0L;
    }

    // Business methods

    public void activate() {
        if (status != EventStatus.SCHEDULED) {
            throw new IllegalStateException(
                    "Cannot activate event in status: " + status + ". Must be SCHEDULED.");
        }
        this.status = EventStatus.ACTIVE;
        this.activatedAt = Instant.now();
    }

    public void expire() {
        if (status != EventStatus.ACTIVE) {
            throw new IllegalStateException(
                    "Cannot expire event in status: " + status + ". Must be ACTIVE.");
        }
        this.status = EventStatus.EXPIRED;
        this.expiredAt = Instant.now();
    }

    public void cancel(String reason) {
        if (status == EventStatus.EXPIRED || status == EventStatus.CANCELLED) {
            throw new IllegalStateException(
                    "Cannot cancel event in status: " + status);
        }
        this.status = EventStatus.CANCELLED;
        this.cancellationReason = reason;
        this.expiredAt = Instant.now();
    }

    public boolean affectsPlayer(Long nflPlayerId) {
        for (EventTarget target : targets) {
            if (target.getType() == EventTargetType.PLAYER &&
                target.getTargetId().equals(nflPlayerId.toString())) {
                return true;
            }
            if (target.getType() == EventTargetType.LEAGUE) {
                return true;
            }
        }
        return false;
    }

    public boolean affectsTeam(String teamAbbreviation) {
        for (EventTarget target : targets) {
            if (target.matchesTeam(teamAbbreviation)) {
                return true;
            }
        }
        return false;
    }

    public boolean isActiveForWeek(Integer week) {
        if (status != EventStatus.ACTIVE && status != EventStatus.SCHEDULED) {
            return false;
        }

        if (timing != null) {
            return timing.isActiveForWeek(week);
        }

        // Fallback to start/end week
        if (startWeek != null && week < startWeek) {
            return false;
        }
        if (endWeek != null && week > endWeek) {
            return false;
        }
        return true;
    }

    public List<StatModifier> getStatModifiers() {
        List<StatModifier> modifiers = new ArrayList<>();

        for (EventEffect effect : effects) {
            for (var entry : effect.getStatModifiers().entrySet()) {
                StatModifier modifier = StatModifier.multiply(entry.getKey(), entry.getValue())
                        .withSource(this.id, this.type);
                modifiers.add(modifier);
            }
        }

        return modifiers;
    }

    public boolean causesUnavailability() {
        for (EventEffect effect : effects) {
            if (effect.causesUnavailability()) {
                return true;
            }
        }
        return false;
    }

    public void addTarget(EventTarget target) {
        if (status != EventStatus.SCHEDULED) {
            throw new IllegalStateException("Cannot modify targets after event is activated");
        }
        this.targets.add(target);
    }

    public void addEffect(EventEffect effect) {
        if (status != EventStatus.SCHEDULED) {
            throw new IllegalStateException("Cannot modify effects after event is activated");
        }
        this.effects.add(effect);
    }

    // Static factory methods

    public static WorldEvent createInjury(Long playerId, String playerName, Double severity,
                                          Integer startWeek, Integer endWeek) {
        WorldEvent event = new WorldEvent();
        event.type = WorldEventType.INJURY;
        event.category = EventCategory.AVAILABILITY;
        event.name = playerName + " Injury";
        event.description = playerName + " is dealing with an injury";
        event.targets.add(EventTarget.player(playerId, playerName));
        event.scope = EventScope.INDIVIDUAL;
        event.severity = severity;
        event.impactType = EventImpactType.NEGATIVE;
        event.startWeek = startWeek;
        event.endWeek = endWeek;
        event.timing = EventTiming.weekRange(startWeek, endWeek);
        event.source = EventSource.CURATED;

        // Add effect based on severity
        if (severity >= 0.9) {
            event.effects.add(EventEffect.injuryOut());
        } else if (severity >= 0.5) {
            event.effects.add(EventEffect.injuryMajor());
        } else {
            event.effects.add(EventEffect.injuryMinor());
        }

        return event;
    }

    public static WorldEvent createWeather(UUID gameId, String gameDescription, WorldEventType weatherType) {
        WorldEvent event = new WorldEvent();
        event.type = weatherType;
        event.category = EventCategory.GAME_CONTEXT;
        event.name = weatherType.getDescription();
        event.description = "Weather affecting " + gameDescription;
        event.targets.add(EventTarget.game(gameId, gameDescription));
        event.scope = EventScope.TEAM;
        event.severity = 0.5;
        event.impactType = EventImpactType.NEGATIVE;
        event.timing = EventTiming.forGame(gameId);
        event.source = EventSource.CURATED;

        // Add weather effect
        event.effects.add(switch (weatherType) {
            case WEATHER_SNOW -> EventEffect.weatherSnow();
            case WEATHER_RAIN -> EventEffect.weatherRain();
            default -> EventEffect.weatherRain();
        });

        return event;
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getSimulationWorldId() {
        return simulationWorldId;
    }

    public void setSimulationWorldId(UUID simulationWorldId) {
        this.simulationWorldId = simulationWorldId;
    }

    public UUID getSimulationRunId() {
        return simulationRunId;
    }

    public void setSimulationRunId(UUID simulationRunId) {
        this.simulationRunId = simulationRunId;
    }

    public WorldEventType getType() {
        return type;
    }

    public void setType(WorldEventType type) {
        this.type = type;
    }

    public EventCategory getCategory() {
        return category;
    }

    public void setCategory(EventCategory category) {
        this.category = category;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public EventTiming getTiming() {
        return timing;
    }

    public void setTiming(EventTiming timing) {
        this.timing = timing;
    }

    public Integer getStartWeek() {
        return startWeek;
    }

    public void setStartWeek(Integer startWeek) {
        this.startWeek = startWeek;
    }

    public Integer getEndWeek() {
        return endWeek;
    }

    public void setEndWeek(Integer endWeek) {
        this.endWeek = endWeek;
    }

    public Instant getScheduledAt() {
        return scheduledAt;
    }

    public void setScheduledAt(Instant scheduledAt) {
        this.scheduledAt = scheduledAt;
    }

    public Instant getActivatedAt() {
        return activatedAt;
    }

    public void setActivatedAt(Instant activatedAt) {
        this.activatedAt = activatedAt;
    }

    public Instant getExpiredAt() {
        return expiredAt;
    }

    public void setExpiredAt(Instant expiredAt) {
        this.expiredAt = expiredAt;
    }

    public List<EventTarget> getTargets() {
        return new ArrayList<>(targets);
    }

    public void setTargets(List<EventTarget> targets) {
        this.targets = new ArrayList<>(targets);
    }

    public EventScope getScope() {
        return scope;
    }

    public void setScope(EventScope scope) {
        this.scope = scope;
    }

    public List<EventEffect> getEffects() {
        return new ArrayList<>(effects);
    }

    public void setEffects(List<EventEffect> effects) {
        this.effects = new ArrayList<>(effects);
    }

    public Double getSeverity() {
        return severity;
    }

    public void setSeverity(Double severity) {
        this.severity = severity;
    }

    public EventImpactType getImpactType() {
        return impactType;
    }

    public void setImpactType(EventImpactType impactType) {
        this.impactType = impactType;
    }

    public EventStatus getStatus() {
        return status;
    }

    public void setStatus(EventStatus status) {
        this.status = status;
    }

    public EventSource getSource() {
        return source;
    }

    public void setSource(EventSource source) {
        this.source = source;
    }

    public String getCancellationReason() {
        return cancellationReason;
    }

    public boolean isTriggerNarrative() {
        return triggerNarrative;
    }

    public void setTriggerNarrative(boolean triggerNarrative) {
        this.triggerNarrative = triggerNarrative;
    }

    public NarrativeEventType getNarrativeType() {
        return narrativeType;
    }

    public void setNarrativeType(NarrativeEventType narrativeType) {
        this.narrativeType = narrativeType;
    }

    public String getNarrativeHeadline() {
        return narrativeHeadline;
    }

    public void setNarrativeHeadline(String narrativeHeadline) {
        this.narrativeHeadline = narrativeHeadline;
    }

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public Long getVersion() {
        return version;
    }

    public void setVersion(Long version) {
        this.version = version;
    }

    @Override
    public String toString() {
        return String.format("WorldEvent{id=%s, type=%s, name='%s', status=%s, weeks=%d-%d}",
                id, type, name, status, startWeek, endWeek);
    }

    /**
     * Narrative event types for integration with narrative system.
     */
    public enum NarrativeEventType {
        BREAKING_NEWS,
        INJURY_REPORT,
        PERFORMANCE_UPDATE,
        WEATHER_ALERT,
        TEAM_NEWS
    }
}
