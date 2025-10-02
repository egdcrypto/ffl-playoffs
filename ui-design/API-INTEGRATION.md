# API Integration Mapping

This document maps each UI screen to its corresponding API endpoints, detailing the data flow between frontend and backend.

## Table of Contents
1. [Login Screen](#1-login-screen)
2. [Player Dashboard](#2-player-dashboard)
3. [Team Selection Screen](#3-team-selection-screen)
4. [Leaderboard Screen](#4-leaderboard-screen)
5. [Admin Dashboard](#5-admin-dashboard)
6. [League Configuration Screen](#6-league-configuration-screen)
7. [Invitation Acceptance Screen](#7-invitation-acceptance-screen)
8. [Super Admin Dashboard](#8-super-admin-dashboard)
9. [Score Breakdown Screen](#9-score-breakdown-screen)
10. [Roster Management Screen](#10-roster-management-screen)

---

## 1. Login Screen

### Purpose
Google OAuth authentication flow for user login.

### API Endpoints

#### On Page Load
None - This is client-side Google OAuth flow

#### On Google Sign-In Success
**All subsequent requests** include:
```http
Header: Authorization: Bearer <google-jwt-token>
```

### User Flow
1. User clicks "Sign in with Google" button
2. Google OAuth popup opens
3. User authenticates with Google
4. Frontend receives Google JWT token
5. Frontend stores JWT in localStorage/cookie
6. Frontend redirects to Player Dashboard
7. All subsequent API calls include JWT in Authorization header

### Authentication Headers (Automatically Added)
After JWT validation, Envoy adds these headers:
```
X-User-Id: 12345
X-User-Email: user@example.com
X-User-Role: PLAYER | ADMIN | SUPER_ADMIN
X-Google-Id: google-oauth2|123456789
```

### Error States
- Google OAuth popup blocked (browser)
- User cancels OAuth flow (redirect back)
- Invalid JWT token (401 error on first API call)
- User not invited (403 error - show "Contact admin" message)

---

## 2. Player Dashboard

### Purpose
Main landing page showing all leagues, upcoming deadlines, and quick actions.

### API Endpoints

#### On Page Load
```http
GET /api/v1/player/leagues
Authorization: Bearer <jwt>
```

**Response**: List of leagues player is part of
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
      "playerCount": 12,
      "nextDeadline": "2025-10-05T13:00:00Z",
      "needsPicks": true
    }
  ]
}
```

### Data Display
- **League Cards**: Show league name, current week, rank, score
- **Action Buttons**: "Make Picks" (if needsPicks), "View Leaderboard", "View League"
- **Deadline Countdown**: Calculate from `nextDeadline` timestamp
- **Visual Indicator**: Highlight leagues that need picks

### User Actions

#### Click "Make Picks"
Navigate to: [Team Selection Screen](#3-team-selection-screen) for that league

#### Click "View Leaderboard"
Navigate to: [Leaderboard Screen](#4-leaderboard-screen) for that league

#### Click "View League"
Navigate to: League Details page (shows league info, admin, rules)

### Polling/Refresh Strategy
- Auto-refresh every 60 seconds if deadlines are within 24 hours
- Pull-to-refresh on mobile
- Manual refresh button

### Error States
- Empty state: "You're not in any leagues yet. Ask an admin for an invitation."
- API error: Show error banner with retry button
- Loading state: Skeleton cards

---

## 3. Build Roster Screen

### Purpose
One-time roster building interface for selecting individual NFL players to fill position slots before roster locks.

### API Endpoints

#### On Page Load
```http
GET /api/v1/player/leagues/{leagueId}/roster
Authorization: Bearer <jwt>
```

**Response**: Player's current roster and lock status
```json
{
  "rosterLocked": false,
  "lockTimestamp": "2025-01-12T18:00:00Z",
  "rosterSlots": [
    {
      "position": "QB",
      "count": 1,
      "players": [
        {
          "id": 501,
          "name": "Patrick Mahomes",
          "team": "KC",
          "byeWeek": 12
        }
      ]
    },
    {
      "position": "RB",
      "count": 2,
      "players": [
        {
          "id": 622,
          "name": "Christian McCaffrey",
          "team": "SF",
          "byeWeek": 9
        }
      ]
    }
  ],
  "completionStatus": {
    "filled": 6,
    "total": 9,
    "isComplete": false
  }
}
```

#### Search NFL Players
```http
GET /api/v1/nfl/players?position=QB&search=mahomes&limit=20
Authorization: Bearer <jwt>
```

**Response**: Available NFL players
```json
{
  "players": [
    {
      "id": 501,
      "firstName": "Patrick",
      "lastName": "Mahomes",
      "position": "QB",
      "team": "KC",
      "byeWeek": 12,
      "inMyRoster": true
    },
    {
      "id": 502,
      "firstName": "Josh",
      "lastName": "Allen",
      "position": "QB",
      "team": "BUF",
      "byeWeek": 12,
      "inMyRoster": false
    }
  ],
  "total": 45,
  "hasMore": true
}
```

#### Add Player to Roster
```http
POST /api/v1/player/leagues/{leagueId}/roster/players
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "playerId": 502,
  "position": "QB"
}
```

**Response**: Confirmation
```json
{
  "id": 124,
  "playerId": 502,
  "playerName": "Josh Allen",
  "position": "QB",
  "team": "BUF",
  "byeWeek": 12,
  "addedAt": "2025-01-01T12:00:00Z"
}
```

#### Remove Player from Roster (Before Lock)
```http
DELETE /api/v1/player/leagues/{leagueId}/roster/players/{playerId}
Authorization: Bearer <jwt>
```

**Response**: Success
```json
{
  "success": true,
  "message": "Player removed from roster"
}
```

### Data Display
- **Roster Lock Timer**: Countdown to `lockTimestamp` (first game), color-coded (green > 2 days, yellow < 2 days, red < 6h)
- **Current Roster**: Show filled positions with player names, empty positions highlighted
- **Available Players**: Search/filter interface with player cards (position, team, bye week)
- **Roster Completion**: Progress indicator (6/9 positions filled)

### User Actions

#### Search Players
1. Type in search box → debounced GET `/api/v1/nfl/players?search={query}`
2. Filter by position → GET `/api/v1/nfl/players?position={pos}`
3. Show results in scrollable grid

#### Add Player to Roster
1. Click "+ Add" on player card
2. POST to `/api/v1/player/leagues/{leagueId}/roster/players`
3. Show loading spinner on button
4. On success: Update roster display, mark player as "✓ Added", show success toast
5. On error: Show error message (see error states)

#### Remove Player from Roster (Before Lock)
1. Click "Remove" on roster slot
2. Show confirmation modal
3. DELETE `/api/v1/player/leagues/{leagueId}/roster/players/{playerId}`
4. On success: Clear slot, return to available players

### Error States

#### Player Already in Roster
```json
{
  "error": "PLAYER_ALREADY_IN_ROSTER",
  "message": "Patrick Mahomes is already in your roster"
}
```
**UI**: Show error toast, disable "+ Add" button for that player

#### Position Full
```json
{
  "error": "POSITION_FULL",
  "message": "QB position is full (1/1 filled)"
}
```
**UI**: Show error toast, suggest removing existing player first

#### Roster Locked
```json
{
  "error": "ROSTER_LOCKED",
  "message": "Roster is permanently locked. First game has started."
}
```
**UI**: Lock entire UI, show "🔒 ROSTER LOCKED" banner, disable all add/remove actions

### Responsive Behavior
- **Mobile**: Vertical stacked roster, 1 player card per row
- **Tablet**: 2 player cards per row, condensed roster table
- **Desktop**: Full roster table, 3-4 player cards per row

---

## 4. Leaderboard Screen

### Purpose
Rankings, weekly/season scores, and roster performance tracking for league.

### API Endpoints

#### On Page Load
```http
GET /api/v1/player/leagues/{leagueId}/leaderboard
Authorization: Bearer <jwt>
```

**Response**: Rankings and scores
```json
{
  "currentWeek": 2,
  "leaderboard": [
    {
      "rank": 1,
      "playerId": 15,
      "playerName": "Jane Player",
      "totalScore": 342.5,
      "weeklyScores": [87.5, 92.0, 85.0, 78.0],
      "eliminatedTeams": 0,
      "isMe": false
    },
    {
      "rank": 2,
      "playerId": 10,
      "playerName": "You",
      "totalScore": 320.0,
      "weeklyScores": [75.0, 88.5, 92.5, 64.0],
      "eliminatedTeams": 1,
      "isMe": true
    }
  ],
  "myRank": 2,
  "totalPlayers": 12
}
```

#### Get Week-Specific Leaderboard
```http
GET /api/v1/player/leagues/{leagueId}/leaderboard?week=1
Authorization: Bearer <jwt>
```

### Data Display
- **Ranking Table**: Rank, Name, Total Score, Weekly Scores
- **Highlight Current User**: Different background color for "me"
- **Top Performer Badge**: Show each player's top scoring player for the week
- **Weekly Breakdown**: Expandable row to show week-by-week scores
- **Filters**: Toggle between "All Weeks" and specific week

### User Actions

#### Click Player Name
Navigate to: Player Detail page (shows all their picks and scores)

#### Click Weekly Score
Show modal with score breakdown for that week/player

#### Change Week Filter
Update query parameter and reload:
```http
GET /api/v1/player/leagues/{leagueId}/leaderboard?week=2
```

### Polling/Refresh Strategy
- Auto-refresh every 30 seconds during live games
- Pull-to-refresh on mobile
- Show "Last updated: X seconds ago" timestamp

### Error States
- Empty state: "No scores yet. Come back after Week 1!"
- Loading: Skeleton table rows
- API error: Show error with retry button

### Responsive Behavior
- **Mobile**: Stacked card view, show rank/name/total only
- **Tablet**: Collapsed table, expandable for weekly scores
- **Desktop**: Full table with all columns visible

---

## 5. Admin Dashboard

### Purpose
Admin control center for managing leagues, inviting players, viewing stats.

### API Endpoints

#### On Page Load
```http
GET /api/v1/admin/leagues/{leagueId}
Authorization: Bearer <jwt>
```

**Response**: League details
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
  "playerCount": 12,
  "scoringRules": { /* full rules object */ },
  "createdAt": "2025-09-15T10:00:00Z"
}
```

#### Get All Players in League
```http
GET /api/v1/admin/leagues/{leagueId}/players
Authorization: Bearer <jwt>
```

**Response**: Player list
```json
{
  "players": [
    {
      "id": 10,
      "email": "player1@example.com",
      "name": "John Player",
      "joinedAt": "2025-09-20T10:00:00Z",
      "teamSelections": 3,
      "totalScore": 265.5,
      "rank": 2
    }
  ]
}
```

#### Get All Player Selections (Admin View)
```http
GET /api/v1/admin/leagues/{leagueId}/selections
Authorization: Bearer <jwt>
```

**Response**: All selections across all players
```json
{
  "selections": [
    {
      "playerId": 10,
      "playerName": "John Player",
      "week": 1,
      "nflWeek": 15,
      "teamName": "Kansas City Chiefs",
      "eliminated": false,
      "score": 87.5
    }
  ]
}
```

### User Actions

#### Invite Player
```http
POST /api/v1/admin/leagues/{leagueId}/invitations
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "email": "newplayer@example.com",
  "message": "Join our playoff pool!"
}
```

**Response**: Invitation details
```json
{
  "invitationId": "uuid-here",
  "leagueId": 1,
  "email": "newplayer@example.com",
  "invitationUrl": "https://app.ffl-playoffs.com/accept-invite?token=xyz",
  "expiresAt": "2025-10-08T12:00:00Z"
}
```

**UI**: 
1. Show "Invite Player" modal
2. Email input + optional message textarea
3. On success: Show invitation URL to copy, or "Email sent" confirmation
4. Close modal, refresh player list

#### Edit League Settings
Navigate to: [League Configuration Screen](#6-league-configuration-screen)

#### Activate League
```http
POST /api/v1/admin/leagues/{leagueId}/activate
Authorization: Bearer <jwt>
```

**UI**: Show confirmation modal: "Once activated, starting week and number of weeks cannot be changed."

### Data Display
- **League Info Card**: Name, description, weeks, active status
- **Player List Table**: Name, email, selections made, total score
- **Quick Stats**: Total players, average score, most eliminated teams
- **Action Buttons**: Invite Player, Edit Settings, View All Picks, Activate League

### Error States
- Not league owner (403): Redirect to player dashboard
- League not found (404): Show error page
- Invitation already sent: Show warning "Already invited"

---

## 6. League Configuration Screen

### Purpose
Create or edit league settings, scoring rules, weeks.

### API Endpoints

#### Create New League
```http
POST /api/v1/admin/leagues
Authorization: Bearer <jwt>
Content-Type: application/json

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
      "pointsAllowedTiers": [...],
      "yardsAllowedTiers": [...]
    }
  }
}
```

**Response**: Created league
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

#### Update League Configuration
```http
PUT /api/v1/admin/leagues/{leagueId}/configuration
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "name": "Updated League Name",
  "description": "Updated description",
  "scoringRules": { /* updated rules */ }
}
```

**Note**: `startingWeek` and `numberOfWeeks` cannot be changed once league is active.

### Form Sections

#### 1. Basic Info
- League Name (text input)
- Description (textarea)
- Starting Week (number input, 1-18)
- Number of Weeks (number input, 1-4)
- Public/Private toggle

#### 2. PPR Scoring Rules
- Passing Yards per Point (number input)
- Rushing Yards per Point (number input)
- Receiving Yards per Point (number input)
- Reception Points (number input)
- Touchdown Points (number input)

#### 3. Field Goal Rules
- 0-39 yards (number input)
- 40-49 yards (number input)
- 50+ yards (number input)

#### 4. Defensive Rules
- Sack Points (number input)
- Interception Points (number input)
- Fumble Recovery Points (number input)
- Safety Points (number input)
- Defensive TD Points (number input)
- Points Allowed Tiers (table input)
- Yards Allowed Tiers (table input)

### Validation

#### Client-Side
- All fields required
- Starting week: 1-18
- Number of weeks: 1-4
- Max week validation: `startingWeek + numberOfWeeks - 1 <= 18`

#### Server-Side Error
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

**UI**: Show error message above form, highlight invalid fields

### User Actions

#### Save & Continue
1. Validate form client-side
2. POST to `/api/v1/admin/leagues` (or PUT for updates)
3. Show loading spinner
4. On success: Redirect to Admin Dashboard
5. On error: Show error messages inline

#### Cancel
Navigate back to Admin Dashboard (show confirmation if form is dirty)

### Responsive Behavior
- **Mobile**: Single column, collapsible sections
- **Tablet**: Two columns for scoring rules
- **Desktop**: Three columns, side-by-side sections

---

## 7. Invitation Acceptance Screen

### Purpose
Player/Admin accepts invitation via email link.

### API Endpoints

#### On Page Load (with token query param)
Extract `token` from URL: `/accept-invite?token=xyz`

Store token, show Google Sign-In button

#### Accept Player Invitation
```http
POST /api/v1/player/invitations/accept
Authorization: Bearer <google-jwt-token>
Content-Type: application/json

{
  "invitationToken": "xyz-token-from-url"
}
```

**Response**: Success
```json
{
  "userId": 10,
  "leagueId": 1,
  "leagueName": "2025 NFL Playoffs Pool",
  "message": "Successfully joined league"
}
```

#### Accept Admin Invitation
```http
POST /api/v1/superadmin/admins/invitations/accept
Authorization: Bearer <google-jwt-token>
Content-Type: application/json

{
  "invitationToken": "xyz-token-from-url"
}
```

**Response**: Success
```json
{
  "userId": 5,
  "role": "ADMIN",
  "message": "Successfully upgraded to admin"
}
```

### User Flow
1. User clicks email link
2. Landing page shows: "You've been invited to [League Name]"
3. "Sign in with Google to accept" button
4. User authenticates with Google
5. Frontend calls accept endpoint with token + JWT
6. On success: Redirect to Player Dashboard (or Admin Dashboard)
7. Show success toast: "You've joined [League Name]!"

### Error States

#### Invalid Token
```json
{
  "error": "INVALID_INVITATION_TOKEN",
  "message": "This invitation link is invalid or has expired"
}
```
**UI**: Show error page: "Invalid invitation. Contact the league admin."

#### Token Expired
```json
{
  "error": "INVITATION_EXPIRED",
  "message": "This invitation expired on 2025-10-08"
}
```
**UI**: Show error page: "Invitation expired. Contact the league admin for a new invitation."

#### Already Accepted
```json
{
  "error": "INVITATION_ALREADY_ACCEPTED",
  "message": "You've already joined this league"
}
```
**UI**: Redirect to Player Dashboard with toast: "You're already in this league!"

---

## 8. Super Admin Dashboard

### Purpose
System-wide administration for managing admins, PATs, and viewing all leagues.

### API Endpoints

#### Get All Admins
```http
GET /api/v1/superadmin/admins
Authorization: Bearer <jwt>
```

**Response**: List of admins
```json
{
  "admins": [
    {
      "id": 1,
      "email": "admin1@example.com",
      "name": "John Admin",
      "createdAt": "2025-09-01T10:00:00Z",
      "active": true,
      "leagueCount": 3
    }
  ]
}
```

#### Get All PATs
```http
GET /api/v1/superadmin/pats
Authorization: Bearer <jwt>
```

**Response**: List of PATs (tokens hidden)
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

#### Get All Leagues (System-Wide)
```http
GET /api/v1/superadmin/leagues
Authorization: Bearer <jwt>
```

**Response**: All leagues across all admins
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

### User Actions

#### Invite Admin
```http
POST /api/v1/superadmin/admins/invitations
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "email": "newadmin@example.com",
  "message": "You've been invited to be an admin"
}
```

**Response**: Invitation URL
```json
{
  "invitationId": "uuid-here",
  "email": "newadmin@example.com",
  "invitationUrl": "https://app.ffl-playoffs.com/accept-admin-invite?token=xyz",
  "expiresAt": "2025-10-08T12:00:00Z"
}
```

#### Create PAT
```http
POST /api/v1/superadmin/pats
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "name": "analytics-service-token",
  "scope": "READ_ONLY",
  "expiresInDays": 365
}
```

**Response**: Token shown ONLY once
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

**UI**: Show modal with token, "Copy to Clipboard" button, warning message

#### Revoke PAT
```http
DELETE /api/v1/superadmin/pats/{patId}
Authorization: Bearer <jwt>
```

**Response**: 204 No Content

**UI**: Show confirmation modal: "Are you sure? This will break any services using this token."

### Data Display
- **Admins Table**: Name, Email, League Count, Active status, Actions
- **PATs Table**: Name, Scope, Last Used, Expires, Revoke button
- **Leagues Table**: Name, Admin, Player Count, Active status, View button

### Error States
- Not super admin (403): Redirect to Player Dashboard
- PAT creation limit reached: Show error "Maximum 10 active PATs allowed"

---

## 9. Score Breakdown Screen

### Purpose
Detailed score breakdown for a specific week and player.

### API Endpoints

#### Get Score Breakdown
```http
GET /api/v1/player/leagues/{leagueId}/scores/{weekNumber}
Authorization: Bearer <jwt>
```

**Response**: Detailed score breakdown
```json
{
  "playerId": 10,
  "playerName": "John Player",
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
    "fieldGoals": {
      "fg0to39": {"count": 1, "points": 3.0},
      "fg40to49": {"count": 0, "points": 0.0},
      "fg50Plus": {"count": 1, "points": 5.0}
    },
    "defensive": {
      "sacks": {"value": 2, "points": 2.0},
      "interceptions": {"value": 1, "points": 2.0},
      "fumbleRecoveries": {"value": 0, "points": 0.0},
      "safeties": {"value": 0, "points": 0.0},
      "defensiveTDs": {"value": 0, "points": 0.0},
      "pointsAllowed": {"value": 10, "tier": "7-13", "points": 4.0},
      "yardsAllowed": {"value": 280, "tier": "200-299", "points": 5.0},
      "total": 13.0
    }
  },
  "eliminated": false,
  "gameStatus": "FINAL"
}
```

### Data Display
- **Team Header**: Team logo, name, week, NFL week
- **Total Score**: Large display of total points
- **Breakdown Sections**:
  - Offensive Stats (passing, rushing, receiving, TDs)
  - Kicking Stats (field goals by distance)
  - Defensive Stats (sacks, INTs, points/yards allowed)
- **Points Calculation**: Show value + points for each stat
- **Elimination Status**: Red badge if eliminated

### User Actions

#### Close/Back
Navigate back to Leaderboard or Player Dashboard

#### View Different Week
Week selector dropdown, reload with new week parameter

### Responsive Behavior
- **Mobile**: Stacked sections, collapsible categories
- **Tablet**: Two-column layout (offense/defense)
- **Desktop**: Three-column layout with summary sidebar

---

## 10. Roster Management Screen

### Purpose
Draft-style roster building with NFL player search and assignment.

### API Endpoints

#### Get My Roster
```http
GET /api/v1/player/leagues/{leagueId}/roster
Authorization: Bearer <jwt>
```

**Response**: Current roster state
```json
{
  "rosterId": "550e8400-e29b-41d4-a716-446655440000",
  "leaguePlayerId": "660e8400-e29b-41d4-a716-446655440001",
  "gameId": "770e8400-e29b-41d4-a716-446655440002",
  "isLocked": false,
  "rosterDeadline": "2025-09-10T13:00:00Z",
  "totalScore": 0,
  "slots": [
    {
      "slotId": "slot-uuid-1",
      "position": "QB",
      "slotOrder": 1,
      "slotLabel": "QB",
      "nflPlayer": null
    },
    {
      "slotId": "slot-uuid-2",
      "position": "RB",
      "slotOrder": 1,
      "slotLabel": "RB1",
      "nflPlayer": {
        "id": 2001,
        "name": "Christian McCaffrey",
        "position": "RB",
        "nflTeam": "San Francisco 49ers",
        "fantasyPoints": 178.2
      }
    }
  ],
  "filledSlotCount": 5,
  "totalSlotCount": 9,
  "isComplete": false,
  "missingPositions": ["QB", "WR1", "TE", "K"]
}
```

#### Get Roster Configuration
```http
GET /api/v1/player/leagues/{leagueId}/roster-config
Authorization: Bearer <jwt>
```

**Response**: Position slot requirements
```json
{
  "leagueId": 1,
  "leagueName": "2025 NFL Playoffs Pool",
  "rosterConfiguration": {
    "positionSlots": {
      "QB": 1,
      "RB": 2,
      "WR": 2,
      "TE": 1,
      "FLEX": 1,
      "K": 1,
      "DEF": 1
    },
    "totalSlots": 9,
    "flexEligible": ["RB", "WR", "TE"],
    "superflexEligible": []
  }
}
```

#### Search NFL Players
```http
GET /api/v1/player/nfl-players?position=QB&name=Mahomes&page=0&size=20&sort=fantasyPoints,desc
Authorization: Bearer <jwt>
```

**Response**: Player search results
```json
{
  "players": [
    {
      "id": 1001,
      "name": "Patrick Mahomes",
      "firstName": "Patrick",
      "lastName": "Mahomes",
      "position": "QB",
      "nflTeam": "Kansas City Chiefs",
      "nflTeamAbbreviation": "KC",
      "jerseyNumber": 15,
      "status": "ACTIVE",
      "stats": {
        "gamesPlayed": 8,
        "fantasyPoints": 215.4,
        "averagePointsPerGame": 26.9
      }
    }
  ],
  "pagination": {
    "page": 0,
    "size": 20,
    "totalElements": 125,
    "totalPages": 7,
    "hasNext": true
  }
}
```

#### Assign Player to Slot
```http
POST /api/v1/player/leagues/{leagueId}/roster/slots/{slotId}/assign
Authorization: Bearer <jwt>
Content-Type: application/json

{
  "nflPlayerId": 1001
}
```

**Response**: Updated slot
```json
{
  "slotId": "slot-uuid-1",
  "position": "QB",
  "nflPlayer": {
    "id": 1001,
    "name": "Patrick Mahomes",
    "position": "QB",
    "nflTeam": "Kansas City Chiefs"
  },
  "message": "Player assigned successfully"
}
```

#### Remove Player from Slot
```http
DELETE /api/v1/player/leagues/{leagueId}/roster/slots/{slotId}
Authorization: Bearer <jwt>
```

**Response**: Empty slot
```json
{
  "slotId": "slot-uuid-1",
  "position": "QB",
  "message": "Player removed from slot successfully"
}
```

### User Interface

#### Layout
```
┌─────────────────────────────────────────────┐
│ Your Roster          5/9 filled   [Lock: 2h]│
├───────────────┬─────────────────────────────┤
│               │                             │
│ Roster Slots  │   Player Search             │
│               │                             │
│ [QB] Empty    │   Position: [QB ▼]          │
│ [RB1] CMC     │   Search: [______]          │
│ [RB2] Empty   │                             │
│ [WR1] Empty   │   [Patrick Mahomes] 215.4   │
│ [WR2] Empty   │   [Josh Allen]      198.2   │
│ [TE] Empty    │   [Lamar Jackson]   192.8   │
│ [FLEX] Empty  │                             │
│ [K] Empty     │   [Next] [Prev]             │
│ [DEF] Empty   │                             │
│               │                             │
└───────────────┴─────────────────────────────┘
```

### User Actions

#### Search for Player
1. Select position filter (optional)
2. Type in search box (debounced, 300ms)
3. API call: `GET /api/v1/player/nfl-players?position=QB&name=Mahomes`
4. Update player list

#### Drag Player to Slot
1. Drag player from search results
2. Drop on empty slot
3. API call: `POST .../slots/{slotId}/assign`
4. On success: Update roster UI, show success toast
5. On error: Show error modal (position mismatch, etc.)

#### Click Player to Add
1. Click player in search results
2. Show "Add to which slot?" modal
3. Display eligible slots (based on position)
4. Select slot
5. API call: `POST .../slots/{slotId}/assign`
6. Update UI

#### Remove Player from Slot
1. Click "X" button on filled slot
2. Show confirmation: "Remove [Player Name]?"
3. API call: `DELETE .../slots/{slotId}`
4. Update UI, player removed

### Error States

#### Position Mismatch
```json
{
  "error": "POSITION_MISMATCH",
  "message": "WR cannot fill TE slot",
  "details": {
    "playerPosition": "WR",
    "slotPosition": "TE",
    "eligiblePositions": ["TE"]
  }
}
```
**UI**: Show error toast: "Justin Jefferson (WR) cannot fill TE slot"

#### Player Already on Roster
```json
{
  "error": "PLAYER_ALREADY_ON_ROSTER",
  "message": "Patrick Mahomes is already on your roster in position QB"
}
```
**UI**: Highlight existing slot, show error toast

#### Roster Locked
```json
{
  "error": "ROSTER_LOCKED",
  "message": "Roster is locked - no changes allowed",
  "details": {
    "rosterDeadline": "2025-09-10T13:00:00Z",
    "lockedAt": "2025-09-10T13:00:00Z"
  }
}
```
**UI**: Gray out entire roster, show banner: "Roster locked. Season has started."

### Responsive Behavior
- **Mobile**: Stacked layout, tabs for Roster/Search
- **Tablet**: Side-by-side, narrower search panel
- **Desktop**: Full two-panel layout

---

## Common Patterns

### Loading States
All API calls should show loading indicators:
- **Button loading**: Spinner icon + disabled state
- **Page loading**: Skeleton screens matching final layout
- **Table loading**: Skeleton rows
- **Card loading**: Skeleton cards

### Error Handling
Standard error response format:
```json
{
  "error": "ERROR_CODE",
  "message": "Human-readable error message",
  "details": { /* context */ },
  "timestamp": "2025-10-01T12:00:00Z",
  "path": "/api/v1/..."
}
```

Error UI patterns:
- **Inline errors**: Show below form fields
- **Toast notifications**: For success/error after actions
- **Modal dialogs**: For critical errors requiring acknowledgment
- **Error pages**: For 404, 403, 500 errors

### Authentication
All authenticated endpoints require:
```http
Authorization: Bearer <google-jwt-token>
```

On 401 Unauthorized response:
1. Clear stored JWT
2. Redirect to Login Screen
3. Show toast: "Session expired. Please sign in again."

On 403 Forbidden response:
1. Show error page: "You don't have permission to access this resource."
2. Provide "Go to Dashboard" button

### Polling Strategy
For real-time updates during live games:
- Poll every 30 seconds for leaderboard
- Poll every 60 seconds for score breakdowns
- Stop polling when games are final
- Use exponential backoff on errors

---

## API Base URL

All endpoints use base URL:
```
https://<pod-ip>/api/v1
```

For local development:
```
http://localhost:443/api/v1
```

---

## Next Steps
1. Implement authentication flow with Google OAuth
2. Create API client service layer with error handling
3. Build state management for API responses
4. Implement polling/refresh strategies
5. Add request caching to minimize API calls
