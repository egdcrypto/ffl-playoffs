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
League 1──* LeaguePlayer
League 1──1 RosterConfiguration

LeaguePlayer 1──1 Roster
Roster 1──* RosterSlot
RosterSlot *──1 NFLPlayer

NFLPlayer 1──* PlayerStats
NFLPlayer has Position (enum)

Week 1──* PlayerStats
Week 1──* DefensiveStats
```

---

## Database Schema

### Key Tables

**nfl_players**
```sql
CREATE TABLE nfl_players (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    position VARCHAR(20) NOT NULL,
    nfl_team VARCHAR(50) NOT NULL,
    jersey_number INTEGER,
    active BOOLEAN DEFAULT true,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE INDEX idx_nfl_players_position ON nfl_players(position);
CREATE INDEX idx_nfl_players_team ON nfl_players(nfl_team);
```

**rosters**
```sql
CREATE TABLE rosters (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    league_player_id UUID NOT NULL REFERENCES league_players(id),
    is_locked BOOLEAN DEFAULT false,
    locked_at TIMESTAMP,
    complete BOOLEAN DEFAULT false,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(league_player_id)
);

CREATE INDEX idx_rosters_league_player ON rosters(league_player_id);
CREATE INDEX idx_rosters_locked ON rosters(is_locked);
```

**roster_slots**
```sql
CREATE TABLE roster_slots (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    roster_id UUID NOT NULL REFERENCES rosters(id),
    position VARCHAR(20) NOT NULL,
    nfl_player_id BIGINT REFERENCES nfl_players(id),
    slot_order INTEGER NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(roster_id, slot_order)
);

CREATE INDEX idx_roster_slots_roster ON roster_slots(roster_id);
CREATE INDEX idx_roster_slots_player ON roster_slots(nfl_player_id);
```

**player_stats**
```sql
CREATE TABLE player_stats (
    id BIGSERIAL PRIMARY KEY,
    nfl_player_id BIGINT NOT NULL REFERENCES nfl_players(id),
    week INTEGER NOT NULL,
    game_id VARCHAR(50),
    passing_yards INTEGER DEFAULT 0,
    passing_tds INTEGER DEFAULT 0,
    rushing_yards INTEGER DEFAULT 0,
    rushing_tds INTEGER DEFAULT 0,
    receptions INTEGER DEFAULT 0,
    receiving_yards INTEGER DEFAULT 0,
    receiving_tds INTEGER DEFAULT 0,
    fantasy_points DECIMAL(10,2),
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(nfl_player_id, week)
);

CREATE INDEX idx_player_stats_player_week ON player_stats(nfl_player_id, week);
CREATE INDEX idx_player_stats_week ON player_stats(week);
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
