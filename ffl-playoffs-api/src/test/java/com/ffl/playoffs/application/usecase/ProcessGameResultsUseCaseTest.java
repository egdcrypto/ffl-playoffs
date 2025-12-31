package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.Game;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.port.GameRepository;
import com.ffl.playoffs.domain.port.NflDataProvider;
import com.ffl.playoffs.domain.port.TeamSelectionRepository;
import com.ffl.playoffs.domain.service.ScoringService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ProcessGameResultsUseCase Tests")
class ProcessGameResultsUseCaseTest {

    @Mock
    private NflDataProvider nflDataProvider;

    @Mock
    private TeamSelectionRepository teamSelectionRepository;

    @Mock
    private GameRepository gameRepository;

    @Mock
    private ScoringService scoringService;

    private ProcessGameResultsUseCase useCase;

    private UUID gameId;
    private Integer week;
    private Integer season;

    @BeforeEach
    void setUp() {
        useCase = new ProcessGameResultsUseCase(
                nflDataProvider,
                teamSelectionRepository,
                gameRepository,
                scoringService
        );

        gameId = UUID.randomUUID();
        week = 15;
        season = 2024;
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should process game results with no selections")
        void shouldProcessGameResultsWithNoSelections() {
            // Arrange
            ProcessGameResultsUseCase.ProcessGameResultsCommand command =
                    new ProcessGameResultsUseCase.ProcessGameResultsCommand(gameId, week, season);

            Game game = Game.builder()
                    .id(1L)
                    .name("Test Game")
                    .status(Game.GameStatus.IN_PROGRESS)
                    .build();

            when(gameRepository.findById(any(Long.class))).thenReturn(Optional.of(game));
            when(teamSelectionRepository.findByGameIdAndWeek(gameId, week)).thenReturn(new ArrayList<>());

            // Act
            ProcessGameResultsUseCase.ProcessGameResultsResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(gameId, result.getGameId());
            assertEquals(week, result.getWeek());
            assertEquals(season, result.getSeason());
            assertEquals(0, result.getTotalSelections());
            assertEquals(0, result.getSelectionsProcessed());
            assertEquals(0, result.getSelectionsWithErrors());
            assertTrue(result.isSuccess());
            assertTrue(result.getErrors().isEmpty());
        }

        @Test
        @DisplayName("should process game results with selections successfully")
        void shouldProcessGameResultsWithSelectionsSuccessfully() {
            // Arrange
            ProcessGameResultsUseCase.ProcessGameResultsCommand command =
                    new ProcessGameResultsUseCase.ProcessGameResultsCommand(gameId, week, season);

            Game game = Game.builder()
                    .id(1L)
                    .name("Test Game")
                    .status(Game.GameStatus.IN_PROGRESS)
                    .build();

            List<TeamSelection> selections = List.of(
                    TeamSelection.builder()
                            .id(1L)
                            .playerId(100L)
                            .nflTeam("KC")
                            .status(TeamSelection.SelectionStatus.LOCKED)
                            .build(),
                    TeamSelection.builder()
                            .id(2L)
                            .playerId(101L)
                            .nflTeam("BUF")
                            .status(TeamSelection.SelectionStatus.LOCKED)
                            .build()
            );

            when(gameRepository.findById(any(Long.class))).thenReturn(Optional.of(game));
            when(teamSelectionRepository.findByGameIdAndWeek(gameId, week)).thenReturn(selections);
            when(teamSelectionRepository.save(any(TeamSelection.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            ProcessGameResultsUseCase.ProcessGameResultsResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(2, result.getTotalSelections());
            assertEquals(2, result.getSelectionsProcessed());
            assertEquals(0, result.getSelectionsWithErrors());
            assertTrue(result.isSuccess());
            verify(teamSelectionRepository, times(2)).save(any(TeamSelection.class));
        }

        @Test
        @DisplayName("should throw exception when game not found")
        void shouldThrowExceptionWhenGameNotFound() {
            // Arrange
            ProcessGameResultsUseCase.ProcessGameResultsCommand command =
                    new ProcessGameResultsUseCase.ProcessGameResultsCommand(gameId, week, season);

            when(gameRepository.findById(any(Long.class))).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("Game not found"));
            verify(teamSelectionRepository, never()).findByGameIdAndWeek(any(UUID.class), any(Integer.class));
        }

        @Test
        @DisplayName("should use default season when not provided")
        void shouldUseDefaultSeasonWhenNotProvided() {
            // Arrange
            ProcessGameResultsUseCase.ProcessGameResultsCommand command =
                    new ProcessGameResultsUseCase.ProcessGameResultsCommand(gameId, week, null);

            Game game = Game.builder()
                    .id(1L)
                    .name("Test Game")
                    .status(Game.GameStatus.IN_PROGRESS)
                    .build();

            when(gameRepository.findById(any(Long.class))).thenReturn(Optional.of(game));
            when(teamSelectionRepository.findByGameIdAndWeek(gameId, week)).thenReturn(new ArrayList<>());

            // Act
            ProcessGameResultsUseCase.ProcessGameResultsResult result = useCase.execute(command);

            // Assert
            assertEquals(2024, result.getSeason());
        }

        @Test
        @DisplayName("should handle errors during selection processing")
        void shouldHandleErrorsDuringSelectionProcessing() {
            // Arrange
            ProcessGameResultsUseCase.ProcessGameResultsCommand command =
                    new ProcessGameResultsUseCase.ProcessGameResultsCommand(gameId, week, season);

            Game game = Game.builder()
                    .id(1L)
                    .name("Test Game")
                    .status(Game.GameStatus.IN_PROGRESS)
                    .build();

            List<TeamSelection> selections = new ArrayList<>();
            selections.add(TeamSelection.builder()
                            .id(1L)
                            .playerId(100L)
                            .nflTeam("KC")
                            .status(TeamSelection.SelectionStatus.LOCKED)
                            .build());

            when(gameRepository.findById(any(Long.class))).thenReturn(Optional.of(game));
            when(teamSelectionRepository.findByGameIdAndWeek(eq(gameId), eq(week))).thenReturn(selections);
            when(teamSelectionRepository.save(any(TeamSelection.class)))
                    .thenThrow(new RuntimeException("Database error"));

            // Act
            ProcessGameResultsUseCase.ProcessGameResultsResult result = useCase.execute(command);

            // Assert
            assertEquals(1, result.getTotalSelections());
            assertEquals(0, result.getSelectionsProcessed());
            assertEquals(1, result.getSelectionsWithErrors());
            assertFalse(result.isSuccess());
            assertFalse(result.getErrors().isEmpty());
            assertTrue(result.getErrors().get(0).contains("Database error"));
        }

        @Test
        @DisplayName("should record process timestamps")
        void shouldRecordProcessTimestamps() {
            // Arrange
            ProcessGameResultsUseCase.ProcessGameResultsCommand command =
                    new ProcessGameResultsUseCase.ProcessGameResultsCommand(gameId, week, season);

            Game game = Game.builder()
                    .id(1L)
                    .name("Test Game")
                    .status(Game.GameStatus.IN_PROGRESS)
                    .build();

            when(gameRepository.findById(any(Long.class))).thenReturn(Optional.of(game));
            when(teamSelectionRepository.findByGameIdAndWeek(gameId, week)).thenReturn(new ArrayList<>());

            // Act
            ProcessGameResultsUseCase.ProcessGameResultsResult result = useCase.execute(command);

            // Assert
            assertNotNull(result.getProcessStartTime());
            assertNotNull(result.getProcessEndTime());
            assertTrue(result.getProcessEndTime().isAfter(result.getProcessStartTime()) ||
                      result.getProcessEndTime().isEqual(result.getProcessStartTime()));
        }
    }

    @Nested
    @DisplayName("ProcessGameResultsCommand")
    class ProcessGameResultsCommandTests {

        @Test
        @DisplayName("should create command with all fields")
        void shouldCreateCommandWithAllFields() {
            // Arrange & Act
            ProcessGameResultsUseCase.ProcessGameResultsCommand command =
                    new ProcessGameResultsUseCase.ProcessGameResultsCommand(gameId, week, season);

            // Assert
            assertEquals(gameId, command.getGameId());
            assertEquals(week, command.getWeek());
            assertEquals(season, command.getSeason());
        }

        @Test
        @DisplayName("should allow null season")
        void shouldAllowNullSeason() {
            // Arrange & Act
            ProcessGameResultsUseCase.ProcessGameResultsCommand command =
                    new ProcessGameResultsUseCase.ProcessGameResultsCommand(gameId, week, null);

            // Assert
            assertNull(command.getSeason());
        }
    }

    @Nested
    @DisplayName("ProcessGameResultsResult")
    class ProcessGameResultsResultTests {

        @Test
        @DisplayName("should create result with all fields")
        void shouldCreateResultWithAllFields() {
            // Arrange
            List<String> errors = List.of("error1", "error2");

            // Act
            ProcessGameResultsUseCase.ProcessGameResultsResult result =
                    new ProcessGameResultsUseCase.ProcessGameResultsResult(
                            gameId, week, season,
                            10, 8, 2, errors,
                            null, null, false
                    );

            // Assert
            assertEquals(gameId, result.getGameId());
            assertEquals(week, result.getWeek());
            assertEquals(season, result.getSeason());
            assertEquals(10, result.getTotalSelections());
            assertEquals(8, result.getSelectionsProcessed());
            assertEquals(2, result.getSelectionsWithErrors());
            assertEquals(errors, result.getErrors());
            assertFalse(result.isSuccess());
        }

        @Test
        @DisplayName("should handle empty errors list")
        void shouldHandleEmptyErrorsList() {
            // Arrange & Act
            ProcessGameResultsUseCase.ProcessGameResultsResult result =
                    new ProcessGameResultsUseCase.ProcessGameResultsResult(
                            gameId, week, season,
                            5, 5, 0, new ArrayList<>(),
                            null, null, true
                    );

            // Assert
            assertTrue(result.isSuccess());
            assertTrue(result.getErrors().isEmpty());
        }
    }
}
