# Screen Wireframes - FFL Playoffs

## Table of Contents
1. [Login Screen](#1-login-screen)
2. [Player Dashboard](#2-player-dashboard)
3. [Team Selection Screen](#3-team-selection-screen)
4. [Leaderboard Screen](#4-leaderboard-screen)
5. [Admin Dashboard](#5-admin-dashboard)
6. [League Configuration Screen](#6-league-configuration-screen)
7. [Super Admin Dashboard](#7-super-admin-dashboard)
8. [Invitation Acceptance Screen](#8-invitation-acceptance-screen)

---

## 1. Login Screen

### Desktop Layout (>1024px)
```
┌────────────────────────────────────────────────────────────┐
│                                                            │
│                                                            │
│                       🏈                                   │
│                 FFL PLAYOFFS                               │
│            Fantasy Football Playoffs Game                  │
│                                                            │
│                                                            │
│            ┌──────────────────────────┐                   │
│            │  Sign in with Google  🔐 │                   │
│            └──────────────────────────┘                   │
│                                                            │
│                                                            │
│         New to FFL Playoffs? Get started now!              │
│                                                            │
│                                                            │
└────────────────────────────────────────────────────────────┘
```

### Mobile Layout (<768px)
```
┌──────────────────────┐
│                      │
│         🏈           │
│    FFL PLAYOFFS      │
│                      │
│   Fantasy Football   │
│    Playoffs Game     │
│                      │
│                      │
│  ┌────────────────┐ │
│  │ Sign in with   │ │
│  │   Google  🔐   │ │
│  └────────────────┘ │
│                      │
│  New to FFL?         │
│  Get started!        │
│                      │
└──────────────────────┘
```

### Components Used
- Button (Primary, Large)
- Logo/Brand
- Typography (H1, Body)

### API Endpoints
- `GET /api/auth/google` - Initiate Google OAuth flow
- `POST /api/auth/callback` - Handle OAuth callback
- `POST /api/auth/token` - Exchange code for JWT

### User Interactions
1. Click "Sign in with Google" button
2. Redirect to Google OAuth consent screen
3. User approves access
4. Redirect back to app with auth code
5. Exchange code for JWT token
6. Store token in local storage
7. Redirect to appropriate dashboard (Player/Admin/Super Admin)

### States
- **Default**: Show login button
- **Loading**: Show spinner during OAuth redirect
- **Error**: Display error message if auth fails
- **Success**: Redirect to dashboard

### Responsive Breakpoints
- Mobile (<768px): Stacked layout, full-width button
- Tablet (768-1024px): Same as mobile, more padding
- Desktop (>1024px): Centered card layout

---

## 2. Player Dashboard

### Desktop Layout (>1024px)
```
┌────────────────────────────────────────────────────────────────┐
│  🏈 FFL Playoffs    [My Leagues] [Make Picks] [Stats]    👤 JD │
└────────────────────────────────────────────────────────────────┘
┌────────────────────────────────────────────────────────────────┐
│  My Leagues                                      [+ Join League]│
│                                                                 │
│  ┌───────────────────────────┐  ┌───────────────────────────┐ │
│  │ 🏈 Office League          │  │ 🏈 Friends League         │ │
│  │ Admin: John D • 12 players│  │ Admin: Sarah K • 8 players│ │
│  ├───────────────────────────┤  ├───────────────────────────┤ │
│  │ Week 6 of 18              │  │ Week 6 of 18              │ │
│  │ ⚠ Picks due in 2 days     │  │ ✓ Picks submitted         │ │
│  │ Your Rank: #3 of 12       │  │ Your Rank: #1 of 8        │ │
│  │ Points: 145               │  │ Points: 162               │ │
│  ├───────────────────────────┤  ├───────────────────────────┤ │
│  │ [View League] [Make Picks]│  │ [View League]             │ │
│  └───────────────────────────┘  └───────────────────────────┘ │
│                                                                 │
│  ┌───────────────────────────┐  ┌───────────────────────────┐ │
│  │ 🏈 Family League          │  │ 🔒 College Buddies        │ │
│  │ Admin: Mom • 6 players    │  │ Admin: Mike • 10 players  │ │
│  ├───────────────────────────┤  ├───────────────────────────┤ │
│  │ Week 6 of 14              │  │ ⚫ Eliminated Week 4       │ │
│  │ ✓ Picks submitted         │  │ Final Rank: #7 of 10      │ │
│  │ Your Rank: #2 of 6        │  │ Points: 82                │ │
│  │ Points: 138               │  │                           │ │
│  ├───────────────────────────┤  ├───────────────────────────┤ │
│  │ [View League]             │  │ [View League]             │ │
│  └───────────────────────────┘  └───────────────────────────┘ │
│                                                                 │
│  Quick Stats                                                    │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Active Leagues: 3  │  Total Points: 445  │  Best Rank: #1│ │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Pending Invitations                                            │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │  🏈 Neighborhood League (invited by Tom)                │   │
│  │      Starts Week 7 • 12 players        [Accept] [Decline]│  │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### Mobile Layout (<768px)
```
┌──────────────────────────────┐
│  ☰  FFL Playoffs       👤 JD │
└──────────────────────────────┘
┌──────────────────────────────┐
│  My Leagues    [+ Join]      │
│                              │
│  ┌────────────────────────┐ │
│  │ 🏈 Office League       │ │
│  │ John D • 12 players    │ │
│  │                        │ │
│  │ Week 6/18              │ │
│  │ ⚠ Due in 2 days        │ │
│  │ Rank: #3 • 145 pts     │ │
│  │                        │ │
│  │ [View] [Make Picks]    │ │
│  └────────────────────────┘ │
│                              │
│  ┌────────────────────────┐ │
│  │ 🏈 Friends League      │ │
│  │ Sarah K • 8 players    │ │
│  │                        │ │
│  │ Week 6/18              │ │
│  │ ✓ Picks submitted      │ │
│  │ Rank: #1 • 162 pts     │ │
│  │                        │ │
│  │ [View League]          │ │
│  └────────────────────────┘ │
│                              │
│  Quick Stats                 │
│  ┌────────────────────────┐ │
│  │ Active: 3              │ │
│  │ Points: 445            │ │
│  │ Best: #1               │ │
│  └────────────────────────┘ │
│                              │
│  Pending (1)                 │
│  ┌────────────────────────┐ │
│  │ Neighborhood League    │ │
│  │ Invited by Tom         │ │
│  │ [Accept] [Decline]     │ │
│  └────────────────────────┘ │
└──────────────────────────────┘
```

### Components Used
- Navigation (Header with tabs)
- Card (League Card - multiple instances)
- Button (Primary, Secondary)
- Badge (Warning, Success, Eliminated)
- Stats Display
- Avatar

### API Endpoints
- `GET /api/player/leagues` - Get all leagues for player
- `GET /api/player/stats` - Get aggregate stats
- `GET /api/player/invitations` - Get pending invitations
- `POST /api/invitations/{id}/accept` - Accept invitation
- `POST /api/invitations/{id}/decline` - Decline invitation

### User Interactions
1. View all leagues at a glance
2. Click "Make Picks" to go to Team Selection
3. Click "View League" to see Leaderboard
4. Click "+ Join League" to enter league code/link
5. Accept/Decline pending invitations
6. Navigate using header tabs
7. Pull to refresh on mobile

### States
- **Loading**: Skeleton cards while fetching
- **Empty**: No leagues yet, show CTA to create/join
- **Error**: Failed to load leagues, retry button
- **Success**: Display all leagues

### Responsive Breakpoints
- Mobile (<768px): Single column, stacked cards, hamburger menu
- Tablet (768-1024px): 2 columns, cards smaller
- Desktop (>1024px): 2-3 columns, full navigation

---

## 3. Team Selection Screen

### Desktop Layout (>1024px)
```
┌────────────────────────────────────────────────────────────────┐
│  🏈 FFL Playoffs                                         👤 JD │
└────────────────────────────────────────────────────────────────┘
┌────────────────────────────────────────────────────────────────┐
│  ← Office League                                                │
│                                                                 │
│  Make Your Pick - Week 6                                        │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Deadline: Thu Sep 14, 8:00 PM ET                       │  │
│  │  ┌────┬────┬────┬────┐                                  │  │
│  │  │ 02 │ 15 │ 32 │ 45 │  Time Remaining                 │  │
│  │  │Days│Hrs │Min │Sec │                                  │  │
│  │  └────┴────┴────┴────┘                                  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Select Your Team (You've used 5 of 32 teams)                  │
│                                                                 │
│  AFC East                                                       │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐         │
│  │   [🏈]   │ │   ⚫     │ │   [🏈]   │ │   [🏈]   │         │
│  │   BUF    │ │   NE     │ │   MIA    │ │   NYJ    │         │
│  │  Bills   │ │Patriots  │ │ Dolphins │ │   Jets   │         │
│  │   6-0    │ │   USED   │ │   3-3    │ │   2-4    │         │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘         │
│                                                                 │
│  AFC North                                                      │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐         │
│  │   [🏈]   │ │   [🏈]   │ │   ⚫     │ │   [🏈]   │         │
│  │   BAL    │ │   CIN    │ │   CLE    │ │   PIT    │         │
│  │  Ravens  │ │ Bengals  │ │ Browns   │ │ Steelers │         │
│  │   5-1    │ │   4-2    │ │   USED   │ │   3-3    │         │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘         │
│                                                                 │
│  [Show AFC South] [Show AFC West] [Show NFC Teams]             │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Selected: None                                          │  │
│  │                                                          │  │
│  │  [Confirm Selection]                                     │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### Mobile Layout (<768px)
```
┌──────────────────────────────┐
│  ← Office League       👤 JD │
└──────────────────────────────┘
┌──────────────────────────────┐
│  Week 6 Picks                │
│                              │
│  ┌────────────────────────┐ │
│  │ Deadline:              │ │
│  │ Thu Sep 14, 8:00 PM    │ │
│  │ ┌───┬───┬───┬───┐     │ │
│  │ │02D│15H│32M│45S│     │ │
│  │ └───┴───┴───┴───┘     │ │
│  └────────────────────────┘ │
│                              │
│  AFC East                    │
│  ┌──────┐ ┌──────┐          │
│  │ [🏈] │ │  ⚫  │          │
│  │ BUF  │ │  NE  │          │
│  │Bills │ │ Used │          │
│  │ 6-0  │ │      │          │
│  └──────┘ └──────┘          │
│  ┌──────┐ ┌──────┐          │
│  │ [🏈] │ │ [🏈] │          │
│  │ MIA  │ │ NYJ  │          │
│  │Dolph │ │Jets  │          │
│  │ 3-3  │ │ 2-4  │          │
│  └──────┘ └──────┘          │
│                              │
│  [AFC North ▼]               │
│  [AFC South ▼]               │
│  [AFC West ▼]                │
│  [NFC Teams ▼]               │
│                              │
│  ┌────────────────────────┐ │
│  │ Selected: None         │ │
│  │                        │ │
│  │ [Confirm Selection]    │ │
│  └────────────────────────┘ │
└──────────────────────────────┘
```

### Components Used
- Navigation (Header with back button)
- Countdown Timer
- Team Selection Cards (grid layout)
- Badge (Used, Eliminated)
- Button (Primary for confirm)
- Accordion (collapsed divisions on mobile)

### API Endpoints
- `GET /api/leagues/{id}/current-week` - Get current week info
- `GET /api/teams` - Get all NFL teams with records
- `GET /api/picks/{leagueId}/history` - Get player's used teams
- `POST /api/picks` - Submit team selection
- `PUT /api/picks/{id}` - Update team selection (before deadline)

### User Interactions
1. View countdown to deadline
2. Browse teams by division
3. Click team card to select
4. See visual feedback on selection
5. Click "Confirm Selection" to submit
6. See used teams grayed out
7. Filter/search teams (optional)

### States
- **Loading**: Fetch teams and deadline
- **Selecting**: User browsing and selecting team
- **Selected**: Team chosen, ready to confirm
- **Submitting**: API call in progress
- **Success**: Pick confirmed, redirect to dashboard
- **Error**: Failed to submit, show retry
- **Deadline Passed**: All teams locked, view-only mode

### Responsive Breakpoints
- Mobile (<768px): 2 teams per row, accordion divisions
- Tablet (768-1024px): 3-4 teams per row
- Desktop (>1024px): 4-6 teams per row, all divisions visible

---

## 4. Leaderboard Screen

### Desktop Layout (>1024px)
```
┌────────────────────────────────────────────────────────────────┐
│  🏈 FFL Playoffs                                         👤 JD │
└────────────────────────────────────────────────────────────────┘
┌────────────────────────────────────────────────────────────────┐
│  ← Office League                                                │
│                                                                 │
│  📊 Leaderboard - Week 6 of 18                                 │
│                                                                 │
│  [Overview] [Standings] [Weekly Results] [Settings]            │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ Rank │ Player        │ This Week │ Total │ Streak │ ⚡  │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │  🥇  │ Sarah Johnson │    24     │  162  │  W-6   │  ✓  │  │
│  │      │ Team: Chiefs  │           │       │        │     │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │  🥈  │ Mike Davis    │    18     │  156  │  W-4   │  ✓  │  │
│  │      │ Team: Bills   │           │       │        │     │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │  🥉  │ You (John D)  │    21     │  145  │  W-2   │  ✓  │  │
│  │      │ Team: 49ers   │           │       │        │     │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │  4   │ Lisa Wong     │    15     │  142  │  L-1   │  ✓  │  │
│  │      │ Team: Cowboys │           │       │        │     │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │  5   │ Tom Anderson  │    12     │  138  │  W-1   │  ✓  │  │
│  │      │ Team: Eagles  │           │       │        │     │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │  6   │ Amy Chen      │    16     │  135  │  W-3   │  ✓  │  │
│  │      │ Team: Ravens  │           │       │        │     │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │  7   │ Bob Smith     │     8     │  128  │  L-2   │  ✓  │  │
│  │      │ Team: Packers │           │       │        │     │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │  ⚫  │ Chris Lee     │     0     │   95  │  L-3   │  ✗  │  │
│  │      │ Eliminated W4 │           │       │        │     │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │  ⚫  │ Emma Wilson   │     0     │   88  │  L-4   │  ✗  │  │
│  │      │ Eliminated W3 │           │       │        │     │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  League Stats                                                   │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Active Players: 7  │  Eliminated: 2  │  Avg Points: 132 │  │
│  │  Highest Week: 24   │  Weeks Left: 12 │  Teams Used: 54  │  │
│  └──────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────┘
```

### Mobile Layout (<768px)
```
┌──────────────────────────────┐
│  ← Office League       👤 JD │
└──────────────────────────────┘
┌──────────────────────────────┐
│  📊 Leaderboard - Week 6     │
│                              │
│  [Overview] [Standings]      │
│                              │
│  ┌────────────────────────┐ │
│  │ 🥇 1st Place           │ │
│  │ Sarah Johnson          │ │
│  │ Chiefs • 162 pts       │ │
│  │ This week: 24 • W-6    │ │
│  │ ✓ Active               │ │
│  └────────────────────────┘ │
│                              │
│  ┌────────────────────────┐ │
│  │ 🥈 2nd Place           │ │
│  │ Mike Davis             │ │
│  │ Bills • 156 pts        │ │
│  │ This week: 18 • W-4    │ │
│  │ ✓ Active               │ │
│  └────────────────────────┘ │
│                              │
│  ┌────────────────────────┐ │
│  │ 🥉 3rd Place (You)     │ │
│  │ John Doe               │ │
│  │ 49ers • 145 pts        │ │
│  │ This week: 21 • W-2    │ │
│  │ ✓ Active               │ │
│  └────────────────────────┘ │
│                              │
│  ┌────────────────────────┐ │
│  │ #4 Lisa Wong           │ │
│  │ Cowboys • 142 pts      │ │
│  │ Week: 15 • L-1 • ✓     │ │
│  └────────────────────────┘ │
│                              │
│  [Show More]                 │
│                              │
│  League Stats                │
│  ┌────────────────────────┐ │
│  │ Active: 7              │ │
│  │ Eliminated: 2          │ │
│  │ Avg Points: 132        │ │
│  └────────────────────────┘ │
└──────────────────────────────┘
```

### Components Used
- Navigation (Header with tabs)
- Table (Desktop) / Cards (Mobile)
- Badge (Active, Eliminated, Medals)
- Stats Display
- Tabs

### API Endpoints
- `GET /api/leagues/{id}/leaderboard` - Get current standings
- `GET /api/leagues/{id}/weekly-results` - Get week-by-week results
- `GET /api/leagues/{id}/stats` - Get aggregate league stats
- `GET /api/picks/{leagueId}/player/{playerId}` - Get player's picks history

### User Interactions
1. View real-time standings
2. Switch between tabs (Overview, Standings, Weekly Results)
3. Click player to see their pick history
4. Sort by different columns (desktop)
5. Pull to refresh on mobile
6. Share leaderboard (optional)

### States
- **Loading**: Skeleton rows while fetching
- **Success**: Display full leaderboard
- **Error**: Failed to load, retry button
- **Real-time Update**: New scores come in, animate changes

### Responsive Breakpoints
- Mobile (<768px): Card-based layout, top 3 emphasized
- Tablet (768-1024px): Condensed table
- Desktop (>1024px): Full table with all columns

---

## 5. Admin Dashboard

### Desktop Layout (>1024px)
```
┌────────────────────────────────────────────────────────────────┐
│  🏈 FFL Playoffs                                         👤 JD │
└────────────────────────────────────────────────────────────────┘
┌────────────────────────────────────────────────────────────────┐
│  Admin Dashboard                              [+ Create League] │
│                                                                 │
│  My Leagues (Admin)                                             │
│                                                                 │
│  ┌────────────────────────────────────────────────────────┐    │
│  │ 🏈 Office League                           [⚙ Manage] │    │
│  │ 12 players • Week 6 of 18 • Started Sep 7               │    │
│  ├────────────────────────────────────────────────────────┤    │
│  │  📊 Active: 10  │  ⚫ Eliminated: 2  │  ⏱ Picks: 8/10  │    │
│  ├────────────────────────────────────────────────────────┤    │
│  │  [View Leaderboard] [Invite Players] [Configure]       │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌────────────────────────────────────────────────────────┐    │
│  │ 🏈 Family League                           [⚙ Manage] │    │
│  │ 6 players • Week 6 of 14 • Started Sep 14               │    │
│  ├────────────────────────────────────────────────────────┤    │
│  │  📊 Active: 6  │  ⚫ Eliminated: 0  │  ⏱ Picks: 6/6   │    │
│  ├────────────────────────────────────────────────────────┤    │
│  │  [View Leaderboard] [Invite Players] [Configure]       │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  Recent Activity                                                │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  • Sarah Johnson submitted picks (Office League)        │    │
│  │    2 minutes ago                                        │    │
│  │                                                         │    │
│  │  • Tom Anderson joined Family League                    │    │
│  │    1 hour ago                                           │    │
│  │                                                         │    │
│  │  • Week 5 results calculated (Office League)            │    │
│  │    2 days ago                                           │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  Pending Actions                                                │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  ⚠ 2 players haven't submitted picks (Office League)    │    │
│  │     Deadline in 2 days                                  │    │
│  │     [Send Reminder]                                     │    │
│  └────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

### Mobile Layout (<768px)
```
┌──────────────────────────────┐
│  ☰  Admin Dashboard    👤 JD │
└──────────────────────────────┘
┌──────────────────────────────┐
│  My Leagues    [+ Create]    │
│                              │
│  ┌────────────────────────┐ │
│  │ 🏈 Office League       │ │
│  │ 12 players • Week 6/18 │ │
│  │                        │ │
│  │ Active: 10             │ │
│  │ Eliminated: 2          │ │
│  │ Picks: 8/10            │ │
│  │                        │ │
│  │ [Leaderboard]          │ │
│  │ [Invite] [Configure]   │ │
│  └────────────────────────┘ │
│                              │
│  ┌────────────────────────┐ │
│  │ 🏈 Family League       │ │
│  │ 6 players • Week 6/14  │ │
│  │                        │ │
│  │ Active: 6              │ │
│  │ Picks: 6/6             │ │
│  │                        │ │
│  │ [Leaderboard]          │ │
│  │ [Invite] [Configure]   │ │
│  └────────────────────────┘ │
│                              │
│  Pending Actions (1)         │
│  ┌────────────────────────┐ │
│  │ ⚠ 2 players need to    │ │
│  │   submit picks         │ │
│  │   Office League        │ │
│  │   [Send Reminder]      │ │
│  └────────────────────────┘ │
└──────────────────────────────┘
```

### Components Used
- Navigation (Header)
- Card (League Admin Card)
- Button (Primary, Secondary)
- Stats Display
- Alert (Pending actions)
- Activity Feed

### API Endpoints
- `GET /api/admin/leagues` - Get leagues where user is admin
- `GET /api/leagues/{id}/activity` - Get recent activity
- `GET /api/leagues/{id}/pending-picks` - Get players who haven't picked
- `POST /api/leagues` - Create new league
- `POST /api/invitations` - Invite players to league
- `POST /api/notifications/reminder` - Send pick reminder

### User Interactions
1. View all leagues where user is admin
2. Click "Create League" to start league creation flow
3. Click "Manage" to configure league settings
4. Click "Invite Players" to send invitations
5. Click "Send Reminder" to nudge players
6. View activity feed
7. Navigate to leaderboard

### States
- **Loading**: Fetch admin leagues
- **Empty**: No leagues created yet, show CTA
- **Success**: Display all leagues with stats
- **Error**: Failed to load

### Responsive Breakpoints
- Mobile (<768px): Stacked cards, condensed stats
- Tablet (768-1024px): 2 columns
- Desktop (>1024px): Full layout with activity feed

---

## 6. League Configuration Screen

### Desktop Layout (>1024px)
```
┌────────────────────────────────────────────────────────────────┐
│  🏈 FFL Playoffs                                         👤 JD │
└────────────────────────────────────────────────────────────────┘
┌────────────────────────────────────────────────────────────────┐
│  ← Office League                                                │
│                                                                 │
│  ⚙️ League Configuration                                        │
│                                                                 │
│  [Basic Info] [Scoring] [Schedule] [Rules] [Players]           │
│                                                                 │
│  Basic Information                                              │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  League Name                                           │    │
│  │  ┌──────────────────────────────────────────────────┐ │    │
│  │  │ Office League                                    │ │    │
│  │  └──────────────────────────────────────────────────┘ │    │
│  │                                                        │    │
│  │  Description (Optional)                                │    │
│  │  ┌──────────────────────────────────────────────────┐ │    │
│  │  │ Weekly NFL survivor pool for the office          │ │    │
│  │  └──────────────────────────────────────────────────┘ │    │
│  │                                                        │    │
│  │  League Code: OFF2024XYZ                               │    │
│  │  Share this code for players to join                  │    │
│  │  [Copy Code]                                           │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  Schedule                                                       │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  Starting Week                                         │    │
│  │  ┌──────────────────────┐                             │    │
│  │  │ Week 1           ▼  │                             │    │
│  │  └──────────────────────┘                             │    │
│  │                                                        │    │
│  │  Ending Week                                           │    │
│  │  ┌──────────────────────┐                             │    │
│  │  │ Week 18          ▼  │                             │    │
│  │  └──────────────────────┘                             │    │
│  │                                                        │    │
│  │  Pick Deadline                                         │    │
│  │  ☐ Thursday 8:00 PM ET (first game)                   │    │
│  │  ☑ Custom deadline                                     │    │
│  │  ┌──────────────────┐  ┌──────────────────┐          │    │
│  │  │ Thursday     ▼  │  │ 6:00 PM ET   ▼  │          │    │
│  │  └──────────────────┘  └──────────────────┘          │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  Scoring Configuration                                          │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  Points System                                         │    │
│  │  ☑ Use team total score (default)                     │    │
│  │  ☐ Custom scoring breakdown                            │    │
│  │                                                        │    │
│  │  Defensive Scoring (Optional)                          │    │
│  │  ┌──────────────────────────────────────────────────┐ │    │
│  │  │  Points Allowed     │  Bonus Points              │ │    │
│  │  │  0 points           │  +10                       │ │    │
│  │  │  1-6 points         │  +7                        │ │    │
│  │  │  7-13 points        │  +4                        │ │    │
│  │  │  14-20 points       │  +1                        │ │    │
│  │  │  21+ points         │  +0                        │ │    │
│  │  └──────────────────────────────────────────────────┘ │    │
│  │                                                        │    │
│  │  Field Goal Bonuses                                    │    │
│  │  ☑ Enable field goal bonuses                          │    │
│  │  ┌──────────────────────────────────────────────────┐ │    │
│  │  │  40-49 yards  │  +3 points                       │ │    │
│  │  │  50+ yards    │  +5 points                       │ │    │
│  │  └──────────────────────────────────────────────────┘ │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  Elimination Rules                                              │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  Elimination Condition                                 │    │
│  │  ☑ Loss eliminates player (survivor style)            │    │
│  │  ☐ Lowest score each week eliminates                  │    │
│  │  ☐ Custom threshold (score below X)                   │    │
│  │                                                        │    │
│  │  ☑ Each team can only be used once                    │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  ┌────────────────────────────────────────────────────────┐    │
│  │                              [Cancel]  [Save Changes]  │    │
│  └────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

### Mobile Layout (<768px)
```
┌──────────────────────────────┐
│  ← Office League       👤 JD │
└──────────────────────────────┘
┌──────────────────────────────┐
│  ⚙️ Configuration            │
│                              │
│  [Basic] [Scoring] [Rules]   │
│                              │
│  League Name                 │
│  ┌────────────────────────┐ │
│  │ Office League          │ │
│  └────────────────────────┘ │
│                              │
│  Description                 │
│  ┌────────────────────────┐ │
│  │ Weekly NFL survivor    │ │
│  │ pool for office        │ │
│  └────────────────────────┘ │
│                              │
│  League Code                 │
│  OFF2024XYZ                  │
│  [Copy Code]                 │
│                              │
│  Starting Week               │
│  ┌────────────────────────┐ │
│  │ Week 1             ▼  │ │
│  └────────────────────────┘ │
│                              │
│  Ending Week                 │
│  ┌────────────────────────┐ │
│  │ Week 18            ▼  │ │
│  └────────────────────────┘ │
│                              │
│  Deadline                    │
│  ┌────────────────────────┐ │
│  │ Thursday           ▼  │ │
│  │ 6:00 PM ET         ▼  │ │
│  └────────────────────────┘ │
│                              │
│  [Cancel] [Save]             │
└──────────────────────────────┘
```

### Components Used
- Navigation (Header with tabs)
- Input (Text, Number)
- Select (Dropdown)
- Checkbox
- Radio buttons
- Button (Primary, Secondary)
- Table (Scoring config)

### API Endpoints
- `GET /api/leagues/{id}/config` - Get current configuration
- `PUT /api/leagues/{id}/config` - Update configuration
- `GET /api/config/defaults` - Get default scoring rules
- `POST /api/leagues/{id}/validate` - Validate config before saving

### User Interactions
1. Edit league name and description
2. Configure starting/ending weeks
3. Set custom deadline
4. Enable/disable scoring bonuses
5. Configure defensive scoring
6. Set elimination rules
7. Save changes (validation required)
8. Cancel to discard changes

### States
- **Loading**: Fetch current config
- **Editing**: User making changes
- **Validating**: Check if config is valid
- **Saving**: Submitting changes
- **Success**: Config saved, show toast
- **Error**: Validation failed, show errors

### Responsive Breakpoints
- Mobile (<768px): Single column, tabs for sections
- Tablet (768-1024px): Condensed layout
- Desktop (>1024px): Full form with all sections

---

## 7. Super Admin Dashboard

### Desktop Layout (>1024px)
```
┌────────────────────────────────────────────────────────────────┐
│  🏈 FFL Playoffs - Super Admin                           👤 SA │
└────────────────────────────────────────────────────────────────┘
┌────────────────────────────────────────────────────────────────┐
│  Super Admin Dashboard                                          │
│                                                                 │
│  [Overview] [Admins] [Leagues] [System]                        │
│                                                                 │
│  Platform Overview                                              │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Total Leagues: 127  │  Active Players: 1,543            │  │
│  │  Total Admins: 45    │  Active Games: 89                 │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
│  Admin Management                               [+ Create Admin]│
│  ┌────────────────────────────────────────────────────────┐    │
│  │  Email            │ Name       │ Leagues │ Status  │   │    │
│  ├────────────────────────────────────────────────────────┤    │
│  │  john@email.com   │ John Doe   │    3    │ Active  │⚙ │    │
│  │  sarah@email.com  │ Sarah K    │    5    │ Active  │⚙ │    │
│  │  mike@email.com   │ Mike Davis │    2    │ Active  │⚙ │    │
│  │  lisa@email.com   │ Lisa Wong  │    1    │ Pending │⚙ │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  Personal Access Tokens                          [+ Create PAT] │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  Token Name       │ Created    │ Last Used │ Actions  │    │
│  ├────────────────────────────────────────────────────────┤    │
│  │  API Integration  │ 2024-09-01 │ 2 min ago │ [Revoke] │    │
│  │  Mobile App       │ 2024-08-15 │ 1 day ago │ [Revoke] │    │
│  │  Test Token       │ 2024-07-20 │ Never     │ [Revoke] │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  All Leagues                                       [Filters ▼]  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  League Name      │ Admin    │ Players │ Week │ Status │    │
│  ├────────────────────────────────────────────────────────┤    │
│  │  Office League    │ John D   │   12    │ 6/18 │ Active │    │
│  │  Friends League   │ Sarah K  │    8    │ 6/18 │ Active │    │
│  │  Family League    │ John D   │    6    │ 6/14 │ Active │    │
│  │  College Buddies  │ Mike D   │   10    │  -   │ Ended  │    │
│  └────────────────────────────────────────────────────────┘    │
│                                                                 │
│  System Health                                                  │
│  ┌────────────────────────────────────────────────────────┐    │
│  │  API Status: ✓ Healthy     │  Uptime: 99.9%            │    │
│  │  Database: ✓ Normal        │  Active Connections: 42   │    │
│  └────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
```

### Components Used
- Navigation (Header with tabs)
- Table (Admins, PATs, Leagues)
- Button (Primary, Secondary, Danger)
- Stats Display
- Modal (Create admin, Create PAT)
- Badge (Status indicators)

### API Endpoints
- `GET /api/super-admin/overview` - Platform stats
- `GET /api/super-admin/admins` - List all admins
- `POST /api/super-admin/admins` - Create new admin
- `DELETE /api/super-admin/admins/{id}` - Remove admin
- `GET /api/super-admin/pats` - List all PATs
- `POST /api/super-admin/pats` - Create new PAT
- `DELETE /api/super-admin/pats/{id}` - Revoke PAT
- `GET /api/super-admin/leagues` - List all leagues
- `GET /api/super-admin/system-health` - System metrics

### User Interactions
1. View platform-wide statistics
2. Create new admin accounts
3. Manage admin permissions
4. Create/revoke Personal Access Tokens
5. View all leagues across platform
6. Filter and search leagues
7. Monitor system health

### States
- **Loading**: Fetch all super admin data
- **Success**: Display all panels
- **Error**: Failed to load data

### Responsive Breakpoints
- Desktop only (>1024px recommended)
- Can work on tablet but cramped

---

## 8. Invitation Acceptance Screen

### Desktop Layout (>1024px)
```
┌────────────────────────────────────────────────────────────────┐
│                                                                 │
│                       🏈                                        │
│                 FFL PLAYOFFS                                    │
│                                                                 │
│            You've been invited!                                 │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                                                          │  │
│  │  John Doe invited you to join                           │  │
│  │                                                          │  │
│  │  🏈 Office League                                        │  │
│  │                                                          │  │
│  │  • 12 players currently                                 │  │
│  │  • Week 6 of 18                                         │  │
│  │  • Started Sep 7, 2024                                  │  │
│  │  • Next deadline: Thu Sep 14, 6:00 PM ET               │  │
│  │                                                          │  │
│  │  League Description:                                     │  │
│  │  Weekly NFL survivor pool for the office. Pick one      │  │
│  │  team each week, can't reuse teams, loss eliminates.    │  │
│  │                                                          │  │
│  │  Sign in to accept this invitation                      │  │
│  │                                                          │  │
│  │  ┌────────────────────────┐                             │  │
│  │  │  Sign in with Google  │                             │  │
│  │  └────────────────────────┘                             │  │
│  │                                                          │  │
│  │  Already have an account? Sign in to accept             │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Mobile Layout (<768px)
```
┌──────────────────────────────┐
│                              │
│         🏈                   │
│    FFL PLAYOFFS              │
│                              │
│  You've been invited!        │
│                              │
│  ┌────────────────────────┐ │
│  │                        │ │
│  │ John Doe invited you   │ │
│  │ to join:               │ │
│  │                        │ │
│  │ 🏈 Office League       │ │
│  │                        │ │
│  │ • 12 players           │ │
│  │ • Week 6/18            │ │
│  │ • Started Sep 7        │ │
│  │ • Deadline: Thu 6PM    │ │
│  │                        │ │
│  │ Weekly NFL survivor    │ │
│  │ pool for the office.   │ │
│  │ Pick one team each     │ │
│  │ week, can't reuse,     │ │
│  │ loss eliminates.       │ │
│  │                        │ │
│  │ ┌──────────────────┐  │ │
│  │ │ Sign in with     │  │ │
│  │ │ Google           │  │ │
│  │ └──────────────────┘  │ │
│  │                        │ │
│  └────────────────────────┘ │
│                              │
└──────────────────────────────┘
```

### Components Used
- Card (Invitation details)
- Button (Primary for sign in)
- Typography (League info)

### API Endpoints
- `GET /api/invitations/{token}` - Get invitation details
- `POST /api/invitations/{token}/accept` - Accept invitation (requires auth)
- `POST /api/auth/google` - Authenticate with Google

### User Interactions
1. Click invitation link in email
2. View league details
3. Click "Sign in with Google"
4. Authenticate
5. Automatically accept invitation
6. Redirect to league dashboard

### States
- **Loading**: Fetch invitation details
- **Valid**: Show invitation, allow acceptance
- **Invalid**: Token expired or already used
- **Accepted**: Invitation already accepted
- **Error**: Failed to load invitation

### Responsive Breakpoints
- Mobile (<768px): Full screen card
- Tablet (768-1024px): Centered card
- Desktop (>1024px): Centered card, max 600px width

---

## Navigation Flows

### 1. Authentication Flow
```
Login Screen
     │
     ├─→ Google OAuth
     │
     ├─→ Player Dashboard (if player only)
     ├─→ Admin Dashboard (if admin)
     └─→ Super Admin Dashboard (if super admin)
```

### 2. Player Making Picks Flow
```
Player Dashboard
     │
     ├─→ Click "Make Picks"
     │
     ├─→ Team Selection Screen
     │   │
     │   ├─→ Select Team
     │   ├─→ Confirm Selection
     │   │
     │   └─→ Success → Back to Dashboard
     │
     └─→ View Leaderboard
```

### 3. Admin Creating League Flow
```
Admin Dashboard
     │
     ├─→ Click "Create League"
     │
     ├─→ League Configuration Screen (Modal)
     │   │
     │   ├─→ Set Basic Info
     │   ├─→ Configure Scoring
     │   ├─→ Set Schedule
     │   ├─→ Define Rules
     │   │
     │   └─→ Save → Generate League Code
     │
     ├─→ Invite Players (Modal)
     │   │
     │   ├─→ Enter Emails
     │   ├─→ Send Invitations
     │   │
     │   └─→ Success
     │
     └─→ Back to Admin Dashboard
```

### 4. Player Accepting Invitation Flow
```
Email Invitation
     │
     ├─→ Click Link
     │
     ├─→ Invitation Acceptance Screen
     │   │
     │   ├─→ View League Details
     │   ├─→ Sign in with Google
     │   │
     │   └─→ Accept → Join League
     │
     └─→ Player Dashboard (new league appears)
```

---

## Error States

### Network Error
```
┌─────────────────────────────────────┐
│                                     │
│           ⚠️                        │
│                                     │
│     Unable to load data             │
│     Check your connection           │
│                                     │
│     [Try Again]                     │
│                                     │
└─────────────────────────────────────┘
```

### Deadline Passed
```
┌─────────────────────────────────────┐
│                                     │
│           🔒                        │
│                                     │
│     Deadline has passed             │
│     You cannot change your pick     │
│                                     │
│     [View Leaderboard]              │
│                                     │
└─────────────────────────────────────┘
```

### Unauthorized
```
┌─────────────────────────────────────┐
│                                     │
│           🚫                        │
│                                     │
│     You don't have access           │
│     Contact your league admin       │
│                                     │
│     [Back to Dashboard]             │
│                                     │
└─────────────────────────────────────┘
```

---

## Loading States

### Page Loading (Skeleton)
```
┌─────────────────────────────────────┐
│  ████████████                       │
│                                     │
│  ┌──────────────────────────────┐  │
│  │ ████████████████             │  │
│  │ ██████████                   │  │
│  │                              │  │
│  │ ████████████████             │  │
│  │ ██████████                   │  │
│  └──────────────────────────────┘  │
│                                     │
│  ┌──────────────────────────────┐  │
│  │ ████████████████             │  │
│  │ ██████████                   │  │
│  └──────────────────────────────┘  │
└─────────────────────────────────────┘
```

### Button Loading
```
┌─────────────────────┐
│  ⟳  Submitting...   │
└─────────────────────┘
```

---

## Success States

### Pick Submitted
```
┌─────────────────────────────────────┐
│                                     │
│           ✅                        │
│                                     │
│     Pick submitted!                 │
│     Good luck this week!            │
│                                     │
│     Redirecting...                  │
│                                     │
└─────────────────────────────────────┘
```

### League Created
```
┌─────────────────────────────────────┐
│                                     │
│           🎉                        │
│                                     │
│     League created!                 │
│                                     │
│     League Code: ABC123XYZ          │
│     [Copy Code] [Invite Players]    │
│                                     │
└─────────────────────────────────────┘
```

---

## Accessibility Considerations

### Keyboard Navigation
- All interactive elements accessible via Tab
- Enter/Space to activate buttons
- Arrow keys for navigation menus
- Esc to close modals

### Screen Reader Support
- Semantic HTML (header, nav, main, footer)
- ARIA labels for icons
- Role attributes for custom components
- Live regions for dynamic content

### Color Contrast
- WCAG AA compliance (4.5:1 for text)
- Not relying on color alone for information
- Focus indicators visible

### Touch Targets
- Minimum 44x44px for mobile buttons
- Adequate spacing between clickable elements
- Swipe gestures optional, not required

---

## Performance Optimizations

### Image Loading
- Lazy load team logos
- Use SVG for icons
- Compress and optimize images

### Code Splitting
- Route-based code splitting
- Lazy load modals and heavy components
- Separate vendor bundles

### API Optimization
- Cache frequently accessed data
- Pagination for large lists
- Real-time updates via WebSocket (optional)
- Optimistic UI updates

### Mobile Performance
- Minimize bundle size
- Service worker for offline support
- Progressive Web App capabilities
- Reduce unnecessary re-renders

