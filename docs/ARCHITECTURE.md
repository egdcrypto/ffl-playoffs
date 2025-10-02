# FFL Playoffs Architecture

## Table of Contents
1. [Overview](#overview)
2. [Technology Stack](#technology-stack)
3. [Hexagonal Architecture](#hexagonal-architecture)
4. [Architecture Layers](#architecture-layers)
5. [Security Architecture](#security-architecture)
6. [Domain Model](#domain-model)
7. [Configuration Immutability](#configuration-immutability)
8. [Data Flow](#data-flow)
9. [Deployment Architecture](#deployment-architecture)
10. [Design Decisions](#design-decisions)

## Overview

The FFL Playoffs application follows **Hexagonal Architecture** (also known as Ports & Adapters), a pattern that promotes:
- **Separation of concerns** between business logic and infrastructure
- **Testability** through dependency inversion
- **Flexibility** to swap out external dependencies
- **Maintainability** through clear boundaries
- **Security first** design with zero-trust architecture

### Why Hexagonal Architecture?

1. **Business Logic Independence**: Domain logic is completely independent of frameworks, databases, and external services
2. **Testability**: Core business rules can be tested without databases or HTTP servers
3. **Flexibility**: Easy to swap MongoDB for another database, or REST for GraphQL
4. **Technology Agnostic**: Framework and library choices don't impact core domain
5. **Clear Dependencies**: Dependencies always point inward toward the domain

### Game Model: Roster-Based Fantasy Football with ONE-TIME DRAFT

The FFL Playoffs application is a **roster-based fantasy football system** where league players build rosters by selecting individual NFL players across multiple positions.

**Core Game Mechanics**:
1. **Individual NFL Player Selection**: League players select specific NFL players by name (e.g., "Patrick Mahomes", "Christian McCaffrey") to fill roster positions
2. **Position-Based Roster Slots**: QB, RB, WR, TE, K, DEF, FLEX (RB/WR/TE eligible), Superflex (QB/RB/WR/TE eligible)
3. **ONE-TIME DRAFT Model**: Rosters are built ONCE before the season and PERMANENTLY LOCKED when the first NFL game starts
4. **No Ownership Model**: Multiple league players can select the same NFL player (unlimited availability)
5. **PPR Scoring**: League player's score = sum of all their selected NFL players' fantasy points

**Critical Business Rule - Roster Lock**:
- **Pre-Lock Phase (Draft Phase)**: League players can modify their rosters (add/drop NFL players) until first game starts
- **Post-Lock Phase (Season Active)**: Once first NFL game starts, rosters are PERMANENTLY LOCKED for entire season
  - NO waiver wire pickups allowed
  - NO trades between league players
  - NO lineup changes week-to-week
  - NO player replacements (even for injuries)
  - League players must compete with their locked rosters for the full duration

This is fundamentally different from a team elimination survivor pool. There is no elimination logic - all league players compete for all configured weeks, regardless of their NFL players' performance.

---

## Technology Stack

- **Language**: Java 17
- **Framework**: Spring Boot 3.x, Spring Data MongoDB
- **Database**: MongoDB 6+
- **Authentication**: Google OAuth 2.0, Personal Access Tokens (PATs)
- **Security**: Envoy Sidecar with External Authorization (ext_authz)
- **Container Orchestration**: Kubernetes
- **Proxy**: Envoy 1.28+

---

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
           │  │  │  - AddNFLPlayerToRosterUseCase             │  │
           │  │  │  - CalculateWeeklyScoresUseCase            │  │
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
              │  │  - Roster                                   │  │
              │  │  - NFLPlayer                                │  │
              │  │  - NFLTeam                                  │  │
              │  │  - LeaguePlayer                             │  │
              │  │  - User                                     │  │
              │  └─────────────────────────────────────────────┘  │
              │                                                   │
              │  ┌─────────────────────────────────────────────┐  │
              │  │  Value Objects                              │  │
              │  │  - ScoringRules                             │  │
              │  │  - PPRScoringRules                          │  │
              │  │  - FieldGoalScoringRules                    │  │
              │  │  - DefensiveScoringRules                    │  │
              │  │  - RosterConfiguration                      │  │
              │  │  - RosterSlot                               │  │
              │  │  - Position                                 │  │
              │  └─────────────────────────────────────────────┘  │
              │                                                   │
              │  ┌─────────────────────────────────────────────┐  │
              │  │  Domain Services                            │  │
              │  │  - ScoringService                           │  │
              │  │  - RosterValidator                          │  │
              │  │  - DefensiveScoringService                  │  │
              │  └─────────────────────────────────────────────┘  │
              │                                                   │
              │  ┌─────────────────────────────────────────────┐  │
              │  │  Domain Events                              │  │
              │  │  - NFLPlayerSelectedEvent                   │  │
              │  │  - RosterCompletedEvent                     │  │
              │  │  - RosterLockedEvent                        │  │
              │  │  - PlayerStatsUpdatedEvent                  │  │
              │  │  - WeekScoresCalculatedEvent                │  │
              │  └─────────────────────────────────────────────┘  │
              └───────────────────────────────────────────────────┘
```

## Architecture Layers

### 1. Domain Layer (Core)
**Location**: `ffl-playoffs-api/src/main/java/com/ffl/playoffs/domain/`

The innermost layer containing pure business logic with **zero external dependencies**.

**Components**:
- **Entities**: League, Roster, NFLPlayer, NFLTeam, LeaguePlayer, User, RosterSelection
- **Value Objects**: ScoringRules, PPRScoringRules, FieldGoalScoringRules, DefensiveScoringRules, RosterConfiguration, RosterSlot, Position
- **Domain Services**: ScoringService, RosterValidator, DefensiveScoringService
- **Domain Events**: NFLPlayerSelectedEvent, RosterCompletedEvent, RosterLockedEvent, PlayerStatsUpdatedEvent
- **Repository Interfaces (Ports)**: LeagueRepository, RosterRepository, NFLPlayerRepository, NFLTeamRepository

**Rules**:
- No framework dependencies (Spring, MongoDB annotations, etc.)
- No infrastructure concerns (databases, HTTP, external APIs)
- Pure Java domain logic
- Self-contained business rules

**Example**:
```java
// domain/model/Roster.java
public class Roster {
    private String id;
    private String leaguePlayerId;
    private RosterStatus status;
    private Instant lockTimestamp;
    private List<RosterSelection> rosterSelections;

    public void addNFLPlayer(RosterSlot slot, NFLPlayer player) {
        if (isLocked()) {
            throw new RosterLockedException("Roster is permanently locked");
        }
        if (hasNFLPlayer(player.getId())) {
            throw new DuplicatePlayerException("NFL player already in roster");
        }
        if (!slot.isEligible(player.getPosition())) {
            throw new InvalidPositionException("Player position not eligible for slot");
        }
        rosterSelections.add(new RosterSelection(slot, player));
    }

    public void lockRoster(Instant lockTime) {
        this.status = RosterStatus.LOCKED;
        this.lockTimestamp = lockTime;
    }

    public boolean isLocked() {
        return this.status == RosterStatus.LOCKED;
    }
}
```

### 2. Application Layer (Use Cases)
**Location**: `ffl-playoffs-api/src/main/java/com/ffl/playoffs/application/`

Orchestrates domain objects to fulfill use cases. Acts as the **boundary between domain and infrastructure**.

**Components**:
- **Use Cases**: CreateLeagueUseCase, AddNFLPlayerToRosterUseCase, CalculateWeeklyScoresUseCase, LockRostersUseCase
- **Application Services**: LeagueApplicationService, RosterApplicationService
- **DTOs**: Data Transfer Objects for API boundaries
- **Port Interfaces**: Define contracts for adapters

**Rules**:
- Depends only on domain layer
- Defines port interfaces that infrastructure implements
- Contains no business logic (delegates to domain)
- Manages transactions and coordinates domain objects

**Example**:
```java
// application/usecase/AddNFLPlayerToRosterUseCase.java
public class AddNFLPlayerToRosterUseCase {
    private final RosterRepository rosterRepository;
    private final NFLPlayerRepository nflPlayerRepository;
    private final RosterValidator validator;

    public RosterSelectionDTO execute(String leaguePlayerId, String rosterSlotId,
                                       String nflPlayerId) {
        Roster roster = rosterRepository.findByLeaguePlayerId(leaguePlayerId);
        NFLPlayer nflPlayer = nflPlayerRepository.findById(nflPlayerId);
        RosterSlot slot = roster.getRosterConfiguration().getSlot(rosterSlotId);

        // Domain validation via validator
        validator.validatePlayerSelection(roster, slot, nflPlayer);

        // Domain logic - roster enforces business rules
        roster.addNFLPlayer(slot, nflPlayer);

        // Save via port
        rosterRepository.save(roster);

        return RosterSelectionDTO.from(roster.getLatestSelection());
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
// infrastructure/adapter/persistence/RosterRepositoryAdapter.java
@Component
public class RosterRepositoryAdapter implements RosterRepository {
    private final RosterMongoRepository mongoRepository;
    private final RosterMapper mapper;

    @Override
    public Roster findByLeaguePlayerId(String leaguePlayerId) {
        RosterDocument document = mongoRepository.findByLeaguePlayerId(leaguePlayerId)
            .orElseThrow(() -> new RosterNotFoundException(leaguePlayerId));
        return mapper.toDomain(document);
    }

    @Override
    public void save(Roster roster) {
        RosterDocument document = mapper.toDocument(roster);
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

---

## Security Architecture

### Three-Service Pod Architecture

```
┌────────────────────────────────────────────────────────────────┐
│                        KUBERNETES POD                           │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │              Envoy Sidecar (Port 443)                    │ │
│  │         External Entry Point - Pod IP Exposed            │ │
│  │                                                           │ │
│  │  ┌─────────────────────────────────────────────────┐    │ │
│  │  │       External Authorization (ext_authz)        │    │ │
│  │  │   Calls Auth Service for ALL requests           │    │ │
│  │  └─────────────────────────────────────────────────┘    │ │
│  └──────────────────────────────────────────────────────────┘ │
│                              │                                  │
│                              │ (if authorized)                  │
│                              ▼                                  │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │       Auth Service (localhost:9191)                      │ │
│  │  - Validates Google OAuth JWT tokens                     │ │
│  │  - Validates Personal Access Tokens (PATs)               │ │
│  │  - Detects token type (pat_ prefix vs JWT)               │ │
│  │  - Returns user/service context headers                  │ │
│  └──────────────────────────────────────────────────────────┘ │
│                              │                                  │
│                              │ (validated request)              │
│                              ▼                                  │
│  ┌──────────────────────────────────────────────────────────┐ │
│  │        Main API (localhost:8080)                         │ │
│  │  - Business Logic                                         │ │
│  │  - Domain Model                                           │ │
│  │  - Receives pre-authenticated requests                   │ │
│  └──────────────────────────────────────────────────────────┘ │
│                                                                 │
└────────────────────────────────────────────────────────────────┘
```

**Network Policies**:
- Main API listens ONLY on `localhost:8080` (not externally accessible)
- Auth Service listens ONLY on `localhost:9191` (not externally accessible)
- Envoy listens on pod IP (externally accessible via Kubernetes service)
- Network policies block direct access to API and Auth Service

### Authentication Flow

#### Google OAuth Flow (Human Users)
1. User authenticates with Google Sign-In (frontend)
2. Frontend receives Google JWT token
3. Client sends request: `Authorization: Bearer <google-jwt>`
4. **Envoy** extracts token → calls **Auth Service**
5. **Auth Service** validates JWT (signature, expiration, issuer)
6. **Auth Service** queries database for user by Google ID
7. **Auth Service** returns `200 OK` with headers:
   - `X-User-Id`, `X-User-Email`, `X-User-Role`, `X-Google-Id`
8. **Envoy** checks role vs. endpoint requirements
9. **Envoy** forwards request to **Main API** with user context
10. **Main API** processes pre-authenticated request

#### PAT Flow (Service-to-Service)
1. Service sends request: `Authorization: Bearer pat_<token>`
2. **Envoy** extracts token → calls **Auth Service**
3. **Auth Service** detects `pat_` prefix
4. **Auth Service** hashes token → queries `PersonalAccessToken` table
5. **Auth Service** validates not expired, not revoked
6. **Auth Service** returns `200 OK` with headers:
   - `X-Service-Id`, `X-PAT-Scope`, `X-PAT-Id`
7. **Auth Service** updates `lastUsedAt` timestamp
8. **Envoy** checks PAT scope vs. endpoint requirements
9. **Envoy** forwards request to **Main API** with service context
10. **Main API** processes pre-authenticated service request

### Role-Based Access Control (RBAC)

**Endpoint Security Requirements** (enforced by Envoy):
- `/api/v1/superadmin/*` → Requires `SUPER_ADMIN` role OR PAT with `ADMIN` scope
- `/api/v1/admin/*` → Requires `ADMIN`/`SUPER_ADMIN` role OR PAT with `WRITE`/`ADMIN` scope
- `/api/v1/player/*` → Requires any authenticated user OR any valid PAT
- `/api/v1/public/*` → No authentication required
- `/api/v1/service/*` → Requires valid PAT only

**Resource Ownership Validation** (enforced in API business logic):
- Admins can only manage their own leagues
- Players can only modify their own rosters (before roster lock)
- Ownership checks performed in domain/application layer

---

## Domain Model

### Key Aggregates

#### 1. League Aggregate
**Root Entity**: League
**Child Entities**: Week, LeaguePlayer
**Value Objects**: RosterConfiguration, ScoringRules

**Responsibilities**:
- Enforce league lifecycle rules
- Manage week progression
- Validate league configuration (startingWeek + numberOfWeeks - 1 ≤ 22)
- Control roster lock timing
- Define roster structure (positions and counts)
- Define scoring rules (PPR, field goals, defense)

#### 2. Roster Aggregate
**Root Entity**: Roster
**Child Entities**: RosterSelection
**Value Objects**: RosterStatus (INCOMPLETE, COMPLETE, LOCKED)

**Responsibilities**:
- Manage NFL player selections
- Enforce ONE-TIME DRAFT model (roster lock after first game)
- Validate position eligibility (QB slot only accepts QB, FLEX accepts RB/WR/TE)
- Prevent duplicate NFL players in same roster
- Track roster completion status
- Calculate weekly scores from individual player stats

#### 3. NFLPlayer Aggregate
**Root Entity**: NFLPlayer
**Child Entities**: PlayerStats (game-by-game stats)
**Value Objects**: Position (QB, RB, WR, TE, K, DEF)

**Responsibilities**:
- Store individual NFL player information
- Track player position and team
- Maintain game-by-game statistics
- Support PPR scoring calculations

#### 4. NFLTeam Aggregate
**Root Entity**: NFLTeam
**Child Entities**: DefensiveStats (game-by-game defense stats), NFLGame
**Value Objects**: Conference, Division

**Responsibilities**:
- Store NFL team information (32 teams)
- Track defensive performance statistics
- Support defensive scoring calculations
- Manage game schedules

#### 5. User Aggregate
**Root Entity**: User
**Value Objects**: Role (SUPER_ADMIN, ADMIN, PLAYER), GoogleProfile

**Responsibilities**:
- Manage authentication identity
- Control role-based permissions
- Link Google OAuth identity

### Value Objects

**RosterConfiguration**: Defines league roster structure
- Immutable
- Contains list of RosterSlot objects
- Validates total roster size
- Examples: {QB: 1, RB: 2, WR: 2, TE: 1, FLEX: 1, K: 1, DEF: 1}

**RosterSlot**: Defines position requirements
- position: QB, RB, WR, TE, K, DEF, FLEX, Superflex
- count: How many of this position
- eligiblePositions: List of allowed positions (for FLEX/Superflex)

**ScoringRules**: Encapsulates all scoring configuration
- Immutable
- Contains nested value objects: PPRScoringRules, FieldGoalScoringRules, DefensiveScoringRules

**PPRScoringRules**: PPR (Points Per Reception) scoring
- Passing, rushing, receiving yards per point
- Touchdown points, interception points
- Reception points (1.0 Full PPR, 0.5 Half PPR, 0.0 Standard)

**Position**: Enum for NFL player positions
- QB, RB, WR, TE, K, DEF

### Domain Services

**ScoringService**:
- Calculates PPR scores from individual NFL player stats
- Applies field goal distance scoring for kickers
- Calculates defensive/special teams points
- Sums all roster player scores for weekly totals

**DefensiveScoringService**:
- Calculates defensive scoring with configurable tiers
- Points allowed tiers (0 pts = 10 fantasy pts, 35+ pts = -4 fantasy pts)
- Yards allowed tiers
- Sacks, interceptions, fumble recoveries, safeties, defensive TDs

**RosterValidator**:
- Validates position eligibility (QB slot only accepts QB)
- Validates FLEX eligibility (RB/WR/TE)
- Validates Superflex eligibility (QB/RB/WR/TE)
- Prevents duplicate NFL players in roster
- Enforces roster lock rules (no changes after lock)

---

## Configuration Immutability

### Business Rule: League Configuration Lock

**CRITICAL BUSINESS RULE**: ALL league configuration becomes **IMMUTABLE** once the first game of the league's starting NFL week begins.

#### Lock Mechanism

**Trigger**: `Instant.now() > league.firstGameStartTime`

**Lock Timestamp**: Set to the kickoff time of the first scheduled NFL game for `league.startingWeek`

**Validation Guard**: All configuration update methods must call:
```java
public void validateConfigurationMutable() {
    if (isConfigurationLocked()) {
        throw new ConfigurationLockedException(
            "LEAGUE_STARTED_CONFIGURATION_LOCKED",
            "Configuration cannot be changed after first game starts"
        );
    }
}
```

#### Immutable Fields After Lock

**All of the following become read-only**:
- ✅ `startingWeek`
- ✅ `numberOfWeeks`
- ✅ `name`
- ✅ `description`
- ✅ `scoringRules` (all sub-rules)
- ✅ `isPublic`
- ✅ `maxPlayers`
- ✅ Pick deadlines for all weeks

#### Configuration Lock Lifecycle

```
DRAFT → ACTIVE (Before First Game) → STARTED (First Game Kicks Off) → COMPLETED
  ↓              ↓                           ↓                           ↓
Mutable       Mutable                   IMMUTABLE                   IMMUTABLE
```

**Timeline Example**:
- **Dec 14, 9:00 AM**: Admin activates league → Status: `ACTIVE`, Locked: `false`
- **Dec 14, 3:00 PM**: Admin modifies scoring rules → ✅ Allowed
- **Dec 15, 12:59 PM**: Admin updates team name → ✅ Allowed
- **Dec 15, 1:00 PM**: First NFL game kicks off → Locked: `true`
- **Dec 15, 1:01 PM**: Admin tries to modify scoring → ❌ **REJECTED**

#### Domain Event: LeagueConfigurationLockedEvent

Triggered when `configurationLocked` changes from `false` to `true`.

**Event Payload**:
```json
{
  "leagueId": 123,
  "lockTimestamp": "2024-12-15T18:00:00Z",
  "lockReason": "FIRST_GAME_STARTED",
  "nflWeekNumber": 15,
  "firstGameStartTime": "2024-12-15T18:00:00Z"
}
```

**Event Handlers**:
1. Send notification to league admin
2. Create audit log entry
3. Update UI to show read-only configuration
4. Disable configuration editing buttons

#### Background Job: ConfigurationLockEnforcer

Runs every minute to automatically lock leagues:
```javascript
SELECT * FROM leagues
WHERE status = 'ACTIVE'
  AND configuration_locked = false
  AND first_game_start_time < NOW();
```

For each league found:
1. Set `configurationLocked = true`
2. Set `lockTimestamp = firstGameStartTime`
3. Publish `LeagueConfigurationLockedEvent`

---

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

### 2. Roster Building Flow (Add NFL Player to Roster)
```
HTTP POST /api/v1/player/leagues/{leagueId}/roster/players
      ↓
[RosterController] (Infrastructure)
      ↓ (maps to command)
[AddNFLPlayerToRosterUseCase] (Application)
      ↓ (load roster and player)
[RosterRepository.findByLeaguePlayerId()] (Port)
[NFLPlayerRepository.findById()] (Port)
      ↓
[Roster.addNFLPlayer(slot, nflPlayer)] (Domain)
      ↓
[RosterValidator] (Domain Service)
      ↓ validates:
      - Roster not locked (ONE-TIME DRAFT enforcement)
      - Position eligibility (QB slot accepts QB, FLEX accepts RB/WR/TE)
      - No duplicate NFL players in roster
      - NFL player exists and is active
      ↓
[RosterSelection] (Domain Entity) created
      ↓
[NFLPlayerSelectedEvent] emitted
      ↓
[RosterRepository.save()] (Port)
      ↓
[Database]
```

### 3. Score Calculation Flow (PPR Scoring from Individual NFL Players)
```
[Scheduled Job] triggers weekly
      ↓
[CalculateWeeklyScoresUseCase] (Application)
      ↓
[NFLDataProvider.getPlayerStats(week)] (Port)
      ↓
[NFLApiClient] (Infrastructure) - fetches individual player stats
      ↓ returns: PlayerStats (passing yards, rushing yards, receptions, TDs, etc.)
[ScoringService] (Domain Service)
      ↓ For each league player's roster:
      - Get all RosterSelections (QB, RB, WR, TE, K, DEF, FLEX, Superflex)
      - For each NFL player in roster:
          * Fetch PlayerStats for the week
          * Calculate fantasy points using PPR rules
            - Passing: yards/25 = pts, TDs = 4 pts, INTs = -2 pts
            - Rushing: yards/10 = pts, TDs = 6 pts
            - Receiving: yards/10 = pts, receptions = 1 pt (PPR), TDs = 6 pts
          * For kickers: apply field goal distance scoring
          * For defense: apply defensive scoring tiers
      - Sum all player scores → weekly roster total
      ↓
[WeeklyScore] (Domain Entity) created
      ↓
[WeekScoresCalculatedEvent] emitted
      ↓
[ScoreRepository.save()] (Port)
      ↓
[Database]
```

### 4. Roster Lock Flow (ONE-TIME DRAFT Enforcement)
```
[Scheduled Job] checks first game start time
      ↓
[LockRostersUseCase] (Application)
      ↓ When: firstGameStartTime < NOW()
[LeagueRepository.findActiveLeagues()] (Port)
      ↓
[For each league with unlocked rosters]
      ↓
[RosterRepository.findByLeagueId()] (Port)
      ↓
[Roster.lockRoster(lockTime)] (Domain)
      ↓ state change:
      - status = LOCKED
      - lockTimestamp = firstGameStartTime
      ↓
[RosterLockedEvent] emitted
      ↓
[Event Handler] sends notifications
      ↓
[NotificationService] (Port)
      ↓
[EmailService] (Infrastructure) - notify players rosters are locked
```

---

## Deployment Architecture

### Kubernetes Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ffl-playoffs-api
spec:
  replicas: 3
  template:
    spec:
      containers:
        - name: envoy-sidecar
          image: envoyproxy/envoy:v1.28
          ports:
            - containerPort: 443  # External HTTPS
          volumeMounts:
            - name: envoy-config
              mountPath: /etc/envoy

        - name: auth-service
          image: ffl-playoffs-auth:latest
          ports:
            - containerPort: 9191  # localhost only

        - name: main-api
          image: ffl-playoffs-api:latest
          ports:
            - containerPort: 8080  # localhost only
          env:
            - name: MONGODB_URI
              valueFrom:
                secretKeyRef:
                  name: mongodb-secret
                  key: uri
```

### Service Mesh Configuration

```yaml
apiVersion: v1
kind: Service
metadata:
  name: ffl-playoffs-api-service
spec:
  selector:
    app: ffl-playoffs-api
  ports:
    - name: https
      port: 443
      targetPort: 443  # Envoy sidecar
  type: LoadBalancer
```

### Network Policy

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: ffl-api-network-policy
spec:
  podSelector:
    matchLabels:
      app: ffl-playoffs-api
  policyTypes:
    - Ingress
  ingress:
    # Only allow external traffic to Envoy port 443
    - from:
        - podSelector: {}
      ports:
        - protocol: TCP
          port: 443

    # Block direct access to ports 8080 and 9191
    # (only allow from localhost within pod)
```

### Database Schema

#### leagues Collection
```javascript
{
  _id: ObjectId,
  name: String,
  description: String,
  ownerId: String,
  startingWeek: Number,  // 1-18
  numberOfWeeks: Number, // 1-17
  status: String,        // DRAFT, ACTIVE, PAUSED, COMPLETED, ARCHIVED
  isPublic: Boolean,
  maxPlayers: Number,
  scoringRules: {
    pprRules: { ... },
    fieldGoalRules: { ... },
    defensiveRules: { ... }
  },

  // Configuration Lock Fields
  configurationLocked: Boolean,
  lockTimestamp: Date,
  lockReason: String,
  firstGameStartTime: Date,

  createdAt: Date,
  updatedAt: Date
}

// Indexes
db.leagues.createIndex({ ownerId: 1 })
db.leagues.createIndex({ status: 1 })
db.leagues.createIndex({ configurationLocked: 1, firstGameStartTime: 1 })
```

#### weeks Collection
```javascript
{
  _id: ObjectId,
  leagueId: String,
  gameWeekNumber: Number,
  nflWeekNumber: Number,
  pickDeadline: Date,
  status: String,  // UPCOMING, ACTIVE, LOCKED, COMPLETED
  createdAt: Date
}

// Indexes
db.weeks.createIndex({ leagueId: 1, gameWeekNumber: 1 }, { unique: true })
db.weeks.createIndex({ nflWeekNumber: 1 })
```

---

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

Domain events (e.g., `NFLPlayerSelectedEvent`, `RosterLockedEvent`) enable:
- **Loose coupling**: Domain doesn't know about notifications or analytics
- **Extensibility**: Add new event handlers without modifying domain
- **Audit trail**: Track all significant domain changes
- **Eventual consistency**: Async processing of side effects

Example:
```java
// Domain emits event
public class Roster {
    public void addNFLPlayer(RosterSlot slot, NFLPlayer player) {
        // ... validation logic ...
        RosterSelection selection = new RosterSelection(slot, player);
        this.rosterSelections.add(selection);
        this.events.add(new NFLPlayerSelectedEvent(this.leaguePlayerId, player, slot));
    }
}

// Infrastructure handles event
@EventListener
public class RosterNotificationHandler {
    public void handle(NFLPlayerSelectedEvent event) {
        notificationService.notifyPlayer(event.getLeaguePlayerId(),
            "Added " + event.getPlayer().getName() + " to your roster");
    }
}
```

### 5. Why Aggregate Boundaries?

**League Aggregate**:
- Root: League
- Contains: Weeks, RosterConfiguration, LeaguePlayers
- Enforces: Week progression, configuration validation, roster lock timing

**Roster Aggregate**:
- Root: Roster
- Contains: RosterSelections
- Enforces: Position eligibility rules, no duplicate players, ONE-TIME DRAFT roster lock

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
public class League {
    private LocalDateTime firstGameStartTime;
    private LocalDateTime configurationLockedAt;
    private String lockReason;
    private String name;
    private LocalDateTime updatedAt;

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
void shouldAddNFLPlayerToRosterWhenPositionEligible() {
    // Pure domain logic test - no Spring, no database
    Roster roster = new Roster(leaguePlayerId, rosterConfiguration);
    RosterSlot qbSlot = rosterConfiguration.getSlot("QB");
    NFLPlayer mahomes = new NFLPlayer("Patrick", "Mahomes", Position.QB);

    roster.addNFLPlayer(qbSlot, mahomes);

    assertThat(roster.getRosterSelections()).hasSize(1);
    assertThat(roster.getRosterSelections().get(0).getNflPlayer()).isEqualTo(mahomes);
}

@Test
void shouldThrowExceptionWhenRosterIsLocked() {
    // Test ONE-TIME DRAFT enforcement
    Roster roster = new Roster(leaguePlayerId, rosterConfiguration);
    roster.lockRoster(Instant.now());

    assertThatThrownBy(() -> roster.addNFLPlayer(qbSlot, mahomes))
        .isInstanceOf(RosterLockedException.class)
        .hasMessage("Roster is permanently locked");
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
