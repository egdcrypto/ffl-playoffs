# FFL Playoffs API Documentation

## Table of Contents
1. [Overview](#overview)
2. [API Architecture](#api-architecture)
3. [Authentication](#authentication)
4. [Endpoint Structure](#endpoint-structure)
5. [API Endpoints](#api-endpoints)
6. [Request/Response Examples](#requestresponse-examples)
7. [Error Handling](#error-handling)
8. [Webhooks & Events](#webhooks--events)

## Overview

The FFL Playoffs API is a RESTful HTTP API that provides:
- **Versioned endpoints** (`/api/v1/...`)
- **JSON request/response** format
- **Role-based access control** via Envoy sidecar
- **OpenAPI/Swagger documentation** at `/swagger-ui.html`

**Base URL**: `https://<pod-ip>/api/v1`

**All API access goes through Envoy sidecar** - the API is NOT directly accessible.

## API Architecture

### Three-Service Pod Model

```
┌────────────────────────────────────────────────────────────┐
│                      Kubernetes Pod                         │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │              Envoy Sidecar (Port 443)                │  │
│  │         External Entry Point (Pod IP:443)            │  │
│  └─────────────┬───────────────────────┬────────────────┘  │
│                │ ext_authz call        │ Forward request   │
│                ↓                       ↓                   │
│  ┌──────────────────────┐   ┌──────────────────────────┐  │
│  │   Auth Service       │   │    Main API              │  │
│  │  (localhost:9191)    │   │  (localhost:8080)        │  │
│  │                      │   │                          │  │
│  │ - Validate tokens    │   │ - Business logic         │  │
│  │ - Google JWT         │   │ - Domain services        │  │
│  │ - PAT validation     │   │ - Data persistence       │  │
│  └──────────────────────┘   └──────────────────────────┘  │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

### Request Flow

```
1. Client → HTTPS Request with Authorization header
              ↓
2. Envoy → Receives request on pod IP:443
              ↓
3. Envoy → Calls Auth Service (localhost:9191) via ext_authz
              ↓
4. Auth Service → Validates token (Google JWT or PAT)
                → Queries database for user/role
                → Returns 200 OK with headers OR 403 Forbidden
              ↓
5. Envoy → Checks role against endpoint requirements
         → If authorized, forwards to API (localhost:8080)
         → If not authorized, returns 403
              ↓
6. Main API → Receives pre-authenticated request
            → Extracts user context from headers
            → Processes business logic
            → Returns response
              ↓
7. Envoy → Forwards response to client
```

## Authentication

### Supported Authentication Methods

#### 1. Google OAuth JWT (Human Users)

**Header Format**:
```
Authorization: Bearer <google-jwt-token>
```

**Token Validation Flow**:
1. Client obtains Google JWT via Google Sign-In
2. Client sends request with JWT in Authorization header
3. Envoy calls Auth Service
4. Auth Service:
   - Validates JWT signature using Google's public keys
   - Validates expiration and issuer (accounts.google.com)
   - Extracts email and Google ID from JWT claims
   - Queries database to find User by googleId
   - Retrieves user role (SUPER_ADMIN, ADMIN, PLAYER)
   - Returns HTTP 200 with headers: `X-User-Id`, `X-User-Email`, `X-User-Role`, `X-Google-Id`
5. Envoy checks role against endpoint requirements
6. If authorized, forwards to API with user context headers

**User Context Headers** (added by Envoy):
```
X-User-Id: 12345
X-User-Email: user@example.com
X-User-Role: ADMIN
X-Google-Id: google-oauth2|123456789
```

#### 2. Personal Access Tokens (PAT) - Service-to-Service

**Header Format**:
```
Authorization: Bearer pat_<random-token-string>
```

**Token Validation Flow**:
1. Service sends request with PAT (prefix `pat_`)
2. Envoy calls Auth Service
3. Auth Service:
   - Detects PAT prefix
   - Hashes the PAT using bcrypt
   - Queries PersonalAccessToken table
   - Validates token not expired and not revoked
   - Extracts PAT scope (READ_ONLY, WRITE, ADMIN)
   - Updates lastUsedAt timestamp
   - Returns HTTP 200 with headers: `X-Service-Id`, `X-PAT-Scope`, `X-PAT-Id`
4. Envoy checks PAT scope against endpoint requirements
5. If authorized, forwards to API with service context headers

**Service Context Headers** (added by Envoy):
```
X-Service-Id: analytics-service
X-PAT-Scope: READ_ONLY
X-PAT-Id: 789
```

### Endpoint Security Requirements

| Endpoint Pattern          | Required Role/Scope                          | Description                |
|---------------------------|----------------------------------------------|----------------------------|
| `/api/v1/superadmin/*`    | SUPER_ADMIN OR PAT:ADMIN                     | Super admin operations     |
| `/api/v1/admin/*`         | ADMIN, SUPER_ADMIN OR PAT:WRITE/ADMIN        | Admin league management    |
| `/api/v1/player/*`        | Any authenticated user OR any PAT            | Player operations          |
| `/api/v1/public/*`        | No authentication required                   | Public data                |
| `/api/v1/service/*`       | Valid PAT only                               | Service-to-service only    |

**Authorization Enforcement**:
- Enforced by Envoy at the proxy layer
- API receives only pre-authorized requests
- Resource ownership validated in API business logic

## Endpoint Structure

### Versioning
All endpoints are versioned: `/api/v1/...`

### Naming Conventions
- Plural nouns for collections: `/leagues`, `/players`
- Resource IDs in path: `/leagues/{leagueId}`
- Actions as HTTP verbs: GET, POST, PUT, DELETE
- Sub-resources: `/leagues/{leagueId}/players`

## API Endpoints

### Public Endpoints (No Auth Required)

#### Health Check
```http
GET /api/v1/public/health
```
**Response**:
```json
{
  "status": "UP",
  "version": "1.0.0",
  "timestamp": "2025-10-01T12:00:00Z"
}
```

---

### Super Admin Endpoints

#### List All Admins
```http
GET /api/v1/superadmin/admins
```
**Auth**: SUPER_ADMIN or PAT:ADMIN

**Response**:
```json
{
  "admins": [
    {
      "id": 1,
      "email": "admin1@example.com",
      "name": "John Admin",
      "createdAt": "2025-09-01T10:00:00Z",
      "active": true
    }
  ]
}
```

#### Invite Admin
```http
POST /api/v1/superadmin/admins/invitations
```
**Auth**: SUPER_ADMIN

**Request**:
```json
{
  "email": "newadmin@example.com",
  "message": "You've been invited to be an admin"
}
```

**Response**:
```json
{
  "invitationId": "uuid-here",
  "email": "newadmin@example.com",
  "invitationUrl": "https://app.ffl-playoffs.com/accept-admin-invite?token=xyz",
  "expiresAt": "2025-10-08T12:00:00Z"
}
```

#### Create Personal Access Token (PAT)
```http
POST /api/v1/superadmin/pats
```
**Auth**: SUPER_ADMIN

**Request**:
```json
{
  "name": "analytics-service-token",
  "scope": "READ_ONLY",
  "expiresInDays": 365
}
```

**Response** (token shown only once):
```json
{
  "id": 123,
  "name": "analytics-service-token",
  "token": "pat_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6",
  "scope": "READ_ONLY",
  "createdAt": "2025-10-01T12:00:00Z",
  "expiresAt": "2026-10-01T12:00:00Z",
  "warning": "Save this token - it will not be shown again"
}
```

#### List All PATs
```http
GET /api/v1/superadmin/pats
```
**Auth**: SUPER_ADMIN

**Response**:
```json
{
  "tokens": [
    {
      "id": 123,
      "name": "analytics-service-token",
      "scope": "READ_ONLY",
      "createdAt": "2025-10-01T12:00:00Z",
      "lastUsedAt": "2025-10-01T14:30:00Z",
      "expiresAt": "2026-10-01T12:00:00Z",
      "revoked": false
    }
  ]
}
```

#### Revoke PAT
```http
DELETE /api/v1/superadmin/pats/{patId}
```
**Auth**: SUPER_ADMIN

**Response**: 204 No Content

#### View All Leagues (System-Wide)
```http
GET /api/v1/superadmin/leagues
```
**Auth**: SUPER_ADMIN

**Response**:
```json
{
  "leagues": [
    {
      "id": 1,
      "name": "2025 NFL Playoffs Pool",
      "adminId": 5,
      "adminEmail": "admin@example.com",
      "startingWeek": 15,
      "numberOfWeeks": 4,
      "active": true,
      "playerCount": 12,
      "createdAt": "2025-09-15T10:00:00Z"
    }
  ]
}
```

---

### Admin Endpoints

#### Create League
```http
POST /api/v1/admin/leagues
```
**Auth**: ADMIN or SUPER_ADMIN

**Request**:
```json
{
  "name": "2025 NFL Playoffs Pool",
  "description": "Our annual playoff pool",
  "startingWeek": 15,
  "numberOfWeeks": 4,
  "isPublic": false,
  "scoringRules": {
    "pprRules": {
      "passingYardsPerPoint": 25,
      "rushingYardsPerPoint": 10,
      "receivingYardsPerPoint": 10,
      "receptionPoints": 1,
      "touchdownPoints": 6
    },
    "fieldGoalRules": {
      "fg0to39Points": 3,
      "fg40to49Points": 4,
      "fg50PlusPoints": 5
    },
    "defensiveRules": {
      "sackPoints": 1,
      "interceptionPoints": 2,
      "fumbleRecoveryPoints": 2,
      "safetyPoints": 2,
      "defensiveTDPoints": 6,
      "pointsAllowedTiers": [
        {"min": 0, "max": 0, "points": 10},
        {"min": 1, "max": 6, "points": 7},
        {"min": 7, "max": 13, "points": 4},
        {"min": 14, "max": 20, "points": 1},
        {"min": 21, "max": 27, "points": 0},
        {"min": 28, "max": 34, "points": -1},
        {"min": 35, "max": null, "points": -4}
      ],
      "yardsAllowedTiers": [
        {"min": 0, "max": 99, "points": 10},
        {"min": 100, "max": 199, "points": 7},
        {"min": 200, "max": 299, "points": 5},
        {"min": 300, "max": 349, "points": 3},
        {"min": 350, "max": 399, "points": 0},
        {"min": 400, "max": 449, "points": -3},
        {"min": 450, "max": null, "points": -5}
      ]
    }
  }
}
```

**Response**:
```json
{
  "id": 1,
  "name": "2025 NFL Playoffs Pool",
  "adminId": 5,
  "startingWeek": 15,
  "numberOfWeeks": 4,
  "weeks": [
    {"leagueWeek": 1, "nflWeek": 15},
    {"leagueWeek": 2, "nflWeek": 16},
    {"leagueWeek": 3, "nflWeek": 17},
    {"leagueWeek": 4, "nflWeek": 18}
  ],
  "active": false,
  "createdAt": "2025-10-01T12:00:00Z"
}
```

**Validation Errors**:
```json
{
  "error": "INVALID_LEAGUE_CONFIGURATION",
  "message": "startingWeek + numberOfWeeks - 1 must be ≤ 18",
  "details": {
    "startingWeek": 17,
    "numberOfWeeks": 4,
    "maxWeek": 20,
    "allowed": 18
  }
}
```

#### Get League Details
```http
GET /api/v1/admin/leagues/{leagueId}
```
**Auth**: ADMIN (owns league) or SUPER_ADMIN

**Response**:
```json
{
  "id": 1,
  "name": "2025 NFL Playoffs Pool",
  "description": "Our annual playoff pool",
  "adminId": 5,
  "startingWeek": 15,
  "numberOfWeeks": 4,
  "currentWeek": 16,
  "active": true,
  "scoringRules": { /* ... */ },
  "playerCount": 12,
  "createdAt": "2025-09-15T10:00:00Z"
}
```

#### Update League Configuration
```http
PUT /api/v1/admin/leagues/{leagueId}/configuration
```
**Auth**: ADMIN (owns league)

**Note**: `startingWeek` and `numberOfWeeks` cannot be changed once league is active.

**Request**:
```json
{
  "name": "Updated League Name",
  "description": "Updated description",
  "scoringRules": { /* updated rules */ }
}
```

**Response**: Updated league object

#### Activate League
```http
POST /api/v1/admin/leagues/{leagueId}/activate
```
**Auth**: ADMIN (owns league)

**Response**: 200 OK

#### Invite Player to League
```http
POST /api/v1/admin/leagues/{leagueId}/invitations
```
**Auth**: ADMIN (owns league)

**Request**:
```json
{
  "email": "player@example.com",
  "message": "Join our playoff pool!"
}
```

**Response**:
```json
{
  "invitationId": "uuid-here",
  "leagueId": 1,
  "email": "player@example.com",
  "invitationUrl": "https://app.ffl-playoffs.com/accept-invite?token=xyz",
  "expiresAt": "2025-10-08T12:00:00Z"
}
```

#### List League Players
```http
GET /api/v1/admin/leagues/{leagueId}/players
```
**Auth**: ADMIN (owns league)

**Response**:
```json
{
  "players": [
    {
      "id": 10,
      "email": "player1@example.com",
      "name": "John Player",
      "joinedAt": "2025-09-20T10:00:00Z",
      "teamSelections": 4,
      "totalScore": 342.5
    }
  ]
}
```

#### View All Player Selections (Admin View)
```http
GET /api/v1/admin/leagues/{leagueId}/selections
```
**Auth**: ADMIN (owns league)

**Response**:
```json
{
  "selections": [
    {
      "playerId": 10,
      "playerName": "John Player",
      "week": 1,
      "nflWeek": 15,
      "team": "Kansas City Chiefs",
      "eliminated": false,
      "score": 87.5
    }
  ]
}
```

---

### Player Endpoints

#### Accept Invitation
```http
POST /api/v1/player/invitations/accept
```
**Auth**: Google OAuth (new user)

**Request**:
```json
{
  "invitationToken": "xyz-token-from-email"
}
```

**Response**:
```json
{
  "userId": 10,
  "leagueId": 1,
  "leagueName": "2025 NFL Playoffs Pool",
  "message": "Successfully joined league"
}
```

#### Get My Leagues
```http
GET /api/v1/player/leagues
```
**Auth**: Authenticated user

**Response**:
```json
{
  "leagues": [
    {
      "id": 1,
      "name": "2025 NFL Playoffs Pool",
      "adminName": "John Admin",
      "currentWeek": 2,
      "myRank": 3,
      "myScore": 142.5,
      "playerCount": 12
    }
  ]
}
```

#### Make Team Selection
```http
POST /api/v1/player/leagues/{leagueId}/selections
```
**Auth**: Authenticated user (member of league)

**Request**:
```json
{
  "week": 1,
  "teamName": "Kansas City Chiefs"
}
```

**Response**:
```json
{
  "id": 123,
  "playerId": 10,
  "leagueId": 1,
  "week": 1,
  "nflWeek": 15,
  "teamName": "Kansas City Chiefs",
  "eliminated": false,
  "locked": false,
  "createdAt": "2025-10-01T12:00:00Z"
}
```

**Validation Errors**:
```json
{
  "error": "TEAM_ALREADY_SELECTED",
  "message": "You have already selected Kansas City Chiefs in week 2",
  "details": {
    "teamName": "Kansas City Chiefs",
    "previousWeek": 2
  }
}
```

```json
{
  "error": "SELECTION_DEADLINE_PASSED",
  "message": "Selection deadline for week 1 has passed",
  "details": {
    "week": 1,
    "deadline": "2025-10-01T12:00:00Z",
    "currentTime": "2025-10-01T13:00:00Z"
  }
}
```

#### Get My Selections
```http
GET /api/v1/player/leagues/{leagueId}/selections
```
**Auth**: Authenticated user (member of league)

**Response**:
```json
{
  "selections": [
    {
      "week": 1,
      "nflWeek": 15,
      "teamName": "Kansas City Chiefs",
      "eliminated": false,
      "score": 87.5,
      "gameStatus": "FINAL"
    },
    {
      "week": 2,
      "nflWeek": 16,
      "teamName": "Buffalo Bills",
      "eliminated": false,
      "score": 55.0,
      "gameStatus": "FINAL"
    }
  ],
  "eliminatedTeams": [],
  "availableTeams": [
    "San Francisco 49ers",
    "Philadelphia Eagles",
    // ... all teams not yet selected
  ]
}
```

#### Get Leaderboard
```http
GET /api/v1/player/leagues/{leagueId}/leaderboard
```
**Auth**: Authenticated user (member of league)

**Response**:
```json
{
  "leaderboard": [
    {
      "rank": 1,
      "playerId": 15,
      "playerName": "Jane Player",
      "totalScore": 342.5,
      "weeklyScores": [87.5, 92.0, 85.0, 78.0],
      "eliminatedTeams": 0
    },
    {
      "rank": 2,
      "playerId": 10,
      "playerName": "John Player",
      "totalScore": 320.0,
      "weeklyScores": [75.0, 88.5, 92.5, 64.0],
      "eliminatedTeams": 1
    }
  ],
  "myRank": 5,
  "totalPlayers": 12
}
```

#### Get Score Breakdown
```http
GET /api/v1/player/leagues/{leagueId}/scores/{weekNumber}
```
**Auth**: Authenticated user (member of league)

**Response**:
```json
{
  "playerId": 10,
  "week": 1,
  "nflWeek": 15,
  "teamName": "Kansas City Chiefs",
  "totalScore": 87.5,
  "breakdown": {
    "passingYards": {"value": 300, "points": 12.0},
    "rushingYards": {"value": 120, "points": 12.0},
    "receivingYards": {"value": 250, "points": 25.0},
    "receptions": {"value": 20, "points": 20.0},
    "touchdowns": {"value": 3, "points": 18.0},
    "fieldGoals": {"value": 2, "points": 6.0},
    "extraPoints": {"value": 3, "points": 3.0},
    "defensive": {
      "sacks": {"value": 2, "points": 2.0},
      "interceptions": {"value": 1, "points": 2.0},
      "pointsAllowed": {"value": 10, "points": 7.0},
      "yardsAllowed": {"value": 280, "points": 5.0},
      "total": 16.0
    }
  },
  "eliminated": false
}
```

---

### Service Endpoints (PAT Only)

#### Bulk Fetch Scores (Analytics)
```http
GET /api/v1/service/scores?leagueId=1&week=2
```
**Auth**: PAT (READ_ONLY or higher)

**Response**:
```json
{
  "leagueId": 1,
  "week": 2,
  "scores": [
    {
      "playerId": 10,
      "teamName": "Buffalo Bills",
      "score": 55.0,
      "eliminated": false
    }
    // ... all players
  ]
}
```

---

## Request/Response Examples

### Complete Team Selection Flow

#### 1. Player Logs In with Google
Frontend handles Google OAuth and obtains JWT.

#### 2. Get Available Teams for Week
```bash
curl -X GET https://api.ffl-playoffs.com/api/v1/player/leagues/1/selections \
  -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
```

**Response**:
```json
{
  "selections": [],
  "eliminatedTeams": [],
  "availableTeams": [
    "Kansas City Chiefs",
    "Buffalo Bills",
    "San Francisco 49ers",
    // ... all 32 NFL teams
  ]
}
```

#### 3. Make Team Selection
```bash
curl -X POST https://api.ffl-playoffs.com/api/v1/player/leagues/1/selections \
  -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..." \
  -H "Content-Type: application/json" \
  -d '{
    "week": 1,
    "teamName": "Kansas City Chiefs"
  }'
```

**Response**:
```json
{
  "id": 123,
  "playerId": 10,
  "leagueId": 1,
  "week": 1,
  "nflWeek": 15,
  "teamName": "Kansas City Chiefs",
  "eliminated": false,
  "locked": false,
  "createdAt": "2025-10-01T12:00:00Z"
}
```

#### 4. View Leaderboard After Week Completes
```bash
curl -X GET https://api.ffl-playoffs.com/api/v1/player/leagues/1/leaderboard \
  -H "Authorization: Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9..."
```

### Service-to-Service with PAT

```bash
curl -X GET https://api.ffl-playoffs.com/api/v1/service/scores?leagueId=1&week=2 \
  -H "Authorization: Bearer pat_a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6"
```

## Error Handling

### Standard Error Response Format

```json
{
  "error": "ERROR_CODE",
  "message": "Human-readable error message",
  "details": {
    // Additional context-specific details
  },
  "timestamp": "2025-10-01T12:00:00Z",
  "path": "/api/v1/player/leagues/1/selections"
}
```

### HTTP Status Codes

| Status | Meaning                | When Used                                      |
|--------|------------------------|------------------------------------------------|
| 200    | OK                     | Successful GET, PUT                            |
| 201    | Created                | Successful POST creating new resource          |
| 204    | No Content             | Successful DELETE                              |
| 400    | Bad Request            | Invalid request body or parameters             |
| 401    | Unauthorized           | Missing or invalid authentication token        |
| 403    | Forbidden              | Valid token but insufficient permissions       |
| 404    | Not Found              | Resource does not exist                        |
| 409    | Conflict               | Business rule violation (duplicate selection)  |
| 422    | Unprocessable Entity   | Validation error                               |
| 500    | Internal Server Error  | Unexpected server error                        |
| 503    | Service Unavailable    | External dependency (NFL API) unavailable      |

### Common Error Codes

#### Authentication Errors (401)
```json
{
  "error": "INVALID_TOKEN",
  "message": "Google JWT signature validation failed"
}
```

```json
{
  "error": "TOKEN_EXPIRED",
  "message": "Authentication token has expired"
}
```

```json
{
  "error": "PAT_REVOKED",
  "message": "Personal Access Token has been revoked"
}
```

#### Authorization Errors (403)
```json
{
  "error": "INSUFFICIENT_PERMISSIONS",
  "message": "ADMIN role required for this endpoint"
}
```

```json
{
  "error": "NOT_LEAGUE_OWNER",
  "message": "You do not own this league",
  "details": {
    "leagueId": 1,
    "ownerId": 5,
    "yourId": 10
  }
}
```

#### Business Logic Errors (409)
```json
{
  "error": "TEAM_ALREADY_SELECTED",
  "message": "You have already selected this team in a previous week",
  "details": {
    "teamName": "Kansas City Chiefs",
    "previousWeek": 2,
    "attemptedWeek": 4
  }
}
```

```json
{
  "error": "SELECTION_DEADLINE_PASSED",
  "message": "Selection deadline for this week has passed",
  "details": {
    "week": 1,
    "deadline": "2025-10-01T12:00:00Z",
    "currentTime": "2025-10-01T13:00:00Z"
  }
}
```

#### Validation Errors (422)
```json
{
  "error": "VALIDATION_ERROR",
  "message": "Request validation failed",
  "details": {
    "field": "startingWeek",
    "error": "must be between 1 and 18",
    "provided": 20
  }
}
```

```json
{
  "error": "INVALID_LEAGUE_CONFIGURATION",
  "message": "startingWeek + numberOfWeeks - 1 cannot exceed 18",
  "details": {
    "startingWeek": 17,
    "numberOfWeeks": 4,
    "calculatedMaxWeek": 20,
    "allowed": 18
  }
}
```

## Webhooks & Events

### Event Types

The system emits domain events that can trigger webhooks:

#### TeamEliminatedEvent
```json
{
  "eventType": "TEAM_ELIMINATED",
  "timestamp": "2025-10-01T16:30:00Z",
  "data": {
    "playerId": 10,
    "leagueId": 1,
    "teamName": "Kansas City Chiefs",
    "week": 2,
    "nflWeek": 16
  }
}
```

#### ScoreCalculatedEvent
```json
{
  "eventType": "SCORE_CALCULATED",
  "timestamp": "2025-10-01T23:00:00Z",
  "data": {
    "playerId": 10,
    "leagueId": 1,
    "week": 2,
    "score": 87.5
  }
}
```

### Webhook Configuration

Admins can configure webhooks for their leagues:

```http
POST /api/v1/admin/leagues/{leagueId}/webhooks
```

**Request**:
```json
{
  "url": "https://your-service.com/webhooks/ffl-playoffs",
  "events": ["TEAM_ELIMINATED", "SCORE_CALCULATED"],
  "secret": "your-webhook-secret"
}
```

Webhooks are signed with HMAC-SHA256 using the provided secret:
```
X-FFL-Signature: sha256=<hmac-signature>
```

## Rate Limiting

API enforced by Envoy:
- **Authenticated users**: 1000 requests/hour
- **PAT tokens**: 10,000 requests/hour
- **Public endpoints**: 100 requests/hour per IP

Rate limit headers:
```
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 950
X-RateLimit-Reset: 1633024800
```

## Pagination

List endpoints support pagination:

```http
GET /api/v1/admin/leagues?page=0&size=20&sort=createdAt,desc
```

**Response**:
```json
{
  "content": [ /* league objects */ ],
  "page": 0,
  "size": 20,
  "totalElements": 45,
  "totalPages": 3,
  "first": true,
  "last": false
}
```

## API Documentation

### OpenAPI/Swagger UI
Available at: `https://<pod-ip>/swagger-ui.html`

### OpenAPI JSON Spec
Available at: `https://<pod-ip>/api-docs`

## Next Steps

- See [DEPLOYMENT.md](DEPLOYMENT.md) for Envoy configuration details
- See [DATA_MODEL.md](DATA_MODEL.md) for entity schemas
- See [DEVELOPMENT.md](DEVELOPMENT.md) for local API setup
