package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.Game;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.GameDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.PlayerDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.GameMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.GameMongoRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("GameRepositoryImpl Tests")
class GameRepositoryImplTest {

    @Mock
    private GameMongoRepository mongoRepository;

    @Mock
    private GameMapper mapper;

    @InjectMocks
    private GameRepositoryImpl repository;

    private Game testGame;
    private GameDocument testDocument;
    private UUID testUuid;

    @BeforeEach
    void setUp() {
        testUuid = UUID.randomUUID();

        testGame = Game.builder()
                .id(123L)
                .name("Test Game")
                .inviteCode("ABC123")
                .currentWeek(1)
                .status(Game.GameStatus.PENDING)
                .createdAt(LocalDateTime.now())
                .build();

        testDocument = GameDocument.builder()
                .id(testUuid)
                .name("Test Game")
                .code("ABC123")
                .currentWeek(1)
                .status("PENDING")
                .createdAt(LocalDateTime.now())
                .build();
    }

    @Nested
    @DisplayName("save")
    class Save {

        @Test
        @DisplayName("should save game and return saved entity")
        void shouldSaveAndReturnGame() {
            // Arrange
            when(mapper.toDocument(testGame)).thenReturn(testDocument);
            when(mongoRepository.save(any(GameDocument.class))).thenReturn(testDocument);
            when(mapper.toDomain(testDocument)).thenReturn(testGame);

            // Act
            Game result = repository.save(testGame);

            // Assert
            assertNotNull(result);
            assertEquals(testGame.getName(), result.getName());
            verify(mongoRepository).save(any(GameDocument.class));
        }

        @Test
        @DisplayName("should generate UUID if not present")
        void shouldGenerateUuidIfNotPresent() {
            // Arrange
            GameDocument docWithoutId = GameDocument.builder()
                    .name("Test Game")
                    .code("ABC123")
                    .build();
            when(mapper.toDocument(testGame)).thenReturn(docWithoutId);
            when(mongoRepository.save(any(GameDocument.class))).thenAnswer(invocation -> {
                GameDocument doc = invocation.getArgument(0);
                assertNotNull(doc.getId(), "UUID should be generated before save");
                return doc;
            });
            when(mapper.toDomain(any())).thenReturn(testGame);

            // Act
            repository.save(testGame);

            // Assert
            verify(mongoRepository).save(any(GameDocument.class));
        }
    }

    @Nested
    @DisplayName("findByInviteCode")
    class FindByInviteCode {

        @Test
        @DisplayName("should return game when found by invite code")
        void shouldReturnGameWhenFound() {
            // Arrange
            when(mongoRepository.findByCode("ABC123")).thenReturn(Optional.of(testDocument));
            when(mapper.toDomain(testDocument)).thenReturn(testGame);

            // Act
            Optional<Game> result = repository.findByInviteCode("ABC123");

            // Assert
            assertTrue(result.isPresent());
            assertEquals("ABC123", result.get().getInviteCode());
        }

        @Test
        @DisplayName("should return empty when not found")
        void shouldReturnEmptyWhenNotFound() {
            // Arrange
            when(mongoRepository.findByCode("NOTFOUND")).thenReturn(Optional.empty());

            // Act
            Optional<Game> result = repository.findByInviteCode("NOTFOUND");

            // Assert
            assertTrue(result.isEmpty());
        }
    }

    @Nested
    @DisplayName("findAll")
    class FindAll {

        @Test
        @DisplayName("should return all games")
        void shouldReturnAllGames() {
            // Arrange
            GameDocument doc2 = GameDocument.builder()
                    .id(UUID.randomUUID())
                    .name("Game 2")
                    .code("DEF456")
                    .build();
            Game game2 = Game.builder().name("Game 2").inviteCode("DEF456").build();

            when(mongoRepository.findAll()).thenReturn(List.of(testDocument, doc2));
            when(mapper.toDomain(testDocument)).thenReturn(testGame);
            when(mapper.toDomain(doc2)).thenReturn(game2);

            // Act
            List<Game> result = repository.findAll();

            // Assert
            assertEquals(2, result.size());
        }

        @Test
        @DisplayName("should return empty list when no games")
        void shouldReturnEmptyListWhenNoGames() {
            // Arrange
            when(mongoRepository.findAll()).thenReturn(List.of());

            // Act
            List<Game> result = repository.findAll();

            // Assert
            assertTrue(result.isEmpty());
        }
    }

    @Nested
    @DisplayName("existsByInviteCode")
    class ExistsByInviteCode {

        @Test
        @DisplayName("should return true when code exists")
        void shouldReturnTrueWhenExists() {
            // Arrange
            when(mongoRepository.existsByCode("ABC123")).thenReturn(true);

            // Act
            boolean result = repository.existsByInviteCode("ABC123");

            // Assert
            assertTrue(result);
        }

        @Test
        @DisplayName("should return false when code does not exist")
        void shouldReturnFalseWhenNotExists() {
            // Arrange
            when(mongoRepository.existsByCode("NOTFOUND")).thenReturn(false);

            // Act
            boolean result = repository.existsByInviteCode("NOTFOUND");

            // Assert
            assertFalse(result);
        }
    }

    @Nested
    @DisplayName("findById")
    class FindById {

        @Test
        @DisplayName("should return game when found by id")
        void shouldReturnGameWhenFound() {
            // Arrange
            Long targetId = Long.parseLong(testUuid.toString().hashCode() + "");
            when(mongoRepository.findAll()).thenReturn(List.of(testDocument));
            when(mapper.toDomain(testDocument)).thenReturn(testGame);

            // Act
            Optional<Game> result = repository.findById(targetId);

            // Assert
            assertTrue(result.isPresent());
        }

        @Test
        @DisplayName("should return empty when not found")
        void shouldReturnEmptyWhenNotFound() {
            // Arrange
            when(mongoRepository.findAll()).thenReturn(List.of(testDocument));

            // Act
            Optional<Game> result = repository.findById(999999L);

            // Assert
            assertTrue(result.isEmpty());
        }
    }

    @Nested
    @DisplayName("delete")
    class Delete {

        @Test
        @DisplayName("should delete game when found")
        void shouldDeleteGameWhenFound() {
            // Arrange
            Long targetId = Long.parseLong(testUuid.toString().hashCode() + "");
            when(mongoRepository.findAll()).thenReturn(List.of(testDocument));

            // Act
            repository.delete(targetId);

            // Assert
            verify(mongoRepository).deleteById(testUuid);
        }

        @Test
        @DisplayName("should not delete when not found")
        void shouldNotDeleteWhenNotFound() {
            // Arrange
            when(mongoRepository.findAll()).thenReturn(List.of(testDocument));

            // Act
            repository.delete(999999L);

            // Assert
            verify(mongoRepository, never()).deleteById(any());
        }
    }

    @Nested
    @DisplayName("findByPlayerId")
    class FindByPlayerId {

        @Test
        @DisplayName("should return games containing player")
        void shouldReturnGamesWithPlayer() {
            // Arrange
            UUID playerUuid = UUID.randomUUID();
            Long playerId = Long.parseLong(playerUuid.toString().hashCode() + "");

            PlayerDocument player = PlayerDocument.builder()
                    .id(playerUuid)
                    .name("Test Player")
                    .email("test@example.com")
                    .build();

            GameDocument gameWithPlayer = GameDocument.builder()
                    .id(testUuid)
                    .name("Game with Player")
                    .code("ABC123")
                    .players(List.of(player))
                    .build();

            when(mongoRepository.findAll()).thenReturn(List.of(gameWithPlayer));
            when(mapper.toDomain(gameWithPlayer)).thenReturn(testGame);

            // Act
            List<Game> result = repository.findByPlayerId(playerId);

            // Assert
            assertEquals(1, result.size());
        }

        @Test
        @DisplayName("should return empty list when player not in any game")
        void shouldReturnEmptyWhenPlayerNotFound() {
            // Arrange
            when(mongoRepository.findAll()).thenReturn(List.of(testDocument));

            // Act
            List<Game> result = repository.findByPlayerId(999999L);

            // Assert
            assertTrue(result.isEmpty());
        }
    }
}
