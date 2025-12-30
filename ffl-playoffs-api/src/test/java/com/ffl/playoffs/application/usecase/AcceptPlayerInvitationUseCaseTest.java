package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.EnumSource;
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
@DisplayName("AcceptPlayerInvitationUseCase Tests")
class AcceptPlayerInvitationUseCaseTest {

    @Mock
    private LeaguePlayerRepository leaguePlayerRepository;

    private AcceptPlayerInvitationUseCase useCase;

    @Captor
    private ArgumentCaptor<LeaguePlayer> leaguePlayerCaptor;

    private UUID leaguePlayerId;
    private String invitationToken;
    private LeaguePlayer invitedPlayer;

    @BeforeEach
    void setUp() {
        useCase = new AcceptPlayerInvitationUseCase(leaguePlayerRepository);

        leaguePlayerId = UUID.randomUUID();
        invitationToken = "inv-token-12345";

        // Create an invited league player
        invitedPlayer = new LeaguePlayer(UUID.randomUUID(), UUID.randomUUID());
        invitedPlayer.setId(leaguePlayerId);
        invitedPlayer.setInvitationToken(invitationToken);
        // Default status is INVITED
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should accept player invitation successfully")
        void shouldAcceptInvitationSuccessfully() {
            // Arrange
            AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand command =
                    new AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand(
                            leaguePlayerId, invitationToken);

            when(leaguePlayerRepository.findById(leaguePlayerId)).thenReturn(Optional.of(invitedPlayer));
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            LeaguePlayer result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(LeaguePlayer.LeaguePlayerStatus.ACTIVE, result.getStatus());
            assertNotNull(result.getJoinedAt());

            verify(leaguePlayerRepository).save(leaguePlayerCaptor.capture());
            assertEquals(LeaguePlayer.LeaguePlayerStatus.ACTIVE, leaguePlayerCaptor.getValue().getStatus());
        }

        @Test
        @DisplayName("should throw exception when league player not found")
        void shouldThrowExceptionWhenPlayerNotFound() {
            // Arrange
            UUID unknownId = UUID.randomUUID();
            AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand command =
                    new AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand(
                            unknownId, invitationToken);

            when(leaguePlayerRepository.findById(unknownId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("not found"));
            verify(leaguePlayerRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when invitation token doesn't match")
        void shouldThrowExceptionWhenTokenMismatch() {
            // Arrange
            String wrongToken = "wrong-token";
            AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand command =
                    new AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand(
                            leaguePlayerId, wrongToken);

            when(leaguePlayerRepository.findById(leaguePlayerId)).thenReturn(Optional.of(invitedPlayer));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Invalid invitation token"));
            verify(leaguePlayerRepository, never()).save(any());
        }

        @ParameterizedTest
        @EnumSource(value = LeaguePlayer.LeaguePlayerStatus.class, mode = EnumSource.Mode.EXCLUDE, names = {"INVITED"})
        @DisplayName("should throw exception when player is not in INVITED status")
        void shouldThrowExceptionWhenNotInvitedStatus(LeaguePlayer.LeaguePlayerStatus status) {
            // Arrange
            LeaguePlayer nonInvitedPlayer = new LeaguePlayer(UUID.randomUUID(), UUID.randomUUID());
            nonInvitedPlayer.setId(leaguePlayerId);
            nonInvitedPlayer.setInvitationToken(invitationToken);
            nonInvitedPlayer.setStatus(status);

            AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand command =
                    new AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand(
                            leaguePlayerId, invitationToken);

            when(leaguePlayerRepository.findById(leaguePlayerId)).thenReturn(Optional.of(nonInvitedPlayer));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("INVITED"));
            verify(leaguePlayerRepository, never()).save(any());
        }

        @Test
        @DisplayName("should accept invitation when token is null in player")
        void shouldAcceptWhenPlayerTokenIsNull() {
            // Arrange
            LeaguePlayer playerWithNullToken = new LeaguePlayer(UUID.randomUUID(), UUID.randomUUID());
            playerWithNullToken.setId(leaguePlayerId);
            playerWithNullToken.setInvitationToken(null);

            AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand command =
                    new AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand(
                            leaguePlayerId, invitationToken);

            when(leaguePlayerRepository.findById(leaguePlayerId)).thenReturn(Optional.of(playerWithNullToken));
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            LeaguePlayer result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(LeaguePlayer.LeaguePlayerStatus.ACTIVE, result.getStatus());
        }

        @Test
        @DisplayName("should save league player after accepting")
        void shouldSaveLeaguePlayerAfterAccepting() {
            // Arrange
            AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand command =
                    new AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand(
                            leaguePlayerId, invitationToken);

            when(leaguePlayerRepository.findById(leaguePlayerId)).thenReturn(Optional.of(invitedPlayer));
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(leaguePlayerRepository, times(1)).save(any(LeaguePlayer.class));
        }

        @Test
        @DisplayName("should clear invitation token after accepting")
        void shouldClearInvitationTokenAfterAccepting() {
            // Arrange
            AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand command =
                    new AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand(
                            leaguePlayerId, invitationToken);

            when(leaguePlayerRepository.findById(leaguePlayerId)).thenReturn(Optional.of(invitedPlayer));
            when(leaguePlayerRepository.save(any(LeaguePlayer.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            LeaguePlayer result = useCase.execute(command);

            // Assert
            assertNull(result.getInvitationToken());
        }
    }

    @Nested
    @DisplayName("AcceptPlayerInvitationCommand")
    class CommandTests {

        @Test
        @DisplayName("should create command with all fields")
        void shouldCreateCommandWithAllFields() {
            // Arrange & Act
            AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand command =
                    new AcceptPlayerInvitationUseCase.AcceptPlayerInvitationCommand(
                            leaguePlayerId, invitationToken);

            // Assert
            assertEquals(leaguePlayerId, command.getLeaguePlayerId());
            assertEquals(invitationToken, command.getInvitationToken());
        }
    }
}
