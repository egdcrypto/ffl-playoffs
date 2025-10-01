# FFL Playoffs Architecture

> **This document is under active development** as we complete the transition to the roster-based fantasy football model. See [DATA_MODEL.md](DATA_MODEL.md) for complete entity documentation.

## Table of Contents
1. [Overview](#overview)
2. [Hexagonal Architecture](#hexagonal-architecture)
3. [Architecture Layers](#architecture-layers)
4. [Dependency Rules](#dependency-rules)
5. [Ports and Adapters](#ports-and-adapters)
6. [Domain Model](#domain-model)
7. [Data Flow](#data-flow)
8. [Design Decisions](#design-decisions)

## Overview

The FFL Playoffs application follows **Hexagonal Architecture** (also known as Ports & Adapters), a pattern that promotes:
- **Separation of concerns** between business logic and infrastructure
- **Testability** through dependency inversion
- **Flexibility** to swap out external dependencies
- **Maintainability** through clear boundaries

### Why Hexagonal Architecture?

1. **Business Logic Independence**: Domain logic is completely independent of frameworks, databases, and external services
2. **Testability**: Core business rules can be tested without databases or HTTP servers
3. **Flexibility**: Easy to swap MongoDB for another database, or REST for GraphQL
4. **Technology Agnostic**: Framework and library choices don't impact core domain
5. **Clear Dependencies**: Dependencies always point inward toward the domain

## Hexagonal Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Infrastructure Layer                      │
│  ┌────────────────┐  ┌────────────────┐  ┌──────────────────┐  │
│  │  REST API      │  │  Persistence   │  │  External Data   │  │
│  │  Controllers   │  │  Repositories  │  │  Integrations    │  │
│  │  (Adapters)    │  │  (Adapters)    │  │  (Adapters)      │  │
│  └───────┬────────┘  └────────┬───────┘  └──────────┬───────┘  │
│          │                    │                      │           │
└──────────┼────────────────────┼──────────────────────┼───────────┘
           │                    │                      │
           │  ┌─────────────────▼──────────────────────▼────────┐
           │  │          Application Layer (Ports)               │
           │  │  ┌────────────────────────────────────────────┐  │
           │  │  │  Use Cases / Application Services          │  │
           │  │  │  - CreateLeagueUseCase                     │  │
           │  │  │  - MakeTeamSelectionUseCase                │  │
           │  │  │  - CalculateScoreUseCase                   │  │
           │  │  │  - InvitePlayerUseCase                     │  │
           │  │  └────────────────────────────────────────────┘  │
           │  │                                                   │
           │  │  ┌────────────────────────────────────────────┐  │
           │  │  │  Port Interfaces (Inbound & Outbound)      │  │
           │  │  │  - LeagueRepository (outbound)             │  │
           │  │  │  - NFLDataProvider (outbound)              │  │
           │  │  │  - NotificationService (outbound)          │  │
           │  │  └────────────────────────────────────────────┘  │
           │  └───────────────────────────────────────────────────┘
           │                         │
           │  ┌──────────────────────▼───────────────────────────┐
           └──►             Domain Layer (Core)                   │
              │  ┌─────────────────────────────────────────────┐  │
              │  │  Domain Model (Aggregates & Entities)       │  │
              │  │  - League                                   │  │
              │  │  - Player                                   │  │
              │  │  - TeamSelection                            │  │
              │  │  - Score                                    │  │
              │  │  - User                                     │  │
              │  └─────────────────────────────────────────────┘  │
              │                                                   │
              │  ┌─────────────────────────────────────────────┐  │
              │  │  Value Objects                              │  │
              │  │  - ScoringRules                             │  │
              │  │  - FieldGoalScoringRules                    │  │
              │  │  - DefensiveScoringRules                    │  │
              │  │  - Week                                     │  │
              │  └─────────────────────────────────────────────┘  │
              │                                                   │
              │  ┌─────────────────────────────────────────────┐  │
              │  │  Domain Services                            │  │
              │  │  - EliminationService                       │  │
              │  │  - ScoringService                           │  │
              │  │  - TeamSelectionValidator                   │  │
              │  └─────────────────────────────────────────────┘  │
              │                                                   │
              │  ┌─────────────────────────────────────────────┐  │
              │  │  Domain Events                              │  │
              │  │  - TeamEliminatedEvent                      │  │
              │  │  - TeamSelectedEvent                        │  │
              │  │  - ScoreCalculatedEvent                     │  │
              │  └─────────────────────────────────────────────┘  │
              └───────────────────────────────────────────────────┘
```

## Architecture Layers

### 1. Domain Layer (Core)
**Location**: `ffl-playoffs-api/src/main/java/com/ffl/playoffs/domain/`

The innermost layer containing pure business logic with **zero external dependencies**.

**Components**:
- **Entities**: League, Player, User, TeamSelection, Score
- **Value Objects**: ScoringRules, Week, NFLTeam
- **Domain Services**: EliminationService, ScoringService
- **Domain Events**: TeamEliminatedEvent, ScoreCalculatedEvent
- **Repository Interfaces (Ports)**: LeagueRepository, PlayerRepository, ScoreRepository

**Rules**:
- No framework dependencies (Spring, MongoDB annotations, etc.)
- No infrastructure concerns (databases, HTTP, external APIs)
- Pure Java domain logic
- Self-contained business rules

**Example**:
```java
// domain/model/TeamSelection.java
public class TeamSelection {
    private Long playerId;
    private NFLTeam team;
    private Week week;
    private boolean eliminated;
    private Week eliminatedInWeek;

    public void eliminate(Week week) {
        if (this.eliminated) {
            throw new TeamAlreadyEliminatedException();
        }
        this.eliminated = true;
        this.eliminatedInWeek = week;
    }

    public boolean canScorePoints() {
        return !this.eliminated;
    }
}
```

### 2. Application Layer (Use Cases)
**Location**: `ffl-playoffs-api/src/main/java/com/ffl/playoffs/application/`

Orchestrates domain objects to fulfill use cases. Acts as the **boundary between domain and infrastructure**.

**Components**:
- **Use Cases**: CreateLeagueUseCase, MakeTeamSelectionUseCase, CalculateScoreUseCase
- **Application Services**: LeagueApplicationService, PlayerApplicationService
- **DTOs**: Data Transfer Objects for API boundaries
- **Port Interfaces**: Define contracts for adapters

**Rules**:
- Depends only on domain layer
- Defines port interfaces that infrastructure implements
- Contains no business logic (delegates to domain)
- Manages transactions and coordinates domain objects

**Example**:
```java
// application/usecase/MakeTeamSelectionUseCase.java
public class MakeTeamSelectionUseCase {
    private final LeagueRepository leagueRepository;
    private final TeamSelectionValidator validator;

    public TeamSelectionDTO execute(Long playerId, Long leagueId,
                                     String teamName, int weekNumber) {
        League league = leagueRepository.findById(leagueId);
        Player player = league.getPlayer(playerId);

        // Domain validation
        validator.validateSelection(player, teamName, weekNumber);

        // Domain logic
        TeamSelection selection = player.selectTeam(teamName, weekNumber);

        // Save via port
        leagueRepository.save(league);

        return TeamSelectionDTO.from(selection);
    }
}
```

### 3. Infrastructure Layer (Adapters)
**Location**: `ffl-playoffs-api/src/main/java/com/ffl/playoffs/infrastructure/`

Implements the port interfaces and handles all external concerns.

**Components**:
- **REST Adapters**: Spring controllers exposing HTTP endpoints
- **Persistence Adapters**: Spring Data MongoDB repositories, document entities
- **Integration Adapters**: NFL data API clients, notification services
- **Configuration**: Spring configuration, security, Envoy integration

**Rules**:
- Implements port interfaces from application layer
- Depends on both application and domain layers
- Handles all framework-specific code
- Translates between domain models and external formats

**Directory Structure**:
```
infrastructure/
├── adapter/
│   ├── rest/              # HTTP/REST controllers
│   │   ├── LeagueController.java
│   │   ├── PlayerController.java
│   │   └── AuthController.java
│   ├── persistence/        # Database implementations
│   │   ├── mongodb/
│   │   │   ├── LeagueMongoRepository.java
│   │   │   └── documents/
│   │   │       ├── LeagueDocument.java
│   │   │       └── PlayerDocument.java
│   │   └── LeagueRepositoryAdapter.java
│   └── integration/        # External service clients
│       ├── NFLDataApiClient.java
│       └── EmailNotificationService.java
└── config/                 # Spring configuration
    ├── SecurityConfig.java
    └── MongoConfig.java
```

**Example**:
```java
// infrastructure/adapter/persistence/LeagueRepositoryAdapter.java
@Component
public class LeagueRepositoryAdapter implements LeagueRepository {
    private final LeagueMongoRepository mongoRepository;
    private final LeagueMapper mapper;

    @Override
    public League findById(String id) {
        LeagueDocument document = mongoRepository.findById(id)
            .orElseThrow(() -> new LeagueNotFoundException(id));
        return mapper.toDomain(document);
    }

    @Override
    public void save(League league) {
        LeagueDocument document = mapper.toDocument(league);
        mongoRepository.save(document);
    }
}
```

## Dependency Rules

### The Dependency Rule
**Dependencies point INWARD**: Infrastructure → Application → Domain

```
┌───────────────────────────────────────┐
│       Infrastructure Layer             │
│         (Frameworks, DB, Web)          │
│              depends on ↓              │
├───────────────────────────────────────┤
│       Application Layer                │
│        (Use Cases, Ports)              │
│              depends on ↓              │
├───────────────────────────────────────┤
│         Domain Layer                   │
│      (Business Logic - PURE)           │
│         NO DEPENDENCIES ←              │
└───────────────────────────────────────┘
```

### Allowed Dependencies
✅ Infrastructure → Application
✅ Infrastructure → Domain
✅ Application → Domain

### Forbidden Dependencies
❌ Domain → Application
❌ Domain → Infrastructure
❌ Application → Infrastructure

### Dependency Inversion
Instead of Application depending on Infrastructure, we use **Ports and Adapters**:

```java
// Application Layer defines the PORT (interface)
public interface LeagueRepository {  // Port
    League findById(Long id);
    void save(League league);
}

// Infrastructure Layer implements the ADAPTER
@Component
public class LeagueRepositoryAdapter implements LeagueRepository {
    // MongoDB implementation
}

// Application uses the PORT, not the concrete implementation
public class CreateLeagueUseCase {
    private final LeagueRepository repository;  // Depends on abstraction

    public CreateLeagueUseCase(LeagueRepository repository) {
        this.repository = repository;
    }
}
```

## Ports and Adapters

### Inbound Ports (Driving Side)
Entry points to the application - what the application **provides**.

**Examples**:
- REST API Controllers
- CLI Commands
- GraphQL Resolvers
- Message Queue Consumers

```java
// Inbound Port (Use Case interface)
public interface CreateLeagueUseCase {
    LeagueDTO execute(CreateLeagueCommand command);
}

// Inbound Adapter (REST Controller)
@RestController
@RequestMapping("/api/v1/admin/leagues")
public class LeagueController {
    private final CreateLeagueUseCase createLeagueUseCase;

    @PostMapping
    public ResponseEntity<LeagueDTO> createLeague(@RequestBody CreateLeagueRequest request) {
        CreateLeagueCommand command = mapper.toCommand(request);
        LeagueDTO league = createLeagueUseCase.execute(command);
        return ResponseEntity.ok(league);
    }
}
```

### Outbound Ports (Driven Side)
Dependencies the application **requires** from the outside world.

**Examples**:
- Database repositories
- External API clients
- Email/notification services
- File storage services

```java
// Outbound Port (Interface)
public interface NFLDataProvider {
    List<GameResult> getWeekResults(int nflWeek);
    TeamStatistics getTeamStats(String teamName, int week);
}

// Outbound Adapter (Implementation)
@Component
public class NFLApiClient implements NFLDataProvider {
    private final RestTemplate restTemplate;

    @Override
    public List<GameResult> getWeekResults(int nflWeek) {
        // Call external NFL API
        return restTemplate.getForObject(
            "https://api.nfl.com/v1/weeks/" + nflWeek,
            GameResultList.class
        );
    }
}
```

## Domain Model

### Key Aggregates

#### 1. League Aggregate
**Root Entity**: League
**Child Entities**: Week, LeagueConfiguration, LeaguePlayer

**Responsibilities**:
- Enforce league lifecycle rules
- Manage week progression
- Validate league configuration (startingWeek + numberOfWeeks ≤ 18)
- Control player membership

#### 2. Player Aggregate
**Root Entity**: Player
**Child Entities**: TeamSelection, Score

**Responsibilities**:
- Manage team selections
- Enforce selection constraints (no duplicate teams)
- Track eliminated teams
- Calculate player scores

#### 3. User Aggregate
**Root Entity**: User
**Value Objects**: Role (SUPER_ADMIN, ADMIN, PLAYER), GoogleProfile

**Responsibilities**:
- Manage authentication identity
- Control role-based permissions
- Link Google OAuth identity

### Value Objects

**ScoringRules**: Encapsulates all scoring configuration
- Immutable
- Contains nested value objects: FieldGoalScoringRules, DefensiveScoringRules

**Week**: Represents both league week and NFL week mapping
- Maps league week to NFL week based on startingWeek

### Domain Services

**EliminationService**:
- Determines when teams are eliminated
- Applies elimination logic across player selections
- Emits TeamEliminatedEvent

**ScoringService**:
- Calculates PPR scores based on ScoringRules
- Applies field goal distance scoring
- Calculates defensive/special teams points
- Handles elimination override (eliminated teams = 0 points)

## Data Flow

### 1. Create League Flow
```
HTTP POST /api/v1/admin/leagues
      ↓
[REST Controller] (Infrastructure)
      ↓ (maps to Command)
[CreateLeagueUseCase] (Application)
      ↓ (validates and creates)
[League] (Domain) - business rules
      ↓ (save via port)
[LeagueRepository] (Port - Application)
      ↓ (implementation)
[LeagueRepositoryAdapter] (Infrastructure)
      ↓ (MongoDB save)
[MongoDB Database]
```

### 2. Team Selection Flow
```
HTTP POST /api/v1/player/selections
      ↓
[TeamSelectionController] (Infrastructure)
      ↓
[MakeTeamSelectionUseCase] (Application)
      ↓
[League.addPlayerSelection()] (Domain)
      ↓
[TeamSelectionValidator] (Domain Service)
      ↓ validates:
      - Player belongs to league
      - Team not already selected
      - Week not locked
      - Selection deadline not passed
      ↓
[TeamSelection] (Domain Entity) created
      ↓
[TeamSelectedEvent] emitted
      ↓
[LeagueRepository.save()] (Port)
      ↓
[Database]
```

### 3. Score Calculation Flow
```
[Scheduled Job] triggers weekly
      ↓
[CalculateScoresUseCase] (Application)
      ↓
[NFLDataProvider.getWeekResults()] (Port)
      ↓
[NFLApiClient] (Infrastructure) - fetches game results
      ↓
[ScoringService] (Domain Service)
      ↓ For each player:
      - Check if team is eliminated
      - If eliminated → score = 0
      - If active → calculate PPR score
      ↓
[Score] (Domain Entity) created
      ↓
[ScoreCalculatedEvent] emitted
      ↓
[ScoreRepository.save()] (Port)
      ↓
[Database]
```

### 4. Team Elimination Flow
```
[Game Result Processing]
      ↓
[EliminationService] (Domain Service)
      ↓ checks game outcome
      - WIN or TIE → no elimination
      - LOSS → eliminate team
      ↓
[TeamSelection.eliminate(week)] (Domain)
      ↓ state change:
      - eliminated = true
      - eliminatedInWeek = current week
      ↓
[TeamEliminatedEvent] emitted
      ↓
[Event Handler] sends notification
      ↓
[NotificationService] (Port)
      ↓
[EmailService] (Infrastructure)
```

## Design Decisions

### 1. Why Hexagonal Architecture?

**Problem**: Traditional layered architecture tightly couples business logic to frameworks and databases, making testing difficult and changes costly.

**Solution**: Hexagonal architecture isolates business logic in the domain layer, making it:
- **Framework-independent**: Can switch from Spring to Micronaut without touching domain
- **Database-independent**: Can swap MongoDB for another database
- **Testable**: Test business logic without Spring context or databases
- **UI-independent**: Support REST, GraphQL, or CLI with same core

### 2. Why Separate Domain and Persistence Models?

**Domain Model** (e.g., `League.java`):
- Pure business logic
- No MongoDB annotations
- Rich behavior
- Encapsulates invariants

**Persistence Model** (e.g., `LeagueEntity.java` or `LeagueDocument.java`):
- MongoDB-annotated
- Database-focused
- Anemic (getters/setters)
- Optimized for queries

**Mapping Layer** (e.g., `LeagueMapper.java`):
- Translates between models
- Prevents database concerns from leaking into domain

**Trade-off**: More code (mapper) vs. cleaner separation and flexibility

### 3. Why Port Interfaces in Application Layer?

**Alternative**: Infrastructure could directly implement interfaces defined in domain.

**Chosen Approach**: Application layer defines port interfaces.

**Rationale**:
- Application layer knows what it needs from infrastructure
- Domain remains completely agnostic to external world
- Application services orchestrate ports
- Clear separation: domain = business rules, application = use case orchestration

### 4. Why Domain Events?

Domain events (e.g., `TeamEliminatedEvent`) enable:
- **Loose coupling**: Domain doesn't know about notifications or analytics
- **Extensibility**: Add new event handlers without modifying domain
- **Audit trail**: Track all significant domain changes
- **Eventual consistency**: Async processing of side effects

Example:
```java
// Domain emits event
public class TeamSelection {
    public void eliminate(Week week) {
        this.eliminated = true;
        this.events.add(new TeamEliminatedEvent(this.playerId, this.team, week));
    }
}

// Infrastructure handles event
@EventListener
public class TeamEliminationNotificationHandler {
    public void handle(TeamEliminatedEvent event) {
        notificationService.notifyPlayer(event.getPlayerId(),
            "Your team " + event.getTeam() + " has been eliminated");
    }
}
```

### 5. Why Aggregate Boundaries?

**League Aggregate**:
- Root: League
- Contains: Weeks, Configuration, LeaguePlayers
- Enforces: Week progression, configuration validation

**Player Aggregate**:
- Root: Player
- Contains: TeamSelections, Scores
- Enforces: Selection rules, elimination logic

**Rationale**:
- **Consistency boundary**: All changes go through aggregate root
- **Transaction boundary**: Save entire aggregate in one transaction
- **Invariant enforcement**: Aggregate root guards business rules
- **Clear ownership**: Each entity belongs to exactly one aggregate

### 6. Why Value Objects for Scoring Rules?

```java
public class ScoringRules {
    private final int passingYardsPerPoint;
    private final int rushingYardsPerPoint;
    private final FieldGoalScoringRules fieldGoalRules;
    private final DefensiveScoringRules defensiveRules;

    // Immutable, no setters
}
```

**Benefits**:
- **Immutability**: Cannot be changed after creation
- **Self-validation**: Constructor enforces valid state
- **Type safety**: Can't confuse with other integers
- **Encapsulation**: Scoring logic lives with scoring data
- **Testability**: Easy to create test fixtures

### 7. Why Configuration Immutability After Game Starts?

**Problem**: Allowing configuration changes mid-game creates unfairness and data integrity issues:
- Players made decisions based on original scoring rules
- Changing rules retrospectively invalidates past calculations
- Altering duration affects strategy and team selection
- Inconsistent scoring if rules change between weeks

**Solution**: Make ALL league configuration immutable once the first NFL game of the starting week begins.

**Implementation**:
```java
public class Game {
    private LocalDateTime firstGameStartTime;
    private LocalDateTime configurationLockedAt;
    private String lockReason;

    public boolean isConfigurationLocked(LocalDateTime currentTime) {
        if (configurationLockedAt != null) {
            return true;
        }
        return firstGameStartTime != null && currentTime.isAfter(firstGameStartTime);
    }

    public void validateConfigurationMutable(LocalDateTime currentTime) {
        if (isConfigurationLocked(currentTime)) {
            throw new ConfigurationLockedException(
                "Configuration cannot be modified after the first game has started"
            );
        }
    }

    public void setName(String name, LocalDateTime currentTime) {
        validateConfigurationMutable(currentTime);  // Enforces immutability
        this.name = name;
        this.updatedAt = LocalDateTime.now();
    }
}
```

**Design Decisions**:

1. **Lock Trigger**: First NFL game start time (not league activation)
   - **Rationale**: Admin needs time to finalize configuration after activation
   - **Window**: Configuration mutable between activation and first game kickoff
   - **Example**: League activated Monday, first game Sunday 1PM → admin has days to adjust

2. **Lock Scope**: ALL configuration settings
   - **Rationale**: Partial immutability creates confusion about what can change
   - **Included**: Name, description, scoring rules, duration, deadlines, privacy, max players
   - **Excluded**: None - everything is locked

3. **Lock Enforcement**: Domain model layer
   - **Rationale**: Business rule belongs in domain, not infrastructure
   - **Pattern**: Each setter accepts `currentTime` parameter and validates
   - **Exception**: `ConfigurationLockedException` prevents unauthorized changes

4. **Lock Tracking**:
   - `configurationLockedAt`: Timestamp when lock occurred
   - `lockReason`: Why lock happened (e.g., "FIRST_GAME_STARTED")
   - `firstGameStartTime`: When first NFL game of starting week begins

**Benefits**:
- ✅ **Fairness**: All players compete under same rules throughout game
- ✅ **Data Integrity**: Scores remain consistent with original configuration
- ✅ **Predictability**: Players know rules won't change mid-game
- ✅ **Audit Trail**: Lock timestamp and reason tracked for transparency
- ✅ **Strategy Preservation**: Player decisions remain valid throughout game

**Trade-offs**:
- ❌ Cannot fix configuration mistakes after first game starts
- ❌ Admin must be diligent before activation
- ✅ Mitigated by: Warning UI, preview mode, configuration clone from previous leagues

**Audit Logging**:
```java
@EventListener
public class ConfigurationModificationAuditListener {
    public void onConfigurationLockedException(ConfigurationLockedException ex) {
        auditLog.record(
            action: "CONFIG_MODIFICATION_REJECTED",
            adminId: SecurityContext.getAdminId(),
            leagueId: leagueId,
            reason: "LEAGUE_STARTED",
            attemptedChange: ex.getAttemptedChange(),
            timestamp: LocalDateTime.now()
        );
    }
}
```

### 8. Why Envoy Sidecar Pattern?

See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed explanation.

**Summary**:
- **Security**: All authentication/authorization at proxy layer
- **Separation of concerns**: API focuses on business logic
- **Flexibility**: Change auth strategy without touching API code
- **Zero-trust**: API never exposed directly, always through Envoy

## Testing Strategy

### Domain Layer Tests
```java
@Test
void shouldEliminateTeamWhenItLoses() {
    // Pure domain logic test - no Spring, no database
    TeamSelection selection = new TeamSelection(playerId, nflTeam, week);

    selection.eliminate(week);

    assertThat(selection.isEliminated()).isTrue();
    assertThat(selection.canScorePoints()).isFalse();
}
```

### Application Layer Tests
```java
@Test
void shouldCreateLeagueWithValidConfiguration() {
    // Mock ports, test orchestration
    LeagueRepository mockRepo = mock(LeagueRepository.class);
    CreateLeagueUseCase useCase = new CreateLeagueUseCase(mockRepo);

    LeagueDTO league = useCase.execute(command);

    verify(mockRepo).save(any(League.class));
}
```

### Infrastructure Layer Tests
```java
@SpringBootTest
@Testcontainers
class LeagueRepositoryAdapterTest {
    // Integration test with real database
    @Test
    void shouldPersistLeagueAndRetrieveIt() {
        League league = new League(...);
        adapter.save(league);

        League retrieved = adapter.findById(league.getId());

        assertThat(retrieved).isEqualTo(league);
    }
}
```

## Summary

Hexagonal Architecture in FFL Playoffs provides:
- ✅ **Clean separation** between business logic and technical concerns
- ✅ **Testable** domain logic without infrastructure dependencies
- ✅ **Flexible** infrastructure swapping without touching core
- ✅ **Maintainable** codebase with clear boundaries and responsibilities
- ✅ **Scalable** design that grows with complexity

**Next Steps**:
- See [DATA_MODEL.md](DATA_MODEL.md) for entity relationships and schemas
- See [API.md](API.md) for endpoint documentation
- See [DEPLOYMENT.md](DEPLOYMENT.md) for Envoy sidecar architecture
- See [DEVELOPMENT.md](DEVELOPMENT.md) for local development setup
