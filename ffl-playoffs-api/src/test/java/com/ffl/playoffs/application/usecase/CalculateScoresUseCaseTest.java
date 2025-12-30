package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.port.LiveScoreRepository;
import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.domain.port.TeamSelectionRepository;
import com.ffl.playoffs.domain.service.ScoringService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ApplicationEventPublisher;

import java.util.*;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("CalculateScoresUseCase Tests")
class CalculateScoresUseCaseTest {

    @Mock
    private ScoringService scoringService;

    @Mock
    private NflDataProvider nflDataProvider;

    @Mock
    private TeamSelectionRepository teamSelectionRepository;

    @Mock
    private LiveScoreRepository liveScoreRepository;

    @Mock
    private ApplicationEventPublisher eventPublisher;

    @InjectMocks
    private CalculateScoresUseCase useCase;

    private Long weekId;
    private int season;

    @BeforeEach
    void setUp() {
        weekId = 15L;
        season = 2024;
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should calculate and save scores for week")
        void shouldCalculateAndSaveScores() {
            // Arrange
            TeamSelection selection = TeamSelection.builder()
                    .id(1L)
                    .playerId(100L)
                    .weekId(weekId)
                    .nflTeam("KC")
                    .build();

            Score score = Score.builder()
                    .id(1L)
                    .playerId(100L)
                    .weekId(weekId)
                    .totalScore(25.5)
                    .rank(1)
                    .build();

            when(teamSelectionRepository.findByWeekId(any(UUID.class))).thenReturn(List.of(selection));
            when(nflDataProvider.getTeamPlayerStats("KC", 15, 2024)).thenReturn(Map.of("passing_yards", 300));
            when(scoringService.calculateWeekScores(eq(weekId), anyMap())).thenReturn(List.of(score));
            when(scoringService.determineEliminatedPlayers(anyList())).thenReturn(List.of());

            // Act
            List<Score> result = useCase.execute(weekId, season);

            // Assert
            assertNotNull(result);
            assertEquals(1, result.size());
            assertEquals(25.5, result.get(0).getTotalScore());

            verify(scoringService).calculateWeekScores(eq(weekId), anyMap());
            verify(scoringService).rankScores(anyList());
            verify(liveScoreRepository).saveAll(anyList());
        }

        @Test
        @DisplayName("should return empty list when no selections")
        void shouldReturnEmptyWhenNoSelections() {
            // Arrange
            when(teamSelectionRepository.findByWeekId(any(UUID.class))).thenReturn(List.of());
            when(scoringService.calculateWeekScores(eq(weekId), eq(Map.of()))).thenReturn(List.of());
            when(scoringService.determineEliminatedPlayers(anyList())).thenReturn(List.of());

            // Act
            List<Score> result = useCase.execute(weekId, season);

            // Assert
            assertNotNull(result);
            assertTrue(result.isEmpty());
        }

        @Test
        @DisplayName("should mark eliminated players and publish events")
        void shouldMarkEliminatedPlayers() {
            // Arrange
            TeamSelection selection = TeamSelection.builder()
                    .id(1L)
                    .playerId(100L)
                    .weekId(weekId)
                    .nflTeam("KC")
                    .build();

            Score score = Score.builder()
                    .id(1L)
                    .playerId(100L)
                    .weekId(weekId)
                    .totalScore(10.0)
                    .rank(8)
                    .build();

            when(teamSelectionRepository.findByWeekId(any(UUID.class))).thenReturn(List.of(selection));
            when(nflDataProvider.getTeamPlayerStats("KC", 15, 2024)).thenReturn(Map.of());
            when(scoringService.calculateWeekScores(eq(weekId), anyMap())).thenReturn(List.of(score));
            when(scoringService.determineEliminatedPlayers(anyList())).thenReturn(List.of(100L));

            // Act
            List<Score> result = useCase.execute(weekId, season);

            // Assert
            assertEquals(1, result.size());
            assertTrue(result.get(0).isEliminated());

            verify(eventPublisher).publishEvent(any(CalculateScoresUseCase.PlayerEliminatedEvent.class));
        }

        @Test
        @DisplayName("should handle NFL data provider errors gracefully")
        void shouldHandleNflDataErrors() {
            // Arrange
            TeamSelection selection = TeamSelection.builder()
                    .id(1L)
                    .playerId(100L)
                    .weekId(weekId)
                    .nflTeam("KC")
                    .build();

            when(teamSelectionRepository.findByWeekId(any(UUID.class))).thenReturn(List.of(selection));
            when(nflDataProvider.getTeamPlayerStats("KC", 15, 2024)).thenThrow(new RuntimeException("API Error"));
            when(scoringService.calculateWeekScores(eq(weekId), anyMap())).thenReturn(List.of());
            when(scoringService.determineEliminatedPlayers(anyList())).thenReturn(List.of());

            // Act - should not throw
            List<Score> result = useCase.execute(weekId, season);

            // Assert
            assertNotNull(result);
            verify(scoringService).calculateWeekScores(eq(weekId), anyMap());
        }
    }
}
