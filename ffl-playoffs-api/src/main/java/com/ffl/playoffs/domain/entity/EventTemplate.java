package com.ffl.playoffs.domain.entity;

import com.ffl.playoffs.domain.aggregate.WorldEvent;
import com.ffl.playoffs.domain.model.*;

import java.util.*;

/**
 * Reusable event definition for generating WorldEvent instances.
 */
public class EventTemplate {

    private UUID id;
    private String name;
    private WorldEventType eventType;
    private EventCategory category;

    // Default effects
    private List<EventEffect> defaultEffects;
    private Double defaultSeverity;
    private EventImpactType defaultImpact;

    // Timing defaults
    private TimingType defaultTimingType;
    private Integer defaultDuration;

    // Target constraints
    private Set<EventTargetType> validTargets;
    private Set<Position> validPositions;

    // Probability
    private Double baseProbability;
    private Map<Position, Double> positionProbabilities;

    // Narrative
    private boolean generateNarrative;
    private String narrativeTemplate;

    public EventTemplate() {
        this.id = UUID.randomUUID();
        this.defaultEffects = new ArrayList<>();
        this.validTargets = new HashSet<>();
        this.validPositions = new HashSet<>();
        this.positionProbabilities = new HashMap<>();
    }

    // Factory methods for predefined templates

    public static EventTemplate minorInjury() {
        EventTemplate template = new EventTemplate();
        template.name = "Minor Injury";
        template.eventType = WorldEventType.INJURY;
        template.category = EventCategory.AVAILABILITY;
        template.defaultEffects.add(EventEffect.injuryMinor());
        template.defaultSeverity = 0.3;
        template.defaultImpact = EventImpactType.NEGATIVE;
        template.defaultTimingType = TimingType.SINGLE_WEEK;
        template.defaultDuration = 1;
        template.validTargets.add(EventTargetType.PLAYER);
        template.baseProbability = 0.02;
        template.generateNarrative = true;
        template.narrativeTemplate = "{{player}} is dealing with a minor {{injury_type}}";

        // Higher injury rates for RB/WR
        template.positionProbabilities.put(Position.RB, 0.03);
        template.positionProbabilities.put(Position.WR, 0.025);
        template.positionProbabilities.put(Position.QB, 0.015);
        template.positionProbabilities.put(Position.TE, 0.02);
        template.positionProbabilities.put(Position.K, 0.005);

        return template;
    }

    public static EventTemplate majorInjury() {
        EventTemplate template = new EventTemplate();
        template.name = "Major Injury";
        template.eventType = WorldEventType.INJURY;
        template.category = EventCategory.AVAILABILITY;
        template.defaultEffects.add(EventEffect.injuryMajor());
        template.defaultSeverity = 0.6;
        template.defaultImpact = EventImpactType.NEGATIVE;
        template.defaultTimingType = TimingType.MULTI_WEEK;
        template.defaultDuration = 3;
        template.validTargets.add(EventTargetType.PLAYER);
        template.baseProbability = 0.005;
        template.generateNarrative = true;
        template.narrativeTemplate = "{{player}} suffers a significant {{injury_type}}, expected to miss several weeks";

        return template;
    }

    public static EventTemplate seasonEnding() {
        EventTemplate template = new EventTemplate();
        template.name = "Season-Ending Injury";
        template.eventType = WorldEventType.INJURY;
        template.category = EventCategory.AVAILABILITY;
        template.defaultEffects.add(EventEffect.injuryOut());
        template.defaultSeverity = 1.0;
        template.defaultImpact = EventImpactType.NEGATIVE;
        template.defaultTimingType = TimingType.INDEFINITE;
        template.defaultDuration = null;
        template.validTargets.add(EventTargetType.PLAYER);
        template.baseProbability = 0.001;
        template.generateNarrative = true;
        template.narrativeTemplate = "BREAKING: {{player}} suffers season-ending {{injury_type}}";

        return template;
    }

    public static EventTemplate hotStreak() {
        EventTemplate template = new EventTemplate();
        template.name = "Hot Streak";
        template.eventType = WorldEventType.BREAKOUT;
        template.category = EventCategory.PERFORMANCE;
        template.defaultEffects.add(EventEffect.hotStreak());
        template.defaultSeverity = 0.5;
        template.defaultImpact = EventImpactType.POSITIVE;
        template.defaultTimingType = TimingType.MULTI_WEEK;
        template.defaultDuration = 2;
        template.validTargets.add(EventTargetType.PLAYER);
        template.baseProbability = 0.01;
        template.generateNarrative = true;
        template.narrativeTemplate = "{{player}} is on fire with an incredible hot streak";

        return template;
    }

    public static EventTemplate coldStreak() {
        EventTemplate template = new EventTemplate();
        template.name = "Cold Streak";
        template.eventType = WorldEventType.SLUMP;
        template.category = EventCategory.PERFORMANCE;
        template.defaultEffects.add(EventEffect.coldStreak());
        template.defaultSeverity = 0.4;
        template.defaultImpact = EventImpactType.NEGATIVE;
        template.defaultTimingType = TimingType.MULTI_WEEK;
        template.defaultDuration = 2;
        template.validTargets.add(EventTargetType.PLAYER);
        template.baseProbability = 0.01;
        template.generateNarrative = true;
        template.narrativeTemplate = "{{player}} continues to struggle in a disappointing slump";

        return template;
    }

    public static EventTemplate weatherEvent(WorldEventType weatherType) {
        EventTemplate template = new EventTemplate();
        template.name = weatherType.getDescription();
        template.eventType = weatherType;
        template.category = EventCategory.GAME_CONTEXT;
        template.defaultSeverity = 0.5;
        template.defaultImpact = EventImpactType.NEGATIVE;
        template.defaultTimingType = TimingType.SINGLE_GAME;
        template.validTargets.add(EventTargetType.GAME);

        switch (weatherType) {
            case WEATHER_SNOW -> template.defaultEffects.add(EventEffect.weatherSnow());
            case WEATHER_RAIN -> template.defaultEffects.add(EventEffect.weatherRain());
            default -> template.defaultEffects.add(EventEffect.weatherRain());
        }

        template.generateNarrative = true;
        template.narrativeTemplate = "{{weather_type}} conditions expected for {{game}}";

        return template;
    }

    // Business methods

    public WorldEvent instantiate(EventTarget target, EventTiming timing) {
        validateTarget(target);

        WorldEvent event = new WorldEvent();
        event.setType(this.eventType);
        event.setCategory(this.category);
        event.setName(this.name);
        event.addTarget(target);
        event.setTiming(timing);
        event.setSeverity(this.defaultSeverity);
        event.setImpactType(this.defaultImpact);

        if (timing.getWeekStart() != null) {
            event.setStartWeek(timing.getWeekStart());
        }
        if (timing.getWeekEnd() != null) {
            event.setEndWeek(timing.getWeekEnd());
        } else if (defaultDuration != null && timing.getWeekStart() != null) {
            event.setEndWeek(timing.getWeekStart() + defaultDuration - 1);
        }

        for (EventEffect effect : defaultEffects) {
            event.addEffect(effect);
        }

        if (generateNarrative) {
            event.setTriggerNarrative(true);
            event.setNarrativeHeadline(generateNarrativeHeadline(target));
        }

        return event;
    }

    public void validateTarget(EventTarget target) {
        if (!validTargets.isEmpty() && !validTargets.contains(target.getType())) {
            throw new IllegalArgumentException(
                    "Invalid target type: " + target.getType() + ". Valid types: " + validTargets);
        }

        if (target.getPosition() != null && !validPositions.isEmpty() &&
            !validPositions.contains(target.getPosition())) {
            throw new IllegalArgumentException(
                    "Invalid position for template: " + target.getPosition());
        }
    }

    public double getProbabilityForPosition(Position position) {
        if (positionProbabilities.containsKey(position)) {
            return positionProbabilities.get(position);
        }
        return baseProbability != null ? baseProbability : 0.0;
    }

    private String generateNarrativeHeadline(EventTarget target) {
        if (narrativeTemplate == null) return name;

        return narrativeTemplate
                .replace("{{player}}", target.getTargetName() != null ? target.getTargetName() : "Player")
                .replace("{{injury_type}}", "injury")
                .replace("{{weather_type}}", eventType.getDescription())
                .replace("{{game}}", target.getTargetName() != null ? target.getTargetName() : "the game");
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public WorldEventType getEventType() {
        return eventType;
    }

    public void setEventType(WorldEventType eventType) {
        this.eventType = eventType;
    }

    public EventCategory getCategory() {
        return category;
    }

    public void setCategory(EventCategory category) {
        this.category = category;
    }

    public List<EventEffect> getDefaultEffects() {
        return new ArrayList<>(defaultEffects);
    }

    public void setDefaultEffects(List<EventEffect> defaultEffects) {
        this.defaultEffects = new ArrayList<>(defaultEffects);
    }

    public Double getDefaultSeverity() {
        return defaultSeverity;
    }

    public void setDefaultSeverity(Double defaultSeverity) {
        this.defaultSeverity = defaultSeverity;
    }

    public EventImpactType getDefaultImpact() {
        return defaultImpact;
    }

    public void setDefaultImpact(EventImpactType defaultImpact) {
        this.defaultImpact = defaultImpact;
    }

    public TimingType getDefaultTimingType() {
        return defaultTimingType;
    }

    public void setDefaultTimingType(TimingType defaultTimingType) {
        this.defaultTimingType = defaultTimingType;
    }

    public Integer getDefaultDuration() {
        return defaultDuration;
    }

    public void setDefaultDuration(Integer defaultDuration) {
        this.defaultDuration = defaultDuration;
    }

    public Set<EventTargetType> getValidTargets() {
        return new HashSet<>(validTargets);
    }

    public void setValidTargets(Set<EventTargetType> validTargets) {
        this.validTargets = new HashSet<>(validTargets);
    }

    public Set<Position> getValidPositions() {
        return new HashSet<>(validPositions);
    }

    public void setValidPositions(Set<Position> validPositions) {
        this.validPositions = new HashSet<>(validPositions);
    }

    public Double getBaseProbability() {
        return baseProbability;
    }

    public void setBaseProbability(Double baseProbability) {
        this.baseProbability = baseProbability;
    }

    public Map<Position, Double> getPositionProbabilities() {
        return new HashMap<>(positionProbabilities);
    }

    public void setPositionProbabilities(Map<Position, Double> positionProbabilities) {
        this.positionProbabilities = new HashMap<>(positionProbabilities);
    }

    public boolean isGenerateNarrative() {
        return generateNarrative;
    }

    public void setGenerateNarrative(boolean generateNarrative) {
        this.generateNarrative = generateNarrative;
    }

    public String getNarrativeTemplate() {
        return narrativeTemplate;
    }

    public void setNarrativeTemplate(String narrativeTemplate) {
        this.narrativeTemplate = narrativeTemplate;
    }
}
