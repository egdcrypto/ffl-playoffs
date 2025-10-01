# FFL Playoffs Data Model

## Table of Contents
1. [Overview](#overview)
2. [Entity Relationship Diagram](#entity-relationship-diagram)
3. [Entities](#entities)
4. [Value Objects](#value-objects)
5. [Aggregates](#aggregates)
6. [Business Rules](#business-rules)
7. [Database Schema](#database-schema)
8. [Indexes and Performance](#indexes-and-performance)

## Overview

The FFL Playoffs data model follows **Domain-Driven Design (DDD)** principles with:
- **Aggregates**: Consistency boundaries for transactional integrity
- **Value Objects**: Immutable objects representing concepts
- **Entities**: Objects with unique identity
- **Rich Domain Model**: Business logic encapsulated in domain objects

## Entity Relationship Diagram

```
┌─────────────────────────────────────────────────────────────────────┐
│                                                                      │
│  ┌──────────┐                                                        │
│  │   User   │                                                        │
│  ├──────────┤                                                        │
│  │ id (PK)  │                                                        │
│  │ googleId │◄──── Google OAuth Identity                            │
│  │ email    │                                                        │
│  │ name     │                                                        │
│  │ role     │◄──── SUPER_ADMIN, ADMIN, PLAYER                       │
│  └────┬─────┘                                                        │
│       │                                                              │
│       │ 1                                                            │
│       │                                                              │
│       │ *                                                            │
│  ┌────▼────────────────┐        ┌────────────────────┐              │
│  │ AdminInvitation     │        │ PersonalAccessToken│              │
│  ├─────────────────────┤        ├────────────────────┤              │
│  │ id (PK)             │        │ id (PK)            │              │
│  │ invitedBy (FK→User) │        │ name               │              │
│  │ email               │        │ tokenHash          │              │
│  │ token               │        │ scope              │              │
│  │ expiresAt           │        │ expiresAt          │              │
│  │ acceptedAt          │        │ createdBy (FK)     │              │
│  └─────────────────────┘        │ revoked            │              │
│                                 └────────────────────┘              │
│       │ 1:1 creates                                                  │
│       ▼                                                              │
│  ┌────────────────┐                                                 │
│  │ User (ADMIN)   │                                                 │
│  └────┬───────────┘                                                 │
│       │                                                              │
│       │ 1                                                            │
│       │ owns                                                         │
│       │ *                                                            │
│  ┌────▼────────────────────────────────────┐                        │
│  │              League                     │                        │
│  ├─────────────────────────────────────────┤                        │
│  │ id (PK)                                 │                        │
│  │ adminId (FK → User)                     │                        │
│  │ name                                    │                        │
│  │ description                             │                        │
│  │ startingWeek (1-18)                     │                        │
│  │ numberOfWeeks (1-17)                    │                        │
│  │ active                                  │                        │
│  │ createdAt                               │                        │
│  └────┬────────────────────────────────────┘                        │
│       │                                                              │
│       │ 1:1                                                          │
│       │                                                              │
│  ┌────▼────────────────────────────────────┐                        │
│  │       ScoringRules (Value Object)       │                        │
│  ├─────────────────────────────────────────┤                        │
│  │ leagueId (FK → League)                  │                        │
│  │ PPR scoring configuration               │                        │
│  │ Field goal scoring by distance          │                        │
│  │ Defensive scoring configuration         │                        │
│  │ Points allowed tiers                    │                        │
│  │ Yards allowed tiers                     │                        │
│  └─────────────────────────────────────────┘                        │
│                                                                      │
│  ┌─────────────────┐         *:*        ┌──────────────────┐        │
│  │      User       │◄───────────────────►│   LeaguePlayer   │        │
│  │   (PLAYER)      │                     │  (Junction)      │        │
│  └─────────────────┘                     ├──────────────────┤        │
│                                          │ id (PK)          │        │
│                                          │ userId (FK)      │        │
│                                          │ leagueId (FK)    │        │
│                                          │ joinedAt         │        │
│                                          │ totalScore       │        │
│                                          └────────┬─────────┘        │
│                                                   │                  │
│                                                   │ 1:*              │
│  ┌───────────────────────────────────────────────▼──────────────┐   │
│  │                    TeamSelection                             │   │
│  ├──────────────────────────────────────────────────────────────┤   │
│  │ id (PK)                                                      │   │
│  │ leaguePlayerId (FK → LeaguePlayer)                           │   │
│  │ week (league week: 1,2,3...)                                 │   │
│  │ nflWeek (actual NFL week: 15,16,17,18...)                    │   │
│  │ teamName                                                     │   │
│  │ eliminated                                                   │   │
│  │ eliminatedInWeek                                             │   │
│  │ locked                                                       │   │
│  │ createdAt                                                    │   │
│  └────────┬─────────────────────────────────────────────────────┘   │
│           │                                                          │
│           │ 1:1                                                      │
│           ▼                                                          │
│  ┌────────────────────────────────────────────────────────────┐     │
│  │                       Score                                │     │
│  ├────────────────────────────────────────────────────────────┤     │
│  │ id (PK)                                                    │     │
│  │ teamSelectionId (FK → TeamSelection)                       │     │
│  │ leaguePlayerId (FK → LeaguePlayer)                         │     │
│  │ week                                                       │     │
│  │ nflWeek                                                    │     │
│  │ totalScore                                                 │     │
│  │ passingPoints                                              │     │
│  │ rushingPoints                                              │     │
│  │ receivingPoints                                            │     │
│  │ fieldGoalPoints                                            │     │
│  │ defensivePoints                                            │     │
│  │ calculatedAt                                               │     │
│  └────────────────────────────────────────────────────────────┘     │
│                                                                      │
│  ┌───────────────────────────────────────────────────────────┐      │
│  │                  GameResult (External Data)               │      │
│  ├───────────────────────────────────────────────────────────┤      │
│  │ id (PK)                                                   │      │
│  │ nflWeek                                                   │      │
│  │ teamName                                                  │      │
│  │ opponentName                                              │      │
│  │ won                                                       │      │
│  │ lost                                                      │      │
│  │ passingYards, rushingYards, receivingYards                │      │
│  │ touchdowns, fieldGoals (with distances)                   │      │
│  │ sacks, interceptions, fumbles                             │      │
│  │ pointsAllowed, yardsAllowed                               │      │
│  │ gameStatus (SCHEDULED, IN_PROGRESS, FINAL)                │      │
│  │ lastUpdated                                               │      │
│  └───────────────────────────────────────────────────────────┘      │
│                                                                      │
│  ┌───────────────────────────────────────────────────────────┐      │
│  │              PlayerInvitation                             │      │
│  ├───────────────────────────────────────────────────────────┤      │
│  │ id (PK)                                                   │      │
│  │ leagueId (FK → League)                                    │      │
│  │ invitedBy (FK → User)                                     │      │
│  │ email                                                     │      │
│  │ token                                                     │      │
│  │ expiresAt                                                 │      │
│  │ acceptedAt                                                │      │
│  │ acceptedByUserId (FK → User)                              │      │
│  └───────────────────────────────────────────────────────────┘      │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

## Entities

### 1. User

**Description**: Represents all users in the system (super admins, admins, players)

**Schema**:
```sql
CREATE TABLE users (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    google_id           VARCHAR(255) UNIQUE NOT NULL,
    email               VARCHAR(255) UNIQUE NOT NULL,
    name                VARCHAR(255) NOT NULL,
    role                VARCHAR(50) NOT NULL,  -- SUPER_ADMIN, ADMIN, PLAYER
    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMP NOT NULL DEFAULT NOW(),
    last_login_at       TIMESTAMP,
    active              BOOLEAN NOT NULL DEFAULT true
);

CREATE INDEX idx_users_google_id ON users(google_id);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
```

**Role Enum**:
- `SUPER_ADMIN`: System-wide administrator
- `ADMIN`: League owner/administrator
- `PLAYER`: League participant

**Business Rules**:
- Google ID must be unique (linked to Google OAuth)
- Email must be unique across the system
- Super admins cannot be created through invitations (bootstrapped)
- Users can have different roles in different contexts (e.g., ADMIN of one league, PLAYER in another)

---

### 2. League (formerly Game)

**Description**: Represents a fantasy football league/game instance

**Schema**:
```sql
CREATE TABLE leagues (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    admin_id            UUID NOT NULL REFERENCES users(id),
    name                VARCHAR(255) NOT NULL,
    description         TEXT,
    starting_week       INTEGER NOT NULL CHECK (starting_week BETWEEN 1 AND 18),
    number_of_weeks     INTEGER NOT NULL CHECK (number_of_weeks BETWEEN 1 AND 17),
    current_week        INTEGER,
    active              BOOLEAN NOT NULL DEFAULT false,
    public              BOOLEAN NOT NULL DEFAULT false,
    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at          TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT valid_week_range CHECK (
        starting_week + number_of_weeks - 1 <= 18
    )
);

CREATE INDEX idx_leagues_admin_id ON leagues(admin_id);
CREATE INDEX idx_leagues_active ON leagues(active);
```

**Fields**:
- `starting_week`: NFL week to begin (1-18)
- `number_of_weeks`: Duration of league (1-17 weeks)
- `current_week`: Current NFL week in league context
- `active`: League is currently running

**Business Rules**:
- `startingWeek + numberOfWeeks - 1 ≤ 18` (cannot exceed NFL season)
- Only league admin can modify configuration
- `startingWeek` and `numberOfWeeks` locked once league is active
- Example: `startingWeek=15, numberOfWeeks=4` → Weeks 15,16,17,18 (playoffs)

---

### 3. LeaguePlayer (Junction Table)

**Description**: Links users to leagues with league-specific player data

**Schema**:
```sql
CREATE TABLE league_players (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id             UUID NOT NULL REFERENCES users(id),
    league_id           UUID NOT NULL REFERENCES leagues(id),
    joined_at           TIMESTAMP NOT NULL DEFAULT NOW(),
    total_score         DECIMAL(10, 2) DEFAULT 0.00,
    rank                INTEGER,
    eliminated          BOOLEAN NOT NULL DEFAULT false,
    active              BOOLEAN NOT NULL DEFAULT true,

    UNIQUE(user_id, league_id)
);

CREATE INDEX idx_league_players_user_id ON league_players(user_id);
CREATE INDEX idx_league_players_league_id ON league_players(league_id);
CREATE INDEX idx_league_players_total_score ON league_players(total_score DESC);
```

**Business Rules**:
- One user can be in multiple leagues
- Each user-league pair is unique
- `total_score` aggregated from all weekly scores
- Player eliminated if all selected teams are eliminated

---

### 4. TeamSelection

**Description**: Represents a player's team choice for a specific week

**Schema**:
```sql
CREATE TABLE team_selections (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    league_player_id        UUID NOT NULL REFERENCES league_players(id),
    week                    INTEGER NOT NULL,  -- League week (1, 2, 3...)
    nfl_week                INTEGER NOT NULL,  -- Actual NFL week (15, 16, 17...)
    team_name               VARCHAR(100) NOT NULL,
    eliminated              BOOLEAN NOT NULL DEFAULT false,
    eliminated_in_week      INTEGER,
    locked                  BOOLEAN NOT NULL DEFAULT false,
    created_at              TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at              TIMESTAMP NOT NULL DEFAULT NOW(),

    UNIQUE(league_player_id, week),
    UNIQUE(league_player_id, team_name)
);

CREATE INDEX idx_team_selections_league_player ON team_selections(league_player_id);
CREATE INDEX idx_team_selections_week ON team_selections(week);
CREATE INDEX idx_team_selections_nfl_week ON team_selections(nfl_week);
```

**Week Mapping**:
- `week`: League week (1-based: 1, 2, 3, 4)
- `nflWeek`: Actual NFL week based on `league.startingWeek`
- Formula: `nflWeek = league.startingWeek + week - 1`

**Business Rules**:
- Player cannot select same team twice in the league
- Player cannot select team after deadline for that week
- Selection locked once NFL week games start
- If team loses, `eliminated = true` and team scores 0 for remaining weeks

---

### 5. Score

**Description**: Calculated fantasy points for a team selection in a specific week

**Schema**:
```sql
CREATE TABLE scores (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    team_selection_id       UUID NOT NULL REFERENCES team_selections(id),
    league_player_id        UUID NOT NULL REFERENCES league_players(id),
    week                    INTEGER NOT NULL,
    nfl_week                INTEGER NOT NULL,
    total_score             DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    passing_points          DECIMAL(10, 2) DEFAULT 0.00,
    rushing_points          DECIMAL(10, 2) DEFAULT 0.00,
    receiving_points        DECIMAL(10, 2) DEFAULT 0.00,
    field_goal_points       DECIMAL(10, 2) DEFAULT 0.00,
    defensive_points        DECIMAL(10, 2) DEFAULT 0.00,
    calculated_at           TIMESTAMP NOT NULL DEFAULT NOW(),

    UNIQUE(team_selection_id, week)
);

CREATE INDEX idx_scores_league_player ON scores(league_player_id);
CREATE INDEX idx_scores_week ON scores(week);
CREATE INDEX idx_scores_total_score ON scores(total_score DESC);
```

**Scoring Breakdown**:
- `passing_points`: Passing yards + passing TDs
- `rushing_points`: Rushing yards + rushing TDs
- `receiving_points`: Receiving yards + receptions (PPR) + receiving TDs
- `field_goal_points`: Field goals by distance (3-5 pts)
- `defensive_points`: Sacks, INTs, fumbles, TDs, points/yards allowed

**Business Rules**:
- Score is 0 if team is eliminated
- Score calculated after NFL week games are final
- Scoring uses league's configured `ScoringRules`

---

### 6. ScoringRules

**Description**: Configurable scoring rules for a league

**Schema**:
```sql
CREATE TABLE scoring_rules (
    id                              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    league_id                       UUID UNIQUE NOT NULL REFERENCES leagues(id),

    -- PPR Scoring
    passing_yards_per_point         DECIMAL(5, 2) DEFAULT 25.0,
    rushing_yards_per_point         DECIMAL(5, 2) DEFAULT 10.0,
    receiving_yards_per_point       DECIMAL(5, 2) DEFAULT 10.0,
    reception_points                DECIMAL(5, 2) DEFAULT 1.0,
    touchdown_points                DECIMAL(5, 2) DEFAULT 6.0,

    -- Field Goal Scoring by Distance
    fg_0_to_39_points               DECIMAL(5, 2) DEFAULT 3.0,
    fg_40_to_49_points              DECIMAL(5, 2) DEFAULT 4.0,
    fg_50_plus_points               DECIMAL(5, 2) DEFAULT 5.0,
    extra_point_points              DECIMAL(5, 2) DEFAULT 1.0,

    -- Defensive Scoring
    sack_points                     DECIMAL(5, 2) DEFAULT 1.0,
    interception_points             DECIMAL(5, 2) DEFAULT 2.0,
    fumble_recovery_points          DECIMAL(5, 2) DEFAULT 2.0,
    safety_points                   DECIMAL(5, 2) DEFAULT 2.0,
    defensive_td_points             DECIMAL(5, 2) DEFAULT 6.0,

    -- Points Allowed Tiers
    points_allowed_0_points         DECIMAL(5, 2) DEFAULT 10.0,
    points_allowed_1_to_6_points    DECIMAL(5, 2) DEFAULT 7.0,
    points_allowed_7_to_13_points   DECIMAL(5, 2) DEFAULT 4.0,
    points_allowed_14_to_20_points  DECIMAL(5, 2) DEFAULT 1.0,
    points_allowed_21_to_27_points  DECIMAL(5, 2) DEFAULT 0.0,
    points_allowed_28_to_34_points  DECIMAL(5, 2) DEFAULT -1.0,
    points_allowed_35_plus_points   DECIMAL(5, 2) DEFAULT -4.0,

    -- Yards Allowed Tiers
    yards_allowed_0_to_99_points    DECIMAL(5, 2) DEFAULT 10.0,
    yards_allowed_100_to_199_points DECIMAL(5, 2) DEFAULT 7.0,
    yards_allowed_200_to_299_points DECIMAL(5, 2) DEFAULT 5.0,
    yards_allowed_300_to_349_points DECIMAL(5, 2) DEFAULT 3.0,
    yards_allowed_350_to_399_points DECIMAL(5, 2) DEFAULT 0.0,
    yards_allowed_400_to_449_points DECIMAL(5, 2) DEFAULT -3.0,
    yards_allowed_450_plus_points   DECIMAL(5, 2) DEFAULT -5.0,

    created_at                      TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at                      TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_scoring_rules_league_id ON scoring_rules(league_id);
```

**Business Rules**:
- Each league has exactly one `ScoringRules` configuration
- Defaults to standard PPR scoring
- Admin can customize all scoring values
- Scoring rules can be modified before league is active

---

### 7. GameResult (External NFL Data)

**Description**: NFL game results and statistics from external API

**Schema**:
```sql
CREATE TABLE game_results (
    id                      UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    nfl_week                INTEGER NOT NULL,
    team_name               VARCHAR(100) NOT NULL,
    opponent_name           VARCHAR(100) NOT NULL,
    won                     BOOLEAN,
    lost                    BOOLEAN,
    tied                    BOOLEAN,

    -- Offensive Stats
    passing_yards           INTEGER DEFAULT 0,
    rushing_yards           INTEGER DEFAULT 0,
    receiving_yards         INTEGER DEFAULT 0,
    touchdowns              INTEGER DEFAULT 0,
    receptions              INTEGER DEFAULT 0,

    -- Field Goal Stats (JSON array of distances)
    field_goals             JSONB DEFAULT '[]',  -- [38, 42, 51]
    extra_points            INTEGER DEFAULT 0,
    two_point_conversions   INTEGER DEFAULT 0,

    -- Defensive Stats
    sacks                   INTEGER DEFAULT 0,
    interceptions           INTEGER DEFAULT 0,
    fumbles_recovered       INTEGER DEFAULT 0,
    safeties                INTEGER DEFAULT 0,
    defensive_tds           INTEGER DEFAULT 0,
    points_allowed          INTEGER DEFAULT 0,
    yards_allowed           INTEGER DEFAULT 0,

    game_status             VARCHAR(50) NOT NULL,  -- SCHEDULED, IN_PROGRESS, FINAL
    game_date               TIMESTAMP NOT NULL,
    last_updated            TIMESTAMP NOT NULL DEFAULT NOW(),

    UNIQUE(nfl_week, team_name)
);

CREATE INDEX idx_game_results_nfl_week ON game_results(nfl_week);
CREATE INDEX idx_game_results_team_name ON game_results(team_name);
CREATE INDEX idx_game_results_status ON game_results(game_status);
```

**Business Rules**:
- Data fetched from external NFL API
- Updated in near real-time during games
- Used to calculate scores for team selections
- Determines team elimination (win/loss/tie)

---

### 8. PersonalAccessToken (PAT)

**Description**: Service-to-service authentication tokens

**Schema**:
```sql
CREATE TABLE personal_access_tokens (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name                VARCHAR(255) NOT NULL,
    token_hash          VARCHAR(255) UNIQUE NOT NULL,  -- bcrypt hash
    scope               VARCHAR(50) NOT NULL,  -- READ_ONLY, WRITE, ADMIN
    created_by          UUID NOT NULL REFERENCES users(id),
    created_at          TIMESTAMP NOT NULL DEFAULT NOW(),
    expires_at          TIMESTAMP NOT NULL,
    last_used_at        TIMESTAMP,
    revoked             BOOLEAN NOT NULL DEFAULT false,
    revoked_at          TIMESTAMP
);

CREATE INDEX idx_pat_token_hash ON personal_access_tokens(token_hash);
CREATE INDEX idx_pat_created_by ON personal_access_tokens(created_by);
CREATE INDEX idx_pat_scope ON personal_access_tokens(scope);
```

**Token Format**: `pat_<random-string>`

**Scope Enum**:
- `READ_ONLY`: Can only read data
- `WRITE`: Can read and write data
- `ADMIN`: Full access (equivalent to SUPER_ADMIN)

**Business Rules**:
- Token plaintext shown only once at creation
- Token hashed with bcrypt before storage
- Super admin can create, list, revoke PATs
- PAT can be revoked immediately
- Expired or revoked PATs are rejected by auth service

---

### 9. AdminInvitation

**Description**: Super admin invitation to create admin account

**Schema**:
```sql
CREATE TABLE admin_invitations (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    invited_by          UUID NOT NULL REFERENCES users(id),
    email               VARCHAR(255) NOT NULL,
    token               VARCHAR(255) UNIQUE NOT NULL,
    expires_at          TIMESTAMP NOT NULL,
    accepted_at         TIMESTAMP,
    accepted_by_user_id UUID REFERENCES users(id),
    created_at          TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_admin_invitations_email ON admin_invitations(email);
CREATE INDEX idx_admin_invitations_token ON admin_invitations(token);
```

**Business Rules**:
- Only super admins can invite admins
- Invitation valid for 7 days
- One-time use token
- Accepting invitation creates ADMIN user via Google OAuth

---

### 10. PlayerInvitation

**Description**: Admin invitation for player to join specific league

**Schema**:
```sql
CREATE TABLE player_invitations (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    league_id           UUID NOT NULL REFERENCES leagues(id),
    invited_by          UUID NOT NULL REFERENCES users(id),
    email               VARCHAR(255) NOT NULL,
    token               VARCHAR(255) UNIQUE NOT NULL,
    expires_at          TIMESTAMP NOT NULL,
    accepted_at         TIMESTAMP,
    accepted_by_user_id UUID REFERENCES users(id),
    created_at          TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_player_invitations_league_id ON player_invitations(league_id);
CREATE INDEX idx_player_invitations_email ON player_invitations(email);
CREATE INDEX idx_player_invitations_token ON player_invitations(token);
```

**Business Rules**:
- Admin can only invite to leagues they own
- Invitation is league-scoped (includes `leagueId`)
- Accepting invitation creates PLAYER user and links to league
- Player account created via Google OAuth

---

## Value Objects

### 1. Week Mapping

**Concept**: Maps league week to NFL week

**Calculation**:
```java
nflWeek = league.startingWeek + leagueWeek - 1
```

**Example**:
- League: `startingWeek=15, numberOfWeeks=4`
- Week 1 → NFL Week 15
- Week 2 → NFL Week 16
- Week 3 → NFL Week 17
- Week 4 → NFL Week 18

---

### 2. Field Goal Scoring

**Stored as JSONB** in `game_results.field_goals`:
```json
{
  "fieldGoals": [38, 42, 51]
}
```

**Scoring Logic**:
- Iterate field goal distances
- Apply scoring rule based on distance:
  - 0-39 yards: `fg_0_to_39_points` (default: 3)
  - 40-49 yards: `fg_40_to_49_points` (default: 4)
  - 50+ yards: `fg_50_plus_points` (default: 5)

---

### 3. Defensive Scoring Tiers

**Points Allowed Example**:
```
Team allowed 10 points → falls in "7-13" tier → earns 4 fantasy points
```

**Yards Allowed Example**:
```
Team allowed 280 yards → falls in "200-299" tier → earns 5 fantasy points
```

**Total Defensive Points**:
```
Defensive Points =
    (sacks × sackPoints) +
    (interceptions × interceptionPoints) +
    (fumbles × fumbleRecoveryPoints) +
    (safeties × safetyPoints) +
    (defensiveTDs × defensiveTDPoints) +
    pointsAllowedTierPoints +
    yardsAllowedTierPoints
```

---

## Aggregates

### 1. League Aggregate

**Root**: League
**Entities**: ScoringRules, LeaguePlayer, PlayerInvitation
**Consistency Boundary**: All league configuration and membership

**Invariants**:
- `startingWeek + numberOfWeeks - 1 ≤ 18`
- Only admin can modify league
- Configuration locked when active

---

### 2. Player Aggregate (LeaguePlayer)

**Root**: LeaguePlayer
**Entities**: TeamSelection, Score
**Consistency Boundary**: Player's selections and scores in a league

**Invariants**:
- Cannot select same team twice
- Cannot select after deadline
- Eliminated teams score 0

---

### 3. User Aggregate

**Root**: User
**Entities**: AdminInvitation, PlayerInvitation (as inviter)
**Consistency Boundary**: User identity and authentication

**Invariants**:
- Google ID unique
- Email unique
- Role determines permissions

---

## Business Rules

### Team Elimination Logic

```
IF team_selection.teamName lost in NFL week:
    team_selection.eliminated = true
    team_selection.eliminatedInWeek = currentWeek

FOR all future weeks:
    score.totalScore = 0  // Eliminated team scores 0
```

**Example**:
- Player selects "Kansas City Chiefs" in Week 1
- Chiefs lose in Week 2
- Chiefs are marked eliminated
- Weeks 3-4: Chiefs score 0 points (even if they win)

---

### PPR Scoring Calculation

```java
public double calculateScore(GameResult result, ScoringRules rules) {
    if (teamSelection.isEliminated()) {
        return 0.0;  // Eliminated teams score 0
    }

    double passingPoints = result.passingYards / rules.passingYardsPerPoint;
    double rushingPoints = result.rushingYards / rules.rushingYardsPerPoint;
    double receivingPoints = (result.receivingYards / rules.receivingYardsPerPoint) +
                             (result.receptions * rules.receptionPoints);
    double touchdownPoints = result.touchdowns * rules.touchdownPoints;

    double fieldGoalPoints = result.fieldGoals.stream()
        .mapToDouble(distance -> calculateFieldGoalPoints(distance, rules))
        .sum();

    double defensivePoints = calculateDefensivePoints(result, rules);

    return passingPoints + rushingPoints + receivingPoints +
           touchdownPoints + fieldGoalPoints + defensivePoints;
}
```

---

### Leaderboard Calculation

**Query**:
```sql
SELECT
    lp.user_id,
    u.name,
    SUM(s.total_score) as total_score,
    COUNT(DISTINCT ts.id) as selections_made,
    COUNT(CASE WHEN ts.eliminated = true THEN 1 END) as eliminated_teams,
    RANK() OVER (ORDER BY SUM(s.total_score) DESC) as rank
FROM league_players lp
JOIN users u ON lp.user_id = u.id
LEFT JOIN team_selections ts ON ts.league_player_id = lp.id
LEFT JOIN scores s ON s.league_player_id = lp.id
WHERE lp.league_id = ?
GROUP BY lp.user_id, u.name
ORDER BY total_score DESC;
```

---

## Database Schema

### Complete Database Creation Script

See `/ffl-playoffs-api/src/main/resources/db/migration/` for Flyway migration scripts.

**Migration Strategy**:
- Flyway for version-controlled migrations
- Incremental migrations (V1, V2, V3...)
- Rollback scripts for each migration

---

## Indexes and Performance

### Query Optimization

**Leaderboard Query**:
- Index: `idx_league_players_league_id`
- Index: `idx_scores_league_player`
- Index: `idx_league_players_total_score`

**Team Selection Validation**:
- Index: `idx_team_selections_league_player`
- Unique constraint: `(league_player_id, team_name)`

**Score Calculation**:
- Index: `idx_game_results_nfl_week`
- Index: `idx_game_results_team_name`

### Performance Considerations

1. **Materialized View for Leaderboard**:
   - Pre-calculated leaderboard updated after each week
   - Reduces real-time computation

2. **Partitioning**:
   - `scores` table partitioned by `nfl_week`
   - `game_results` partitioned by `nfl_week`

3. **Caching**:
   - Redis cache for leaderboard (1-hour TTL)
   - Cache invalidation on score updates

---

## Next Steps

- See [ARCHITECTURE.md](ARCHITECTURE.md) for hexagonal architecture details
- See [API.md](API.md) for REST endpoint documentation
- See [DEPLOYMENT.md](DEPLOYMENT.md) for Kubernetes deployment
- See [DEVELOPMENT.md](DEVELOPMENT.md) for local development setup
