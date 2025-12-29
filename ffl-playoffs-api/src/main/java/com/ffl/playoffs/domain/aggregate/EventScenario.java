package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.entity.EventTemplate;
import com.ffl.playoffs.domain.model.*;

import java.time.LocalDateTime;
import java.util.*;

/**
 * EventScenario aggregate - a curated collection of events for specific simulation purposes.
 */
public class EventScenario {

    private UUID id;
    private String name;
    private String description;
    private ScenarioType type;

    // Events in scenario
    private List<WorldEvent> events;
    private List<EventTemplate> templates;

    // Scheduling
    private EventDistribution distribution;
    private Integer totalEvents;
    private Double eventDensity;

    // Configuration
    private boolean randomizeTimings;
    private boolean allowOverlap;
    private Double severityScale;

    // Source
    private ScenarioSource source;
    private Integer historicalSeason;

    // Metadata
    private Set<String> tags;
    private String authorId;
    private LocalDateTime createdAt;

    public EventScenario() {
        this.id = UUID.randomUUID();
        this.events = new ArrayList<>();
        this.templates = new ArrayList<>();
        this.tags = new HashSet<>();
        this.createdAt = LocalDateTime.now();
        this.severityScale = 1.0;
        this.allowOverlap = false;
        this.randomizeTimings = false;
    }

    // Factory methods

    public static EventScenario injuryHeavy() {
        EventScenario scenario = new EventScenario();
        scenario.name = "High Injury Frequency";
        scenario.description = "Simulation with elevated injury rates";
        scenario.type = ScenarioType.INJURY_HEAVY;
        scenario.severityScale = 1.5;
        scenario.eventDensity = 2.0;

        scenario.templates.add(EventTemplate.minorInjury());
        scenario.templates.add(EventTemplate.majorInjury());
        scenario.templates.add(EventTemplate.seasonEnding());

        return scenario;
    }

    public static EventScenario injuryLight() {
        EventScenario scenario = new EventScenario();
        scenario.name = "Low Injury Frequency";
        scenario.description = "Simulation with minimal injuries";
        scenario.type = ScenarioType.INJURY_LIGHT;
        scenario.severityScale = 0.5;
        scenario.eventDensity = 0.5;

        scenario.templates.add(EventTemplate.minorInjury());

        return scenario;
    }

    public static EventScenario weatherExtreme() {
        EventScenario scenario = new EventScenario();
        scenario.name = "Extreme Weather";
        scenario.description = "Frequent severe weather affecting games";
        scenario.type = ScenarioType.WEATHER_EXTREME;
        scenario.eventDensity = 1.5;

        scenario.templates.add(EventTemplate.weatherEvent(WorldEventType.WEATHER_SNOW));
        scenario.templates.add(EventTemplate.weatherEvent(WorldEventType.WEATHER_RAIN));
        scenario.templates.add(EventTemplate.weatherEvent(WorldEventType.WEATHER_WIND));

        return scenario;
    }

    public static EventScenario chaos() {
        EventScenario scenario = new EventScenario();
        scenario.name = "Maximum Chaos";
        scenario.description = "Maximum unpredictability with all event types";
        scenario.type = ScenarioType.CHAOS;
        scenario.severityScale = 2.0;
        scenario.eventDensity = 3.0;
        scenario.randomizeTimings = true;
        scenario.allowOverlap = true;

        scenario.templates.add(EventTemplate.minorInjury());
        scenario.templates.add(EventTemplate.majorInjury());
        scenario.templates.add(EventTemplate.seasonEnding());
        scenario.templates.add(EventTemplate.hotStreak());
        scenario.templates.add(EventTemplate.coldStreak());

        return scenario;
    }

    public static EventScenario stable() {
        EventScenario scenario = new EventScenario();
        scenario.name = "Stable Season";
        scenario.description = "Minimal disruptions for predictable simulation";
        scenario.type = ScenarioType.STABLE;
        scenario.severityScale = 0.25;
        scenario.eventDensity = 0.2;

        return scenario;
    }

    // Business methods

    public void addEvent(WorldEvent event) {
        this.events.add(event);
        if (totalEvents == null) {
            totalEvents = 0;
        }
        totalEvents++;
    }

    public void addEventTemplate(EventTemplate template) {
        this.templates.add(template);
    }

    public WorldEvent instantiateTemplate(EventTemplate template, EventTarget target, EventTiming timing) {
        WorldEvent event = template.instantiate(target, timing);

        // Apply scenario severity scale
        if (severityScale != null && severityScale != 1.0) {
            Double currentSeverity = event.getSeverity();
            if (currentSeverity != null) {
                event.setSeverity(Math.min(1.0, currentSeverity * severityScale));
            }
        }

        return event;
    }

    public int getEventCount() {
        return events.size();
    }

    public List<WorldEvent> getEventsByType(WorldEventType type) {
        return events.stream()
                .filter(e -> e.getType() == type)
                .toList();
    }

    public List<WorldEvent> getEventsForWeek(int week) {
        return events.stream()
                .filter(e -> e.isActiveForWeek(week))
                .toList();
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public ScenarioType getType() {
        return type;
    }

    public void setType(ScenarioType type) {
        this.type = type;
    }

    public List<WorldEvent> getEvents() {
        return new ArrayList<>(events);
    }

    public void setEvents(List<WorldEvent> events) {
        this.events = new ArrayList<>(events);
    }

    public List<EventTemplate> getTemplates() {
        return new ArrayList<>(templates);
    }

    public void setTemplates(List<EventTemplate> templates) {
        this.templates = new ArrayList<>(templates);
    }

    public EventDistribution getDistribution() {
        return distribution;
    }

    public void setDistribution(EventDistribution distribution) {
        this.distribution = distribution;
    }

    public Integer getTotalEvents() {
        return totalEvents;
    }

    public void setTotalEvents(Integer totalEvents) {
        this.totalEvents = totalEvents;
    }

    public Double getEventDensity() {
        return eventDensity;
    }

    public void setEventDensity(Double eventDensity) {
        this.eventDensity = eventDensity;
    }

    public boolean isRandomizeTimings() {
        return randomizeTimings;
    }

    public void setRandomizeTimings(boolean randomizeTimings) {
        this.randomizeTimings = randomizeTimings;
    }

    public boolean isAllowOverlap() {
        return allowOverlap;
    }

    public void setAllowOverlap(boolean allowOverlap) {
        this.allowOverlap = allowOverlap;
    }

    public Double getSeverityScale() {
        return severityScale;
    }

    public void setSeverityScale(Double severityScale) {
        this.severityScale = severityScale;
    }

    public ScenarioSource getSource() {
        return source;
    }

    public void setSource(ScenarioSource source) {
        this.source = source;
    }

    public Integer getHistoricalSeason() {
        return historicalSeason;
    }

    public void setHistoricalSeason(Integer historicalSeason) {
        this.historicalSeason = historicalSeason;
    }

    public Set<String> getTags() {
        return new HashSet<>(tags);
    }

    public void setTags(Set<String> tags) {
        this.tags = new HashSet<>(tags);
    }

    public void addTag(String tag) {
        this.tags.add(tag);
    }

    public String getAuthorId() {
        return authorId;
    }

    public void setAuthorId(String authorId) {
        this.authorId = authorId;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return String.format("EventScenario{id=%s, name='%s', type=%s, events=%d, density=%.1f}",
                id, name, type, events.size(), eventDensity);
    }

    /**
     * How events are distributed across the simulation.
     */
    public enum EventDistribution {
        UNIFORM,        // Evenly spread across all weeks
        FRONT_LOADED,   // More events early in the season
        BACK_LOADED,    // More events late in the season
        RANDOM,         // Random distribution
        CUSTOM          // Specific weeks defined
    }

    /**
     * Source of the scenario.
     */
    public enum ScenarioSource {
        SYSTEM,         // Built-in system scenario
        USER,           // User-created scenario
        HISTORICAL,     // Based on real NFL data
        IMPORTED        // Imported from external source
    }
}
