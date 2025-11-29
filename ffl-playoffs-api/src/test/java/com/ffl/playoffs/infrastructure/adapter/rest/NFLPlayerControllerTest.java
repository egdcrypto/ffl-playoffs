package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.nfl.NFLPlayerDTO;
import com.ffl.playoffs.application.service.NFLPlayerService;
import com.ffl.playoffs.application.service.PlayerStatsService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.test.web.servlet.MockMvc;

import java.util.List;
import java.util.Optional;

import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(NFLPlayerController.class)
@DisplayName("NFLPlayerController Tests")
class NFLPlayerControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private NFLPlayerService playerService;

    @MockBean
    private PlayerStatsService statsService;

    private NFLPlayerDTO testPlayer;
    private Page<NFLPlayerDTO> testPage;

    @BeforeEach
    void setUp() {
        testPlayer = NFLPlayerDTO.builder()
                .playerId("12345")
                .name("Patrick Mahomes")
                .firstName("Patrick")
                .lastName("Mahomes")
                .position("QB")
                .team("KC")
                .jerseyNumber(15)
                .status("ACTIVE")
                .build();

        testPage = new Page<>(
                List.of(testPlayer),
                0,
                20,
                1L,
                1
        );
    }

    @Test
    @DisplayName("GET /api/v1/nfl/players should return paginated players")
    @WithMockUser
    void listPlayersShouldReturnPaginatedPlayers() throws Exception {
        // Arrange
        when(playerService.getAllPlayers(0, 20)).thenReturn(testPage);

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/players")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.content.length()").value(1))
                .andExpect(jsonPath("$.content[0].playerId").value("12345"))
                .andExpect(jsonPath("$.content[0].name").value("Patrick Mahomes"))
                .andExpect(jsonPath("$.page").value(0))
                .andExpect(jsonPath("$.size").value(20))
                .andExpect(jsonPath("$.totalElements").value(1));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/players with pagination params should use them")
    @WithMockUser
    void listPlayersWithPaginationShouldUseParams() throws Exception {
        // Arrange
        Page<NFLPlayerDTO> pagedResult = new Page<>(List.of(testPlayer), 2, 10, 25L, 3);
        when(playerService.getAllPlayers(2, 10)).thenReturn(pagedResult);

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/players")
                        .param("page", "2")
                        .param("size", "10")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.page").value(2))
                .andExpect(jsonPath("$.size").value(10));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/players/{playerId} should return player when found")
    @WithMockUser
    void getPlayerShouldReturnPlayerWhenFound() throws Exception {
        // Arrange
        when(playerService.getPlayerById("12345")).thenReturn(Optional.of(testPlayer));

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/players/12345")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.playerId").value("12345"))
                .andExpect(jsonPath("$.name").value("Patrick Mahomes"))
                .andExpect(jsonPath("$.position").value("QB"))
                .andExpect(jsonPath("$.team").value("KC"));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/players/{playerId} should return 404 when not found")
    @WithMockUser
    void getPlayerShouldReturn404WhenNotFound() throws Exception {
        // Arrange
        when(playerService.getPlayerById("99999")).thenReturn(Optional.empty());

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/players/99999")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("GET /api/v1/nfl/players/team/{team} should return players for team")
    @WithMockUser
    void getPlayersByTeamShouldReturnPlayersForTeam() throws Exception {
        // Arrange
        when(playerService.getPlayersByTeam("KC", 0, 50)).thenReturn(testPage);

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/players/team/KC")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.content[0].team").value("KC"));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/players/position/{position} should return players for position")
    @WithMockUser
    void getPlayersByPositionShouldReturnPlayersForPosition() throws Exception {
        // Arrange
        when(playerService.getPlayersByPosition("QB", 0, 50)).thenReturn(testPage);

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/players/position/QB")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.content[0].position").value("QB"));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/players/search should return matching players")
    @WithMockUser
    void searchPlayersShouldReturnMatchingPlayers() throws Exception {
        // Arrange
        when(playerService.searchPlayersByName("Mahomes", 0, 20)).thenReturn(testPage);

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/players/search")
                        .param("query", "Mahomes")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.content[0].name").value("Patrick Mahomes"));
    }
}
