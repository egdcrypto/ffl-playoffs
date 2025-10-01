# FFL Playoffs - Gherkin Feature Files

## Overview
This directory contains comprehensive Gherkin feature files for the FFL Playoffs fantasy football application. These files define the complete behavior of the system using Given-When-Then scenarios, covering all core features from the requirements document.

## Project Summary
**FFL Playoffs** is a fantasy football league game where players build rosters by selecting individual NFL players across multiple positions (QB, RB, WR, TE, FLEX, K, DEF, Superflex) for a configurable duration. The system uses:
- **One-Time Draft Model**: Rosters are built once and locked for the entire season
- **Configurable Scheduling**: Start at any NFL week (1-22), run for any duration (1-17 weeks)
- **Traditional Fantasy Scoring**: PPR scoring based on individual NFL player performance
- **League-Scoped Players**: Players can participate in multiple independent leagues
- **Enterprise Security**: Envoy sidecar with Google OAuth and PAT authentication

## Feature Files Created

### 1. User Management & Authentication
- **user-management.feature** - Three-tier role hierarchy (SUPER_ADMIN → ADMIN → PLAYER)
- **admin-invitation.feature** - Super admin inviting admins via Google OAuth
- **player-invitation.feature** - Admin inviting players to specific leagues
- **authentication.feature** - Google OAuth and PAT authentication flows
- **authorization.feature** - Role-based access control at Envoy layer
- **pat-management.feature** - Personal Access Token management for service-to-service auth
- **bootstrap-setup.feature** - Bootstrap PAT for initial super admin creation

### 2. League Management
- **league-creation.feature** - Admin creating and configuring leagues
  - Custom roster structures (position counts)
  - Configurable starting week and duration
  - PPR, field goal, and defensive scoring configuration
  - Public/private leagues

- **league-configuration-lock.feature** - Configuration immutability
  - All settings locked when first NFL game starts
  - Prevents mid-season rule changes
  - Ensures competitive fairness

- **week-management.feature** - Dynamic NFL week mapping
  - League weeks map to specific NFL weeks
  - Support for playoff-only leagues (e.g., weeks 15-18)
  - Support for mid-season challenges (e.g., weeks 8-13)
  - Validation: startingWeek + numberOfWeeks - 1 ≤ 22

### 3. Roster Management
- **roster-building.feature** - Individual NFL player selection by position
  - Select specific NFL players (e.g., Patrick Mahomes, Christian McCaffrey)
  - Position-based roster slots (QB, RB, WR, TE, FLEX, K, DEF, Superflex)
  - Player search and filtering by name, position, team
  - View NFL player stats and projections
  - Multiple league players can select same NFL player (unlimited availability)

- **roster-lock.feature** - One-time draft model enforcement
  - Rosters permanently locked when first game starts
  - No weekly lineup changes
  - No waiver wire or free agent pickups
  - No trades allowed
  - Incomplete rosters score 0 for unfilled positions

### 4. Scoring System
- **ppr-scoring.feature** - Individual player PPR scoring
  - Passing: yards, TDs, interceptions
  - Rushing: yards, TDs, fumbles
  - Receiving: yards, receptions (PPR), TDs
  - Configurable: Full PPR (1.0), Half PPR (0.5), Standard (0.0)
  - Real-time score updates during games

- **field-goal-scoring.feature** - Kicker scoring by distance
  - Default: 0-39 yards (3 pts), 40-49 yards (4 pts), 50+ yards (5 pts)
  - Custom distance ranges configurable by admin
  - Extra points tracked separately

- **defensive-scoring.feature** - Team defense comprehensive scoring
  - Individual plays: sacks, INTs, fumbles, safeties, TDs
  - Points allowed tiers (e.g., 0 points allowed = 10 pts)
  - Yards allowed tiers (e.g., 0-99 yards = 10 pts)
  - All tiers configurable by admin
  - Negative points possible for poor performance

### 5. Leaderboard & Standings
- **leaderboard.feature** - Real-time standings and rankings
  - Current week rankings
  - Overall cumulative scores
  - Points breakdown by week
  - Historical performance tracking

### 6. Data Integration
- **data-integration.feature** - NFL data synchronization
  - Game schedules for specific weeks
  - Live game scores
  - Player statistics per week
  - Near real-time updates (configurable interval)
  - Fetches data only for league week range

### 7. Additional Features
- **admin-management.feature** - Super admin capabilities
- **game-management.feature** - Game lifecycle management
- **super-admin-management.feature** - System-wide admin operations

## Domain Model
See **DOMAIN_MODEL.md** for comprehensive documentation of:
- Aggregates (User, League, Roster, NFLPlayer, NFLTeam)
- Value Objects (RosterConfiguration, ScoringRules)
- Entities (Week, LeaguePlayer, RosterSelection, PlayerStats)
- Domain Events
- Repository Interfaces
- Business Rules and Invariants

## Key Business Rules Captured

### One-Time Draft Model
- Rosters built ONCE before season starts
- Rosters PERMANENTLY LOCKED when first game begins
- NO changes allowed after lock (no waiver wire, no trades, no weekly changes)
- Ensures strategy and skill in initial draft selection

### League Configuration Lock
- ALL league configuration becomes immutable when first NFL game starts
- Locked settings include: roster structure, scoring rules, week settings, etc.
- Prevents mid-season rule changes
- Maintains competitive fairness

### Flexible Scheduling
- Leagues can start at any NFL week (1-22)
- Leagues can run for any duration (1-17 weeks)
- Validation: startingWeek + numberOfWeeks - 1 ≤ 22
- Examples:
  - Playoff league: start week 15, run 4 weeks
  - Mid-season challenge: start week 8, run 6 weeks
  - Full season: start week 1, run 17 weeks

### Individual Player Selection
- Players select specific NFL players by position
- Traditional fantasy football roster management
- QB, RB, WR, TE, K, DEF positions
- FLEX position: can select RB, WR, or TE
- Superflex position: can select QB, RB, WR, or TE
- Unlimited availability: multiple league players can select same NFL player

### Scoring
- **PPR Scoring**: Points Per Reception (configurable: 1.0, 0.5, or 0)
- **Field Goals**: Scored by distance (longer = more points)
- **Defense**: Individual plays + points allowed tier + yards allowed tier
- **Real-time Updates**: Scores update during live games
- **Weekly Totals**: Sum of all roster player fantasy points

### League-Scoped Players
- Players belong to specific leagues, not globally to system
- Players can be members of multiple leagues
- Separate rosters for each league
- Admin can only invite players to their own leagues

### Three-Tier Role Hierarchy
- **SUPER_ADMIN**: System-wide administrator, manages admins, generates PATs
- **ADMIN**: League administrators, create leagues, invite players (league-scoped)
- **PLAYER**: Participants, build rosters, view standings (league-scoped)

### Security Architecture
- **Envoy Sidecar**: All traffic goes through Envoy (pod IP:443)
- **Auth Service**: Token validation on localhost:9191
- **Main API**: Business logic on localhost:8080
- **Authentication**: Google OAuth (users) and PATs (service-to-service)
- **Authorization**: Role-based at Envoy, resource ownership in API

## Test Coverage

Each feature file includes:
- **Happy path scenarios**: Normal operation flows
- **Edge cases**: Boundary conditions and special cases
- **Error cases**: Validation failures and authorization errors
- **Data-driven scenarios**: Using Scenario Outlines with example tables

## Scenario Statistics
- **Total Feature Files**: 17
- **Total Scenarios**: 200+ comprehensive test scenarios
- **Coverage**: All requirements from requirements.md
- **Business Rules**: All key rules captured in executable format

## Usage

These Gherkin feature files serve as:
1. **Requirements Documentation**: Business-readable specifications
2. **Test Specifications**: BDD test scenarios
3. **Developer Guide**: Clear expected behavior
4. **Acceptance Criteria**: Definition of done

## Implementation Notes

### Hexagonal Architecture Layers
The features map to hexagonal architecture layers:

**Domain Layer**:
- Game, Player, League, Roster aggregates
- Scoring domain logic
- Value objects for configuration

**Application Layer**:
- Use cases for each feature scenario
- DTOs for data transfer
- Transaction boundaries

**Infrastructure Layer**:
- REST controllers (Envoy → API)
- Repository implementations (MongoDB)
- NFL data adapters
- Auth service for Envoy ext_authz

### Next Steps
1. Implement domain entities and value objects
2. Create repository interfaces (ports)
3. Build use cases for each feature
4. Implement REST API endpoints
5. Build auth service for Envoy
6. Implement NFL data integration adapter
7. Create automated tests using these feature files

## Related Documents
- **requirements.md**: Original requirements document
- **DOMAIN_MODEL.md**: Comprehensive domain model documentation
- **FEATURE_COVERAGE_SUMMARY.md**: Mapping of features to requirements

## Feature File Format
All feature files follow standard Gherkin format:
```gherkin
Feature: <Feature Name>
  As a <role>
  I want to <goal>
  So that <business value>

  Background:
    Given <common setup for all scenarios>

  Scenario: <Happy path scenario>
    Given <precondition>
    When <action>
    Then <expected outcome>

  Scenario: <Edge case scenario>
    ...

  Scenario: <Error case scenario>
    ...
```

## Contact & Contribution
These feature files are the foundation for the entire FFL Playoffs project. They define expected behavior and serve as the contract between business requirements and technical implementation.
