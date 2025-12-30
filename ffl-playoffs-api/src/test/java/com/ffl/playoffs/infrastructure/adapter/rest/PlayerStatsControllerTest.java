package com.ffl.playoffs.infrastructure.adapter.rest;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.nfl.PlayerStatsDTO;
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

import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

@WebMvcTest(PlayerStatsController.class)
@DisplayName("PlayerStatsController Tests")
class PlayerStatsControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockBean
    private PlayerStatsService statsService;

    private PlayerStatsDTO testStats;

    @BeforeEach
    void setUp() {
        testStats = PlayerStatsDTO.builder()
                .playerId("12345")
                .playerName("Patrick Mahomes")
                .season(2024)
                .week(15)
                .team("KC")
                .position("QB")
                .passingYards(350)
                .passingTds(3)
                .interceptions(1)
                .rushingYards(25)
                .rushingTds(0)
                .fantasyPoints(26.5)
                .pprFantasyPoints(26.5)
                .halfPprFantasyPoints(26.5)
                .build();
    }

    @Test
    @DisplayName("GET /api/v1/nfl/stats/week/{season}/{week} should return stats for week")
    @WithMockUser
    void getStatsByWeekShouldReturnStatsForWeek() throws Exception {
        // Arrange
        when(statsService.getAllStatsByWeek(2024, 15)).thenReturn(List.of(testStats));

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/stats/week/2024/15")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$.length()").value(1))
                .andExpect(jsonPath("$[0].playerId").value("12345"))
                .andExpect(jsonPath("$[0].season").value(2024))
                .andExpect(jsonPath("$[0].week").value(15));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/stats/week/{season}/{week}/paged should return paginated stats")
    @WithMockUser
    void getStatsByWeekPagedShouldReturnPaginatedStats() throws Exception {
        // Arrange
        Page<PlayerStatsDTO> testPage = new Page<>(List.of(testStats), 0, 50, 1L);
        when(statsService.getStatsByWeek(2024, 15, 0, 50)).thenReturn(testPage);

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/stats/week/2024/15/paged")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.content").isArray())
                .andExpect(jsonPath("$.content.length()").value(1))
                .andExpect(jsonPath("$.page").value(0))
                .andExpect(jsonPath("$.size").value(50));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/stats/player/{playerId} should return stats for player")
    @WithMockUser
    void getStatsByPlayerShouldReturnStatsForPlayer() throws Exception {
        // Arrange
        when(statsService.getAllStatsByPlayer("12345")).thenReturn(List.of(testStats));

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/stats/player/12345")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].playerId").value("12345"))
                .andExpect(jsonPath("$[0].playerName").value("Patrick Mahomes"));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/stats/player/{playerId}/season/{season} should return stats for player in season")
    @WithMockUser
    void getStatsByPlayerAndSeasonShouldReturnStats() throws Exception {
        // Arrange
        when(statsService.getStatsByPlayerAndSeason("12345", 2024)).thenReturn(List.of(testStats));

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/stats/player/12345/season/2024")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].season").value(2024));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/stats/player/{playerId}/week/{season}/{week} should return stats when found")
    @WithMockUser
    void getStatsByPlayerAndWeekShouldReturnStatsWhenFound() throws Exception {
        // Arrange
        when(statsService.getStatsByPlayerAndWeek("12345", 2024, 15)).thenReturn(Optional.of(testStats));

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/stats/player/12345/week/2024/15")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.playerId").value("12345"))
                .andExpect(jsonPath("$.passingYards").value(350))
                .andExpect(jsonPath("$.passingTds").value(3))
                .andExpect(jsonPath("$.fantasyPoints").value(26.5));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/stats/player/{playerId}/week/{season}/{week} should return 404 when not found")
    @WithMockUser
    void getStatsByPlayerAndWeekShouldReturn404WhenNotFound() throws Exception {
        // Arrange
        when(statsService.getStatsByPlayerAndWeek("12345", 2024, 20)).thenReturn(Optional.empty());

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/stats/player/12345/week/2024/20")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isNotFound());
    }

    @Test
    @DisplayName("GET /api/v1/nfl/stats/position/{position}/week/{season}/{week} should return stats by position")
    @WithMockUser
    void getStatsByPositionShouldReturnStatsByPosition() throws Exception {
        // Arrange
        when(statsService.getStatsByPosition("QB", 2024, 15)).thenReturn(List.of(testStats));

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/stats/position/QB/week/2024/15")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].position").value("QB"));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/stats/team/{team}/week/{season}/{week} should return stats by team")
    @WithMockUser
    void getStatsByTeamShouldReturnStatsByTeam() throws Exception {
        // Arrange
        when(statsService.getStatsByTeam("KC", 2024, 15)).thenReturn(List.of(testStats));

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/stats/team/KC/week/2024/15")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].team").value("KC"));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/stats/top-scorers/week/{season}/{week} should return top scorers")
    @WithMockUser
    void getTopScorersByWeekShouldReturnTopScorers() throws Exception {
        // Arrange
        when(statsService.getTopScorersByWeek(2024, 15, 10)).thenReturn(List.of(testStats));

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/stats/top-scorers/week/2024/15")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$").isArray())
                .andExpect(jsonPath("$[0].playerName").value("Patrick Mahomes"));
    }

    @Test
    @DisplayName("GET /api/v1/nfl/stats/top-scorers/week/{season}/{week} with limit should use limit")
    @WithMockUser
    void getTopScorersByWeekWithLimitShouldUseLimit() throws Exception {
        // Arrange
        when(statsService.getTopScorersByWeek(2024, 15, 5)).thenReturn(List.of(testStats));

        // Act & Assert
        mockMvc.perform(get("/api/v1/nfl/stats/top-scorers/week/2024/15")
                        .param("limit", "5")
                        .contentType(MediaType.APPLICATION_JSON))
                .andExpect(status().isOk());
    }
}
