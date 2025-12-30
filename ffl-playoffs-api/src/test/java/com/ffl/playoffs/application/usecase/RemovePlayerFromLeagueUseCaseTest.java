package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.LeagueRepository;
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
@DisplayName("RemovePlayerFromLeagueUseCase Tests")
class RemovePlayerFromLeagueUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    @Mock
    private LeaguePlayerRepository leaguePlayerRepository;

    private RemovePlayerFromLeagueUseCase useCase;

    @Captor
    private ArgumentCaptor<LeaguePlayer> leaguePlayerCaptor;

    private UUID leagueId;
    private UUID adminUserId;
    private UUID playerUserId;
    private League league;
    private LeaguePlayer leaguePlayer;

    @BeforeEach
    void setUp() {
        useCase = new RemovePlayerFromLeagueUseCase(leagueRepository, leaguePlayerRepository);

        leagueId = UUID.randomUUID();
        adminUserId = UUID.randomUUID();
        playerUserId = UUID.randomUUID();

        // Create league
        league = new League();
        league.setId(leagueId);
        league.setName("Test League");
        league.setCode("TEST");
        league.setOwnerId(adminUserId);
        league.setStartingWeekAndDuration(15, 3);

        // Create league player
        leaguePlayer = new LeaguePlayer(playerUserId, leagueId);
        leaguePlayer.setId(UUID.randomUUID());
        leaguePlayer.setStatus(LeaguePlayer.LeaguePlayerStatus.ACTIVE);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should remove player successfully")
        void shouldRemovePlayerSuccessfully() {
            // Arrange
            RemovePlayerFromLeagueUseCase.RemovePlayerCommand command =
                    new RemovePlayerFromLeagueUseCase.RemovePlayerCommand(leagueId, playerUserId, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leaguePlayerRepository.findByUserIdAndLeagueId(playerUserId, leagueId))
                    .thenReturn(Optional.of(leaguePlayer));
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            LeaguePlayer result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(LeaguePlayer.LeaguePlayerStatus.REMOVED, result.getStatus());
        }

        @Test
        @DisplayName("should throw exception when league not found")
        void shouldThrowExceptionWhenLeagueNotFound() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            RemovePlayerFromLeagueUseCase.RemovePlayerCommand command =
                    new RemovePlayerFromLeagueUseCase.RemovePlayerCommand(unknownLeagueId, playerUserId, adminUserId);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("League not found"));
            verify(leaguePlayerRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw UnauthorizedLeagueAccessException when not owner")
        void shouldThrowExceptionWhenNotOwner() {
            // Arrange
            UUID differentUserId = UUID.randomUUID();
            RemovePlayerFromLeagueUseCase.RemovePlayerCommand command =
                    new RemovePlayerFromLeagueUseCase.RemovePlayerCommand(leagueId, playerUserId, differentUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));

            // Act & Assert
            RemovePlayerFromLeagueUseCase.UnauthorizedLeagueAccessException exception = assertThrows(
                    RemovePlayerFromLeagueUseCase.UnauthorizedLeagueAccessException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("does not own"));
            assertEquals("UNAUTHORIZED_LEAGUE_ACCESS", exception.getErrorCode());
            verify(leaguePlayerRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when player not in league")
        void shouldThrowExceptionWhenPlayerNotInLeague() {
            // Arrange
            UUID unknownPlayerId = UUID.randomUUID();
            RemovePlayerFromLeagueUseCase.RemovePlayerCommand command =
                    new RemovePlayerFromLeagueUseCase.RemovePlayerCommand(leagueId, unknownPlayerId, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leaguePlayerRepository.findByUserIdAndLeagueId(unknownPlayerId, leagueId))
                    .thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("not a member"));
            verify(leaguePlayerRepository, never()).save(any());
        }

        @Test
        @DisplayName("should set status to REMOVED")
        void shouldSetStatusToRemoved() {
            // Arrange
            RemovePlayerFromLeagueUseCase.RemovePlayerCommand command =
                    new RemovePlayerFromLeagueUseCase.RemovePlayerCommand(leagueId, playerUserId, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leaguePlayerRepository.findByUserIdAndLeagueId(playerUserId, leagueId))
                    .thenReturn(Optional.of(leaguePlayer));
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(leaguePlayerRepository).save(leaguePlayerCaptor.capture());
            LeaguePlayer savedPlayer = leaguePlayerCaptor.getValue();
            assertEquals(LeaguePlayer.LeaguePlayerStatus.REMOVED, savedPlayer.getStatus());
        }

        @Test
        @DisplayName("should save to repository")
        void shouldSaveToRepository() {
            // Arrange
            RemovePlayerFromLeagueUseCase.RemovePlayerCommand command =
                    new RemovePlayerFromLeagueUseCase.RemovePlayerCommand(leagueId, playerUserId, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leaguePlayerRepository.findByUserIdAndLeagueId(playerUserId, leagueId))
                    .thenReturn(Optional.of(leaguePlayer));
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(leaguePlayerRepository, times(1)).save(any(LeaguePlayer.class));
        }

        @Test
        @DisplayName("should throw exception when player already removed")
        void shouldThrowExceptionWhenPlayerAlreadyRemoved() {
            // Arrange
            LeaguePlayer removedPlayer = new LeaguePlayer(playerUserId, leagueId);
            removedPlayer.setId(UUID.randomUUID());
            removedPlayer.setStatus(LeaguePlayer.LeaguePlayerStatus.REMOVED);

            RemovePlayerFromLeagueUseCase.RemovePlayerCommand command =
                    new RemovePlayerFromLeagueUseCase.RemovePlayerCommand(leagueId, playerUserId, adminUserId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(leaguePlayerRepository.findByUserIdAndLeagueId(playerUserId, leagueId))
                    .thenReturn(Optional.of(removedPlayer));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("already removed"));
            verify(leaguePlayerRepository, never()).save(any());
        }
    }

    @Nested
    @DisplayName("RemovePlayerCommand")
    class RemovePlayerCommandTests {

        @Test
        @DisplayName("should create command with all fields")
        void shouldCreateCommandWithAllFields() {
            // Arrange & Act
            RemovePlayerFromLeagueUseCase.RemovePlayerCommand command =
                    new RemovePlayerFromLeagueUseCase.RemovePlayerCommand(leagueId, playerUserId, adminUserId);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
            assertEquals(playerUserId, command.getPlayerUserId());
            assertEquals(adminUserId, command.getAdminUserId());
        }
    }
}
