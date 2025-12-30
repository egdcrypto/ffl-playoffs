package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.exception.RosterOperationException;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.model.RosterSlot;
import com.ffl.playoffs.domain.model.RosterStatus;
import com.ffl.playoffs.domain.port.RosterRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("LockRosterUseCase")
class LockRosterUseCaseTest {

    @Mock
    private RosterRepository rosterRepository;

    private LockRosterUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new LockRosterUseCase(rosterRepository);
    }

    private Roster createCompleteRoster() {
        Roster roster = new Roster();
        roster.setId(UUID.randomUUID());
        roster.setLeaguePlayerId(UUID.randomUUID());
        roster.setGameId(UUID.randomUUID());
        roster.setStatus(RosterStatus.UNLOCKED);

        // Create filled slots
        List<RosterSlot> slots = new ArrayList<>();
        slots.add(createFilledSlot(Position.QB, 1L));
        slots.add(createFilledSlot(Position.RB, 2L));
        slots.add(createFilledSlot(Position.RB, 3L));
        slots.add(createFilledSlot(Position.WR, 4L));
        slots.add(createFilledSlot(Position.WR, 5L));
        slots.add(createFilledSlot(Position.TE, 6L));
        slots.add(createFilledSlot(Position.FLEX, 7L));
        slots.add(createFilledSlot(Position.K, 8L));
        slots.add(createFilledSlot(Position.DEF, 9L));
        roster.setSlots(slots);

        return roster;
    }

    private Roster createIncompleteRoster() {
        Roster roster = new Roster();
        roster.setId(UUID.randomUUID());
        roster.setLeaguePlayerId(UUID.randomUUID());
        roster.setGameId(UUID.randomUUID());
        roster.setStatus(RosterStatus.UNLOCKED);

        // Create partially filled slots
        List<RosterSlot> slots = new ArrayList<>();
        slots.add(createFilledSlot(Position.QB, 1L));
        slots.add(createFilledSlot(Position.RB, 2L));
        slots.add(createEmptySlot(Position.RB));  // Empty
        slots.add(createFilledSlot(Position.WR, 4L));
        slots.add(createEmptySlot(Position.WR));  // Empty
        slots.add(createFilledSlot(Position.TE, 6L));
        slots.add(createEmptySlot(Position.FLEX));  // Empty
        slots.add(createFilledSlot(Position.K, 8L));
        slots.add(createFilledSlot(Position.DEF, 9L));
        roster.setSlots(slots);

        return roster;
    }

    private RosterSlot createFilledSlot(Position position, Long playerId) {
        RosterSlot slot = new RosterSlot(UUID.randomUUID(), position, 1);
        slot.assignPlayer(playerId, position);
        return slot;
    }

    private RosterSlot createEmptySlot(Position position) {
        return new RosterSlot(UUID.randomUUID(), position, 1);
    }

    @Nested
    @DisplayName("Successful Lock Operations")
    class SuccessfulLocks {

        @Test
        @DisplayName("Should lock complete roster with LOCKED status")
        void shouldLockCompleteRoster() {
            // Given
            Roster roster = createCompleteRoster();
            UUID rosterId = roster.getId();

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(rosterRepository.save(any(Roster.class))).thenAnswer(i -> i.getArgument(0));

            // When
            LockRosterUseCase.LockRosterCommand command = new LockRosterUseCase.LockRosterCommand(rosterId);
            LockRosterUseCase.LockRosterResult result = useCase.execute(command);

            // Then
            assertTrue(result.isLocked());
            assertEquals(RosterStatus.LOCKED, result.getStatus());
            assertTrue(result.isComplete());
            assertNull(result.getWarningMessage());
            verify(rosterRepository).save(any(Roster.class));
        }

        @Test
        @DisplayName("Should lock incomplete roster with LOCKED_INCOMPLETE status when allowed")
        void shouldLockIncompleteRosterWhenAllowed() {
            // Given
            Roster roster = createIncompleteRoster();
            UUID rosterId = roster.getId();

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(rosterRepository.save(any(Roster.class))).thenAnswer(i -> i.getArgument(0));

            // When
            LockRosterUseCase.LockRosterCommand command = LockRosterUseCase.LockRosterCommand.builder()
                    .rosterId(rosterId)
                    .allowIncomplete(true)
                    .build();
            LockRosterUseCase.LockRosterResult result = useCase.execute(command);

            // Then
            assertTrue(result.isLocked());
            assertEquals(RosterStatus.LOCKED_INCOMPLETE, result.getStatus());
            assertFalse(result.isComplete());
            assertNotNull(result.getWarningMessage());
            assertTrue(result.getWarningMessage().contains("incomplete"));
            assertFalse(result.getMissingPositions().isEmpty());
            verify(rosterRepository).save(any(Roster.class));
        }

        @Test
        @DisplayName("Should set correct lock time")
        void shouldSetCorrectLockTime() {
            // Given
            Roster roster = createCompleteRoster();
            UUID rosterId = roster.getId();
            LocalDateTime lockTime = LocalDateTime.of(2024, 9, 5, 20, 0, 0);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(rosterRepository.save(any(Roster.class))).thenAnswer(i -> i.getArgument(0));

            // When
            LockRosterUseCase.LockRosterCommand command = LockRosterUseCase.LockRosterCommand.builder()
                    .rosterId(rosterId)
                    .lockTime(lockTime)
                    .build();
            LockRosterUseCase.LockRosterResult result = useCase.execute(command);

            // Then
            assertEquals(lockTime, result.getLockedAt());
        }
    }

    @Nested
    @DisplayName("Lock Validation Failures")
    class LockValidationFailures {

        @Test
        @DisplayName("Should fail when roster not found")
        void shouldFailWhenRosterNotFound() {
            // Given
            UUID rosterId = UUID.randomUUID();
            when(rosterRepository.findById(rosterId)).thenReturn(Optional.empty());

            // When/Then
            LockRosterUseCase.LockRosterCommand command = new LockRosterUseCase.LockRosterCommand(rosterId);
            RosterOperationException exception = assertThrows(
                    RosterOperationException.class,
                    () -> useCase.execute(command)
            );

            assertEquals(RosterOperationException.ErrorCode.ROSTER_NOT_FOUND, exception.getErrorCode());
        }

        @Test
        @DisplayName("Should fail when roster is already locked")
        void shouldFailWhenAlreadyLocked() {
            // Given
            Roster roster = createCompleteRoster();
            roster.setLocked(true);
            roster.setLockedAt(LocalDateTime.now());
            roster.setStatus(RosterStatus.LOCKED);
            UUID rosterId = roster.getId();

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));

            // When/Then
            LockRosterUseCase.LockRosterCommand command = new LockRosterUseCase.LockRosterCommand(rosterId);
            RosterOperationException exception = assertThrows(
                    RosterOperationException.class,
                    () -> useCase.execute(command)
            );

            assertEquals(RosterOperationException.ErrorCode.ROSTER_ALREADY_LOCKED, exception.getErrorCode());
        }

        @Test
        @DisplayName("Should fail when locking incomplete roster without allowIncomplete flag")
        void shouldFailWhenIncompleteWithoutFlag() {
            // Given
            Roster roster = createIncompleteRoster();
            UUID rosterId = roster.getId();

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));

            // When/Then
            LockRosterUseCase.LockRosterCommand command = new LockRosterUseCase.LockRosterCommand(rosterId);
            RosterOperationException exception = assertThrows(
                    RosterOperationException.class,
                    () -> useCase.execute(command)
            );

            assertEquals(RosterOperationException.ErrorCode.ROSTER_INCOMPLETE, exception.getErrorCode());
            assertTrue(exception.getMessage().contains("incomplete"));
        }
    }

    @Nested
    @DisplayName("One-Time Draft Model Enforcement")
    class OneTimeDraftModelEnforcement {

        @Test
        @DisplayName("Locked roster should have LOCKED status")
        void lockedRosterShouldHaveLockedStatus() {
            // Given
            Roster roster = createCompleteRoster();
            UUID rosterId = roster.getId();

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(rosterRepository.save(any(Roster.class))).thenAnswer(i -> i.getArgument(0));

            // When
            LockRosterUseCase.LockRosterCommand command = new LockRosterUseCase.LockRosterCommand(rosterId);
            LockRosterUseCase.LockRosterResult result = useCase.execute(command);

            // Then
            assertTrue(result.getStatus().isLocked());
        }

        @Test
        @DisplayName("Incomplete locked roster should have LOCKED_INCOMPLETE status")
        void incompleteLockedRosterShouldHaveLockedIncompleteStatus() {
            // Given
            Roster roster = createIncompleteRoster();
            UUID rosterId = roster.getId();

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(rosterRepository.save(any(Roster.class))).thenAnswer(i -> i.getArgument(0));

            // When
            LockRosterUseCase.LockRosterCommand command = LockRosterUseCase.LockRosterCommand.builder()
                    .rosterId(rosterId)
                    .allowIncomplete(true)
                    .build();
            LockRosterUseCase.LockRosterResult result = useCase.execute(command);

            // Then
            assertEquals(RosterStatus.LOCKED_INCOMPLETE, result.getStatus());
            assertTrue(result.getStatus().isLocked());
            assertFalse(result.getStatus().isComplete());
        }
    }
}
