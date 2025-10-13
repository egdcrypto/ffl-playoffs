# FFL Playoffs - Feature Coverage Summary

## Overview
This document provides a comprehensive summary of all Gherkin feature files created for the FFL Playoffs project based on requirements.md.

**Total Feature Files:** 16
**Total Lines of Gherkin:** 5,001
**Status:** Complete ✅

---

## Feature Files by Category

### 1. Authentication & Authorization (236 lines)
**File:** `authentication.feature`

**Coverage:**
- ✅ Envoy sidecar security architecture
- ✅ Google OAuth JWT authentication flow
- ✅ Personal Access Token (PAT) authentication flow
- ✅ Token validation by auth service (localhost:9191)
- ✅ Role-based access control (SUPER_ADMIN, ADMIN, PLAYER)
- ✅ PAT scope-based access control (ADMIN, WRITE, READ_ONLY)
- ✅ User account creation via Google OAuth
- ✅ Resource ownership validation
- ✅ Multi-league access
- ✅ Network policy enforcement (API on localhost only)
- ✅ Token expiration and refresh
- ✅ Error cases (expired, invalid, malformed tokens)

**Key Scenarios:**
- Envoy ext_authz filter calls auth service for all requests
- Auth service detects token type (Google JWT vs PAT prefix)
- Pre-validated requests forwarded to API with user/service context headers
- Endpoint security requirements enforcement

---

### 2. Personal Access Token Management (413 lines)
**File:** `pat-management.feature` ⭐ NEW

**Coverage:**
- ✅ Bootstrap PAT creation via setup script
- ✅ Bootstrap PAT properties (ADMIN scope, 1-year expiration, created by SYSTEM)
- ✅ Super admin PAT CRUD operations
- ✅ PAT scope configuration (READ_ONLY, WRITE, ADMIN)
- ✅ PAT expiration date management
- ✅ PAT revocation (immediate invalidation)
- ✅ PAT rotation/regeneration (old token invalidated, new token issued)
- ✅ PAT deletion (permanent removal)
- ✅ PAT security (bcrypt hashing, one-time plaintext display)
- ✅ PAT usage tracking (lastUsedAt timestamp)
- ✅ Audit logging for all PAT operations
- ✅ Token format validation (pat_ prefix, 64+ chars, cryptographically secure)
- ✅ Error cases (duplicate names, invalid scope, past expiration dates)

**Key Scenarios:**
- Setup script creates bootstrap PAT for initial super admin creation
- Plaintext token displayed only once upon creation
- Token hashed with bcrypt before database storage
- PAT usage tracked for audit purposes
- Only SUPER_ADMIN can manage PATs

---

### 3. Super Admin Management (181 lines)
**File:** `super-admin-management.feature`

**Coverage:**
- ✅ Bootstrap super admin via bootstrap PAT
- ✅ Super admin invitation system
- ✅ Admin account creation and revocation
- ✅ System-wide permissions
- ✅ View all admins and leagues
- ✅ Audit logging
- ✅ PAT management (covered in pat-management.feature)

---

### 4. Admin Management (266 lines)
**File:** `admin-management.feature`

**Coverage:**
- ✅ Admin invitation by super admin
- ✅ Admin role assignment via Google OAuth
- ✅ League creation and ownership
- ✅ League-scoped permissions
- ✅ Admin cannot access other admins' leagues
- ✅ Admin management of league players
- ✅ Manual score adjustments
- ✅ League health monitoring

---

### 5. Player Invitation (115 lines)
**File:** `player-invitation.feature`

**Coverage:**
- ✅ League-scoped player invitations
- ✅ Email-based invitation system
- ✅ Invitation acceptance via Google OAuth
- ✅ Player linked to specific league
- ✅ Multi-league player membership
- ✅ Invitation expiration
- ✅ Invitation revocation

---

### 6. League Configuration (470 lines)
**File:** `league-configuration.feature`

**Coverage:**
- ✅ Starting NFL week configuration (1-22)
- ✅ Number of weeks configuration (1-17)
- ✅ Week validation (startingWeek + numberOfWeeks - 1 ≤ 22)
- ✅ Week mapping (league week → NFL week)
- ✅ PPR scoring rules configuration
- ✅ Field goal scoring by distance
- ✅ Defensive scoring rules configuration
- ✅ Points allowed scoring tiers (configurable)
- ✅ Yards allowed scoring tiers (configurable)
- ✅ Pick deadline configuration per week
- ✅ League privacy settings (PUBLIC/PRIVATE)
- ✅ Maximum players configuration
- ✅ **Configuration locking** - ALL settings become immutable after first game starts
- ✅ Configuration cloning from previous leagues
- ✅ Roster configuration (position slots: QB, RB, WR, TE, FLEX, K, DEF, SUPERFLEX)
- ✅ Roster validation (minimum 1 position, max 20 total slots)

**Key Scenarios:**
- League configuration is mutable between activation and first game start
- Once first NFL game of starting week begins, ALL config becomes immutable
- Lock applies to: scoring rules, roster config, weeks, privacy, deadlines, etc.
- Warning displayed before lock with countdown timer
- Audit log captures all attempted modifications after lock

---

### 7. Roster Management (314 lines)
**File:** `roster-management.feature`

**Coverage:**
- ✅ **ONE-TIME DRAFT MODEL** - Build roster ONCE before season
- ✅ Roster building with individual NFL player selection
- ✅ Position-based selection (QB, RB, WR, TE, FLEX, K, DEF)
- ✅ FLEX position accepts RB/WR/TE
- ✅ SUPERFLEX position accepts QB/RB/WR/TE
- ✅ All position slots must be filled
- ✅ Cannot select same NFL player twice in roster
- ✅ Multiple league players CAN select same NFL player (NO draft restrictions)
- ✅ **Permanent roster lock** when first game starts
- ✅ NO changes after lock: no waiver wire, no trades, no weekly adjustments
- ✅ BYE week handling (player scores 0)
- ✅ Injured/inactive player handling (player scores 0, cannot replace)
- ✅ Real-time score updates during games
- ✅ Roster varies by league configuration
- ✅ DEF position selects entire team defense (32 NFL teams)
- ✅ Pagination and filtering for NFL player selection

**Key Scenarios:**
- Build roster before first game with all positions filled
- Roster permanently locked when first game starts - NO changes allowed
- Injured/suspended players must remain on roster for entire season
- League players compete with locked rosters for all configured weeks
- No waiver wire or trade systems exist

---

### 8. Player Roster Selection (485 lines)
**File:** `player-roster-selection.feature`

**Coverage:**
- ✅ NFL player drafting to specific position slots
- ✅ Draft validation (position eligibility, roster limits)
- ✅ Roster completion tracking
- ✅ Position eligibility (FLEX, SUPERFLEX flexible positions)
- ✅ Draft deadlines and lock enforcement
- ✅ Roster finalization before lock
- ✅ Concurrent roster building by multiple league players
- ✅ NFL player availability and ownership
- ✅ Draft history and audit trail

---

### 9. Player Selection (290 lines)
**File:** `player-selection.feature`

**Coverage:**
- ✅ Search NFL players by name
- ✅ Filter by position (QB, RB, WR, TE, K, DEF)
- ✅ Filter by NFL team (32 teams)
- ✅ View player stats (game-by-game performance)
- ✅ View player season totals and averages
- ✅ Sort by various stats (points, yards, touchdowns)
- ✅ Pagination support
- ✅ Player availability status
- ✅ Player injury status

---

### 10. PPR Scoring (225 lines)
**File:** `scoring-ppr.feature`

**Coverage:**
- ✅ Standard PPR scoring rules (individual NFL player-based)
- ✅ Passing: 1 point per 25 yards (configurable)
- ✅ Passing TD: 4 points (configurable)
- ✅ Interceptions: -2 points (configurable)
- ✅ Rushing: 1 point per 10 yards (configurable)
- ✅ Rushing TD: 6 points (configurable)
- ✅ Receiving: 1 point per 10 yards (configurable)
- ✅ Reception: 1 point per reception (configurable to 0.5 or 0)
- ✅ Receiving TD: 6 points (configurable)
- ✅ Fumbles Lost: -2 points (configurable)
- ✅ 2-Point Conversions: 2 points (configurable)
- ✅ Game-by-game stat tracking
- ✅ Weekly score calculation
- ✅ Cumulative season scoring

**Key Scenarios:**
- Each NFL player's stats tracked per game/week
- League player's total score = sum of all roster players' scores
- Real-time score updates during games

---

### 11. Field Goal Scoring (317 lines)
**File:** `field-goal-scoring.feature`

**Coverage:**
- ✅ Field goal scoring by distance range
- ✅ Default scoring: 0-39 yards (3 pts), 40-49 yards (4 pts), 50+ yards (5 pts)
- ✅ Admin can configure custom distance-based scoring
- ✅ Each league can have different field goal rules
- ✅ Game results track field goal distance for accurate scoring
- ✅ Missed field goals score 0 points
- ✅ Extra points (PAT) scoring

---

### 12. Defensive Scoring (349 lines)
**File:** `defensive-scoring.feature`

**Coverage:**
- ✅ Individual defensive play scoring:
  - Sacks: 1 point (configurable)
  - Interceptions: 2 points (configurable)
  - Fumble Recovery: 2 points (configurable)
  - Safety: 2 points (configurable)
  - Defensive/Special Teams TD: 6 points (configurable)
- ✅ **Points Allowed Scoring Tiers** (configurable):
  - 0 points allowed: 10 pts
  - 1-6 points: 7 pts
  - 7-13 points: 4 pts
  - 14-20 points: 1 pt
  - 21-27 points: 0 pts
  - 28-34 points: -1 pt
  - 35+ points: -4 pts
- ✅ **Yards Allowed Scoring Tiers** (configurable):
  - 0-99 yards: 10 pts
  - 100-199 yards: 7 pts
  - 200-299 yards: 5 pts
  - 300-349 yards: 3 pts
  - 350-399 yards: 0 pts
  - 400-449 yards: -3 pts
  - 450+ yards: -5 pts
- ✅ Total defensive points = individual plays + points allowed tier + yards allowed tier
- ✅ Each league can customize all defensive scoring rules

---

### 13. Game Management (291 lines)
**File:** `game-management.feature`

**Coverage:**
- ✅ Create new game/season
- ✅ Set starting NFL week (1-22)
- ✅ Set game duration (1-17 weeks)
- ✅ Configure pick deadlines
- ✅ Start/End game
- ✅ Archive completed games
- ✅ Game lifecycle management
- ✅ Game status tracking (DRAFT, ACTIVE, COMPLETED, ARCHIVED)

---

### 14. Week Management (298 lines)
**File:** `week-management.feature`

**Coverage:**
- ✅ Track current NFL week
- ✅ League week to NFL week mapping
- ✅ Lock picks after deadline for each NFL week
- ✅ Process game results from NFL data
- ✅ Calculate weekly scores based on NFL week games
- ✅ Update standings
- ✅ Weeks dynamically created based on league.startingWeek and league.numberOfWeeks
- ✅ Fetch NFL data only for weeks in league range

**Key Scenarios:**
- League Week 1 → NFL Week (startingWeek)
- League Week 2 → NFL Week (startingWeek + 1)
- Data fetched only for NFL weeks in range [startingWeek, startingWeek + numberOfWeeks - 1]

---

### 15. Leaderboard & Standings (344 lines)
**File:** `leaderboard.feature`

**Coverage:**
- ✅ Real-time standings
- ✅ Current week rankings
- ✅ Overall cumulative scores
- ✅ Points breakdown by week
- ✅ Points breakdown by player position
- ✅ League player performance comparison
- ✅ Historical data (past weeks, trends)
- ✅ Roster preview in standings
- ✅ Live score updates during games
- ✅ Multi-league standings

---

### 16. Data Integration (407 lines)
**File:** `data-integration.feature`

**Coverage:**
- ✅ NFL game schedules for specific weeks
- ✅ Live game scores during games
- ✅ Player statistics per NFL week
- ✅ Team standings and bye weeks
- ✅ Near real-time data synchronization
- ✅ Data refresh intervals (configurable)
- ✅ Fetch data only for NFL weeks within league range
- ✅ Handle NFL schedule changes
- ✅ Player injury updates
- ✅ Weather data integration
- ✅ Error handling and retry logic
- ✅ Data source failover

---

## Domain Model Coverage

Based on the feature files, the following domain entities are defined:

### Core Entities
- ✅ **User** - role (SUPER_ADMIN, ADMIN, PLAYER), googleId, email, name
- ✅ **League/Game** - owned by admin, startingWeek, numberOfWeeks, rosterConfiguration, scoringRules
- ✅ **LeaguePlayer** - junction table for league membership (league-scoped)
- ✅ **NFLTeam** - 32 NFL teams (name, abbreviation, conference, division)
- ✅ **NFLPlayer** - individual NFL players (firstName, lastName, position, nflTeam, jerseyNumber, status)
- ✅ **Position** - enum (QB, RB, WR, TE, K, DEF)
- ✅ **RosterSlot** - roster position definition (position, count, eligiblePositions)
- ✅ **RosterConfiguration** - defines league roster structure (list of RosterSlots, total size)
- ✅ **Roster** - league player's roster (leaguePlayerId, list of RosterSelections)
- ✅ **RosterSelection** - NFL player selection for specific roster slot
- ✅ **PlayerStats** - individual NFL player stats per game/week
- ✅ **DefensiveStats** - team defense stats per game/week
- ✅ **Week** - league week with nflWeekNumber mapping
- ✅ **Score** - calculated per league player per NFL week
- ✅ **NFLGame** - NFL game schedule and outcomes
- ✅ **AdminInvitation** - super admin → admin
- ✅ **PlayerInvitation** - admin → player (league-scoped)
- ✅ **LeagueConfiguration** - includes all league settings
- ✅ **PersonalAccessToken** - PAT storage (id, name, tokenHash, scope, expiresAt, createdBy, lastUsedAt, revoked)
- ✅ **PATScope** - enum (READ_ONLY, WRITE, ADMIN)
- ✅ **AuditLog** - admin and PAT activity tracking

### Value Objects
- ✅ **ScoringRules** - all scoring configuration for a league
- ✅ **FieldGoalScoringRules** - fg0to39Points, fg40to49Points, fg50PlusPoints
- ✅ **DefensiveScoringRules** - sackPoints, interceptionPoints, fumbleRecoveryPoints, safetyPoints, defensiveTDPoints, pointsAllowedTiers, yardsAllowedTiers
- ✅ **PPRScoringRules** - passingYardsPerPoint, rushingYardsPerPoint, receivingYardsPerPoint, receptionPoints, touchdownPoints

---

## Key Business Rules Captured

### 1. Role Hierarchy ✅
- SUPER_ADMIN: System-wide access, can invite/revoke admins, manage PATs
- ADMIN: League-scoped, can create leagues, invite players to their leagues
- PLAYER: Participant-level, can build rosters, view standings

### 2. Authentication & Authorization ✅
- ALL API access through Envoy sidecar (no direct API access)
- Two authentication methods: Google OAuth (users) + PATs (services)
- Envoy ext_authz filter validates ALL requests via auth service
- Auth service detects token type and validates accordingly
- Bootstrap PAT for initial system setup

### 3. ONE-TIME DRAFT MODEL ✅
- Rosters built ONCE before first game
- Rosters PERMANENTLY LOCKED when first game starts
- NO changes after lock: no waiver wire, no trades, no weekly adjustments
- League players compete with locked rosters for all configured weeks
- Injured/suspended players must remain on roster

### 4. Configuration Immutability ✅
- League configuration is mutable between activation and first game start
- Once first NFL game of starting week begins, ALL config becomes IMMUTABLE
- Lock applies to: scoring rules, roster config, weeks, privacy, deadlines, etc.

### 5. Flexible Scheduling ✅
- Start at any NFL week (1-22)
- Run for any duration (1-17 weeks)
- Validation: startingWeek + numberOfWeeks - 1 ≤ 22
- League weeks map to NFL weeks dynamically

### 6. Configurable Roster Structure ✅
- Admins define roster positions (QB, RB, WR, TE, FLEX, K, DEF, SUPERFLEX)
- FLEX accepts RB/WR/TE
- SUPERFLEX accepts QB/RB/WR/TE
- Each league can have different roster configuration

### 7. Individual NFL Player Scoring ✅
- Traditional fantasy football with individual NFL player selection
- PPR scoring based on individual player performance
- Field goal scoring by distance
- Defensive scoring with configurable tiers
- League player's score = sum of all roster players' scores

### 8. Multi-League Support ✅
- Players can be members of multiple leagues
- Each league has independent configuration
- League-scoped player invitations
- Admins can own multiple leagues with different settings

### 9. PAT System ✅
- Bootstrap PAT created by setup script for initial super admin creation
- Super admin can create/revoke/rotate PATs
- PATs have scope (READ_ONLY, WRITE, ADMIN)
- PAT tokens hashed with bcrypt before storage
- Plaintext token displayed only once upon creation
- PAT usage tracked for audit purposes

---

## Coverage Analysis

### Requirements Completeness: 100% ✅

All core features from requirements.md are covered:

1. ✅ User Management and Role Hierarchy
   - Three-tier role system (SUPER_ADMIN, ADMIN, PLAYER)
   - Super admin capabilities (admin invitation, PAT management)
   - Admin player invitation (league-scoped)
   - Bootstrap PAT for initial setup

2. ✅ Roster Building and Player Selection
   - Individual NFL player selection by position
   - ONE-TIME DRAFT MODEL with permanent roster lock
   - Player search and filtering
   - Roster management (build once, lock after first game)
   - Position eligibility (FLEX, SUPERFLEX)

3. ✅ Scoring System
   - PPR scoring rules (individual player-based)
   - Field goal scoring by distance (configurable)
   - Defensive scoring (configurable with tiers)
   - Weekly scoring and cumulative totals

4. ✅ League/Game Creation and Configuration
   - Flexible scheduling (startingWeek, numberOfWeeks)
   - Configurable roster positions
   - Configurable scoring rules
   - Configuration immutability after first game starts
   - Configuration cloning

5. ✅ Leaderboard & Standings
   - Real-time standings
   - Weekly rankings
   - Cumulative scores
   - Points breakdown

6. ✅ Data Integration
   - NFL game schedules for specific weeks
   - Live game scores
   - Player statistics per week
   - Near real-time synchronization

7. ✅ Admin Tools
   - Super admin functions (system-wide)
   - Admin functions (league-scoped)
   - Manual score adjustments
   - Audit logging

8. ✅ Authentication & Authorization
   - Envoy sidecar with ext_authz filter
   - Google OAuth for users
   - Personal Access Tokens for services
   - Role-based access control
   - Resource ownership validation

---

## Recommendations

### 1. Implementation Priority

**Phase 1: Foundation** (Weeks 1-2)
- Bootstrap PAT setup script
- Authentication service (Google OAuth + PAT validation)
- User and role management
- Domain model entities

**Phase 2: Core Features** (Weeks 3-5)
- League creation and configuration
- Roster configuration
- NFL player and team data model
- Configuration lock enforcement

**Phase 3: Roster Building** (Weeks 6-8)
- NFL player selection
- Roster building UI/API
- Position validation
- Roster lock enforcement

**Phase 4: Scoring** (Weeks 9-11)
- PPR scoring engine
- Field goal scoring
- Defensive scoring with tiers
- Weekly score calculation

**Phase 5: Data Integration** (Weeks 12-14)
- NFL data API integration
- Live game scores
- Player stats synchronization
- Real-time updates

**Phase 6: Leaderboard** (Weeks 15-16)
- Standings calculation
- Leaderboard display
- Historical data

**Phase 7: Polish** (Weeks 17-18)
- Admin tools
- Audit logging
- Error handling
- Performance optimization

---

## Next Steps

1. ✅ Feature files complete (all 16 files)
2. 🔄 Review feature files with stakeholders
3. ⏳ Create step definitions (Java/Spring Boot)
4. ⏳ Implement domain model (Hexagonal Architecture)
5. ⏳ Implement application services
6. ⏳ Implement REST controllers
7. ⏳ Implement data integration layer
8. ⏳ Implement Envoy configuration
9. ⏳ Implement authentication service
10. ⏳ Create database migrations (MongoDB)
11. ⏳ Write unit and integration tests
12. ⏳ Deploy to Kubernetes with Envoy sidecar

---

## Conclusion

All feature files have been created based on requirements.md. The Gherkin scenarios provide comprehensive coverage of all core features, including:

- **Authentication & Authorization** with Envoy sidecar and dual authentication (Google OAuth + PATs)
- **PAT Management** with bootstrap PAT for initial setup (NEW file created)
- **ONE-TIME DRAFT MODEL** with permanent roster lock
- **Configuration Immutability** after first game starts
- **Flexible Scheduling** with startingWeek and numberOfWeeks
- **Configurable Roster Structure** with position-based selection
- **Individual NFL Player Scoring** with PPR, field goal, and defensive scoring
- **Multi-League Support** with independent configurations

The feature files total over 5,000 lines of comprehensive Gherkin scenarios, covering happy paths, edge cases, and error cases for all business rules.

**Status:** Ready for implementation ✅
