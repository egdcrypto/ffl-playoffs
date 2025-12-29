# Simulation Core Architecture

> **ANIMA-1019**: Design and architecture for FFL Playoffs Simulation Core

## Overview

The Simulation Core provides the ability to simulate complete fantasy football seasons, including NFL game outcomes, player statistics, fantasy scoring, and league progression. This enables:

- **Demo Mode**: Showcase the platform without real NFL data
- **Testing**: Deterministic test scenarios for scoring and elimination logic
- **What-If Analysis**: Replay scenarios with different rosters
- **Load Testing**: Generate realistic data at scale

---

## Use Cases

### Primary Use Cases

1. **Simulate Complete Season**
   - Generate NFL game results for all weeks
   - Calculate player statistics based on game outcomes
   - Progress league through all configured weeks
   - Determine standings and eliminations

2. **Simulate Single Week**
   - Generate stats for one NFL week
   - Calculate fantasy scores for all rosters
   - Apply elimination rules
   - Advance to next week

3. **Replay with Different Roster**
   - Use historical game outcomes
   - Apply different roster selections
   - Recalculate fantasy scores
   - Compare scenarios

4. **Demo Mode**
   - Continuous simulation for live demo
   - Realistic score progression
   - Configurable speed (real-time or accelerated)

---

## Domain Model

### 1. SimulationRun (Aggregate Root)

Represents a complete simulation execution.

**Location**: `domain/aggregate/SimulationRun.java`

```java
public class SimulationRun extends EventSourcedAggregate {

    private UUID id;
    private UUID leagueId;              // League being simulated
    private SimulationMode mode;         // DEMO, TEST, REPLAY
    private SimulationStatus status;     // CREATED, RUNNING, PAUSED, COMPLETED, FAILED
    private SimulationConfiguration config;

    // Progress tracking
    private Integer currentNflWeek;
    private Integer targetNflWeek;       // Final week to simulate
    private Integer gamesSimulated;
    private Integer totalGames;

    // Timing
    private Instant startedAt;
    private Instant completedAt;
    private Duration simulatedDuration;  // How much time has "passed" in simulation

    // Random seed for reproducibility
    private Long randomSeed;

    // Metadata
    private String createdBy;
    private LocalDateTime createdAt;

    // Business methods
    public void start();
    public void pause();
    public void resume();
    public void complete();
    public void fail(String reason);
    public void advanceWeek();
    public boolean isComplete();
}
```

**SimulationMode Enum**:
```java
public enum SimulationMode {
    DEMO,       // Continuous simulation for demonstration
    TEST,       // Deterministic simulation for testing
    REPLAY,     // Replay with historical data but different rosters
    BENCHMARK   // Load testing with high volume
}
```

**SimulationStatus Enum**:
```java
public enum SimulationStatus {
    CREATED,    // Initialized but not started
    RUNNING,    // Actively simulating
    PAUSED,     // Temporarily stopped
    COMPLETED,  // Successfully finished
    FAILED,     // Error occurred
    CANCELLED   // Manually stopped
}
```

### 2. SimulationConfiguration (Value Object)

Configures simulation behavior.

**Location**: `domain/model/SimulationConfiguration.java`

```java
public class SimulationConfiguration {

    // Time control
    private TimeAcceleration timeAcceleration;  // REAL_TIME, 10X, 100X, INSTANT
    private Duration gameSimulationDuration;    // How long a game takes in sim time

    // Randomness
    private Long randomSeed;                    // null = random, set for reproducibility
    private boolean deterministicMode;          // For testing

    // Stats generation
    private StatDistribution statDistribution;  // NORMAL, HISTORICAL, CUSTOM
    private Double varianceMultiplier;          // 1.0 = normal, 2.0 = more variance

    // Injury/bye simulation
    private boolean simulateInjuries;
    private boolean simulateByeWeeks;
    private Double injuryProbability;           // Default 0.05 (5%)

    // Output control
    private boolean persistResults;             // Save to database
    private boolean publishEvents;              // Emit domain events
    private String outputCollection;            // MongoDB collection for results

    // Factory methods
    public static SimulationConfiguration forDemo();
    public static SimulationConfiguration forTesting(long seed);
    public static SimulationConfiguration forReplay();
    public static SimulationConfiguration instant();
}
```

**TimeAcceleration Enum**:
```java
public enum TimeAcceleration {
    REAL_TIME(1),       // 1 second = 1 second
    FAST_10X(10),       // 1 second = 10 seconds
    FAST_100X(100),     // 1 second = 100 seconds
    FAST_1000X(1000),   // 1 second = ~17 minutes
    INSTANT(0);         // No delay, instant completion

    private final int multiplier;
}
```

### 3. SimulatedNFLGame (Entity)

Represents a simulated NFL game with generated outcome.

**Location**: `domain/entity/SimulatedNFLGame.java`

```java
public class SimulatedNFLGame {

    private UUID id;
    private UUID simulationRunId;
    private UUID originalNflGameId;     // Reference to real game (if replay)

    // Game identity
    private Integer season;
    private Integer week;
    private String homeTeam;
    private String awayTeam;

    // Simulated outcome
    private Integer homeScore;
    private Integer awayScore;
    private GameResult result;          // HOME_WIN, AWAY_WIN, TIE

    // Quarter-by-quarter (optional detail)
    private int[] quarterScoresHome;    // [7, 10, 3, 14]
    private int[] quarterScoresAway;    // [3, 7, 7, 7]

    // Simulation metadata
    private Instant simulatedAt;
    private Long randomSeedUsed;

    // Methods
    public String getWinner();
    public String getLoser();
    public int getMarginOfVictory();
    public boolean isHomeWin();
    public boolean isCloseGame();       // Within 7 points
}
```

### 4. SimulatedPlayerStats (Entity)

Generated player statistics for a simulated game.

**Location**: `domain/entity/SimulatedPlayerStats.java`

```java
public class SimulatedPlayerStats {

    private UUID id;
    private UUID simulationRunId;
    private UUID simulatedGameId;

    // Player identity
    private Long nflPlayerId;
    private String playerName;
    private String position;            // QB, RB, WR, TE, K, DEF
    private String team;

    // Context
    private Integer season;
    private Integer week;

    // Passing stats
    private Integer passingYards;
    private Integer passingTouchdowns;
    private Integer interceptions;
    private Integer passingAttempts;
    private Integer passingCompletions;

    // Rushing stats
    private Integer rushingYards;
    private Integer rushingTouchdowns;
    private Integer rushingAttempts;

    // Receiving stats
    private Integer receptions;
    private Integer receivingYards;
    private Integer receivingTouchdowns;
    private Integer targets;

    // Other offensive
    private Integer fumblesLost;
    private Integer twoPointConversions;

    // Kicking stats
    private Integer fieldGoalsMade0to39;
    private Integer fieldGoalsMade40to49;
    private Integer fieldGoalsMade50Plus;
    private Integer fieldGoalsMissed;
    private Integer extraPointsMade;
    private Integer extraPointsMissed;

    // Defensive stats (for DEF position)
    private Integer sacks;
    private Integer defensiveInterceptions;
    private Integer fumbleRecoveries;
    private Integer defensiveTouchdowns;
    private Integer safeties;
    private Integer pointsAllowed;
    private Integer yardsAllowed;

    // Calculated scores
    private Double fantasyPoints;
    private Double pprFantasyPoints;
    private Double halfPprFantasyPoints;

    // Simulation metadata
    private Instant simulatedAt;

    // Methods
    public void calculateFantasyPoints(ScoringRules rules);
}
```

### 5. SimulatedScore (Entity)

Roster score for a simulated week.

**Location**: `domain/entity/SimulatedScore.java`

```java
public class SimulatedScore {

    private UUID id;
    private UUID simulationRunId;
    private UUID leaguePlayerId;
    private UUID weekId;

    // Score breakdown
    private Double totalScore;
    private Map<String, Double> playerScores;  // nflPlayerId -> score

    // Ranking
    private Integer rank;
    private boolean isEliminated;

    // Comparison (for replay scenarios)
    private Double originalScore;       // null if not replay
    private Double scoreDifference;

    // Metadata
    private Instant calculatedAt;
}
```

---

## Port Interfaces

### 1. SimulationEngine (Domain Service Port)

Main orchestrator for simulation execution.

**Location**: `domain/port/SimulationEngine.java`

```java
public interface SimulationEngine {

    /**
     * Starts a new simulation run.
     */
    SimulationRun startSimulation(UUID leagueId, SimulationConfiguration config);

    /**
     * Simulates a single NFL week.
     */
    SimulationWeekResult simulateWeek(SimulationRun run, Integer nflWeek);

    /**
     * Simulates all remaining weeks in a run.
     */
    void simulateToCompletion(SimulationRun run);

    /**
     * Pauses an active simulation.
     */
    void pauseSimulation(UUID simulationRunId);

    /**
     * Resumes a paused simulation.
     */
    void resumeSimulation(UUID simulationRunId);

    /**
     * Cancels a simulation.
     */
    void cancelSimulation(UUID simulationRunId);

    /**
     * Gets simulation status.
     */
    SimulationRun getSimulationStatus(UUID simulationRunId);
}
```

### 2. GameOutcomeGenerator (Domain Service Port)

Generates NFL game outcomes.

**Location**: `domain/port/GameOutcomeGenerator.java`

```java
public interface GameOutcomeGenerator {

    /**
     * Generates outcome for a single game.
     */
    SimulatedNFLGame generateGameOutcome(
        String homeTeam,
        String awayTeam,
        Integer week,
        Integer season,
        SimulationConfiguration config
    );

    /**
     * Generates outcomes for all games in a week.
     */
    List<SimulatedNFLGame> generateWeekOutcomes(
        Integer week,
        Integer season,
        SimulationConfiguration config
    );

    /**
     * Regenerates outcome with specific seed (for replay).
     */
    SimulatedNFLGame replayGameOutcome(
        UUID originalGameId,
        Long seed
    );
}
```

### 3. PlayerStatsGenerator (Domain Service Port)

Generates player statistics based on game outcomes.

**Location**: `domain/port/PlayerStatsGenerator.java`

```java
public interface PlayerStatsGenerator {

    /**
     * Generates stats for all players in a game.
     */
    List<SimulatedPlayerStats> generateGameStats(
        SimulatedNFLGame game,
        SimulationConfiguration config
    );

    /**
     * Generates stats for a specific player.
     */
    SimulatedPlayerStats generatePlayerStats(
        Long nflPlayerId,
        String position,
        SimulatedNFLGame game,
        SimulationConfiguration config
    );

    /**
     * Generates defensive stats for a team.
     */
    SimulatedPlayerStats generateDefensiveStats(
        String team,
        SimulatedNFLGame game,
        SimulationConfiguration config
    );
}
```

### 4. SimulationRepository (Outbound Port)

Persistence for simulation data.

**Location**: `domain/port/SimulationRepository.java`

```java
public interface SimulationRepository {

    // SimulationRun
    SimulationRun saveRun(SimulationRun run);
    Optional<SimulationRun> findRunById(UUID id);
    List<SimulationRun> findRunsByLeague(UUID leagueId);
    List<SimulationRun> findRunsByStatus(SimulationStatus status);

    // SimulatedNFLGame
    void saveGame(SimulatedNFLGame game);
    void saveGames(List<SimulatedNFLGame> games);
    List<SimulatedNFLGame> findGamesByRun(UUID simulationRunId);
    List<SimulatedNFLGame> findGamesByWeek(UUID simulationRunId, Integer week);

    // SimulatedPlayerStats
    void savePlayerStats(SimulatedPlayerStats stats);
    void savePlayerStats(List<SimulatedPlayerStats> stats);
    List<SimulatedPlayerStats> findStatsByGame(UUID simulatedGameId);
    List<SimulatedPlayerStats> findStatsByPlayer(UUID simulationRunId, Long nflPlayerId);
    List<SimulatedPlayerStats> findStatsByWeek(UUID simulationRunId, Integer week);

    // SimulatedScore
    void saveScore(SimulatedScore score);
    void saveScores(List<SimulatedScore> scores);
    List<SimulatedScore> findScoresByWeek(UUID simulationRunId, Integer week);
    List<SimulatedScore> findScoresByPlayer(UUID simulationRunId, UUID leaguePlayerId);
}
```

---

## Stats Generation Strategy

### Position-Based Distribution

Each position has characteristic stat distributions:

```java
public class PositionStatDistributions {

    // QB typical game: 250 yards, 2 TDs, 0.7 INTs
    public static final StatDistribution QB = new StatDistribution(
        mean(250, 50),      // passing yards: mean 250, stddev 50
        mean(2.0, 1.0),     // passing TDs
        mean(0.7, 0.8),     // interceptions
        mean(20, 15),       // rushing yards
        mean(0.2, 0.4)      // rushing TDs
    );

    // RB typical game: 70 rushing yards, 3 receptions, 25 receiving yards
    public static final StatDistribution RB = new StatDistribution(
        mean(70, 30),       // rushing yards
        mean(0.5, 0.6),     // rushing TDs
        mean(3, 2),         // receptions
        mean(25, 15),       // receiving yards
        mean(0.2, 0.4)      // receiving TDs
    );

    // WR typical game: 5 receptions, 65 yards, 0.4 TDs
    public static final StatDistribution WR = new StatDistribution(
        mean(5, 2.5),       // receptions
        mean(65, 30),       // receiving yards
        mean(0.4, 0.5)      // receiving TDs
    );

    // TE typical game: 3 receptions, 35 yards
    public static final StatDistribution TE = new StatDistribution(
        mean(3, 2),         // receptions
        mean(35, 20),       // receiving yards
        mean(0.25, 0.4)     // receiving TDs
    );

    // K typical game: 1.5 FGs, 2.5 XPs
    public static final StatDistribution K = new StatDistribution(
        mean(1.5, 1.0),     // field goals
        mean(2.5, 1.5)      // extra points
    );

    // DEF typical game: varies by opponent score
    public static final StatDistribution DEF = new StatDistribution(
        mean(2.5, 1.5),     // sacks
        mean(0.8, 0.9),     // interceptions
        mean(0.5, 0.7)      // fumble recoveries
    );
}
```

### Game Context Adjustments

Stats are adjusted based on game outcome:

```java
public class GameContextAdjuster {

    /**
     * Adjusts stats based on game score and context.
     *
     * Winning team by large margin:
     * - More rushing yards (running out clock)
     * - Fewer passing attempts
     * - Lower interception risk
     *
     * Losing team playing from behind:
     * - More passing attempts
     * - More passing yards
     * - Higher interception risk
     * - Fewer rushing attempts
     *
     * Close game:
     * - Balanced stats
     * - Higher variability
     */
    public StatAdjustments calculateAdjustments(
        SimulatedNFLGame game,
        String playerTeam
    );
}
```

---

## Integration with Existing Systems

### 1. Scoring Integration

The Simulation Core uses the existing `SpelScoringEngine`:

```java
public class SimulationScoringService {

    private final SpelScoringEngine scoringEngine;
    private final ScoringRulesRepository rulesRepository;

    public void calculateSimulatedScores(
        UUID simulationRunId,
        UUID leagueId,
        Integer week
    ) {
        // Get league's scoring rules
        ScoringRules rules = rulesRepository.findByLeague(leagueId);

        // Get simulated stats for the week
        List<SimulatedPlayerStats> stats =
            simulationRepo.findStatsByWeek(simulationRunId, week);

        // Calculate fantasy points using existing engine
        for (SimulatedPlayerStats stat : stats) {
            Map<String, Object> variables = stat.toScoringVariables();
            Double points = scoringEngine.calculateScore(
                rules.getPprRules().getFormula(),
                variables
            );
            stat.setFantasyPoints(points);
        }
    }
}
```

### 2. Week Management Integration

Simulation respects league week configuration:

```java
public class SimulationWeekManager {

    private final WeekService weekService;

    public void progressSimulatedWeek(
        SimulationRun run,
        UUID leagueId
    ) {
        // Get current week
        Week currentWeek = weekService.getCurrentWeek(leagueId);

        // Simulate stats for this week
        List<SimulatedPlayerStats> stats = generateWeekStats(run, currentWeek);

        // Calculate scores
        calculateWeekScores(run, currentWeek, stats);

        // Apply elimination rules
        applyEliminationLogic(run, currentWeek);

        // Advance to next week (if not final)
        if (!isLastWeek(currentWeek)) {
            weekService.advanceToNextWeek(leagueId);
        }
    }
}
```

### 3. Roster Integration

Simulation uses actual roster configurations:

```java
public class SimulationRosterScorer {

    private final RosterRepository rosterRepository;

    public SimulatedScore calculateRosterScore(
        UUID simulationRunId,
        UUID leaguePlayerId,
        Integer week
    ) {
        // Get player's roster
        Roster roster = rosterRepository.findByLeaguePlayerId(leaguePlayerId);

        // Get simulated stats for roster players
        Map<Long, SimulatedPlayerStats> playerStats = getStatsForRoster(
            simulationRunId, roster, week
        );

        // Sum fantasy points from all roster positions
        double totalScore = 0.0;
        Map<String, Double> breakdown = new HashMap<>();

        for (RosterSlot slot : roster.getSlots()) {
            if (slot.getNflPlayerId() != null) {
                SimulatedPlayerStats stats = playerStats.get(slot.getNflPlayerId());
                if (stats != null) {
                    totalScore += stats.getFantasyPoints();
                    breakdown.put(
                        slot.getNflPlayerId().toString(),
                        stats.getFantasyPoints()
                    );
                }
            }
        }

        return new SimulatedScore(
            simulationRunId,
            leaguePlayerId,
            week,
            totalScore,
            breakdown
        );
    }
}
```

---

## Domain Events

### Simulation Events

```java
// Simulation lifecycle
public class SimulationStartedEvent extends DomainEvent {
    private UUID simulationRunId;
    private UUID leagueId;
    private SimulationMode mode;
    private SimulationConfiguration config;
}

public class SimulationCompletedEvent extends DomainEvent {
    private UUID simulationRunId;
    private Integer weeksSimulated;
    private Duration totalDuration;
}

public class SimulationFailedEvent extends DomainEvent {
    private UUID simulationRunId;
    private String errorMessage;
    private Integer failedAtWeek;
}

// Week simulation
public class SimulatedWeekCompletedEvent extends DomainEvent {
    private UUID simulationRunId;
    private Integer week;
    private Integer gamesSimulated;
    private Integer playersScored;
}

// Game simulation
public class SimulatedGameCompletedEvent extends DomainEvent {
    private UUID simulatedGameId;
    private String homeTeam;
    private String awayTeam;
    private Integer homeScore;
    private Integer awayScore;
}
```

---

## API Endpoints

### Simulation Controller

**Location**: `infrastructure/adapter/rest/SimulationController.java`

```
POST   /api/v1/admin/simulations
       Create and start new simulation

GET    /api/v1/admin/simulations/{id}
       Get simulation status and progress

POST   /api/v1/admin/simulations/{id}/pause
       Pause running simulation

POST   /api/v1/admin/simulations/{id}/resume
       Resume paused simulation

DELETE /api/v1/admin/simulations/{id}
       Cancel and delete simulation

GET    /api/v1/admin/simulations/{id}/games
       Get simulated game results

GET    /api/v1/admin/simulations/{id}/games/{week}
       Get games for specific week

GET    /api/v1/admin/simulations/{id}/stats
       Get all simulated player stats

GET    /api/v1/admin/simulations/{id}/stats/{week}
       Get stats for specific week

GET    /api/v1/admin/simulations/{id}/scores
       Get all roster scores

GET    /api/v1/admin/simulations/{id}/scores/{week}
       Get scores for specific week

GET    /api/v1/admin/simulations/{id}/standings
       Get current standings
```

---

## MongoDB Collections

### simulations Collection

```javascript
{
  _id: UUID,
  leagueId: UUID,
  mode: String,              // DEMO, TEST, REPLAY, BENCHMARK
  status: String,            // CREATED, RUNNING, PAUSED, COMPLETED, FAILED
  config: {
    timeAcceleration: String,
    randomSeed: Long,
    deterministicMode: Boolean,
    statDistribution: String,
    varianceMultiplier: Double,
    simulateInjuries: Boolean,
    simulateByeWeeks: Boolean,
    persistResults: Boolean,
    publishEvents: Boolean
  },
  currentNflWeek: Number,
  targetNflWeek: Number,
  gamesSimulated: Number,
  totalGames: Number,
  startedAt: ISODate,
  completedAt: ISODate,
  createdBy: String,
  createdAt: ISODate
}

// Indexes
db.simulations.createIndex({ leagueId: 1 })
db.simulations.createIndex({ status: 1 })
db.simulations.createIndex({ createdAt: -1 })
```

### simulated_games Collection

```javascript
{
  _id: UUID,
  simulationRunId: UUID,
  originalNflGameId: UUID,   // nullable, for replay mode
  season: Number,
  week: Number,
  homeTeam: String,
  awayTeam: String,
  homeScore: Number,
  awayScore: Number,
  result: String,            // HOME_WIN, AWAY_WIN, TIE
  quarterScoresHome: [Number],
  quarterScoresAway: [Number],
  simulatedAt: ISODate,
  randomSeedUsed: Long
}

// Indexes
db.simulated_games.createIndex({ simulationRunId: 1, week: 1 })
db.simulated_games.createIndex({ simulationRunId: 1, homeTeam: 1 })
db.simulated_games.createIndex({ simulationRunId: 1, awayTeam: 1 })
```

### simulated_player_stats Collection

```javascript
{
  _id: UUID,
  simulationRunId: UUID,
  simulatedGameId: UUID,
  nflPlayerId: Long,
  playerName: String,
  position: String,
  team: String,
  season: Number,
  week: Number,

  // Stats by category
  passingYards: Number,
  passingTouchdowns: Number,
  interceptions: Number,
  rushingYards: Number,
  rushingTouchdowns: Number,
  receptions: Number,
  receivingYards: Number,
  receivingTouchdowns: Number,
  // ... all other stat fields

  fantasyPoints: Double,
  pprFantasyPoints: Double,
  halfPprFantasyPoints: Double,
  simulatedAt: ISODate
}

// Indexes
db.simulated_player_stats.createIndex({ simulationRunId: 1, week: 1 })
db.simulated_player_stats.createIndex({ simulationRunId: 1, nflPlayerId: 1 })
db.simulated_player_stats.createIndex({ simulationRunId: 1, team: 1, week: 1 })
```

### simulated_scores Collection

```javascript
{
  _id: UUID,
  simulationRunId: UUID,
  leaguePlayerId: UUID,
  weekId: UUID,
  week: Number,
  totalScore: Double,
  playerScores: {
    "<nflPlayerId>": Double,
    // ...
  },
  rank: Number,
  isEliminated: Boolean,
  originalScore: Double,     // nullable, for replay comparison
  scoreDifference: Double,   // nullable
  calculatedAt: ISODate
}

// Indexes
db.simulated_scores.createIndex({ simulationRunId: 1, week: 1 })
db.simulated_scores.createIndex({ simulationRunId: 1, leaguePlayerId: 1 })
db.simulated_scores.createIndex({ simulationRunId: 1, rank: 1 })
```

---

## Feature File

**Location**: `features/ffl-simulation-core.feature`

```gherkin
Feature: Simulation Core
  As a system administrator
  I want to simulate fantasy football seasons
  So that I can test, demo, and analyze the platform

  Background:
    Given a league exists with code "DEMO-2025"
    And the league is configured for weeks 15-18
    And the league has 10 players with complete rosters

  # Basic Simulation

  Scenario: Start instant simulation
    When an admin starts an instant simulation for league "DEMO-2025"
    Then a simulation run is created with status "RUNNING"
    And all 4 weeks are simulated
    And simulation status becomes "COMPLETED"
    And all player rosters have scores for each week

  Scenario: Start demo mode simulation
    When an admin starts a demo simulation for league "DEMO-2025"
    Then a simulation run is created with status "RUNNING"
    And games are simulated at 10x speed
    And scores update in real-time

  # Deterministic Testing

  Scenario: Reproducible simulation with seed
    Given simulation seed is set to 12345
    When an admin runs a test simulation for league "DEMO-2025"
    And the simulation completes
    And another simulation is run with seed 12345
    Then both simulations produce identical results
    And all game scores match exactly
    And all player stats match exactly

  # Stats Generation

  Scenario: QB stats generation follows realistic distribution
    When a simulation generates QB stats for 100 games
    Then average passing yards is between 200 and 300
    And average passing TDs is between 1.5 and 2.5
    And average interceptions is between 0.5 and 1.0

  Scenario: Game context affects stats
    Given a simulated game where team A wins 35-10
    When player stats are generated
    Then team A rushing yards are higher than average
    And team B passing attempts are higher than average

  # Scoring Integration

  Scenario: Simulated stats use league scoring rules
    Given league "DEMO-2025" uses full PPR scoring
    When a WR has 6 receptions and 80 yards in simulation
    Then the fantasy points calculation includes:
      | Component        | Formula      | Points |
      | Receptions       | 6 × 1.0      | 6.0    |
      | Receiving yards  | 80 / 10      | 8.0    |
      | Total            |              | 14.0   |

  # Week Progression

  Scenario: Simulation advances through weeks
    When simulation starts at week 15
    Then week 15 games are simulated first
    And scores are calculated for week 15
    And eliminations are applied for week 15
    Then simulation advances to week 16
    And the process repeats for each configured week

  # Elimination Logic

  Scenario: Elimination applies after each week
    Given league uses bottom-2 elimination per week
    When week 15 simulation completes
    Then 2 lowest scoring players are marked eliminated
    And eliminated players' rosters are not scored in future weeks

  # Replay Mode

  Scenario: Replay with different roster
    Given historical game data exists for week 15
    And player "A" had roster with Patrick Mahomes
    When admin runs replay simulation
    And modifies player "A" roster to have Josh Allen instead
    Then new fantasy scores are calculated
    And original vs new score comparison is available

  # Error Handling

  Scenario: Simulation handles missing player data
    Given NFL player "Unknown Player" has no stats
    When simulation generates stats for week 15
    Then "Unknown Player" gets zero fantasy points
    And simulation continues without failing

  Scenario: Simulation can be cancelled
    Given a simulation is running
    When admin cancels the simulation
    Then simulation status becomes "CANCELLED"
    And partial results are preserved
```

---

## Files to Create

### Domain Layer
- `domain/aggregate/SimulationRun.java`
- `domain/entity/SimulatedNFLGame.java`
- `domain/entity/SimulatedPlayerStats.java`
- `domain/entity/SimulatedScore.java`
- `domain/model/SimulationConfiguration.java`
- `domain/model/SimulationMode.java`
- `domain/model/SimulationStatus.java`
- `domain/model/TimeAcceleration.java`
- `domain/model/StatDistribution.java`
- `domain/model/PositionStatDistributions.java`
- `domain/port/SimulationEngine.java`
- `domain/port/GameOutcomeGenerator.java`
- `domain/port/PlayerStatsGenerator.java`
- `domain/port/SimulationRepository.java`
- `domain/event/simulation/*.java` (events)
- `domain/service/GameContextAdjuster.java`

### Application Layer
- `application/usecase/StartSimulationUseCase.java`
- `application/usecase/SimulateWeekUseCase.java`
- `application/usecase/CancelSimulationUseCase.java`
- `application/usecase/GetSimulationResultsUseCase.java`
- `application/service/SimulationScoringService.java`
- `application/service/SimulationWeekManager.java`
- `application/service/SimulationRosterScorer.java`
- `application/dto/SimulationDTO.java`
- `application/dto/SimulatedGameDTO.java`
- `application/dto/SimulatedStatsDTO.java`

### Infrastructure Layer
- `infrastructure/adapter/rest/SimulationController.java`
- `infrastructure/adapter/persistence/document/SimulationRunDocument.java`
- `infrastructure/adapter/persistence/document/SimulatedGameDocument.java`
- `infrastructure/adapter/persistence/document/SimulatedPlayerStatsDocument.java`
- `infrastructure/adapter/persistence/document/SimulatedScoreDocument.java`
- `infrastructure/adapter/persistence/repository/MongoSimulationRepository.java`
- `infrastructure/adapter/persistence/SimulationRepositoryImpl.java`
- `infrastructure/adapter/persistence/mapper/SimulationMapper.java`
- `infrastructure/simulation/DefaultSimulationEngine.java`
- `infrastructure/simulation/DefaultGameOutcomeGenerator.java`
- `infrastructure/simulation/DefaultPlayerStatsGenerator.java`

### Feature File
- `features/ffl-simulation-core.feature`

---

## Implementation Priority

### Phase 1: Core Infrastructure
1. SimulationRun aggregate and repository
2. SimulatedNFLGame entity
3. SimulatedPlayerStats entity
4. Basic GameOutcomeGenerator (random scores)
5. Basic PlayerStatsGenerator (position averages)

### Phase 2: Scoring Integration
1. Connect to SpelScoringEngine
2. SimulatedScore calculation
3. Roster integration
4. Week progression

### Phase 3: Advanced Features
1. Deterministic mode with seeds
2. Replay mode
3. Game context adjustments
4. Realistic stat distributions

### Phase 4: API & Demo Mode
1. REST endpoints
2. Demo mode with real-time updates
3. Time acceleration
4. Event publishing

---

**Document Status**: Ready for Implementation
**Created**: 2025-12-29
**Ticket**: ANIMA-1019
