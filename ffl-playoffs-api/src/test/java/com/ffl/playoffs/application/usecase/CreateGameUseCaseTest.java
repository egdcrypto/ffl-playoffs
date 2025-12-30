package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.GameDTO;
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
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ApplicationEventPublisher;

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

    private CreateGameUseCase useCase;

    @Captor
    private ArgumentCaptor<Game> gameCaptor;

    @Captor
    private ArgumentCaptor<GameCreatedEvent> eventCaptor;

    private String gameName;
    private String creatorEmail;

    @BeforeEach
    void setUp() {
        useCase = new CreateGameUseCase(gameRepository, eventPublisher);

        gameName = "Test Game";
        creatorEmail = "creator@test.com";
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should create game successfully")
        void shouldCreateGameSuccessfully() {
            // Arrange
            when(gameRepository.save(any(Game.class))).thenAnswer(inv -> {
                Game game = inv.getArgument(0);
                game.setId(1L);
                return game;
            });

            // Act
            GameDTO result = useCase.execute(gameName, creatorEmail);

            // Assert
            assertNotNull(result);
            assertEquals(gameName, result.getName());
            assertNotNull(result.getInviteCode());
        }

        @Test
        @DisplayName("should generate 8-character uppercase invite code")
        void shouldGenerateInviteCode() {
            // Arrange
            when(gameRepository.save(any(Game.class))).thenAnswer(inv -> {
                Game game = inv.getArgument(0);
                game.setId(1L);
                return game;
            });

            // Act
            GameDTO result = useCase.execute(gameName, creatorEmail);

            // Assert
            assertNotNull(result.getInviteCode());
            assertEquals(8, result.getInviteCode().length());
            assertEquals(result.getInviteCode().toUpperCase(), result.getInviteCode());
        }

        @Test
        @DisplayName("should set game status to PENDING")
        void shouldSetStatusToPending() {
            // Arrange
            when(gameRepository.save(any(Game.class))).thenAnswer(inv -> {
                Game game = inv.getArgument(0);
                game.setId(1L);
                return game;
            });

            // Act
            GameDTO result = useCase.execute(gameName, creatorEmail);

            // Assert
            assertEquals("PENDING", result.getStatus());
        }

        @Test
        @DisplayName("should set currentWeek to 0")
        void shouldSetCurrentWeekToZero() {
            // Arrange
            when(gameRepository.save(any(Game.class))).thenAnswer(inv -> {
                Game game = inv.getArgument(0);
                game.setId(1L);
                return game;
            });

            // Act
            GameDTO result = useCase.execute(gameName, creatorEmail);

            // Assert
            assertEquals(0, result.getCurrentWeek());
        }

        @Test
        @DisplayName("should save game to repository")
        void shouldSaveGameToRepository() {
            // Arrange
            when(gameRepository.save(any(Game.class))).thenAnswer(inv -> {
                Game game = inv.getArgument(0);
                game.setId(1L);
                return game;
            });

            // Act
            useCase.execute(gameName, creatorEmail);

            // Assert
            verify(gameRepository, times(1)).save(gameCaptor.capture());
            Game savedGame = gameCaptor.getValue();
            assertEquals(gameName, savedGame.getName());
            assertNotNull(savedGame.getInviteCode());
            assertEquals(Game.GameStatus.PENDING, savedGame.getStatus());
            assertEquals(0, savedGame.getCurrentWeek());
        }

        @Test
        @DisplayName("should publish GameCreatedEvent")
        void shouldPublishGameCreatedEvent() {
            // Arrange
            when(gameRepository.save(any(Game.class))).thenAnswer(inv -> {
                Game game = inv.getArgument(0);
                game.setId(1L);
                return game;
            });

            // Act
            useCase.execute(gameName, creatorEmail);

            // Assert
            verify(eventPublisher, times(1)).publishEvent(eventCaptor.capture());
            GameCreatedEvent event = eventCaptor.getValue();
            assertEquals(1L, event.getGameId());
            assertEquals(gameName, event.getGameName());
            assertEquals(creatorEmail, event.getCreatorEmail());
            assertNotNull(event.getInviteCode());
        }

        @Test
        @DisplayName("should return GameDTO with correct data")
        void shouldReturnGameDTOWithCorrectData() {
            // Arrange
            when(gameRepository.save(any(Game.class))).thenAnswer(inv -> {
                Game game = inv.getArgument(0);
                game.setId(1L);
                return game;
            });

            // Act
            GameDTO result = useCase.execute(gameName, creatorEmail);

            // Assert
            assertNotNull(result);
            assertEquals(1L, result.getId());
            assertEquals(gameName, result.getName());
            assertNotNull(result.getInviteCode());
            assertNotNull(result.getCreatedAt());
            assertEquals(0, result.getCurrentWeek());
            assertEquals("PENDING", result.getStatus());
        }

        @Test
        @DisplayName("should set createdAt timestamp")
        void shouldSetCreatedAtTimestamp() {
            // Arrange
            when(gameRepository.save(any(Game.class))).thenAnswer(inv -> {
                Game game = inv.getArgument(0);
                game.setId(1L);
                return game;
            });

            // Act
            GameDTO result = useCase.execute(gameName, creatorEmail);

            // Assert
            assertNotNull(result.getCreatedAt());
        }
    }
}
