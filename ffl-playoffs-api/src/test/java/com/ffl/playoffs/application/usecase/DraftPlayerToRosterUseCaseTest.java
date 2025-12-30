package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.NFLPlayer;
import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.exception.RosterOperationException;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.model.RosterSlot;
import com.ffl.playoffs.domain.port.NFLPlayerRepository;
import com.ffl.playoffs.domain.port.RosterRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * Unit tests for DraftPlayerToRosterUseCase
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("DraftPlayerToRosterUseCase")
class DraftPlayerToRosterUseCaseTest {

    @Mock
    private RosterRepository rosterRepository;

    @Mock
    private NFLPlayerRepository nflPlayerRepository;

    private DraftPlayerToRosterUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new DraftPlayerToRosterUseCase(rosterRepository, nflPlayerRepository);
    }

    @Nested
    @DisplayName("execute - Successful drafts")
    class SuccessfulDrafts {

        @Test
        @DisplayName("should draft QB to QB slot")
        void shouldDraftQbToQbSlot() {
            // Given
            UUID rosterId = UUID.randomUUID();
            Roster roster = createRosterWithSlots();
            NFLPlayer player = createPlayer(101L, "Patrick Mahomes", Position.QB, "KC");

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(101L)).thenReturn(Optional.of(player));
            when(rosterRepository.save(any(Roster.class))).thenReturn(roster);

            DraftPlayerToRosterUseCase.DraftCommand command = DraftPlayerToRosterUseCase.DraftCommand.builder()
                    .rosterId(rosterId)
                    .nflPlayerId(101L)
                    .slotPosition(Position.QB)
                    .build();

            // When
            DraftPlayerToRosterUseCase.DraftResult result = useCase.execute(command);

            // Then
            assertThat(result.isSuccess()).isTrue();
            assertThat(result.getPlayerName()).isEqualTo("Patrick Mahomes");
            assertThat(result.getSlotPosition()).isEqualTo(Position.QB);
            assertThat(result.getRosterCompletion()).isEqualTo("1/10");
            verify(rosterRepository).save(any(Roster.class));
        }

        @Test
        @DisplayName("should draft RB to FLEX slot")
        void shouldDraftRbToFlexSlot() {
            // Given
            UUID rosterId = UUID.randomUUID();
            Roster roster = createRosterWithSlots();
            NFLPlayer player = createPlayer(103L, "Christian McCaffrey", Position.RB, "SF");

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(103L)).thenReturn(Optional.of(player));
            when(rosterRepository.save(any(Roster.class))).thenReturn(roster);

            DraftPlayerToRosterUseCase.DraftCommand command = DraftPlayerToRosterUseCase.DraftCommand.builder()
                    .rosterId(rosterId)
                    .nflPlayerId(103L)
                    .slotPosition(Position.FLEX)
                    .build();

            // When
            DraftPlayerToRosterUseCase.DraftResult result = useCase.execute(command);

            // Then
            assertThat(result.isSuccess()).isTrue();
            assertThat(result.getSlotPosition()).isEqualTo(Position.FLEX);
        }

        @Test
        @DisplayName("should draft QB to SUPERFLEX slot")
        void shouldDraftQbToSuperflexSlot() {
            // Given
            UUID rosterId = UUID.randomUUID();
            Roster roster = createRosterWithSlots();
            NFLPlayer player = createPlayer(102L, "Josh Allen", Position.QB, "BUF");

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(102L)).thenReturn(Optional.of(player));
            when(rosterRepository.save(any(Roster.class))).thenReturn(roster);

            DraftPlayerToRosterUseCase.DraftCommand command = DraftPlayerToRosterUseCase.DraftCommand.builder()
                    .rosterId(rosterId)
                    .nflPlayerId(102L)
                    .slotPosition(Position.SUPERFLEX)
                    .build();

            // When
            DraftPlayerToRosterUseCase.DraftResult result = useCase.execute(command);

            // Then
            assertThat(result.isSuccess()).isTrue();
            assertThat(result.getSlotPosition()).isEqualTo(Position.SUPERFLEX);
        }

        @Test
        @DisplayName("should show IR warning for injured reserve player")
        void shouldShowIrWarning() {
            // Given
            UUID rosterId = UUID.randomUUID();
            Roster roster = createRosterWithSlots();
            NFLPlayer player = createPlayer(201L, "Aaron Rodgers", Position.QB, "NYJ");
            player.setStatus("INJURED_RESERVE");

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(201L)).thenReturn(Optional.of(player));
            when(rosterRepository.save(any(Roster.class))).thenReturn(roster);

            DraftPlayerToRosterUseCase.DraftCommand command = DraftPlayerToRosterUseCase.DraftCommand.builder()
                    .rosterId(rosterId)
                    .nflPlayerId(201L)
                    .slotPosition(Position.QB)
                    .build();

            // When
            DraftPlayerToRosterUseCase.DraftResult result = useCase.execute(command);

            // Then
            assertThat(result.isSuccess()).isTrue();
            assertThat(result.hasWarning()).isTrue();
            assertThat(result.getWarningMessage()).contains("Injured Reserve");
        }
    }

    @Nested
    @DisplayName("execute - Position validation failures")
    class PositionValidationFailures {

        @Test
        @DisplayName("should fail when QB drafted to RB slot")
        void shouldFailWhenQbDraftedToRbSlot() {
            // Given
            UUID rosterId = UUID.randomUUID();
            Roster roster = createRosterWithSlots();
            NFLPlayer player = createPlayer(101L, "Patrick Mahomes", Position.QB, "KC");

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(101L)).thenReturn(Optional.of(player));

            DraftPlayerToRosterUseCase.DraftCommand command = DraftPlayerToRosterUseCase.DraftCommand.builder()
                    .rosterId(rosterId)
                    .nflPlayerId(101L)
                    .slotPosition(Position.RB)
                    .build();

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(RosterOperationException.class)
                    .hasFieldOrPropertyWithValue("errorCode", RosterOperationException.ErrorCode.POSITION_MISMATCH)
                    .hasMessageContaining("Patrick Mahomes");
        }

        @Test
        @DisplayName("should fail when QB drafted to FLEX slot")
        void shouldFailWhenQbDraftedToFlexSlot() {
            // Given
            UUID rosterId = UUID.randomUUID();
            Roster roster = createRosterWithSlots();
            NFLPlayer player = createPlayer(101L, "Patrick Mahomes", Position.QB, "KC");

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(101L)).thenReturn(Optional.of(player));

            DraftPlayerToRosterUseCase.DraftCommand command = DraftPlayerToRosterUseCase.DraftCommand.builder()
                    .rosterId(rosterId)
                    .nflPlayerId(101L)
                    .slotPosition(Position.FLEX)
                    .build();

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(RosterOperationException.class)
                    .hasFieldOrPropertyWithValue("errorCode", RosterOperationException.ErrorCode.POSITION_NOT_ELIGIBLE_FOR_FLEX)
                    .hasMessageContaining("RB, WR, TE");
        }

        @Test
        @DisplayName("should fail when K drafted to SUPERFLEX slot")
        void shouldFailWhenKDraftedToSuperflexSlot() {
            // Given
            UUID rosterId = UUID.randomUUID();
            Roster roster = createRosterWithSlots();
            NFLPlayer player = createPlayer(108L, "Justin Tucker", Position.K, "BAL");

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(108L)).thenReturn(Optional.of(player));

            DraftPlayerToRosterUseCase.DraftCommand command = DraftPlayerToRosterUseCase.DraftCommand.builder()
                    .rosterId(rosterId)
                    .nflPlayerId(108L)
                    .slotPosition(Position.SUPERFLEX)
                    .build();

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(RosterOperationException.class)
                    .hasFieldOrPropertyWithValue("errorCode", RosterOperationException.ErrorCode.POSITION_NOT_ELIGIBLE_FOR_SUPERFLEX);
        }
    }

    @Nested
    @DisplayName("execute - Player validation failures")
    class PlayerValidationFailures {

        @Test
        @DisplayName("should fail when player is already on roster")
        void shouldFailWhenPlayerAlreadyOnRoster() {
            // Given
            UUID rosterId = UUID.randomUUID();
            Roster roster = createRosterWithSlots();
            NFLPlayer player = createPlayer(101L, "Patrick Mahomes", Position.QB, "KC");

            // Fill the QB slot first
            roster.getSlots().stream()
                    .filter(s -> s.getPosition() == Position.QB)
                    .findFirst()
                    .ifPresent(s -> s.assignPlayer(101L, Position.QB));

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(101L)).thenReturn(Optional.of(player));

            DraftPlayerToRosterUseCase.DraftCommand command = DraftPlayerToRosterUseCase.DraftCommand.builder()
                    .rosterId(rosterId)
                    .nflPlayerId(101L)
                    .slotPosition(Position.SUPERFLEX)
                    .build();

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(RosterOperationException.class)
                    .hasFieldOrPropertyWithValue("errorCode", RosterOperationException.ErrorCode.PLAYER_ALREADY_DRAFTED)
                    .hasMessageContaining("already drafted");
        }

        @Test
        @DisplayName("should fail when player not found")
        void shouldFailWhenPlayerNotFound() {
            // Given
            UUID rosterId = UUID.randomUUID();
            Roster roster = createRosterWithSlots();

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(99999L)).thenReturn(Optional.empty());

            DraftPlayerToRosterUseCase.DraftCommand command = DraftPlayerToRosterUseCase.DraftCommand.builder()
                    .rosterId(rosterId)
                    .nflPlayerId(99999L)
                    .slotPosition(Position.QB)
                    .build();

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(RosterOperationException.class)
                    .hasFieldOrPropertyWithValue("errorCode", RosterOperationException.ErrorCode.PLAYER_NOT_FOUND)
                    .hasMessageContaining("99999");
        }

        @Test
        @DisplayName("should fail when player is retired")
        void shouldFailWhenPlayerRetired() {
            // Given
            UUID rosterId = UUID.randomUUID();
            Roster roster = createRosterWithSlots();
            NFLPlayer player = createPlayer(200L, "Andrew Luck", Position.QB, "IND");
            player.setStatus("RETIRED");

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(200L)).thenReturn(Optional.of(player));

            DraftPlayerToRosterUseCase.DraftCommand command = DraftPlayerToRosterUseCase.DraftCommand.builder()
                    .rosterId(rosterId)
                    .nflPlayerId(200L)
                    .slotPosition(Position.QB)
                    .build();

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(RosterOperationException.class)
                    .hasFieldOrPropertyWithValue("errorCode", RosterOperationException.ErrorCode.PLAYER_INACTIVE)
                    .hasMessageContaining("RETIRED");
        }
    }

    @Nested
    @DisplayName("execute - Roster state failures")
    class RosterStateFailures {

        @Test
        @DisplayName("should fail when roster is locked")
        void shouldFailWhenRosterLocked() {
            // Given
            UUID rosterId = UUID.randomUUID();
            Roster roster = createRosterWithSlots();
            roster.lockRoster(java.time.LocalDateTime.now());

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));

            DraftPlayerToRosterUseCase.DraftCommand command = DraftPlayerToRosterUseCase.DraftCommand.builder()
                    .rosterId(rosterId)
                    .nflPlayerId(101L)
                    .slotPosition(Position.QB)
                    .build();

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(RosterOperationException.class)
                    .hasFieldOrPropertyWithValue("errorCode", RosterOperationException.ErrorCode.ROSTER_PERMANENTLY_LOCKED);
        }

        @Test
        @DisplayName("should fail when roster not found")
        void shouldFailWhenRosterNotFound() {
            // Given
            UUID rosterId = UUID.randomUUID();
            when(rosterRepository.findById(rosterId)).thenReturn(Optional.empty());

            DraftPlayerToRosterUseCase.DraftCommand command = DraftPlayerToRosterUseCase.DraftCommand.builder()
                    .rosterId(rosterId)
                    .nflPlayerId(101L)
                    .slotPosition(Position.QB)
                    .build();

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(RosterOperationException.class)
                    .hasFieldOrPropertyWithValue("errorCode", RosterOperationException.ErrorCode.ROSTER_NOT_FOUND);
        }

        @Test
        @DisplayName("should fail when position slots are full")
        void shouldFailWhenPositionSlotsFull() {
            // Given
            UUID rosterId = UUID.randomUUID();
            Roster roster = createRosterWithSlots();
            NFLPlayer player1 = createPlayer(103L, "CMC", Position.RB, "SF");
            NFLPlayer player2 = createPlayer(104L, "Derrick Henry", Position.RB, "BAL");
            NFLPlayer player3 = createPlayer(105L, "Jahmyr Gibbs", Position.RB, "DET");

            // Fill both RB slots
            roster.getSlots().stream()
                    .filter(s -> s.getPosition() == Position.RB)
                    .limit(2)
                    .forEach(s -> s.assignPlayer(s.getSlotOrder() == 1 ? 103L : 104L, Position.RB));

            when(rosterRepository.findById(rosterId)).thenReturn(Optional.of(roster));
            when(nflPlayerRepository.findById(105L)).thenReturn(Optional.of(player3));

            DraftPlayerToRosterUseCase.DraftCommand command = DraftPlayerToRosterUseCase.DraftCommand.builder()
                    .rosterId(rosterId)
                    .nflPlayerId(105L)
                    .slotPosition(Position.RB)
                    .build();

            // When/Then
            assertThatThrownBy(() -> useCase.execute(command))
                    .isInstanceOf(RosterOperationException.class)
                    .hasFieldOrPropertyWithValue("errorCode", RosterOperationException.ErrorCode.POSITION_LIMIT_EXCEEDED)
                    .hasMessageContaining("full");
        }
    }

    // Helper methods

    private Roster createRosterWithSlots() {
        RosterConfiguration config = RosterConfiguration.superflexRoster();
        return new Roster(UUID.randomUUID(), UUID.randomUUID(), config);
    }

    private NFLPlayer createPlayer(Long id, String name, Position position, String team) {
        NFLPlayer player = new NFLPlayer(name, position, team);
        player.setId(id);
        player.setStatus("ACTIVE");
        player.setNflTeamAbbreviation(team);
        return player;
    }
}
