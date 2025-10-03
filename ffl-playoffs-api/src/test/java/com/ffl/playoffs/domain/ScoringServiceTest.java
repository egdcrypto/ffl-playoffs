package com.ffl.playoffs.domain;

import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.domain.service.ScoringService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.when;

/**
 * Unit tests for ScoringService.
 */
class ScoringServiceTest {

    @Mock
    private NflDataProvider nflDataProvider;

    private ScoringService scoringService;

    @BeforeEach
    void setUp() {
        MockitoAnnotations.openMocks(this);
        scoringService = new ScoringService(nflDataProvider);
    }

    @Test
    void testCalculateScore_withValidStats() {
        // Arrange
        UUID teamSelectionId = UUID.randomUUID();
        String teamCode = "KC";
        int nflWeek = 1;
        int season = 2025;

        Map<String, Object> mockStats = new HashMap<>();
        mockStats.put("passingYards", 300.0);
        mockStats.put("passingTouchdowns", 3.0);
        mockStats.put("interceptions", 1.0);
        mockStats.put("rushingYards", 120.0);
        mockStats.put("rushingTouchdowns", 2.0);

        when(nflDataProvider.getTeamStats(teamCode, nflWeek, season)).thenReturn(mockStats);

        // Act
        Score score = scoringService.calculateScore(teamSelectionId, teamCode, nflWeek, season);

        // Assert
        assertNotNull(score);
        assertEquals(teamSelectionId, score.getTeamSelectionId());
        assertTrue(score.getTotalScore() > 0);
    }

    @Test
    void testCalculateScore_withNoStats() {
        // Arrange
        UUID teamSelectionId = UUID.randomUUID();
        String teamCode = "KC";
        int nflWeek = 1;
        int season = 2025;

        Map<String, Object> emptyStats = new HashMap<>();
        when(nflDataProvider.getTeamStats(teamCode, nflWeek, season)).thenReturn(emptyStats);

        // Act
        Score score = scoringService.calculateScore(teamSelectionId, teamCode, nflWeek, season);

        // Assert
        assertNotNull(score);
        assertEquals(0.0, score.getTotalScore());
    }
}
