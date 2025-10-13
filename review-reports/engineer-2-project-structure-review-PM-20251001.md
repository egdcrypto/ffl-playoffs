# Review: Engineer 2 - Project Structure Engineer
Date: 2025-10-01
Reviewer: Product Manager

## Summary
**🚨 CRITICAL BLOCKING ISSUE**: Java codebase contains the SAME conflicting game models as the feature files. Code implementing WEEKLY TEAM ELIMINATION POOL model coexists with correct ONE-TIME DRAFT ROSTER model code. This is a blocking issue that must be resolved immediately before any further implementation.

## Requirements Compliance

### ❌ CRITICAL FAILURE: Two Game Models Implemented Simultaneously

The Java implementation contains code for **TWO DIFFERENT GAMES**:

**MODEL 1 (INCORRECT - Must Delete)**:
- Weekly team selection system (TeamSelection.java, SelectTeamUseCase.java)
- Team elimination mechanics (TeamEliminatedEvent.java)
- Weekly selection per player per week
- Domain model supports "team choices for specific weeks"

**MODEL 2 (CORRECT - Keep and Expand)**:
- One-time roster draft system (Roster.java, RosterSlot.java, BuildRosterUseCase.java)
- Individual NFL player selections by position
- Permanent roster lock functionality
- League-scoped player ownership (League.java, LeaguePlayer.java)

Based on requirements.md (lines 112-148, 465-516), the system must implement **ONLY the ONE-TIME DRAFT ROSTER MODEL**.

## Findings

### ✅ What's Correct

**1. Hexagonal Architecture Structure** ✅
- Proper package structure:
  - `domain/model` - Domain entities with no framework dependencies
  - `domain/port` - Repository interfaces (ports)
  - `application/usecase` - Use cases orchestrating domain logic
  - `application/dto` - Data transfer objects
  - `infrastructure/adapter/persistence` - MongoDB repositories (adapters)
  - `infrastructure/adapter/rest` - REST controllers
- **Lines verified**: File structure follows clean architecture principles
- **Evidence**: Domain models (Roster.java, NFLPlayer.java) have zero framework dependencies

**2. Roster Model Implementation** ✅
- `Roster.java` (242 lines):
  - **Lines 1-13**: Proper documentation as aggregate root
  - **Lines 15-23**: Correct attributes (leaguePlayerId, gameId, slots, isLocked, lockedAt, rosterDeadline)
  - **Lines 52-67**: `assignPlayerToSlot()` - validates not locked, prevents duplicate players
  - **Lines 81-101**: `dropAndAddPlayer()` - supports pre-lock roster editing
  - **Lines 103-112**: `isComplete()` and `getMissingPositions()` - roster validation
  - **Lines 122-125**: `hasPlayer()` - prevents same NFL player twice on roster
  - **Lines 127-131**: `lockRoster()` - permanent roster lock implementation
  - **Lines 139-146**: `validateNotLocked()` - throws RosterLockedException when changes attempted after lock
  - **Lines 236-240**: Custom exception for roster lock violations

**3. RosterSlot Implementation** ✅
- `RosterSlot.java`:
  - Represents individual position slots (QB, RB, WR, TE, FLEX, K, DEF)
  - Tracks assigned NFL player ID per slot
  - Position eligibility validation

**4. RosterConfiguration Implementation** ✅
- `RosterConfiguration.java`:
  - Configurable position counts (Map<Position, Integer>)
  - Supports flexible roster structures per league
  - Aligns with requirements.md lines 226-238

**5. NFLPlayer Domain Model** ✅
- `NFLPlayer.java`:
  - Represents individual NFL players (not teams)
  - Includes firstName, lastName, position, nflTeam, jerseyNumber, status
  - Aligns with requirements.md line 471

**6. League and LeaguePlayer Implementation** ✅
- `League.java`:
  - Includes startingWeek, numberOfWeeks, rosterConfiguration, scoringRules
  - Configuration lock support (isLocked, lockedAt, lockReason)
  - Aligns with requirements.md lines 468, 499-500
- `LeaguePlayer.java`:
  - Junction table for league membership
  - League-scoped player association
  - Aligns with requirements.md lines 469, 502-503

**7. Authentication Service Implementation** ✅
- `infrastructure/auth/AuthService.java` - Envoy ext_authz handler
- `infrastructure/auth/GoogleJwtValidator.java` - Google OAuth validation
- `infrastructure/auth/PATValidator.java` - Personal Access Token validation
- `infrastructure/auth/TokenValidator.java` - Unified token validation interface
- Aligns with requirements.md lines 345-407 (Envoy sidecar security)

**8. PAT Domain Model** ✅
- `domain/model/PersonalAccessToken.java` - PAT entity
- `domain/model/PATScope.java` - Scope enumeration
- `domain/port/PersonalAccessTokenRepository.java` - Repository interface
- Aligns with requirements.md lines 79-99, 486-487

**9. Use Case Layer Structure** ✅
- `CreateLeagueUseCase.java` - League creation orchestration
- `ConfigureLeagueUseCase.java` - League configuration
- `ValidateConfigurationLockUseCase.java` - Lock validation
- `BuildRosterUseCase.java` - Roster building orchestration ✅ CORRECT
- `FetchNFLScheduleUseCase.java` - NFL data integration
- `FetchPlayerStatsUseCase.java` - Individual player stats
- `FetchDefensiveStatsUseCase.java` - Defensive stats

**10. MongoDB Infrastructure** ✅
- Document classes for persistence mapping
- Mapper classes for domain-to-document conversion
- Repository implementations (GameRepositoryImpl, PlayerRepositoryImpl)
- Aligns with requirements.md line 544 (MongoDB 6+)

### ❌ What Needs Fixing (CRITICAL)

**1. TeamSelection.java** ❌ MUST DELETE
- **File**: `domain/model/TeamSelection.java`
- **Issue**: Implements WEEKLY TEAM SELECTION model
- **Evidence**:
  - Line 7: "represents a player's team choice for a specific week"
  - Line 13-14: `Integer week` and `String nflTeamCode` - selecting NFL TEAMS per week
  - Lines 50-52: `isWinningSelection()` - elimination pool mechanic
- **Violation**: Requirements state "roster building by selecting individual NFL players" (req line 113), NOT weekly team selections
- **Action**: DELETE this entire file

**2. SelectTeamUseCase.java** ❌ MUST DELETE
- **File**: `application/usecase/SelectTeamUseCase.java`
- **Issue**: Use case for weekly team selection
- **Evidence**:
  - Line 11: "Use case for a player selecting a team"
  - Line 36-38: "Check if player already selected for this week" - weekly selection model
  - Line 49: `player.makeTeamSelection(selection)` - weekly team picking
- **Violation**: Contradicts ONE-TIME DRAFT model
- **Action**: DELETE this entire file

**3. TeamEliminatedEvent.java** ❌ MUST DELETE
- **File**: `domain/event/TeamEliminatedEvent.java`
- **Issue**: Domain event for elimination pool mechanic
- **Evidence**:
  - Line 7: "fired when a player is eliminated from the game"
  - Line 14: `weekEliminated` attribute
- **Violation**: Requirements have NO elimination mechanic (req lines 112-148 describe ONE-TIME DRAFT only)
- **Action**: DELETE this entire file

**4. TeamSelectionRepository.java** ❌ MUST DELETE
- **File**: `domain/port/TeamSelectionRepository.java`
- **Issue**: Repository for team selections
- **Action**: DELETE this file (verified exists in file list)

**5. TeamSelectionDTO.java** ❌ MUST DELETE
- **File**: `application/dto/TeamSelectionDTO.java`
- **Issue**: DTO for weekly team selections
- **Action**: DELETE this file

**6. TeamSelectionDocument.java** ❌ MUST DELETE
- **File**: `infrastructure/adapter/persistence/document/TeamSelectionDocument.java`
- **Issue**: MongoDB document for team selections
- **Action**: DELETE this file

**7. Player.java Domain Model** ❌ NEEDS REVIEW/CLEANUP
- **File**: `domain/model/Player.java`
- **Issue**: Likely contains `makeTeamSelection()` and weekly selection logic
- **Evidence**: SelectTeamUseCase.java line 49 calls `player.makeTeamSelection(selection)`
- **Action**: READ and REMOVE all team selection methods. Player should reference Roster, not TeamSelection

**8. Game.java Domain Model** ❌ NEEDS REVIEW/CLEANUP
- **File**: `domain/model/Game.java`
- **Issue**: May contain elimination tracking and weekly selection logic
- **Action**: READ and ENSURE it supports roster-based gameplay only

**9. PlayerController.java** ❌ NEEDS REVIEW
- **File**: `infrastructure/adapter/rest/PlayerController.java`
- **Issue**: May expose endpoints for team selection
- **Action**: VERIFY endpoints support roster building, not team selection

**10. Score.java Domain Model** ❌ NEEDS REVIEW
- **File**: `domain/model/Score.java`
- **Issue**: Likely has `isWin()` method for elimination logic
- **Evidence**: TeamSelection.java line 51 calls `this.score.isWin()`
- **Action**: REMOVE win/loss logic. Score should track PPR fantasy points only

### Missing Implementation

The following requirements are not yet implemented:

1. **RosterSelection Entity** (requirements.md line 476)
   - Missing: Entity linking RosterSlot to NFLPlayer with week tracking
   - Need: `RosterSelection(rosterSlot, nflPlayer, week)` value object

2. **PlayerStats and DefensiveStats Entities** (requirements.md lines 477-478)
   - Missing: Game-by-game player statistics tracking
   - Need: PlayerStats (nflPlayerId, nflWeek, gameId, passing/rushing/receiving stats)
   - Need: DefensiveStats (nflTeamId, nflWeek, gameId, sacks, INTs, points/yards allowed)

3. **ScoringService Implementation** (requirements.md lines 150-208)
   - File exists but need to verify PPR calculation logic
   - Must support: Full PPR, Half PPR, Standard
   - Must support: Field goal distance scoring
   - Must support: Defensive scoring with tiers

4. **ConfigurationLockedException** (requirements.md lines 248-268)
   - Missing: Exception for league configuration lock violations
   - Need: Thrown when admin attempts to modify config after first game starts

5. **Roster Lock Deadline Validation** (requirements.md line 140)
   - Roster.java has rosterDeadline but needs first game start validation
   - Lock should occur at "first game starts" NOT just deadline

6. **AdminInvitation and PlayerInvitation Entities** (requirements.md lines 482-483, 512)
   - Mentioned in work queue but not confirmed implemented
   - Need to verify these exist and are correct

7. **AuditLog Entity** (requirements.md line 488)
   - Mentioned in work queue but not confirmed implemented
   - Need for admin activity tracking

8. **NFLGame Entity** (requirements.md line 481)
   - Missing: NFL game schedule tracking
   - Need: homeTeam, awayTeam, week, gameTime, result

## Hexagonal Architecture Compliance

### ✅ Architecture Compliance

**Domain Layer** ✅
- Clean domain models with no framework dependencies
- Business logic encapsulated in entities (Roster.assignPlayerToSlot, Roster.lockRoster)
- Repository interfaces as ports
- Domain events defined (though TeamEliminatedEvent is wrong model)

**Application Layer** ✅
- Use cases orchestrate domain logic
- DTOs for data transfer
- Clear separation from infrastructure

**Infrastructure Layer** ✅
- REST controllers in `adapter/rest`
- MongoDB persistence in `adapter/persistence`
- External NFL data integration in `adapter/integration`
- Dependency direction: Infrastructure → Application → Domain ✅

**Configuration** ✅
- SpringConfig.java for dependency injection
- SecurityConfig.java for security
- AuthServiceConfiguration.java for auth service

### ⚠️ Architecture Concerns

1. **Domain Event Confusion**
   - TeamEliminatedEvent violates requirements (no elimination in ONE-TIME DRAFT)
   - GameCreatedEvent exists - verify it's correct

2. **Mixed Models in Domain Layer**
   - TeamSelection vs. Roster - contradictory domain concepts
   - Suggests unclear requirements interpretation

## Technology Stack Compliance

✅ **Java with Spring Boot** - Confirmed
✅ **MongoDB** - Confirmed (GameMongoRepository, documents, mappers)
✅ **Hexagonal Architecture** - Confirmed (proper package structure)
✅ **Envoy Sidecar Auth** - Confirmed (AuthService.java, TokenValidator.java)
✅ **Google OAuth + PAT** - Confirmed (GoogleJwtValidator.java, PATValidator.java)

## Code Quality Observations

### ✅ Strengths
- Clean domain models with business logic
- Proper exception handling (RosterLockedException)
- Defensive copying (Roster.getSlots() returns new ArrayList)
- Validation logic (validateNotLocked, hasPlayer)
- Well-documented classes with Javadoc comments

### ⚠️ Areas for Improvement
- Delete all elimination pool code immediately
- Add unit tests for domain models (mentioned in work queue)
- Add integration tests for use cases
- Implement missing entities (PlayerStats, DefensiveStats, RosterSelection)

## Recommendation

🚫 **CHANGES REQUIRED** - Blocking issue must be resolved immediately

### Immediate Actions Required (CRITICAL)

**STOP ALL NEW IMPLEMENTATION** until model conflict is resolved.

**DELETE these files immediately**:
1. `domain/model/TeamSelection.java`
2. `application/usecase/SelectTeamUseCase.java`
3. `domain/event/TeamEliminatedEvent.java`
4. `domain/port/TeamSelectionRepository.java`
5. `application/dto/TeamSelectionDTO.java`
6. `infrastructure/adapter/persistence/document/TeamSelectionDocument.java`

**REVIEW and CLEAN UP**:
1. `domain/model/Player.java` - Remove `makeTeamSelection()` and team selection tracking
2. `domain/model/Game.java` - Remove elimination tracking
3. `domain/model/Score.java` - Remove `isWin()` logic, focus on PPR points only
4. `infrastructure/adapter/rest/PlayerController.java` - Remove team selection endpoints
5. `infrastructure/adapter/rest/GameController.java` - Verify no team selection endpoints

**IMPLEMENT MISSING REQUIREMENTS**:
1. RosterSelection entity (link RosterSlot to NFLPlayer)
2. PlayerStats entity (game-by-game individual player stats)
3. DefensiveStats entity (game-by-game team defense stats)
4. ConfigurationLockedException
5. Enhanced roster lock validation (first game start, not just deadline)
6. NFLGame entity (schedule tracking)
7. Verify AdminInvitation and PlayerInvitation are correct
8. Verify AuditLog implementation

### Next Steps

1. **Engineer 2**: Acknowledge this review and STOP all new work
2. **Engineer 2**: Delete all elimination pool code files listed above
3. **Engineer 2**: Clean up Player.java, Game.java, Score.java
4. **Engineer 2**: Implement missing roster-based requirements
5. **Product Manager**: Coordinate with Engineer 1 on feature file alignment
6. **All Engineers**: Full team alignment meeting on ONE-TIME DRAFT model

## Evidence Summary

| Component | Status | Evidence |
|-----------|--------|----------|
| Roster.java | ✅ CORRECT | Lines 1-241: Proper roster aggregate with lock enforcement |
| RosterSlot.java | ✅ CORRECT | Position-based NFL player slot assignment |
| RosterConfiguration.java | ✅ CORRECT | Configurable roster structure |
| League.java | ✅ CORRECT | startingWeek, numberOfWeeks, configuration lock support |
| LeaguePlayer.java | ✅ CORRECT | League-scoped player membership |
| NFLPlayer.java | ✅ CORRECT | Individual NFL player entity |
| BuildRosterUseCase.java | ✅ CORRECT | Roster building orchestration |
| TeamSelection.java | ❌ WRONG MODEL | Line 7: "team choice for a specific week" |
| SelectTeamUseCase.java | ❌ WRONG MODEL | Lines 36-38: Weekly team selection logic |
| TeamEliminatedEvent.java | ❌ WRONG MODEL | Line 7: Elimination pool mechanic |
| Auth infrastructure | ✅ CORRECT | Envoy ext_authz, Google OAuth, PAT support |
| MongoDB infrastructure | ✅ CORRECT | Documents, mappers, repositories |
| Hexagonal architecture | ✅ CORRECT | Proper layer separation |

## Approval Status

**STATUS**: 🚫 **CHANGES REQUIRED - BLOCKING**

**Blocking Issues**:
1. Java codebase implements TWO conflicting game models simultaneously
2. Elimination pool code (TeamSelection, SelectTeamUseCase, TeamEliminatedEvent) must be DELETED
3. Missing critical entities (RosterSelection, PlayerStats, DefensiveStats, NFLGame)
4. Domain model cleanup required (Player.java, Game.java, Score.java)

**Impact**:
- Cannot proceed with any implementation until model conflict resolved
- All work queued for Engineer 2 is at risk if based on wrong model
- Documentation from Engineer 3 likely affected by same conflict

**Cannot approve for implementation until elimination pool code is completely removed and roster-based model is fully implemented.**
