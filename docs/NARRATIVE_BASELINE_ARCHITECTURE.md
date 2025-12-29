# Narrative Baseline with Autonomous Evolution Architecture

> **ANIMA-1038**: Design and architecture for the Narrative System with Autonomous Evolution

## Overview

The Narrative System provides dynamic storytelling capabilities for fantasy football simulations. It creates, tracks, and evolves narratives based on simulation events, enabling:

- **Engaging Experience**: Transform raw statistics into compelling stories
- **Context Enrichment**: Add meaning to player/team performances
- **Autonomous Updates**: Narratives evolve without manual intervention
- **Demo Enhancement**: Rich storytelling for product demonstrations
- **Historical Records**: Narrative summaries of simulated seasons

This builds on the Simulation Core (ANIMA-1019) and Simulation World (ANIMA-1031) to create the "story" layer of the simulation platform.

---

## Use Cases

### Primary Use Cases

1. **Initialize Narrative Baseline**
   - Create starting narratives for a simulation
   - Assign storylines to players, teams, and league
   - Set narrative expectations based on world configuration
   - Establish potential narrative arcs

2. **Evolve Narratives Autonomously**
   - Listen to simulation events (game outcomes, stat performances)
   - Update narrative states based on trigger conditions
   - Progress storylines through defined arcs
   - Generate narrative events for consumers

3. **Detect Emergent Narratives**
   - Identify unexpected patterns (upsets, streaks, comebacks)
   - Create new storylines from simulation outcomes
   - Merge or split narratives based on events
   - Surface surprising developments

4. **Generate Narrative Content**
   - Produce human-readable narrative summaries
   - Create week-by-week story recaps
   - Build season-long narrative arcs
   - Support multiple content formats (text, highlights, headlines)

5. **Query Narrative State**
   - Get active narratives for a player/team/league
   - View narrative history and evolution
   - Access narrative momentum and trajectory
   - Retrieve narrative-enriched statistics

---

## Domain Model

### 1. NarrativeBaseline (Aggregate Root)

The container for all narratives associated with a simulation run.

**Location**: `domain/aggregate/NarrativeBaseline.java`

```java
public class NarrativeBaseline {

    private UUID id;
    private UUID simulationRunId;          // Link to simulation
    private UUID simulationWorldId;        // Link to world config

    // Narrative components
    private List<PlayerNarrative> playerNarratives;
    private List<TeamNarrative> teamNarratives;
    private LeagueNarrative leagueNarrative;

    // Active storylines
    private List<Storyline> activeStorylines;
    private List<Storyline> completedStorylines;

    // Evolution state
    private NarrativeState state;          // INITIALIZING, ACTIVE, SUSPENDED, CONCLUDED
    private Integer currentWeek;
    private NarrativeConfiguration config;

    // Metadata
    private LocalDateTime createdAt;
    private LocalDateTime lastEvolvedAt;
    private Long version;

    // Business methods
    public void initialize(SimulationWorld world);
    public void evolve(SimulationEvent event);
    public void advanceWeek(Integer week);
    public List<NarrativeEvent> getEventsForWeek(Integer week);
    public NarrativeSummary generateSummary();
}
```

**NarrativeState Enum**:
```java
public enum NarrativeState {
    INITIALIZING,   // Setting up initial narratives
    ACTIVE,         // Narratives evolving with simulation
    SUSPENDED,      // Simulation paused
    CONCLUDED       // Simulation complete, narratives finalized
}
```

### 2. PlayerNarrative (Entity)

Tracks the narrative arc for an individual NFL player.

**Location**: `domain/entity/PlayerNarrative.java`

```java
public class PlayerNarrative {

    private UUID id;
    private UUID baselineId;
    private Long nflPlayerId;
    private String playerName;
    private String position;
    private String team;

    // Narrative arc
    private NarrativeArcType arcType;       // REDEMPTION, DOMINANCE, DECLINE, BREAKOUT, etc.
    private ArcPhase currentPhase;          // SETUP, RISING, CLIMAX, FALLING, RESOLUTION
    private Double arcProgress;             // 0.0 to 1.0

    // Performance expectations
    private PerformanceExpectation expectation;
    private Double expectedWeeklyPoints;
    private Double performanceVariance;

    // Narrative momentum
    private Double momentum;                // -1.0 (negative) to 1.0 (positive)
    private Integer streakLength;           // Consecutive above/below expectation
    private StreakType streakType;          // HOT_STREAK, COLD_STREAK, CONSISTENT, VOLATILE

    // Significant events
    private List<NarrativeEvent> events;
    private NarrativeEvent climaxEvent;     // The defining moment

    // Evolution tracking
    private Map<Integer, WeeklyNarrativeSnapshot> weeklySnapshots;

    // Business methods
    public void recordPerformance(SimulatedPlayerStats stats);
    public void evolve(GameContext context);
    public boolean hasReachedClimax();
    public NarrativeText generateCurrentNarrative();
}
```

**NarrativeArcType Enum**:
```java
public enum NarrativeArcType {
    // Positive arcs
    DOMINANCE("Elite performer maintaining excellence"),
    BREAKOUT("Emerging star exceeding expectations"),
    REDEMPTION("Comeback from adversity"),
    UNDERDOG("Defying low expectations"),
    CLUTCH("Rising to big moments"),

    // Negative arcs
    DECLINE("Former star losing effectiveness"),
    DISAPPOINTMENT("High expectations unmet"),
    STRUGGLE("Consistent underperformance"),
    INCONSISTENT("Boom-or-bust unpredictability"),

    // Neutral arcs
    STEADY("Reliable, consistent performer"),
    JOURNEYMAN("Moving between teams/roles"),
    UNKNOWN("Narrative still developing");

    private final String description;
}
```

**ArcPhase Enum**:
```java
public enum ArcPhase {
    SETUP(0.0, 0.2),       // Establishing the narrative context
    RISING(0.2, 0.5),      // Building tension/momentum
    CLIMAX(0.5, 0.7),      // Peak moment of the arc
    FALLING(0.7, 0.9),     // Consequences and aftermath
    RESOLUTION(0.9, 1.0);  // Narrative conclusion

    private final double startProgress;
    private final double endProgress;
}
```

### 3. TeamNarrative (Entity)

Tracks the narrative arc for an NFL team.

**Location**: `domain/entity/TeamNarrative.java`

```java
public class TeamNarrative {

    private UUID id;
    private UUID baselineId;
    private String teamAbbreviation;
    private String teamName;

    // Season context
    private TeamNarrativeType type;          // CONTENDER, REBUILDING, DARK_HORSE, etc.
    private SeasonExpectation expectation;
    private Integer projectedWins;
    private Integer actualWins;

    // Narrative elements
    private List<RivalryNarrative> rivalries;
    private PlayoffNarrative playoffNarrative;
    private List<String> keyPlayerNames;      // Players driving the narrative

    // Game-by-game
    private List<GameNarrativeResult> gameResults;
    private Integer winStreak;
    private Integer lossStreak;

    // Momentum
    private Double seasonMomentum;            // Current trajectory
    private TrendDirection trend;             // ASCENDING, DESCENDING, STABLE

    // Business methods
    public void recordGameResult(SimulatedNFLGame game);
    public void updatePlayoffPicture(PlayoffStandings standings);
    public RivalryNarrative getRivalryWith(String opponent);
    public NarrativeText generateSeasonSummary();
}
```

**TeamNarrativeType Enum**:
```java
public enum TeamNarrativeType {
    DYNASTY("Established championship contender"),
    CONTENDER("Expected to compete for title"),
    DARK_HORSE("Underrated potential"),
    REBUILDING("Young team developing"),
    STRUGGLING("Facing significant challenges"),
    RESURGENT("Bouncing back from down year"),
    FADING("Former contender declining"),
    SURPRISE("Unexpected performance level");

    private final String description;
}
```

### 4. LeagueNarrative (Entity)

Tracks the overall fantasy league narrative.

**Location**: `domain/entity/LeagueNarrative.java`

```java
public class LeagueNarrative {

    private UUID id;
    private UUID baselineId;
    private UUID leagueId;
    private String leagueName;

    // Championship race
    private ChampionshipRaceNarrative championshipRace;
    private List<UUID> contenders;            // LeaguePlayer IDs
    private UUID currentLeader;
    private Integer leaderWeeksAtop;

    // Storylines
    private List<LeagueStoryline> activeStorylines;
    private LeagueTheme seasonTheme;          // PARITY, DOMINANCE, CHAOS, etc.

    // Notable events
    private List<LeagueMoment> moments;       // Big upsets, records, etc.
    private LeagueMoment momentOfTheWeek;

    // Standings dynamics
    private Map<UUID, Integer> weeklyRankings;
    private UUID biggestMover;                // Most positions gained
    private UUID biggestFaller;               // Most positions lost

    // Rivalries
    private List<OwnerRivalry> ownerRivalries;

    // Business methods
    public void updateStandings(List<SimulatedScore> weekScores);
    public void detectNewStorylines();
    public void nominateMomentOfTheWeek(LeagueMoment moment);
    public NarrativeText generateWeekRecap(Integer week);
}
```

**LeagueTheme Enum**:
```java
public enum LeagueTheme {
    DOMINANCE("One team running away with it"),
    TIGHT_RACE("Multiple contenders battling"),
    CHAOS("Unpredictable week-to-week results"),
    COMEBACK("Late-season surge by underdog"),
    COLLAPSE("Front-runner faltering"),
    PARITY("Very balanced competition"),
    DAVID_VS_GOLIATH("Underdogs challenging favorites");

    private final String description;
}
```

### 5. Storyline (Entity)

A narrative thread that spans multiple weeks/events.

**Location**: `domain/entity/Storyline.java`

```java
public class Storyline {

    private UUID id;
    private UUID baselineId;

    // Identity
    private StorylineType type;
    private String title;                     // "Patrick Mahomes' Comeback Tour"
    private String headline;                  // Short version for display
    private String description;               // Full narrative description

    // Subjects
    private StorylineSubject primarySubject;  // Player, team, or matchup
    private List<StorylineSubject> secondarySubjects;

    // Lifecycle
    private StorylineStatus status;           // EMERGING, ACTIVE, CLIMAXING, CONCLUDED
    private Integer startWeek;
    private Integer endWeek;                  // null if ongoing
    private Integer peakWeek;                 // Week of maximum intensity

    // Intensity
    private Double intensity;                 // 0.0 to 1.0 current narrative strength
    private Double peakIntensity;             // Maximum achieved
    private IntensityTrend trend;             // BUILDING, STEADY, FADING

    // Resolution
    private StorylineOutcome outcome;         // null if ongoing
    private String resolutionSummary;

    // Events
    private List<StorylineChapter> chapters;  // Major beats in the story

    // Methods
    public void addChapter(StorylineChapter chapter);
    public void updateIntensity(Double newIntensity);
    public void conclude(StorylineOutcome outcome, String summary);
    public boolean shouldConclude();
    public NarrativeText getCurrentNarrative();
}
```

**StorylineType Enum**:
```java
public enum StorylineType {
    // Player storylines
    MVP_RACE("Race for league MVP"),
    BREAKOUT_SEASON("Emerging star making waves"),
    COMEBACK_STORY("Return from adversity"),
    RECORD_CHASE("Pursuing statistical record"),
    RIVALRY_DUEL("Head-to-head player rivalry"),

    // Team storylines
    CHAMPIONSHIP_PUSH("Team contending for title"),
    PLAYOFF_CHASE("Fighting for playoff spot"),
    RIVALRY_SHOWDOWN("Intense team rivalry"),
    CINDERELLA_RUN("Unexpected team success"),

    // League storylines
    CHAMPIONSHIP_RACE("League title race"),
    BASEMENT_BATTLE("Battle to avoid last place"),
    WEEKLY_SHOWDOWN("Key matchup of the week"),
    SCORING_RECORD("Chasing scoring records");

    private final String description;
}
```

### 6. NarrativeEvent (Value Object)

A discrete narrative occurrence.

**Location**: `domain/model/NarrativeEvent.java`

```java
public class NarrativeEvent {

    private UUID id;
    private NarrativeEventType type;
    private EventSignificance significance;   // MINOR, NOTABLE, MAJOR, HISTORIC

    // Context
    private Integer week;
    private Instant occurredAt;

    // Subject
    private StorylineSubject subject;
    private UUID relatedStorylineId;

    // Content
    private String headline;                  // "Mahomes Throws 5 TDs in Comeback Win"
    private String description;               // Detailed narrative
    private Map<String, Object> eventData;    // Raw data for templating

    // Impact
    private Double narrativeImpact;           // How much it moves the story
    private List<NarrativeConsequence> consequences;

    // Factory methods
    public static NarrativeEvent playerBigGame(SimulatedPlayerStats stats);
    public static NarrativeEvent upsetVictory(SimulatedNFLGame game);
    public static NarrativeEvent streakEvent(PlayerNarrative narrative, Integer streakLength);
    public static NarrativeEvent recordBreaking(String record, Object value);
}
```

**NarrativeEventType Enum**:
```java
public enum NarrativeEventType {
    // Performance events
    BIG_GAME("Exceptional statistical performance"),
    DUD_GAME("Disappointing performance"),
    CAREER_HIGH("Personal best performance"),
    INJURY("Player injured during game"),

    // Streak events
    HOT_STREAK_START("Beginning of hot streak"),
    HOT_STREAK_CONTINUES("Hot streak extending"),
    HOT_STREAK_END("Hot streak broken"),
    COLD_STREAK_START("Beginning of cold streak"),

    // Game events
    UPSET("Underdog defeats favorite"),
    BLOWOUT("One-sided game result"),
    COMEBACK("Team overcomes large deficit"),
    RIVALRY_WIN("Victory in rivalry game"),

    // Season events
    PLAYOFF_CLINCH("Team clinches playoff spot"),
    ELIMINATION("Team eliminated from playoffs"),
    RECORD_BROKEN("Statistical record broken"),

    // Fantasy events
    WEEKLY_HIGH("Highest fantasy score of week"),
    WEEKLY_LOW("Lowest fantasy score of week"),
    LEAD_CHANGE("New league leader");

    private final String description;
}
```

### 7. NarrativeConfiguration (Value Object)

Configures narrative behavior.

**Location**: `domain/model/NarrativeConfiguration.java`

```java
public class NarrativeConfiguration {

    // Evolution frequency
    private NarrativeUpdateFrequency updateFrequency;  // PER_GAME, PER_WEEK, REAL_TIME

    // Thresholds for event creation
    private Double bigGameThreshold;          // Fantasy points to qualify as "big game"
    private Double dudGameThreshold;          // Fantasy points to qualify as "dud"
    private Integer streakMinimum;            // Games for streak recognition
    private Double upsetMargin;               // Point spread for upset classification

    // Narrative intensity
    private Double baseIntensityDecay;        // Weekly decay if no new events
    private Double eventIntensityBoost;       // Boost from significant events
    private Double climaxThreshold;           // Intensity to trigger climax

    // Content generation
    private NarrativeVoice voice;             // FORMAL, CASUAL, DRAMATIC, ANALYTICAL
    private Boolean includeStatistics;        // Include numbers in narratives
    private Integer maxActiveStorylines;      // Limit concurrent stories

    // Emergent narrative detection
    private Boolean detectEmergentNarratives;
    private Double emergentThreshold;         // Significance for new storyline

    // Factory methods
    public static NarrativeConfiguration forDemo();
    public static NarrativeConfiguration forCompetitive();
    public static NarrativeConfiguration minimal();
}
```

**NarrativeVoice Enum**:
```java
public enum NarrativeVoice {
    FORMAL("Professional sports journalism style"),
    CASUAL("Conversational, fan-friendly tone"),
    DRAMATIC("High-energy, exciting narration"),
    ANALYTICAL("Stats-focused, objective analysis"),
    HUMOROUS("Light-hearted, fun commentary");

    private final String description;
}
```

### 8. NarrativeText (Value Object)

Generated narrative content.

**Location**: `domain/model/NarrativeText.java`

```java
public class NarrativeText {

    private NarrativeTextType type;
    private String headline;                  // Short, attention-grabbing
    private String summary;                   // 1-2 sentence overview
    private String fullText;                  // Complete narrative

    // Formatting variants
    private String tweetLength;               // 280 chars max
    private String pushNotification;          // 100 chars max

    // Metadata
    private List<String> keywords;
    private List<String> mentionedPlayers;
    private List<String> mentionedTeams;
    private NarrativeTone tone;               // POSITIVE, NEGATIVE, NEUTRAL, DRAMATIC

    // Template data
    private Map<String, Object> templateVariables;

    // Builder pattern
    public static NarrativeTextBuilder builder();
}
```

---

## Autonomous Evolution Engine

### EvolutionEngine (Domain Service)

The core engine that evolves narratives based on simulation events.

**Location**: `domain/service/NarrativeEvolutionEngine.java`

```java
public class NarrativeEvolutionEngine {

    private final NarrativeEventDetector eventDetector;
    private final StorylineManager storylineManager;
    private final NarrativeTextGenerator textGenerator;

    /**
     * Processes a simulation event and evolves relevant narratives.
     */
    public List<NarrativeEvent> evolve(
        NarrativeBaseline baseline,
        SimulationEvent simulationEvent
    ) {
        List<NarrativeEvent> narrativeEvents = new ArrayList<>();

        // 1. Detect narrative events from simulation
        List<DetectedEvent> detected = eventDetector.detect(simulationEvent);

        // 2. Update affected narratives
        for (DetectedEvent event : detected) {
            NarrativeEvent narrativeEvent = processEvent(baseline, event);
            if (narrativeEvent != null) {
                narrativeEvents.add(narrativeEvent);
            }
        }

        // 3. Check for storyline transitions
        storylineManager.updateStorylines(baseline, narrativeEvents);

        // 4. Detect emergent narratives
        List<Storyline> emergent = detectEmergentStorylines(baseline);
        baseline.addStorylines(emergent);

        // 5. Decay inactive narratives
        decayInactiveNarratives(baseline);

        return narrativeEvents;
    }

    /**
     * Evolves narratives at end of week.
     */
    public WeeklyNarrativeEvolution evolveWeek(
        NarrativeBaseline baseline,
        Integer week,
        List<SimulatedScore> scores
    ) {
        // Update all player narratives with weekly performance
        for (PlayerNarrative pn : baseline.getPlayerNarratives()) {
            pn.recordWeeklyPerformance(week, scores);
        }

        // Update team narratives
        for (TeamNarrative tn : baseline.getTeamNarratives()) {
            tn.updateWeeklyStandings(week);
        }

        // Update league narrative
        baseline.getLeagueNarrative().updateStandings(scores);

        // Generate week summary
        return generateWeeklySummary(baseline, week);
    }
}
```

### NarrativeEventDetector (Domain Service)

Detects narrative-worthy events from simulation data.

**Location**: `domain/service/NarrativeEventDetector.java`

```java
public class NarrativeEventDetector {

    private final NarrativeConfiguration config;

    /**
     * Detects narrative events from a simulated game.
     */
    public List<DetectedEvent> detectFromGame(SimulatedNFLGame game) {
        List<DetectedEvent> events = new ArrayList<>();

        // Check for upset
        if (isUpset(game)) {
            events.add(DetectedEvent.upset(game));
        }

        // Check for blowout
        if (isBlowout(game)) {
            events.add(DetectedEvent.blowout(game));
        }

        // Check for comeback
        if (isComeback(game)) {
            events.add(DetectedEvent.comeback(game));
        }

        return events;
    }

    /**
     * Detects narrative events from player stats.
     */
    public List<DetectedEvent> detectFromStats(
        SimulatedPlayerStats stats,
        PlayerNarrative narrative
    ) {
        List<DetectedEvent> events = new ArrayList<>();

        Double fantasyPoints = stats.getFantasyPoints();
        Double expected = narrative.getExpectedWeeklyPoints();

        // Big game detection
        if (fantasyPoints >= config.getBigGameThreshold()) {
            events.add(DetectedEvent.bigGame(stats));
        }

        // Dud game detection
        if (fantasyPoints <= config.getDudGameThreshold()) {
            events.add(DetectedEvent.dudGame(stats));
        }

        // Streak detection
        if (shouldTriggerStreakEvent(narrative, fantasyPoints)) {
            events.add(DetectedEvent.streak(narrative));
        }

        // Exceeded/missed expectations
        Double variance = (fantasyPoints - expected) / expected;
        if (Math.abs(variance) > 0.5) {
            events.add(variance > 0
                ? DetectedEvent.exceededExpectations(stats, variance)
                : DetectedEvent.missedExpectations(stats, variance));
        }

        return events;
    }
}
```

### StorylineManager (Domain Service)

Manages storyline lifecycle.

**Location**: `domain/service/StorylineManager.java`

```java
public class StorylineManager {

    /**
     * Updates storylines based on new narrative events.
     */
    public void updateStorylines(
        NarrativeBaseline baseline,
        List<NarrativeEvent> events
    ) {
        for (NarrativeEvent event : events) {
            // Find related storylines
            List<Storyline> related = findRelatedStorylines(
                baseline.getActiveStorylines(),
                event
            );

            for (Storyline storyline : related) {
                // Add chapter if significant enough
                if (event.getSignificance().isAtLeast(EventSignificance.NOTABLE)) {
                    storyline.addChapter(new StorylineChapter(event));
                }

                // Update intensity
                Double intensityChange = calculateIntensityChange(storyline, event);
                storyline.updateIntensity(storyline.getIntensity() + intensityChange);

                // Check for status transitions
                updateStorylineStatus(storyline);
            }
        }
    }

    /**
     * Creates a new storyline from detected pattern.
     */
    public Storyline createStoryline(
        StorylineType type,
        StorylineSubject subject,
        NarrativeEvent triggerEvent
    ) {
        return Storyline.builder()
            .id(UUID.randomUUID())
            .type(type)
            .title(generateTitle(type, subject))
            .headline(generateHeadline(type, subject))
            .primarySubject(subject)
            .status(StorylineStatus.EMERGING)
            .startWeek(triggerEvent.getWeek())
            .intensity(0.3)  // Starting intensity
            .build();
    }
}
```

---

## Port Interfaces

### NarrativeRepository

**Location**: `domain/port/NarrativeRepository.java`

```java
public interface NarrativeRepository {

    // NarrativeBaseline
    NarrativeBaseline save(NarrativeBaseline baseline);
    Optional<NarrativeBaseline> findById(UUID id);
    Optional<NarrativeBaseline> findBySimulationRunId(UUID simulationRunId);

    // PlayerNarrative
    List<PlayerNarrative> findPlayerNarratives(UUID baselineId);
    Optional<PlayerNarrative> findPlayerNarrative(UUID baselineId, Long nflPlayerId);

    // TeamNarrative
    List<TeamNarrative> findTeamNarratives(UUID baselineId);
    Optional<TeamNarrative> findTeamNarrative(UUID baselineId, String teamAbbreviation);

    // Storylines
    List<Storyline> findActiveStorylines(UUID baselineId);
    List<Storyline> findStorylinesForSubject(UUID baselineId, StorylineSubject subject);

    // NarrativeEvents
    void saveEvent(NarrativeEvent event);
    List<NarrativeEvent> findEventsByWeek(UUID baselineId, Integer week);
    List<NarrativeEvent> findEventsBySignificance(UUID baselineId, EventSignificance minSignificance);
}
```

### NarrativeTextGenerator

**Location**: `domain/port/NarrativeTextGenerator.java`

```java
public interface NarrativeTextGenerator {

    /**
     * Generates narrative text for an event.
     */
    NarrativeText generateEventNarrative(NarrativeEvent event, NarrativeVoice voice);

    /**
     * Generates narrative text for a player's current arc.
     */
    NarrativeText generatePlayerNarrative(PlayerNarrative narrative, NarrativeVoice voice);

    /**
     * Generates a weekly recap for the league.
     */
    NarrativeText generateWeeklyRecap(
        LeagueNarrative leagueNarrative,
        Integer week,
        List<NarrativeEvent> weekEvents,
        NarrativeVoice voice
    );

    /**
     * Generates a storyline update.
     */
    NarrativeText generateStorylineUpdate(Storyline storyline, NarrativeVoice voice);

    /**
     * Generates season summary.
     */
    NarrativeText generateSeasonSummary(NarrativeBaseline baseline, NarrativeVoice voice);
}
```

### NarrativeEventPublisher

**Location**: `domain/port/NarrativeEventPublisher.java`

```java
public interface NarrativeEventPublisher {

    /**
     * Publishes a narrative event for consumers.
     */
    void publishEvent(NarrativeEvent event);

    /**
     * Publishes a storyline update.
     */
    void publishStorylineUpdate(Storyline storyline, StorylineUpdateType updateType);

    /**
     * Publishes weekly narrative summary.
     */
    void publishWeeklySummary(UUID baselineId, Integer week, NarrativeText summary);
}
```

---

## Integration with Simulation

### Simulation Event Listener

The narrative system listens to simulation events:

```java
@Component
public class SimulationNarrativeListener {

    private final NarrativeEvolutionEngine evolutionEngine;
    private final NarrativeRepository narrativeRepository;
    private final NarrativeEventPublisher eventPublisher;

    @EventListener
    public void onGameCompleted(SimulatedGameCompletedEvent event) {
        // Get narrative baseline for this simulation
        NarrativeBaseline baseline = narrativeRepository
            .findBySimulationRunId(event.getSimulationRunId())
            .orElse(null);

        if (baseline == null || baseline.getState() != NarrativeState.ACTIVE) {
            return;
        }

        // Evolve narratives based on game
        List<NarrativeEvent> narrativeEvents = evolutionEngine.evolve(baseline, event);

        // Persist and publish
        for (NarrativeEvent narrativeEvent : narrativeEvents) {
            narrativeRepository.saveEvent(narrativeEvent);
            eventPublisher.publishEvent(narrativeEvent);
        }

        narrativeRepository.save(baseline);
    }

    @EventListener
    public void onWeekCompleted(SimulatedWeekCompletedEvent event) {
        NarrativeBaseline baseline = narrativeRepository
            .findBySimulationRunId(event.getSimulationRunId())
            .orElseThrow();

        // Weekly evolution
        WeeklyNarrativeEvolution evolution = evolutionEngine.evolveWeek(
            baseline,
            event.getWeek(),
            event.getScores()
        );

        // Publish weekly summary
        eventPublisher.publishWeeklySummary(
            baseline.getId(),
            event.getWeek(),
            evolution.getSummary()
        );
    }
}
```

### Integration Diagram

```
SimulationCore                    NarrativeSystem
     │                                  │
     ├── SimulatedGameCompletedEvent ──►│
     │                                  ├── NarrativeEventDetector
     │                                  │       │
     ├── SimulatedPlayerStats ─────────►│       ▼
     │                                  ├── NarrativeEvolutionEngine
     │                                  │       │
     ├── SimulatedWeekCompletedEvent ──►│       ▼
     │                                  ├── StorylineManager
     │                                  │       │
     │                                  │       ▼
     │                                  ├── NarrativeRepository
     │                                  │       │
     │                                  │       ▼
     │                          ◄───────┤── NarrativeEventPublisher
     │                                  │
     │                                  ▼
     │                           NarrativeText → UI/API
```

---

## API Endpoints

### Narrative Controller

**Location**: `infrastructure/adapter/rest/NarrativeController.java`

```
GET    /api/v1/narratives/simulations/{simulationId}
       Get narrative baseline for simulation

GET    /api/v1/narratives/simulations/{simulationId}/players/{playerId}
       Get player narrative

GET    /api/v1/narratives/simulations/{simulationId}/teams/{teamAbbr}
       Get team narrative

GET    /api/v1/narratives/simulations/{simulationId}/storylines
       Get active storylines

GET    /api/v1/narratives/simulations/{simulationId}/storylines/{storylineId}
       Get specific storyline details

GET    /api/v1/narratives/simulations/{simulationId}/events
       Get narrative events (with filtering)

GET    /api/v1/narratives/simulations/{simulationId}/weeks/{week}/recap
       Get weekly narrative recap

GET    /api/v1/narratives/simulations/{simulationId}/summary
       Get full season narrative summary
```

---

## MongoDB Collections

### narrative_baselines Collection

```javascript
{
  _id: UUID,
  simulationRunId: UUID,
  simulationWorldId: UUID,
  state: String,                    // INITIALIZING, ACTIVE, SUSPENDED, CONCLUDED
  currentWeek: Number,

  config: {
    updateFrequency: String,
    bigGameThreshold: Double,
    dudGameThreshold: Double,
    streakMinimum: Number,
    narrativeVoice: String,
    detectEmergentNarratives: Boolean
  },

  leagueNarrative: {
    leagueId: UUID,
    leagueName: String,
    seasonTheme: String,
    currentLeaderId: UUID,
    // ... embedded LeagueNarrative
  },

  createdAt: ISODate,
  lastEvolvedAt: ISODate,
  version: Long
}

// Indexes
db.narrative_baselines.createIndex({ simulationRunId: 1 }, { unique: true })
db.narrative_baselines.createIndex({ state: 1 })
```

### player_narratives Collection

```javascript
{
  _id: UUID,
  baselineId: UUID,
  nflPlayerId: Long,
  playerName: String,
  position: String,
  team: String,

  arcType: String,                  // DOMINANCE, BREAKOUT, REDEMPTION, etc.
  currentPhase: String,             // SETUP, RISING, CLIMAX, FALLING, RESOLUTION
  arcProgress: Double,

  expectedWeeklyPoints: Double,
  momentum: Double,
  streakLength: Number,
  streakType: String,

  weeklySnapshots: {
    "15": { points: 24.5, momentum: 0.6, phase: "RISING" },
    "16": { points: 31.2, momentum: 0.8, phase: "RISING" },
    // ...
  }
}

// Indexes
db.player_narratives.createIndex({ baselineId: 1 })
db.player_narratives.createIndex({ baselineId: 1, nflPlayerId: 1 }, { unique: true })
db.player_narratives.createIndex({ baselineId: 1, arcType: 1 })
```

### team_narratives Collection

```javascript
{
  _id: UUID,
  baselineId: UUID,
  teamAbbreviation: String,
  teamName: String,

  type: String,                     // CONTENDER, REBUILDING, DARK_HORSE, etc.
  projectedWins: Number,
  actualWins: Number,

  seasonMomentum: Double,
  trend: String,                    // ASCENDING, DESCENDING, STABLE

  rivalries: [{
    opponentTeam: String,
    intensity: Double,
    headToHead: { wins: Number, losses: Number }
  }],

  gameResults: [{
    week: Number,
    opponent: String,
    won: Boolean,
    score: String,
    narrativeEvent: String
  }]
}

// Indexes
db.team_narratives.createIndex({ baselineId: 1 })
db.team_narratives.createIndex({ baselineId: 1, teamAbbreviation: 1 }, { unique: true })
```

### storylines Collection

```javascript
{
  _id: UUID,
  baselineId: UUID,

  type: String,                     // MVP_RACE, BREAKOUT_SEASON, etc.
  title: String,
  headline: String,
  description: String,

  primarySubject: {
    type: String,                   // PLAYER, TEAM, MATCHUP, LEAGUE
    id: String,
    name: String
  },
  secondarySubjects: [Object],

  status: String,                   // EMERGING, ACTIVE, CLIMAXING, CONCLUDED
  startWeek: Number,
  endWeek: Number,
  peakWeek: Number,

  intensity: Double,
  peakIntensity: Double,
  trend: String,

  chapters: [{
    week: Number,
    eventId: UUID,
    title: String,
    summary: String,
    intensityImpact: Double
  }],

  outcome: String,
  resolutionSummary: String
}

// Indexes
db.storylines.createIndex({ baselineId: 1 })
db.storylines.createIndex({ baselineId: 1, status: 1 })
db.storylines.createIndex({ baselineId: 1, "primarySubject.id": 1 })
```

### narrative_events Collection

```javascript
{
  _id: UUID,
  baselineId: UUID,
  type: String,                     // BIG_GAME, UPSET, STREAK_START, etc.
  significance: String,             // MINOR, NOTABLE, MAJOR, HISTORIC

  week: Number,
  occurredAt: ISODate,

  subject: {
    type: String,
    id: String,
    name: String
  },
  relatedStorylineId: UUID,

  headline: String,
  description: String,
  eventData: Object,

  narrativeImpact: Double,
  consequences: [Object]
}

// Indexes
db.narrative_events.createIndex({ baselineId: 1, week: 1 })
db.narrative_events.createIndex({ baselineId: 1, significance: 1 })
db.narrative_events.createIndex({ baselineId: 1, type: 1 })
db.narrative_events.createIndex({ baselineId: 1, "subject.id": 1 })
```

---

## Feature File

**Location**: `features/ffl-narrative-system.feature`

```gherkin
Feature: Narrative Baseline with Autonomous Evolution
  As a simulation administrator
  I want narratives to evolve automatically during simulations
  So that users get engaging storylines without manual curation

  Background:
    Given a simulation run exists for league "DEMO-2025"
    And the simulation is configured for weeks 15-18
    And a narrative baseline is initialized

  # Baseline Initialization

  Scenario: Initialize narrative baseline from simulation
    When the narrative baseline is created
    Then each NFL player has a player narrative
    And each NFL team has a team narrative
    And the league has a league narrative
    And all narratives are in SETUP phase
    And initial storylines are created based on expectations

  Scenario: Player narrative reflects performance tier
    Given Patrick Mahomes is configured as ELITE tier
    When his player narrative is initialized
    Then his narrative arc type is "DOMINANCE"
    And his expected weekly points are above average
    And his consistency rating is high

  # Autonomous Evolution

  Scenario: Big game triggers narrative event
    Given Patrick Mahomes has an expected score of 22 points
    When he scores 35 fantasy points in a simulated game
    Then a BIG_GAME narrative event is created
    And his momentum increases
    And his arc progress advances
    And a "big game" chapter is added to his storyline

  Scenario: Hot streak detection
    Given a player has exceeded expectations for 2 weeks
    When they exceed expectations in week 3
    Then a HOT_STREAK narrative event is created
    And a "Hot Streak" storyline begins
    And the player's momentum is significantly positive

  Scenario: Upset game creates narrative event
    Given a simulated game between favored team A and underdog team B
    When team B wins by 10+ points
    Then an UPSET narrative event is created
    And both team narratives are updated
    And the winner's momentum increases dramatically
    And the loser's narrative may shift toward DISAPPOINTMENT

  Scenario: Storyline climax detection
    Given a player's storyline has intensity 0.9
    And they have a defining performance
    When the narrative evolves
    Then the storyline status becomes CLIMAXING
    And a climax event is recorded
    And narrative text highlights the peak moment

  # Emergent Narratives

  Scenario: Detect unexpected breakout
    Given an unheralded player with BACKUP tier
    When they have 3 consecutive above-average performances
    Then a new BREAKOUT_SEASON storyline emerges
    And their arc type changes to BREAKOUT
    And narrative events document the emergence

  Scenario: Detect rivalry intensification
    Given two teams have played once this simulation
    And the game was decided by 3 points
    When they are scheduled to play again
    Then their rivalry intensity increases
    And a RIVALRY_SHOWDOWN storyline may be created

  # Weekly Evolution

  Scenario: Weekly narrative recap generation
    When week 15 simulation completes
    Then a weekly narrative recap is generated
    And it highlights top storylines of the week
    And it includes the "moment of the week"
    And it previews upcoming narrative threads

  Scenario: Inactive narratives decay
    Given a storyline has not had new events for 2 weeks
    When weekly evolution occurs
    Then the storyline intensity decreases
    And if intensity drops below threshold, storyline concludes

  # Narrative Text Generation

  Scenario: Generate player narrative text
    Given a player has a COMEBACK narrative arc
    And they are in RISING phase
    When narrative text is requested
    Then the text describes their comeback journey
    And mentions specific performances that built momentum
    And indicates what's at stake going forward

  Scenario: Generate storyline update
    Given an MVP_RACE storyline is active
    With multiple players as subjects
    When storyline text is requested
    Then the text compares the contenders
    And highlights recent performances
    And projects who's in the lead

  # Integration

  Scenario: Narrative events published for consumers
    When a MAJOR significance narrative event occurs
    Then the event is published to event subscribers
    And UI components can update in real-time
    And notification services can alert users

  Scenario: Narrative survives simulation pause/resume
    Given a simulation is paused mid-week
    When the simulation resumes
    Then the narrative baseline is restored
    And evolution continues from saved state
    And no narrative data is lost
```

---

## Files to Create

### Domain Layer
- `domain/aggregate/NarrativeBaseline.java`
- `domain/entity/PlayerNarrative.java`
- `domain/entity/TeamNarrative.java`
- `domain/entity/LeagueNarrative.java`
- `domain/entity/Storyline.java`
- `domain/entity/StorylineChapter.java`
- `domain/model/NarrativeState.java`
- `domain/model/NarrativeArcType.java`
- `domain/model/ArcPhase.java`
- `domain/model/TeamNarrativeType.java`
- `domain/model/LeagueTheme.java`
- `domain/model/StorylineType.java`
- `domain/model/StorylineStatus.java`
- `domain/model/StorylineSubject.java`
- `domain/model/NarrativeEvent.java`
- `domain/model/NarrativeEventType.java`
- `domain/model/EventSignificance.java`
- `domain/model/NarrativeConfiguration.java`
- `domain/model/NarrativeVoice.java`
- `domain/model/NarrativeText.java`
- `domain/service/NarrativeEvolutionEngine.java`
- `domain/service/NarrativeEventDetector.java`
- `domain/service/StorylineManager.java`
- `domain/port/NarrativeRepository.java`
- `domain/port/NarrativeTextGenerator.java`
- `domain/port/NarrativeEventPublisher.java`

### Application Layer
- `application/usecase/InitializeNarrativeBaselineUseCase.java`
- `application/usecase/EvolveNarrativeUseCase.java`
- `application/usecase/GetNarrativeSummaryUseCase.java`
- `application/usecase/GetWeeklyRecapUseCase.java`
- `application/service/SimulationNarrativeListener.java`
- `application/dto/NarrativeBaselineDTO.java`
- `application/dto/PlayerNarrativeDTO.java`
- `application/dto/StorylineDTO.java`
- `application/dto/NarrativeEventDTO.java`

### Infrastructure Layer
- `infrastructure/adapter/rest/NarrativeController.java`
- `infrastructure/adapter/persistence/document/NarrativeBaselineDocument.java`
- `infrastructure/adapter/persistence/document/PlayerNarrativeDocument.java`
- `infrastructure/adapter/persistence/document/TeamNarrativeDocument.java`
- `infrastructure/adapter/persistence/document/StorylineDocument.java`
- `infrastructure/adapter/persistence/document/NarrativeEventDocument.java`
- `infrastructure/adapter/persistence/NarrativeRepositoryImpl.java`
- `infrastructure/adapter/persistence/mapper/NarrativeMapper.java`
- `infrastructure/narrative/TemplateNarrativeTextGenerator.java`
- `infrastructure/narrative/SpringNarrativeEventPublisher.java`
- `infrastructure/narrative/NarrativeTemplates.java`

### Feature File
- `features/ffl-narrative-system.feature`

---

## Implementation Priority

### Phase 1: Core Infrastructure
1. NarrativeBaseline aggregate and repository
2. PlayerNarrative entity with basic arc tracking
3. NarrativeEvent value object
4. Basic NarrativeEventDetector (big games, duds)
5. Simulation event listener

### Phase 2: Evolution Engine
1. NarrativeEvolutionEngine implementation
2. Momentum and streak tracking
3. Arc phase progression
4. Storyline entity and manager

### Phase 3: Emergent Narratives
1. Pattern detection for new storylines
2. Storyline lifecycle management
3. Intensity and decay mechanics
4. TeamNarrative and LeagueNarrative

### Phase 4: Content Generation
1. NarrativeTextGenerator implementation
2. Template-based narrative generation
3. Weekly recap generation
4. API endpoints and DTOs

---

**Document Status**: Ready for Implementation
**Created**: 2025-12-29
**Ticket**: ANIMA-1038
