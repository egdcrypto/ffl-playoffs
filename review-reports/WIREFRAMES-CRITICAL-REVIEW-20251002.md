# CRITICAL WIREFRAMES REVIEW - FFL Playoffs

**Date:** 2025-10-02
**Reviewer:** Feature Architect (engineer1)
**File Reviewed:** ui-design/WIREFRAMES.md
**Status:** ❌ CRITICAL ISSUES FOUND - REQUIRES IMMEDIATE REVISION

---

## Executive Summary

The current wireframes in `ui-design/WIREFRAMES.md` describe a **SURVIVOR POOL game** where players pick one NFL TEAM per week. However, `requirements.md` clearly specifies a **TRADITIONAL FANTASY FOOTBALL game** where players build rosters by selecting INDIVIDUAL NFL PLAYERS across multiple positions (QB, RB, WR, TE, FLEX, K, DEF, Superflex).

**This is a FUNDAMENTAL mismatch that affects the entire UI/UX design.**

---

## Critical Discrepancies

### 1. Screen 3: "Team Selection Screen" ❌

**Current Wireframe:**
- Title: "Team Selection Screen"
- Shows: Picking one NFL team per week (Bills, Patriots, Dolphins, Jets, etc.)
- Text: "Select Your Team (You've used 5 of 32 teams)"
- Model: Weekly team picks, cannot reuse teams
- Shows: AFC divisions, team records (6-0, 3-3, etc.)

**Should Be: "Build Roster Screen"**
- Title: "Build Roster Screen"
- Shows: Selecting INDIVIDUAL NFL PLAYERS for each position slot
- Text: "Build Your Roster (7 of 9 positions filled)"
- Model: ONE-TIME DRAFT - Build roster ONCE before season, permanently locked after first game
- Shows: NFL player names (Patrick Mahomes, Christian McCaffrey, etc.), position slots, player stats

**Requirements Reference:**
> "League players build rosters by selecting individual NFL players (e.g., 'Patrick Mahomes', 'Christian McCaffrey')"
> "This is traditional fantasy football roster management with position-based selection"
> "CRITICAL: This is a ONE-TIME DRAFT model - rosters are built ONCE before the season"

---

### 2. Navigation Terminology ❌

**Current Wireframe:**
- Uses: "Make Picks" (implies weekly selections)
- Player Dashboard shows: "[Make Picks]" buttons

**Should Be:**
- Use: "Build Roster" (one-time roster construction)
- Player Dashboard shows: "[Build Roster]" or "[Edit Roster]" (only before lock)

**Requirements Reference:**
> "Roster Lock: Rosters are PERMANENTLY LOCKED once the first game starts"
> "After roster lock, NO changes are allowed for the entire season"
> "No waiver wire, no trades, no weekly lineup changes"

---

### 3. Elimination Rules ❌

**Current Wireframe:**
- Shows: "Elimination Condition: Loss eliminates player (survivor style)"
- Model: If your team loses, you're eliminated

**Should Be:**
- Shows: No elimination based on team losses
- Model: Standard fantasy scoring - cumulative points over all weeks
- Players compete for highest total points, not survival

**Requirements Reference:**
> "Standard PPR (Points Per Reception) scoring"
> "League player's total score = sum of all their selected NFL players' scores"
> "Cumulative season scoring across all configured weeks"

---

### 4. Scoring System ❌

**Current Wireframe:**
- Focus: Team total score
- Shows: Defensive scoring based on points allowed
- Model: One team's performance per week

**Should Be:**
- Focus: Individual NFL player statistics
- Shows: PPR scoring (passing yards, rushing yards, receiving yards, receptions, TDs, etc.)
- Model: Sum of all rostered players' fantasy points

**Requirements Reference:**
> "Scoring is based on INDIVIDUAL NFL PLAYER performance"
> "Standard PPR scoring rules: Passing (1pt/25yds), Rushing (1pt/10yds), Receiving (1pt/10yds), Receptions (1pt), TDs (4/6pts)"
> "Example: Patrick Mahomes throws 300 yards (12 pts) + 3 TDs (12 pts) + 1 INT (-2 pts) = 22 fantasy points"

---

### 5. Roster Configuration ❌

**Current Wireframe:**
- Shows: Only team selection interface
- No mention of: Position slots (QB, RB, WR, TE, FLEX, K, DEF, Superflex)

**Should Be:**
- Shows: Position-based roster building interface
- Display: All position slots with requirements
  - QB: 1 slot
  - RB: 2 slots
  - WR: 2 slots
  - TE: 1 slot
  - FLEX: 1 slot (RB/WR/TE eligible)
  - K: 1 slot
  - DEF: 1 slot
  - Superflex: 1 slot (QB/RB/WR/TE eligible)

**Requirements Reference:**
> "Roster structure configured by admin (e.g., 1 QB, 2 RB, 2 WR, 1 TE, 1 FLEX, 1 K, 1 DEF, 1 Superflex)"
> "Each roster slot has position requirements"
> "FLEX: Can select RB, WR, or TE"
> "Superflex: Can select QB, RB, WR, or TE"

---

### 6. Week Management ❌

**Current Wireframe:**
- Shows: Weekly deadline countdown
- Text: "Make Your Pick - Week 6"
- Model: New pick required each week

**Should Be:**
- Shows: ONE-TIME roster deadline countdown
- Text: "Build Your Roster - Deadline: [Date]"
- Model: Build roster ONCE before first game, no weekly changes

**Requirements Reference:**
> "Build roster by filling all required position slots"
> "Edit roster selections ONLY before roster lock deadline"
> "Roster Lock: Rosters are PERMANENTLY LOCKED once the first game starts"

---

### 7. Player Dashboard ❌

**Current Wireframe:**
- Shows: "⚠ Picks due in 2 days" (implies weekly action)
- Shows: "✓ Picks submitted" (implies weekly completion)

**Should Be:**
- Shows: "⚠ Roster incomplete - 2 positions open" (one-time action)
- Shows: "✓ Roster complete" or "🔒 Roster locked" (permanent status)

---

### 8. Leaderboard Display ❌

**Current Wireframe:**
- Shows: Player name + "Team: Chiefs" (single team pick)
- Shows: "This Week" points only

**Should Be:**
- Shows: Player name + Roster preview (multiple NFL players)
- Shows: Weekly breakdown BY PLAYER POSITION
  - QB: Patrick Mahomes - 24 pts
  - RB1: Christian McCaffrey - 18 pts
  - RB2: Austin Ekeler - 12 pts
  - etc.

**Requirements Reference:**
> "Points breakdown by player position"
> "View game-by-game scoring breakdown for each selected player"
> "League player's weekly total = sum of all roster player scores for that week"

---

### 9. League Configuration Screen ❌

**Current Wireframe:**
- Shows: "Each team can only be used once" (survivor pool rule)
- Shows: Basic scoring config but focused on team performance

**Should Be:**
- Shows: "Roster Configuration" section
  - Define number of each position (QB: 1, RB: 2, WR: 2, etc.)
  - Configure FLEX eligibility
  - Configure Superflex eligibility
- Shows: Detailed PPR scoring rules
  - Passing yards per point
  - Rushing yards per point
  - Receiving yards per point
  - Points per reception
  - TD points by type
  - Field goal scoring by distance
  - Defensive scoring with configurable tiers

**Requirements Reference:**
> "Admins define roster structure with flexible position counts"
> "Roster configuration: QB (0-4), RB (0-6), WR (0-6), TE (0-3), K (0-2), DEF (0-2), FLEX (0-3), Superflex (0-2)"
> "PPR settings configurable: Full PPR (1.0), Half PPR (0.5), or Standard (0.0)"

---

## Missing Screens

### 1. NFL Player Search & Filter Screen ❌

**Required Features:**
- Search NFL players by name
- Filter by position (QB, RB, WR, TE, K, DEF)
- Filter by NFL team (32 teams)
- View player stats (game-by-game performance)
- View player season totals and averages
- Sort by various stats (points, yards, touchdowns)
- Pagination support for large player lists

**Requirements Reference:**
> "Search NFL players by name"
> "Filter by position and NFL team"
> "View player stats, season totals, and averages"

---

### 2. Roster Lock Warning Screen ❌

**Required Features:**
- Display countdown to roster lock
- Warning that changes cannot be made after lock
- List of unfilled positions (if any)
- Confirmation before submitting final roster

**Requirements Reference:**
> "Roster deadline is before the first game of the season starts (configurable)"
> "Roster validation ensures all positions are filled with eligible players before lock"
> "After roster lock, NO changes allowed for entire season"

---

### 3. Player Statistics Detail Screen ❌

**Required Features:**
- Individual NFL player profile
- Game-by-game statistics breakdown
- Season totals and averages
- Injury status
- BYE week information
- NFL team and position

---

## Correctly Designed Screens ✅

### 1. Login Screen ✅
- Google OAuth flow correctly designed
- Responsive layouts appropriate
- States handled properly

### 2. Admin Dashboard ✅
- League management interface correct
- Pending actions appropriate
- Recent activity feed good

### 3. Super Admin Dashboard ✅
- Platform overview correct
- Admin management appropriate
- PAT management correctly shown

### 4. Invitation Acceptance Screen ✅
- League details display correct
- Google OAuth integration appropriate

---

## Required Wireframe Revisions

### HIGH PRIORITY - Complete Redesign Required

1. **Screen 3: "Build Roster Screen" (Replace "Team Selection Screen")**
   - Change from team selection to individual NFL player selection
   - Show position slots (QB, RB, WR, TE, FLEX, K, DEF, Superflex)
   - Display roster completion status (7 of 9 positions filled)
   - Show selected players with their stats
   - Add search/filter interface for available NFL players
   - Include roster lock countdown
   - Remove "used teams" tracking
   - Add "Add Player" buttons for each unfilled position slot

2. **Player Dashboard Revisions**
   - Change "Make Picks" to "Build Roster" or "View Roster"
   - Change "⚠ Picks due" to "⚠ Roster incomplete"
   - Change "✓ Picks submitted" to "✓ Roster complete" or "🔒 Roster locked"
   - Remove weekly pick status
   - Add roster completion percentage

3. **Leaderboard Screen Revisions**
   - Change single team display to roster preview
   - Add expandable roster view showing all selected players
   - Show points breakdown by position
   - Display weekly scoring breakdown BY PLAYER
   - Remove "Team: Chiefs" single team display

4. **League Configuration Screen Revisions**
   - Add "Roster Configuration" tab/section
   - Show position slot configuration (QB: 1, RB: 2, etc.)
   - Add PPR scoring detailed configuration
   - Add field goal scoring by distance
   - Add defensive scoring with tier configuration
   - Remove "Each team can only be used once" rule
   - Remove "Loss eliminates player" option

### NEW SCREENS REQUIRED

5. **NFL Player Search & Selection Screen**
   - Browse/search interface for 2000+ NFL players
   - Position filter (QB, RB, WR, TE, K, DEF)
   - Team filter (32 NFL teams)
   - Stats display (points, yards, TDs)
   - Sort options
   - Pagination
   - "Add to Roster" button
   - Show which position slot player will fill

6. **Roster Lock Warning Screen**
   - Countdown to lock deadline
   - Warning message about permanent lock
   - List unfilled positions
   - "Finalize Roster" confirmation button
   - Option to go back and edit

7. **Player Statistics Detail Screen**
   - Individual player profile
   - Game-by-game stats table
   - Season averages
   - Injury/status indicators
   - BYE week display

---

## Impact Assessment

### Development Impact: CRITICAL ❌
- All frontend components affected
- API endpoints need to match roster model, not team selection
- Database schema must support individual player rosters
- Scoring engine must calculate individual player PPR points

### Timeline Impact: HIGH RISK ❌
- Complete UI/UX redesign required
- All wireframe-based development work must be paused
- Estimated 2-3 weeks additional design work

### Stakeholder Impact: CRITICAL ❌
- Current wireframes show wrong product
- Stakeholder expectations may be misaligned
- Immediate clarification meeting required

---

## Recommendations

### IMMEDIATE ACTIONS REQUIRED

1. **STOP all wireframe-based development** ✋
   - Do not proceed with current Team Selection implementation
   - Do not build APIs based on current wireframes

2. **Schedule emergency alignment meeting** 📅
   - Product Owner
   - UI/UX Designer
   - Feature Architect
   - Engineering leads
   - Confirm product direction: Survivor Pool vs. Traditional Fantasy Football

3. **Clarify requirements** 📋
   - If Traditional Fantasy Football (per requirements.md): Redesign all wireframes
   - If Survivor Pool (per wireframes): Rewrite requirements.md completely

4. **Update Gherkin feature files** ✅
   - GOOD NEWS: Feature files in `features/` directory correctly implement Traditional Fantasy Football model
   - Feature files align with requirements.md, not wireframes
   - Feature files do NOT need revision

5. **Assign UI/UX Designer to revisions** 👤
   - engineer4 (UI/UX Designer) must revise wireframes
   - Follow requirements.md specifications
   - Reference feature files for business logic

---

## Conclusion

The wireframes describe a **completely different product** than specified in requirements.md and implemented in feature files. This is a **critical blocker** that must be resolved before any frontend development proceeds.

**Recommended Path Forward:**
1. Confirm product direction with stakeholders
2. Assuming Traditional Fantasy Football is correct (per requirements.md):
   - Completely redesign Screen 3 as "Build Roster Screen"
   - Add 3 new screens for player search, roster lock, and player details
   - Revise Player Dashboard, Leaderboard, and League Configuration screens
   - Update all terminology from "picks" to "roster"
3. Validate revised wireframes against requirements.md and feature files
4. Only then proceed with frontend development

---

**Status:** 🚨 BLOCKED - Wireframes must be revised before development can proceed

**Next Steps:**
1. Route to PM for stakeholder alignment
2. Route to UI/UX Designer (engineer4) for complete redesign
3. Review cycle with Feature Architect before implementation begins

---

**Reviewed by:** Feature Architect (engineer1)
**Date:** 2025-10-02
**Severity:** CRITICAL
**Priority:** IMMEDIATE
