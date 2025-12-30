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
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ValidateRosterUseCase Tests")
class ValidateRosterUseCaseTest {

    @Mock
    private RosterRepository rosterRepository;

    private ValidateRosterUseCase useCase;

    private UUID rosterId;

    @BeforeEach
    void setUp() {
        useCase = new ValidateRosterUseCase(rosterRepository);
        rosterId = UUID.randomUUID();
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should validate complete roster successfully")
        void shouldValidateCompleteRoster() {
            // Arrange
            Roster completeRoster = createCompleteRoster();
            ValidateRosterUseCase.ValidateRosterCommand command =
                    new ValidateRosterUseCase.ValidateRosterCommand(rosterId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(completeRoster));

            // Act
            ValidateRosterUseCase.ValidationResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertTrue(result.isComplete());
            assertTrue(result.getMissingPositions().isEmpty());
            assertEquals(rosterId, result.getRosterId());
        }

        @Test
        @DisplayName("should validate incomplete roster")
        void shouldValidateIncompleteRoster() {
            // Arrange
            Roster incompleteRoster = createIncompleteRoster();
            ValidateRosterUseCase.ValidateRosterCommand command =
                    new ValidateRosterUseCase.ValidateRosterCommand(rosterId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(incompleteRoster));

            // Act
            ValidateRosterUseCase.ValidationResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertFalse(result.isComplete());
            assertFalse(result.getMissingPositions().isEmpty());
        }

        @Test
        @DisplayName("should throw exception when roster not found")
        void shouldThrowExceptionWhenRosterNotFound() {
            // Arrange
            UUID unknownRosterId = UUID.randomUUID();
            ValidateRosterUseCase.ValidateRosterCommand command =
                    new ValidateRosterUseCase.ValidateRosterCommand(unknownRosterId);

            when(rosterRepository.findById(unknownRosterId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Roster not found"));
        }

        @Test
        @DisplayName("should return missing positions")
        void shouldReturnMissingPositions() {
            // Arrange
            Roster incompleteRoster = createIncompleteRoster();
            ValidateRosterUseCase.ValidateRosterCommand command =
                    new ValidateRosterUseCase.ValidateRosterCommand(rosterId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(incompleteRoster));

            // Act
            ValidateRosterUseCase.ValidationResult result = useCase.execute(command);

            // Assert
            assertNotNull(result.getMissingPositions());
            assertTrue(result.getMissingPositions().contains(Position.RB));
        }

        @Test
        @DisplayName("should return locked status")
        void shouldReturnLockedStatus() {
            // Arrange
            Roster lockedRoster = createCompleteRoster();
            lockedRoster.setLocked(true);

            ValidateRosterUseCase.ValidateRosterCommand command =
                    new ValidateRosterUseCase.ValidateRosterCommand(rosterId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(lockedRoster));

            // Act
            ValidateRosterUseCase.ValidationResult result = useCase.execute(command);

            // Assert
            assertTrue(result.isLocked());
        }

        @Test
        @DisplayName("should return roster deadline")
        void shouldReturnRosterDeadline() {
            // Arrange
            LocalDateTime deadline = LocalDateTime.of(2024, 1, 20, 13, 0);
            Roster roster = createCompleteRoster();
            roster.setRosterDeadline(deadline);

            ValidateRosterUseCase.ValidateRosterCommand command =
                    new ValidateRosterUseCase.ValidateRosterCommand(rosterId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));

            // Act
            ValidateRosterUseCase.ValidationResult result = useCase.execute(command);

            // Assert
            assertEquals(deadline, result.getRosterDeadline());
        }
    }

    @Nested
    @DisplayName("ValidationResult")
    class ValidationResultTests {

        @Test
        @DisplayName("canBeLocked returns true when complete and not locked")
        void canBeLockedReturnsTrueWhenCompleteAndNotLocked() {
            // Arrange
            ValidateRosterUseCase.ValidationResult result =
                    new ValidateRosterUseCase.ValidationResult(
                            rosterId, true, List.of(), false, null);

            // Act & Assert
            assertTrue(result.canBeLocked());
        }

        @Test
        @DisplayName("canBeLocked returns false when incomplete")
        void canBeLockedReturnsFalseWhenIncomplete() {
            // Arrange
            ValidateRosterUseCase.ValidationResult result =
                    new ValidateRosterUseCase.ValidationResult(
                            rosterId, false, List.of(Position.QB), false, null);

            // Act & Assert
            assertFalse(result.canBeLocked());
        }

        @Test
        @DisplayName("canBeLocked returns false when already locked")
        void canBeLockedReturnsFalseWhenAlreadyLocked() {
            // Arrange
            ValidateRosterUseCase.ValidationResult result =
                    new ValidateRosterUseCase.ValidationResult(
                            rosterId, true, List.of(), true, null);

            // Act & Assert
            assertFalse(result.canBeLocked());
        }

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            LocalDateTime deadline = LocalDateTime.now();
            List<Position> missingPositions = List.of(Position.QB, Position.RB);

            // Act
            ValidateRosterUseCase.ValidationResult result =
                    new ValidateRosterUseCase.ValidationResult(
                            rosterId, false, missingPositions, true, deadline);

            // Assert
            assertEquals(rosterId, result.getRosterId());
            assertFalse(result.isComplete());
            assertEquals(missingPositions, result.getMissingPositions());
            assertTrue(result.isLocked());
            assertEquals(deadline, result.getRosterDeadline());
        }
    }

    @Nested
    @DisplayName("ValidateRosterCommand")
    class ValidateRosterCommandTests {

        @Test
        @DisplayName("should create command with roster ID")
        void shouldCreateCommandWithRosterId() {
            // Arrange & Act
            ValidateRosterUseCase.ValidateRosterCommand command =
                    new ValidateRosterUseCase.ValidateRosterCommand(rosterId);

            // Assert
            assertEquals(rosterId, command.getRosterId());
        }
    }

    // Helper methods
    private Roster createCompleteRoster() {
        Roster roster = new Roster();
        roster.setId(rosterId);
        roster.setLocked(false);

        List<RosterSlot> slots = new ArrayList<>();
        RosterSlot slot1 = new RosterSlot(rosterId, Position.QB, 1);
        slot1.setId(UUID.randomUUID());
        slot1.setNflPlayerId(12345L);

        RosterSlot slot2 = new RosterSlot(rosterId, Position.RB, 1);
        slot2.setId(UUID.randomUUID());
        slot2.setNflPlayerId(12346L);

        slots.add(slot1);
        slots.add(slot2);
        roster.setSlots(slots);

        return roster;
    }

    private Roster createIncompleteRoster() {
        Roster roster = new Roster();
        roster.setId(rosterId);
        roster.setLocked(false);

        List<RosterSlot> slots = new ArrayList<>();
        RosterSlot filledSlot = new RosterSlot(rosterId, Position.QB, 1);
        filledSlot.setId(UUID.randomUUID());
        filledSlot.setNflPlayerId(12345L);

        RosterSlot emptySlot = new RosterSlot(rosterId, Position.RB, 1);
        emptySlot.setId(UUID.randomUUID());
        // Not setting nflPlayerId - slot is empty

        slots.add(filledSlot);
        slots.add(emptySlot);
        roster.setSlots(slots);

        return roster;
    }
}
