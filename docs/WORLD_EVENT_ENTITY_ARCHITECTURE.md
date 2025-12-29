# World Event Entity Curation Architecture

> **ANIMA-1041**: Design and architecture for World Event Entity management

## Overview

World Events are discrete occurrences within a simulation that affect player performance, team dynamics, game outcomes, and narrative progression. This system provides:

- **Event Definition**: Structured model for simulation events (injuries, weather, roster moves)
- **Effect Application**: How events modify stats, scores, and outcomes
- **Curation Tools**: Create, schedule, and manage events within simulations
- **Integration Layer**: Connect events to Simulation Core and Narrative systems

World Events bridge the gap between the static Simulation World configuration and the dynamic Simulation Core execution, introducing variability and realism.

---

## Use Cases

### Primary Use Cases

1. **Create World Event**
   - Define event type and parameters
   - Specify affected entities (players, teams, games)
   - Set duration and effect modifiers
   - Schedule for specific time/week

2. **Apply Event Effects**
   - Modify player stat distributions during simulation
   - Adjust team performance ratings
   - Alter game outcome probabilities
   - Trigger narrative consequences

3. **Curate Event Scenarios**
   - Design event sequences for specific narratives
   - Create "what-if" scenarios with custom events
   - Import historical events from real NFL data
   - Build event templates for reuse

4. **Query Active Events**
   - Get events affecting a specific player/team
   - List events for a given week
   - Retrieve event history for simulation
   - Analyze event impact on outcomes

5. **Event Lifecycle Management**
   - Activate pending events
   - Expire events after duration
   - Cancel or modify active events
   - Archive completed events

---

## Domain Model

### 1. WorldEvent (Aggregate Root)

The core entity representing a simulation world event.

**Location**: `domain/aggregate/WorldEvent.java`

```java
public class WorldEvent {

    private UUID id;
    private UUID simulationWorldId;        // Parent world
    private UUID simulationRunId;          // Active run (if applied)

    // Event identity
    private WorldEventType type;
    private EventCategory category;
    private String name;
    private String description;

    // Timing
    private EventTiming timing;
    private Integer startWeek;
    private Integer endWeek;               // null = single week or until cancelled
    private Instant scheduledAt;
    private Instant activatedAt;
    private Instant expiredAt;

    // Affected entities
    private List<EventTarget> targets;     // Players, teams, games affected
    private EventScope scope;              // INDIVIDUAL, TEAM, LEAGUE, GLOBAL

    // Effects
    private List<EventEffect> effects;
    private Double severity;               // 0.0 (minor) to 1.0 (major)
    private EventImpactType impactType;    // NEGATIVE, NEUTRAL, POSITIVE

    // State
    private EventStatus status;            // SCHEDULED, ACTIVE, EXPIRED, CANCELLED
    private EventSource source;            // CURATED, SIMULATED, HISTORICAL, RANDOM

    // Narrative integration
    private boolean triggerNarrative;
    private NarrativeEventType narrativeType;
    private String narrativeHeadline;

    // Metadata
    private String createdBy;
    private LocalDateTime createdAt;
    private Long version;

    // Business methods
    public void activate();
    public void expire();
    public void cancel(String reason);
    public boolean affectsPlayer(Long nflPlayerId);
    public boolean affectsTeam(String teamAbbreviation);
    public boolean isActiveForWeek(Integer week);
    public List<StatModifier> getStatModifiers();
}
```

**WorldEventType Enum**:
```java
public enum WorldEventType {
    // Player events
    INJURY("Player injury affecting availability/performance"),
    SUSPENSION("Player suspended for violation"),
    ILLNESS("Player dealing with illness"),
    PERSONAL_LEAVE("Player away for personal reasons"),
    BREAKOUT("Player entering peak performance"),
    SLUMP("Player in performance decline"),
    RETURN_FROM_INJURY("Player returning to action"),

    // Team events
    COACH_CHANGE("Team coaching change"),
    SCHEME_CHANGE("Offensive/defensive scheme change"),
    HOME_FIELD_BOOST("Enhanced home field advantage"),
    RIVALRY_INTENSITY("Heightened rivalry game"),
    PLAYOFF_PUSH("Team motivation boost"),
    TANKING("Team motivation decline"),

    // Game events
    WEATHER_SEVERE("Severe weather affecting game"),
    WEATHER_COLD("Extreme cold conditions"),
    WEATHER_WIND("High wind conditions"),
    WEATHER_RAIN("Rain conditions"),
    WEATHER_SNOW("Snow conditions"),
    PRIME_TIME("Prime time game modifier"),
    NEUTRAL_SITE("Neutral site game"),

    // League events
    BYE_WEEK("Team on bye week"),
    SHORT_WEEK("Team on short rest"),
    LONG_WEEK("Team on extended rest"),
    INTERNATIONAL("International game"),

    // Fantasy events
    USAGE_INCREASE("Increased player usage"),
    USAGE_DECREASE("Decreased player usage"),
    ROLE_CHANGE("Player role change"),
    DEPTH_CHART_MOVE("Depth chart position change");

    private final String description;
}
```

**EventCategory Enum**:
```java
public enum EventCategory {
    AVAILABILITY("Affects whether player/team participates"),
    PERFORMANCE("Modifies statistical output"),
    GAME_CONTEXT("Affects game environment/conditions"),
    ROSTER("Changes team composition"),
    MOTIVATION("Affects effort/intensity levels"),
    USAGE("Changes snap count/target share");

    private final String description;
}
```

### 2. EventTarget (Value Object)

Specifies what entity is affected by an event.

**Location**: `domain/model/EventTarget.java`

```java
public class EventTarget {

    private EventTargetType type;          // PLAYER, TEAM, GAME, POSITION
    private String targetId;               // nflPlayerId, teamAbbr, gameId
    private String targetName;             // Display name

    // For position-based targeting
    private Position position;             // QB, RB, WR, etc.
    private String teamContext;            // Team for position targeting

    // Scope refinement
    private TargetRole role;               // STARTER, BACKUP, ALL
    private Integer limit;                 // Max players affected (for position)

    // Factory methods
    public static EventTarget player(Long nflPlayerId, String name);
    public static EventTarget team(String abbreviation, String name);
    public static EventTarget game(UUID gameId, String description);
    public static EventTarget position(Position pos, String team, TargetRole role);
    public static EventTarget allPlayers(String team);
}
```

**EventTargetType Enum**:
```java
public enum EventTargetType {
    PLAYER,         // Specific NFL player
    TEAM,           // Entire team
    GAME,           // Specific game
    POSITION,       // All players at position (on team)
    MATCHUP,        // Both teams in a matchup
    LEAGUE          // All teams/players
}
```

### 3. EventEffect (Value Object)

Defines the statistical/performance impact of an event.

**Location**: `domain/model/EventEffect.java`

```java
public class EventEffect {

    private EffectType type;
    private EffectApplication application;  // MULTIPLIER, ADDITIVE, REPLACEMENT

    // Stat modifications
    private Map<StatCategory, Double> statModifiers;

    // Availability
    private Double availabilityChance;      // 0.0 (out) to 1.0 (available)
    private Boolean forceOut;               // Override to 0% availability

    // Performance envelope
    private Double ceilingModifier;         // Max performance adjustment
    private Double floorModifier;           // Min performance adjustment
    private Double varianceModifier;        // Consistency adjustment

    // Scoring impact
    private Double fantasyPointsModifier;   // Direct fantasy points adjustment
    private Map<String, Double> bonusModifiers;

    // Probability
    private Double effectProbability;       // Chance effect applies (for random)

    // Factory methods
    public static EventEffect injuryMinor();    // -20% stats
    public static EventEffect injuryMajor();    // -50% stats
    public static EventEffect injuryOut();      // 0% availability
    public static EventEffect hotStreak();      // +25% stats
    public static EventEffect coldStreak();     // -25% stats
    public static EventEffect weatherRain();    // -10% passing, +5% rushing
    public static EventEffect weatherSnow();    // -20% passing, -10% all
    public static EventEffect primeTime();      // +10% for elite players
}
```

**EffectType Enum**:
```java
public enum EffectType {
    // Availability effects
    OUT("Player unavailable"),
    LIMITED("Reduced snap count"),
    FULL("Normal availability"),

    // Performance effects
    BOOST("Enhanced performance"),
    REDUCTION("Reduced performance"),
    VARIANCE_HIGH("Increased variance/volatility"),
    VARIANCE_LOW("Decreased variance/consistency"),

    // Specific stat effects
    PASSING_MODIFIER("Affects passing stats"),
    RUSHING_MODIFIER("Affects rushing stats"),
    RECEIVING_MODIFIER("Affects receiving stats"),
    SCORING_MODIFIER("Affects scoring stats"),

    // Game flow effects
    GAME_SCRIPT_PASS("Increased passing due to game script"),
    GAME_SCRIPT_RUN("Increased rushing due to game script"),

    // Usage effects
    TARGET_SHARE("Modified target share"),
    SNAP_COUNT("Modified snap count"),
    RED_ZONE_USAGE("Modified red zone usage");

    private final String description;
}
```

### 4. EventTiming (Value Object)

Controls when an event is active.

**Location**: `domain/model/EventTiming.java`

```java
public class EventTiming {

    private TimingType type;
    private Integer weekStart;              // NFL week number
    private Integer weekEnd;                // null = indefinite
    private Duration duration;              // For time-based events

    // Game-specific timing
    private UUID specificGameId;            // For single-game events
    private GamePhase gamePhase;            // PRE_GAME, IN_GAME, POST_GAME

    // Recurrence
    private boolean recurring;
    private RecurrencePattern recurrence;   // WEEKLY, BI_WEEKLY, etc.
    private Set<Integer> recurringWeeks;    // Specific weeks

    // Conditions
    private List<TimingCondition> conditions;  // Conditional activation

    // Factory methods
    public static EventTiming singleWeek(int week);
    public static EventTiming weekRange(int start, int end);
    public static EventTiming indefinite(int startWeek);
    public static EventTiming forGame(UUID gameId);
    public static EventTiming restOfSeason(int fromWeek);
}
```

**TimingType Enum**:
```java
public enum TimingType {
    INSTANT("Single moment effect"),
    SINGLE_WEEK("Lasts one NFL week"),
    MULTI_WEEK("Spans multiple weeks"),
    SINGLE_GAME("Affects one game only"),
    INDEFINITE("Until cancelled/expired"),
    CONDITIONAL("Active when conditions met");

    private final String description;
}
```

### 5. EventScenario (Aggregate)

A curated collection of events for specific simulation purposes.

**Location**: `domain/aggregate/EventScenario.java`

```java
public class EventScenario {

    private UUID id;
    private String name;
    private String description;
    private ScenarioType type;              // INJURY_HEAVY, WEATHER_CHAOS, HISTORICAL

    // Events in scenario
    private List<WorldEvent> events;
    private List<EventTemplate> templates;  // Reusable event definitions

    // Scheduling
    private EventDistribution distribution; // How events are spread
    private Integer totalEvents;
    private Double eventDensity;            // Events per week

    // Configuration
    private boolean randomizeTimings;
    private boolean allowOverlap;           // Can same player have multiple events
    private Double severityScale;           // Global severity multiplier

    // Source
    private ScenarioSource source;
    private Integer historicalSeason;       // If based on real season

    // Metadata
    private Set<String> tags;
    private String authorId;
    private LocalDateTime createdAt;

    // Business methods
    public List<WorldEvent> generateEvents(SimulationWorld world);
    public void addEvent(WorldEvent event);
    public void addEventTemplate(EventTemplate template);
    public WorldEvent instantiateTemplate(EventTemplate template, EventTarget target);
}
```

**ScenarioType Enum**:
```java
public enum ScenarioType {
    HISTORICAL("Based on real NFL season events"),
    INJURY_HEAVY("High injury frequency"),
    INJURY_LIGHT("Minimal injuries"),
    WEATHER_EXTREME("Frequent severe weather"),
    CHAOS("Maximum unpredictability"),
    STABLE("Minimal disruptions"),
    CUSTOM("User-defined event mix"),
    NARRATIVE("Designed for storyline purposes");

    private final String description;
}
```

### 6. EventTemplate (Entity)

Reusable event definition for generating instances.

**Location**: `domain/entity/EventTemplate.java`

```java
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
    private Integer defaultDuration;        // Weeks

    // Target constraints
    private Set<EventTargetType> validTargets;
    private Set<Position> validPositions;   // For player events

    // Probability
    private Double baseProbability;         // Per week per player
    private Map<Position, Double> positionProbabilities;

    // Narrative
    private boolean generateNarrative;
    private String narrativeTemplate;       // "{{player}} suffers {{injury_type}}"

    // Factory methods
    public WorldEvent instantiate(EventTarget target, EventTiming timing);

    // Predefined templates
    public static EventTemplate minorInjury();
    public static EventTemplate majorInjury();
    public static EventTemplate seasonEnding();
    public static EventTemplate hotStreak();
    public static EventTemplate coldStreak();
    public static EventTemplate weatherEvent(WeatherType weather);
}
```

### 7. StatModifier (Value Object)

A calculated stat modification from an event.

**Location**: `domain/model/StatModifier.java`

```java
public class StatModifier {

    private StatCategory category;
    private ModifierType modifierType;      // MULTIPLIER, ADDITIVE, CAP, FLOOR
    private Double value;

    // Source tracking
    private UUID sourceEventId;
    private WorldEventType sourceEventType;

    // Stacking rules
    private boolean stackable;
    private StackingGroup stackingGroup;    // Events in same group don't stack

    // Methods
    public Double apply(Double baseValue);
    public boolean conflictsWith(StatModifier other);

    // Factory methods
    public static StatModifier multiply(StatCategory cat, double factor);
    public static StatModifier add(StatCategory cat, double amount);
    public static StatModifier cap(StatCategory cat, double max);
    public static StatModifier floor(StatCategory cat, double min);
}
```

**StatCategory Enum**:
```java
public enum StatCategory {
    // Passing
    PASSING_YARDS,
    PASSING_TOUCHDOWNS,
    INTERCEPTIONS,
    COMPLETION_PERCENTAGE,

    // Rushing
    RUSHING_YARDS,
    RUSHING_TOUCHDOWNS,
    RUSHING_ATTEMPTS,

    // Receiving
    RECEPTIONS,
    RECEIVING_YARDS,
    RECEIVING_TOUCHDOWNS,
    TARGETS,

    // Kicking
    FIELD_GOALS,
    FIELD_GOAL_PERCENTAGE,
    EXTRA_POINTS,

    // Defense
    SACKS,
    DEFENSIVE_INTERCEPTIONS,
    FUMBLE_RECOVERIES,
    POINTS_ALLOWED,

    // General
    FANTASY_POINTS,
    ALL_STATS
}
```

---

## Event Application Engine

### EventApplicationService (Domain Service)

Applies active events to simulation calculations.

**Location**: `domain/service/EventApplicationService.java`

```java
public class EventApplicationService {

    private final WorldEventRepository eventRepository;

    /**
     * Gets all stat modifiers for a player in a given week.
     */
    public List<StatModifier> getModifiersForPlayer(
        UUID simulationRunId,
        Long nflPlayerId,
        Integer week
    ) {
        // Find all active events affecting this player
        List<WorldEvent> activeEvents = eventRepository
            .findActiveEventsForPlayer(simulationRunId, nflPlayerId, week);

        // Collect all modifiers
        List<StatModifier> modifiers = new ArrayList<>();
        for (WorldEvent event : activeEvents) {
            modifiers.addAll(event.getStatModifiers());
        }

        // Resolve conflicts/stacking
        return resolveModifierConflicts(modifiers);
    }

    /**
     * Applies modifiers to base stats.
     */
    public SimulatedPlayerStats applyEventEffects(
        SimulatedPlayerStats baseStats,
        List<StatModifier> modifiers
    ) {
        SimulatedPlayerStats modified = baseStats.copy();

        for (StatModifier modifier : modifiers) {
            modified.applyStat(modifier.getCategory(), modifier::apply);
        }

        return modified;
    }

    /**
     * Checks if a player is available for a game.
     */
    public boolean isPlayerAvailable(
        UUID simulationRunId,
        Long nflPlayerId,
        UUID gameId,
        Integer week
    ) {
        List<WorldEvent> events = eventRepository
            .findActiveEventsForPlayer(simulationRunId, nflPlayerId, week);

        for (WorldEvent event : events) {
            for (EventEffect effect : event.getEffects()) {
                if (effect.getForceOut() != null && effect.getForceOut()) {
                    return false;
                }
                if (effect.getAvailabilityChance() != null
                    && effect.getAvailabilityChance() == 0.0) {
                    return false;
                }
            }
        }
        return true;
    }
}
```

### EventGenerationService (Domain Service)

Generates random events based on configuration.

**Location**: `domain/service/EventGenerationService.java`

```java
public class EventGenerationService {

    private final EventTemplateRepository templateRepository;
    private final Random random;

    /**
     * Generates random events for a simulation week.
     */
    public List<WorldEvent> generateWeeklyEvents(
        SimulationWorld world,
        Integer week,
        EventGenerationConfig config
    ) {
        List<WorldEvent> events = new ArrayList<>();

        if (config.isSimulateInjuries()) {
            events.addAll(generateInjuryEvents(world, week, config));
        }

        if (config.isSimulateWeather()) {
            events.addAll(generateWeatherEvents(world, week, config));
        }

        if (config.isSimulateStreaks()) {
            events.addAll(generateStreakEvents(world, week, config));
        }

        return events;
    }

    /**
     * Generates injury events based on position probabilities.
     */
    private List<WorldEvent> generateInjuryEvents(
        SimulationWorld world,
        Integer week,
        EventGenerationConfig config
    ) {
        List<WorldEvent> injuries = new ArrayList<>();

        for (PlayerArchetype player : world.getPlayerArchetypes()) {
            double probability = getInjuryProbability(player.getPosition());
            probability *= config.getInjuryMultiplier();

            if (random.nextDouble() < probability) {
                WorldEvent injury = createInjuryEvent(player, week);
                injuries.add(injury);
            }
        }

        return injuries;
    }
}
```

---

## Port Interfaces

### WorldEventRepository

**Location**: `domain/port/WorldEventRepository.java`

```java
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

    // EventTemplate
    EventTemplate saveTemplate(EventTemplate template);
    Optional<EventTemplate> findTemplateById(UUID id);
    List<EventTemplate> findTemplatesByType(WorldEventType type);
}
```

### EventNotificationPublisher

**Location**: `domain/port/EventNotificationPublisher.java`

```java
public interface EventNotificationPublisher {

    /**
     * Publishes when an event is activated.
     */
    void publishEventActivated(WorldEvent event);

    /**
     * Publishes when an event expires.
     */
    void publishEventExpired(WorldEvent event);

    /**
     * Publishes when an event is cancelled.
     */
    void publishEventCancelled(WorldEvent event, String reason);

    /**
     * Publishes summary of weekly events.
     */
    void publishWeeklyEventSummary(UUID simulationRunId, Integer week, List<WorldEvent> events);
}
```

---

## Integration with Other Systems

### Simulation Core Integration

Events modify the stat generation process:

```java
@Component
public class EventAwarePlayerStatsGenerator implements PlayerStatsGenerator {

    private final DefaultPlayerStatsGenerator baseGenerator;
    private final EventApplicationService eventService;

    @Override
    public SimulatedPlayerStats generatePlayerStats(
        Long nflPlayerId,
        String position,
        SimulatedNFLGame game,
        SimulationConfiguration config
    ) {
        // Check availability first
        if (!eventService.isPlayerAvailable(config.getRunId(), nflPlayerId, game.getId(), game.getWeek())) {
            return SimulatedPlayerStats.unavailable(nflPlayerId, game.getWeek());
        }

        // Generate base stats
        SimulatedPlayerStats baseStats = baseGenerator.generatePlayerStats(
            nflPlayerId, position, game, config
        );

        // Get active event modifiers
        List<StatModifier> modifiers = eventService.getModifiersForPlayer(
            config.getRunId(), nflPlayerId, game.getWeek()
        );

        // Apply modifiers
        return eventService.applyEventEffects(baseStats, modifiers);
    }
}
```

### Narrative System Integration

Events trigger narrative updates:

```java
@Component
public class WorldEventNarrativeListener {

    private final NarrativeEvolutionEngine narrativeEngine;

    @EventListener
    public void onWorldEventActivated(WorldEventActivatedDomainEvent event) {
        WorldEvent worldEvent = event.getWorldEvent();

        if (worldEvent.isTriggerNarrative()) {
            NarrativeEvent narrativeEvent = NarrativeEvent.builder()
                .type(worldEvent.getNarrativeType())
                .headline(worldEvent.getNarrativeHeadline())
                .significance(mapSeverityToSignificance(worldEvent.getSeverity()))
                .subject(mapTargetToSubject(worldEvent.getTargets().get(0)))
                .build();

            narrativeEngine.processEvent(narrativeEvent);
        }
    }
}
```

### Integration Diagram

```
                              WorldEvent System
                                     │
     ┌───────────────────────────────┼───────────────────────────────┐
     │                               │                               │
     ▼                               ▼                               ▼
SimulationWorld              SimulationCore                  NarrativeSystem
     │                               │                               │
     ├── EventScenario              ├── EventAwareStatsGen          ├── EventNarrativeListener
     │   (curated events)            │   (applies modifiers)         │   (triggers storylines)
     │                               │                               │
     ├── EventTemplate              ├── EventApplicationSvc         ├── Injury storylines
     │   (reusable defs)             │   (resolves effects)          │   Weather narratives
     │                               │                               │   Streak detection
     └── EnvironmentConfig          └── Availability checks         └── Event headlines
         (event probabilities)
```

---

## API Endpoints

### Event Management

```
POST   /api/v1/admin/worlds/{worldId}/events
       Create new world event

GET    /api/v1/admin/worlds/{worldId}/events
       List all events for world

GET    /api/v1/admin/events/{eventId}
       Get event details

PUT    /api/v1/admin/events/{eventId}
       Update event

DELETE /api/v1/admin/events/{eventId}
       Delete/cancel event

POST   /api/v1/admin/events/{eventId}/activate
       Manually activate event

POST   /api/v1/admin/events/{eventId}/cancel
       Cancel active event
```

### Query Endpoints

```
GET    /api/v1/simulations/{runId}/events
       Get events for simulation run

GET    /api/v1/simulations/{runId}/events/week/{week}
       Get events active in week

GET    /api/v1/simulations/{runId}/events/player/{playerId}
       Get events affecting player

GET    /api/v1/simulations/{runId}/events/team/{teamAbbr}
       Get events affecting team
```

### Scenarios and Templates

```
GET    /api/v1/event-scenarios
       List available scenarios

GET    /api/v1/event-scenarios/{id}
       Get scenario details

POST   /api/v1/admin/worlds/{worldId}/apply-scenario
       Apply scenario to world

GET    /api/v1/event-templates
       List available templates

POST   /api/v1/admin/worlds/{worldId}/events/from-template
       Create event from template
```

---

## MongoDB Collections

### world_events Collection

```javascript
{
  _id: UUID,
  simulationWorldId: UUID,
  simulationRunId: UUID,              // nullable until activated

  type: String,                       // INJURY, WEATHER_SEVERE, etc.
  category: String,                   // AVAILABILITY, PERFORMANCE, etc.
  name: String,
  description: String,

  timing: {
    type: String,                     // SINGLE_WEEK, MULTI_WEEK, etc.
    weekStart: Number,
    weekEnd: Number,
    specificGameId: UUID,
    recurring: Boolean,
    conditions: [Object]
  },

  targets: [{
    type: String,                     // PLAYER, TEAM, GAME
    targetId: String,
    targetName: String,
    position: String,
    role: String
  }],

  scope: String,                      // INDIVIDUAL, TEAM, LEAGUE
  severity: Double,
  impactType: String,                 // NEGATIVE, NEUTRAL, POSITIVE

  effects: [{
    type: String,
    application: String,
    statModifiers: Object,
    availabilityChance: Double,
    forceOut: Boolean,
    ceilingModifier: Double,
    floorModifier: Double
  }],

  status: String,                     // SCHEDULED, ACTIVE, EXPIRED, CANCELLED
  source: String,                     // CURATED, SIMULATED, HISTORICAL

  triggerNarrative: Boolean,
  narrativeType: String,
  narrativeHeadline: String,

  createdBy: String,
  createdAt: ISODate,
  activatedAt: ISODate,
  expiredAt: ISODate,
  version: Long
}

// Indexes
db.world_events.createIndex({ simulationWorldId: 1 })
db.world_events.createIndex({ simulationRunId: 1, status: 1 })
db.world_events.createIndex({ simulationRunId: 1, "timing.weekStart": 1 })
db.world_events.createIndex({ simulationRunId: 1, "targets.targetId": 1 })
db.world_events.createIndex({ type: 1 })
```

### event_scenarios Collection

```javascript
{
  _id: UUID,
  name: String,
  description: String,
  type: String,                       // INJURY_HEAVY, WEATHER_CHAOS, etc.

  events: [Object],                   // Embedded WorldEvent definitions
  templates: [Object],                // EventTemplate references

  distribution: {
    type: String,
    totalEvents: Number,
    eventsPerWeek: Double
  },

  randomizeTimings: Boolean,
  allowOverlap: Boolean,
  severityScale: Double,

  source: String,
  historicalSeason: Number,

  tags: [String],
  authorId: String,
  createdAt: ISODate
}

// Indexes
db.event_scenarios.createIndex({ type: 1 })
db.event_scenarios.createIndex({ tags: 1 })
```

### event_templates Collection

```javascript
{
  _id: UUID,
  name: String,
  eventType: String,
  category: String,

  defaultEffects: [Object],
  defaultSeverity: Double,
  defaultImpact: String,

  defaultTimingType: String,
  defaultDuration: Number,

  validTargets: [String],
  validPositions: [String],

  baseProbability: Double,
  positionProbabilities: Object,

  generateNarrative: Boolean,
  narrativeTemplate: String
}

// Indexes
db.event_templates.createIndex({ eventType: 1 })
db.event_templates.createIndex({ category: 1 })
```

---

## Feature File

**Location**: `features/ffl-world-events.feature`

```gherkin
Feature: World Event Entity Curation
  As a simulation administrator
  I want to create and manage world events
  So that simulations include realistic injuries, weather, and other factors

  Background:
    Given a simulation world "Demo World" exists
    And a simulation run is active

  # Event Creation

  Scenario: Create player injury event
    When I create a world event:
      | Type     | INJURY                        |
      | Target   | Patrick Mahomes (QB)          |
      | Severity | 0.3 (minor)                   |
      | Weeks    | 15-16                         |
    Then the event is created with status "SCHEDULED"
    And the event has a -30% passing stats modifier
    And the event is associated with the simulation world

  Scenario: Create weather event for game
    Given an NFL game KC vs BUF in week 15
    When I create a weather event:
      | Type   | WEATHER_SNOW  |
      | Game   | KC vs BUF     |
      | Effects| -20% passing  |
    Then both teams are affected
    And passing stats are reduced for all players

  Scenario: Create team-wide event
    When I create a motivation event:
      | Type   | PLAYOFF_PUSH       |
      | Team   | Kansas City Chiefs |
      | Effect | +10% all stats     |
    Then all KC players receive the boost
    And the event shows in team narrative

  # Event Application

  Scenario: Injured player has reduced stats
    Given Patrick Mahomes has an active minor injury event
    When his stats are generated for week 15
    Then his passing yards are reduced by injury percentage
    And his fantasy points reflect the reduction

  Scenario: Severely injured player is unavailable
    Given a player has a severe injury event with forceOut=true
    When availability is checked for week 15
    Then the player is marked unavailable
    And they receive 0 fantasy points for the week

  Scenario: Multiple events stack correctly
    Given a player has both injury (-20%) and cold streak (-15%)
    When stat modifiers are calculated
    Then effects are combined according to stacking rules
    And the final modifier is approximately -32%

  # Event Lifecycle

  Scenario: Event activates at scheduled time
    Given an injury event scheduled for week 15
    When week 15 simulation begins
    Then the event status becomes "ACTIVE"
    And event effects are applied

  Scenario: Event expires after duration
    Given an active 2-week injury event starting week 15
    When week 17 simulation begins
    Then the event status becomes "EXPIRED"
    And event effects no longer apply

  Scenario: Cancel active event
    Given an active injury event
    When an admin cancels the event with reason "Player cleared"
    Then the event status becomes "CANCELLED"
    And effects stop applying immediately

  # Event Scenarios

  Scenario: Apply injury-heavy scenario
    Given the scenario "NFL 2023 Injury Pattern" exists
    When I apply the scenario to my simulation world
    Then multiple injury events are created
    And events are distributed across the season
    And injury rates match historical data

  Scenario: Generate random events for week
    Given event generation is enabled with:
      | Injury Rate | 5%   |
      | Weather     | true |
    When week 15 is simulated
    Then random injuries may be generated
    And weather events are created for outdoor games

  # Event Templates

  Scenario: Create event from template
    Given the "Minor Hamstring Injury" template exists
    When I create an event from template for "Derrick Henry"
    Then an injury event is created with template defaults
    And I can customize duration and severity

  Scenario: Template respects position constraints
    Given a template valid only for RB and WR positions
    When I try to apply it to a QB
    Then the creation fails with "Invalid position for template"

  # Narrative Integration

  Scenario: Injury event triggers narrative
    Given an injury event with triggerNarrative=true
    When the event is activated
    Then a narrative event is published
    And the player's narrative reflects the injury
    And storylines may be affected

  # Query Events

  Scenario: Query events affecting player
    Given Patrick Mahomes has 2 active events
    When I query events for player "Patrick Mahomes"
    Then both events are returned
    And events show current status and effects

  Scenario: Query weekly event summary
    Given week 15 has 5 active events
    When I request event summary for week 15
    Then all 5 events are listed
    And events are grouped by category
```

---

## Files to Create

### Domain Layer
- `domain/aggregate/WorldEvent.java`
- `domain/aggregate/EventScenario.java`
- `domain/entity/EventTemplate.java`
- `domain/model/WorldEventType.java`
- `domain/model/EventCategory.java`
- `domain/model/EventTarget.java`
- `domain/model/EventTargetType.java`
- `domain/model/EventEffect.java`
- `domain/model/EffectType.java`
- `domain/model/EventTiming.java`
- `domain/model/TimingType.java`
- `domain/model/EventStatus.java`
- `domain/model/EventScope.java`
- `domain/model/EventSource.java`
- `domain/model/EventImpactType.java`
- `domain/model/StatModifier.java`
- `domain/model/StatCategory.java`
- `domain/model/ScenarioType.java`
- `domain/service/EventApplicationService.java`
- `domain/service/EventGenerationService.java`
- `domain/port/WorldEventRepository.java`
- `domain/port/EventNotificationPublisher.java`
- `domain/event/WorldEventActivatedDomainEvent.java`
- `domain/event/WorldEventExpiredDomainEvent.java`

### Application Layer
- `application/usecase/CreateWorldEventUseCase.java`
- `application/usecase/ActivateEventUseCase.java`
- `application/usecase/CancelEventUseCase.java`
- `application/usecase/ApplyEventScenarioUseCase.java`
- `application/usecase/QueryEventsUseCase.java`
- `application/service/EventAwarePlayerStatsGenerator.java`
- `application/service/WorldEventNarrativeListener.java`
- `application/dto/WorldEventDTO.java`
- `application/dto/EventScenarioDTO.java`
- `application/dto/EventTemplateDTO.java`

### Infrastructure Layer
- `infrastructure/adapter/rest/WorldEventController.java`
- `infrastructure/adapter/rest/EventScenarioController.java`
- `infrastructure/adapter/persistence/document/WorldEventDocument.java`
- `infrastructure/adapter/persistence/document/EventScenarioDocument.java`
- `infrastructure/adapter/persistence/document/EventTemplateDocument.java`
- `infrastructure/adapter/persistence/WorldEventRepositoryImpl.java`
- `infrastructure/adapter/persistence/mapper/WorldEventMapper.java`
- `infrastructure/event/SpringEventNotificationPublisher.java`
- `infrastructure/event/DefaultEventTemplates.java`

### Feature File
- `features/ffl-world-events.feature`

---

## Implementation Priority

### Phase 1: Core Event Model
1. WorldEvent aggregate and repository
2. EventTarget and EventEffect value objects
3. EventTiming and lifecycle management
4. Basic CRUD operations

### Phase 2: Effect Application
1. EventApplicationService implementation
2. StatModifier calculation and stacking
3. Integration with Simulation Core stats generator
4. Availability checks

### Phase 3: Event Generation
1. EventTemplate entity
2. EventGenerationService for random events
3. Injury probability by position
4. Weather event generation

### Phase 4: Scenarios and Templates
1. EventScenario aggregate
2. Scenario application
3. Historical event import
4. Template management

### Phase 5: Integration
1. Narrative system listeners
2. API endpoints
3. Event notification publishing

---

**Document Status**: Ready for Implementation
**Created**: 2025-12-29
**Ticket**: ANIMA-1041
