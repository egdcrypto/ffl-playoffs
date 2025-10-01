# API Integration - FFL Playoffs

## Overview
This document maps each UI screen to the backend API endpoints it consumes, including request/response formats, loading states, error handling, and data flow.

---

## Table of Contents
1. [Authentication](#authentication)
2. [Player Dashboard](#player-dashboard)
3. [Team Selection Screen](#team-selection-screen)
4. [Leaderboard Screen](#leaderboard-screen)
5. [Admin Dashboard](#admin-dashboard)
6. [League Configuration](#league-configuration)
7. [Super Admin Dashboard](#super-admin-dashboard)
8. [Invitation System](#invitation-system)
9. [Common Patterns](#common-patterns)

---

## Authentication

### Google OAuth Flow

**Endpoints:**

#### 1. Initiate OAuth
```
GET /api/auth/google
```
**Purpose:** Redirect user to Google OAuth consent screen

**Response:**
```json
{
  "redirectUrl": "https://accounts.google.com/o/oauth2/v2/auth?..."
}
```

**UI State:**
- Show loading spinner
- Redirect to Google

---

#### 2. OAuth Callback
```
GET /api/auth/callback?code=AUTHORIZATION_CODE
```
**Purpose:** Exchange authorization code for tokens

**Query Parameters:**
- `code`: Authorization code from Google
- `state`: CSRF protection token

**Response:**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 3600,
  "user": {
    "id": "user-123",
    "email": "john@example.com",
    "name": "John Doe",
    "picture": "https://...",
    "roles": ["player", "admin"]
  }
}
```

**UI Actions:**
- Store tokens in localStorage/sessionStorage
- Redirect to appropriate dashboard based on roles
- Initialize user context

**Error Handling:**
- Invalid code: Show error, redirect to login
- Network error: Show retry option
- Server error: Show error message

---

#### 3. Token Refresh
```
POST /api/auth/refresh
```
**Purpose:** Get new access token using refresh token

**Request:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response:**
```json
{
  "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "expiresIn": 3600
}
```

**UI Actions:**
- Silently update access token
- Retry failed requests with new token
- If refresh fails, redirect to login

---

#### 4. Logout
```
POST /api/auth/logout
```
**Purpose:** Invalidate tokens

**Request:**
```json
{
  "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Response:**
```json
{
  "message": "Successfully logged out"
}
```

**UI Actions:**
- Clear localStorage/sessionStorage
- Clear user context
- Redirect to login screen

---

## Player Dashboard

### Get Player Leagues

```
GET /api/player/leagues
```
**Purpose:** Fetch all leagues the player is part of

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "leagues": [
    {
      "id": "league-123",
      "name": "Office League",
      "admin": {
        "id": "user-456",
        "name": "John Doe"
      },
      "playerCount": 12,
      "currentWeek": 6,
      "totalWeeks": 18,
      "startDate": "2024-09-07T00:00:00Z",
      "playerStatus": {
        "rank": 3,
        "totalPoints": 145,
        "isEliminated": false,
        "hasSubmittedPick": false,
        "pickDeadline": "2024-09-14T20:00:00Z"
      }
    }
  ]
}
```

**UI Mapping:**
- Display league cards with name, admin, player count
- Show current week and total weeks
- Display player rank and points
- Show "Make Picks" button if `hasSubmittedPick: false`
- Show deadline countdown
- Gray out eliminated leagues

**Loading State:**
- Show skeleton cards (3-4 placeholders)

**Error Handling:**
- Network error: Show error banner with retry button
- 401 Unauthorized: Refresh token or redirect to login
- 500 Server error: Show error message

---

### Get Player Stats

```
GET /api/player/stats
```
**Purpose:** Get aggregate statistics across all leagues

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "stats": {
    "activeLeagues": 3,
    "totalPoints": 445,
    "bestRank": 1,
    "totalWins": 15,
    "totalLosses": 3,
    "eliminatedLeagues": 1
  }
}
```

**UI Mapping:**
- Display in "Quick Stats" card
- Show active leagues count
- Show total points and best rank

---

### Get Pending Invitations

```
GET /api/player/invitations
```
**Purpose:** Get pending league invitations

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "invitations": [
    {
      "id": "invite-789",
      "league": {
        "id": "league-456",
        "name": "Neighborhood League",
        "playerCount": 12,
        "startWeek": 7
      },
      "invitedBy": {
        "id": "user-999",
        "name": "Tom Anderson"
      },
      "invitedAt": "2024-09-10T10:00:00Z",
      "expiresAt": "2024-09-17T10:00:00Z"
    }
  ]
}
```

**UI Mapping:**
- Display invitation cards in "Pending Invitations" section
- Show league name, inviter name, start week
- Show "Accept" and "Decline" buttons

---

### Accept Invitation

```
POST /api/invitations/{invitationId}/accept
```
**Purpose:** Accept a league invitation

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "message": "Invitation accepted",
  "league": {
    "id": "league-456",
    "name": "Neighborhood League"
  }
}
```

**UI Actions:**
- Show success toast: "You've joined Neighborhood League!"
- Remove invitation from pending list
- Add new league to leagues list
- Refresh dashboard

**Error Handling:**
- 404: Invitation expired or not found
- 409: Already a member
- 400: League has started or is full

---

### Decline Invitation

```
POST /api/invitations/{invitationId}/decline
```
**Purpose:** Decline a league invitation

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "message": "Invitation declined"
}
```

**UI Actions:**
- Remove invitation from pending list
- Show toast: "Invitation declined"

---

## Team Selection Screen

### Get Current Week Info

```
GET /api/leagues/{leagueId}/current-week
```
**Purpose:** Get current week number and deadline

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "currentWeek": 6,
  "deadline": "2024-09-14T20:00:00Z",
  "hasStarted": false,
  "isLocked": false,
  "nflWeekStartTime": "2024-09-14T20:00:00Z"
}
```

**UI Mapping:**
- Display week number in header
- Show countdown timer to deadline
- Lock UI if `isLocked: true`

---

### Get Available Teams

```
GET /api/teams?week=6
```
**Purpose:** Get all NFL teams with current records

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Query Parameters:**
- `week`: Current NFL week

**Response:**
```json
{
  "teams": [
    {
      "id": "team-buf",
      "abbreviation": "BUF",
      "name": "Buffalo Bills",
      "division": "AFC East",
      "conference": "AFC",
      "wins": 6,
      "losses": 0,
      "logoUrl": "https://..."
    }
  ]
}
```

**UI Mapping:**
- Display team cards grouped by division
- Show team abbreviation, name, and record
- Show team logo

---

### Get Player's Pick History

```
GET /api/picks/{leagueId}/history
```
**Purpose:** Get all teams the player has used

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "usedTeams": [
    {
      "week": 1,
      "teamId": "team-ne",
      "teamName": "New England Patriots",
      "result": "win",
      "points": 24
    },
    {
      "week": 3,
      "teamId": "team-cle",
      "teamName": "Cleveland Browns",
      "result": "loss",
      "points": 14
    }
  ]
}
```

**UI Mapping:**
- Gray out used teams (mark as unavailable)
- Show "USED" badge on used team cards
- Count used teams (e.g., "5 of 32 teams used")

---

### Submit Pick

```
POST /api/picks
```
**Purpose:** Submit team selection for current week

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request:**
```json
{
  "leagueId": "league-123",
  "week": 6,
  "teamId": "team-buf"
}
```

**Response:**
```json
{
  "message": "Pick submitted successfully",
  "pick": {
    "id": "pick-789",
    "week": 6,
    "team": {
      "id": "team-buf",
      "name": "Buffalo Bills"
    },
    "submittedAt": "2024-09-12T15:30:00Z",
    "canEdit": true,
    "deadline": "2024-09-14T20:00:00Z"
  }
}
```

**UI Actions:**
- Show success toast: "Pick submitted! Good luck!"
- Redirect to Player Dashboard
- Update league card to show "Picks submitted ✓"

**Error Handling:**
- 400: Invalid team (already used, doesn't exist)
- 409: Deadline passed
- 409: Team already picked by user this week
- 500: Server error, show retry

**Loading State:**
- Disable "Confirm" button
- Show spinner with "Submitting..."

---

### Update Pick

```
PUT /api/picks/{pickId}
```
**Purpose:** Update team selection before deadline

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request:**
```json
{
  "teamId": "team-mia"
}
```

**Response:**
```json
{
  "message": "Pick updated successfully",
  "pick": {
    "id": "pick-789",
    "week": 6,
    "team": {
      "id": "team-mia",
      "name": "Miami Dolphins"
    },
    "updatedAt": "2024-09-13T10:15:00Z"
  }
}
```

**UI Actions:**
- Show success toast: "Pick updated!"
- Update UI to reflect new selection

---

## Leaderboard Screen

### Get Leaderboard

```
GET /api/leagues/{leagueId}/leaderboard
```
**Purpose:** Get current standings for league

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "league": {
    "id": "league-123",
    "name": "Office League",
    "currentWeek": 6,
    "totalWeeks": 18
  },
  "standings": [
    {
      "rank": 1,
      "player": {
        "id": "user-456",
        "name": "Sarah Johnson"
      },
      "currentPick": {
        "team": "Kansas City Chiefs",
        "teamId": "team-kc"
      },
      "weekPoints": 24,
      "totalPoints": 162,
      "streak": {
        "type": "win",
        "count": 6
      },
      "isActive": true,
      "isEliminated": false,
      "isCurrentUser": false
    }
  ]
}
```

**UI Mapping:**
- Display table with rank, player, team, points, streak
- Highlight current user's row
- Show medals (🥇🥈🥉) for top 3
- Show eliminated players grayed out with ⚫ badge
- Show active status (✓ or ✗)

**Loading State:**
- Show skeleton table rows

**Refresh:**
- Auto-refresh every 30 seconds during game time
- Manual pull-to-refresh on mobile

---

### Get Weekly Results

```
GET /api/leagues/{leagueId}/weekly-results?week=6
```
**Purpose:** Get results for a specific week

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Query Parameters:**
- `week`: Week number (optional, defaults to current week)

**Response:**
```json
{
  "week": 6,
  "results": [
    {
      "player": {
        "id": "user-456",
        "name": "Sarah Johnson"
      },
      "team": "Kansas City Chiefs",
      "points": 24,
      "result": "win",
      "opponentScore": 17
    }
  ]
}
```

**UI Mapping:**
- Display in "Weekly Results" tab
- Show team picked, score, and result
- Sort by points descending

---

### Get League Stats

```
GET /api/leagues/{leagueId}/stats
```
**Purpose:** Get aggregate league statistics

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "stats": {
    "activePlayers": 7,
    "eliminatedPlayers": 2,
    "totalPlayers": 9,
    "averagePoints": 132,
    "highestWeekScore": 24,
    "weeksRemaining": 12,
    "totalTeamsUsed": 54
  }
}
```

**UI Mapping:**
- Display in "League Stats" card below leaderboard
- Show key metrics

---

## Admin Dashboard

### Get Admin Leagues

```
GET /api/admin/leagues
```
**Purpose:** Get all leagues where user is admin

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "leagues": [
    {
      "id": "league-123",
      "name": "Office League",
      "playerCount": 12,
      "activePlayers": 10,
      "eliminatedPlayers": 2,
      "currentWeek": 6,
      "totalWeeks": 18,
      "startDate": "2024-09-07T00:00:00Z",
      "pendingPicks": 2,
      "nextDeadline": "2024-09-14T20:00:00Z"
    }
  ]
}
```

**UI Mapping:**
- Display league cards with admin controls
- Show player stats (active, eliminated, pending picks)
- Show "Manage" button for each league

---

### Get League Activity

```
GET /api/leagues/{leagueId}/activity?limit=10
```
**Purpose:** Get recent activity for a league

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Query Parameters:**
- `limit`: Number of events to return (default 10)

**Response:**
```json
{
  "activity": [
    {
      "id": "activity-1",
      "type": "pick_submitted",
      "player": {
        "id": "user-456",
        "name": "Sarah Johnson"
      },
      "details": "Submitted picks for Week 6",
      "timestamp": "2024-09-12T15:30:00Z"
    },
    {
      "id": "activity-2",
      "type": "player_joined",
      "player": {
        "id": "user-789",
        "name": "Tom Anderson"
      },
      "details": "Joined the league",
      "timestamp": "2024-09-10T10:00:00Z"
    }
  ]
}
```

**UI Mapping:**
- Display in "Recent Activity" section
- Show player name, action, and time ago
- Auto-refresh every minute

---

### Get Pending Picks

```
GET /api/leagues/{leagueId}/pending-picks
```
**Purpose:** Get players who haven't submitted picks

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "week": 6,
  "deadline": "2024-09-14T20:00:00Z",
  "pendingPlayers": [
    {
      "id": "user-999",
      "name": "Bob Smith",
      "email": "bob@example.com"
    }
  ]
}
```

**UI Mapping:**
- Display in "Pending Actions" alert
- Show count of pending players
- Show "Send Reminder" button

---

### Send Pick Reminder

```
POST /api/notifications/reminder
```
**Purpose:** Send email reminder to players who haven't picked

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request:**
```json
{
  "leagueId": "league-123",
  "week": 6,
  "playerIds": ["user-999"]
}
```

**Response:**
```json
{
  "message": "Reminders sent",
  "sentCount": 1
}
```

**UI Actions:**
- Show success toast: "Reminder sent to 1 player"
- Disable "Send Reminder" button temporarily

---

### Create League

```
POST /api/leagues
```
**Purpose:** Create a new league

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request:**
```json
{
  "name": "Office League",
  "description": "Weekly NFL survivor pool",
  "startingWeek": 1,
  "endingWeek": 18,
  "deadlineDay": "thursday",
  "deadlineTime": "18:00:00",
  "timezone": "America/New_York",
  "scoringType": "team_total",
  "defensiveScoring": {
    "enabled": true,
    "rules": [
      {"pointsAllowed": 0, "bonus": 10},
      {"pointsAllowed": 6, "bonus": 7}
    ]
  },
  "fieldGoalBonuses": {
    "enabled": true,
    "rules": [
      {"minYards": 40, "maxYards": 49, "bonus": 3},
      {"minYards": 50, "maxYards": null, "bonus": 5}
    ]
  },
  "eliminationRule": "loss_eliminates",
  "canReuseTeams": false
}
```

**Response:**
```json
{
  "message": "League created successfully",
  "league": {
    "id": "league-123",
    "name": "Office League",
    "code": "OFF2024XYZ",
    "adminId": "user-456",
    "createdAt": "2024-09-01T12:00:00Z"
  }
}
```

**UI Actions:**
- Show success modal with league code
- Provide "Copy Code" and "Invite Players" buttons
- Redirect to Admin Dashboard

**Error Handling:**
- 400: Validation errors (show field-specific errors)
- 409: League name already exists
- 500: Server error

---

### Invite Players

```
POST /api/invitations
```
**Purpose:** Invite players to join league

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request:**
```json
{
  "leagueId": "league-123",
  "emails": [
    "player1@example.com",
    "player2@example.com"
  ],
  "message": "Join my league!"
}
```

**Response:**
```json
{
  "message": "Invitations sent",
  "sentCount": 2,
  "invitations": [
    {
      "id": "invite-1",
      "email": "player1@example.com",
      "status": "sent",
      "inviteUrl": "https://ffl.com/invite/abc123"
    }
  ]
}
```

**UI Actions:**
- Show success toast: "Invitations sent to 2 players"
- Close modal
- Optionally show invite URLs to copy

---

## League Configuration

### Get League Configuration

```
GET /api/leagues/{leagueId}/config
```
**Purpose:** Get current league configuration

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Response:**
```json
{
  "config": {
    "name": "Office League",
    "description": "Weekly NFL survivor pool",
    "code": "OFF2024XYZ",
    "startingWeek": 1,
    "endingWeek": 18,
    "deadlineDay": "thursday",
    "deadlineTime": "18:00:00",
    "timezone": "America/New_York",
    "scoringType": "team_total",
    "defensiveScoring": {
      "enabled": true,
      "rules": []
    },
    "fieldGoalBonuses": {
      "enabled": true,
      "rules": []
    },
    "eliminationRule": "loss_eliminates",
    "canReuseTeams": false,
    "isLocked": false,
    "hasStarted": false
  }
}
```

**UI Mapping:**
- Populate form fields with current values
- Show league code for sharing
- Lock fields if `isLocked: true` or `hasStarted: true`

---

### Update League Configuration

```
PUT /api/leagues/{leagueId}/config
```
**Purpose:** Update league configuration

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request:**
```json
{
  "name": "Office League 2024",
  "description": "Updated description",
  "deadlineTime": "19:00:00"
}
```

**Response:**
```json
{
  "message": "Configuration updated",
  "config": {
    "name": "Office League 2024"
  }
}
```

**UI Actions:**
- Show success toast: "Configuration saved"
- Update UI with new values

**Error Handling:**
- 400: Validation errors
- 403: League has started, cannot modify
- 409: Conflict (e.g., week already passed)

---

### Validate Configuration

```
POST /api/leagues/{leagueId}/validate
```
**Purpose:** Validate configuration before saving

**Headers:**
```
Authorization: Bearer {accessToken}
```

**Request:**
```json
{
  "startingWeek": 1,
  "endingWeek": 18
}
```

**Response:**
```json
{
  "valid": true,
  "errors": []
}
```

Or if invalid:
```json
{
  "valid": false,
  "errors": [
    {
      "field": "startingWeek",
      "message": "Week 1 has already passed"
    }
  ]
}
```

**UI Actions:**
- Show inline validation errors
- Disable "Save" button if invalid

---

## Super Admin Dashboard

### Get Platform Overview

```
GET /api/super-admin/overview
```
**Purpose:** Get platform-wide statistics

**Headers:**
```
Authorization: Bearer {accessToken}
X-Super-Admin-Token: {superAdminToken}
```

**Response:**
```json
{
  "stats": {
    "totalLeagues": 127,
    "activeLeagues": 89,
    "totalPlayers": 1543,
    "activePlayers": 987,
    "totalAdmins": 45,
    "activeGames": 89
  }
}
```

**UI Mapping:**
- Display in "Platform Overview" card
- Show key metrics

---

### Get All Admins

```
GET /api/super-admin/admins
```
**Purpose:** List all admin users

**Headers:**
```
Authorization: Bearer {accessToken}
X-Super-Admin-Token: {superAdminToken}
```

**Response:**
```json
{
  "admins": [
    {
      "id": "user-456",
      "email": "john@example.com",
      "name": "John Doe",
      "leagueCount": 3,
      "status": "active",
      "createdAt": "2024-08-01T00:00:00Z",
      "lastLoginAt": "2024-09-12T10:00:00Z"
    }
  ]
}
```

**UI Mapping:**
- Display in table format
- Show email, name, league count, status
- Show "Manage" button for each admin

---

### Create Admin

```
POST /api/super-admin/admins
```
**Purpose:** Create a new admin user

**Headers:**
```
Authorization: Bearer {accessToken}
X-Super-Admin-Token: {superAdminToken}
```

**Request:**
```json
{
  "email": "newadmin@example.com",
  "name": "New Admin",
  "sendInviteEmail": true
}
```

**Response:**
```json
{
  "message": "Admin created",
  "admin": {
    "id": "user-999",
    "email": "newadmin@example.com",
    "status": "pending"
  }
}
```

**UI Actions:**
- Show success toast: "Admin created and invitation sent"
- Add new admin to table
- Close modal

---

### Delete Admin

```
DELETE /api/super-admin/admins/{adminId}
```
**Purpose:** Remove admin user

**Headers:**
```
Authorization: Bearer {accessToken}
X-Super-Admin-Token: {superAdminToken}
```

**Response:**
```json
{
  "message": "Admin removed"
}
```

**UI Actions:**
- Show confirmation modal before deleting
- Remove admin from table
- Show toast: "Admin removed"

---

### Get Personal Access Tokens

```
GET /api/super-admin/pats
```
**Purpose:** List all Personal Access Tokens

**Headers:**
```
Authorization: Bearer {accessToken}
X-Super-Admin-Token: {superAdminToken}
```

**Response:**
```json
{
  "tokens": [
    {
      "id": "pat-123",
      "name": "API Integration",
      "createdAt": "2024-09-01T00:00:00Z",
      "lastUsedAt": "2024-09-12T15:30:00Z",
      "expiresAt": null
    }
  ]
}
```

**UI Mapping:**
- Display in table format
- Show token name, created date, last used
- Show "Revoke" button for each token

---

### Create Personal Access Token

```
POST /api/super-admin/pats
```
**Purpose:** Create a new Personal Access Token

**Headers:**
```
Authorization: Bearer {accessToken}
X-Super-Admin-Token: {superAdminToken}
```

**Request:**
```json
{
  "name": "API Integration",
  "expiresAt": "2025-09-01T00:00:00Z"
}
```

**Response:**
```json
{
  "message": "Token created",
  "token": {
    "id": "pat-123",
    "name": "API Integration",
    "value": "pat_xxxxxxxxxxxxxxxxxxx"
  }
}
```

**UI Actions:**
- Show modal with token value (only shown once)
- Provide "Copy Token" button
- Warn user to save token securely
- Add token to table

---

### Revoke Personal Access Token

```
DELETE /api/super-admin/pats/{tokenId}
```
**Purpose:** Revoke a Personal Access Token

**Headers:**
```
Authorization: Bearer {accessToken}
X-Super-Admin-Token: {superAdminToken}
```

**Response:**
```json
{
  "message": "Token revoked"
}
```

**UI Actions:**
- Show confirmation modal
- Remove token from table
- Show toast: "Token revoked"

---

### Get All Leagues

```
GET /api/super-admin/leagues?page=1&limit=20
```
**Purpose:** List all leagues on the platform

**Headers:**
```
Authorization: Bearer {accessToken}
X-Super-Admin-Token: {superAdminToken}
```

**Query Parameters:**
- `page`: Page number (default 1)
- `limit`: Items per page (default 20)
- `status`: Filter by status (active, ended)
- `adminId`: Filter by admin

**Response:**
```json
{
  "leagues": [
    {
      "id": "league-123",
      "name": "Office League",
      "admin": {
        "id": "user-456",
        "name": "John Doe"
      },
      "playerCount": 12,
      "currentWeek": 6,
      "totalWeeks": 18,
      "status": "active"
    }
  ],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 127,
    "pages": 7
  }
}
```

**UI Mapping:**
- Display in paginated table
- Show league name, admin, players, week, status
- Provide filters and search

---

### Get System Health

```
GET /api/super-admin/system-health
```
**Purpose:** Get system health metrics

**Headers:**
```
Authorization: Bearer {accessToken}
X-Super-Admin-Token: {superAdminToken}
```

**Response:**
```json
{
  "health": {
    "api": {
      "status": "healthy",
      "uptime": 99.9,
      "latency": 45
    },
    "database": {
      "status": "healthy",
      "connections": 42,
      "maxConnections": 100
    },
    "cache": {
      "status": "healthy",
      "hitRate": 87.5
    }
  }
}
```

**UI Mapping:**
- Display in "System Health" card
- Show status indicators (✓ or ✗)
- Show key metrics

---

## Invitation System

### Get Invitation Details (Public)

```
GET /api/invitations/{token}
```
**Purpose:** Get invitation details using public token

**No authentication required**

**Response:**
```json
{
  "invitation": {
    "id": "invite-789",
    "league": {
      "name": "Office League",
      "playerCount": 12,
      "startWeek": 7,
      "description": "Weekly NFL survivor pool"
    },
    "invitedBy": {
      "name": "John Doe"
    },
    "invitedAt": "2024-09-10T10:00:00Z",
    "expiresAt": "2024-09-17T10:00:00Z",
    "status": "pending"
  }
}
```

**UI Mapping:**
- Display league details
- Show who invited
- Show "Sign in to accept" button

**Error Handling:**
- 404: Invalid or expired token
- 410: Already accepted/declined

---

## Common Patterns

### Pagination
```
GET /api/resource?page=1&limit=20
```

**Response:**
```json
{
  "data": [],
  "pagination": {
    "page": 1,
    "limit": 20,
    "total": 150,
    "pages": 8,
    "hasNext": true,
    "hasPrev": false
  }
}
```

**UI Actions:**
- Show page numbers
- Enable/disable prev/next buttons
- Show total count

---

### Sorting
```
GET /api/resource?sortBy=name&sortOrder=asc
```

**Query Parameters:**
- `sortBy`: Field to sort by
- `sortOrder`: asc or desc

**UI Actions:**
- Click column header to sort
- Show sort indicator (↑ or ↓)
- Toggle sort order on click

---

### Filtering
```
GET /api/resource?filter[status]=active&filter[week]=6
```

**Query Parameters:**
- `filter[field]`: Value to filter by

**UI Actions:**
- Provide filter dropdowns or inputs
- Apply filters on change
- Show active filters with "Clear" option

---

### Search
```
GET /api/resource?search=office
```

**Query Parameters:**
- `search`: Search term

**UI Actions:**
- Provide search input
- Debounce input (300ms)
- Show "No results" if empty

---

## Error Response Format

All errors follow this format:

```json
{
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "Invalid request",
    "details": [
      {
        "field": "email",
        "message": "Invalid email format"
      }
    ]
  }
}
```

**Common Error Codes:**
- `VALIDATION_ERROR`: 400 - Invalid input
- `UNAUTHORIZED`: 401 - Not authenticated
- `FORBIDDEN`: 403 - Not authorized
- `NOT_FOUND`: 404 - Resource not found
- `CONFLICT`: 409 - Conflict (e.g., duplicate)
- `INTERNAL_ERROR`: 500 - Server error

**UI Error Handling:**
- Show field-specific errors inline
- Show general errors in toast/banner
- Provide retry option for network errors
- Log errors to monitoring service

---

## Loading States

### Initial Load
- Show skeleton screens
- Match layout of actual content

### Refresh
- Show subtle spinner in header
- Pull-to-refresh on mobile

### Submit Actions
- Disable button
- Show spinner in button
- Change button text to "Submitting..."

### Background Updates
- Silent updates (e.g., leaderboard refresh)
- Optional: show small indicator

---

## Real-time Updates

### WebSocket Connection (Optional)

**Connect:**
```
ws://api.ffl.com/ws?token={accessToken}
```

**Subscribe to Leaderboard:**
```json
{
  "action": "subscribe",
  "channel": "league.123.leaderboard"
}
```

**Receive Updates:**
```json
{
  "channel": "league.123.leaderboard",
  "event": "standings_updated",
  "data": {
    "standings": []
  }
}
```

**UI Actions:**
- Connect on leaderboard screen mount
- Subscribe to league-specific channel
- Update UI when receiving data
- Animate changes (e.g., rank up/down)
- Disconnect on unmount

---

## Caching Strategy

### Cache Duration
- User profile: 5 minutes
- Leagues list: 2 minutes
- Leaderboard: 30 seconds (or real-time)
- Team data: 1 hour
- Configuration: Until modified

### Cache Invalidation
- Manual refresh (pull-to-refresh)
- After mutations (create, update, delete)
- Token expiration
- Logout

### Implementation
- Use React Query, SWR, or similar
- Stale-while-revalidate pattern
- Optimistic updates for better UX

---

## Rate Limiting

**Response Headers:**
```
X-RateLimit-Limit: 100
X-RateLimit-Remaining: 95
X-RateLimit-Reset: 1694700000
```

**UI Handling:**
- Show warning if approaching limit
- If limited (429), show retry-after timer
- For non-critical requests, implement backoff

---

## Security Headers

**All requests should include:**
```
Authorization: Bearer {accessToken}
X-CSRF-Token: {csrfToken}
```

**Super admin requests also include:**
```
X-Super-Admin-Token: {superAdminToken}
```

**Response Security Headers:**
```
X-Content-Type-Options: nosniff
X-Frame-Options: DENY
X-XSS-Protection: 1; mode=block
```

---

## API Versioning

**Base URL:**
```
https://api.ffl.com/v1/...
```

**Version in Header:**
```
Accept: application/vnd.ffl.v1+json
```

**UI Handling:**
- Always use latest stable version
- Handle deprecated endpoint warnings
- Graceful degradation for breaking changes

---

## Offline Support (Future)

### Service Worker
- Cache API responses
- Queue mutations when offline
- Sync when back online

### UI Indicators
- Show offline banner
- Disable actions that require network
- Queue optimistic updates
- Show sync status

---

## Performance Optimization

### Reduce API Calls
- Combine related data in single endpoint
- Use pagination to limit data
- Cache aggressively
- Debounce search and filters

### Optimize Payloads
- Request only needed fields
- Compress responses (gzip)
- Use CDN for static assets

### Lazy Loading
- Load data on demand (infinite scroll)
- Lazy load images and heavy components
- Code split by route

---

## Monitoring & Analytics

### Track API Calls
- Log all requests/responses
- Monitor latency
- Track error rates
- Alert on failures

### User Analytics
- Track screen views
- Track user actions (clicks, submits)
- Monitor conversion rates
- A/B test features

### Tools
- Sentry for error tracking
- Google Analytics for usage
- DataDog/New Relic for performance
- LogRocket for session replay

