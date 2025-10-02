# WIREFRAMES - REMAINING CRITICAL ISSUES

**Date:** 2025-10-02 12:30
**Reviewer:** Feature Architect (engineer1)
**Work Items:** WORK-20251002-123003-1898921, WORK-20251002-123009-1901555
**Status:** ❌ CRITICAL ISSUES STILL PRESENT

---

## Executive Summary

While significant progress has been made in correcting the wireframes (Build Roster Screen, Player Dashboard, Navigation Flows), **Screen 6: League Configuration Screen** still contains **CRITICAL survivor pool elements** that directly contradict requirements.md.

---

## CRITICAL ISSUES FOUND

### Issue #1: Elimination Rules Section ❌

**Location:** League Configuration Screen, lines 696-704

**Current Wireframe:**
```
Elimination Rules
┌────────────────────────────────────────────────────────┐
│  Elimination Condition                                 │
│  ☑ Loss eliminates player (survivor style)            │
│  ☐ Lowest score each week eliminates                  │
│  ☐ Custom threshold (score below X)                   │
│                                                        │
│  ☑ Each team can only be used once                    │
└────────────────────────────────────────────────────────┘
```

**Why This Is Wrong:**
- Traditional fantasy football does NOT have elimination mechanics
- Players compete based on cumulative PPR scoring
- No "survivor style" elimination
- No "each team can only be used once" rule (this is for team selection, not player drafting)

**Should Be: REMOVE ENTIRE SECTION**
- Traditional fantasy football has no elimination rules
- Players compete for highest cumulative score
- OR if keeping the section, change to:
  ```
  League Format
  ┌────────────────────────────────────────────────────────┐
  │  Scoring System                                        │
  │  ☑ Season-long cumulative scoring (default)           │
  │  ☐ Head-to-head weekly matchups                       │
  │  ☐ Best ball (auto-optimal lineup)                    │
  └────────────────────────────────────────────────────────┘
  ```

**Requirements Reference:**
> "Standard PPR (Points Per Reception) scoring"
> "Cumulative season scoring across all configured weeks"
> "League player's total score = sum of all their selected NFL players' scores"

---

### Issue #2: Scoring Configuration Section ❌

**Location:** League Configuration Screen, lines 704-710

**Current Wireframe:**
```
Scoring Configuration
┌────────────────────────────────────────────────────────┐
│  Points System                                         │
│  ☑ Use team total score (default)                     │
│  ☐ Custom scoring breakdown                            │
│                                                        │
│  Defensive Scoring (Optional)                          │
```

**Why This Is Wrong:**
- "Use team total score" implies picking NFL teams (survivor pool)
- Should be "PPR scoring for individual NFL players"
- "Custom scoring breakdown" is vague

**Should Be:**
```
Scoring Configuration
┌────────────────────────────────────────────────────────┐
│  Scoring Format                                        │
│  ☑ PPR (Points Per Reception) - 1.0 pt/reception      │
│  ☐ Half-PPR - 0.5 pt/reception                        │
│  ☐ Standard (No PPR) - 0.0 pt/reception               │
│                                                        │
│  [Configure Detailed Scoring Rules ▼]                 │
│  ┌────────────────────────────────────────────────┐   │
│  │ Passing                                        │   │
│  │  • Yards per point: [25▼]  (1 pt / 25 yards)  │   │
│  │  • TD points: [4]                              │   │
│  │  • Interception: [-2]                          │   │
│  │                                                │   │
│  │ Rushing                                        │   │
│  │  • Yards per point: [10▼]  (1 pt / 10 yards)  │   │
│  │  • TD points: [6]                              │   │
│  │                                                │   │
│  │ Receiving                                      │   │
│  │  • Yards per point: [10▼]  (1 pt / 10 yards)  │   │
│  │  • Reception: [1.0]  (PPR)                     │   │
│  │  • TD points: [6]                              │   │
│  │                                                │   │
│  │ Misc                                           │   │
│  │  • 2-PT Conversion: [2]                        │   │
│  │  • Fumble Lost: [-2]                           │   │
│  └────────────────────────────────────────────────┘   │
│                                                        │
│  Field Goal Scoring                                    │
```

**Requirements Reference:**
> "Standard PPR scoring rules (configurable by admin)"
> "Passing: 1 point per 25 yards (default, configurable)"
> "Reception: 1 point per reception (PPR, configurable to 0.5 for Half-PPR or 0 for Standard)"

---

### Issue #3: Missing Roster Configuration Section ❌

**Location:** League Configuration Screen

**Currently:** Mentioned in User Interactions (line 811) but NOT shown in wireframe visual

**Should Include:**
```
Roster Configuration
┌────────────────────────────────────────────────────────┐
│  Position Slots (Define how many of each position)     │
│  ┌────────────────────────────────────────────────┐   │
│  │  QB (Quarterback)        [1 ▼]  (0-4)         │   │
│  │  RB (Running Back)       [2 ▼]  (0-6)         │   │
│  │  WR (Wide Receiver)      [2 ▼]  (0-6)         │   │
│  │  TE (Tight End)          [1 ▼]  (0-3)         │   │
│  │  FLEX (RB/WR/TE)         [1 ▼]  (0-3)         │   │
│  │  K (Kicker)              [1 ▼]  (0-2)         │   │
│  │  DEF (Defense/ST)        [1 ▼]  (0-2)         │   │
│  │  Superflex (QB/RB/WR/TE) [0 ▼]  (0-2)         │   │
│  └────────────────────────────────────────────────┘   │
│                                                        │
│  Total Roster Size: 9 players                          │
│  Minimum: 1  Maximum: 20                               │
└────────────────────────────────────────────────────────┘
```

**Requirements Reference:**
> "Roster configuration: Define number of each position required"
> "QB: 0-4 (typical: 1), RB: 0-6 (typical: 2-3), WR: 0-6 (typical: 2-3), etc."
> "Total roster size calculated from position counts"

---

## CORRECTLY UPDATED SECTIONS ✅

### 1. Build Roster Screen (Screen 3) ✅
- Shows individual NFL player selection
- Position-based roster building
- Roster lock countdown with permanent lock warning
- Search/filter for NFL players

### 2. Player Dashboard (Screen 2) ✅
- Navigation: "Build Roster" (not "Make Picks")
- Buttons: "[Build Roster]" (not "[Make Picks]")
- Correct routing

### 3. Navigation Flow: "Player Building Roster Flow" ✅
- Renamed from "Player Making Picks Flow"
- Describes one-time roster building
- Mentions roster lock

### 4. Leaderboard (Screen 4) ✅
- Shows PPR fantasy points
- Displays individual player highlights
- Season-long cumulative scoring

---

## REQUIRED IMMEDIATE CORRECTIONS

### HIGH PRIORITY - Must Fix Before Development

1. **Remove "Elimination Rules" Section**
   - Delete entire section (lines ~696-704)
   - OR replace with "League Format" options (season-long vs head-to-head)

2. **Fix "Scoring Configuration" Section**
   - Change "Use team total score" to PPR scoring format selector
   - Add detailed PPR scoring configuration UI
   - Show all configurable scoring parameters

3. **Add "Roster Configuration" Visual Section**
   - Currently only in User Interactions text
   - Needs visual wireframe showing position slot dropdowns
   - Must include all 8 position types (QB, RB, WR, TE, FLEX, K, DEF, Superflex)

### SUMMARY OF CHANGES NEEDED

| Section | Current State | Required State | Priority |
|---------|--------------|----------------|----------|
| Elimination Rules | ❌ Survivor pool | ✅ Remove or replace | CRITICAL |
| Scoring Config | ❌ Team scoring | ✅ PPR scoring | CRITICAL |
| Roster Config | ❌ Text only | ✅ Visual wireframe | HIGH |

---

## Impact Assessment

### User Experience Impact: HIGH
- Admins will be confused by elimination rules that don't exist
- Scoring configuration is misleading
- Cannot properly configure roster structure

### Development Impact: MEDIUM
- Backend APIs align with requirements.md (correct model)
- Frontend will be misguided by wireframes if not corrected
- Configuration UI will be built incorrectly

### Timeline Impact: LOW
- 1-2 hours to correct wireframe sections
- No code written yet, so minimal rework

---

## Recommendations

1. **IMMEDIATE:** Update League Configuration Screen wireframe sections
   - Remove/replace Elimination Rules
   - Fix Scoring Configuration to show PPR
   - Add visual Roster Configuration section

2. **VERIFY:** Cross-reference with requirements.md section 4 (League Configuration)
   - Starting/ending weeks ✅ (already correct)
   - Roster configuration ❌ (needs visual)
   - Scoring rules ❌ (needs PPR focus)
   - Elimination rules ❌ (should not exist)

3. **VALIDATE:** Review against feature files
   - features/league-configuration.feature
   - features/ppr-scoring.feature
   - features/roster-management.feature

---

## Conclusion

**Progress Made:** 70% of wireframes corrected ✅
**Remaining Issues:** 30% in League Configuration Screen ❌

The core product model (Build Roster Screen, Player Dashboard, Navigation) has been successfully corrected. However, the League Configuration Screen still contains survivor pool elements that will confuse developers and admins.

**Required Actions:**
1. Remove "Elimination Rules" section entirely
2. Replace "Team total score" with PPR scoring configuration
3. Add visual "Roster Configuration" section with position slots

**Estimated Time:** 1-2 hours for UI/UX Designer

---

**Status:** 🟡 PARTIAL COMPLETION - Additional wireframe revisions required

**Next Steps:**
1. Route to UI/UX Designer (engineer4) for League Configuration corrections
2. Final review after corrections
3. Approve for frontend development

---

**Reviewed by:** Feature Architect (engineer1)
**Date:** 2025-10-02 12:30
**Severity:** HIGH (not critical, as most wireframes are correct)
**Priority:** IMMEDIATE (must fix before development)
