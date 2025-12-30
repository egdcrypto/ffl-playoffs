package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterSlot;
import com.ffl.playoffs.domain.port.RosterRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("LockRosterUseCase Tests")
class LockRosterUseCaseTest {

    @Mock
    private RosterRepository rosterRepository;

    private LockRosterUseCase useCase;

    @Captor
    private ArgumentCaptor<Roster> rosterCaptor;

    private UUID rosterId;
    private Roster completeRoster;

    @BeforeEach
    void setUp() {
        useCase = new LockRosterUseCase(rosterRepository);

        rosterId = UUID.randomUUID();

        // Create complete roster with filled slots
        completeRoster = new Roster();
        completeRoster.setId(rosterId);
        completeRoster.setLocked(false);

        List<RosterSlot> slots = new ArrayList<>();
        RosterSlot slot1 = new RosterSlot(rosterId, Position.QB, 1);
        slot1.setId(UUID.randomUUID());
        slot1.setNflPlayerId(12345L);

        RosterSlot slot2 = new RosterSlot(rosterId, Position.RB, 1);
        slot2.setId(UUID.randomUUID());
        slot2.setNflPlayerId(12346L);

        slots.add(slot1);
        slots.add(slot2);
        completeRoster.setSlots(slots);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should lock roster successfully")
        void shouldLockRosterSuccessfully() {
            // Arrange
            LockRosterUseCase.LockRosterCommand command =
                    new LockRosterUseCase.LockRosterCommand(rosterId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(completeRoster));
            when(rosterRepository.save(any(Roster.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            LockRosterUseCase.LockRosterResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertTrue(result.isLocked());
            assertEquals(rosterId, result.getRosterId());
            assertNotNull(result.getLockedAt());
        }

        @Test
        @DisplayName("should throw exception when roster not found")
        void shouldThrowExceptionWhenRosterNotFound() {
            // Arrange
            UUID unknownRosterId = UUID.randomUUID();
            LockRosterUseCase.LockRosterCommand command =
                    new LockRosterUseCase.LockRosterCommand(unknownRosterId);

            when(rosterRepository.findById(unknownRosterId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Roster not found"));
            verify(rosterRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when roster already locked")
        void shouldThrowExceptionWhenAlreadyLocked() {
            // Arrange
            Roster lockedRoster = new Roster();
            lockedRoster.setId(rosterId);
            lockedRoster.setLocked(true);

            LockRosterUseCase.LockRosterCommand command =
                    new LockRosterUseCase.LockRosterCommand(rosterId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(lockedRoster));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("already locked"));
            verify(rosterRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when roster incomplete")
        void shouldThrowExceptionWhenIncomplete() {
            // Arrange
            Roster incompleteRoster = new Roster();
            incompleteRoster.setId(rosterId);
            incompleteRoster.setLocked(false);

            List<RosterSlot> slots = new ArrayList<>();
            RosterSlot emptySlot = new RosterSlot(rosterId, Position.QB, 1);
            emptySlot.setId(UUID.randomUUID());
            // Not setting nflPlayerId - slot is empty
            slots.add(emptySlot);
            incompleteRoster.setSlots(slots);

            LockRosterUseCase.LockRosterCommand command =
                    new LockRosterUseCase.LockRosterCommand(rosterId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(incompleteRoster));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("incomplete"));
            verify(rosterRepository, never()).save(any());
        }

        @Test
        @DisplayName("should use provided lock time")
        void shouldUseProvidedLockTime() {
            // Arrange
            LocalDateTime customLockTime = LocalDateTime.of(2024, 1, 15, 14, 30);
            LockRosterUseCase.LockRosterCommand command =
                    new LockRosterUseCase.LockRosterCommand(rosterId, customLockTime);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(completeRoster));
            when(rosterRepository.save(any(Roster.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            LockRosterUseCase.LockRosterResult result = useCase.execute(command);

            // Assert
            assertEquals(customLockTime, result.getLockedAt());
        }

        @Test
        @DisplayName("should use current time when lock time not provided")
        void shouldUseCurrentTimeWhenNotProvided() {
            // Arrange
            LockRosterUseCase.LockRosterCommand command =
                    new LockRosterUseCase.LockRosterCommand(rosterId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(completeRoster));
            when(rosterRepository.save(any(Roster.class))).thenAnswer(inv -> inv.getArgument(0));

            LocalDateTime beforeExecution = LocalDateTime.now();

            // Act
            LockRosterUseCase.LockRosterResult result = useCase.execute(command);

            LocalDateTime afterExecution = LocalDateTime.now();

            // Assert
            assertNotNull(result.getLockedAt());
            assertTrue(result.getLockedAt().isAfter(beforeExecution.minusSeconds(1)));
            assertTrue(result.getLockedAt().isBefore(afterExecution.plusSeconds(1)));
        }

        @Test
        @DisplayName("should save roster to repository")
        void shouldSaveRosterToRepository() {
            // Arrange
            LockRosterUseCase.LockRosterCommand command =
                    new LockRosterUseCase.LockRosterCommand(rosterId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(completeRoster));
            when(rosterRepository.save(any(Roster.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(rosterRepository, times(1)).save(rosterCaptor.capture());
            Roster savedRoster = rosterCaptor.getValue();
            assertTrue(savedRoster.isLocked());
        }
    }

    @Nested
    @DisplayName("LockRosterCommand")
    class LockRosterCommandTests {

        @Test
        @DisplayName("should create command with roster ID only")
        void shouldCreateCommandWithRosterIdOnly() {
            // Arrange & Act
            LockRosterUseCase.LockRosterCommand command =
                    new LockRosterUseCase.LockRosterCommand(rosterId);

            // Assert
            assertEquals(rosterId, command.getRosterId());
            assertNull(command.getLockTime());
        }

        @Test
        @DisplayName("should create command with roster ID and lock time")
        void shouldCreateCommandWithRosterIdAndLockTime() {
            // Arrange
            LocalDateTime lockTime = LocalDateTime.now();

            // Act
            LockRosterUseCase.LockRosterCommand command =
                    new LockRosterUseCase.LockRosterCommand(rosterId, lockTime);

            // Assert
            assertEquals(rosterId, command.getRosterId());
            assertEquals(lockTime, command.getLockTime());
        }
    }

    @Nested
    @DisplayName("LockRosterResult")
    class LockRosterResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            LocalDateTime lockedAt = LocalDateTime.now();

            // Act
            LockRosterUseCase.LockRosterResult result =
                    new LockRosterUseCase.LockRosterResult(rosterId, true, lockedAt);

            // Assert
            assertEquals(rosterId, result.getRosterId());
            assertTrue(result.isLocked());
            assertEquals(lockedAt, result.getLockedAt());
        }
    }
}
