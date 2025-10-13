# FFL Playoffs Domain Model

## Overview
This document describes the domain model for the FFL Playoffs fantasy football application, based on the comprehensive Gherkin feature files.

## Aggregates

### 1. User Aggregate
**Root Entity**: User

**Properties**:
- `id`: String (UUID)
- `email`: String (unique)
- `name`: String
- `googleId`: String (unique, from Google OAuth)
- `role`: Enum (SUPER_ADMIN, ADMIN, PLAYER)
- `createdAt`: Timestamp
- `updatedAt`: Timestamp

**Business Rules**:
- SUPER_ADMIN cannot be created through invitation (bootstrapped only)
- SUPER_ADMIN can invite ADMIN users
- ADMIN can invite PLAYER users to their leagues
- Users can upgrade roles (PLAYER → ADMIN)
- Users maintain their googleId for authentication

**Related Entities**:
- AdminInvitation (for admin creation)
- PersonalAccessToken (for super admin PAT management)

---

### 2. League Aggregate
**Root Entity**: League

**Properties**:
- `id`: String (UUID)
- `name`: String
- `description`: String
- `ownerId`: String (reference to ADMIN user)
- `status`: Enum (DRAFT, ACTIVE, INACTIVE, COMPLETED)
- `startingWeek`: Integer (1-22, which NFL week to start)
- `numberOfWeeks`: Integer (1-17, how many weeks to run)
- `maxPlayers`: Integer
- `privacy`: Enum (PUBLIC, PRIVATE)
- `rosterLockDeadline`: Timestamp
- `isConfigurationLocked`: Boolean
- `lockReason`: String (e.g., "FIRST_GAME_STARTED")
- `lockTimestamp`: Timestamp
- `rosterConfiguration`: RosterConfiguration (embedded)
- `scoringRules`: ScoringRules (embedded)
- `createdAt`: Timestamp
- `updatedAt`: Timestamp

**Business Rules**:
- Validation: `startingWeek + numberOfWeeks - 1 ≤ 22`
- Configuration becomes IMMUTABLE when first NFL game of starting week begins
- Only league owner can modify league (before lock)
- Roster lock deadline must be before first game starts
- At least 1 roster position required

**Value Objects**:
- RosterConfiguration
- ScoringRules (contains PPRScoringRules, FieldGoalScoringRules, DefensiveScoringRules)

**Entities**:
- Week (league weeks mapped to NFL weeks)
- LeaguePlayer (junction for league membership)

---

### 3. Roster Aggregate
**Root Entity**: Roster

**Properties**:
- `id`: String (UUID)
- `leaguePlayerId`: String (reference to LeaguePlayer)
- `status`: Enum (INCOMPLETE, COMPLETE, LOCKED, LOCKED_INCOMPLETE)
- `lockTimestamp`: Timestamp
- `rosterSelections`: List<RosterSelection>

**Business Rules**:
- ONE-TIME DRAFT model - roster locked once first game starts
- After lock, NO changes allowed for entire season
- Must fill all positions before validation passes
- Cannot select same NFL player twice in roster
- Position eligibility validated (e.g., QB slot only accepts QB)

**Entities**:
- RosterSelection (links RosterSlot to NFLPlayer)

---

### 4. NFLPlayer Aggregate
**Root Entity**: NFLPlayer

**Properties**:
- `id`: String (UUID)
- `firstName`: String
- `lastName`: String
- `position`: Enum (QB, RB, WR, TE, K, DEF)
- `nflTeamId`: String (reference to NFLTeam)
- `jerseyNumber`: Integer
- `status`: Enum (ACTIVE, INJURED, INACTIVE)

**Business Rules**:
- Multiple league players can select same NFL player
- NFL players are NOT drafted - unlimited availability
- Position determines eligible roster slots

**Entities**:
- PlayerStats (game-by-game performance)

---

### 5. NFLTeam Aggregate
**Root Entity**: NFLTeam

**Properties**:
- `id`: String (UUID)
- `name`: String (e.g., "Kansas City Chiefs")
- `abbreviation`: String (e.g., "KC")
- `conference`: Enum (AFC, NFC)
- `division`: Enum (NORTH, SOUTH, EAST, WEST)

**Entities**:
- DefensiveStats (team defense performance)
- NFLGame (scheduled games)

---

## Value Objects

### RosterConfiguration
**Properties**:
- `positions`: List<RosterSlot>
- `totalSize`: Integer (calculated)

**RosterSlot Properties**:
- `position`: Enum (QB, RB, WR, TE, K, DEF, FLEX, Superflex)
- `count`: Integer (how many of this position)
- `eligiblePositions`: List<Position> (for FLEX/Superflex)

**Examples**:
- QB slot: position=QB, count=1, eligiblePositions=[QB]
- FLEX slot: position=FLEX, count=1, eligiblePositions=[RB, WR, TE]
- Superflex slot: position=Superflex, count=1, eligiblePositions=[QB, RB, WR, TE]

---

### ScoringRules
**Properties**:
- `pprRules`: PPRScoringRules
- `fieldGoalRules`: FieldGoalScoringRules
- `defensiveRules`: DefensiveScoringRules

#### PPRScoringRules
- `passingYardsPerPoint`: Double (default: 25)
- `passingTDPoints`: Integer (default: 4)
- `interceptionPoints`: Integer (default: -2)
- `rushingYardsPerPoint`: Double (default: 10)
- `rushingTDPoints`: Integer (default: 6)
- `receivingYardsPerPoint`: Double (default: 10)
- `receptionPoints`: Double (default: 1.0 for Full PPR, 0.5 for Half, 0 for Standard)
- `receivingTDPoints`: Integer (default: 6)
- `fumbleLostPoints`: Integer (default: -2)
- `twoPointConversionPoints`: Integer (default: 2)

#### FieldGoalScoringRules
- `fg0to39Points`: Integer (default: 3)
- `fg40to49Points`: Integer (default: 4)
- `fg50PlusPoints`: Integer (default: 5)
- Custom ranges can be configured by admin

#### DefensiveScoringRules
- `sackPoints`: Integer (default: 1)
- `interceptionPoints`: Integer (default: 2)
- `fumbleRecoveryPoints`: Integer (default: 2)
- `safetyPoints`: Integer (default: 2)
- `defensiveTDPoints`: Integer (default: 6)
- `pointsAllowedTiers`: List<ScoringTier>
- `yardsAllowedTiers`: List<ScoringTier>

**ScoringTier Properties**:
- `min`: Integer (inclusive)
- `max`: Integer (inclusive, or null for open-ended)
- `points`: Integer (can be negative)

---

## Entities (Non-Root)

### LeaguePlayer
**Properties**:
- `id`: String (UUID)
- `userId`: String (reference to User)
- `leagueId`: String (reference to League)
- `joinedAt`: Timestamp
- `rosterStatus`: Enum (NOT_STARTED, IN_PROGRESS, COMPLETE, LOCKED)

**Business Rules**:
- Junction table for league membership
- Players can be members of multiple leagues
- Each league membership is independent

---

### Week
**Properties**:
- `id`: String (UUID)
- `leagueId`: String (reference to League)
- `leagueWeekNumber`: Integer (1, 2, 3, ...)
- `nflWeekNumber`: Integer (actual NFL week: 1-22)
- `status`: Enum (UPCOMING, IN_PROGRESS, COMPLETED)
- `pickDeadline`: Timestamp

**Business Rules**:
- Dynamically created based on league.startingWeek and league.numberOfWeeks
- League Week N maps to NFL Week (startingWeek + N - 1)
- Example: startingWeek=15, numberOfWeeks=4 → weeks 15, 16, 17, 18

**Week Mapping Examples**:
| League Config             | League Week 1 | League Week 2 | League Week 3 | League Week 4 |
|---------------------------|---------------|---------------|---------------|---------------|
| start=1, duration=4       | NFL Week 1    | NFL Week 2    | NFL Week 3    | NFL Week 4    |
| start=15, duration=4      | NFL Week 15   | NFL Week 16   | NFL Week 17   | NFL Week 18   |
| start=8, duration=6       | NFL Week 8    | NFL Week 9    | NFL Week 10   | NFL Week 11   |

---

### RosterSelection
**Properties**:
- `id`: String (UUID)
- `rosterId`: String (reference to Roster)
- `rosterSlot`: RosterSlot (which position slot)
- `nflPlayerId`: String (reference to NFLPlayer)
- `selectedAt`: Timestamp

**Business Rules**:
- Links a roster slot to specific NFL player
- Position eligibility validated on creation
- Cannot duplicate NFL player in same roster

---

### PlayerStats
**Properties**:
- `id`: String (UUID)
- `nflPlayerId`: String (reference to NFLPlayer)
- `nflWeekNumber`: Integer (which NFL week)
- `gameId`: String (reference to NFLGame)
- `passingYards`: Integer
- `passingTDs`: Integer
- `interceptions`: Integer
- `rushingYards`: Integer
- `rushingTDs`: Integer
- `receptions`: Integer
- `receivingYards`: Integer
- `receivingTDs`: Integer
- `fumblesLost`: Integer
- `twoPointConversions`: Integer
- `fantasyPoints`: Double (calculated)

**Business Rules**:
- Game-by-game stats tracked for each NFL week
- Fantasy points calculated based on league's PPR scoring rules
- Real-time updates during live games (configurable refresh interval)

---

### DefensiveStats
**Properties**:
- `id`: String (UUID)
- `nflTeamId`: String (reference to NFLTeam)
- `nflWeekNumber`: Integer
- `gameId`: String (reference to NFLGame)
- `sacks`: Integer
- `interceptions`: Integer
- `fumbleRecoveries`: Integer
- `safeties`: Integer
- `defensiveTDs`: Integer
- `pointsAllowed`: Integer
- `yardsAllowed`: Integer
- `fantasyPoints`: Double (calculated)

**Business Rules**:
- Team defense stats per game
- Fantasy points = individual plays + points allowed tier + yards allowed tier
- Negative fantasy points possible

---

### Score
**Properties**:
- `id`: String (UUID)
- `leaguePlayerId`: String (reference to LeaguePlayer)
- `weekId`: String (reference to Week)
- `nflWeekNumber`: Integer
- `totalPoints`: Double
- `breakdown`: List<PlayerScoreBreakdown>
- `cumulativePoints`: Double (season total up to this week)
- `rank`: Integer (player's rank in league for this week)

**Business Rules**:
- Calculated per league player per week
- Sum of all roster player fantasy points for that week
- Cumulative scoring across all league weeks
- Real-time updates during games

---

### AdminInvitation
**Properties**:
- `id`: String (UUID)
- `email`: String
- `invitedBy`: String (reference to SUPER_ADMIN user)
- `status`: Enum (PENDING, ACCEPTED, EXPIRED)
- `token`: String (unique invitation token)
- `expiresAt`: Timestamp (7 days from creation)
- `createdAt`: Timestamp
- `acceptedAt`: Timestamp (nullable)

**Business Rules**:
- Created by SUPER_ADMIN only
- Expires in 7 days
- Email must match Google OAuth email on acceptance
- Cannot create SUPER_ADMIN via invitation

---

### PlayerInvitation
**Properties**:
- `id`: String (UUID)
- `email`: String
- `leagueId`: String (reference to League - LEAGUE-SCOPED)
- `invitedBy`: String (reference to ADMIN user)
- `status`: Enum (PENDING, ACCEPTED, EXPIRED)
- `token`: String (unique invitation token)
- `expiresAt`: Timestamp (7 days from creation)
- `createdAt`: Timestamp
- `acceptedAt`: Timestamp (nullable)

**Business Rules**:
- Created by ADMIN for their own leagues only
- League-scoped - player joins specific league
- Email must match Google OAuth email on acceptance
- Player can be member of multiple leagues

---

### PersonalAccessToken (PAT)
**Properties**:
- `id`: String (UUID)
- `name`: String (user-defined name)
- `tokenHash`: String (bcrypt hash of plaintext token)
- `scope`: Enum (READ_ONLY, WRITE, ADMIN)
- `expiresAt`: Timestamp
- `createdBy`: String (user ID or "SYSTEM" for bootstrap)
- `createdAt`: Timestamp
- `lastUsedAt`: Timestamp (nullable)
- `revoked`: Boolean
- `revokedAt`: Timestamp (nullable)

**Business Rules**:
- Plaintext token shown ONLY ONCE at creation (format: `pat_<random>`)
- Token hashed with bcrypt before storage
- Used for service-to-service authentication
- Bootstrap PAT created by setup script with ADMIN scope
- Tracked for audit and security

**PAT Scopes**:
- READ_ONLY: Read access to endpoints
- WRITE: Write access to admin endpoints
- ADMIN: Full access including super admin endpoints

---

### NFLGame
**Properties**:
- `id`: String (UUID)
- `nflWeekNumber`: Integer (1-22)
- `homeTeamId`: String (reference to NFLTeam)
- `awayTeamId`: String (reference to NFLTeam)
- `gameTime`: Timestamp
- `status`: Enum (SCHEDULED, IN_PROGRESS, COMPLETED)
- `homeScore`: Integer (nullable)
- `awayScore`: Integer (nullable)

**Business Rules**:
- Schedule fetched from external NFL data source
- Used to determine roster lock timing
- First game start time triggers league configuration lock

---

## Domain Events

### UserEvents
- `AdminInvitationSent`
- `AdminAccountCreated`
- `PlayerInvitationSent`
- `PlayerJoinedLeague`
- `RoleUpgraded`

### LeagueEvents
- `LeagueCreated`
- `LeagueActivated`
- `LeagueConfigurationLocked` (when first game starts)
- `LeagueCompleted`

### RosterEvents
- `NFLPlayerSelected`
- `RosterSelectionChanged`
- `RosterCompleted`
- `RosterLocked` (when first game starts)

### ScoringEvents
- `PlayerStatsUpdated` (real-time during games)
- `WeekScoresCalculated`
- `StandingsUpdated`

### SecurityEvents
- `PATCreated`
- `PATUsed`
- `PATRevoked`
- `UnauthorizedAccessAttempt`
- `AuthenticationFailure`

---

## Repository Interfaces (Ports)

### User Domain
- `UserRepository`
- `AdminInvitationRepository`
- `PlayerInvitationRepository`
- `PersonalAccessTokenRepository`

### League Domain
- `LeagueRepository`
- `LeaguePlayerRepository`
- `WeekRepository`

### Roster Domain
- `RosterRepository`
- `RosterSelectionRepository`

### NFL Data Domain
- `NFLPlayerRepository`
- `NFLTeamRepository`
- `NFLGameRepository`
- `PlayerStatsRepository`
- `DefensiveStatsRepository`

### Scoring Domain
- `ScoreRepository`

### Audit Domain
- `AuditLogRepository`

---

## External Adapters (Infrastructure)

### Authentication/Authorization
- **Envoy Sidecar**: External entry point, handles ALL traffic
- **Auth Service** (localhost:9191): Token validation for Envoy ext_authz
  - Validates Google OAuth JWT tokens
  - Validates Personal Access Tokens (PATs)
  - Returns user/service context to Envoy
- **Google OAuth**: User authentication provider

### Data Integration
- **NFL Data Adapter**: Fetches real-time NFL data
  - Game schedules for specific weeks
  - Live game scores
  - Player statistics per week
  - Team standings
  - Configurable refresh interval (e.g., 5 minutes)
  - Fetches only for league week range (startingWeek to startingWeek+numberOfWeeks-1)

### Persistence
- **MongoDB Repositories**: All repository implementations

---

## Key Business Flows

### 1. Admin Creation Flow
1. SUPER_ADMIN sends admin invitation to email
2. User receives invitation link
3. User authenticates with Google OAuth
4. System validates email match
5. User account created with ADMIN role
6. Admin can now create leagues

### 2. Player Joins League Flow
1. ADMIN invites player to specific league
2. Player receives league-specific invitation
3. Player authenticates with Google OAuth
4. System creates User (if new) with PLAYER role
5. LeaguePlayer record created (league membership)
6. Player can now build roster for that league

### 3. Roster Building Flow (One-Time Draft)
1. League player selects individual NFL players by position
2. System validates position eligibility
3. System validates no duplicate NFL players in roster
4. Player fills all required positions before lock deadline
5. When roster lock deadline passes, roster is PERMANENTLY LOCKED
6. No changes allowed for entire season (no waiver wire, no trades)
7. Same roster competes for all configured weeks

### 4. Weekly Scoring Flow
1. NFL games played for specific week
2. Data adapter fetches player stats for that NFL week
3. System calculates fantasy points per NFL player using league's scoring rules
4. System sums all roster player points for each league player
5. Standings updated with cumulative scores
6. Real-time updates during games (configurable interval)

### 5. League Configuration Lock Flow
1. Admin creates league with configuration
2. Configuration remains mutable until first NFL game starts
3. When first game of starting week begins, configuration LOCKS
4. ALL configuration becomes immutable:
   - Roster structure, scoring rules, week settings, etc.
5. Any modification attempts rejected with CONFIGURATION_LOCKED
6. Ensures fairness - rules cannot change mid-season

### 6. Bootstrap PAT Flow
1. Setup script creates bootstrap PAT in database
2. PAT has ADMIN scope, 1-year expiration
3. Plaintext PAT shown once on console
4. Used to create first SUPER_ADMIN via API
5. After super admin created, bootstrap PAT should be revoked
6. Super admin can create new PATs for service access

---

## Security Model

### Three-Service Pod Architecture
1. **Envoy Sidecar** (pod IP:443): External entry point
2. **Auth Service** (localhost:9191): Token validation for Envoy
3. **Main API** (localhost:8080): Business logic

### Request Flow
```
External Request → Envoy (pod IP:443)
                     ↓
                   Auth Service (localhost:9191)
                     ↓ (validates token)
                   Envoy (checks role/scope)
                     ↓
                   Main API (localhost:8080)
```

### Authentication Methods
1. **Google OAuth JWT**: For human users (SUPER_ADMIN, ADMIN, PLAYER)
   - Format: `Authorization: Bearer <google-jwt>`
   - Validated by auth service using Google's public keys
   - User role determined from database lookup by googleId

2. **Personal Access Token (PAT)**: For service-to-service
   - Format: `Authorization: Bearer pat_<token>`
   - Hashed and validated against database
   - Scope determines access level (READ_ONLY, WRITE, ADMIN)

### Authorization Layers
1. **Envoy Layer**: Role/scope-based endpoint access
   - `/api/v1/superadmin/*`: SUPER_ADMIN or PAT with ADMIN scope
   - `/api/v1/admin/*`: ADMIN/SUPER_ADMIN or PAT with WRITE/ADMIN scope
   - `/api/v1/player/*`: Any authenticated user or PAT
   - `/api/v1/public/*`: No authentication required
   - `/api/v1/service/*`: PAT only

2. **API Layer**: Resource ownership validation
   - Admin can only manage their own leagues
   - Player can only access leagues they're members of
   - Resource-level permissions in business logic

---

## Key Domain Invariants

1. **NFL Week Validation**: `startingWeek + numberOfWeeks - 1 ≤ 22`
2. **One-Time Draft**: Rosters locked permanently after first game starts
3. **Configuration Immutability**: League config locked when first game starts
4. **League Scoping**: Players belong to specific leagues, not globally
5. **Position Eligibility**: Roster selections must match position requirements
6. **No Duplicate Players**: Cannot select same NFL player twice in roster
7. **Unlimited Availability**: Multiple league players can select same NFL player
8. **Role Hierarchy**: SUPER_ADMIN > ADMIN > PLAYER
9. **Bootstrap Security**: PAT plaintext shown only once, hashed in storage

---

This domain model provides the foundation for implementing the FFL Playoffs system using Hexagonal Architecture, with clear boundaries between domain logic, application services, and infrastructure adapters.
