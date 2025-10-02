# UI DESIGN FILES - API INTEGRATION CRITICAL ISSUES

**Date:** 2025-10-02 12:32
**Reviewer:** Feature Architect (engineer1)
**Work Item:** WORK-20251002-123211-1933568
**Files Reviewed:**
- ui-design/API-INTEGRATION.md ❌
- ui-design/COMPONENTS.md ✅
- ui-design/WIREFRAMES.md ✅

---

## Executive Summary

**COMPONENTS.md**: ✅ CORRECT - All components properly reference roster building model
**WIREFRAMES.md**: ✅ CORRECT - All wireframes updated to traditional fantasy football
**API-INTEGRATION.md**: ❌ CRITICAL ISSUES - Still contains survivor pool API concepts

---

## CRITICAL ISSUES IN API-INTEGRATION.md

### Issue #1: Leaderboard API Returns "eliminatedTeams" ❌

**Location:** Lines 331-344

**Current API Response:**
```json
{
  "leaderboard": [
    {
      "rank": 1,
      "playerId": 15,
      "playerName": "Jane Player",
      "totalScore": 342.5,
      "weeklyScores": [87.5, 92.0, 85.0, 78.0],
      "eliminatedTeams": 0,  // ❌ WRONG
      "isMe": false
    }
  ]
}
```

**Why This Is Wrong:**
- Traditional fantasy football has NO elimination concept
- Players compete for highest cumulative PPR score
- "eliminatedTeams" makes no sense when drafting individual NFL players

**Should Be:**
```json
{
  "leaderboard": [
    {
      "rank": 1,
      "playerId": 15,
      "playerName": "Jane Player",
      "totalScore": 342.5,
      "weeklyScores": [87.5, 92.0, 85.0, 78.0],
      "topScorer": {  // ✅ CORRECT - Show top performing player
        "name": "Patrick Mahomes",
        "position": "QB",
        "points": 28.6
      },
      "isMe": false
    }
  ]
}
```

**Requirements Reference:**
> "Standard PPR scoring - cumulative season scoring across all configured weeks"
> "League player's total score = sum of all their selected NFL players' scores"

---

### Issue #2: Admin View Shows "eliminated" Flag ❌

**Location:** Lines 462-466

**Current API Response:**
```json
{
  "selections": [
    {
      "playerId": 10,
      "playerName": "John Player",
      "week": 1,
      "nflWeek": 15,
      "teamName": "Kansas City Chiefs",  // ❌ WRONG - Not team selection
      "eliminated": false,  // ❌ WRONG - No elimination
      "score": 87.5
    }
  ]
}
```

**Why This Is Wrong:**
- "teamName" implies picking NFL teams, not individual players
- "eliminated" flag doesn't exist in traditional fantasy football
- This is still describing survivor pool team selections

**Should Be:**
```json
{
  "rosterSelections": [
    {
      "leaguePlayerId": "uuid-here",
      "playerName": "John Player",
      "position": "QB",
      "nflPlayerId": 501,
      "nflPlayerName": "Patrick Mahomes",
      "nflTeam": "Kansas City Chiefs",
      "weeklyScores": [28.6, 24.2, 31.5, 22.8],
      "totalScore": 107.1
    }
  ]
}
```

**Requirements Reference:**
> "Admins can view all player picks in their leagues"
> "This is traditional fantasy football roster management with position-based selection"

---

### Issue #3: Quick Stats Shows "most eliminated teams" ❌

**Location:** Line 517

**Current:**
```
- **Quick Stats**: Total players, average score, most eliminated teams
```

**Why This Is Wrong:**
- No teams are selected or eliminated
- This metric is meaningless in roster-based fantasy football

**Should Be:**
```
- **Quick Stats**: Total players, average score, top scorer, highest weekly score
```

Or more useful roster stats:
```
- **Quick Stats**: Total players, average score, most rostered player, highest scoring position
```

---

### Issue #4: Score Breakdown Shows "eliminated" Status ❌

**Location:** Lines 965, 978

**Current API Response:**
```json
{
  "playerId": 10,
  "playerName": "John Player",
  "week": 1,
  "nflWeek": 15,
  "teamName": "Kansas City Chiefs",  // ❌ Team name
  "totalScore": 87.5,
  "breakdown": {
    // ... stats ...
  },
  "eliminated": false,  // ❌ No elimination
  "gameStatus": "FINAL"
}
```

**Current UI Display:**
```
- **Elimination Status**: Red badge if eliminated  // ❌ WRONG
```

**Why This Is Wrong:**
- Score breakdown should show ROSTER player performance, not team
- No elimination status in fantasy football

**Should Be:**
```json
{
  "playerId": 10,
  "playerName": "John Player",
  "week": 1,
  "nflWeek": 15,
  "totalScore": 127.4,
  "rosterBreakdown": [
    {
      "position": "QB",
      "nflPlayer": "Patrick Mahomes",
      "nflTeam": "Kansas City Chiefs",
      "points": 28.6,
      "stats": {
        "passingYards": 325,
        "passingTDs": 3,
        "interceptions": 0
      }
    },
    {
      "position": "RB",
      "nflPlayer": "Christian McCaffrey",
      "nflTeam": "San Francisco 49ers",
      "points": 24.8,
      "stats": {
        "rushingYards": 128,
        "rushingTDs": 1,
        "receptions": 5,
        "receivingYards": 42
      }
    }
    // ... all roster positions ...
  ],
  "weekStatus": "COMPLETE"
}
```

**UI Display:**
```
- **Roster Breakdown**: Show each player's performance (name, position, stats, points)
- **Weekly Total**: Sum of all roster player scores
- **Top Performer**: Highlight highest scoring player
```

**Requirements Reference:**
> "View game-by-game scoring breakdown for each selected player"
> "Points breakdown by player position"

---

## CORRECTLY DESIGNED SECTIONS ✅

### 1. Build Roster Screen (Section 3) ✅
- Correct API endpoints for roster management
- Individual NFL player search
- Position-based roster slots
- Roster lock mechanism
- Add/remove players before lock

### 2. Roster Management Screen (Section 10) ✅
- Draft-style interface
- NFL player search and filtering
- Slot-based assignment
- Position eligibility validation

### 3. Authentication (Section 1) ✅
- Google OAuth flow correct
- JWT token handling
- Envoy headers properly defined

---

## REQUIRED API FIXES

### HIGH PRIORITY - Must Fix Before Development

1. **Leaderboard API (Line 331-348)**
   - Remove `"eliminatedTeams"` field
   - Add `"topScorer"` object with player name, position, points
   - Keep cumulative scoring focus

2. **Admin View API (Line 462-469)**
   - Rename `selections` to `rosterSelections`
   - Remove `"teamName"` (use `"nflTeam"` for player's team)
   - Remove `"eliminated"` flag
   - Add roster position breakdown

3. **Quick Stats (Line 517)**
   - Remove "most eliminated teams"
   - Add roster-relevant stats:
     - Top scorer (player name + points)
     - Highest weekly score
     - Most rostered player

4. **Score Breakdown API (Line 965-968)**
   - Remove `"eliminated"` field
   - Change from team-based to roster player breakdown
   - Show per-player scoring for all roster positions
   - Include player stats (yards, TDs, receptions, etc.)

---

## COMPONENTS.MD STATUS ✅

**VERIFIED CORRECT** - All components properly reference:
- "Build Roster" navigation
- NFL Player Card components
- Roster status indicators
- Position-based selection
- Roster lock warnings

No changes needed to COMPONENTS.md.

---

## WIREFRAMES.MD STATUS ✅

**VERIFIED CORRECT** - All wireframes properly show:
- Build Roster Screen (individual NFL players)
- Position-based roster slots
- Player search interface
- Roster lock countdown
- PPR scoring leaderboard

No changes needed to WIREFRAMES.md.

---

## Impact Assessment

### API Development Impact: CRITICAL ❌
- Backend developers will implement wrong API contracts
- Frontend will receive incorrect data structures
- Survivor pool concepts will leak into codebase

### Timeline Impact: MEDIUM ⚠️
- 2-4 hours to update API documentation
- Low risk since no code written yet

### Data Model Impact: MEDIUM ⚠️
- API contracts align with backend implementation
- Backend already has correct roster-based model
- Just need to update API documentation

---

## Recommendations

### IMMEDIATE ACTIONS

1. **Update Leaderboard API Documentation** 📋
   - Remove `eliminatedTeams` field
   - Add `topScorer` object
   - Focus on roster performance metrics

2. **Update Admin View API Documentation** 📋
   - Change to `rosterSelections` endpoint
   - Show roster player breakdown
   - Remove elimination concepts

3. **Update Score Breakdown API Documentation** 📋
   - Show roster-based scoring breakdown
   - Per-player performance display
   - Remove team and elimination references

4. **Update Quick Stats** 📋
   - Replace "eliminated teams" with roster metrics
   - Add useful fantasy football stats

5. **Cross-Reference with Backend APIs** ✅
   - Verify API docs match actual backend implementation
   - Backend likely already correct (follows requirements.md)
   - Just update documentation to match

---

## Cross-Reference Check

The Gherkin feature files in `features/` directory correctly specify:
- Roster-based player selection
- No elimination mechanics
- PPR cumulative scoring
- Position-based roster management

**Action:** Update API-INTEGRATION.md to align with feature files.

---

## Conclusion

**Progress:** 95% of UI design files are correct ✅
**Remaining Issues:** API-INTEGRATION.md has 4 critical survivor pool concepts ❌

The API documentation incorrectly describes survivor pool endpoints (team selection, elimination tracking) instead of traditional fantasy football endpoints (roster management, player scoring).

**Required Work:**
- 4 API endpoint sections to update
- Estimated time: 2-4 hours
- Priority: HIGH (blocks frontend development)

**Next Steps:**
1. Update API-INTEGRATION.md sections 4, 5, 9 (Leaderboard, Admin, Score Breakdown)
2. Remove all "eliminated" and "eliminatedTeams" references
3. Add roster player breakdown responses
4. Final validation against requirements.md and feature files

---

**Status:** 🟡 PARTIAL COMPLETION - API documentation needs updates

**Reviewed by:** Feature Architect (engineer1)
**Date:** 2025-10-02 12:32
**Severity:** HIGH
**Priority:** IMMEDIATE
