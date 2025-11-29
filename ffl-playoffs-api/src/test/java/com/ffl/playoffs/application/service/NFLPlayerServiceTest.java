package com.ffl.playoffs.application.service;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.nfl.NFLPlayerDTO;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLPlayerDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoNFLPlayerRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("NFLPlayerService Tests")
class NFLPlayerServiceTest {

    @Mock
    private MongoNFLPlayerRepository playerRepository;

    @InjectMocks
    private NFLPlayerService playerService;

    private NFLPlayerDocument testPlayer;

    @BeforeEach
    void setUp() {
        testPlayer = NFLPlayerDocument.builder()
                .playerId("12345")
                .name("Patrick Mahomes")
                .firstName("Patrick")
                .lastName("Mahomes")
                .position("QB")
                .team("KC")
                .jerseyNumber(15)
                .status("ACTIVE")
                .build();
    }

    @Test
    @DisplayName("getAllPlayers should return paginated players")
    void getAllPlayersShouldReturnPaginatedPlayers() {
        // Arrange
        List<NFLPlayerDocument> players = List.of(testPlayer);
        org.springframework.data.domain.Page<NFLPlayerDocument> springPage =
                new PageImpl<>(players, PageRequest.of(0, 20), 1);
        when(playerRepository.findAll(any(Pageable.class))).thenReturn(springPage);

        // Act
        Page<NFLPlayerDTO> result = playerService.getAllPlayers(0, 20);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getContent().size());
        assertEquals(0, result.getPage());
        assertEquals(20, result.getSize());
        assertEquals(1, result.getTotalElements());
        assertEquals("Patrick Mahomes", result.getContent().get(0).getName());
    }

    @Test
    @DisplayName("getPlayerById should return player when found")
    void getPlayerByIdShouldReturnPlayerWhenFound() {
        // Arrange
        when(playerRepository.findByPlayerId("12345")).thenReturn(Optional.of(testPlayer));

        // Act
        Optional<NFLPlayerDTO> result = playerService.getPlayerById("12345");

        // Assert
        assertTrue(result.isPresent());
        assertEquals("12345", result.get().getPlayerId());
        assertEquals("Patrick Mahomes", result.get().getName());
        assertEquals("QB", result.get().getPosition());
        assertEquals("KC", result.get().getTeam());
    }

    @Test
    @DisplayName("getPlayerById should return empty when not found")
    void getPlayerByIdShouldReturnEmptyWhenNotFound() {
        // Arrange
        when(playerRepository.findByPlayerId("99999")).thenReturn(Optional.empty());

        // Act
        Optional<NFLPlayerDTO> result = playerService.getPlayerById("99999");

        // Assert
        assertTrue(result.isEmpty());
    }

    @Test
    @DisplayName("getPlayersByTeam should return players for team")
    void getPlayersByTeamShouldReturnPlayersForTeam() {
        // Arrange
        List<NFLPlayerDocument> players = List.of(testPlayer);
        org.springframework.data.domain.Page<NFLPlayerDocument> springPage =
                new PageImpl<>(players, PageRequest.of(0, 50), 1);
        when(playerRepository.findByTeam(eq("KC"), any(Pageable.class))).thenReturn(springPage);

        // Act
        Page<NFLPlayerDTO> result = playerService.getPlayersByTeam("KC", 0, 50);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getContent().size());
        assertEquals("KC", result.getContent().get(0).getTeam());
    }

    @Test
    @DisplayName("getPlayersByTeam should convert team to uppercase")
    void getPlayersByTeamShouldConvertToUppercase() {
        // Arrange
        List<NFLPlayerDocument> players = List.of(testPlayer);
        org.springframework.data.domain.Page<NFLPlayerDocument> springPage =
                new PageImpl<>(players, PageRequest.of(0, 50), 1);
        when(playerRepository.findByTeam(eq("KC"), any(Pageable.class))).thenReturn(springPage);

        // Act
        Page<NFLPlayerDTO> result = playerService.getPlayersByTeam("kc", 0, 50);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getContent().size());
    }

    @Test
    @DisplayName("getPlayersByPosition should return players for position")
    void getPlayersByPositionShouldReturnPlayersForPosition() {
        // Arrange
        List<NFLPlayerDocument> players = List.of(testPlayer);
        org.springframework.data.domain.Page<NFLPlayerDocument> springPage =
                new PageImpl<>(players, PageRequest.of(0, 50), 1);
        when(playerRepository.findByPosition(eq("QB"), any(Pageable.class))).thenReturn(springPage);

        // Act
        Page<NFLPlayerDTO> result = playerService.getPlayersByPosition("QB", 0, 50);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getContent().size());
        assertEquals("QB", result.getContent().get(0).getPosition());
    }

    @Test
    @DisplayName("searchPlayersByName should return matching players")
    void searchPlayersByNameShouldReturnMatchingPlayers() {
        // Arrange
        List<NFLPlayerDocument> players = List.of(testPlayer);
        org.springframework.data.domain.Page<NFLPlayerDocument> springPage =
                new PageImpl<>(players, PageRequest.of(0, 20), 1);
        when(playerRepository.findByNameContainingIgnoreCase(eq("Mahomes"), any(Pageable.class)))
                .thenReturn(springPage);

        // Act
        Page<NFLPlayerDTO> result = playerService.searchPlayersByName("Mahomes", 0, 20);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getContent().size());
        assertTrue(result.getContent().get(0).getName().contains("Mahomes"));
    }

    @Test
    @DisplayName("getTotalPlayerCount should return total count")
    void getTotalPlayerCountShouldReturnTotalCount() {
        // Arrange
        when(playerRepository.count()).thenReturn(100L);

        // Act
        long result = playerService.getTotalPlayerCount();

        // Assert
        assertEquals(100L, result);
    }

    @Test
    @DisplayName("getPlayerCountByTeam should return count for team")
    void getPlayerCountByTeamShouldReturnCountForTeam() {
        // Arrange
        when(playerRepository.countByTeam("KC")).thenReturn(53L);

        // Act
        long result = playerService.getPlayerCountByTeam("KC");

        // Assert
        assertEquals(53L, result);
    }

    @Test
    @DisplayName("playerExists should return true when player exists")
    void playerExistsShouldReturnTrueWhenPlayerExists() {
        // Arrange
        when(playerRepository.existsByPlayerId("12345")).thenReturn(true);

        // Act
        boolean result = playerService.playerExists("12345");

        // Assert
        assertTrue(result);
    }

    @Test
    @DisplayName("playerExists should return false when player does not exist")
    void playerExistsShouldReturnFalseWhenPlayerDoesNotExist() {
        // Arrange
        when(playerRepository.existsByPlayerId("99999")).thenReturn(false);

        // Act
        boolean result = playerService.playerExists("99999");

        // Assert
        assertFalse(result);
    }
}
