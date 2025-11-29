package com.ffl.playoffs.application.service;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.nfl.PlayerStatsDTO;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.PlayerStatsDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoPlayerStatsRepository;
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
@DisplayName("PlayerStatsService Tests")
class PlayerStatsServiceTest {

    @Mock
    private MongoPlayerStatsRepository statsRepository;

    @InjectMocks
    private PlayerStatsService statsService;

    private PlayerStatsDocument testStats;

    @BeforeEach
    void setUp() {
        testStats = PlayerStatsDocument.builder()
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
                .build();
    }

    @Test
    @DisplayName("getStatsByWeek should return paginated stats")
    void getStatsByWeekShouldReturnPaginatedStats() {
        // Arrange
        List<PlayerStatsDocument> stats = List.of(testStats);
        org.springframework.data.domain.Page<PlayerStatsDocument> springPage =
                new PageImpl<>(stats, PageRequest.of(0, 50), 1);
        when(statsRepository.findBySeasonAndWeek(eq(2024), eq(15), any(Pageable.class)))
                .thenReturn(springPage);

        // Act
        Page<PlayerStatsDTO> result = statsService.getStatsByWeek(2024, 15, 0, 50);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getContent().size());
        assertEquals(0, result.getPage());
        assertEquals(50, result.getSize());
        assertEquals(1, result.getTotalElements());
    }

    @Test
    @DisplayName("getAllStatsByWeek should return all stats for week")
    void getAllStatsByWeekShouldReturnAllStatsForWeek() {
        // Arrange
        List<PlayerStatsDocument> stats = List.of(testStats);
        when(statsRepository.findBySeasonAndWeek(2024, 15)).thenReturn(stats);

        // Act
        List<PlayerStatsDTO> result = statsService.getAllStatsByWeek(2024, 15);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(15, result.get(0).getWeek());
        assertEquals(2024, result.get(0).getSeason());
    }

    @Test
    @DisplayName("getStatsByPlayer should return paginated stats for player")
    void getStatsByPlayerShouldReturnPaginatedStatsForPlayer() {
        // Arrange
        List<PlayerStatsDocument> stats = List.of(testStats);
        org.springframework.data.domain.Page<PlayerStatsDocument> springPage =
                new PageImpl<>(stats, PageRequest.of(0, 20), 1);
        when(statsRepository.findByPlayerId(eq("12345"), any(Pageable.class)))
                .thenReturn(springPage);

        // Act
        Page<PlayerStatsDTO> result = statsService.getStatsByPlayer("12345", 0, 20);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.getContent().size());
        assertEquals("12345", result.getContent().get(0).getPlayerId());
    }

    @Test
    @DisplayName("getAllStatsByPlayer should return all stats for player")
    void getAllStatsByPlayerShouldReturnAllStatsForPlayer() {
        // Arrange
        when(statsRepository.findByPlayerId("12345")).thenReturn(List.of(testStats));

        // Act
        List<PlayerStatsDTO> result = statsService.getAllStatsByPlayer("12345");

        // Assert
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals("12345", result.get(0).getPlayerId());
    }

    @Test
    @DisplayName("getStatsByPlayerAndSeason should return stats for player in season")
    void getStatsByPlayerAndSeasonShouldReturnStatsForPlayerInSeason() {
        // Arrange
        when(statsRepository.findByPlayerIdAndSeason("12345", 2024)).thenReturn(List.of(testStats));

        // Act
        List<PlayerStatsDTO> result = statsService.getStatsByPlayerAndSeason("12345", 2024);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals(2024, result.get(0).getSeason());
    }

    @Test
    @DisplayName("getStatsByPlayerAndWeek should return stats when found")
    void getStatsByPlayerAndWeekShouldReturnStatsWhenFound() {
        // Arrange
        when(statsRepository.findByPlayerIdAndSeasonAndWeek("12345", 2024, 15))
                .thenReturn(Optional.of(testStats));

        // Act
        Optional<PlayerStatsDTO> result = statsService.getStatsByPlayerAndWeek("12345", 2024, 15);

        // Assert
        assertTrue(result.isPresent());
        assertEquals("12345", result.get().getPlayerId());
        assertEquals(15, result.get().getWeek());
        assertEquals(350, result.get().getPassingYards());
        assertEquals(3, result.get().getPassingTds());
    }

    @Test
    @DisplayName("getStatsByPlayerAndWeek should return empty when not found")
    void getStatsByPlayerAndWeekShouldReturnEmptyWhenNotFound() {
        // Arrange
        when(statsRepository.findByPlayerIdAndSeasonAndWeek("12345", 2024, 20))
                .thenReturn(Optional.empty());

        // Act
        Optional<PlayerStatsDTO> result = statsService.getStatsByPlayerAndWeek("12345", 2024, 20);

        // Assert
        assertTrue(result.isEmpty());
    }

    @Test
    @DisplayName("getStatsByPosition should return stats for position")
    void getStatsByPositionShouldReturnStatsForPosition() {
        // Arrange
        when(statsRepository.findByPositionAndSeasonAndWeek("QB", 2024, 15))
                .thenReturn(List.of(testStats));

        // Act
        List<PlayerStatsDTO> result = statsService.getStatsByPosition("qb", 2024, 15);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals("QB", result.get(0).getPosition());
    }

    @Test
    @DisplayName("getStatsByTeam should return stats for team")
    void getStatsByTeamShouldReturnStatsForTeam() {
        // Arrange
        when(statsRepository.findByTeamAndSeasonAndWeek("KC", 2024, 15))
                .thenReturn(List.of(testStats));

        // Act
        List<PlayerStatsDTO> result = statsService.getStatsByTeam("kc", 2024, 15);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.size());
        assertEquals("KC", result.get(0).getTeam());
    }

    @Test
    @DisplayName("getTopScorersByWeek should return top scorers")
    void getTopScorersByWeekShouldReturnTopScorers() {
        // Arrange
        List<PlayerStatsDocument> stats = List.of(testStats);
        org.springframework.data.domain.Page<PlayerStatsDocument> springPage =
                new PageImpl<>(stats, PageRequest.of(0, 10), 1);
        when(statsRepository.findTopScorersByWeek(eq(2024), eq(15), any(Pageable.class)))
                .thenReturn(springPage);

        // Act
        List<PlayerStatsDTO> result = statsService.getTopScorersByWeek(2024, 15, 10);

        // Assert
        assertNotNull(result);
        assertEquals(1, result.size());
    }

    @Test
    @DisplayName("getStatsCountBySeason should return count for season")
    void getStatsCountBySeasonShouldReturnCountForSeason() {
        // Arrange
        when(statsRepository.countBySeason(2024)).thenReturn(5000L);

        // Act
        long result = statsService.getStatsCountBySeason(2024);

        // Assert
        assertEquals(5000L, result);
    }

    @Test
    @DisplayName("getStatsCountByWeek should return count for week")
    void getStatsCountByWeekShouldReturnCountForWeek() {
        // Arrange
        when(statsRepository.countBySeasonAndWeek(2024, 15)).thenReturn(300L);

        // Act
        long result = statsService.getStatsCountByWeek(2024, 15);

        // Assert
        assertEquals(300L, result);
    }

    @Test
    @DisplayName("statsExist should return true when stats exist")
    void statsExistShouldReturnTrueWhenStatsExist() {
        // Arrange
        when(statsRepository.existsByPlayerIdAndSeasonAndWeek("12345", 2024, 15))
                .thenReturn(true);

        // Act
        boolean result = statsService.statsExist("12345", 2024, 15);

        // Assert
        assertTrue(result);
    }

    @Test
    @DisplayName("Fantasy points should be calculated correctly")
    void fantasyPointsShouldBeCalculatedCorrectly() {
        // Arrange
        when(statsRepository.findByPlayerIdAndSeasonAndWeek("12345", 2024, 15))
                .thenReturn(Optional.of(testStats));

        // Act
        Optional<PlayerStatsDTO> result = statsService.getStatsByPlayerAndWeek("12345", 2024, 15);

        // Assert
        assertTrue(result.isPresent());
        PlayerStatsDTO stats = result.get();

        // Standard: 350*0.04 + 3*4 - 1*2 + 25*0.1 = 14 + 12 - 2 + 2.5 = 26.5
        assertEquals(26.5, stats.getFantasyPoints());

        // PPR should be same as standard for QB (no receptions)
        assertEquals(26.5, stats.getPprFantasyPoints());
    }
}
