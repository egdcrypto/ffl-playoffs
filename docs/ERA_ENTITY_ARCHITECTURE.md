# Era Entity Curation Architecture

> **ANIMA-1046**: Design and architecture for Era Entity management

## Overview

Era Entities define historical periods in NFL history, each with distinct characteristics that affect simulation behavior:

- **Rule Sets**: Different rules across eras (pass interference, roughing the passer, etc.)
- **Playing Styles**: Run-heavy vs pass-heavy offensive tendencies
- **Statistical Norms**: Era-appropriate stat distributions
- **Scoring Patterns**: Different scoring frequencies and types
- **Player Archetypes**: Era-specific player characteristics

Eras enable "what-if" simulations (e.g., "How would a 1985 Bears defense perform against modern offenses?") and historical accuracy in period simulations.

---

## Use Cases

### Primary Use Cases

1. **Define Historical Era**
   - Create era with time period boundaries
   - Configure era-specific rules and characteristics
   - Set statistical norms for the era
   - Define playing style tendencies

2. **Apply Era to Simulation**
   - Select era for simulation world
   - Apply era rules to game simulation
   - Adjust stat distributions for era
   - Modify scoring patterns

3. **Cross-Era Comparison**
   - Normalize stats across eras
   - Compare players from different eras
   - Project historical players to modern rules
   - Simulate era matchups

4. **Era Timeline Management**
   - View eras chronologically
   - Understand rule change impacts
   - Track league evolution
   - Identify era transitions

5. **Custom Era Creation**
   - Blend characteristics from multiple eras
   - Create hypothetical rule sets
   - Design alternative history scenarios
   - Build fantasy eras

---

## Domain Model

### 1. Era (Aggregate Root)

Represents a distinct period in NFL history.

**Location**: `domain/aggregate/Era.java`

```java
public class Era {

    private UUID id;
    private String name;                    // "The West Coast Era"
    private String shortName;               // "WEST_COAST"
    private String description;

    // Time boundaries
    private Integer startYear;              // 1978
    private Integer endYear;                // 1993 (null if current)
    private EraStatus status;               // HISTORICAL, CURRENT, HYPOTHETICAL

    // Defining characteristics
    private EraType type;                   // RUN_DOMINANT, BALANCED, PASS_DOMINANT
    private List<EraCharacteristic> characteristics;
    private List<RuleChange> definingRules;

    // Statistical context
    private EraStatisticalProfile statisticalProfile;
    private ScoringProfile scoringProfile;

    // Playing style
    private OffensiveStyle offensiveStyle;
    private DefensiveStyle defensiveStyle;

    // Game characteristics
    private GamePaceProfile gamePace;
    private InjuryRateProfile injuryProfile;

    // Notable elements
    private List<String> iconicTeams;
    private List<String> iconicPlayers;
    private List<String> keyInnovations;

    // Predecessor/successor
    private UUID predecessorEraId;
    private UUID successorEraId;

    // Metadata
    private EraSource source;               // OFFICIAL, CUSTOM, HYPOTHETICAL
    private LocalDateTime createdAt;
    private Long version;

    // Business methods
    public boolean isActive();
    public boolean containsYear(int year);
    public StatModifiers getStatModifiers();
    public Era transitionTo(Era nextEra, int transitionYear);
    public EraComparison compareTo(Era other);
}
```

**EraStatus Enum**:
```java
public enum EraStatus {
    HISTORICAL("Past era, no longer active"),
    CURRENT("Currently active era"),
    HYPOTHETICAL("Fictional or alternative history"),
    TRANSITIONAL("Between two defined eras");

    private final String description;
}
```

**EraType Enum**:
```java
public enum EraType {
    RUN_DOMINANT("Ground game focused", 0.60, 0.40),
    RUN_HEAVY("Strong running emphasis", 0.55, 0.45),
    BALANCED("Equal run/pass mix", 0.50, 0.50),
    PASS_HEAVY("Strong passing emphasis", 0.45, 0.55),
    PASS_DOMINANT("Air attack focused", 0.40, 0.60),
    EXTREME_PASSING("Modern pass-heavy", 0.35, 0.65);

    private final String description;
    private final double runPlayPercentage;
    private final double passPlayPercentage;
}
```

### 2. EraCharacteristic (Value Object)

Defines a notable characteristic of an era.

**Location**: `domain/model/EraCharacteristic.java`

```java
public class EraCharacteristic {

    private CharacteristicType type;
    private String name;
    private String description;
    private Double impactLevel;             // 0.0 to 1.0

    // Effect on simulation
    private Map<StatCategory, Double> statModifiers;
    private Map<String, Object> ruleOverrides;

    // Factory methods
    public static EraCharacteristic passHappyRules();
    public static EraCharacteristic physicalDefense();
    public static EraCharacteristic runFirstMentality();
    public static EraCharacteristic spreadOffense();
    public static EraCharacteristic twoTightEndSets();
}
```

**CharacteristicType Enum**:
```java
public enum CharacteristicType {
    // Offensive characteristics
    OFFENSIVE_SCHEME("Predominant offensive approach"),
    PASSING_PHILOSOPHY("Approach to passing game"),
    RUSHING_PHILOSOPHY("Approach to running game"),
    FORMATION_TENDENCY("Common formations used"),

    // Defensive characteristics
    DEFENSIVE_SCHEME("Predominant defensive approach"),
    COVERAGE_STYLE("Pass coverage philosophy"),
    PHYSICALITY_LEVEL("Allowed physical contact"),

    // Rule-driven
    RULE_BASED("Driven by specific rules"),
    EQUIPMENT_BASED("Driven by equipment/technology"),

    // Cultural
    COACHING_PHILOSOPHY("Prevailing coaching approaches"),
    PLAYER_DEVELOPMENT("How players were developed");

    private final String description;
}
```

### 3. RuleChange (Value Object)

Represents a specific rule that defines or changed an era.

**Location**: `domain/model/RuleChange.java`

```java
public class RuleChange {

    private String ruleName;
    private String description;
    private Integer yearImplemented;
    private RuleCategory category;

    // Impact on play
    private RuleImpact impact;
    private Map<StatCategory, Double> statisticalImpact;

    // Before/after
    private String previousRule;
    private String newRule;

    // Factory for notable rules
    public static RuleChange melBlountRule();       // 1978 - Can't contact receivers past 5 yards
    public static RuleChange illegalContact();      // 2004 - Emphasized illegal contact
    public static RuleChange roughingThePasser();   // 2018 - Enhanced QB protection
    public static RuleChange catchRule();           // 2018 - Simplified catch definition
    public static RuleChange hashMarkChange();      // 1972 - Narrower hash marks
    public static RuleChange twoPointConversion();  // 1994 - Added 2-point option
}
```

**RuleCategory Enum**:
```java
public enum RuleCategory {
    PASSING("Rules affecting passing game"),
    RUSHING("Rules affecting running game"),
    DEFENSE("Rules affecting defensive play"),
    SPECIAL_TEAMS("Kickoff, punt, FG rules"),
    SAFETY("Player safety rules"),
    TIMING("Clock and game timing"),
    SCORING("Scoring rules"),
    REPLAY("Instant replay rules"),
    EQUIPMENT("Equipment regulations");

    private final String description;
}
```

### 4. EraStatisticalProfile (Value Object)

Statistical norms for an era.

**Location**: `domain/model/EraStatisticalProfile.java`

```java
public class EraStatisticalProfile {

    // League averages for the era
    private Double averagePointsPerGame;
    private Double averagePassingYardsPerGame;
    private Double averageRushingYardsPerGame;
    private Double averageTotalYardsPerGame;

    // Passing norms
    private Double averageCompletionPercentage;
    private Double averageYardsPerAttempt;
    private Double averagePassingTDsPerGame;
    private Double averageInterceptionsPerGame;
    private Integer typicalPassAttemptsPerGame;

    // Rushing norms
    private Double averageYardsPerCarry;
    private Double averageRushingTDsPerGame;
    private Integer typicalRushAttemptsPerGame;

    // Receiving norms (when tracked)
    private Double averageReceptionsPerGame;
    private Double averageYardsPerReception;

    // Turnovers
    private Double averageTurnoversPerGame;
    private Double averageFumblesPerGame;

    // Individual benchmarks
    private Map<Position, PositionBenchmarks> positionBenchmarks;

    // Methods
    public StatDistribution getDistributionFor(StatCategory category);
    public Double normalizeToModern(StatCategory category, Double value);
    public Double projectFromModern(StatCategory category, Double value);
}
```

### 5. PositionBenchmarks (Value Object)

Era-specific benchmarks for a position.

**Location**: `domain/model/PositionBenchmarks.java`

```java
public class PositionBenchmarks {

    private Position position;

    // Elite thresholds (Top 5 at position)
    private Map<StatCategory, Double> eliteThresholds;

    // Pro Bowl level (Top 12)
    private Map<StatCategory, Double> proBowlThresholds;

    // Starter level (Top 32)
    private Map<StatCategory, Double> starterThresholds;

    // Season records for the era
    private Map<StatCategory, Double> eraRecords;

    // Factory for different eras
    public static PositionBenchmarks qbModern();    // ~5000 yards elite
    public static PositionBenchmarks qb1990s();     // ~4000 yards elite
    public static PositionBenchmarks qb1970s();     // ~3000 yards elite
    public static PositionBenchmarks rbModern();    // ~1500 yards elite
    public static PositionBenchmarks rb1970s();     // ~1800 yards elite (more carries)
}
```

### 6. OffensiveStyle (Value Object)

Era-specific offensive tendencies.

**Location**: `domain/model/OffensiveStyle.java`

```java
public class OffensiveStyle {

    private String name;                    // "West Coast Offense"
    private String description;

    // Play calling tendencies
    private Double runPercentage;           // 0.0 to 1.0
    private Double passPercentage;
    private Double playActionPercentage;
    private Double shotgunPercentage;

    // Pass distribution
    private Double shortPassPercentage;     // < 10 yards
    private Double mediumPassPercentage;    // 10-20 yards
    private Double deepPassPercentage;      // > 20 yards

    // Target distribution
    private Map<Position, Double> targetShares;  // WR, TE, RB shares

    // Formation tendencies
    private Map<String, Double> formationUsage;  // "11", "12", "21", etc.

    // Tempo
    private PlayTempo tempo;                // SLOW, MODERATE, FAST, HURRY_UP
    private Double noHuddlePercentage;

    // Factory for era styles
    public static OffensiveStyle groundAndPound();
    public static OffensiveStyle westCoast();
    public static OffensiveStyle airRaid();
    public static OffensiveStyle spreadOption();
    public static OffensiveStyle proCoreSet();
}
```

### 7. DefensiveStyle (Value Object)

Era-specific defensive tendencies.

**Location**: `domain/model/DefensiveStyle.java`

```java
public class DefensiveStyle {

    private String name;                    // "46 Defense"
    private String description;

    // Base alignment
    private DefensiveAlignment baseAlignment;  // 4-3, 3-4, NICKEL, DIME

    // Coverage tendencies
    private Double manCoveragePercentage;
    private Double zoneCoveragePercentage;
    private Double blitzPercentage;

    // Physicality
    private PhysicalityLevel physicality;   // FINESSE, BALANCED, PHYSICAL, AGGRESSIVE
    private Double penaltyRate;             // Era-appropriate penalty frequency

    // Pass rush style
    private PassRushStyle passRush;         // CONTAIN, AGGRESSIVE, EXOTIC_BLITZ
    private Double sackRate;                // Era-typical sack rate

    // Run defense
    private RunDefenseStyle runDefense;     // STACK_BOX, BALANCED, LIGHT_BOX

    // Factory for era defenses
    public static DefensiveStyle steelCurtain();
    public static DefensiveStyle chicago46();
    public static DefensiveStyle tampa2();
    public static DefensiveStyle seattleLOB();
}
```

### 8. GamePaceProfile (Value Object)

Era-specific game tempo and flow.

**Location**: `domain/model/GamePaceProfile.java`

```java
public class GamePaceProfile {

    // Plays per game
    private Integer averagePlaysPerGame;    // Total snaps
    private Integer averagePassPlays;
    private Integer averageRunPlays;

    // Time of possession
    private Duration averagePossessionTime;
    private Duration averagePlayClockUsage;

    // Game duration
    private Duration averageGameLength;
    private Double overtimeProbability;

    // Scoring
    private Double averageScoresPerGame;
    private Double averageDrivesPerGame;
    private Double averageDriveSuccessRate;

    // Field position
    private Integer averageStartingFieldPosition;
    private Double threeAndOutRate;
    private Double redZoneConversionRate;

    // Methods
    public Integer generatePlaysForGame(Random random);
    public Duration generatePossessionTime(Random random);
}
```

---

## Predefined NFL Eras

### Historical Era Definitions

```java
public class NFLEras {

    /**
     * Pre-Modern Era (1920-1945)
     * - Leather helmets, minimal passing
     * - Single-wing and T-formation
     * - Limited forward passing
     */
    public static Era preModern() {
        return Era.builder()
            .name("Pre-Modern Era")
            .shortName("PRE_MODERN")
            .startYear(1920)
            .endYear(1945)
            .type(EraType.RUN_DOMINANT)
            .statisticalProfile(EraStatisticalProfile.builder()
                .averagePointsPerGame(15.0)
                .averagePassingYardsPerGame(100.0)
                .averageRushingYardsPerGame(150.0)
                .averageCompletionPercentage(0.40)
                .typicalPassAttemptsPerGame(15)
                .build())
            .offensiveStyle(OffensiveStyle.groundAndPound())
            .build();
    }

    /**
     * Post-War Era (1946-1969)
     * - Introduction of T-formation dominance
     * - Beginning of modern passing
     * - AFL-NFL competition
     */
    public static Era postWar() {
        return Era.builder()
            .name("Post-War Era")
            .shortName("POST_WAR")
            .startYear(1946)
            .endYear(1969)
            .type(EraType.RUN_HEAVY)
            .statisticalProfile(EraStatisticalProfile.builder()
                .averagePointsPerGame(22.0)
                .averagePassingYardsPerGame(180.0)
                .averageRushingYardsPerGame(140.0)
                .averageCompletionPercentage(0.50)
                .typicalPassAttemptsPerGame(25)
                .build())
            .build();
    }

    /**
     * Steel Curtain Era (1970-1977)
     * - Dominant defenses
     * - Run-first offenses
     * - Physical, low-scoring games
     */
    public static Era steelCurtain() {
        return Era.builder()
            .name("Steel Curtain Era")
            .shortName("STEEL_CURTAIN")
            .startYear(1970)
            .endYear(1977)
            .type(EraType.RUN_HEAVY)
            .statisticalProfile(EraStatisticalProfile.builder()
                .averagePointsPerGame(18.5)
                .averagePassingYardsPerGame(160.0)
                .averageRushingYardsPerGame(145.0)
                .averageCompletionPercentage(0.52)
                .averageInterceptionsPerGame(1.8)
                .typicalPassAttemptsPerGame(24)
                .build())
            .definingRules(List.of(
                RuleChange.hashMarkChange()
            ))
            .iconicTeams(List.of("Pittsburgh Steelers", "Miami Dolphins", "Dallas Cowboys"))
            .iconicPlayers(List.of("Terry Bradshaw", "Franco Harris", "Mean Joe Greene"))
            .build();
    }

    /**
     * Passing Revolution Era (1978-1993)
     * - Mel Blount Rule opens passing game
     * - West Coast offense emergence
     * - More balanced offenses
     */
    public static Era passingRevolution() {
        return Era.builder()
            .name("Passing Revolution Era")
            .shortName("PASSING_REV")
            .startYear(1978)
            .endYear(1993)
            .type(EraType.BALANCED)
            .definingRules(List.of(
                RuleChange.melBlountRule()
            ))
            .statisticalProfile(EraStatisticalProfile.builder()
                .averagePointsPerGame(21.0)
                .averagePassingYardsPerGame(210.0)
                .averageRushingYardsPerGame(125.0)
                .averageCompletionPercentage(0.55)
                .averageInterceptionsPerGame(1.5)
                .typicalPassAttemptsPerGame(30)
                .build())
            .offensiveStyle(OffensiveStyle.westCoast())
            .characteristics(List.of(
                EraCharacteristic.passHappyRules(),
                EraCharacteristic.of("West Coast Revolution", "Short passing game emphasis")
            ))
            .iconicTeams(List.of("San Francisco 49ers", "Washington Redskins", "Chicago Bears"))
            .iconicPlayers(List.of("Joe Montana", "Jerry Rice", "Walter Payton", "Lawrence Taylor"))
            .build();
    }

    /**
     * Free Agency Era (1994-2003)
     * - Salary cap introduced
     * - Increased parity
     * - Spread offense beginnings
     */
    public static Era freeAgency() {
        return Era.builder()
            .name("Free Agency Era")
            .shortName("FREE_AGENCY")
            .startYear(1994)
            .endYear(2003)
            .type(EraType.BALANCED)
            .definingRules(List.of(
                RuleChange.twoPointConversion(),
                RuleChange.of("Salary Cap", 1994, "Hard salary cap introduced")
            ))
            .statisticalProfile(EraStatisticalProfile.builder()
                .averagePointsPerGame(21.5)
                .averagePassingYardsPerGame(215.0)
                .averageRushingYardsPerGame(115.0)
                .averageCompletionPercentage(0.58)
                .typicalPassAttemptsPerGame(32)
                .build())
            .iconicTeams(List.of("Dallas Cowboys", "Green Bay Packers", "Denver Broncos"))
            .iconicPlayers(List.of("Brett Favre", "Emmitt Smith", "Deion Sanders", "Barry Sanders"))
            .build();
    }

    /**
     * Quarterback Protection Era (2004-2017)
     * - Illegal contact emphasis
     * - Increased passing
     * - Fantasy football boom
     */
    public static Era qbProtection() {
        return Era.builder()
            .name("Quarterback Protection Era")
            .shortName("QB_PROTECTION")
            .startYear(2004)
            .endYear(2017)
            .type(EraType.PASS_HEAVY)
            .definingRules(List.of(
                RuleChange.illegalContact(),
                RuleChange.of("Defenseless Receiver", 2009, "Protection for receivers")
            ))
            .statisticalProfile(EraStatisticalProfile.builder()
                .averagePointsPerGame(22.5)
                .averagePassingYardsPerGame(235.0)
                .averageRushingYardsPerGame(115.0)
                .averageCompletionPercentage(0.62)
                .averageInterceptionsPerGame(1.0)
                .typicalPassAttemptsPerGame(35)
                .build())
            .characteristics(List.of(
                EraCharacteristic.of("Fantasy Era", "Individual stats tracking emphasis"),
                EraCharacteristic.of("QB Safety", "Enhanced quarterback protection")
            ))
            .iconicTeams(List.of("New England Patriots", "Indianapolis Colts", "Seattle Seahawks"))
            .iconicPlayers(List.of("Tom Brady", "Peyton Manning", "Drew Brees", "Aaron Rodgers"))
            .build();
    }

    /**
     * Modern Passing Era (2018-Present)
     * - Roughing the passer expansion
     * - RPO dominance
     * - Record passing numbers
     */
    public static Era modernPassing() {
        return Era.builder()
            .name("Modern Passing Era")
            .shortName("MODERN")
            .startYear(2018)
            .endYear(null)  // Current
            .status(EraStatus.CURRENT)
            .type(EraType.PASS_DOMINANT)
            .definingRules(List.of(
                RuleChange.roughingThePasser(),
                RuleChange.catchRule()
            ))
            .statisticalProfile(EraStatisticalProfile.builder()
                .averagePointsPerGame(23.5)
                .averagePassingYardsPerGame(250.0)
                .averageRushingYardsPerGame(115.0)
                .averageCompletionPercentage(0.65)
                .averageInterceptionsPerGame(0.9)
                .typicalPassAttemptsPerGame(36)
                .build())
            .offensiveStyle(OffensiveStyle.builder()
                .name("Spread RPO")
                .runPercentage(0.40)
                .passPercentage(0.60)
                .shotgunPercentage(0.70)
                .noHuddlePercentage(0.25)
                .build())
            .characteristics(List.of(
                EraCharacteristic.spreadOffense(),
                EraCharacteristic.of("Analytics Revolution", "Data-driven decision making"),
                EraCharacteristic.of("Mobile QB Value", "Running QBs highly valued")
            ))
            .iconicTeams(List.of("Kansas City Chiefs", "Buffalo Bills", "San Francisco 49ers"))
            .iconicPlayers(List.of("Patrick Mahomes", "Josh Allen", "Travis Kelce", "Tyreek Hill"))
            .build();
    }

    /**
     * Returns all official NFL eras in chronological order.
     */
    public static List<Era> allEras() {
        return List.of(
            preModern(),
            postWar(),
            steelCurtain(),
            passingRevolution(),
            freeAgency(),
            qbProtection(),
            modernPassing()
        );
    }
}
```

---

## Era Application Service

### EraApplicationService (Domain Service)

Applies era characteristics to simulation.

**Location**: `domain/service/EraApplicationService.java`

```java
public class EraApplicationService {

    /**
     * Gets stat distribution adjusted for era.
     */
    public StatDistributionSet getEraAdjustedDistributions(
        Era era,
        Position position,
        PerformanceTier tier
    ) {
        // Get base distribution from Simulation World
        StatDistributionSet base = getBaseDistributions(position, tier);

        // Adjust for era statistical norms
        EraStatisticalProfile profile = era.getStatisticalProfile();

        return base.adjust(eraModifiers -> {
            // Example: If era has lower passing yards, reduce QB passing
            if (position == Position.QB) {
                double eraPassingFactor = profile.getAveragePassingYardsPerGame() / 250.0; // Modern baseline
                eraModifiers.put(StatCategory.PASSING_YARDS, eraPassingFactor);
                eraModifiers.put(StatCategory.PASSING_TOUCHDOWNS, eraPassingFactor * 0.9);
            }
            // Adjust rushing for era
            double eraRushingFactor = profile.getAverageRushingYardsPerGame() / 115.0;
            if (position == Position.RB) {
                eraModifiers.put(StatCategory.RUSHING_YARDS, eraRushingFactor);
            }
        });
    }

    /**
     * Adjusts scoring rules for era.
     */
    public ScoringRules getEraAdjustedScoringRules(Era era, ScoringRules base) {
        // Historical eras might not have had certain bonuses
        if (era.getEndYear() != null && era.getEndYear() < 1994) {
            // No two-point conversions before 1994
            return base.without(ScoringCategory.TWO_POINT_CONVERSION);
        }
        return base;
    }

    /**
     * Gets play distribution for era.
     */
    public PlayDistribution getPlayDistribution(Era era) {
        OffensiveStyle style = era.getOffensiveStyle();
        return PlayDistribution.builder()
            .runPercentage(style.getRunPercentage())
            .passPercentage(style.getPassPercentage())
            .playActionRate(style.getPlayActionPercentage())
            .build();
    }
}
```

### EraNormalizationService (Domain Service)

Normalizes stats across eras for comparison.

**Location**: `domain/service/EraNormalizationService.java`

```java
public class EraNormalizationService {

    /**
     * Normalizes a stat from one era to another.
     * Useful for comparing players across eras.
     */
    public Double normalize(
        Double value,
        StatCategory category,
        Era sourceEra,
        Era targetEra
    ) {
        EraStatisticalProfile source = sourceEra.getStatisticalProfile();
        EraStatisticalProfile target = targetEra.getStatisticalProfile();

        // Get era averages for the category
        Double sourceAvg = source.getAverage(category);
        Double targetAvg = target.getAverage(category);

        if (sourceAvg == 0) return value;

        // Calculate z-score in source era
        Double sourceStdDev = source.getStandardDeviation(category);
        Double zScore = (value - sourceAvg) / sourceStdDev;

        // Apply to target era
        Double targetStdDev = target.getStandardDeviation(category);
        return targetAvg + (zScore * targetStdDev);
    }

    /**
     * Projects a historical player to modern era.
     */
    public Map<StatCategory, Double> projectToModern(
        Map<StatCategory, Double> historicalStats,
        Era historicalEra
    ) {
        Era modernEra = NFLEras.modernPassing();
        Map<StatCategory, Double> projected = new HashMap<>();

        for (Map.Entry<StatCategory, Double> entry : historicalStats.entrySet()) {
            Double normalized = normalize(
                entry.getValue(),
                entry.getKey(),
                historicalEra,
                modernEra
            );
            projected.put(entry.getKey(), normalized);
        }

        return projected;
    }
}
```

---

## Port Interfaces

### EraRepository

**Location**: `domain/port/EraRepository.java`

```java
public interface EraRepository {

    // Era CRUD
    Era save(Era era);
    Optional<Era> findById(UUID id);
    Optional<Era> findByShortName(String shortName);
    List<Era> findAll();

    // Queries
    Optional<Era> findByYear(Integer year);
    Era findCurrentEra();
    List<Era> findByType(EraType type);
    List<Era> findByStatus(EraStatus status);

    // Timeline
    List<Era> findAllChronological();
    Optional<Era> findPredecessor(UUID eraId);
    Optional<Era> findSuccessor(UUID eraId);

    // Rule changes
    List<RuleChange> findRuleChangesInEra(UUID eraId);
    List<RuleChange> findRuleChangesByCategory(RuleCategory category);
}
```

### EraComparisonService

**Location**: `domain/port/EraComparisonService.java`

```java
public interface EraComparisonService {

    /**
     * Compares two eras and returns differences.
     */
    EraComparison compare(Era era1, Era era2);

    /**
     * Gets the impact of transitioning between eras.
     */
    EraTransitionImpact getTransitionImpact(Era from, Era to);

    /**
     * Projects a player's stats to a different era.
     */
    Map<StatCategory, Double> projectStats(
        Map<StatCategory, Double> stats,
        Era sourceEra,
        Era targetEra
    );
}
```

---

## Integration with Other Systems

### Simulation World Integration

Era determines base statistical profiles:

```java
@Component
public class EraAwareWorldConfiguration {

    private final EraApplicationService eraService;

    public List<PlayerArchetype> generateArchetypes(SimulationWorld world, Era era) {
        List<PlayerArchetype> archetypes = new ArrayList<>();

        for (Position position : Position.values()) {
            for (PerformanceTier tier : PerformanceTier.values()) {
                StatDistributionSet eraDistributions =
                    eraService.getEraAdjustedDistributions(era, position, tier);

                archetypes.add(PlayerArchetype.builder()
                    .position(position)
                    .tier(tier)
                    .statDistributions(eraDistributions)
                    .build());
            }
        }

        return archetypes;
    }
}
```

### Narrative Integration

Era context enriches narratives:

```java
@Component
public class EraNarrativeEnricher {

    public NarrativeText enrichWithEraContext(
        NarrativeEvent event,
        Era era
    ) {
        String template = getTemplateForEra(event.getType(), era);

        // Era-specific language
        // "In the hard-nosed Steel Curtain Era, 200 passing yards was elite"
        // vs "In today's pass-happy NFL, 200 yards is pedestrian"

        return NarrativeText.builder()
            .headline(event.getHeadline())
            .fullText(renderTemplate(template, event, era))
            .eraContext(era.getName())
            .build();
    }
}
```

---

## API Endpoints

### Era Endpoints

```
GET    /api/v1/eras
       List all eras chronologically

GET    /api/v1/eras/{id}
       Get era details

GET    /api/v1/eras/current
       Get current era

GET    /api/v1/eras/year/{year}
       Get era for specific year

GET    /api/v1/eras/{id}/rules
       Get rule changes for era

GET    /api/v1/eras/{id}/statistics
       Get statistical profile for era
```

### Comparison Endpoints

```
GET    /api/v1/eras/compare?era1={id}&era2={id}
       Compare two eras

POST   /api/v1/eras/normalize
       Normalize stats between eras

POST   /api/v1/eras/project
       Project stats to different era
```

---

## MongoDB Collections

### eras Collection

```javascript
{
  _id: UUID,
  name: String,
  shortName: String,
  description: String,

  startYear: Number,
  endYear: Number,                        // null if current
  status: String,                         // HISTORICAL, CURRENT, HYPOTHETICAL

  type: String,                           // RUN_DOMINANT, BALANCED, PASS_DOMINANT

  statisticalProfile: {
    averagePointsPerGame: Double,
    averagePassingYardsPerGame: Double,
    averageRushingYardsPerGame: Double,
    averageCompletionPercentage: Double,
    averageInterceptionsPerGame: Double,
    typicalPassAttemptsPerGame: Number,
    typicalRushAttemptsPerGame: Number,
    positionBenchmarks: Object
  },

  offensiveStyle: {
    name: String,
    runPercentage: Double,
    passPercentage: Double,
    playActionPercentage: Double,
    shotgunPercentage: Double,
    tempo: String
  },

  defensiveStyle: {
    name: String,
    baseAlignment: String,
    manCoveragePercentage: Double,
    blitzPercentage: Double,
    physicality: String
  },

  characteristics: [{
    type: String,
    name: String,
    description: String,
    impactLevel: Double,
    statModifiers: Object
  }],

  definingRules: [{
    ruleName: String,
    description: String,
    yearImplemented: Number,
    category: String,
    impact: String
  }],

  iconicTeams: [String],
  iconicPlayers: [String],
  keyInnovations: [String],

  predecessorEraId: UUID,
  successorEraId: UUID,
  source: String,
  createdAt: ISODate,
  version: Long
}

// Indexes
db.eras.createIndex({ shortName: 1 }, { unique: true })
db.eras.createIndex({ startYear: 1, endYear: 1 })
db.eras.createIndex({ status: 1 })
db.eras.createIndex({ type: 1 })
```

---

## Feature File

**Location**: `features/ffl-era-entities.feature`

```gherkin
Feature: Era Entity Curation
  As a simulation administrator
  I want to define historical NFL eras
  So that simulations can reflect period-accurate characteristics

  Background:
    Given NFL era data is loaded

  # Era Queries

  Scenario: Get current NFL era
    When I request the current era
    Then I receive era "Modern Passing Era"
    And start year is 2018
    And end year is null
    And type is "PASS_DOMINANT"

  Scenario: Get era for specific year
    When I query era for year 1985
    Then I receive era "Passing Revolution Era"
    And the era spans 1978-1993

  Scenario: List all eras chronologically
    When I request all eras
    Then I receive eras in order:
      | Pre-Modern Era            | 1920-1945 |
      | Post-War Era              | 1946-1969 |
      | Steel Curtain Era         | 1970-1977 |
      | Passing Revolution Era    | 1978-1993 |
      | Free Agency Era           | 1994-2003 |
      | QB Protection Era         | 2004-2017 |
      | Modern Passing Era        | 2018-     |

  # Era Characteristics

  Scenario: Era affects statistical norms
    Given I select era "Steel Curtain Era"
    When I check statistical profile
    Then average points per game is ~18.5
    And average passing yards is ~160
    And average interceptions is ~1.8 per game

  Scenario: Modern era has higher passing stats
    Given I compare eras "Steel Curtain Era" and "Modern Passing Era"
    Then passing yards difference is ~90 per game
    And completion percentage difference is ~13%
    And interceptions decreased by ~50%

  Scenario: Era defines playing style
    Given I select era "Steel Curtain Era"
    When I check offensive style
    Then run percentage is ~55%
    And pass percentage is ~45%
    And type is "RUN_HEAVY"

  # Era-Based Simulation

  Scenario: Apply era to simulation world
    Given a simulation world exists
    When I apply era "Passing Revolution Era"
    Then player archetypes reflect era norms
    And QB passing distributions are adjusted
    And RB rushing distributions are adjusted

  Scenario: Era affects scoring expectations
    Given a simulation uses "Modern Passing Era"
    When I generate expected fantasy scores
    Then QB expected points are higher
    And RB rushing TDs reflect modern rates

  # Cross-Era Comparison

  Scenario: Normalize stats between eras
    Given a player with 3000 passing yards in 1975
    When I normalize to Modern Era
    Then equivalent modern value is ~4500 yards
    And era context is explained

  Scenario: Project historical player to modern era
    Given Joe Montana's 1989 stats:
      | Passing Yards | 3521  |
      | TDs           | 26    |
      | INTs          | 8     |
    When I project to Modern Passing Era
    Then projected passing yards is ~4800
    And projected TDs is ~38
    And analysis explains adjustments

  # Rule Changes

  Scenario: Era includes defining rules
    Given I query era "QB Protection Era"
    Then defining rules include:
      | Illegal Contact Rule     | 2004 |
      | Defenseless Receiver     | 2009 |
    And rules explain passing increase

  Scenario: Rule change impacts statistics
    Given the Mel Blount Rule in 1978
    When I compare pre and post rule stats
    Then passing yards increased ~25%
    And completion percentage increased ~5%

  # Custom Eras

  Scenario: Create hypothetical era
    When I create a custom era:
      | Name       | Ground and Pound 2.0     |
      | Type       | RUN_DOMINANT             |
      | Rules      | Reduced passing emphasis |
    Then a hypothetical era is created
    And it can be applied to simulations
    And status is "HYPOTHETICAL"
```

---

## Files to Create

### Domain Layer
- `domain/aggregate/Era.java`
- `domain/model/EraStatus.java`
- `domain/model/EraType.java`
- `domain/model/EraCharacteristic.java`
- `domain/model/CharacteristicType.java`
- `domain/model/RuleChange.java`
- `domain/model/RuleCategory.java`
- `domain/model/EraStatisticalProfile.java`
- `domain/model/PositionBenchmarks.java`
- `domain/model/OffensiveStyle.java`
- `domain/model/DefensiveStyle.java`
- `domain/model/GamePaceProfile.java`
- `domain/model/EraComparison.java`
- `domain/service/EraApplicationService.java`
- `domain/service/EraNormalizationService.java`
- `domain/port/EraRepository.java`
- `domain/port/EraComparisonService.java`

### Application Layer
- `application/usecase/GetEraUseCase.java`
- `application/usecase/ApplyEraUseCase.java`
- `application/usecase/CompareErasUseCase.java`
- `application/usecase/NormalizeStatsUseCase.java`
- `application/service/EraAwareWorldConfiguration.java`
- `application/service/EraNarrativeEnricher.java`
- `application/dto/EraDTO.java`
- `application/dto/EraComparisonDTO.java`

### Infrastructure Layer
- `infrastructure/adapter/rest/EraController.java`
- `infrastructure/adapter/persistence/document/EraDocument.java`
- `infrastructure/adapter/persistence/EraRepositoryImpl.java`
- `infrastructure/era/NFLEras.java`
- `infrastructure/era/NFLRuleChanges.java`
- `infrastructure/era/DefaultEraComparisonService.java`

### Feature File
- `features/ffl-era-entities.feature`

---

## Implementation Priority

### Phase 1: Core Era Model
1. Era aggregate and repository
2. EraStatisticalProfile value object
3. Predefined NFL eras data
4. Basic CRUD operations

### Phase 2: Statistical Adjustments
1. EraApplicationService
2. Era-adjusted stat distributions
3. Position benchmarks by era
4. Integration with Simulation World

### Phase 3: Normalization & Comparison
1. EraNormalizationService
2. Cross-era stat projection
3. Era comparison functionality
4. API endpoints

### Phase 4: Integration
1. Narrative era context
2. Rule change tracking
3. Custom era creation
4. Historical player projection

---

**Document Status**: Ready for Implementation
**Created**: 2025-12-29
**Ticket**: ANIMA-1046
