# FFL Playoffs Game - Requirements

## Overview
A Fantasy Football League playoff game where players pick teams for 4 weeks. If a player's chosen team loses, that team no longer earns points for the remainder of the game. Uses standard PPR (Points Per Reception) scoring rules.

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
   - Can make team selections
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

### 2. Team Selection
- **Weekly Team Picks**
  - Players select one NFL team per week for 4 weeks
  - Cannot select the same team twice across all 4 weeks
  - Selection deadline before games start each week
  - View available teams for selection
  - Edit picks before deadline

### 3. Scoring System
- **PPR Scoring Rules**
  - Standard PPR (Points Per Reception) scoring
  - Touchdowns: 6 points
  - Receptions: 1 point per reception
  - Passing yards: 1 point per 25 yards
  - Rushing/Receiving yards: 1 point per 10 yards
  - Field Goals: 3 points
  - Extra Points: 1 point
  - Two-Point Conversions: 2 points
  - Defensive/Special Teams scoring

- **Elimination Rules**
  - If a player's selected team loses, that team is "eliminated"
  - Eliminated teams score ZERO points for all remaining weeks
  - Player can still pick other non-eliminated teams in future weeks
  - Track team win/loss status per week

### 4. League/Game Creation and Configuration
- **Admin League Setup**
  - Admins can create new leagues/games
  - Configure league settings:
    - League name and description
    - Start date and end date
    - Number of weeks (default: 4)
    - Scoring rules (PPR settings)
    - Pick deadline times for each week
    - Maximum number of players
    - Public or private league
  - Admins can modify settings before game starts
  - Critical settings locked once game becomes active
  - Admins can activate/deactivate leagues
  - View all league configurations
  - Clone settings from previous leagues

- **Game Lifecycle**
  - Create new game/season
  - Set game duration (4 weeks)
  - Configure pick deadlines
  - Start/End game
  - Archive completed games

- **Week Management**
  - Track current week (1-4)
  - Lock picks after deadline
  - Process game results
  - Calculate weekly scores
  - Update standings

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
  - NFL game schedules
  - Live game scores
  - Player statistics
  - Team standings
  - Near real-time data synchronization
  - Data refresh intervals (configurable)

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
  - League/Game (owned by an admin)
  - LeaguePlayer (junction table: league membership, league-scoped player role)
  - Team (NFL teams)
  - Week
  - TeamSelection (player's team pick for a week in a league)
  - Score (calculated per player per week per league)
  - GameResult (NFL game outcomes)
  - AdminInvitation (super admin → admin)
  - PlayerInvitation (admin → player for specific league, includes leagueId)
  - LeagueConfiguration
  - PersonalAccessToken (stored in database: id, name, tokenHash, scope, expiresAt, createdBy, createdAt, lastUsedAt, revoked, revokedAt)
  - PATScope (READ_ONLY, WRITE, ADMIN)
  - AuditLog (for admin and PAT activity tracking)

- **Key Relationships**
  - User has role (SUPER_ADMIN, ADMIN, PLAYER)
  - User authenticated via Google OAuth (googleId)
  - Admin owns multiple Leagues
  - League has multiple LeaguePlayers (junction table)
  - LeaguePlayer links User to League with league-specific data
  - Players can belong to multiple leagues
  - PlayerInvitation is league-scoped (includes leagueId)
  - TeamSelections are league-scoped (player picks team for league)

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
- **Framework**: Spring Boot, Spring Data JPA
- **Database**: PostgreSQL (recommended)
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
