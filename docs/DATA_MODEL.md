# FFL Playoffs Data Model

> **This document is under active development** as we complete the transition to the roster-based fantasy football model.

## Current Model: Roster-Based Fantasy Football

The FFL Playoffs application uses a **traditional fantasy football** model with individual NFL player roster building.

### Core Entities

#### NFLPlayer
Individual NFL players with position, team, and statistics.

**Attributes**:
- `id` - Unique identifier
- `name` - Player full name
- `position` - Position enum (QB, RB, WR, TE, K, DEF)
- `nflTeam` - Current NFL team
- `jerseyNumber` - Jersey number
- Position-specific stats (passing, rushing, receiving, kicking, defensive)

#### Position (Enum)
Player position types with eligibility rules.

**Values**:
- `QB` - Quarterback
- `RB` - Running Back
- `WR` - Wide Receiver
- `TE` - Tight End
- `K` - Kicker
- `DEF` - Defense/Special Teams
- `FLEX` - Flexible position (RB/WR/TE eligible)
- `SUPERFLEX` - Super-flexible position (QB/RB/WR/TE eligible)

#### RosterConfiguration
League-specific roster structure defining how many of each position.

**Attributes**:
- `leagueId` - Foreign key to League
- `positionSlots` - Map of Position → count
- Example: `{QB: 1, RB: 2, WR: 2, TE: 1, FLEX: 1, K: 1, DEF: 1}` = 9 total players

#### RosterSlot
Individual position slot in a roster with eligibility validation.

**Attributes**:
- `id` - Unique identifier
- `rosterId` - Foreign key to Roster
- `position` - Position type (QB, RB, FLEX, etc.)
- `nflPlayerId` - Assigned NFL player (nullable)

#### Roster (Aggregate Root)
League player's complete roster with all position slots.

**Attributes**:
- `id` - Unique identifier
- `leaguePlayerId` - Foreign key to LeaguePlayer
- `slots` - Collection of RosterSlot
- `isLocked` - Permanent lock status
- `lockedAt` - Timestamp when roster locked
- `complete` - All required slots filled

#### PlayerStats
Individual NFL player performance for a specific game/week.

**Attributes**:
- `id` - Unique identifier
- `nflPlayerId` - Foreign key to NFLPlayer
- `week` - NFL week number
- `gameId` - External game identifier
- Stat fields (yards, touchdowns, receptions, etc.)
- `fantasyPoints` - Calculated PPR points

#### DefensiveStats
Team defense performance for a specific game/week.

**Attributes**:
- `id` - Unique identifier
- `nflTeam` - Team name
- `week` - NFL week number
- `sacks`, `interceptions`, `fumblesRecovered`
- `pointsAllowed`, `yardsAllowed`
- `defensiveTDs`, `safeties`
- `fantasyPoints` - Calculated defensive points

#### LeaguePlayer (Junction Entity)
Junction entity linking Users to Leagues/Games, enabling multi-league membership.

**Purpose**: Represents a user's membership in a specific league with league-scoped data and status tracking.

**Attributes**:
- `id` - Unique identifier (UUID)
- `userId` - Reference to User (UUID)
- `leagueId` - Reference to League/Game (UUID)
- `status` - Membership status (LeaguePlayerStatus enum)
- `joinedAt` - Timestamp when user accepted invitation and became active
- `invitedAt` - Timestamp when invitation was sent
- `lastActiveAt` - Last activity timestamp for engagement tracking
- `invitationToken` - Secure token for invitation acceptance (cleared after use)
- `createdAt` - Record creation timestamp
- `updatedAt` - Last update timestamp

**LeaguePlayerStatus Enum Values**:
- `INVITED` - Invitation pending, user hasn't responded
- `ACTIVE` - User accepted invitation and is active league member
- `DECLINED` - User declined the invitation
- `INACTIVE` - Admin deactivated the member (reversible)
- `REMOVED` - Admin removed the member from league (final)

**Business Methods**:
- `acceptInvitation()` - Accept invitation and transition to ACTIVE status
- `declineInvitation()` - Decline invitation and transition to DECLINED status
- `deactivate()` - Admin action to deactivate active player
- `reactivate()` - Admin action to reactivate inactive player
- `remove()` - Admin action to remove player from league
- `updateLastActive()` - Update activity timestamp
- `isActive()` - Check if player is active
- `isPending()` - Check if invitation is pending
- `canParticipate()` - Check if player can participate in league activities

**Status Lifecycle**:
```
INVITED → ACTIVE (acceptInvitation)
INVITED → DECLINED (declineInvitation)
ACTIVE → INACTIVE (deactivate)
INACTIVE → ACTIVE (reactivate)
* → REMOVED (remove - final state)
```

**Multi-League Support**: A User can have multiple LeaguePlayer records, one for each league they're a member of.

#### PersonalAccessToken (PAT)
API access token for programmatic authentication and authorization.

**Purpose**: Enables server-to-server authentication and API integrations without requiring Google OAuth.

**Attributes**:
- `id` - Unique identifier (UUID)
- `name` - Human-readable token name (e.g., "CI/CD Pipeline Token")
- `tokenIdentifier` - UUID without hyphens from token (for efficient lookup)
- `tokenHash` - BCrypt hashed full token value (secure storage)
- `scope` - Access level (PATScope enum)
- `expiresAt` - Optional expiration timestamp (nullable for non-expiring tokens)
- `createdBy` - User ID who created the token (UUID)
- `createdAt` - Token creation timestamp
- `lastUsedAt` - Last usage timestamp for tracking
- `revoked` - Boolean flag indicating if token is revoked

**Token Format**: `pat_<identifier>_<random>`
- Complete token is 99 characters: prefix (4) + identifier (32) + separator (1) + random (62+)
- Identifier is stored in `tokenIdentifier` for fast database lookups
- Full token is BCrypt hashed and stored in `tokenHash`

**PATScope Enum Values**:
- `READ_ONLY` - Can only read data (GET requests)
- `WRITE` - Can read and modify data (GET, POST, PUT, DELETE)
- `ADMIN` - Full access including administrative operations

**Scope Hierarchy**:
```
ADMIN > WRITE > READ_ONLY
(Admin has all permissions, Write has READ_ONLY + write permissions)
```

**Business Methods**:
- `isValid()` - Check if token is valid (not revoked and not expired)
- `hasScope(PATScope requiredScope)` - Check if token has required permission level
- `revoke()` - Revoke the token (irreversible)
- `updateLastUsed()` - Update last used timestamp
- `isExpired()` - Check if token has expired
- `validateOrThrow()` - Validate token and throw exception if invalid

**Security Notes**:
- Token values are BCrypt hashed before storage
- Only the hash is stored in the database
- The raw token is shown to the user ONLY once at creation time
- Revoked tokens cannot be reactivated (must create new token)

---

## Key Business Rules

### ONE-TIME DRAFT Model

**Critical Rule**: Rosters are built ONCE before the season and are PERMANENTLY LOCKED when the first game starts.

**Pre-Lock Phase**:
- League players draft individual NFL players to fill all roster slots
- Players can modify roster selections (drop/add players)
- Countdown timer to roster lock deadline
- All slots must be filled before lock

**Post-Lock Phase**:
- Roster PERMANENTLY LOCKED - no changes for entire season
- NO waiver wire pickups
- NO trades between players
- NO lineup changes week-to-week
- Injured players remain on roster (cannot replace)

### Individual Player Scoring

**PPR (Points Per Reception) Scoring**:
- Passing: 1 point per 25 yards, 4 points per TD
- Rushing: 1 point per 10 yards, 6 points per TD
- Receiving: 1 point per 10 yards, 1 point per reception (PPR), 6 points per TD
- Kicking: 3-5 points per FG (distance-based), 1 point per extra point
- Defense: Points for sacks, INTs, fumbles, TDs, points/yards allowed tiers

**Total Score Calculation**:
```
League Player Total Score = SUM(all 9 NFL players' fantasy points)
```

### Draft System

**Player Availability**:
- Multiple league players CAN select the same NFL player
- NO ownership restrictions
- NOT a traditional draft where players become unavailable
- All NFL players remain available throughout draft phase

### Roster Lock Enforcement

**Lock Trigger**: First NFL game of the season starts

**Lock Mechanism**:
- `Roster.isLocked = true` when `NOW() >= firstGameStartTime`
- All roster modification endpoints return `403 ROSTER_LOCKED` error
- API validates lock status before any roster changes
- Domain model enforces lock via `validateNotLocked()` guard

---

## Entity Relationships

```
User 1──* LeaguePlayer           // Users can join multiple leagues
User 1──* PersonalAccessToken    // Users can create multiple API tokens

League 1──* LeaguePlayer         // Leagues have multiple members
League 1──1 RosterConfiguration  // Each league has one roster configuration

LeaguePlayer 1──1 Roster         // Each league member has one roster
LeaguePlayer has LeaguePlayerStatus (enum)

Roster 1──* RosterSlot           // Rosters contain multiple position slots
RosterSlot *──1 NFLPlayer        // Slots reference NFL players

NFLPlayer 1──* PlayerStats       // NFL players have weekly stats
NFLPlayer has Position (enum)

PersonalAccessToken has PATScope (enum)

Week 1──* PlayerStats            // Weeks contain player statistics
Week 1──* DefensiveStats         // Weeks contain defensive statistics
```

---

## Database Schema (MongoDB)

### Collections

**nflPlayers**
```javascript
{
  _id: Long,                    // NFL player ID
  name: String,                 // Full name
  firstName: String,
  lastName: String,
  position: String,             // QB, RB, WR, TE, K, DEF
  nflTeam: String,              // Team name
  nflTeamAbbreviation: String,
  jerseyNumber: Number,
  status: String,               // ACTIVE, INJURED, OUT, QUESTIONABLE, DOUBTFUL, BYE

  // Season stats
  gamesPlayed: Number,
  fantasyPoints: Number,
  averagePointsPerGame: Number,

  // Position-specific stats
  passingYards: Number,
  passingTouchdowns: Number,
  interceptions: Number,
  rushingYards: Number,
  rushingTouchdowns: Number,
  receptions: Number,
  receivingYards: Number,
  receivingTouchdowns: Number,
  fieldGoalsMade: Number,
  sacks: Number,
  defensiveTouchdowns: Number,

  externalPlayerId: String,     // External API ID
  createdAt: ISODate,
  updatedAt: ISODate
}

// Indexes
db.nflPlayers.createIndex({ position: 1 })
db.nflPlayers.createIndex({ nflTeam: 1 })
db.nflPlayers.createIndex({ name: "text" })
```

**rosters**
```javascript
{
  _id: UUID,
  leaguePlayerId: UUID,         // Reference to league player
  gameId: UUID,                 // Reference to game
  slots: [                      // Embedded roster slots
    {
      id: UUID,
      position: String,         // QB, RB, WR, TE, K, DEF, FLEX, SUPERFLEX
      nflPlayerId: Long,        // Reference to NFL player
      slotOrder: Number
    }
  ],
  isLocked: Boolean,
  lockedAt: ISODate,
  rosterDeadline: ISODate,
  createdAt: ISODate,
  updatedAt: ISODate
}

// Indexes
db.rosters.createIndex({ leaguePlayerId: 1 }, { unique: true })
db.rosters.createIndex({ gameId: 1 })
db.rosters.createIndex({ isLocked: 1 })
```

**games**
```javascript
{
  _id: UUID,
  name: String,
  code: String,
  creatorId: UUID,
  status: String,               // CREATED, WAITING_FOR_PLAYERS, IN_PROGRESS, COMPLETED
  startingWeek: Number,
  currentWeek: Number,
  numberOfWeeks: Number,
  eliminationMode: String,

  // Configuration lock
  configurationLockedAt: ISODate,
  lockReason: String,
  firstGameStartTime: ISODate,

  // Embedded players
  players: [
    {
      id: UUID,
      gameId: UUID,
      name: String,
      email: String,
      status: String,           // INVITED, ACTIVE, ELIMINATED
      joinedAt: ISODate,
      isEliminated: Boolean,
      teamSelections: []        // Embedded team selections
    }
  ],

  // Embedded scoring rules
  scoringRules: {
    pprRules: { ... },
    fieldGoalRules: { ... },
    defensiveRules: { ... }
  },

  createdAt: ISODate,
  updatedAt: ISODate
}

// Indexes
db.games.createIndex({ code: 1 }, { unique: true })
db.games.createIndex({ creatorId: 1 })
db.games.createIndex({ status: 1 })
```

**playerStats** (Weekly stats per NFL player)
```javascript
{
  _id: ObjectId,
  nflPlayerId: Long,
  week: Number,
  gameId: String,

  // Offensive stats
  passingYards: Number,
  passingTouchdowns: Number,
  interceptions: Number,
  rushingYards: Number,
  rushingTouchdowns: Number,
  receptions: Number,
  receivingYards: Number,
  receivingTouchdowns: Number,

  // Kicking stats
  fieldGoalsMade: Number,
  extraPointsMade: Number,

  // Defensive stats
  sacks: Number,
  interceptionsDef: Number,
  fumbleRecoveries: Number,
  defensiveTouchdowns: Number,

  fantasyPoints: Number,
  createdAt: ISODate
}

// Indexes
db.playerStats.createIndex({ nflPlayerId: 1, week: 1 }, { unique: true })
db.playerStats.createIndex({ week: 1 })
```

**leaguePlayers** (Junction table for user-league membership)
```javascript
{
  _id: UUID,
  userId: UUID,                 // Reference to User
  leagueId: UUID,               // Reference to League/Game
  status: String,               // INVITED, ACTIVE, DECLINED, INACTIVE, REMOVED
  joinedAt: ISODate,            // When user accepted invitation and became active
  invitedAt: ISODate,           // When invitation was sent
  lastActiveAt: ISODate,        // Last activity timestamp
  invitationToken: String,      // Secure invitation token (nullable, cleared after use)
  createdAt: ISODate,
  updatedAt: ISODate
}

// Indexes
db.leaguePlayers.createIndex({ userId: 1, leagueId: 1 }, { unique: true })
db.leaguePlayers.createIndex({ userId: 1 })
db.leaguePlayers.createIndex({ leagueId: 1 })
db.leaguePlayers.createIndex({ status: 1 })
db.leaguePlayers.createIndex({ invitationToken: 1 }, { sparse: true })
```

**personalAccessTokens** (API access tokens for programmatic authentication)
```javascript
{
  _id: UUID,
  name: String,                 // Human-readable token name
  tokenIdentifier: String,      // UUID without hyphens (for fast lookup, indexed)
  tokenHash: String,            // BCrypt hashed FULL token (pat_<identifier>_<random>)
  scope: String,                // READ_ONLY, WRITE, ADMIN
  expiresAt: ISODate,           // Optional expiration (nullable for non-expiring)
  createdBy: UUID,              // User ID who created this token
  createdAt: ISODate,
  lastUsedAt: ISODate,          // Last usage timestamp
  revoked: Boolean              // Revocation flag
}

// Indexes
db.personalAccessTokens.createIndex({ tokenIdentifier: 1 }, { unique: true })
db.personalAccessTokens.createIndex({ createdBy: 1 })
db.personalAccessTokens.createIndex({ revoked: 1 })
db.personalAccessTokens.createIndex({ expiresAt: 1 }, { sparse: true })

// Token Format: pat_<identifier>_<random>
// - tokenIdentifier: extracted from middle part (32 chars)
// - tokenHash: bcrypt hash of complete token for verification
```

---

## API Endpoints

See [API.md](API.md) for complete REST API documentation covering:
- Roster management endpoints (GET, POST, DELETE)
- NFL player search and filtering
- Roster lock validation
- Weekly scoring calculations

---

## Domain Events

### RosterLockedEvent
Triggered when roster becomes permanently locked (first game starts).

**Payload**:
```json
{
  "rosterId": "uuid",
  "leaguePlayerId": "uuid",
  "lockTimestamp": "2025-01-12T18:00:00Z",
  "lockReason": "FIRST_GAME_STARTED"
}
```

### PlayerDraftedEvent
Triggered when NFL player is assigned to a roster slot.

**Payload**:
```json
{
  "rosterId": "uuid",
  "rosterSlotId": "uuid",
  "nflPlayerId": 123,
  "position": "QB"
}
```

---

## References

- **[requirements.md](../requirements.md)** - Complete roster-based requirements
- **[features/roster-management.feature](../features/roster-management.feature)** - Roster lock business rules
- **[features/player-selection.feature](../features/player-selection.feature)** - NFL player selection rules
- **[API.md](API.md)** - Roster management REST endpoints
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Hexagonal architecture details

---

**Last Updated**: 2025-10-01
**Status**: Active Development - Roster-Based Model
