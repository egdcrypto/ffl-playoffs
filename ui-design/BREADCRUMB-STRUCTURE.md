# Breadcrumb Navigation Structure

## Overview
This document defines the standardized breadcrumb navigation structure for all FFL Playoffs mockup pages.

## Breadcrumb Hierarchy

### Player-Facing Pages (5 levels)
For pages within a specific league context:

```
Home > Dashboard > My Leagues > [League Name] > [Current Page]
```

**Example:**
```
Home > Dashboard > My Leagues > 2025 NFL Playoffs Pool > My Roster
```

**Applies to:**
- player-selection-prelock.html
- player-selection-locked.html
- player-selection.html
- my-roster-prelock.html
- my-roster-locked.html
- my-roster.html
- players-prelock.html
- players-locked.html
- league-standings-prelock.html
- league-standings-locked.html
- league-standings.html

### Dashboard Pages (2 levels)
For main dashboard pages without league context:

```
Home > Dashboard
```

**Applies to:**
- player-dashboard.html
- player-dashboard-prelock.html
- player-dashboard-locked.html

### Admin Pages (2-3 levels)
For administrative pages:

```
Home > Admin Dashboard > [Optional: Section/Page]
```

**Examples:**
- `Home > Admin Dashboard` (admin-dashboard.html)
- `Home > Admin Dashboard > League Configuration` (league-config.html)

### Super Admin Pages (2 levels)
```
Home > Super Admin Dashboard
```

**Applies to:**
- super-admin-dashboard.html

### Landing Pages (0 breadcrumbs)
No breadcrumbs needed:
- index.html (main landing page)
- login.html (authentication page)

## Standardization Rules

### 1. Consistent League Naming
- **Standard Name:** `2025 NFL Playoffs Pool`
- All league breadcrumbs must use this exact name
- League name appears in both breadcrumb AND page title/dropdown

### 2. Breadcrumb Order (5-level structure)
1. **Home** - Link to index.html
2. **Dashboard** - Link to appropriate dashboard (player-dashboard.html, player-dashboard-prelock.html, or player-dashboard-locked.html)
3. **My Leagues** - Link to `#` (section indicator, not a separate page)
4. **League Name** - Link to `#` (e.g., "2025 NFL Playoffs Pool")
5. **Current Page** - Active (no link), shows current location (e.g., "My Roster", "Build Roster", "Standings")

### 3. State-Aware Navigation
Breadcrumb links must respect the current state:
- **Pre-lock state:** Link to `player-dashboard-prelock.html`
- **Post-lock state:** Link to `player-dashboard-locked.html`
- **Mixed/neutral state:** Link to `player-dashboard.html`

## HTML Implementation

### Standard 5-Level Player Page Breadcrumb
```html
<nav aria-label="breadcrumb" class="mb-3">
    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="index.html">Home</a></li>
        <li class="breadcrumb-item"><a href="player-dashboard-prelock.html">Dashboard</a></li>
        <li class="breadcrumb-item"><a href="#">My Leagues</a></li>
        <li class="breadcrumb-item"><a href="#">2025 NFL Playoffs Pool</a></li>
        <li class="breadcrumb-item active">My Roster</li>
    </ol>
</nav>
```

### Dashboard Breadcrumb
```html
<nav aria-label="breadcrumb">
    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="index.html">Home</a></li>
        <li class="breadcrumb-item active">Dashboard</li>
    </ol>
</nav>
```

### Admin Breadcrumb
```html
<nav aria-label="breadcrumb">
    <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href="index.html">Home</a></li>
        <li class="breadcrumb-item"><a href="admin-dashboard.html">Admin Dashboard</a></li>
        <li class="breadcrumb-item active">League Configuration</li>
    </ol>
</nav>
```

## Verification Checklist

When adding or updating breadcrumbs:

- [ ] Correct number of levels for page type
- [ ] League name is "2025 NFL Playoffs Pool" (if applicable)
- [ ] "My Leagues" level is present between Dashboard and League Name (for 5-level pages)
- [ ] Links point to correct state-aware pages (prelock/locked/neutral)
- [ ] Active page has `active` class and no link
- [ ] Consistent ordering across all pages
- [ ] Mobile-responsive styling (Bootstrap breadcrumb component)

## Common Issues Fixed

### Issue 1: Missing "My Leagues" Level
**Before (4 levels):**
```
Home > Dashboard > 2025 NFL Playoffs Pool > My Roster
```

**After (5 levels):**
```
Home > Dashboard > My Leagues > 2025 NFL Playoffs Pool > My Roster
```

### Issue 2: Inconsistent League Names
**Before:**
- Some pages: "2025 NFL Playoffs Pool"
- Other pages: "Playoff Challenge 2024"

**After:**
- All pages: "2025 NFL Playoffs Pool"

### Issue 3: Breadcrumb Order Variations
**Solution:** Strict enforcement of the 5-level structure for all league pages
