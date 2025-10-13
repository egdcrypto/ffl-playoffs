# FFL Playoffs Mockup States

## Overview

This directory contains mockups demonstrating the **ONE-TIME DRAFT MODEL** with **PRE-LOCK** and **POST-LOCK** states.

## Roster Lock Model

- **Rosters are built ONCE** before the season starts
- **Rosters are PERMANENTLY LOCKED** when the first game begins
- **NO changes allowed** after lock: no waiver wire, no trades, no weekly lineup changes
- Players must compete with their locked roster for the entire season

## Mockup States

### 🔓 PRE-LOCK State (Before First Game)
**Files**: `*-prelock.html`

**Features**:
- Active "Build Roster", "Add Players", "Edit" buttons
- Countdown timer to permanent lock
- Warning banners about upcoming lock
- Incomplete roster indicators
- Draft progress tracking
- Position slot highlighting

**When**: From league creation until first NFL game starts

### 🔒 POST-LOCK State (After First Game)
**Files**: `*-locked.html`

**Features**:
- "View Roster" buttons only (read-only)
- All edit buttons removed/disabled
- Permanent "LOCKED" badges throughout
- Lock timestamp displayed
- No modification UI
- Injury warnings (players remain on roster)
- "Roster Permanently Locked" banners

**When**: From first game start until season ends

## Available Mockup Pairs

| Mockup Type | PRE-LOCK Version | POST-LOCK Version |
|-------------|------------------|-------------------|
| **Dashboard** | `player-dashboard-prelock.html` | `player-dashboard-locked.html` |
| **My Roster** | `my-roster-prelock.html` | `my-roster-locked.html` |
| **Player Selection** | `player-selection-prelock.html` | `player-selection-locked.html` |
| **League Standings** | `league-standings-prelock.html` | `league-standings-locked.html` |

## Mixed-State Mockups

- `player-dashboard.html` - Shows multiple leagues in different states
- `my-roster.html` - Original mockup (being replaced by state-specific versions)
- `player-selection.html` - Original mockup (being replaced by state-specific versions)
- `league-standings.html` - Current roster-based league standings

## Viewing Mockups

Open `index.html` to see all mockups organized by state with detailed descriptions.

---

**Last Updated**: October 2025
