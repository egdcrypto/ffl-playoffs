package com.ffl.playoffs.application.service;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.nfl.NFLGameDTO;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.NFLGameDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoNFLGameRepository;
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

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("NFLGameService Tests")
class NFLGameServiceTest {

    @Mock
    private MongoNFLGameRepository gameRepository;

    @InjectMocks
    private NFLGameService gameService;

    private NFLGameDocument testGame;

    @BeforeEach
    void setUp() {
        testGame = NFLGameDocument.builder()
                .gameId("2024-15-KC-BUF")
                .season(2024)
                .week(15)
                .homeTeam("KC")
                .awayTeam("BUF")
                .homeScore(27)
                .awayScore(24)
                .gameTime(LocalDateTime.of(2024, 12, 15, 13, 0))
                .status("FINAL")
                .quarter("FINAL")
                .venue("Arrowhead Stadium")
                .build();
    }

    @Test
    @DisplayName("getAllGames should return paginated games")
    void getAllGamesShouldReturnPaginatedGames() {
        // Arrange
        List<NFLGameDocument> games = List.of(testGame);
        org.springframework.data.domain.Page<NFLGameDocument> springPage =
                new PageImpl<>(games, PageRequest.of(0, 20), 1);
        when(gameRepository.findAll(any(Pageable.class))).thenReturn(springPage);

        // Act
        Page<NFLGameDTO> result = gameService.getAllGames(0, 20);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getContent().size());
        assertEquals(0, result.getPage());
        assertEquals(20, result.getSize());
        assertEquals(1, result.getTotalElements());
    }

    @Test
    @DisplayName("getGameById should return game when found")
    void getGameByIdShouldReturnGameWhenFound() {
        // Arrange
        when(gameRepository.findByGameId("2024-15-KC-BUF")).thenReturn(Optional.of(testGame));

        // Act
        Optional<NFLGameDTO> result = gameService.getGameById("2024-15-KC-BUF");

        // Assert
        assertTrue(result.isPresent());
        assertEquals("2024-15-KC-BUF", result.get().getGameId());
        assertEquals("KC", result.get().getHomeTeam());
        assertEquals("BUF", result.get().getAwayTeam());
        assertEquals(27, result.get().getHomeScore());
        assertEquals(24, result.get().getAwayScore());
    }

    @Test
    @DisplayName("getGameById should return empty when not found")
    void getGameByIdShouldReturnEmptyWhenNotFound() {
        // Arrange
        when(gameRepository.findByGameId("nonexistent")).thenReturn(Optional.empty());

        // Act
        Optional<NFLGameDTO> result = gameService.getGameById("nonexistent");

        // Assert
        assertTrue(result.isEmpty());
    }

    @Test
    @DisplayName("getGamesByWeek should return games for specific week")
    void getGamesByWeekShouldReturnGamesForWeek() {
        // Arrange
        List<NFLGameDocument> games = List.of(testGame);
        when(gameRepository.findBySeasonAndWeek(2024, 15)).thenReturn(games);

        // Act
        List<NFLGameDTO> result = gameService.getGamesByWeek(2024, 15);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(15, result.get(0).getWeek());
        assertEquals(2024, result.get(0).getSeason());
    }

    @Test
    @DisplayName("getGames with season and week should return filtered games")
    void getGamesWithSeasonAndWeekShouldReturnFilteredGames() {
        // Arrange
        List<NFLGameDocument> games = List.of(testGame);
        when(gameRepository.findBySeasonAndWeek(2024, 15)).thenReturn(games);

        // Act
        Page<NFLGameDTO> result = gameService.getGames(2024, 15, 0, 20);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getContent().size());
        assertEquals(0, result.getPage());
    }

    @Test
    @DisplayName("getGames with only season should return paginated games")
    void getGamesWithOnlySeasonShouldReturnPaginatedGames() {
        // Arrange
        List<NFLGameDocument> games = List.of(testGame);
        org.springframework.data.domain.Page<NFLGameDocument> springPage =
                new PageImpl<>(games, PageRequest.of(0, 20), 1);
        when(gameRepository.findBySeason(eq(2024), any(Pageable.class))).thenReturn(springPage);

        // Act
        Page<NFLGameDTO> result = gameService.getGames(2024, null, 0, 20);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getContent().size());
    }

    @Test
    @DisplayName("getActiveGames should return in-progress games")
    void getActiveGamesShouldReturnInProgressGames() {
        // Arrange
        NFLGameDocument activeGame = NFLGameDocument.builder()
                .gameId("2024-15-SF-SEA")
                .status("IN_PROGRESS")
                .build();
        when(gameRepository.findActiveGames()).thenReturn(List.of(activeGame));

        // Act
        List<NFLGameDTO> result = gameService.getActiveGames();

        // Assert
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals("IN_PROGRESS", result.get(0).getStatus());
    }

    @Test
    @DisplayName("getGamesByStatus should return games with specific status")
    void getGamesByStatusShouldReturnGamesWithSpecificStatus() {
        // Arrange
        when(gameRepository.findByStatus("FINAL")).thenReturn(List.of(testGame));

        // Act
        List<NFLGameDTO> result = gameService.getGamesByStatus("final");

        // Assert
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals("FINAL", result.get(0).getStatus());
    }

    @Test
    @DisplayName("getGamesByTeam should return games for team")
    void getGamesByTeamShouldReturnGamesForTeam() {
        // Arrange
        when(gameRepository.findByTeamAndSeason("KC", 2024)).thenReturn(List.of(testGame));

        // Act
        List<NFLGameDTO> result = gameService.getGamesByTeam("kc", 2024);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.size());
        assertTrue(result.get(0).getHomeTeam().equals("KC") || result.get(0).getAwayTeam().equals("KC"));
    }

    @Test
    @DisplayName("getTotalGameCount should return total count")
    void getTotalGameCountShouldReturnTotalCount() {
        // Arrange
        when(gameRepository.count()).thenReturn(272L);

        // Act
        long result = gameService.getTotalGameCount();

        // Assert
        assertEquals(272L, result);
    }

    @Test
    @DisplayName("getGameCountBySeason should return count for season")
    void getGameCountBySeasonShouldReturnCountForSeason() {
        // Arrange
        when(gameRepository.countBySeason(2024)).thenReturn(272L);

        // Act
        long result = gameService.getGameCountBySeason(2024);

        // Assert
        assertEquals(272L, result);
    }

    @Test
    @DisplayName("getGameCountByWeek should return count for week")
    void getGameCountByWeekShouldReturnCountForWeek() {
        // Arrange
        when(gameRepository.countBySeasonAndWeek(2024, 15)).thenReturn(16L);

        // Act
        long result = gameService.getGameCountByWeek(2024, 15);

        // Assert
        assertEquals(16L, result);
    }

    @Test
    @DisplayName("gameExists should return true when game exists")
    void gameExistsShouldReturnTrueWhenGameExists() {
        // Arrange
        when(gameRepository.existsByGameId("2024-15-KC-BUF")).thenReturn(true);

        // Act
        boolean result = gameService.gameExists("2024-15-KC-BUF");

        // Assert
        assertTrue(result);
    }
}
