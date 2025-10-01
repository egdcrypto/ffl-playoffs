# FFL Playoffs Game - Architecture Documentation

## Table of Contents
1. [Architecture Overview](#architecture-overview)
2. [Hexagonal Architecture](#hexagonal-architecture)
3. [Security Architecture](#security-architecture)
4. [Domain Model](#domain-model)
5. [Configuration Immutability](#configuration-immutability)
6. [Data Flow](#data-flow)
7. [Deployment Architecture](#deployment-architecture)

---

## Architecture Overview

The FFL Playoffs Game follows **Hexagonal Architecture** (Ports & Adapters) principles, ensuring:
- Clear separation of concerns
- Business logic independence from infrastructure
- Testability and maintainability
- Flexibility to swap implementations

### Technology Stack
- **Language**: Java (Spring Boot)
- **Framework**: Spring Boot, Spring Data JPA
- **Database**: PostgreSQL
- **Authentication**: Google OAuth 2.0, Personal Access Tokens (PATs)
- **Security**: Envoy Sidecar with External Authorization (ext_authz)
- **Container Orchestration**: Kubernetes
- **Proxy**: Envoy

---

## Hexagonal Architecture

### Layer Structure

```
┌─────────────────────────────────────────────────────────────┐
│                     INFRASTRUCTURE LAYER                     │
│  REST Controllers │ Envoy Integration │ Database Adapters   │
│  NFL Data Adapters │ Email Service │ Scheduled Jobs        │
└─────────────────────────────────────────────────────────────┘
                              ▲
                              │ (Ports)
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     APPLICATION LAYER                        │
│  Use Cases │ DTOs │ Application Services │ Event Handlers   │
└─────────────────────────────────────────────────────────────┘
                              ▲
                              │
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                       DOMAIN LAYER                           │
│  Aggregates │ Entities │ Value Objects │ Domain Logic       │
│  League │ Player │ PlayerRoster │ Score │ Week │ NFLPlayer  │
│  Repository Interfaces (Ports) │ Domain Events              │
└─────────────────────────────────────────────────────────────┘
```

### Domain Layer

**Aggregates**:
- `League` - Root aggregate for game/league management
- `User` - User account with roles (SUPER_ADMIN, ADMIN, PLAYER)
- `PlayerRoster` - Player's roster with individual NFL players
- `NFLPlayer` - Individual NFL player data (QB, RB, WR, TE, K, DEF)
- `Week` - Game week with NFL week mapping

**Value Objects**:
- `ScoringRules` - Composite of all scoring configurations
- `PPRScoringRules` - Points per reception scoring
- `FieldGoalScoringRules` - Distance-based field goal points
- `DefensiveScoringRules` - Defensive play scoring + tiers

**Domain Events**:
- `LeagueActivatedEvent`
- `LeagueConfigurationLockedEvent` 🆕
- `RosterLockedEvent` 🆕
- `PlayerDraftedEvent` 🆕
- `WeekCompletedEvent`
- `ScoresCalculatedEvent`

**Repository Interfaces (Ports)**:
- `LeagueRepository`
- `UserRepository`
- `PlayerRosterRepository`
- `NFLPlayerRepository`
- `WeekRepository`
- `GameResultRepository`

### Application Layer

**Use Cases**:
- `CreateLeagueUseCase`
- `ActivateLeagueUseCase`
- `UpdateLeagueConfigurationUseCase` 🆕 (validates configuration lock)
- `DraftPlayerUseCase` 🆕 (draft individual NFL player to roster)
- `BuildRosterUseCase` 🆕 (complete roster building)
- `CalculateScoresUseCase`
- `InvitePlayerUseCase`

**Application Services**:
- `LeagueApplicationService` - Orchestrates league operations
- `RosterApplicationService` - Manages roster building and player drafting
- `ScoringApplicationService` - Calculates scores
- `UserManagementApplicationService` - User and invitation management

### Infrastructure Layer

**Adapters (Outbound)**:
- `PostgresLeagueRepository` implements `LeagueRepository`
- `NFLDataAPIAdapter` - Fetches NFL schedules and statistics
- `EmailServiceAdapter` - Sends notifications
- `GoogleOAuthAdapter` - Validates Google JWT tokens

**Controllers (Inbound)**:
- `SuperAdminController` - `/api/v1/superadmin/*`
- `AdminController` - `/api/v1/admin/*`
- `PlayerController` - `/api/v1/player/*`
- `PublicController` - `/api/v1/public/*`

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

### Core Entities

#### League Aggregate
```java
class League {
    Long id;
    String name;
    String description;
    Long ownerId;  // Admin who created the league
    Integer startingWeek;  // 1-18
    Integer numberOfWeeks; // 1-17
    LeagueStatus status;   // DRAFT, ACTIVE, PAUSED, COMPLETED, ARCHIVED

    // Scoring Configuration
    ScoringRules scoringRules;

    // Settings
    Boolean isPublic;
    Integer maxPlayers;

    // 🆕 Configuration Lock
    Boolean configurationLocked;
    Instant lockTimestamp;
    LockReason lockReason;
    Instant firstGameStartTime; // from NFL schedule
}
```

#### Week Entity
```java
class Week {
    Long id;
    Long leagueId;
    Integer gameWeekNumber;    // 1, 2, 3, 4 (within league)
    Integer nflWeekNumber;     // 15, 16, 17, 18 (actual NFL week)
    Instant pickDeadline;
    WeekStatus status;         // UPCOMING, ACTIVE, LOCKED, COMPLETED
}
```

#### PlayerRoster Entity
```java
class PlayerRoster {
    Long id;
    Long playerId;
    Long leagueId;
    Boolean isLocked;
    Instant lockedAt;
    List<RosterSlot> rosterSlots; // QB, RB, WR, TE, K, DEF, FLEX, SUPERFLEX
}

class RosterSlot {
    Long id;
    Long rosterId;
    Position position; // QB, RB, WR, TE, K, DEF, FLEX, SUPERFLEX
    Long nflPlayerId;
    String nflPlayerName;
    String nflTeam;
}
```

#### Score Entity
```java
class Score {
    Long id;
    Long playerId;
    Long leagueId;
    Long weekId;
    Integer nflWeekNumber;

    // Offensive
    Double passingYardsPoints;
    Double rushingYardsPoints;
    Double receivingYardsPoints;
    Double receptionPoints;
    Double touchdownPoints;

    // Kicking
    Double fieldGoalPoints;
    Double extraPointPoints;

    // Defensive
    Double sackPoints;
    Double interceptionPoints;
    Double fumbleRecoveryPoints;
    Double defensiveTDPoints;
    Double pointsAllowedTierPoints;
    Double yardsAllowedTierPoints;

    Double totalPoints;
}
```

### Value Objects

#### ScoringRules
```java
class ScoringRules {
    PPRScoringRules pprRules;
    FieldGoalScoringRules fieldGoalRules;
    DefensiveScoringRules defensiveRules;
}
```

#### DefensiveScoringRules
```java
class DefensiveScoringRules {
    Integer sackPoints;
    Integer interceptionPoints;
    Integer fumbleRecoveryPoints;
    Integer safetyPoints;
    Integer defensiveTDPoints;

    // Configurable Tiers
    Map<String, Integer> pointsAllowedTiers;  // "0" -> 10, "1-6" -> 7, etc.
    Map<String, Integer> yardsAllowedTiers;   // "0-99" -> 10, "100-199" -> 7, etc.
}
```

---

## Configuration Immutability

### Business Rule: League Configuration Lock

**🆕 CRITICAL BUSINESS RULE**: ALL league configuration becomes **IMMUTABLE** once the first game of the league's starting NFL week begins.

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
```sql
SELECT * FROM leagues
WHERE status = 'ACTIVE'
  AND configuration_locked = false
  AND first_game_start_time < NOW();
```

For each league found:
1. Set `configurationLocked = true`
2. Set `lockTimestamp = firstGameStartTime`
3. Publish `LeagueConfigurationLockedEvent`

#### Audit Logging

**All configuration change attempts logged**:

**Before Lock**:
```json
{
  "action": "CONFIG_UPDATED",
  "field": "scoringRules.pprRules.receptionPoints",
  "oldValue": 1,
  "newValue": 1.5,
  "adminId": 123,
  "leagueId": 456,
  "timestamp": "2024-12-15T10:00:00Z",
  "status": "SUCCESS"
}
```

**After Lock**:
```json
{
  "action": "CONFIG_UPDATE_REJECTED",
  "field": "scoringRules.pprRules.receptionPoints",
  "attemptedNewValue": 1.5,
  "adminId": 123,
  "leagueId": 456,
  "timestamp": "2024-12-15T14:00:00Z",
  "status": "REJECTED",
  "reason": "LEAGUE_STARTED_CONFIGURATION_LOCKED",
  "lockTimestamp": "2024-12-15T13:00:00Z"
}
```

---

## Data Flow

### League Configuration Update Flow

```
Admin (UI) → REST Controller → Application Service → Domain Model
                                                           │
                                                           ▼
                                      [validateConfigurationMutable()]
                                                           │
                                 ┌─────────────────────────┴──────────────────────┐
                                 │                                                 │
                          Locked = false                                    Locked = true
                                 │                                                 │
                                 ▼                                                 ▼
                          Update Allowed                        throw ConfigurationLockedException
                                 │                                                 │
                                 ▼                                                 ▼
                        Save to Repository                            HTTP 400/409 Error
                                 │                                                 │
                                 ▼                                                 ▼
                        Publish DomainEvent                           Audit Log Entry
```

### NFL Data Integration Flow

```
[Scheduled Job] → NFL Data API Adapter → Fetch Schedule/Stats
                         │
                         ▼
                  Process Game Results
                         │
                         ├─→ Update GameResult entities
                         ├─→ Calculate Scores
                         ├─→ Apply Elimination Rules
                         └─→ Update Leaderboard
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
            - name: DATABASE_URL
              valueFrom:
                secretKeyRef:
                  name: postgres-secret
                  key: url
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

---

## Database Schema

### Key Tables

#### leagues
```sql
CREATE TABLE leagues (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    owner_id BIGINT NOT NULL,
    starting_week INTEGER NOT NULL CHECK (starting_week BETWEEN 1 AND 18),
    number_of_weeks INTEGER NOT NULL CHECK (number_of_weeks BETWEEN 1 AND 17),
    status VARCHAR(50) NOT NULL,
    is_public BOOLEAN DEFAULT false,
    max_players INTEGER,
    scoring_rules JSONB NOT NULL,

    -- 🆕 Configuration Lock Fields
    configuration_locked BOOLEAN DEFAULT false,
    lock_timestamp TIMESTAMPTZ,
    lock_reason VARCHAR(50),
    first_game_start_time TIMESTAMPTZ,

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_leagues_owner ON leagues(owner_id);
CREATE INDEX idx_leagues_status ON leagues(status);
CREATE INDEX idx_leagues_config_lock ON leagues(configuration_locked, first_game_start_time);
```

#### weeks
```sql
CREATE TABLE weeks (
    id BIGSERIAL PRIMARY KEY,
    league_id BIGINT NOT NULL REFERENCES leagues(id),
    game_week_number INTEGER NOT NULL,
    nfl_week_number INTEGER NOT NULL,
    pick_deadline TIMESTAMPTZ NOT NULL,
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX idx_weeks_league_game_week ON weeks(league_id, game_week_number);
CREATE INDEX idx_weeks_nfl_week ON weeks(nfl_week_number);
```

---

## Summary

**Key Architectural Principles**:
1. ✅ **Hexagonal Architecture**: Clean separation of concerns
2. ✅ **Security First**: Envoy-based authentication/authorization
3. ✅ **Domain-Driven Design**: Rich domain model with business logic
4. ✅ **Configuration Immutability**: 🆕 Locked after first game starts
5. ✅ **Event-Driven**: Domain events for cross-cutting concerns
6. ✅ **Scalable**: Stateless API, horizontal scaling
7. ✅ **Auditable**: Comprehensive logging and audit trails
