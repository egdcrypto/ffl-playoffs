package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.NFLPlayer;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterSlot;
import com.ffl.playoffs.domain.port.NFLPlayerRepository;
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

import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("AddNFLPlayerToSlotUseCase Tests")
class AddNFLPlayerToSlotUseCaseTest {

    @Mock
    private RosterRepository rosterRepository;

    @Mock
    private NFLPlayerRepository nflPlayerRepository;

    private AddNFLPlayerToSlotUseCase useCase;

    @Captor
    private ArgumentCaptor<Roster> rosterCaptor;

    private UUID rosterId;
    private UUID slotId;
    private Long nflPlayerId;
    private Roster roster;
    private RosterSlot slot;
    private NFLPlayer activePlayer;

    @BeforeEach
    void setUp() {
        useCase = new AddNFLPlayerToSlotUseCase(rosterRepository, nflPlayerRepository);

        rosterId = UUID.randomUUID();
        slotId = UUID.randomUUID();
        nflPlayerId = 12345L;

        // Create roster with an empty slot
        roster = new Roster();
        roster.setId(rosterId);

        slot = new RosterSlot(rosterId, Position.QB, 1);
        slot.setId(slotId);

        java.util.List<RosterSlot> slots = new java.util.ArrayList<>();
        slots.add(slot);
        roster.setSlots(slots);

        // Create active NFL player
        activePlayer = new NFLPlayer("Test Player", Position.QB, "NYG");
        activePlayer.setId(nflPlayerId);
        activePlayer.setStatus("ACTIVE");
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should add NFL player to slot successfully")
        void shouldAddPlayerToSlotSuccessfully() {
            // Arrange
            AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand command =
                    new AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand(
                            rosterId, slotId, nflPlayerId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(nflPlayerId)).thenReturn(Optional.of(activePlayer));
            when(rosterRepository.save(any(Roster.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            Roster result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            verify(rosterRepository).save(rosterCaptor.capture());
            Roster savedRoster = rosterCaptor.getValue();
            RosterSlot updatedSlot = savedRoster.getSlots().stream()
                    .filter(s -> s.getId().equals(slotId))
                    .findFirst()
                    .orElse(null);
            assertNotNull(updatedSlot);
            assertEquals(nflPlayerId, updatedSlot.getNflPlayerId());
        }

        @Test
        @DisplayName("should throw exception when roster not found")
        void shouldThrowExceptionWhenRosterNotFound() {
            // Arrange
            UUID unknownRosterId = UUID.randomUUID();
            AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand command =
                    new AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand(
                            unknownRosterId, slotId, nflPlayerId);

            when(rosterRepository.findById(unknownRosterId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Roster not found"));
            verify(nflPlayerRepository, never()).findById(any());
            verify(rosterRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when NFL player not found")
        void shouldThrowExceptionWhenNflPlayerNotFound() {
            // Arrange
            Long unknownPlayerId = 99999L;
            AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand command =
                    new AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand(
                            rosterId, slotId, unknownPlayerId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(unknownPlayerId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("NFL player not found"));
            verify(rosterRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when player is not active")
        void shouldThrowExceptionWhenPlayerNotActive() {
            // Arrange
            NFLPlayer inactivePlayer = new NFLPlayer("Injured Player", Position.QB, "NYG");
            inactivePlayer.setId(nflPlayerId);
            inactivePlayer.setStatus("INJURED");

            AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand command =
                    new AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand(
                            rosterId, slotId, nflPlayerId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(nflPlayerId)).thenReturn(Optional.of(inactivePlayer));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("not active"));
            verify(rosterRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when roster is locked")
        void shouldThrowExceptionWhenRosterIsLocked() {
            // Arrange
            Roster lockedRoster = new Roster();
            lockedRoster.setId(rosterId);
            lockedRoster.setLocked(true);

            java.util.List<RosterSlot> slots = new java.util.ArrayList<>();
            slots.add(slot);
            lockedRoster.setSlots(slots);

            AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand command =
                    new AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand(
                            rosterId, slotId, nflPlayerId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(lockedRoster));
            when(nflPlayerRepository.findById(nflPlayerId)).thenReturn(Optional.of(activePlayer));

            // Act & Assert
            Roster.RosterLockedException exception = assertThrows(
                    Roster.RosterLockedException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("locked"));
            verify(rosterRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when player is already on roster")
        void shouldThrowExceptionWhenPlayerAlreadyOnRoster() {
            // Arrange
            // Create roster with player already in a slot
            Roster rosterWithExistingPlayer = new Roster();
            rosterWithExistingPlayer.setId(rosterId);

            // Add empty target slot
            RosterSlot targetSlot = new RosterSlot(rosterId, Position.QB, 1);
            targetSlot.setId(slotId);

            // Add another slot with the same player already assigned
            RosterSlot existingSlot = new RosterSlot(rosterId, Position.QB, 2);
            existingSlot.setId(UUID.randomUUID());
            existingSlot.setNflPlayerId(nflPlayerId);

            java.util.List<RosterSlot> slots = new java.util.ArrayList<>();
            slots.add(targetSlot);
            slots.add(existingSlot);
            rosterWithExistingPlayer.setSlots(slots);

            AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand command =
                    new AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand(
                            rosterId, slotId, nflPlayerId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(rosterWithExistingPlayer));
            when(nflPlayerRepository.findById(nflPlayerId)).thenReturn(Optional.of(activePlayer));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("already on"));
            verify(rosterRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when slot not found")
        void shouldThrowExceptionWhenSlotNotFound() {
            // Arrange
            UUID unknownSlotId = UUID.randomUUID();
            AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand command =
                    new AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand(
                            rosterId, unknownSlotId, nflPlayerId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(nflPlayerId)).thenReturn(Optional.of(activePlayer));

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("slot not found"));
            verify(rosterRepository, never()).save(any());
        }

        @Test
        @DisplayName("should save roster after adding player")
        void shouldSaveRosterAfterAddingPlayer() {
            // Arrange
            AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand command =
                    new AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand(
                            rosterId, slotId, nflPlayerId);

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(nflPlayerId)).thenReturn(Optional.of(activePlayer));
            when(rosterRepository.save(any(Roster.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(rosterRepository, times(1)).save(any(Roster.class));
        }
    }

    @Nested
    @DisplayName("AddNFLPlayerToSlotCommand")
    class CommandTests {

        @Test
        @DisplayName("should create command with all fields")
        void shouldCreateCommandWithAllFields() {
            // Arrange & Act
            AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand command =
                    new AddNFLPlayerToSlotUseCase.AddNFLPlayerToSlotCommand(
                            rosterId, slotId, nflPlayerId);

            // Assert
            assertEquals(rosterId, command.getRosterId());
            assertEquals(slotId, command.getSlotId());
            assertEquals(nflPlayerId, command.getNflPlayerId());
        }
    }
}
