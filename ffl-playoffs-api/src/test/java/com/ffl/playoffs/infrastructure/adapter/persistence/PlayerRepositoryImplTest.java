package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.StandalonePlayerDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.PlayerMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.PlayerMongoRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("PlayerRepositoryImpl Tests")
class PlayerRepositoryImplTest {

    @Mock
    private PlayerMongoRepository mongoRepository;

    @Mock
    private PlayerMapper mapper;

    @InjectMocks
    private PlayerRepositoryImpl repository;

    private Player testPlayer;
    private StandalonePlayerDocument testDocument;

    @BeforeEach
    void setUp() {
        testPlayer = Player.builder()
                .id(123L)
                .email("test@example.com")
                .displayName("Test Player")
                .googleId("google-123")
                .joinedAt(LocalDateTime.now())
                .status(Player.PlayerStatus.ACTIVE)
                .build();

        testDocument = new StandalonePlayerDocument();
        testDocument.setId("123");
        testDocument.setEmail("test@example.com");
        testDocument.setDisplayName("Test Player");
        testDocument.setGoogleId("google-123");
        testDocument.setJoinedAt(LocalDateTime.now());
        testDocument.setStatus("ACTIVE");
    }

    @Test
    @DisplayName("save should persist player and return saved entity")
    void saveShouldPersistAndReturnSaved() {
        // Arrange
        when(mapper.toDocument(testPlayer)).thenReturn(testDocument);
        when(mongoRepository.save(testDocument)).thenReturn(testDocument);
        when(mapper.toDomain(testDocument)).thenReturn(testPlayer);

        // Act
        Player result = repository.save(testPlayer);

        // Assert
        assertNotNull(result);
        assertEquals(testPlayer.getId(), result.getId());
        assertEquals(testPlayer.getEmail(), result.getEmail());
        verify(mongoRepository).save(testDocument);
    }

    @Test
    @DisplayName("findById should return player when found")
    void findByIdShouldReturnPlayerWhenFound() {
        // Arrange
        when(mongoRepository.findById("123")).thenReturn(Optional.of(testDocument));
        when(mapper.toDomain(testDocument)).thenReturn(testPlayer);

        // Act
        Optional<Player> result = repository.findById(123L);

        // Assert
        assertTrue(result.isPresent());
        assertEquals(testPlayer.getEmail(), result.get().getEmail());
    }

    @Test
    @DisplayName("findById should return empty when not found")
    void findByIdShouldReturnEmptyWhenNotFound() {
        // Arrange
        when(mongoRepository.findById("999")).thenReturn(Optional.empty());

        // Act
        Optional<Player> result = repository.findById(999L);

        // Assert
        assertTrue(result.isEmpty());
    }

    @Test
    @DisplayName("findByEmail should return player when found")
    void findByEmailShouldReturnPlayerWhenFound() {
        // Arrange
        when(mongoRepository.findByEmail("test@example.com")).thenReturn(Optional.of(testDocument));
        when(mapper.toDomain(testDocument)).thenReturn(testPlayer);

        // Act
        Optional<Player> result = repository.findByEmail("test@example.com");

        // Assert
        assertTrue(result.isPresent());
        assertEquals(testPlayer.getId(), result.get().getId());
    }

    @Test
    @DisplayName("findByEmail should return empty when not found")
    void findByEmailShouldReturnEmptyWhenNotFound() {
        // Arrange
        when(mongoRepository.findByEmail("unknown@example.com")).thenReturn(Optional.empty());

        // Act
        Optional<Player> result = repository.findByEmail("unknown@example.com");

        // Assert
        assertTrue(result.isEmpty());
    }

    @Test
    @DisplayName("findByGoogleId should return player when found")
    void findByGoogleIdShouldReturnPlayerWhenFound() {
        // Arrange
        when(mongoRepository.findByGoogleId("google-123")).thenReturn(Optional.of(testDocument));
        when(mapper.toDomain(testDocument)).thenReturn(testPlayer);

        // Act
        Optional<Player> result = repository.findByGoogleId("google-123");

        // Assert
        assertTrue(result.isPresent());
        assertEquals(testPlayer.getGoogleId(), result.get().getGoogleId());
    }

    @Test
    @DisplayName("findAll should return all players")
    void findAllShouldReturnAllPlayers() {
        // Arrange
        StandalonePlayerDocument doc2 = new StandalonePlayerDocument();
        doc2.setId("456");
        doc2.setEmail("player2@example.com");

        Player player2 = Player.builder().id(456L).email("player2@example.com").build();

        when(mongoRepository.findAll()).thenReturn(List.of(testDocument, doc2));
        when(mapper.toDomain(testDocument)).thenReturn(testPlayer);
        when(mapper.toDomain(doc2)).thenReturn(player2);

        // Act
        List<Player> result = repository.findAll();

        // Assert
        assertEquals(2, result.size());
    }

    @Test
    @DisplayName("findByGameId should return empty list (standalone players not game-scoped)")
    void findByGameIdShouldReturnEmptyList() {
        // Act
        List<Player> result = repository.findByGameId(1L);

        // Assert
        assertTrue(result.isEmpty());
        verifyNoInteractions(mongoRepository);
    }

    @Test
    @DisplayName("delete should call repository deleteById")
    void deleteShouldCallRepositoryDeleteById() {
        // Act
        repository.delete(123L);

        // Assert
        verify(mongoRepository).deleteById("123");
    }
}
