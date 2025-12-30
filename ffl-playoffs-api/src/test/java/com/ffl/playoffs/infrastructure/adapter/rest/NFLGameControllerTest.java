package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.nfl.NFLGameDTO;
import com.ffl.playoffs.application.service.NFLGameService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(NFLGameController.class)
@DisplayName("NFLGameController Tests")
class NFLGameControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private NFLGameService gameService;

    private NFLGameDTO testGame;
    private Page<NFLGameDTO> testPage;

    @BeforeEach
    void setUp() {
        testGame = NFLGameDTO.builder()
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

        testPage = new Page<>(
                List.of(testGame),
                0,
                20,
                1L
        );
    }

    @Test
    @DisplayName("GET /api/v1/nfl/games should return paginated games")
    @WithMockUser
    void listGamesShouldReturnPaginatedGames() throws Exception {
        // Arrange
        when(gameService.getGames(null, null, 0, 20)).thenReturn(testPage);

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/games")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.content.length()").value(1))
                .andExpect(jsonPath("$.content[0].gameId").value("2024-15-KC-BUF"))
                .andExpect(jsonPath("$.page").value(0))
                .andExpect(jsonPath("$.size").value(20));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/games with season filter should use filter")
    @WithMockUser
    void listGamesWithSeasonFilterShouldUseFilter() throws Exception {
        // Arrange
        when(gameService.getGames(2024, null, 0, 20)).thenReturn(testPage);

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/games")
                        .param("season", "2024")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content[0].season").value(2024));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/games with season and week should use filters")
    @WithMockUser
    void listGamesWithSeasonAndWeekShouldUseFilters() throws Exception {
        // Arrange
        when(gameService.getGames(2024, 15, 0, 20)).thenReturn(testPage);

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/games")
                        .param("season", "2024")
                        .param("week", "15")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content[0].week").value(15));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/games/{gameId} should return game when found")
    @WithMockUser
    void getGameShouldReturnGameWhenFound() throws Exception {
        // Arrange
        when(gameService.getGameById("2024-15-KC-BUF")).thenReturn(Optional.of(testGame));

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/games/2024-15-KC-BUF")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.gameId").value("2024-15-KC-BUF"))
                .andExpect(jsonPath("$.homeTeam").value("KC"))
                .andExpect(jsonPath("$.awayTeam").value("BUF"))
                .andExpect(jsonPath("$.homeScore").value(27))
                .andExpect(jsonPath("$.awayScore").value(24));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/games/{gameId} should return 404 when not found")
    @WithMockUser
    void getGameShouldReturn404WhenNotFound() throws Exception {
        // Arrange
        when(gameService.getGameById("nonexistent")).thenReturn(Optional.empty());

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/games/nonexistent")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("GET /api/v1/nfl/games/week/{season}/{week} should return games for week")
    @WithMockUser
    void getGamesByWeekShouldReturnGamesForWeek() throws Exception {
        // Arrange
        when(gameService.getGamesByWeek(2024, 15)).thenReturn(List.of(testGame));

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/games/week/2024/15")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$.length()").value(1))
                .andExpect(jsonPath("$[0].season").value(2024))
                .andExpect(jsonPath("$[0].week").value(15));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/games/active should return active games")
    @WithMockUser
    void getActiveGamesShouldReturnActiveGames() throws Exception {
        // Arrange
        NFLGameDTO activeGame = NFLGameDTO.builder()
                .gameId("2024-15-SF-SEA")
                .status("IN_PROGRESS")
                .build();
        when(gameService.getActiveGames()).thenReturn(List.of(activeGame));

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/games/active")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].status").value("IN_PROGRESS"));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/games/status/{status} should return games by status")
    @WithMockUser
    void getGamesByStatusShouldReturnGamesByStatus() throws Exception {
        // Arrange
        when(gameService.getGamesByStatus("FINAL")).thenReturn(List.of(testGame));

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/games/status/FINAL")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].status").value("FINAL"));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/games/team/{team}/season/{season} should return games for team")
    @WithMockUser
    void getGamesByTeamShouldReturnGamesForTeam() throws Exception {
        // Arrange
        when(gameService.getGamesByTeam("KC", 2024)).thenReturn(List.of(testGame));

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/games/team/KC/season/2024")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].homeTeam").value("KC"));
    }
}
