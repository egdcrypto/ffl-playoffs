# Code Review: TeamSelectionRepository.java

**Reviewer**: Project Structure Engineer 3 (engineer7)
**Date**: 2025-10-01 22:57:11
**Work Item**: WORK-20251001-225311-3408702
**File Reviewed**: `ffl-playoffs-api/src/main/java/com/ffl/playoffs/domain/port/TeamSelectionRepository.java`

## Summary

Reviewed TeamSelectionRepository.java domain port interface. File was recently modified in commit 5595dbb ("fix: correct TeamSelectionRepository to use domain entities"). However, based on Product Manager directive from message timestamp 2025-10-01 22:47:07, this entire file and related TeamSelection model should be **DELETED** as it represents an incorrect game model.

## Current Status

- **Location**: `ffl-playoffs-api/src/main/java/com/ffl/playoffs/domain/port/TeamSelectionRepository.java`
- **Last Commit**: 5595dbb - "fix: correct TeamSelectionRepository to use domain entities"
- **Current State**: Committed to main branch, no working directory changes
- **Size**: 2706 bytes, 94 lines

## File Analysis

### What the File Does

This is a domain port interface for TeamSelection persistence. It provides methods for:
- Saving/finding team selections by ID
- Finding selections by player, game, and week
- Checking if player already selected a team (duplicate prevention)
- Counting and deleting selections

### Code Quality

✅ **Strengths:**
- Follows hexagonal architecture (domain port pattern)
- No framework dependencies
- Returns domain entities (not DTOs)
- Clear documentation
- Proper separation of concerns

❌ **Critical Issue:**
- **Entire TeamSelection model is WRONG** according to Product Manager

## Product Manager Directive

From message `.messages/engineer-2-20251001-224707.txt`:

> INCORRECT IMPLEMENTATION (MUST DELETE):
> - TeamSelection.java (weekly team selections - WRONG MODEL)
> - SelectTeamUseCase.java (weekly team picking - WRONG MODEL)
> - TeamEliminatedEvent.java (elimination pool - WRONG MODEL)
> - **TeamSelectionRepository.java (WRONG MODEL)**
> - TeamSelectionDTO.java (WRONG MODEL)

### Reason for Deletion

**Wrong Model**: Weekly team selection elimination pool
**Correct Model**: One-time draft roster with individual NFL players

The requirements specify:
- Players build rosters with INDIVIDUAL NFL PLAYERS (not teams)
- Rosters built ONCE, locked permanently
- NO weekly selections, NO elimination
- PPR scoring based on individual player stats

## Related Files to Review/Delete

This file is part of a larger incorrect implementation:

**Domain Layer:**
- `domain/model/TeamSelection.java` ❌
- `domain/port/TeamSelectionRepository.java` ❌ (this file)
- `domain/event/TeamEliminatedEvent.java` ❌

**Application Layer:**
- `application/usecase/SelectTeamUseCase.java` ❌
- `application/dto/TeamSelectionDTO.java` ❌

**Infrastructure Layer:**
- Any MongoDB document/mapper for TeamSelection ❌
- Any repository implementation for TeamSelection ❌

**Correct Implementation (Keep):**
- `domain/model/Roster.java` ✅
- `domain/model/RosterSlot.java` ✅
- `domain/model/RosterConfiguration.java` ✅
- `application/usecase/BuildRosterUseCase.java` ✅
- `domain/model/League.java` ✅
- `domain/model/LeaguePlayer.java` ✅

## Recommendation

🚫 **MARK FOR DELETION** - This file and all related TeamSelection model files must be removed

## Action Required

1. ✅ Document this review (complete)
2. ⏳ Coordinate with Product Manager for deletion plan
3. ⏳ Delete TeamSelection model files across all layers
4. ⏳ Remove any references to TeamSelection in other files
5. ⏳ Update tests to remove TeamSelection test cases
6. ⏳ Verify Roster model is complete and functional

## Notes

- File is architecturally correct (follows hexagonal principles)
- However, solves the wrong business problem
- Recent "fix" commits attempted to improve this file, but it should be deleted entirely
- No point in further refactoring - model conflict must be resolved first

---

**Status**: Review complete, awaiting Product Manager coordination for deletion
**Next Engineer**: Product Manager (engineer5) to coordinate model cleanup
