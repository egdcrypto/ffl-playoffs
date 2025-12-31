package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.port.NflDataProvider;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("FetchNFLScheduleUseCase Tests")
class FetchNFLScheduleUseCaseTest {

    @Mock
    private NflDataProvider nflDataProvider;

    private FetchNFLScheduleUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new FetchNFLScheduleUseCase(nflDataProvider);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should fetch schedule for specific week and season")
        void shouldFetchScheduleForSpecificWeekAndSeason() {
            // Arrange
            Integer week = 15;
            Integer season = 2024;
            List<String> playoffTeams = List.of("KC", "BUF", "BAL", "HOU", "DET", "PHI", "SF", "TB");

            FetchNFLScheduleUseCase.FetchScheduleCommand command =
                    new FetchNFLScheduleUseCase.FetchScheduleCommand(week, season);

            when(nflDataProvider.getPlayoffTeams(season)).thenReturn(playoffTeams);

            // Act
            FetchNFLScheduleUseCase.ScheduleResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(week, result.getWeek());
            assertEquals(season, result.getSeason());
            assertEquals(8, result.getPlayoffTeams().size());
            assertTrue(result.getPlayoffTeams().contains("KC"));
            verify(nflDataProvider).getPlayoffTeams(season);
        }

        @Test
        @DisplayName("should use default week when null provided")
        void shouldUseDefaultWeekWhenNullProvided() {
            // Arrange
            FetchNFLScheduleUseCase.FetchScheduleCommand command =
                    new FetchNFLScheduleUseCase.FetchScheduleCommand(null, 2024);

            when(nflDataProvider.getPlayoffTeams(2024)).thenReturn(List.of("KC"));

            // Act
            FetchNFLScheduleUseCase.ScheduleResult result = useCase.execute(command);

            // Assert
            assertEquals(1, result.getWeek()); // Default week
            assertEquals(2024, result.getSeason());
        }

        @Test
        @DisplayName("should use default season when null provided")
        void shouldUseDefaultSeasonWhenNullProvided() {
            // Arrange
            FetchNFLScheduleUseCase.FetchScheduleCommand command =
                    new FetchNFLScheduleUseCase.FetchScheduleCommand(15, null);

            when(nflDataProvider.getPlayoffTeams(2024)).thenReturn(List.of("KC"));

            // Act
            FetchNFLScheduleUseCase.ScheduleResult result = useCase.execute(command);

            // Assert
            assertEquals(15, result.getWeek());
            assertEquals(2024, result.getSeason()); // Default season
        }

        @Test
        @DisplayName("should handle empty playoff teams list")
        void shouldHandleEmptyPlayoffTeamsList() {
            // Arrange
            FetchNFLScheduleUseCase.FetchScheduleCommand command =
                    new FetchNFLScheduleUseCase.FetchScheduleCommand(15, 2024);

            when(nflDataProvider.getPlayoffTeams(2024)).thenReturn(new ArrayList<>());

            // Act
            FetchNFLScheduleUseCase.ScheduleResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertTrue(result.getPlayoffTeams().isEmpty());
        }
    }

    @Nested
    @DisplayName("executeCurrentWeek")
    class ExecuteCurrentWeek {

        @Test
        @DisplayName("should use default week and season values")
        void shouldUseDefaultWeekAndSeasonValues() {
            // Arrange
            List<String> playoffTeams = List.of("KC", "BUF");
            when(nflDataProvider.getPlayoffTeams(2024)).thenReturn(playoffTeams);

            // Act
            FetchNFLScheduleUseCase.ScheduleResult result = useCase.executeCurrentWeek();

            // Assert
            assertNotNull(result);
            assertEquals(1, result.getWeek()); // Default week
            assertEquals(2024, result.getSeason()); // Default season
            verify(nflDataProvider).getPlayoffTeams(2024);
        }

        @Test
        @DisplayName("should return playoff teams for current season")
        void shouldReturnPlayoffTeamsForCurrentSeason() {
            // Arrange
            List<String> playoffTeams = List.of("KC", "BUF", "BAL", "HOU");
            when(nflDataProvider.getPlayoffTeams(2024)).thenReturn(playoffTeams);

            // Act
            FetchNFLScheduleUseCase.ScheduleResult result = useCase.executeCurrentWeek();

            // Assert
            assertEquals(4, result.getPlayoffTeams().size());
            assertTrue(result.getPlayoffTeams().containsAll(playoffTeams));
        }
    }

    @Nested
    @DisplayName("FetchScheduleCommand")
    class FetchScheduleCommandTests {

        @Test
        @DisplayName("should create command with week and season")
        void shouldCreateCommandWithWeekAndSeason() {
            // Arrange & Act
            FetchNFLScheduleUseCase.FetchScheduleCommand command =
                    new FetchNFLScheduleUseCase.FetchScheduleCommand(16, 2024);

            // Assert
            assertEquals(16, command.getWeek());
            assertEquals(2024, command.getSeason());
        }

        @Test
        @DisplayName("should allow null week")
        void shouldAllowNullWeek() {
            // Arrange & Act
            FetchNFLScheduleUseCase.FetchScheduleCommand command =
                    new FetchNFLScheduleUseCase.FetchScheduleCommand(null, 2024);

            // Assert
            assertNull(command.getWeek());
            assertEquals(2024, command.getSeason());
        }

        @Test
        @DisplayName("should allow null season")
        void shouldAllowNullSeason() {
            // Arrange & Act
            FetchNFLScheduleUseCase.FetchScheduleCommand command =
                    new FetchNFLScheduleUseCase.FetchScheduleCommand(15, null);

            // Assert
            assertEquals(15, command.getWeek());
            assertNull(command.getSeason());
        }
    }

    @Nested
    @DisplayName("ScheduleResult")
    class ScheduleResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            List<String> playoffTeams = List.of("KC", "BUF", "BAL");

            // Act
            FetchNFLScheduleUseCase.ScheduleResult result =
                    new FetchNFLScheduleUseCase.ScheduleResult(15, 2024, playoffTeams);

            // Assert
            assertEquals(15, result.getWeek());
            assertEquals(2024, result.getSeason());
            assertEquals(3, result.getPlayoffTeams().size());
            assertTrue(result.getPlayoffTeams().contains("KC"));
        }

        @Test
        @DisplayName("should handle empty playoff teams list")
        void shouldHandleEmptyPlayoffTeamsList() {
            // Arrange & Act
            FetchNFLScheduleUseCase.ScheduleResult result =
                    new FetchNFLScheduleUseCase.ScheduleResult(15, 2024, new ArrayList<>());

            // Assert
            assertNotNull(result.getPlayoffTeams());
            assertTrue(result.getPlayoffTeams().isEmpty());
        }
    }
}
