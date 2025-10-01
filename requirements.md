# FFL Playoffs Game - Requirements

## Table of Contents
1. [Overview](#overview)
2. [System Architecture](#system-architecture)
3. [Core Features](#core-features)
   - [User Management and Role Hierarchy](#1-user-management-and-role-hierarchy)
   - [Roster Building and Player Selection](#2-roster-building-and-player-selection)
   - [Scoring System](#3-scoring-system)
   - [League/Game Creation](#4-leaguegame-creation-and-configuration)
   - [Leaderboard & Standings](#5-leaderboard--standings)
   - [Data Integration](#6-data-integration)
   - [Admin Tools](#7-admin-tools)
   - [Authentication & Authorization](#8-authentication--authorization)
4. [Technical Requirements](#technical-requirements)
5. [Technology Stack](#technology-stack)
6. [Initial Deliverables](#initial-deliverables)
7. [Setup and Bootstrap Process](#setup-and-bootstrap-process)

## Overview

### Product Description
A Fantasy Football League game where players build rosters by selecting individual NFL players across multiple positions (QB, RB, WR, TE, FLEX, K, DEF, Superflex) for a configurable duration (1-17 weeks, default 4 weeks) starting at any week of the NFL season (weeks 1-22). Admins configure roster structure (how many of each position) and scoring rules. Uses standard PPR (Points Per Reception) scoring with configurable field goal and defensive scoring.

### Key Differentiators
- **Configurable Roster Positions**: Admins define roster structure with flexible position counts (QB, RB, WR, TE, FLEX, K, DEF, Superflex)
- **Flexible Scheduling**: Start at any NFL week (1-22), run for any duration (1-17 weeks)
- **League-Scoped Players**: Players belong to specific leagues, supporting multi-league participation
- **Enterprise-Grade Security**: Envoy sidecar with custom auth service, Google OAuth, and PATs
- **Hexagonal Architecture**: Clean separation of concerns for maintainability and testability

## System Architecture
- **API**: Headless Java-based REST API
- **Architecture Pattern**: Hexagonal Architecture (Ports & Adapters)
- **Authentication/Authorization**: Envoy sidecar proxy in the same pod as the API
- **API Access**: ALL API access is ONLY through Envoy sidecar (no direct API exposure)
- **Security Model**: API listens only on localhost, Envoy handles all external traffic
- **Data Integration**: Near real-time data pulling from external datasources

## Core Features

### 1. User Management and Role Hierarchy

#### Role System
The system implements a three-tier role hierarchy:

1. **SUPER_ADMIN**
   - System-wide administrator
   - Can invite and create ADMIN accounts
   - Can revoke admin access
   - Can view and manage all leagues across the system
   - Has full system access
   - Cannot be created through invitation (bootstrapped via configuration)

2. **ADMIN**
   - League administrators (invite-only)
   - Can be created only by SUPER_ADMIN invitation
   - Can create and manage their own leagues
   - Can configure league settings
   - Can invite PLAYER accounts to their leagues
   - Has league-scoped permissions

3. **PLAYER**
   - Regular participants (invite-only)
   - Can be invited only by ADMIN to specific leagues
   - Can build rosters (select individual NFL players by position)
   - Can view standings and scores
   - Has participant-level permissions

#### Super Admin Capabilities
- **Admin Invitation**
  - Super admin can invite users to become admins
  - Email-based admin invitation system
  - Admin account creation upon accepting invitation
  - Revoke admin privileges
  - View all admins in the system
  - Audit admin activities

- **Personal Access Token (PAT) Management**
  - Super admin can generate PATs for service-to-service authentication
  - Configure PAT scope: READ_ONLY, WRITE, ADMIN
  - Set PAT expiration date
  - Revoke PATs immediately
  - View all active PATs
  - Audit PAT usage and last access time
  - Rotate/regenerate PATs
  - PAT returned in plaintext only once upon creation
  - PATs stored in database (PersonalAccessToken table)
  - PAT tokens hashed with bcrypt before storage

- **Bootstrap PAT for Initial Setup**
  - Setup script creates initial bootstrap PAT in database
  - Bootstrap PAT has ADMIN scope and 1-year expiration
  - Bootstrap PAT named "bootstrap" created by "SYSTEM"
  - Script outputs bootstrap PAT plaintext to console (one-time only)
  - Bootstrap PAT used to create first super admin account via API
  - Bootstrap PAT should be rotated after super admin is created
  - Never log or expose PAT plaintext after initial creation

#### Admin Player Invitation (League-Scoped)
- **Player Invitation to Specific Leagues**
  - Admins can invite players ONLY to leagues they own
  - Email-based invitation system with league context
  - Invitation specifies which league the player is joining
  - Player account creation via Google OAuth upon accepting invitation
  - Player belongs to specific league(s), not globally to the system
  - Players can be members of multiple leagues
  - Admin can only manage players in their own leagues
  - Player profile management within league context

### 2. Roster Building and Player Selection
- **Individual NFL Player Selection by Position**
  - **IMPORTANT**: League players build rosters by selecting individual NFL players (e.g., "Patrick Mahomes", "Christian McCaffrey")
  - This is traditional fantasy football roster management with position-based selection
  - Roster structure configured by admin (e.g., 1 QB, 2 RB, 2 WR, 1 TE, 1 FLEX, 1 K, 1 DEF, 1 Superflex)
  - Each roster slot has position requirements:
    - **QB (Quarterback)**: Must select NFL quarterback
    - **RB (Running Back)**: Must select NFL running back
    - **WR (Wide Receiver)**: Must select NFL wide receiver
    - **TE (Tight End)**: Must select NFL tight end
    - **K (Kicker)**: Must select NFL kicker
    - **DEF (Defense/Special Teams)**: Must select NFL team defense
    - **FLEX**: Can select RB, WR, or TE
    - **Superflex**: Can select QB, RB, WR, or TE

- **Player Search and Filtering**
  - Search NFL players by name
  - Filter by position (QB, RB, WR, TE, K, DEF)
  - Filter by NFL team (32 teams)
  - View player stats (game-by-game performance)
  - View player season totals and averages
  - Sort by various stats (points, yards, touchdowns, etc.)
  - Pagination support for large player lists

- **Roster Management (ONE-TIME DRAFT MODEL)**
  - **CRITICAL**: This is a ONE-TIME DRAFT model - rosters are built ONCE before the season
  - Build roster by filling all required position slots
  - View current roster with all filled positions
  - Edit roster selections ONLY before roster lock deadline
  - **Roster Lock**: Rosters are PERMANENTLY LOCKED once the first game starts
  - After roster lock, NO changes are allowed for the entire season
  - No waiver wire, no trades, no weekly lineup changes
  - Roster deadline is before the first game of the season starts (configurable)
  - Roster validation ensures all positions are filled with eligible players before lock
  - View game-by-game scoring breakdown for each selected player
  - Number of weeks determined by league configuration (1-17 weeks)
  - League players compete with their locked rosters for all configured weeks

### 3. Scoring System
- **PPR Scoring Rules (Individual Player-Based)**
  - **IMPORTANT**: Scoring is based on INDIVIDUAL NFL PLAYER performance
  - Standard PPR (Points Per Reception) scoring (configurable by admin):
    - **Passing**: 1 point per 25 yards (default, configurable)
    - **Passing TD**: 4 points (default, configurable)
    - **Interceptions**: -2 points (default, configurable)
    - **Rushing**: 1 point per 10 yards (default, configurable)
    - **Rushing TD**: 6 points (default, configurable)
    - **Receiving**: 1 point per 10 yards (default, configurable)
    - **Reception**: 1 point per reception (PPR, configurable to 0.5 for Half-PPR or 0 for Standard)
    - **Receiving TD**: 6 points (default, configurable)
    - **Fumbles Lost**: -2 points (default, configurable)
    - **2-Point Conversions**: 2 points (default, configurable)
  - Example: Patrick Mahomes throws 300 yards (12 pts) + 3 TDs (12 pts) + 1 INT (-2 pts) = 22 fantasy points
  - Each NFL player's stats tracked game-by-game throughout the season
  - League player's total score = sum of all their selected NFL players' scores

- **Field Goal Scoring (Configurable by Distance)**
  - Admin can configure points by distance range
  - Default scoring:
    - 0-39 yards: 3 points
    - 40-49 yards: 4 points
    - 50+ yards: 5 points
  - Each league can customize these values
  - Game results track field goal distance for accurate scoring

- **Defensive Scoring (Configurable)**
  - Admin can configure all defensive scoring rules
  - Default defensive scoring:
    - Sacks: 1 point
    - Interceptions: 2 points
    - Fumble Recovery: 2 points
    - Safety: 2 points
    - Defensive/Special Teams TD: 6 points

  - **Points Allowed Scoring Tiers** (configurable):
    - 0 points allowed: 10 points
    - 1-6 points allowed: 7 points
    - 7-13 points allowed: 4 points
    - 14-20 points allowed: 1 point
    - 21-27 points allowed: 0 points
    - 28-34 points allowed: -1 point
    - 35+ points allowed: -4 points

  - **Total Yards Allowed Scoring Tiers** (configurable):
    - 0-99 yards allowed: 10 points
    - 100-199 yards allowed: 7 points
    - 200-299 yards allowed: 5 points
    - 300-349 yards allowed: 3 points
    - 350-399 yards allowed: 0 points
    - 400-449 yards allowed: -3 points
    - 450+ yards allowed: -5 points

  - **Total Defensive Points Calculation**:
    - Sum of: individual defensive plays + points allowed tier + yards allowed tier
    - Example: 3 sacks (3 pts) + 1 INT (2 pts) + 10 points allowed (7 pts) + 250 yards allowed (5 pts) = 17 fantasy points

  - Each league can customize all defensive scoring rules and tiers

- **Weekly Scoring**
  - Each NFL player's performance tracked game-by-game
  - Fantasy points calculated per week for each NFL player
  - League player's weekly total = sum of all roster player scores for that week
  - Cumulative season scoring across all configured weeks
  - Real-time score updates during games (configurable refresh interval)

### 4. League/Game Creation and Configuration
- **Admin League Setup**
  - Admins can create new leagues/games
  - Configure league settings:
    - League name and description
    - Start date and end date
    - Starting NFL week (1-22, default: 1) - which week of NFL season to begin
    - Number of weeks (configurable: 1-17 weeks, default: 4)
    - Validation: startingWeek + numberOfWeeks - 1 ≤ 22 (cannot exceed NFL season including playoffs)
    - **Roster configuration**:
      - Define number of each position required:
        - Quarterbacks (QB): 0-4 (typical: 1)
        - Running Backs (RB): 0-6 (typical: 2-3)
        - Wide Receivers (WR): 0-6 (typical: 2-3)
        - Tight Ends (TE): 0-3 (typical: 1)
        - Kickers (K): 0-2 (typical: 1)
        - Defense/Special Teams (DEF): 0-2 (typical: 1)
        - FLEX (RB/WR/TE): 0-3 (typical: 1)
        - Superflex (QB/RB/WR/TE): 0-2 (typical: 0-1)
      - Total roster size calculated from position counts
      - Validation: At least 1 position slot required
      - Example roster: 1 QB + 2 RB + 2 WR + 1 TE + 1 FLEX + 1 K + 1 DEF = 9 total
    - **Scoring rules configuration**:
      - PPR settings (passing/rushing/receiving yards per point, reception points, TDs, INTs, fumbles)
      - PPR format: Full PPR (1.0), Half PPR (0.5), or Standard (0.0)
      - Field goal scoring by distance (0-39, 40-49, 50+ yards)
      - Defensive scoring rules (sacks, interceptions, fumbles, TDs)
      - Points allowed scoring tiers
      - Yards allowed scoring tiers
    - Pick deadline times for each week
    - Maximum number of league players
    - Public or private league
  - **Configuration Immutability**:
    - ALL league configuration becomes **IMMUTABLE** once the first NFL game of the starting week begins
    - Lock is based on first NFL game start time, NOT league activation time
    - After lock, NO changes allowed to ANY setting:
      - League name and description
      - Starting week and number of weeks
      - Roster configuration (position counts)
      - PPR scoring rules
      - Field goal scoring rules
      - Defensive scoring rules (including points/yards allowed tiers)
      - Pick deadlines
      - Maximum league players
      - Privacy settings (public/private)
    - Lock reason: "FIRST_GAME_STARTED"
    - Attempted modifications after lock throw `ConfigurationLockedException`
    - Configuration remains mutable between league activation and first game start
    - Admin UI displays warning before configuration locks with countdown timer
    - Audit log captures all attempted modifications after lock
  - Admins can activate/deactivate leagues (before first game starts)
  - View all league configurations (including lock status and lock timestamp)
  - Clone settings from previous leagues

  **Example Configurations:**
  - Playoff-focused: startingWeek=15, numberOfWeeks=4 (NFL weeks 15-18)
  - Mid-season challenge: startingWeek=8, numberOfWeeks=6 (NFL weeks 8-13)
  - Full season: startingWeek=1, numberOfWeeks=17 (NFL weeks 1-17)

- **Game Lifecycle**
  - Create new game/season
  - Set starting NFL week (1-18)
  - Set game duration (configurable 1-17 weeks)
  - Configure pick deadlines
  - Start/End game
  - Archive completed games

- **Week Management**
  - Track current NFL week (startingWeek to startingWeek + numberOfWeeks - 1)
  - Each league week maps to specific NFL week
  - Lock picks after deadline for each NFL week
  - Process game results from NFL data for specific weeks
  - Calculate weekly scores based on NFL week games
  - Update standings
  - Weeks dynamically created based on league.startingWeek and league.numberOfWeeks

  **Week Mapping Example:**
  - League: startingWeek=10, numberOfWeeks=4
  - League Week 1 → NFL Week 10
  - League Week 2 → NFL Week 11
  - League Week 3 → NFL Week 12
  - League Week 4 → NFL Week 13

### 5. Leaderboard & Standings
- **Real-time Standings**
  - Current week rankings
  - Overall cumulative scores
  - Team elimination status
  - Points breakdown by week

- **Historical Data**
  - Past game results
  - Player performance history
  - Team selection trends

### 6. Data Integration
- **External Data Sources**
  - NFL game schedules for specific weeks
  - Live game scores for configured NFL weeks
  - Player statistics per NFL week
  - Team standings
  - Near real-time data synchronization
  - Data refresh intervals (configurable)
  - Fetch data only for NFL weeks within league range (startingWeek to startingWeek + numberOfWeeks - 1)

### 7. Admin Tools

- **Super Admin Functions**
  - Invite and create admin accounts
  - Revoke admin access
  - View all admins in the system
  - View all leagues across the system
  - System-wide configuration
  - View system health/status
  - Audit logs and admin activities

- **Admin Functions (League-Scoped)**
  - Create/manage their own leagues
  - Configure league settings
  - Invite players to their leagues
  - View all player picks in their leagues
  - Manual score adjustments for their leagues (if needed)
  - View league health/status
  - Manage league participants

### 8. Authentication & Authorization

- **Envoy Sidecar Security Model**
  - Envoy handles ALL authentication and authorization via External Authorization (ext_authz) filter
  - Custom authentication service validates tokens
  - Supports two authentication methods:
    - Google OAuth JWT tokens for user authentication (users, admins, players)
    - Personal Access Tokens (PATs) for service-to-service communication
  - Envoy calls auth service to validate ALL requests
  - Auth service detects token type and validates accordingly
  - Role-based access control enforced by Envoy based on auth service response
  - Unauthenticated requests blocked at sidecar (401 Unauthorized)
  - Unauthorized role access blocked at sidecar (403 Forbidden)
  - API receives pre-validated requests with user context headers

- **Envoy Authentication Plugin Architecture**
  - Envoy ext_authz filter configured to call authentication service
  - Authentication service runs in same pod (localhost:9191)
  - For each request, Envoy extracts Authorization header and calls auth service
  - Auth service detects token type:
    - Token starts with `pat_` prefix → PAT validation
    - Otherwise → Google JWT validation
  - Auth service returns HTTP 200 (authorized) with headers or HTTP 403 (forbidden)
  - Envoy forwards request to API only if auth service approves

- **Google OAuth Authentication Flow (Human Users)**
  1. User authenticates with Google Sign-In (frontend)
  2. Frontend receives Google JWT token
  3. Client sends request with Google JWT in Authorization header: `Bearer <google-jwt>`
  4. Envoy calls auth service with the token
  5. Auth service validates Google JWT signature using Google's public keys
  6. Auth service validates JWT expiration and issuer (accounts.google.com)
  7. Auth service extracts user email/Google ID from JWT claims
  8. Auth service queries database to find User by googleId and get role
  9. Auth service returns HTTP 200 with headers: X-User-Id, X-User-Email, X-User-Role, X-Google-Id
  10. Envoy checks role against endpoint requirements
  11. If authorized, Envoy forwards request to API with user context headers
  12. API processes pre-authenticated request

- **User Account Creation Flow**
  1. Admin sends invitation to player email for specific league
  2. Player receives invitation link
  3. Player clicks link and authenticates with Google OAuth
  4. System checks if user exists by Google ID
  5. If new user: create account with Google ID, email, name from Google profile
  6. Link player to the specific league they were invited to
  7. Player can now access league with Google authentication

- **PAT Authentication Flow (Service-to-Service)**
  1. Service sends request with PAT in Authorization header: `Bearer pat_<token>`
  2. Envoy calls auth service with the PAT
  3. Auth service detects PAT prefix (`pat_`)
  4. Auth service hashes the PAT and queries PersonalAccessToken table
  5. Auth service validates PAT is not expired and not revoked
  6. Auth service extracts PAT scope and service identifier
  7. Auth service returns HTTP 200 with headers: X-Service-Id, X-PAT-Scope, X-PAT-Id
  8. Auth service updates lastUsedAt timestamp for PAT
  9. Envoy checks PAT scope against endpoint requirements
  10. If authorized, Envoy forwards request to API with service context headers
  11. API processes pre-authenticated service request

- **Endpoint Security Requirements**
  - `/api/v1/superadmin/*` - Requires SUPER_ADMIN role OR PAT with ADMIN scope (enforced by Envoy)
  - `/api/v1/admin/*` - Requires ADMIN/SUPER_ADMIN role OR PAT with WRITE/ADMIN scope (enforced by Envoy)
  - `/api/v1/player/*` - Requires any authenticated user OR PAT with any scope (enforced by Envoy)
  - `/api/v1/public/*` - No authentication required
  - `/api/v1/service/*` - Requires valid PAT only (service-to-service endpoints)

- **Authorization Rules**
  - SUPER_ADMIN: Full system access, all endpoints
  - ADMIN: League-scoped access, can only manage their own leagues
  - PLAYER: Read-only league data, write access only to their own picks
  - Endpoint-level role validation by Envoy
  - Resource ownership validation in API business logic
  - Token refresh mechanism handled by Envoy

## Technical Requirements

### API Design
- **RESTful API**
  - Standard HTTP methods (GET, POST, PUT, DELETE)
  - JSON request/response format
  - Versioned endpoints (/api/v1/...)
  - Consistent error handling
  - API documentation (OpenAPI/Swagger)

- **API Deployment Model**
  - Three services in the same Kubernetes pod:
    1. Main API (localhost:8080) - Business logic
    2. Auth Service (localhost:9191) - Token validation for Envoy
    3. Envoy Sidecar (pod IP:443) - External entry point
  - Main API listens ONLY on localhost:8080 (not externally accessible)
  - Auth service listens ONLY on localhost:9191 (called by Envoy ext_authz)
  - Envoy sidecar listens on pod IP (externally accessible)
  - All external requests go through Envoy → Auth Service → Main API
  - Network policies prevent direct API/Auth service access
  - API and Auth service completely protected behind Envoy proxy
  - No way to bypass Envoy authentication/authorization

### Hexagonal Architecture Layers
- **Domain Layer**
  - Game aggregate
  - Player aggregate
  - Team selection value objects
  - Scoring domain logic
  - Elimination rules
  - Domain events
  - Repository interfaces (ports)

- **Application Layer**
  - Use cases for all features
  - DTOs for data transfer
  - Application services
  - Transaction boundaries
  - Event handlers

- **Infrastructure Layer**
  - REST controllers
  - Repository implementations
  - External data source adapters
  - Database persistence
  - Envoy integration
  - Scheduled data synchronization jobs

### Data Model
- **Entities**
  - User (with role: SUPER_ADMIN, ADMIN, PLAYER; includes googleId, email, name)
  - League/Game (owned by an admin; includes startingWeek, numberOfWeeks, rosterConfiguration, scoringRules)
  - LeaguePlayer (junction table: league membership, league-scoped player role)
  - **NFLTeam** (32 NFL teams: name, abbreviation, conference, division)
  - **NFLPlayer** (individual NFL players: firstName, lastName, position, nflTeam, jerseyNumber, status)
  - **Position** (enum: QB, RB, WR, TE, K, DEF)
  - **RosterSlot** (roster position definition: position, count, eligiblePositions for FLEX/Superflex)
  - **RosterConfiguration** (defines league roster structure: list of RosterSlots, total size)
  - **Roster** (league player's roster: leaguePlayerId, list of RosterSelections)
  - **RosterSelection** (NFL player selection for specific roster slot: rosterSlot, nflPlayer, week)
  - **PlayerStats** (individual NFL player statistics per game: nflPlayerId, nflWeek, gameId, passing/rushing/receiving stats)
  - **DefensiveStats** (team defense statistics per game: nflTeamId, nflWeek, gameId, sacks, INTs, points/yards allowed)
  - Week (league week with nflWeekNumber mapping)
  - Score (calculated per league player per NFL week per league)
  - NFLGame (NFL game schedule and outcomes: homeTeam, awayTeam, week, gameTime, result)
  - AdminInvitation (super admin → admin)
  - PlayerInvitation (admin → player for specific league, includes leagueId)
  - LeagueConfiguration (includes startingWeek, numberOfWeeks, rosterConfiguration, scoringRules)
  - PersonalAccessToken (stored in database: id, name, tokenHash, scope, expiresAt, createdBy, createdAt, lastUsedAt, revoked, revokedAt)
  - PATScope (READ_ONLY, WRITE, ADMIN)
  - AuditLog (for admin and PAT activity tracking)

- **Value Objects (Scoring Configuration)**
  - ScoringRules (contains all scoring configuration for a league)
  - FieldGoalScoringRules (fg0to39Points, fg40to49Points, fg50PlusPoints)
  - DefensiveScoringRules (sackPoints, interceptionPoints, fumbleRecoveryPoints, safetyPoints, defensiveTDPoints, pointsAllowedTiers, yardsAllowedTiers)
  - PPRScoringRules (passingYardsPerPoint, rushingYardsPerPoint, receivingYardsPerPoint, receptionPoints, touchdownPoints)

- **Key Relationships**
  - User has role (SUPER_ADMIN, ADMIN, PLAYER)
  - User authenticated via Google OAuth (googleId)
  - Admin owns multiple Leagues
  - League has configurable startingWeek (1-22, default 1) and numberOfWeeks (1-17, default 4)
  - League validation: startingWeek + numberOfWeeks - 1 ≤ 22
  - League has RosterConfiguration defining required positions
  - League has multiple LeaguePlayers (junction table)
  - LeaguePlayer links User to League with league-specific data
  - LeaguePlayer has one Roster
  - Roster contains multiple RosterSelections (one per roster slot)
  - RosterSelection links RosterSlot to NFLPlayer
  - NFLPlayer has Position (QB, RB, WR, TE, K, DEF)
  - NFLPlayer belongs to NFLTeam
  - PlayerStats tracks individual NFL player performance per game/week
  - DefensiveStats tracks team defense performance per game/week
  - Players can belong to multiple leagues
  - PlayerInvitation is league-scoped (includes leagueId)
  - Week entity maps league week to NFL week (nflWeekNumber)
  - Week count is dynamic based on league.numberOfWeeks
  - NFL data fetched for weeks in range [startingWeek, startingWeek + numberOfWeeks - 1]

### Non-Functional Requirements
- **Performance**
  - API response time < 500ms
  - Support concurrent users
  - Efficient database queries

- **Reliability**
  - Data consistency
  - Transaction management
  - Error recovery

- **Security**
  - Secure authentication via Envoy
  - Role-based access control (RBAC)
  - Resource ownership validation
  - Input validation
  - SQL injection prevention
  - Rate limiting
  - Audit logging for admin actions

- **Scalability**
  - Horizontal scaling capability
  - Stateless API design
  - Database connection pooling

## Technology Stack
- **Language**: Java (Spring Boot)
- **Framework**: Spring Boot, Spring Data MongoDB
- **Database**: MongoDB 6+
- **Authentication**:
  - Google OAuth 2.0 for user authentication
  - Personal Access Tokens (PATs) for service-to-service
  - Envoy sidecar with ext_authz filter
  - Custom auth service for token validation
- **Build Tool**: Gradle or Maven
- **Testing**: JUnit, Mockito, Spring Test
- **Container Orchestration**: Kubernetes
- **Proxy**: Envoy sidecar

## Initial Deliverables
1. Gherkin feature files for all core features
2. Project structure following hexagonal architecture
3. Domain model with entities and value objects
4. Application services and use cases
5. Main REST API endpoints (accessible only via Envoy on localhost:8080)
6. Authentication service (token validation on localhost:9191)
7. Data integration layer
8. Three-tier role system (SUPER_ADMIN, ADMIN, PLAYER)
9. Google OAuth 2.0 integration for user authentication
10. Super admin capabilities for admin management
11. Admin invitation system (super admin → admin via Google OAuth)
12. Player invitation system (admin → player for specific league via Google OAuth)
13. League-scoped player membership (LeaguePlayer junction table)
14. Personal Access Token (PAT) system for service-to-service authentication
15. PAT database storage (PersonalAccessToken table with bcrypt hashing)
16. Bootstrap PAT setup script for initial system configuration
17. Database migrations for all entities including PersonalAccessToken
18. Envoy ext_authz configuration calling auth service
19. Auth service detects and validates both Google JWT and PAT tokens
20. Envoy configuration for role-based access control
21. Super admin bootstrap mechanism (via bootstrap PAT)
22. Three-service pod deployment (API + Auth Service + Envoy)
23. Audit logging for admin and PAT activities
24. Setup documentation for bootstrap PAT and initial super admin creation
