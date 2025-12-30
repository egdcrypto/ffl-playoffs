package com.ffl.playoffs.domain.model;

import com.ffl.playoffs.domain.aggregate.Roster;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

/**
 * Unit tests for Roster domain entity
 * Tests roster locking functionality for the one-time draft model
 */
@DisplayName("Roster Domain Entity Tests")
class RosterTest {

    private UUID leaguePlayerId;
    private UUID gameId;
    private RosterConfiguration config;

    @BeforeEach
    void setUp() {
        leaguePlayerId = UUID.randomUUID();
        gameId = UUID.randomUUID();
        config = RosterConfiguration.standard();
    }

    private Roster createCompleteRoster() {
        Roster roster = new Roster(leaguePlayerId, gameId, config);

        // Fill all slots with NFL players
        roster.getSlots().forEach(slot -> {
            long playerId = Math.abs(UUID.randomUUID().hashCode());
            slot.assignPlayer(playerId, slot.getPosition());
        });

        return roster;
    }

    private Roster createIncompleteRoster() {
        Roster roster = new Roster(leaguePlayerId, gameId, config);

        // Only fill some slots (leave QB and K empty)
        roster.getSlots().stream()
                .filter(slot -> slot.getPosition() != Position.QB && slot.getPosition() != Position.K)
                .forEach(slot -> {
                    long playerId = Math.abs(UUID.randomUUID().hashCode());
                    slot.assignPlayer(playerId, slot.getPosition());
                });

        return roster;
    }

    @Nested
    @DisplayName("Roster Lock Status Tests")
    class RosterLockStatusTests {

        @Test
        @DisplayName("New roster should have UNLOCKED status")
        void newRosterShouldBeUnlocked() {
            Roster roster = new Roster(leaguePlayerId, gameId, config);

            assertThat(roster.isLocked()).isFalse();
            assertThat(roster.getLockStatus()).isEqualTo(RosterLockStatus.UNLOCKED);
            assertThat(roster.getLockedAt()).isNull();
        }

        @Test
        @DisplayName("Should lock complete roster with LOCKED status")
        void shouldLockCompleteRoster() {
            Roster roster = createCompleteRoster();
            LocalDateTime lockTime = LocalDateTime.of(2024, 9, 5, 20, 0);

            roster.lockRoster(lockTime);

            assertThat(roster.isLocked()).isTrue();
            assertThat(roster.getLockStatus()).isEqualTo(RosterLockStatus.LOCKED);
            assertThat(roster.getLockedAt()).isEqualTo(lockTime);
        }

        @Test
        @DisplayName("Should throw exception when locking incomplete roster with lockRoster")
        void shouldThrowExceptionWhenLockingIncompleteRoster() {
            Roster roster = createIncompleteRoster();
            LocalDateTime lockTime = LocalDateTime.of(2024, 9, 5, 20, 0);

            assertThatThrownBy(() -> roster.lockRoster(lockTime))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("Cannot lock incomplete roster");
        }

        @Test
        @DisplayName("Should lock incomplete roster with LOCKED_INCOMPLETE status using lockRosterIncomplete")
        void shouldLockIncompleteRosterWithLockRosterIncomplete() {
            Roster roster = createIncompleteRoster();
            LocalDateTime lockTime = LocalDateTime.of(2024, 9, 5, 20, 0);

            roster.lockRosterIncomplete(lockTime);

            assertThat(roster.isLocked()).isTrue();
            assertThat(roster.getLockStatus()).isEqualTo(RosterLockStatus.LOCKED_INCOMPLETE);
            assertThat(roster.getLockedAt()).isEqualTo(lockTime);
        }

        @Test
        @DisplayName("Should lock at deadline with appropriate status based on completeness")
        void shouldLockAtDeadlineWithAppropriateStatus() {
            // Complete roster
            Roster completeRoster = createCompleteRoster();
            LocalDateTime lockTime = LocalDateTime.of(2024, 9, 5, 20, 0);

            RosterLockStatus completeStatus = completeRoster.lockAtDeadline(lockTime);
            assertThat(completeStatus).isEqualTo(RosterLockStatus.LOCKED);
            assertThat(completeRoster.getLockStatus()).isEqualTo(RosterLockStatus.LOCKED);

            // Incomplete roster
            Roster incompleteRoster = createIncompleteRoster();

            RosterLockStatus incompleteStatus = incompleteRoster.lockAtDeadline(lockTime);
            assertThat(incompleteStatus).isEqualTo(RosterLockStatus.LOCKED_INCOMPLETE);
            assertThat(incompleteRoster.getLockStatus()).isEqualTo(RosterLockStatus.LOCKED_INCOMPLETE);
        }

        @Test
        @DisplayName("Should unlock roster and reset status to UNLOCKED")
        void shouldUnlockRoster() {
            Roster roster = createCompleteRoster();
            roster.lockRoster(LocalDateTime.now());

            roster.unlockRoster();

            assertThat(roster.isLocked()).isFalse();
            assertThat(roster.getLockStatus()).isEqualTo(RosterLockStatus.UNLOCKED);
            assertThat(roster.getLockedAt()).isNull();
        }
    }

    @Nested
    @DisplayName("Locked Roster Modification Tests")
    class LockedRosterModificationTests {

        @Test
        @DisplayName("Should prevent player assignment on locked roster")
        void shouldPreventPlayerAssignmentOnLockedRoster() {
            Roster roster = createCompleteRoster();
            roster.lockRoster(LocalDateTime.now());

            UUID slotId = roster.getSlots().get(0).getId();

            assertThatThrownBy(() -> roster.assignPlayerToSlot(slotId, 999L, Position.QB))
                    .isInstanceOf(Roster.RosterLockedException.class)
                    .hasMessageContaining("locked for the season");
        }

        @Test
        @DisplayName("Should prevent player removal on locked roster")
        void shouldPreventPlayerRemovalOnLockedRoster() {
            Roster roster = createCompleteRoster();
            roster.lockRoster(LocalDateTime.now());

            UUID slotId = roster.getSlots().get(0).getId();

            assertThatThrownBy(() -> roster.removePlayerFromSlot(slotId))
                    .isInstanceOf(Roster.RosterLockedException.class)
                    .hasMessageContaining("locked for the season");
        }

        @Test
        @DisplayName("Should prevent drop and add on locked roster")
        void shouldPreventDropAndAddOnLockedRoster() {
            Roster roster = createCompleteRoster();
            RosterSlot slot = roster.getSlots().get(0);
            Long currentPlayerId = slot.getNflPlayerId();

            roster.lockRoster(LocalDateTime.now());

            assertThatThrownBy(() -> roster.dropAndAddPlayer(slot.getId(), currentPlayerId, 999L, slot.getPosition()))
                    .isInstanceOf(Roster.RosterLockedException.class)
                    .hasMessageContaining("locked for the season");
        }

        @Test
        @DisplayName("Should allow modifications on unlocked roster")
        void shouldAllowModificationsOnUnlockedRoster() {
            Roster roster = new Roster(leaguePlayerId, gameId, config);
            UUID slotId = roster.getSlots().get(0).getId();
            Position slotPosition = roster.getSlots().get(0).getPosition();

            // Should not throw
            assertThatCode(() -> roster.assignPlayerToSlot(slotId, 123L, slotPosition))
                    .doesNotThrowAnyException();
        }
    }

    @Nested
    @DisplayName("Roster Completeness Tests")
    class RosterCompletenessTests {

        @Test
        @DisplayName("Should return correct missing positions for incomplete roster")
        void shouldReturnMissingPositions() {
            Roster roster = createIncompleteRoster();

            assertThat(roster.isComplete()).isFalse();
            assertThat(roster.getMissingPositions())
                    .contains(Position.QB, Position.K);
        }

        @Test
        @DisplayName("Should return empty missing positions for complete roster")
        void shouldReturnEmptyMissingPositionsForCompleteRoster() {
            Roster roster = createCompleteRoster();

            assertThat(roster.isComplete()).isTrue();
            assertThat(roster.getMissingPositions()).isEmpty();
        }

        @Test
        @DisplayName("Should return correct filled slot count")
        void shouldReturnCorrectFilledSlotCount() {
            Roster roster = createIncompleteRoster();

            // Standard config has 9 slots, we left 2 empty (QB and K)
            assertThat(roster.getFilledSlotCount()).isEqualTo(7);
            assertThat(roster.getTotalSlotCount()).isEqualTo(9);
        }
    }

    @Nested
    @DisplayName("RosterLockStatus Enum Tests")
    class RosterLockStatusEnumTests {

        @Test
        @DisplayName("UNLOCKED status should not be locked and can modify")
        void unlockedStatusBehavior() {
            RosterLockStatus status = RosterLockStatus.UNLOCKED;

            assertThat(status.isLocked()).isFalse();
            assertThat(status.canModify()).isTrue();
        }

        @Test
        @DisplayName("LOCKED status should be locked and cannot modify")
        void lockedStatusBehavior() {
            RosterLockStatus status = RosterLockStatus.LOCKED;

            assertThat(status.isLocked()).isTrue();
            assertThat(status.canModify()).isFalse();
        }

        @Test
        @DisplayName("LOCKED_INCOMPLETE status should be locked and cannot modify")
        void lockedIncompleteStatusBehavior() {
            RosterLockStatus status = RosterLockStatus.LOCKED_INCOMPLETE;

            assertThat(status.isLocked()).isTrue();
            assertThat(status.canModify()).isFalse();
        }

        @Test
        @DisplayName("Status display messages should be descriptive")
        void statusDisplayMessages() {
            assertThat(RosterLockStatus.UNLOCKED.getDisplayMessage())
                    .contains("open");
            assertThat(RosterLockStatus.LOCKED.getDisplayMessage())
                    .contains("locked");
            assertThat(RosterLockStatus.LOCKED_INCOMPLETE.getDisplayMessage())
                    .contains("missing");
        }
    }
}
