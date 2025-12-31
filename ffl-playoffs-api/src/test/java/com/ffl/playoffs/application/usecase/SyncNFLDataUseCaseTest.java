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
@DisplayName("SyncNFLDataUseCase Tests")
class SyncNFLDataUseCaseTest {

    @Mock
    private NflDataProvider nflDataProvider;

    private SyncNFLDataUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new SyncNFLDataUseCase(nflDataProvider);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should sync NFL data successfully for specific week and season")
        void shouldSyncNFLDataSuccessfully() {
            // Arrange
            Integer week = 15;
            Integer season = 2024;
            List<String> playoffTeams = List.of("KC", "BUF", "BAL", "HOU", "DET", "PHI", "SF", "TB");

            SyncNFLDataUseCase.SyncNFLDataCommand command =
                    new SyncNFLDataUseCase.SyncNFLDataCommand(week, season);

            when(nflDataProvider.getPlayoffTeams(season)).thenReturn(playoffTeams);

            // Act
            SyncNFLDataUseCase.SyncResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(week, result.getWeek());
            assertEquals(season, result.getSeason());
            assertEquals(8, result.getTotalTeams());
            assertEquals(8, result.getTeamsProcessed());
            assertTrue(result.isSuccess());
            assertNotNull(result.getSyncStartTime());
            assertNotNull(result.getSyncEndTime());
            verify(nflDataProvider).getPlayoffTeams(season);
        }

        @Test
        @DisplayName("should handle empty playoff teams list")
        void shouldHandleEmptyPlayoffTeamsList() {
            // Arrange
            Integer week = 15;
            Integer season = 2024;

            SyncNFLDataUseCase.SyncNFLDataCommand command =
                    new SyncNFLDataUseCase.SyncNFLDataCommand(week, season);

            when(nflDataProvider.getPlayoffTeams(season)).thenReturn(new ArrayList<>());

            // Act
            SyncNFLDataUseCase.SyncResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(0, result.getTotalTeams());
            assertEquals(0, result.getTeamsProcessed());
            assertTrue(result.isSuccess());
        }

        @Test
        @DisplayName("should record sync timestamps")
        void shouldRecordSyncTimestamps() {
            // Arrange
            SyncNFLDataUseCase.SyncNFLDataCommand command =
                    new SyncNFLDataUseCase.SyncNFLDataCommand(15, 2024);

            when(nflDataProvider.getPlayoffTeams(2024)).thenReturn(List.of("KC"));

            // Act
            SyncNFLDataUseCase.SyncResult result = useCase.execute(command);

            // Assert
            assertNotNull(result.getSyncStartTime());
            assertNotNull(result.getSyncEndTime());
            assertTrue(result.getSyncEndTime().isAfter(result.getSyncStartTime()) ||
                      result.getSyncEndTime().isEqual(result.getSyncStartTime()));
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
            SyncNFLDataUseCase.SyncResult result = useCase.executeCurrentWeek();

            // Assert
            assertNotNull(result);
            assertEquals(1, result.getWeek()); // Default week
            assertEquals(2024, result.getSeason()); // Default season
            verify(nflDataProvider).getPlayoffTeams(2024);
        }

        @Test
        @DisplayName("should return successful result for current week sync")
        void shouldReturnSuccessfulResultForCurrentWeekSync() {
            // Arrange
            List<String> playoffTeams = List.of("KC", "BUF", "BAL");
            when(nflDataProvider.getPlayoffTeams(2024)).thenReturn(playoffTeams);

            // Act
            SyncNFLDataUseCase.SyncResult result = useCase.executeCurrentWeek();

            // Assert
            assertTrue(result.isSuccess());
            assertEquals(3, result.getTotalTeams());
            assertEquals(3, result.getTeamsProcessed());
        }
    }

    @Nested
    @DisplayName("SyncNFLDataCommand")
    class SyncNFLDataCommandTests {

        @Test
        @DisplayName("should create command with week and season")
        void shouldCreateCommandWithWeekAndSeason() {
            // Arrange & Act
            SyncNFLDataUseCase.SyncNFLDataCommand command =
                    new SyncNFLDataUseCase.SyncNFLDataCommand(16, 2024);

            // Assert
            assertEquals(16, command.getWeek());
            assertEquals(2024, command.getSeason());
        }

        @Test
        @DisplayName("should allow null week")
        void shouldAllowNullWeek() {
            // Arrange & Act
            SyncNFLDataUseCase.SyncNFLDataCommand command =
                    new SyncNFLDataUseCase.SyncNFLDataCommand(null, 2024);

            // Assert
            assertNull(command.getWeek());
            assertEquals(2024, command.getSeason());
        }

        @Test
        @DisplayName("should allow null season")
        void shouldAllowNullSeason() {
            // Arrange & Act
            SyncNFLDataUseCase.SyncNFLDataCommand command =
                    new SyncNFLDataUseCase.SyncNFLDataCommand(15, null);

            // Assert
            assertEquals(15, command.getWeek());
            assertNull(command.getSeason());
        }
    }

    @Nested
    @DisplayName("SyncResult")
    class SyncResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            java.time.LocalDateTime startTime = java.time.LocalDateTime.now();
            java.time.LocalDateTime endTime = java.time.LocalDateTime.now().plusSeconds(5);

            // Act
            SyncNFLDataUseCase.SyncResult result = new SyncNFLDataUseCase.SyncResult(
                    15, 2024, 8, 8, startTime, endTime, true
            );

            // Assert
            assertEquals(15, result.getWeek());
            assertEquals(2024, result.getSeason());
            assertEquals(8, result.getTotalTeams());
            assertEquals(8, result.getTeamsProcessed());
            assertEquals(startTime, result.getSyncStartTime());
            assertEquals(endTime, result.getSyncEndTime());
            assertTrue(result.isSuccess());
        }

        @Test
        @DisplayName("should indicate failure when not all teams processed")
        void shouldIndicateFailureWhenNotAllTeamsProcessed() {
            // Arrange
            java.time.LocalDateTime now = java.time.LocalDateTime.now();

            // Act
            SyncNFLDataUseCase.SyncResult result = new SyncNFLDataUseCase.SyncResult(
                    15, 2024, 8, 6, now, now, false
            );

            // Assert
            assertEquals(8, result.getTotalTeams());
            assertEquals(6, result.getTeamsProcessed());
            assertFalse(result.isSuccess());
        }
    }
}
