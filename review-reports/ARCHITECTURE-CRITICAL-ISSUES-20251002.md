# ARCHITECTURE.md - Critical Issues Report
**Date**: 2025-10-02
**Reviewer**: Documentation Engineer
**Work ID**: WORK-20251002-115527

## Executive Summary

**CRITICAL**: The `docs/ARCHITECTURE.md` file contains fundamental misalignment with the actual project requirements. The architecture describes a **team elimination survivor pool** game model, but `requirements.md` and all feature files define a **traditional fantasy football roster-based system** with individual NFL player selection.

**Status**: ❌ MAJOR REVISIONS REQUIRED
**Impact**: HIGH - Could mislead development team and cause incorrect implementation

---

## Critical Issues Found

### 1. ❌ WRONG GAME MODEL - Team Elimination vs. Roster-Based
**Location**: Lines 82-84, 139-153, 490-497, 641-712

**Current (INCORRECT)**:
- Domain model shows `TeamSelection` entity
- References "eliminated teams" and elimination logic
- Shows `eliminate()` method and `canScorePoints()` logic
- Describes team elimination survivor pool mechanics

**Required (CORRECT)**:
- Domain model should show **Roster** and **RosterSelection** entities
- System is based on **individual NFL player selection** (QB, RB, WR, TE, K, DEF)
- **ONE-TIME DRAFT MODEL**: rosters built once, locked permanently after first game
- NO elimination logic - players score based on NFL player performance
- Scoring = sum of all roster players' PPR fantasy points

**Evidence from requirements.md**:
```
Section 2: "build rosters by selecting individual NFL players across
multiple positions (QB, RB, WR, TE, FLEX, K, DEF, Superflex)"

Section 2: "ONE-TIME DRAFT MODEL - rosters are built ONCE before the season
- Roster PERMANENTLY LOCKED when first game starts
- NO changes allowed for entire season (no waiver wire, no trades)"
```

---

### 2. ❌ MISSING Core Domain Entities
**Location**: Lines 80-109 (Domain Model diagram)

**Missing Critical Entities**:
- ✅ `NFLPlayer` - Individual NFL players (Patrick Mahomes, Christian McCaffrey, etc.)
- ✅ `NFLTeam` - 32 NFL teams
- ✅ `Roster` - League player's roster (list of NFL players)
- ✅ `RosterSelection` - NFL player in specific roster slot
- ✅ `RosterSlot` - Position definition (QB, RB, WR, TE, FLEX, K, DEF, Superflex)
- ✅ `RosterConfiguration` - League's roster structure
- ✅ `Position` - Enum (QB, RB, WR, TE, K, DEF)
- ✅ `PlayerStats` - Individual NFL player stats per game
- ✅ `DefensiveStats` - Team defense stats per game
- ✅ `LeaguePlayer` - Junction table for league membership

**Incorrect Entities Shown**:
- ❌ `TeamSelection` - doesn't exist in requirements
- ❌ `Player` aggregate with TeamSelection - wrong model

---

### 3. ❌ WRONG Domain Services
**Location**: Lines 518-528

**Current (INCORRECT)**:
- `EliminationService` - doesn't exist
- References "eliminated teams" logic

**Required (CORRECT)**:
- `ScoringService` - Calculate PPR scores from individual NFL player stats
- `RosterValidator` - Validate roster selections (position eligibility, no duplicates)
- `ConfigurationValidator` - Validate league configuration
- `DefensiveScoringService` - Calculate defense scoring with tiers

---

### 4. ❌ WRONG Domain Events
**Location**: Lines 104-108, 905-922

**Current (INCORRECT)**:
- `TeamEliminatedEvent` - doesn't exist
- `TeamSelectedEvent` - doesn't exist

**Required (CORRECT)**:
- `NFLPlayerSelectedEvent` - When player adds NFL player to roster
- `RosterCompletedEvent` - When all roster slots filled
- `RosterLockedEvent` - When first game starts (permanent lock)
- `PlayerStatsUpdatedEvent` - When NFL player stats updated
- `LeagueConfigurationLockedEvent` - When league config locks
- `WeekScoresCalculatedEvent` - When weekly scores calculated

---

### 5. ❌ WRONG Data Flows
**Location**: Lines 641-712

**Issues**:
1. **Team Selection Flow** (lines 641-664):
   - Shows "MakeTeamSelectionUseCase" - doesn't exist
   - Shows "TeamSelectionValidator" - doesn't exist
   - References team selection instead of NFL player selection

2. **Score Calculation Flow** (lines 666-688):
   - Shows "Check if team is eliminated" - wrong logic
   - Missing PPR scoring calculation from individual player stats

3. **Team Elimination Flow** (lines 691-712):
   - Entire section is WRONG - no elimination in this system
   - Should be removed completely

**Required Flows**:
1. **Roster Building Flow**:
   - Player selects individual NFL player (e.g., Patrick Mahomes)
   - System validates position eligibility (QB slot only accepts QB)
   - System validates no duplicate NFL players in roster
   - RosterSelection created linking RosterSlot to NFLPlayer

2. **Score Calculation Flow**:
   - Fetch individual NFL player stats for the week
   - Calculate fantasy points per NFL player (PPR rules)
   - Sum all roster player points for league player's weekly score
   - No elimination logic - just sum of fantasy points

3. **Roster Lock Flow**:
   - First game starts
   - All rosters permanently locked
   - No changes allowed for entire season
   - Must compete with locked roster

---

### 6. ❌ MISSING Critical Business Rules

**Not Documented**:
1. **ONE-TIME DRAFT MODEL**:
   - Rosters built ONCE before first game
   - Rosters PERMANENTLY LOCKED when first game starts
   - NO changes after lock: no waiver wire, no trades, no weekly adjustments

2. **Roster Lock Enforcement**:
   - Roster lock deadline = first game start time
   - Incomplete rosters score 0 for unfilled positions
   - Injured/suspended players must remain on roster

3. **Individual NFL Player Selection**:
   - Traditional fantasy football model
   - Select specific NFL players by name (not teams)
   - Position-based roster slots (QB, RB, WR, TE, FLEX, K, DEF, Superflex)
   - FLEX position: accepts RB, WR, or TE
   - Superflex position: accepts QB, RB, WR, or TE
   - Multiple league players can select same NFL player (unlimited availability)

4. **Scoring Model**:
   - PPR (Points Per Reception) scoring for individual players
   - Field goal scoring by distance (0-39, 40-49, 50+ yards)
   - Defensive scoring with configurable tiers (points allowed, yards allowed)
   - League player's score = sum of all roster players' fantasy points

---

### 7. ❌ MISSING Value Objects

**Not Shown in Architecture**:
- `RosterConfiguration` - Defines league roster structure
- `PPRScoringRules` - PPR scoring configuration
- `FieldGoalScoringRules` - Kicker scoring by distance
- `DefensiveScoringRules` - Defense scoring with tiers
- `ScoringTier` - Points allowed/yards allowed tier definition

---

### 8. ✅ CORRECT Sections (No Issues)

These sections are accurate and aligned with requirements:
- **Security Architecture** (lines 385-472) - ✅ Correct Envoy sidecar architecture
- **Configuration Immutability** (lines 532-618) - ✅ Correct lock mechanism
- **Hexagonal Architecture Principles** (lines 17-31, 46-110, 262-381) - ✅ Correct pattern
- **Technology Stack** (lines 34-42) - ✅ Correct technologies
- **Deployment Architecture** (lines 716-795) - ✅ Correct K8s setup
- **Database Schema** (lines 798-848) - ✅ Correct structure (though missing some collections)

---

## Impact Assessment

### High Impact Issues
1. **Development Confusion**: Team might implement wrong game model (team elimination vs roster)
2. **Wasted Effort**: Code written based on this architecture would need major rework
3. **Testing Issues**: Tests would be written for wrong domain model
4. **Integration Problems**: API contracts would be misaligned

### Medium Impact Issues
1. **Documentation Inconsistency**: Architecture doesn't match feature files
2. **Onboarding Problems**: New developers would be misled
3. **Design Review Issues**: Architecture reviews would use wrong baseline

---

## Required Actions

### Immediate (Critical)
1. ✅ **Replace all `TeamSelection` references with `Roster` and `RosterSelection`**
2. ✅ **Remove all team elimination logic and flows**
3. ✅ **Add missing domain entities**: NFLPlayer, NFLTeam, RosterSlot, RosterConfiguration, Position, PlayerStats, DefensiveStats, LeaguePlayer
4. ✅ **Update domain services**: Remove EliminationService, add ScoringService, RosterValidator
5. ✅ **Update domain events**: Remove team elimination events, add roster events
6. ✅ **Rewrite data flows**: Roster Building Flow, Score Calculation Flow, Roster Lock Flow

### High Priority
1. ✅ **Add ONE-TIME DRAFT MODEL documentation**
2. ✅ **Add Roster Lock business rules**
3. ✅ **Add Individual NFL Player Selection details**
4. ✅ **Add PPR Scoring model documentation**
5. ✅ **Add missing value objects documentation**

### Medium Priority
1. ✅ **Update code examples** to reflect roster-based model
2. ✅ **Add roster configuration examples**
3. ✅ **Add flexible position examples** (FLEX, Superflex)
4. ✅ **Update testing strategy** for roster model

---

## Verification Checklist

To verify the corrected architecture, ensure:
- [ ] Domain model shows Roster, RosterSelection, NFLPlayer entities
- [ ] No references to TeamSelection or elimination logic
- [ ] Data flows show roster building with individual NFL player selection
- [ ] Business rules document ONE-TIME DRAFT MODEL
- [ ] Score calculation shows PPR scoring from individual player stats
- [ ] All domain entities from requirements.md are documented
- [ ] Domain events match feature files (roster events, not team events)
- [ ] Value objects include RosterConfiguration and ScoringRules subtypes
- [ ] Code examples use roster-based model, not team elimination

---

## Recommendations

### Documentation Strategy
1. **Reference Source of Truth**: Use `requirements.md` and `features/DOMAIN_MODEL.md` as authoritative sources
2. **Cross-Reference**: Ensure all architecture documentation aligns with feature files
3. **Review Process**: Architecture changes should be reviewed against requirements.md
4. **Version Control**: Track which requirements version architecture is based on

### Quality Assurance
1. **Automated Checks**: Consider tooling to validate architecture-requirements alignment
2. **Peer Review**: Architecture documents should be reviewed by multiple team members
3. **Stakeholder Sign-off**: Product owner should approve architecture before development
4. **Living Documentation**: Keep architecture updated as requirements evolve

---

## Conclusion

**The current ARCHITECTURE.md file is fundamentally misaligned with project requirements and must be completely revised before development proceeds.**

The document describes a team elimination survivor pool game, but the actual system is a traditional fantasy football roster-based game with individual NFL player selection, PPR scoring, and a one-time draft model.

**Recommended Action**: Rewrite ARCHITECTURE.md using `requirements.md` and `features/DOMAIN_MODEL.md` as the authoritative sources.

**Risk if Not Addressed**: Development team will implement the wrong system, resulting in significant rework and project delays.

---

## References
- `/home/repos/ffl-playoffs/requirements.md` - Authoritative requirements (Section 2: Roster Building and Player Selection)
- `/home/repos/ffl-playoffs/features/DOMAIN_MODEL.md` - Correct domain model
- `/home/repos/ffl-playoffs/features/roster-management.feature` - Roster building business rules
- `/home/repos/ffl-playoffs/features/FEATURE_COVERAGE_SUMMARY.md` - Complete feature coverage
