# Review: Engineer 1 - Feature Architect
Date: 2025-10-01
Reviewer: Product Manager

## Summary
**CRITICAL ISSUE IDENTIFIED**: Feature files contain TWO CONFLICTING GAME MODELS. 9 feature files correctly describe the intended ONE-TIME DRAFT model with individual NFL player roster building, while 5 feature files incorrectly describe a weekly team elimination pool model. This fundamental conflict must be resolved before development can proceed.

## Requirements Compliance

### ❌ CRITICAL FAILURE: Conflicting Game Models

The feature files describe **TWO DIFFERENT GAMES**:

**MODEL 1 (CORRECT - 9 files)**: ONE-TIME DRAFT with Individual NFL Player Rosters
- Players select INDIVIDUAL NFL PLAYERS by position (QB, RB, WR, TE, FLEX, K, DEF)
- Rosters built ONCE before first game
- Rosters PERMANENTLY LOCKED when first game starts
- NO changes for entire season
- Multiple players can select same NFL player (no ownership)
- Scoring based on individual player PPR performance

**MODEL 2 (INCORRECT - 5 files)**: WEEKLY TEAM ELIMINATION POOL
- Players select NFL TEAMS (Kansas City Chiefs, Buffalo Bills, etc.) each week
- New team selection required EACH WEEK
- Weekly pick deadlines and weekly locks
- Teams can be "eliminated" (survivor pool mechanic)
- Cannot reuse same team across your own weeks
- Team-level scoring, not individual player PPR scoring

### Requirements Mapping

Based on requirements.md lines 112-148 (Roster Building and Player Selection):
- ✅ Requirement: "League players build rosters by selecting individual NFL players" - VIOLATED by 5 files
- ✅ Requirement: "This is traditional fantasy football roster management" - VIOLATED by 5 files
- ✅ Requirement: "ONE-TIME DRAFT MODEL - rosters built ONCE before season" - VIOLATED by 5 files
- ✅ Requirement: "Roster Lock: Rosters PERMANENTLY LOCKED once first game starts" - VIOLATED by 5 files
- ✅ Requirement: "After roster lock, NO changes allowed for entire season" - VIOLATED by 5 files
- ✅ Requirement: "No waiver wire, no trades, no weekly lineup changes" - VIOLATED by 5 files

## Findings

### ✅ What's Correct (9 files)

**1. roster-management.feature** ✅
- Lines 1-10: Explicitly states "ONE-TIME DRAFT MODEL" with critical rules
- Lines 25-42: Correct roster building with individual NFL players (Mahomes, McCaffrey, Barkley, Hill, Lamb, Kelce, Diggs, Tucker, 49ers Defense)
- Lines 60-68: Correctly implements NO ownership - multiple players can select same NFL player
- Lines 94-110: Correctly prevents roster changes after first game starts with "ROSTER_PERMANENTLY_LOCKED"
- Lines 267-288: Injured players must remain on locked roster - no replacements
- Lines 289-303: Correctly states NO waiver wire and NO trade systems

**2. roster-building.feature** ✅
- Lines 1-4: "Select individual NFL players by position to build my roster"
- Lines 20-112: Proper roster building scenarios with NFL players by position
- Lines 124-129: Prevents selecting same NFL player twice in own roster
- Lines 130-138: Multiple league players can select same NFL player - "unlimited availability"

**3. roster-lock.feature** ✅
- Lines 1-4: Feature title explicitly states "One-Time Draft Model"
- Lines 14-29: Roster permanently locks, prevents ALL changes
- Lines 64-77: NO waiver wire, NO trades - "one-time draft model"
- Lines 104-110: Same 9 NFL players score points each week across all 4 weeks

**4. player-roster-selection.feature** ✅
- Lines 1-11: "ONE-TIME DRAFT MODEL" in title
- Lines 6-10: CRITICAL RULE clearly explains the model
- Lines 183-192: "no ownership model" correctly implemented
- Lines 326-408: PERMANENT lock enforcement with "ROSTER_PERMANENTLY_LOCKED"

**5. ppr-scoring.feature** ✅
- Lines 1-4: "Roster scored based on individual NFL player performance using PPR rules"
- Lines 21-90: All scenarios score individual NFL players (Mahomes, McCaffrey, Hill, Kelce)
- Lines 93-106: Weekly roster total calculated from all 9 players' individual performances

**6. defensive-scoring.feature** ✅
- Correctly scores NFL team defenses as roster positions
- Integrates with roster-based gameplay model

**7. field-goal-scoring.feature** ✅
- Correctly scores kickers as roster positions
- Integrates with roster-based gameplay model

**8. league-configuration.feature** ✅
- Lines 396-470: Roster configuration with position slots (QB, RB, WR, TE, FLEX, K, DEF, Superflex)
- Correctly describes roster structure, not weekly team selection

**9. league-configuration-lock.feature** ✅
- Enforces configuration lock based on first game start
- Prevents changes to roster configuration after lock
- Integrates with one-time draft model

### ❌ What Needs Fixing (5 files - CRITICAL)

**1. player-selection.feature** ❌ INCORRECT MODEL
- **Issue**: Describes WEEKLY PLAYER SELECTIONS, not one-time roster building
- **Location**: Lines 11-19: "I select NFL player Patrick Mahomes **for week 1**"
- **Location**: Lines 21-31: "I selected Travis Kelce **for week 1**... cannot select for **week 2**"
- **Location**: Lines 98-109: "League player makes selections **for all 4 weeks**" with different players per week
- **Location**: Lines 180-196: Scenario outline shows selecting different players across weeks 1, 2, 3, 4
- **Fix Required**: REWRITE to align with roster-building.feature - players select all positions ONCE before season

**2. game-management.feature** ❌ INCORRECT TERMINOLOGY & MODEL
- **Issue**: Uses "team selections" instead of "roster selections" throughout
- **Location**: Line 15: "players cannot make team selections" (should be "roster selections")
- **Location**: Line 28: "players can now make team selections" (should be "build rosters")
- **Location**: Lines 83-84: "week 1 selections are locked" and "week 2 selections are now open" - implies weekly changes
- **Location**: Line 139: References "Elimination history" which doesn't exist in ONE-TIME DRAFT
- **Fix Required**: REWRITE to use correct terminology and remove weekly selection logic

**3. week-management.feature** ❌ INCORRECT MODEL
- **Issue**: Describes weekly team selections with weekly deadlines
- **Location**: Lines 169-175: "Lock week after deadline passes" - implies weekly locking, not season-long roster lock
- **Location**: Lines 178-189: "Players select **teams** for specific NFL weeks"
- **Location**: Line 179: "player selects Kansas City Chiefs **for game week 1**" - this is TEAM selection
- **Location**: Lines 184-189: "Team selections are validated" - confirms team-based weekly model
- **Location**: Lines 193-199: "selected Buffalo Bills **for game week 1**"
- **Fix Required**: REWRITE to focus on scoring calculation weeks, not selection weeks. Weeks are for calculating scores, not making selections.

**4. leaderboard.feature** ❌ INCORRECT MODEL
- **Issue**: Shows team elimination pool leaderboard, not fantasy roster leaderboard
- **Location**: Lines 16-22: Players have "team selected" per week (Chiefs, Bills, etc.)
- **Location**: Lines 112-127: Shows "team elimination status" and "eliminated teams count"
- **Location**: Lines 118-126: Elimination model: "Chiefs WIN", "Cowboys LOSS eliminated", "Dolphins LOSS eliminated"
- **Location**: Line 139: "Elimination history" in archived data
- **Fix Required**: REWRITE to show fantasy roster leaderboard with cumulative PPR scoring

**5. data-integration.feature** ❌ INCORRECT MODEL
- **Issue**: Describes team-based weekly selections for bye week handling
- **Location**: Lines 37-43: "Team A has a bye week" and "players who selected Team A are notified"
- **Fix Required**: REWRITE to handle individual NFL player bye weeks and roster implications

### Missing Coverage

The following scenarios from requirements.md are not covered in feature files:

1. **Superflex Position Handling** (requirements.md lines 124)
   - Only basic FLEX coverage exists
   - Need detailed Superflex scenarios (can select QB, RB, WR, or TE)

2. **Custom Roster Configurations** (requirements.md lines 226-238)
   - Need scenarios for non-standard configurations (2 QB, 3 RB, 0 K, etc.)
   - Edge cases like 0 positions for certain slots

3. **Personal Access Token (PAT) Scenarios** (requirements.md lines 79-99, 389-407)
   - PAT creation, validation, and usage scenarios missing
   - Bootstrap PAT setup scenarios missing

4. **Admin Invitation Flow** (requirements.md lines 71-78)
   - Super admin to admin invitation scenarios missing
   - Covered player invitation but not admin invitation

## Recommendation

🚫 **CHANGES REQUIRED** - Must fix before approval

### Immediate Actions Required

1. **DELETE or COMPLETELY REWRITE** these 5 files to match ONE-TIME DRAFT model:
   - `player-selection.feature` → Rewrite as roster position filling scenarios
   - `game-management.feature` → Fix terminology from "team selections" to "rosters"
   - `week-management.feature` → Remove weekly selection logic, focus on scoring weeks
   - `leaderboard.feature` → Remove elimination logic, show fantasy roster standings
   - `data-integration.feature` → Handle individual player data, not team data

2. **ADD MISSING COVERAGE**:
   - Create `admin-invitation.feature` (super admin → admin flow)
   - Create `pat-management.feature` (PAT creation, validation, usage)
   - Create `bootstrap-setup.feature` (initial system setup with bootstrap PAT)
   - Enhance `roster-building.feature` with Superflex and custom configuration scenarios

3. **CLARIFY GAME MODEL** in all features:
   - Every feature should be consistent with ONE-TIME DRAFT model
   - Remove all references to weekly selections, weekly picks, weekly deadlines for selections
   - Weeks are for SCORING calculations only, not for making new selections
   - Roster lock deadline is BEFORE SEASON, not weekly

### Root Cause Analysis

The conflict likely arose from:
1. Misunderstanding of requirements (confused with survivor/elimination pool model)
2. Two different engineers working on feature files without coordination
3. Lack of clear game model documentation at project start

## Next Steps

1. **Engineer 1**: Review this report and create implementation plan for fixes
2. **Engineer 1**: Prioritize rewriting the 5 incorrect feature files
3. **Engineer 1**: Add missing coverage for PAT, admin invitation, bootstrap scenarios
4. **Product Manager**: Schedule alignment meeting to clarify ONE-TIME DRAFT model with all engineers
5. **All Engineers**: Review requirements.md lines 112-148 carefully before any further work

## Evidence Summary

| File | Status | Evidence |
|------|--------|----------|
| roster-management.feature | ✅ CORRECT | Lines 1-10: "ONE-TIME DRAFT MODEL", Lines 60-68: no ownership |
| roster-building.feature | ✅ CORRECT | Lines 130-138: unlimited availability of NFL players |
| roster-lock.feature | ✅ CORRECT | Lines 1-4: "One-Time Draft Model" in title |
| player-roster-selection.feature | ✅ CORRECT | Lines 1-11: explicit ONE-TIME DRAFT description |
| ppr-scoring.feature | ✅ CORRECT | All scenarios use individual player scoring |
| defensive-scoring.feature | ✅ CORRECT | Scores team defenses as roster positions |
| field-goal-scoring.feature | ✅ CORRECT | Scores kickers as roster positions |
| league-configuration.feature | ✅ CORRECT | Roster configuration scenarios |
| league-configuration-lock.feature | ✅ CORRECT | Configuration immutability enforcement |
| player-selection.feature | ❌ INCORRECT | Lines 11-19: weekly player selections |
| game-management.feature | ❌ INCORRECT | Lines 15, 28: "team selections" terminology |
| week-management.feature | ❌ INCORRECT | Lines 178-189: weekly team selections |
| leaderboard.feature | ❌ INCORRECT | Lines 112-127: elimination tracking |
| data-integration.feature | ❌ INCORRECT | Lines 37-43: team bye week handling |

## Approval Status

**STATUS**: 🚫 **CHANGES REQUIRED**

**Blocking Issues**:
1. 5 feature files describe wrong game model (weekly team elimination pool vs. one-time draft roster)
2. Fundamental conflict must be resolved before any implementation begins
3. Missing coverage for PAT, admin invitation, bootstrap scenarios

**Cannot proceed with implementation until these issues are resolved.**
