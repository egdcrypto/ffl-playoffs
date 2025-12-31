package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.LeagueStatus;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.model.ScoringRules;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.LeagueRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("LeagueLifecycleUseCase Tests")
class LeagueLifecycleUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    @Mock
    private LeaguePlayerRepository leaguePlayerRepository;

    private LeagueLifecycleUseCase useCase;

    private UUID leagueId;
    private UUID adminUserId;

    @BeforeEach
    void setUp() {
        useCase = new LeagueLifecycleUseCase(leagueRepository, leaguePlayerRepository);
        leagueId = UUID.randomUUID();
        adminUserId = UUID.randomUUID();
    }

    private League createLeagueInStatus(LeagueStatus status) {
        League league = new League();
        league.setId(leagueId);
        league.setName("Test League");
        league.setOwnerId(adminUserId);
        league.setStatus(status);
        league.setMinPlayers(2);
        return league;
    }

    private League createReadyToActivateLeague() {
        League league = createLeagueInStatus(LeagueStatus.DRAFT);
        league.setRosterConfiguration(RosterConfiguration.standardRoster());
        league.setScoringRules(ScoringRules.standardRules());
        league.setStartingWeekAndDuration(15, 3);
        // Add minimum players
        Player player1 = Player.builder().id(1L).email("p1@test.com").displayName("Player 1").build();
        Player player2 = Player.builder().id(2L).email("p2@test.com").displayName("Player 2").build();
        league.getPlayers().add(player1);
        league.getPlayers().add(player2);
        return league;
    }

    @Nested
    @DisplayName("activate")
    class Activate {

        @Test
        @DisplayName("should activate league successfully")
        void shouldActivateLeagueSuccessfully() {
            // Arrange
            League readyLeague = createReadyToActivateLeague();
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(leagueId, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(readyLeague));
            when(leaguePlayerRepository.countActivePlayersByLeagueId(leagueId)).thenReturn(2L);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.activate(command);

            // Assert
            assertEquals(LeagueStatus.ACTIVE, result.getStatus());
            verify(leagueRepository).save(any(League.class));
        }

        @Test
        @DisplayName("should throw exception when league not found")
        void shouldThrowExceptionWhenLeagueNotFound() {
            // Arrange
            UUID unknownId = UUID.randomUUID();
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(unknownId, adminUserId);

            when(leagueRepository.findById(unknownId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.activate(command)
            );

            assertTrue(exception.getMessage().contains("League not found"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when admin does not own the league")
        void shouldThrowExceptionWhenAdminDoesNotOwnLeague() {
            // Arrange
            UUID differentAdmin = UUID.randomUUID();
            League league = createReadyToActivateLeague();
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(leagueId, differentAdmin);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act & Assert
            LeagueLifecycleUseCase.UnauthorizedLeagueAccessException exception = assertThrows(
                    LeagueLifecycleUseCase.UnauthorizedLeagueAccessException.class,
                    () -> useCase.activate(command)
            );

            assertTrue(exception.getMessage().contains("does not own this league"));
            assertEquals("UNAUTHORIZED_LEAGUE_ACCESS", exception.getErrorCode());
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when insufficient players")
        void shouldThrowExceptionWhenInsufficientPlayers() {
            // Arrange
            League league = createReadyToActivateLeague();
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(leagueId, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leaguePlayerRepository.countActivePlayersByLeagueId(leagueId)).thenReturn(1L);

            // Act & Assert
            League.LeagueValidationException exception = assertThrows(
                    League.LeagueValidationException.class,
                    () -> useCase.activate(command)
            );

            assertTrue(exception.getMessage().contains("at least 2 players"));
            assertEquals("INSUFFICIENT_PLAYERS", exception.getErrorCode());
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when league is not in activatable status")
        void shouldThrowExceptionWhenLeagueNotInActivatableStatus() {
            // Arrange
            League activeLeague = createReadyToActivateLeague();
            activeLeague.setStatus(LeagueStatus.ACTIVE);
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(leagueId, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(leaguePlayerRepository.countActivePlayersByLeagueId(leagueId)).thenReturn(2L);

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.activate(command)
            );

            assertTrue(exception.getMessage().contains("cannot be activated"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should activate league from INACTIVE status")
        void shouldActivateLeagueFromInactiveStatus() {
            // Arrange
            League inactiveLeague = createReadyToActivateLeague();
            inactiveLeague.setStatus(LeagueStatus.INACTIVE);
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(leagueId, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(inactiveLeague));
            when(leaguePlayerRepository.countActivePlayersByLeagueId(leagueId)).thenReturn(2L);
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.activate(command);

            // Assert
            assertEquals(LeagueStatus.ACTIVE, result.getStatus());
            verify(leagueRepository).save(any(League.class));
        }
    }

    @Nested
    @DisplayName("deactivate")
    class Deactivate {

        @Test
        @DisplayName("should deactivate active league successfully")
        void shouldDeactivateActiveLeagueSuccessfully() {
            // Arrange
            League activeLeague = createLeagueInStatus(LeagueStatus.ACTIVE);
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(leagueId, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.deactivate(command);

            // Assert
            assertEquals(LeagueStatus.INACTIVE, result.getStatus());
            verify(leagueRepository).save(any(League.class));
        }

        @Test
        @DisplayName("should throw exception when league not found")
        void shouldThrowExceptionWhenLeagueNotFound() {
            // Arrange
            UUID unknownId = UUID.randomUUID();
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(unknownId, adminUserId);

            when(leagueRepository.findById(unknownId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.deactivate(command)
            );

            assertTrue(exception.getMessage().contains("League not found"));
        }

        @Test
        @DisplayName("should throw exception when admin does not own the league")
        void shouldThrowExceptionWhenAdminDoesNotOwnLeague() {
            // Arrange
            UUID differentAdmin = UUID.randomUUID();
            League league = createLeagueInStatus(LeagueStatus.ACTIVE);
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(leagueId, differentAdmin);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act & Assert
            LeagueLifecycleUseCase.UnauthorizedLeagueAccessException exception = assertThrows(
                    LeagueLifecycleUseCase.UnauthorizedLeagueAccessException.class,
                    () -> useCase.deactivate(command)
            );

            assertTrue(exception.getMessage().contains("does not own this league"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when league is not ACTIVE")
        void shouldThrowExceptionWhenLeagueNotActive() {
            // Arrange
            League draftLeague = createLeagueInStatus(LeagueStatus.DRAFT);
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(leagueId, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(draftLeague));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.deactivate(command)
            );

            assertTrue(exception.getMessage().contains("cannot be deactivated"));
            verify(leagueRepository, never()).save(any());
        }
    }

    @Nested
    @DisplayName("archive")
    class Archive {

        @Test
        @DisplayName("should archive completed league successfully")
        void shouldArchiveCompletedLeagueSuccessfully() {
            // Arrange
            League completedLeague = createLeagueInStatus(LeagueStatus.COMPLETED);
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(leagueId, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(completedLeague));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            League result = useCase.archive(command);

            // Assert
            assertEquals(LeagueStatus.ARCHIVED, result.getStatus());
            verify(leagueRepository).save(any(League.class));
        }

        @Test
        @DisplayName("should throw exception when league not found")
        void shouldThrowExceptionWhenLeagueNotFound() {
            // Arrange
            UUID unknownId = UUID.randomUUID();
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(unknownId, adminUserId);

            when(leagueRepository.findById(unknownId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.archive(command)
            );

            assertTrue(exception.getMessage().contains("League not found"));
        }

        @Test
        @DisplayName("should throw exception when admin does not own the league")
        void shouldThrowExceptionWhenAdminDoesNotOwnLeague() {
            // Arrange
            UUID differentAdmin = UUID.randomUUID();
            League league = createLeagueInStatus(LeagueStatus.COMPLETED);
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(leagueId, differentAdmin);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act & Assert
            LeagueLifecycleUseCase.UnauthorizedLeagueAccessException exception = assertThrows(
                    LeagueLifecycleUseCase.UnauthorizedLeagueAccessException.class,
                    () -> useCase.archive(command)
            );

            assertTrue(exception.getMessage().contains("does not own this league"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when league is not COMPLETED")
        void shouldThrowExceptionWhenLeagueNotCompleted() {
            // Arrange
            League activeLeague = createLeagueInStatus(LeagueStatus.ACTIVE);
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(leagueId, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.archive(command)
            );

            assertTrue(exception.getMessage().contains("cannot be archived"));
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when league is already ARCHIVED")
        void shouldThrowExceptionWhenLeagueAlreadyArchived() {
            // Arrange
            League archivedLeague = createLeagueInStatus(LeagueStatus.ARCHIVED);
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(leagueId, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(archivedLeague));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.archive(command)
            );

            assertTrue(exception.getMessage().contains("cannot be archived"));
            verify(leagueRepository, never()).save(any());
        }
    }

    @Nested
    @DisplayName("LifecycleCommand")
    class LifecycleCommandTests {

        @Test
        @DisplayName("should create command with leagueId and adminUserId")
        void shouldCreateCommandWithLeagueIdAndAdminUserId() {
            // Arrange & Act
            LeagueLifecycleUseCase.LifecycleCommand command =
                    new LeagueLifecycleUseCase.LifecycleCommand(leagueId, adminUserId);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertEquals(adminUserId, command.getAdminUserId());
        }
    }

    @Nested
    @DisplayName("UnauthorizedLeagueAccessException")
    class UnauthorizedLeagueAccessExceptionTests {

        @Test
        @DisplayName("should create exception with message and error code")
        void shouldCreateExceptionWithMessageAndErrorCode() {
            // Arrange & Act
            LeagueLifecycleUseCase.UnauthorizedLeagueAccessException exception =
                    new LeagueLifecycleUseCase.UnauthorizedLeagueAccessException("Test message");

            // Assert
            assertEquals("Test message", exception.getMessage());
            assertEquals("UNAUTHORIZED_LEAGUE_ACCESS", exception.getErrorCode());
        }
    }
}
