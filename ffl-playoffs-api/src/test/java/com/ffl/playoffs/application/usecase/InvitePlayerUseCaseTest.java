package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.PlayerDTO;
import com.ffl.playoffs.domain.aggregate.Game;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.port.GameRepository;
import com.ffl.playoffs.domain.port.PlayerRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("InvitePlayerUseCase Tests")
class InvitePlayerUseCaseTest {

    @Mock
    private GameRepository gameRepository;

    @Mock
    private PlayerRepository playerRepository;

    @InjectMocks
    private InvitePlayerUseCase useCase;

    @Captor
    private ArgumentCaptor<Player> playerCaptor;

    @Captor
    private ArgumentCaptor<Game> gameCaptor;

    private String inviteCode;
    private String email;
    private String displayName;
    private String googleId;
    private Game pendingGame;

    @BeforeEach
    void setUp() {
        inviteCode = "ABC12345";
        email = "player@example.com";
        displayName = "Test Player";
        googleId = "google-123";

        pendingGame = Game.builder()
                .id(1L)
                .name("Test Game")
                .inviteCode(inviteCode)
                .status(Game.GameStatus.PENDING)
                .currentWeek(0)
                .createdAt(LocalDateTime.now())
                .build();
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should invite player successfully when game is pending")
        void shouldInvitePlayerSuccessfully() {
            // Arrange
            Player savedPlayer = Player.builder()
                    .id(1L)
                    .email(email)
                    .displayName(displayName)
                    .googleId(googleId)
                    .status(Player.PlayerStatus.ACTIVE)
                    .joinedAt(LocalDateTime.now())
                    .build();

            when(gameRepository.findByInviteCode(inviteCode)).thenReturn(Optional.of(pendingGame));
            when(playerRepository.save(any(Player.class))).thenReturn(savedPlayer);
            when(gameRepository.save(any(Game.class))).thenReturn(pendingGame);

            // Act
            PlayerDTO result = useCase.execute(inviteCode, email, displayName, googleId);

            // Assert
            assertNotNull(result);
            assertEquals(email, result.getEmail());
            assertEquals(displayName, result.getDisplayName());

            verify(playerRepository).save(playerCaptor.capture());
            Player capturedPlayer = playerCaptor.getValue();
            assertEquals(email, capturedPlayer.getEmail());
            assertEquals(displayName, capturedPlayer.getDisplayName());
            assertEquals(googleId, capturedPlayer.getGoogleId());
            assertEquals(Player.PlayerStatus.ACTIVE, capturedPlayer.getStatus());
            assertNotNull(capturedPlayer.getJoinedAt());

            verify(gameRepository).save(gameCaptor.capture());
        }

        @Test
        @DisplayName("should throw exception when invite code is invalid")
        void shouldThrowExceptionWhenInviteCodeIsInvalid() {
            // Arrange
            String invalidCode = "INVALID";
            when(gameRepository.findByInviteCode(invalidCode)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(invalidCode, email, displayName, googleId)
            );

            assertEquals("Invalid invite code", exception.getMessage());
            verify(playerRepository, never()).save(any());
            verify(gameRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when game has already started")
        void shouldThrowExceptionWhenGameHasStarted() {
            // Arrange
            Game activeGame = Game.builder()
                    .id(1L)
                    .name("Active Game")
                    .inviteCode(inviteCode)
                    .status(Game.GameStatus.IN_PROGRESS)
                    .currentWeek(1)
                    .build();

            when(gameRepository.findByInviteCode(inviteCode)).thenReturn(Optional.of(activeGame));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(inviteCode, email, displayName, googleId)
            );

            assertEquals("Game has already started", exception.getMessage());
            verify(playerRepository, never()).save(any());
            verify(gameRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when game is completed")
        void shouldThrowExceptionWhenGameIsCompleted() {
            // Arrange
            Game completedGame = Game.builder()
                    .id(1L)
                    .name("Completed Game")
                    .inviteCode(inviteCode)
                    .status(Game.GameStatus.COMPLETED)
                    .currentWeek(4)
                    .build();

            when(gameRepository.findByInviteCode(inviteCode)).thenReturn(Optional.of(completedGame));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(inviteCode, email, displayName, googleId)
            );

            assertEquals("Game has already started", exception.getMessage());
        }

        @Test
        @DisplayName("should set player status to ACTIVE")
        void shouldSetPlayerStatusToActive() {
            // Arrange
            Player savedPlayer = Player.builder()
                    .id(1L)
                    .email(email)
                    .displayName(displayName)
                    .googleId(googleId)
                    .status(Player.PlayerStatus.ACTIVE)
                    .joinedAt(LocalDateTime.now())
                    .build();

            when(gameRepository.findByInviteCode(inviteCode)).thenReturn(Optional.of(pendingGame));
            when(playerRepository.save(any(Player.class))).thenReturn(savedPlayer);
            when(gameRepository.save(any(Game.class))).thenReturn(pendingGame);

            // Act
            useCase.execute(inviteCode, email, displayName, googleId);

            // Assert
            verify(playerRepository).save(playerCaptor.capture());
            assertEquals(Player.PlayerStatus.ACTIVE, playerCaptor.getValue().getStatus());
        }

        @Test
        @DisplayName("should add player to game")
        void shouldAddPlayerToGame() {
            // Arrange
            Player savedPlayer = Player.builder()
                    .id(1L)
                    .email(email)
                    .displayName(displayName)
                    .googleId(googleId)
                    .status(Player.PlayerStatus.ACTIVE)
                    .joinedAt(LocalDateTime.now())
                    .build();

            when(gameRepository.findByInviteCode(inviteCode)).thenReturn(Optional.of(pendingGame));
            when(playerRepository.save(any(Player.class))).thenReturn(savedPlayer);
            when(gameRepository.save(any(Game.class))).thenReturn(pendingGame);

            // Act
            useCase.execute(inviteCode, email, displayName, googleId);

            // Assert
            verify(gameRepository).save(gameCaptor.capture());
            Game capturedGame = gameCaptor.getValue();
            assertNotNull(capturedGame);
        }

        @Test
        @DisplayName("should set joinedAt timestamp")
        void shouldSetJoinedAtTimestamp() {
            // Arrange
            LocalDateTime beforeInvite = LocalDateTime.now().minusSeconds(1);

            Player savedPlayer = Player.builder()
                    .id(1L)
                    .email(email)
                    .displayName(displayName)
                    .googleId(googleId)
                    .status(Player.PlayerStatus.ACTIVE)
                    .joinedAt(LocalDateTime.now())
                    .build();

            when(gameRepository.findByInviteCode(inviteCode)).thenReturn(Optional.of(pendingGame));
            when(playerRepository.save(any(Player.class))).thenReturn(savedPlayer);
            when(gameRepository.save(any(Game.class))).thenReturn(pendingGame);

            // Act
            useCase.execute(inviteCode, email, displayName, googleId);

            // Assert
            verify(playerRepository).save(playerCaptor.capture());
            LocalDateTime joinedAt = playerCaptor.getValue().getJoinedAt();
            assertNotNull(joinedAt);
            assertTrue(joinedAt.isAfter(beforeInvite));
        }
    }
}
