# FFL Playoffs Mockup States Guide

## Overview

This document outlines the **Pre-Lock** and **Post-Lock** mockup states for the FFL Playoffs ONE-TIME DRAFT model.

---

## ONE-TIME DRAFT Model

**Critical Business Rule**: Rosters are built ONCE before the season starts and are PERMANENTLY LOCKED when the first NFL game begins. No changes allowed for the entire season.

---

## Mockup State Categories

### 1. Pre-Lock State (Draft Phase)

**When**: From league creation until the first NFL game of the season starts

**File Naming Convention**: `{page-name}-prelock.html`

**Visual Indicators**:
- 🟢 Green badges: "PRE-LOCK", "Draft Active", "Editable"
- 🔓 Unlock icons
- Green left border (4px solid #198754)

**User Actions Available**:
- Browse and search for NFL players
- Draft players to fill all roster positions
- View incomplete roster with "Add Player" options
- Edit roster selections (drop/add players)
- See countdown timer to permanent roster lock

**Required Mockups**:
1. **player-selection-prelock.html**
   - Active "Add to Roster" buttons
   - Countdown timer to lock
   - Draft warnings banner
   - Available positions highlighted
   - Search/filter fully functional

2. **my-roster-prelock.html**
   - Incomplete roster view
   - "Add Player" buttons for empty slots
   - "Drop Player" buttons for filled slots
   - Countdown timer to lock
   - Position slots with visual indicators for completion status
   - Draft progress bar

3. **league-standings-prelock.html**
   - Shows roster completion status per player
   - "View Draft Progress" buttons for incomplete rosters
   - Countdown to lock timer
   - Draft completion badges (e.g., "8/10 Complete")

---

### 2. Post-Lock State (Season Active - Read-Only)

**When**: From the moment the first NFL game starts until season ends

**File Naming Convention**: `{page-name}-locked.html`

**Visual Indicators**:
- 🔴 Red badges: "POST-LOCK", "Roster Locked", "Read-Only"
- 🔒 Lock icons
- Red left border (4px solid #dc3545)

**User Actions Available**:
- View roster (read-only) - NO modifications
- View player stats and weekly scores
- View league standings and rankings
- See "Roster Locked" badges and warnings

**Actions NOT Available**:
- ❌ Add players
- ❌ Drop players
- ❌ Trade players
- ❌ Use waiver wire
- ❌ Make ANY roster modifications

**Required Mockups**:
1. **player-selection-locked.html**
   - Browse-only view
   - ALL "Add to Roster" buttons removed or disabled
   - Prominent "Roster Locked" warning banner
   - Lock timestamp displayed
   - Tooltip on hover: "Roster permanently locked - no changes allowed"

2. **my-roster-locked.html**
   - Complete roster view (read-only)
   - NO edit buttons (Add/Drop removed)
   - Lock notice at top with timestamp
   - Weekly scoring displayed
   - Injured players remain on roster (cannot replace)
   - Disabled state styling for position slots

3. **league-standings-locked.html**
   - Rankings with "Roster Locked" badges
   - "View Roster" (read-only) buttons only
   - Shows weekly scores and total points
   - No "Edit" or "Modify" options
   - Lock badges for all rosters

---

### 3. General Mockups (State-Independent)

**No State Suffix**: `{page-name}.html`

**Mockups**:
- **login.html** - Authentication (no state)
- **player-dashboard.html** - Shows mixed states (incomplete, locked, active leagues)

---

## Implementation Checklist for Engineer 4

### Pre-Lock Mockups

- [ ] **player-selection-prelock.html**
  - [ ] Add "Add to Roster" buttons (active state)
  - [ ] Add countdown timer component
  - [ ] Add draft warning banner
  - [ ] Highlight available positions
  - [ ] Add draft phase badges

- [ ] **my-roster-prelock.html**
  - [ ] Show incomplete roster (6/9 players example)
  - [ ] Add "Add Player" buttons for empty slots
  - [ ] Add "Drop Player" buttons with confirmation modals
  - [ ] Add countdown timer
  - [ ] Add draft progress bar
  - [ ] Highlight empty position slots

- [ ] **league-standings-prelock.html**
  - [ ] Show roster completion status (e.g., "8/10 Complete")
  - [ ] Add "View Draft Progress" buttons
  - [ ] Add countdown timer
  - [ ] Show draft completion badges

### Post-Lock Mockups

- [ ] **player-selection-locked.html**
  - [ ] Remove all "Add to Roster" buttons
  - [ ] Add "Roster Locked" warning banner at top
  - [ ] Display lock timestamp (e.g., "Locked on Jan 12, 2025 at 1:00 PM ET")
  - [ ] Add disabled state styling to player rows
  - [ ] Add tooltips: "Roster permanently locked"

- [ ] **my-roster-locked.html**
  - [ ] Remove ALL edit buttons (Add/Drop)
  - [ ] Add lock notice banner with timestamp
  - [ ] Show complete roster with all 10 positions filled
  - [ ] Add weekly scoring columns
  - [ ] Add injured player indicators (cannot replace)
  - [ ] Add lock icon badges on position slots

- [ ] **league-standings-locked.html**
  - [ ] Add "Roster Locked" badges to all players
  - [ ] Replace "Edit Roster" with "View Roster" (read-only)
  - [ ] Show weekly scores and live scoring indicators
  - [ ] Add lock timestamp in header

---

## Visual Design Consistency

### Color Scheme

**Pre-Lock State**:
- Primary Color: `#198754` (Bootstrap Success Green)
- Badge Background: `bg-success`
- Icon: `bi-unlock-fill`
- Border: `4px solid #198754`

**Post-Lock State**:
- Primary Color: `#dc3545` (Bootstrap Danger Red)
- Badge Background: `bg-danger`
- Icon: `bi-lock-fill`
- Border: `4px solid #dc3545`

### Typography

**Lock Notices**:
```html
<div class="alert alert-danger border-danger">
    <h5 class="alert-heading">
        <i class="bi bi-lock-fill"></i> Roster Permanently Locked
    </h5>
    <p class="mb-0">
        Your roster was locked on <strong>January 12, 2025 at 1:00 PM ET</strong>
        when the first game started. No changes can be made for the remainder of the season.
    </p>
</div>
```

**Countdown Timer** (Pre-Lock):
```html
<div class="alert alert-warning">
    <i class="bi bi-clock-fill"></i>
    <strong>Time until roster lock: 2 hours 15 minutes</strong> - Complete your roster now!
</div>
```

---

## Testing Scenarios

### Pre-Lock State Testing
1. Verify all "Add to Roster" buttons are clickable
2. Verify countdown timer displays correctly
3. Verify draft warnings are prominent
4. Verify empty position slots are highlighted
5. Verify "Drop Player" modals work correctly

### Post-Lock State Testing
1. Verify NO edit buttons exist
2. Verify all "Add to Roster" buttons removed
3. Verify lock timestamp displays correctly
4. Verify "Roster Locked" badges appear
5. Verify tooltips show lock messages
6. Verify all links go to read-only views

---

## Bootstrap Components Used

- **Badges**: `badge bg-success`, `badge bg-danger`, `badge bg-secondary`
- **Alerts**: `alert alert-warning`, `alert alert-danger`, `alert alert-success`
- **Icons**: Bootstrap Icons (`bi-lock-fill`, `bi-unlock-fill`, `bi-clock-fill`)
- **Cards**: `card`, `card-body`, `card-header`, `card-footer`
- **Buttons**: `btn btn-primary`, `btn btn-outline-secondary disabled`
- **Progress Bars**: `progress`, `progress-bar`

---

## Collaboration Notes

**For Engineer 4**:

Current mockup files already created (by previous work):
- ✅ `player-selection.html` - Can be used as base for `-prelock` version
- ✅ `my-roster.html` - Already shows locked state, use as base for `-locked` version
- ✅ `league-standings.html` - Already has lock warnings, use as base

**Recommended Approach**:
1. Copy existing mockups as starting point
2. Add/remove UI elements based on state (buttons, warnings, timers)
3. Update badges and visual indicators
4. Test both states side-by-side for consistency

**Questions/Clarifications**: Reach out if any state behavior is unclear.

---

## References

- **requirements.md** - ONE-TIME DRAFT business rules
- **features/roster-management.feature** - Roster lock scenarios
- **docs/API.md** - API endpoints for roster lock status
- **index.html** - Visual organization of mockup states

---

**Last Updated**: 2025-10-01
**Maintained By**: Engineering Team (Collaboration between Engineer 3 & Engineer 4)
