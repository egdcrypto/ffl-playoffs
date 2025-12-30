package com.ffl.playoffs.application;

import com.ffl.playoffs.application.dto.GameDTO;
import com.ffl.playoffs.application.usecase.CreateGameUseCase;
import com.ffl.playoffs.domain.aggregate.Game;
import com.ffl.playoffs.domain.event.GameCreatedEvent;
import com.ffl.playoffs.domain.port.GameRepository;
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
import org.springframework.context.ApplicationEventPublisher;

import java.time.LocalDateTime;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CreateGameUseCase Tests")
class CreateGameUseCaseTest {

    @Mock
    private GameRepository gameRepository;

    @Mock
    private ApplicationEventPublisher eventPublisher;

    @InjectMocks
    private CreateGameUseCase useCase;

    @Captor
    private ArgumentCaptor<Game> gameCaptor;

    @Captor
    private ArgumentCaptor<GameCreatedEvent> eventCaptor;

    private String gameName;
    private String creatorEmail;

    @BeforeEach
    void setUp() {
        gameName = "Test Game";
        creatorEmail = "creator@example.com";
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should create game successfully with generated invite code")
        void shouldCreateGameSuccessfully() {
            // Arrange
            Game savedGame = Game.builder()
                    .id(1L)
                    .name(gameName)
                    .inviteCode("ABC12345")
                    .currentWeek(0)
                    .status(Game.GameStatus.PENDING)
                    .createdAt(LocalDateTime.now())
                    .build();

            when(gameRepository.save(any(Game.class))).thenReturn(savedGame);

            // Act
            GameDTO result = useCase.execute(gameName, creatorEmail);

            // Assert
            assertNotNull(result);
            assertEquals(gameName, result.getName());
            assertEquals(Game.GameStatus.PENDING.name(), result.getStatus());

            verify(gameRepository).save(gameCaptor.capture());
            Game capturedGame = gameCaptor.getValue();
            assertEquals(gameName, capturedGame.getName());
            assertNotNull(capturedGame.getInviteCode());
            assertEquals(8, capturedGame.getInviteCode().length());
            assertEquals(0, capturedGame.getCurrentWeek());
            assertEquals(Game.GameStatus.PENDING, capturedGame.getStatus());
        }

        @Test
        @DisplayName("should generate unique invite codes")
        void shouldGenerateUniqueInviteCodes() {
            // Arrange
            Game savedGame1 = Game.builder()
                    .id(1L)
                    .name(gameName)
                    .inviteCode("ABC12345")
                    .currentWeek(0)
                    .status(Game.GameStatus.PENDING)
                    .createdAt(LocalDateTime.now())
                    .build();

            Game savedGame2 = Game.builder()
                    .id(2L)
                    .name("Another Game")
                    .inviteCode("XYZ98765")
                    .currentWeek(0)
                    .status(Game.GameStatus.PENDING)
                    .createdAt(LocalDateTime.now())
                    .build();

            when(gameRepository.save(any(Game.class)))
                    .thenReturn(savedGame1)
                    .thenReturn(savedGame2);

            // Act
            useCase.execute(gameName, creatorEmail);
            useCase.execute("Another Game", "another@example.com");

            // Assert
            verify(gameRepository, times(2)).save(gameCaptor.capture());
            var capturedGames = gameCaptor.getAllValues();
            assertNotEquals(
                    capturedGames.get(0).getInviteCode(),
                    capturedGames.get(1).getInviteCode()
            );
        }

        @Test
        @DisplayName("should publish GameCreatedEvent after game creation")
        void shouldPublishGameCreatedEvent() {
            // Arrange
            Game savedGame = Game.builder()
                    .id(1L)
                    .name(gameName)
                    .inviteCode("ABC12345")
                    .currentWeek(0)
                    .status(Game.GameStatus.PENDING)
                    .createdAt(LocalDateTime.now())
                    .build();

            when(gameRepository.save(any(Game.class))).thenReturn(savedGame);

            // Act
            useCase.execute(gameName, creatorEmail);

            // Assert
            verify(eventPublisher).publishEvent(eventCaptor.capture());
            GameCreatedEvent capturedEvent = eventCaptor.getValue();

            assertNotNull(capturedEvent);
            assertEquals(savedGame.getId(), capturedEvent.getGameId());
            assertEquals(savedGame.getName(), capturedEvent.getGameName());
            assertEquals(savedGame.getInviteCode(), capturedEvent.getInviteCode());
            assertEquals(creatorEmail, capturedEvent.getCreatorEmail());
            assertNotNull(capturedEvent.getCreatedAt());
        }

        @Test
        @DisplayName("should set initial game status to PENDING")
        void shouldSetInitialStatusToPending() {
            // Arrange
            Game savedGame = Game.builder()
                    .id(1L)
                    .name(gameName)
                    .inviteCode("ABC12345")
                    .currentWeek(0)
                    .status(Game.GameStatus.PENDING)
                    .createdAt(LocalDateTime.now())
                    .build();

            when(gameRepository.save(any(Game.class))).thenReturn(savedGame);

            // Act
            GameDTO result = useCase.execute(gameName, creatorEmail);

            // Assert
            verify(gameRepository).save(gameCaptor.capture());
            assertEquals(Game.GameStatus.PENDING, gameCaptor.getValue().getStatus());
        }

        @Test
        @DisplayName("should set current week to 0 on creation")
        void shouldSetCurrentWeekToZero() {
            // Arrange
            Game savedGame = Game.builder()
                    .id(1L)
                    .name(gameName)
                    .inviteCode("ABC12345")
                    .currentWeek(0)
                    .status(Game.GameStatus.PENDING)
                    .createdAt(LocalDateTime.now())
                    .build();

            when(gameRepository.save(any(Game.class))).thenReturn(savedGame);

            // Act
            useCase.execute(gameName, creatorEmail);

            // Assert
            verify(gameRepository).save(gameCaptor.capture());
            assertEquals(0, gameCaptor.getValue().getCurrentWeek());
        }
    }
}
