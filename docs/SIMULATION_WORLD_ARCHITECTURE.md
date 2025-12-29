# Simulation World Curation and Configuration Architecture

> **ANIMA-1031**: Design and architecture for Simulation World configuration

## Overview

The Simulation World provides the foundation environment for fantasy football simulations. It defines:

- **Player Archetypes**: Performance distributions by position and tier
- **Team Strength Profiles**: Offensive and defensive capabilities
- **Scenario Presets**: Pre-configured league setups for common use cases
- **World Templates**: Reusable, shareable world configurations
- **Season Profiles**: Historical or hypothetical season data

This complements the Simulation Core by providing the "what" (world configuration) that the core uses to determine "how" (execution).

---

## Use Cases

### Primary Use Cases

1. **Create Custom World**
   - Define player archetypes and distributions
   - Configure team strengths
   - Set environmental parameters
   - Save for reuse

2. **Use Preset Scenario**
   - Select from curated scenarios (Demo, Testing, Historical)
   - Apply preset with minimal configuration
   - Customize specific aspects as needed

3. **Clone and Modify World**
   - Start from existing world template
   - Adjust specific parameters
   - Save as new template

4. **Import Historical Season**
   - Load actual NFL season data
   - Use real player performance as baseline
   - Enable "what-if" analysis

5. **Export World Template**
   - Share configurations across environments
   - Version control world definitions
   - Enable reproducible simulations

---

## Domain Model

### 1. SimulationWorld (Aggregate Root)

The main container for all simulation world configuration.

**Location**: `domain/aggregate/SimulationWorld.java`

```java
public class SimulationWorld {

    private UUID id;
    private String name;
    private String description;
    private WorldType type;                     // CUSTOM, PRESET, HISTORICAL, DEMO
    private WorldStatus status;                 // DRAFT, ACTIVE, ARCHIVED

    // Season context
    private Integer season;                     // NFL season year (e.g., 2025)
    private Integer startWeek;                  // Starting NFL week (1-22)
    private Integer endWeek;                    // Ending NFL week

    // World components
    private List<PlayerArchetype> playerArchetypes;
    private List<TeamStrengthProfile> teamStrengths;
    private EnvironmentConfig environment;
    private ScoringProfile scoringProfile;

    // Source tracking
    private UUID sourceTemplateId;              // If cloned from template
    private String sourceDescription;

    // Metadata
    private String createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private Long version;

    // Business methods
    public void activate();
    public void archive();
    public PlayerArchetype getArchetypeForPlayer(Long nflPlayerId);
    public TeamStrengthProfile getTeamStrength(String teamAbbreviation);
    public void validate();
    public SimulationWorld clone(String newName);
}
```

**WorldType Enum**:
```java
public enum WorldType {
    CUSTOM,         // User-created from scratch
    PRESET,         // System-provided preset
    HISTORICAL,     // Based on actual NFL season data
    DEMO,           // Optimized for demonstrations
    TEST            // Designed for testing scenarios
}
```

**WorldStatus Enum**:
```java
public enum WorldStatus {
    DRAFT,          // Being configured
    ACTIVE,         // Ready for use
    ARCHIVED        // No longer available
}
```

### 2. PlayerArchetype (Entity)

Defines performance distributions for a player or player category.

**Location**: `domain/entity/PlayerArchetype.java`

```java
public class PlayerArchetype {

    private UUID id;
    private UUID worldId;

    // Identification
    private ArchetypeScope scope;               // INDIVIDUAL, TIER, POSITION
    private Long nflPlayerId;                   // If INDIVIDUAL
    private String playerName;                  // Display name
    private Position position;
    private PerformanceTier tier;               // ELITE, STARTER, BACKUP, PRACTICE_SQUAD

    // Stat distributions
    private StatDistributionSet statDistributions;

    // Availability
    private Double injuryProbability;           // 0.0 - 1.0
    private Double byeWeekModifier;             // Stat multiplier when coming off bye
    private Double primtimeModifier;            // Stat multiplier for prime time games

    // Consistency
    private Double consistencyRating;           // 0.0 (boom/bust) to 1.0 (consistent)
    private Double upwardVariance;              // Max positive deviation
    private Double downwardVariance;            // Max negative deviation

    // Methods
    public StatDistribution getDistributionFor(StatCategory category);
    public Double generateStatValue(StatCategory category, Random random);
}
```

**ArchetypeScope Enum**:
```java
public enum ArchetypeScope {
    INDIVIDUAL,     // Specific NFL player
    TIER,           // Performance tier (e.g., "Elite QB")
    POSITION,       // All players at position
    DEFAULT         // Fallback for unmapped players
}
```

**PerformanceTier Enum**:
```java
public enum PerformanceTier {
    ELITE(1.3),           // Top 5 at position
    PRO_BOWL(1.15),       // Top 12 at position
    STARTER(1.0),         // Average starter
    BACKUP(0.7),          // Second string
    PRACTICE_SQUAD(0.4);  // Rarely plays

    private final double baseMultiplier;
}
```

### 3. StatDistributionSet (Value Object)

Collection of stat distributions for a player archetype.

**Location**: `domain/model/StatDistributionSet.java`

```java
public class StatDistributionSet {

    // Passing distributions (for QB)
    private StatDistribution passingYards;
    private StatDistribution passingTouchdowns;
    private StatDistribution interceptions;
    private StatDistribution passingAttempts;
    private StatDistribution completionPercentage;

    // Rushing distributions (for RB, QB)
    private StatDistribution rushingYards;
    private StatDistribution rushingTouchdowns;
    private StatDistribution rushingAttempts;

    // Receiving distributions (for WR, RB, TE)
    private StatDistribution receptions;
    private StatDistribution receivingYards;
    private StatDistribution receivingTouchdowns;
    private StatDistribution targets;

    // Kicking distributions (for K)
    private StatDistribution fieldGoalAttempts;
    private StatDistribution fieldGoalPercentage;
    private StatDistribution extraPointAttempts;
    private StatDistribution kickDistanceAverage;

    // Defensive distributions (for DEF)
    private StatDistribution sacks;
    private StatDistribution interceptionsDef;
    private StatDistribution fumbleRecoveries;
    private StatDistribution pointsAllowed;
    private StatDistribution yardsAllowed;

    // Factory methods
    public static StatDistributionSet forEliteQB();
    public static StatDistributionSet forStarterRB();
    public static StatDistributionSet forEliteWR();
    // ... more presets
}
```

### 4. StatDistribution (Value Object)

Defines a single stat's probability distribution.

**Location**: `domain/model/StatDistribution.java`

```java
public class StatDistribution {

    private DistributionType type;              // NORMAL, POISSON, UNIFORM, CUSTOM
    private Double mean;
    private Double standardDeviation;
    private Double minimum;                     // Floor value
    private Double maximum;                     // Ceiling value

    // For custom distributions
    private List<Double> customProbabilities;
    private List<Double> customValues;

    // Game context adjustments
    private Double homeAdvantage;               // Multiplier when home team
    private Double favoredMultiplier;           // When team is favored
    private Double underdogMultiplier;          // When team is underdog

    // Methods
    public Double generate(Random random);
    public Double generateWithContext(Random random, GameContext context);

    // Factory methods
    public static StatDistribution normal(double mean, double stdDev);
    public static StatDistribution poisson(double lambda);
    public static StatDistribution fixed(double value);
}
```

**DistributionType Enum**:
```java
public enum DistributionType {
    NORMAL,         // Bell curve distribution
    POISSON,        // Count-based (TDs, INTs)
    UNIFORM,        // Equal probability in range
    SKEWED_RIGHT,   // Long tail for big games
    CUSTOM          // User-defined probabilities
}
```

### 5. TeamStrengthProfile (Entity)

Defines team offensive and defensive capabilities.

**Location**: `domain/entity/TeamStrengthProfile.java`

```java
public class TeamStrengthProfile {

    private UUID id;
    private UUID worldId;
    private String teamAbbreviation;            // "KC", "SF", etc.
    private String teamName;

    // Overall ratings (0-100)
    private Integer overallRating;
    private Integer offensiveRating;
    private Integer defensiveRating;
    private Integer specialTeamsRating;

    // Offensive tendencies
    private Double passingTendency;             // 0.0 (run-heavy) to 1.0 (pass-heavy)
    private Double explosivePlayRate;           // Big play frequency
    private Double redZoneEfficiency;
    private Double timeOfPossessionTarget;      // Minutes per game

    // Defensive tendencies
    private Double sackRate;
    private Double turnoverRate;
    private Double pointsAllowedAverage;
    private Double yardsAllowedAverage;

    // Home/away splits
    private Double homeAdvantage;               // Multiplier at home
    private Integer homeWinPercentage;

    // Matchup modifiers
    private Map<String, Double> divisionModifiers;  // Adjustments vs division rivals

    // Methods
    public Double getGameStrengthModifier(String opponent, boolean isHome);
    public Double getExpectedPointsFor();
    public Double getExpectedPointsAgainst();
}
```

### 6. EnvironmentConfig (Value Object)

Global environment settings for the simulation world.

**Location**: `domain/model/EnvironmentConfig.java`

```java
public class EnvironmentConfig {

    // Injury simulation
    private boolean simulateInjuries;
    private Double baseInjuryRate;              // Per game probability
    private Map<Position, Double> positionInjuryRates;

    // Weather effects
    private boolean simulateWeather;
    private Double weatherImpactMultiplier;
    private Map<WeatherType, StatModifiers> weatherEffects;

    // Game flow
    private Double averageGameLength;           // Minutes
    private Double overtimeProbability;
    private Integer maxOvertimePeriods;

    // Bye weeks
    private boolean respectByeWeeks;
    private Map<String, Integer> teamByeWeeks;  // Team -> NFL week

    // Randomness control
    private Double chaosLevel;                  // 0.0 (predictable) to 1.0 (chaotic)
    private boolean allowUpsets;
    private Double upsetProbabilityBoost;

    // Factory methods
    public static EnvironmentConfig realistic();
    public static EnvironmentConfig demo();
    public static EnvironmentConfig testing();
}
```

**WeatherType Enum**:
```java
public enum WeatherType {
    CLEAR(1.0),
    RAIN(0.9),
    SNOW(0.8),
    WIND(0.85),
    EXTREME_COLD(0.9),
    EXTREME_HEAT(0.95),
    DOME(1.0);

    private final double defaultModifier;
}
```

### 7. ScoringProfile (Value Object)

Scoring configuration for the simulation world.

**Location**: `domain/model/ScoringProfile.java`

```java
public class ScoringProfile {

    private ScoringTemplate baseTemplate;       // STANDARD, HALF_PPR, FULL_PPR, etc.

    // Custom overrides
    private PPRScoringRules pprRules;
    private FieldGoalScoringRules fieldGoalRules;
    private DefensiveScoringRules defensiveRules;

    // Position-specific formula overrides
    private Map<Position, ScoringFormula> customFormulas;

    // Bonus scoring
    private boolean enable100YardBonuses;
    private Double hundredYardRushingBonus;
    private Double hundredYardReceivingBonus;
    private Double threeHundredYardPassingBonus;

    // Methods
    public ScoringFormula getFormulaForPosition(Position position);
    public Double calculateFantasyPoints(PlayerStats stats);

    // Factory methods
    public static ScoringProfile fromTemplate(ScoringTemplate template);
    public static ScoringProfile custom();
}
```

### 8. WorldTemplate (Aggregate)

A reusable, shareable world configuration template.

**Location**: `domain/aggregate/WorldTemplate.java`

```java
public class WorldTemplate {

    private UUID id;
    private String name;
    private String description;
    private TemplateCategory category;          // OFFICIAL, COMMUNITY, PRIVATE
    private TemplateStatus status;              // DRAFT, PUBLISHED, DEPRECATED

    // Version control
    private Integer versionNumber;
    private UUID previousVersionId;
    private String versionNotes;

    // Content
    private SimulationWorld worldDefinition;

    // Metadata
    private String authorId;
    private String authorName;
    private LocalDateTime publishedAt;
    private Integer usageCount;
    private Double averageRating;

    // Tags for discovery
    private Set<String> tags;                   // "PPR", "playoff", "beginner", etc.

    // Methods
    public SimulationWorld instantiate(String worldName);
    public WorldTemplate createNewVersion(String notes);
    public void publish();
    public void deprecate();
}
```

**TemplateCategory Enum**:
```java
public enum TemplateCategory {
    OFFICIAL,       // System-provided, curated
    VERIFIED,       // Community-created, reviewed
    COMMUNITY,      // User-created, public
    PRIVATE         // User-created, not shared
}
```

### 9. ScenarioPreset (Entity)

Pre-configured league scenario for quick setup.

**Location**: `domain/entity/ScenarioPreset.java`

```java
public class ScenarioPreset {

    private UUID id;
    private String name;
    private String description;
    private ScenarioType type;

    // League configuration
    private Integer playerCount;                // Number of league players
    private RosterConfiguration rosterConfig;
    private ScoringProfile scoringProfile;

    // World reference
    private UUID worldTemplateId;
    private String worldTemplateName;

    // Simulation defaults
    private SimulationMode defaultMode;
    private TimeAcceleration defaultSpeed;
    private Integer weeksToSimulate;

    // Tags
    private Set<String> tags;
    private boolean isFeatured;
    private Integer displayOrder;

    // Methods
    public SimulationConfiguration toSimulationConfig();
    public League createLeague(String leagueName, UUID ownerId);
}
```

**ScenarioType Enum**:
```java
public enum ScenarioType {
    DEMO,               // For demonstrations
    QUICK_START,        // Minimal configuration needed
    COMPETITIVE,        // Balanced for real competition
    TESTING,            // For development/QA
    TUTORIAL,           // Learning the system
    HISTORICAL          // Based on real season
}
```

---

## Curated Presets

### Official World Templates

```java
public class OfficialWorldTemplates {

    /**
     * 2024 NFL Season - Realistic
     * - Actual team strengths from 2024 season
     * - Player archetypes based on performance
     * - Realistic injury and weather modeling
     */
    public static WorldTemplate nfl2024Realistic();

    /**
     * 2024 NFL Playoffs
     * - 14 playoff teams only
     * - Weeks 19-22 (Wild Card to Super Bowl)
     * - Elite player focus
     */
    public static WorldTemplate nfl2024Playoffs();

    /**
     * Demo World - Balanced
     * - 32 teams with equal strength
     * - High-scoring, exciting games
     * - No injuries or weather
     */
    public static WorldTemplate demoBalanced();

    /**
     * Demo World - Chaos
     * - Unpredictable outcomes
     * - High variance
     * - Lots of upsets
     */
    public static WorldTemplate demoChaos();

    /**
     * Testing - Deterministic
     * - Reproducible outcomes
     * - Fixed stat distributions
     * - Seed-controlled randomness
     */
    public static WorldTemplate testingDeterministic();

    /**
     * Testing - Edge Cases
     * - Extreme stat values
     * - Injury-heavy
     * - Tests system limits
     */
    public static WorldTemplate testingEdgeCases();
}
```

### Default Player Archetypes

```java
public class DefaultPlayerArchetypes {

    // Elite Tier (Top 5 at position)
    public static PlayerArchetype eliteQB() {
        return PlayerArchetype.builder()
            .position(Position.QB)
            .tier(PerformanceTier.ELITE)
            .statDistributions(StatDistributionSet.builder()
                .passingYards(StatDistribution.normal(285, 45))
                .passingTouchdowns(StatDistribution.poisson(2.3))
                .interceptions(StatDistribution.poisson(0.5))
                .rushingYards(StatDistribution.normal(25, 15))
                .build())
            .consistencyRating(0.85)
            .injuryProbability(0.03)
            .build();
    }

    public static PlayerArchetype eliteRB() {
        return PlayerArchetype.builder()
            .position(Position.RB)
            .tier(PerformanceTier.ELITE)
            .statDistributions(StatDistributionSet.builder()
                .rushingYards(StatDistribution.normal(95, 30))
                .rushingTouchdowns(StatDistribution.poisson(0.8))
                .receptions(StatDistribution.poisson(4))
                .receivingYards(StatDistribution.normal(35, 20))
                .build())
            .consistencyRating(0.75)
            .injuryProbability(0.06)
            .build();
    }

    public static PlayerArchetype eliteWR() {
        return PlayerArchetype.builder()
            .position(Position.WR)
            .tier(PerformanceTier.ELITE)
            .statDistributions(StatDistributionSet.builder()
                .receptions(StatDistribution.poisson(7))
                .receivingYards(StatDistribution.normal(90, 35))
                .receivingTouchdowns(StatDistribution.poisson(0.6))
                .targets(StatDistribution.poisson(10))
                .build())
            .consistencyRating(0.70)
            .injuryProbability(0.04)
            .build();
    }

    // Starter Tier (Average starters)
    public static PlayerArchetype starterQB();
    public static PlayerArchetype starterRB();
    public static PlayerArchetype starterWR();
    public static PlayerArchetype starterTE();
    public static PlayerArchetype starterK();
    public static PlayerArchetype starterDEF();

    // Backup Tier
    public static PlayerArchetype backupQB();
    // ... etc
}
```

### Default Team Strengths

```java
public class DefaultTeamStrengths {

    /**
     * Creates team strengths based on 2024 power rankings.
     */
    public static List<TeamStrengthProfile> nfl2024() {
        return List.of(
            TeamStrengthProfile.builder()
                .teamAbbreviation("KC")
                .teamName("Kansas City Chiefs")
                .overallRating(92)
                .offensiveRating(95)
                .defensiveRating(85)
                .passingTendency(0.62)
                .homeAdvantage(1.08)
                .build(),

            TeamStrengthProfile.builder()
                .teamAbbreviation("SF")
                .teamName("San Francisco 49ers")
                .overallRating(90)
                .offensiveRating(92)
                .defensiveRating(88)
                .passingTendency(0.48)
                .homeAdvantage(1.05)
                .build(),

            // ... all 32 teams
        );
    }

    /**
     * Creates balanced team strengths for demo mode.
     */
    public static List<TeamStrengthProfile> balanced() {
        return NFLTeams.ALL.stream()
            .map(team -> TeamStrengthProfile.builder()
                .teamAbbreviation(team.getAbbreviation())
                .teamName(team.getName())
                .overallRating(80)
                .offensiveRating(80)
                .defensiveRating(80)
                .passingTendency(0.55)
                .homeAdvantage(1.03)
                .build())
            .toList();
    }
}
```

---

## Port Interfaces

### WorldRepository

**Location**: `domain/port/WorldRepository.java`

```java
public interface WorldRepository {

    // SimulationWorld
    SimulationWorld save(SimulationWorld world);
    Optional<SimulationWorld> findById(UUID id);
    List<SimulationWorld> findByCreator(String creatorId);
    List<SimulationWorld> findByType(WorldType type);
    List<SimulationWorld> findByStatus(WorldStatus status);

    // WorldTemplate
    WorldTemplate saveTemplate(WorldTemplate template);
    Optional<WorldTemplate> findTemplateById(UUID id);
    List<WorldTemplate> findTemplatesByCategory(TemplateCategory category);
    List<WorldTemplate> searchTemplates(String query, Set<String> tags);
    List<WorldTemplate> findFeaturedTemplates();

    // ScenarioPreset
    ScenarioPreset savePreset(ScenarioPreset preset);
    Optional<ScenarioPreset> findPresetById(UUID id);
    List<ScenarioPreset> findPresetsByType(ScenarioType type);
    List<ScenarioPreset> findFeaturedPresets();
}
```

### WorldCurationService

**Location**: `domain/port/WorldCurationService.java`

```java
public interface WorldCurationService {

    /**
     * Creates a new world from a template.
     */
    SimulationWorld createFromTemplate(UUID templateId, String worldName, String creatorId);

    /**
     * Creates a new world from a preset scenario.
     */
    SimulationWorld createFromPreset(UUID presetId, String worldName, String creatorId);

    /**
     * Clones an existing world.
     */
    SimulationWorld cloneWorld(UUID sourceWorldId, String newName, String creatorId);

    /**
     * Imports world from external format (JSON).
     */
    SimulationWorld importWorld(String jsonDefinition, String creatorId);

    /**
     * Exports world to shareable format.
     */
    String exportWorld(UUID worldId);

    /**
     * Validates world configuration.
     */
    ValidationResult validateWorld(SimulationWorld world);

    /**
     * Publishes a world as a template.
     */
    WorldTemplate publishAsTemplate(UUID worldId, String name, String description);
}
```

### HistoricalDataProvider

**Location**: `domain/port/HistoricalDataProvider.java`

```java
public interface HistoricalDataProvider {

    /**
     * Gets player archetypes based on historical performance.
     */
    List<PlayerArchetype> getPlayerArchetypesForSeason(Integer season);

    /**
     * Gets team strengths based on historical record.
     */
    List<TeamStrengthProfile> getTeamStrengthsForSeason(Integer season);

    /**
     * Gets actual game results for a season/week.
     */
    List<GameResult> getGameResults(Integer season, Integer week);

    /**
     * Gets actual player stats for a season/week.
     */
    List<PlayerStats> getPlayerStats(Integer season, Integer week);

    /**
     * Creates a world based on historical data.
     */
    SimulationWorld createHistoricalWorld(Integer season, Integer startWeek, Integer endWeek);
}
```

---

## API Endpoints

### World Management

```
POST   /api/v1/admin/worlds
       Create new simulation world

GET    /api/v1/admin/worlds
       List all worlds for current user

GET    /api/v1/admin/worlds/{id}
       Get world details

PUT    /api/v1/admin/worlds/{id}
       Update world configuration

DELETE /api/v1/admin/worlds/{id}
       Delete world

POST   /api/v1/admin/worlds/{id}/clone
       Clone world with new name

POST   /api/v1/admin/worlds/{id}/activate
       Activate world for use

POST   /api/v1/admin/worlds/{id}/archive
       Archive world
```

### Templates

```
GET    /api/v1/worlds/templates
       List available templates (with filtering)

GET    /api/v1/worlds/templates/{id}
       Get template details

POST   /api/v1/worlds/templates/{id}/instantiate
       Create world from template

POST   /api/v1/admin/worlds/{id}/publish
       Publish world as template
```

### Presets

```
GET    /api/v1/worlds/presets
       List scenario presets

GET    /api/v1/worlds/presets/{id}
       Get preset details

POST   /api/v1/worlds/presets/{id}/apply
       Create world and league from preset
```

### Player Archetypes

```
GET    /api/v1/admin/worlds/{worldId}/archetypes
       List player archetypes

POST   /api/v1/admin/worlds/{worldId}/archetypes
       Add player archetype

PUT    /api/v1/admin/worlds/{worldId}/archetypes/{id}
       Update archetype

DELETE /api/v1/admin/worlds/{worldId}/archetypes/{id}
       Remove archetype
```

### Team Strengths

```
GET    /api/v1/admin/worlds/{worldId}/teams
       List team strength profiles

PUT    /api/v1/admin/worlds/{worldId}/teams/{teamAbbr}
       Update team strength
```

---

## MongoDB Collections

### simulation_worlds Collection

```javascript
{
  _id: UUID,
  name: String,
  description: String,
  type: String,                    // CUSTOM, PRESET, HISTORICAL, DEMO, TEST
  status: String,                  // DRAFT, ACTIVE, ARCHIVED
  season: Number,
  startWeek: Number,
  endWeek: Number,

  environment: {
    simulateInjuries: Boolean,
    baseInjuryRate: Double,
    simulateWeather: Boolean,
    chaosLevel: Double,
    allowUpsets: Boolean
  },

  scoringProfile: {
    baseTemplate: String,
    pprRules: Object,
    fieldGoalRules: Object,
    defensiveRules: Object,
    customFormulas: Object
  },

  sourceTemplateId: UUID,
  createdBy: String,
  createdAt: ISODate,
  updatedAt: ISODate,
  version: Long
}

// Indexes
db.simulation_worlds.createIndex({ createdBy: 1 })
db.simulation_worlds.createIndex({ type: 1, status: 1 })
db.simulation_worlds.createIndex({ name: "text", description: "text" })
```

### player_archetypes Collection

```javascript
{
  _id: UUID,
  worldId: UUID,
  scope: String,                   // INDIVIDUAL, TIER, POSITION, DEFAULT
  nflPlayerId: Long,               // nullable
  playerName: String,
  position: String,
  tier: String,

  statDistributions: {
    passingYards: { type: String, mean: Double, stdDev: Double, min: Double, max: Double },
    passingTouchdowns: { type: String, mean: Double, ... },
    // ... all stat categories
  },

  injuryProbability: Double,
  consistencyRating: Double,
  upwardVariance: Double,
  downwardVariance: Double
}

// Indexes
db.player_archetypes.createIndex({ worldId: 1 })
db.player_archetypes.createIndex({ worldId: 1, position: 1 })
db.player_archetypes.createIndex({ worldId: 1, nflPlayerId: 1 })
db.player_archetypes.createIndex({ worldId: 1, tier: 1 })
```

### team_strength_profiles Collection

```javascript
{
  _id: UUID,
  worldId: UUID,
  teamAbbreviation: String,
  teamName: String,

  overallRating: Number,
  offensiveRating: Number,
  defensiveRating: Number,
  specialTeamsRating: Number,

  passingTendency: Double,
  explosivePlayRate: Double,
  redZoneEfficiency: Double,

  sackRate: Double,
  turnoverRate: Double,
  pointsAllowedAverage: Double,
  yardsAllowedAverage: Double,

  homeAdvantage: Double,
  homeWinPercentage: Number,
  divisionModifiers: Object
}

// Indexes
db.team_strength_profiles.createIndex({ worldId: 1 })
db.team_strength_profiles.createIndex({ worldId: 1, teamAbbreviation: 1 }, { unique: true })
```

### world_templates Collection

```javascript
{
  _id: UUID,
  name: String,
  description: String,
  category: String,               // OFFICIAL, VERIFIED, COMMUNITY, PRIVATE
  status: String,                 // DRAFT, PUBLISHED, DEPRECATED

  versionNumber: Number,
  previousVersionId: UUID,
  versionNotes: String,

  worldDefinition: Object,        // Embedded SimulationWorld

  authorId: String,
  authorName: String,
  publishedAt: ISODate,
  usageCount: Number,
  averageRating: Double,
  tags: [String]
}

// Indexes
db.world_templates.createIndex({ category: 1, status: 1 })
db.world_templates.createIndex({ tags: 1 })
db.world_templates.createIndex({ usageCount: -1 })
db.world_templates.createIndex({ name: "text", description: "text", tags: "text" })
```

### scenario_presets Collection

```javascript
{
  _id: UUID,
  name: String,
  description: String,
  type: String,                   // DEMO, QUICK_START, COMPETITIVE, etc.

  playerCount: Number,
  rosterConfig: Object,
  scoringProfile: Object,

  worldTemplateId: UUID,
  worldTemplateName: String,

  defaultMode: String,
  defaultSpeed: String,
  weeksToSimulate: Number,

  tags: [String],
  isFeatured: Boolean,
  displayOrder: Number
}

// Indexes
db.scenario_presets.createIndex({ type: 1 })
db.scenario_presets.createIndex({ isFeatured: 1, displayOrder: 1 })
```

---

## Feature File

**Location**: `features/ffl-simulation-world.feature`

```gherkin
Feature: Simulation World Curation and Configuration
  As a league administrator
  I want to configure simulation worlds
  So that I can create realistic or custom fantasy football scenarios

  Background:
    Given I am authenticated as an admin user

  # World Creation

  Scenario: Create world from official template
    Given the official template "NFL 2024 Realistic" exists
    When I create a world from template "NFL 2024 Realistic"
    And I name it "My 2024 League Simulation"
    Then a new simulation world is created
    And the world inherits player archetypes from template
    And the world inherits team strengths from template
    And the world status is "DRAFT"

  Scenario: Create custom world from scratch
    When I create a new custom simulation world
    And I set season to 2025
    And I set weeks 15 to 18
    And I configure scoring as "Full PPR"
    Then a world is created with type "CUSTOM"
    And no player archetypes are assigned
    And I must configure archetypes before activation

  Scenario: Clone existing world
    Given I have a world "My Custom World" with custom archetypes
    When I clone the world with name "My Custom World v2"
    Then a new world is created with same configuration
    And the source is tracked as "My Custom World"
    And I can modify the clone independently

  # Player Archetypes

  Scenario: Configure elite QB archetype
    Given I have a simulation world "Test World"
    When I add a player archetype with:
      | Position     | QB                  |
      | Tier         | ELITE               |
      | Passing Mean | 285 yards           |
      | Passing StdDev | 45 yards          |
      | TD Mean      | 2.3                 |
      | INT Mean     | 0.5                 |
      | Consistency  | 0.85                |
    Then the archetype is added to the world
    And QB players without individual archetypes use this template

  Scenario: Override archetype for specific player
    Given I have a world with tier-based archetypes
    When I add an individual archetype for player "Patrick Mahomes"
    With enhanced stats:
      | Passing Mean | 310 yards |
      | TD Mean      | 2.8       |
    Then "Patrick Mahomes" uses the individual archetype
    And other elite QBs use the tier archetype

  # Team Strengths

  Scenario: Configure balanced team strengths
    Given I have a demo simulation world
    When I set all teams to equal strength rating of 80
    Then all 32 teams have:
      | Overall Rating    | 80   |
      | Offensive Rating  | 80   |
      | Defensive Rating  | 80   |
    And game outcomes are more unpredictable

  Scenario: Configure realistic team strengths
    Given I have a 2024 season world
    When I import team strengths from "2024 Power Rankings"
    Then each team has distinct strength ratings
    And higher-rated teams win more often

  # Environment Configuration

  Scenario: Enable injury simulation
    Given I have a simulation world
    When I enable injury simulation with:
      | Base Rate      | 5%     |
      | QB Rate        | 3%     |
      | RB Rate        | 8%     |
    Then simulated games may produce injuries
    And injured players have reduced stats

  Scenario: Disable weather effects for indoor simulation
    Given I have a simulation world
    When I disable weather simulation
    Then all games simulate as if played indoors
    And no weather-based stat modifiers apply

  # Templates and Presets

  Scenario: Publish world as template
    Given I have a validated simulation world "Pro League Config"
    When I publish it as a template with:
      | Category    | COMMUNITY      |
      | Tags        | PPR, 10-team   |
    Then the template is available to other users
    And my usage count is tracked

  Scenario: Use quick start preset
    Given the preset "10-Team PPR Quick Start" exists
    When I apply the preset
    Then a world is created with:
      | Player Count | 10          |
      | Scoring      | Full PPR    |
      | Roster       | Standard    |
    And a league is optionally created

  # Validation

  Scenario: World requires minimum configuration
    Given I have a draft simulation world
    And no player archetypes are configured
    When I try to activate the world
    Then activation fails with error "At least one default archetype required per position"

  Scenario: Validate team coverage
    Given I have a simulation world
    And only 20 teams have strength profiles
    When I validate the world
    Then validation warns "12 teams missing strength profiles"
    And missing teams will use default strength

  # Historical Data

  Scenario: Import historical season
    When I create a world from historical data:
      | Season | 2023         |
      | Weeks  | 15-18        |
    Then player archetypes reflect 2023 performance
    And team strengths reflect 2023 records
    And I can replay with different rosters
```

---

## Files to Create

### Domain Layer
- `domain/aggregate/SimulationWorld.java`
- `domain/aggregate/WorldTemplate.java`
- `domain/entity/PlayerArchetype.java`
- `domain/entity/TeamStrengthProfile.java`
- `domain/entity/ScenarioPreset.java`
- `domain/model/WorldType.java`
- `domain/model/WorldStatus.java`
- `domain/model/ArchetypeScope.java`
- `domain/model/PerformanceTier.java`
- `domain/model/StatDistribution.java`
- `domain/model/StatDistributionSet.java`
- `domain/model/DistributionType.java`
- `domain/model/EnvironmentConfig.java`
- `domain/model/WeatherType.java`
- `domain/model/ScoringProfile.java`
- `domain/model/TemplateCategory.java`
- `domain/model/ScenarioType.java`
- `domain/port/WorldRepository.java`
- `domain/port/WorldCurationService.java`
- `domain/port/HistoricalDataProvider.java`

### Application Layer
- `application/usecase/CreateWorldUseCase.java`
- `application/usecase/ConfigureWorldUseCase.java`
- `application/usecase/CloneWorldUseCase.java`
- `application/usecase/PublishTemplateUseCase.java`
- `application/usecase/ApplyPresetUseCase.java`
- `application/service/WorldCurationServiceImpl.java`
- `application/dto/SimulationWorldDTO.java`
- `application/dto/PlayerArchetypeDTO.java`
- `application/dto/TeamStrengthDTO.java`

### Infrastructure Layer
- `infrastructure/adapter/rest/WorldController.java`
- `infrastructure/adapter/rest/TemplateController.java`
- `infrastructure/adapter/rest/PresetController.java`
- `infrastructure/adapter/persistence/document/SimulationWorldDocument.java`
- `infrastructure/adapter/persistence/document/PlayerArchetypeDocument.java`
- `infrastructure/adapter/persistence/document/TeamStrengthDocument.java`
- `infrastructure/adapter/persistence/document/WorldTemplateDocument.java`
- `infrastructure/adapter/persistence/WorldRepositoryImpl.java`
- `infrastructure/adapter/persistence/mapper/WorldMapper.java`
- `infrastructure/world/DefaultPlayerArchetypes.java`
- `infrastructure/world/DefaultTeamStrengths.java`
- `infrastructure/world/OfficialWorldTemplates.java`

### Feature File
- `features/ffl-simulation-world.feature`

---

## Integration with Simulation Core

The Simulation World integrates with the Simulation Core (ANIMA-1019) as follows:

```
SimulationWorld                          SimulationCore
     │                                        │
     ├─── PlayerArchetypes ──────────────────► PlayerStatsGenerator
     │    (stat distributions)                 (generates stats)
     │                                        │
     ├─── TeamStrengthProfiles ──────────────► GameOutcomeGenerator
     │    (team ratings)                       (determines winners)
     │                                        │
     ├─── EnvironmentConfig ─────────────────► SimulationEngine
     │    (injury, weather, chaos)             (applies modifiers)
     │                                        │
     └─── ScoringProfile ────────────────────► SpelScoringEngine
          (scoring rules)                      (calculates points)
```

---

**Document Status**: Ready for Implementation
**Created**: 2025-12-29
**Ticket**: ANIMA-1031
