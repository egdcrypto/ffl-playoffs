package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.model.LeagueStatus;
import com.ffl.playoffs.domain.model.WeekStatus;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.WeekRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.Captor;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("AdvanceWeekUseCase Tests")
class AdvanceWeekUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    @Mock
    private WeekRepository weekRepository;

    private AdvanceWeekUseCase useCase;

    @Captor
    private ArgumentCaptor<League> leagueCaptor;

    @Captor
    private ArgumentCaptor<Week> weekCaptor;

    private UUID leagueId;
    private League activeLeague;
    private Week completedWeek;
    private Week nextWeek;

    @BeforeEach
    void setUp() {
        useCase = new AdvanceWeekUseCase(leagueRepository, weekRepository);

        leagueId = UUID.randomUUID();

        // Create an active league with weeks 15-17 (3 weeks)
        activeLeague = new League();
        activeLeague.setId(leagueId);
        activeLeague.setName("Test League");
        activeLeague.setStatus(LeagueStatus.ACTIVE);
        activeLeague.setStartingWeekAndDuration(15, 3);
        activeLeague.setCurrentWeek(15);

        // Create a completed current week
        completedWeek = new Week(leagueId, 1, 15);
        completedWeek.setStatus(WeekStatus.COMPLETED);
        completedWeek.setTotalNFLGames(16);
        completedWeek.setGamesCompleted(16);
        completedWeek.setGamesInProgress(0);

        // Create the next week (upcoming)
        nextWeek = new Week(leagueId, 2, 16);
        nextWeek.setStatus(WeekStatus.UPCOMING);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should advance week successfully when current week is completed")
        void shouldAdvanceWeekSuccessfully() {
            // Arrange
            AdvanceWeekUseCase.AdvanceWeekCommand command =
                    new AdvanceWeekUseCase.AdvanceWeekCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(weekRepository.findCurrentWeek(leagueId)).thenReturn(Optional.of(completedWeek));
            when(weekRepository.findByLeagueIdAndGameWeekNumber(leagueId, 2)).thenReturn(Optional.of(nextWeek));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));
            when(weekRepository.save(any(Week.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            AdvanceWeekUseCase.AdvanceWeekResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertFalse(result.isLeagueCompleted());
            assertEquals(completedWeek, result.getPreviousWeek());
            assertEquals(nextWeek, result.getCurrentWeek());

            verify(leagueRepository).save(leagueCaptor.capture());
            assertEquals(16, leagueCaptor.getValue().getCurrentWeek());
        }

        @Test
        @DisplayName("should throw LeagueNotFoundException when league not found")
        void shouldThrowLeagueNotFoundException() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            AdvanceWeekUseCase.AdvanceWeekCommand command =
                    new AdvanceWeekUseCase.AdvanceWeekCommand(unknownLeagueId);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            AdvanceWeekUseCase.LeagueNotFoundException exception = assertThrows(
                    AdvanceWeekUseCase.LeagueNotFoundException.class,
                    () -> useCase.execute(command)
            );

            assertEquals(unknownLeagueId, exception.getLeagueId());
            verify(weekRepository, never()).findCurrentWeek(any());
        }

        @Test
        @DisplayName("should throw exception when league is not active")
        void shouldThrowExceptionWhenLeagueNotActive() {
            // Arrange
            League inactiveLeague = new League();
            inactiveLeague.setId(leagueId);
            inactiveLeague.setStatus(LeagueStatus.DRAFT);

            AdvanceWeekUseCase.AdvanceWeekCommand command =
                    new AdvanceWeekUseCase.AdvanceWeekCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(inactiveLeague));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertEquals("Can only advance week for active leagues", exception.getMessage());
            verify(weekRepository, never()).findCurrentWeek(any());
        }

        @Test
        @DisplayName("should throw exception when no active week found")
        void shouldThrowExceptionWhenNoActiveWeekFound() {
            // Arrange
            AdvanceWeekUseCase.AdvanceWeekCommand command =
                    new AdvanceWeekUseCase.AdvanceWeekCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(weekRepository.findCurrentWeek(leagueId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(command)
            );

            assertEquals("No active week found for league", exception.getMessage());
        }

        @Test
        @DisplayName("should throw WeekNotCompleteException when games still in progress")
        void shouldThrowExceptionWhenGamesInProgress() {
            // Arrange
            Week weekWithGamesInProgress = new Week(leagueId, 1, 15);
            weekWithGamesInProgress.setStatus(WeekStatus.LOCKED);
            weekWithGamesInProgress.setGamesInProgress(3);
            weekWithGamesInProgress.setTotalNFLGames(16);
            weekWithGamesInProgress.setGamesCompleted(13);

            AdvanceWeekUseCase.AdvanceWeekCommand command =
                    new AdvanceWeekUseCase.AdvanceWeekCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(weekRepository.findCurrentWeek(leagueId)).thenReturn(Optional.of(weekWithGamesInProgress));

            // Act & Assert
            AdvanceWeekUseCase.WeekNotCompleteException exception = assertThrows(
                    AdvanceWeekUseCase.WeekNotCompleteException.class,
                    () -> useCase.execute(command)
            );

            assertEquals(3, exception.getGamesInProgress());
            assertEquals("WEEK_NOT_COMPLETE", exception.getErrorCode());
        }

        @Test
        @DisplayName("should throw WeekNotCompleteException when not all games completed")
        void shouldThrowExceptionWhenNotAllGamesCompleted() {
            // Arrange
            Week incompleteWeek = new Week(leagueId, 1, 15);
            incompleteWeek.setStatus(WeekStatus.LOCKED);
            incompleteWeek.setGamesInProgress(0);
            incompleteWeek.setTotalNFLGames(16);
            incompleteWeek.setGamesCompleted(14); // Not all games completed

            AdvanceWeekUseCase.AdvanceWeekCommand command =
                    new AdvanceWeekUseCase.AdvanceWeekCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(weekRepository.findCurrentWeek(leagueId)).thenReturn(Optional.of(incompleteWeek));

            // Act & Assert
            AdvanceWeekUseCase.WeekNotCompleteException exception = assertThrows(
                    AdvanceWeekUseCase.WeekNotCompleteException.class,
                    () -> useCase.execute(command)
            );

            assertTrue(exception.getMessage().contains("not all games have completed"));
        }

        @Test
        @DisplayName("should throw ScoresNotCalculatedException when week status is ACTIVE")
        void shouldThrowExceptionWhenScoresNotCalculated() {
            // Arrange
            Week activeWeek = new Week(leagueId, 1, 15);
            activeWeek.setStatus(WeekStatus.ACTIVE);
            activeWeek.setGamesInProgress(0);
            activeWeek.setTotalNFLGames(16);
            activeWeek.setGamesCompleted(16);

            AdvanceWeekUseCase.AdvanceWeekCommand command =
                    new AdvanceWeekUseCase.AdvanceWeekCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(weekRepository.findCurrentWeek(leagueId)).thenReturn(Optional.of(activeWeek));

            // Act & Assert
            AdvanceWeekUseCase.ScoresNotCalculatedException exception = assertThrows(
                    AdvanceWeekUseCase.ScoresNotCalculatedException.class,
                    () -> useCase.execute(command)
            );

            assertEquals("SCORES_NOT_CALCULATED", exception.getErrorCode());
        }

        @Test
        @DisplayName("should complete league when on final week")
        void shouldCompleteLeagueWhenOnFinalWeek() {
            // Arrange
            // Set league to final week (week 17 of 15-17 range)
            activeLeague.setCurrentWeek(17);

            Week finalWeek = new Week(leagueId, 3, 17);
            finalWeek.setStatus(WeekStatus.COMPLETED);
            finalWeek.setTotalNFLGames(16);
            finalWeek.setGamesCompleted(16);
            finalWeek.setGamesInProgress(0);

            AdvanceWeekUseCase.AdvanceWeekCommand command =
                    new AdvanceWeekUseCase.AdvanceWeekCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(weekRepository.findCurrentWeek(leagueId)).thenReturn(Optional.of(finalWeek));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            AdvanceWeekUseCase.AdvanceWeekResult result = useCase.execute(command);

            // Assert
            assertTrue(result.isLeagueCompleted());
            assertNull(result.getCurrentWeek());
            assertEquals(finalWeek, result.getPreviousWeek());

            verify(leagueRepository).save(leagueCaptor.capture());
            assertEquals(LeagueStatus.COMPLETED, leagueCaptor.getValue().getStatus());
        }

        @Test
        @DisplayName("should complete LOCKED week before advancing")
        void shouldCompleteLockedWeekBeforeAdvancing() {
            // Arrange
            Week lockedWeek = new Week(leagueId, 1, 15);
            lockedWeek.setStatus(WeekStatus.LOCKED);
            lockedWeek.setTotalNFLGames(16);
            lockedWeek.setGamesCompleted(16);
            lockedWeek.setGamesInProgress(0);

            AdvanceWeekUseCase.AdvanceWeekCommand command =
                    new AdvanceWeekUseCase.AdvanceWeekCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(weekRepository.findCurrentWeek(leagueId)).thenReturn(Optional.of(lockedWeek));
            when(weekRepository.findByLeagueIdAndGameWeekNumber(leagueId, 2)).thenReturn(Optional.of(nextWeek));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));
            when(weekRepository.save(any(Week.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            AdvanceWeekUseCase.AdvanceWeekResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertFalse(result.isLeagueCompleted());

            // Verify lockedWeek was completed and saved
            verify(weekRepository, atLeast(1)).save(weekCaptor.capture());
            assertTrue(weekCaptor.getAllValues().stream()
                    .anyMatch(w -> w.getId().equals(lockedWeek.getId())));
        }

        @Test
        @DisplayName("should activate next UPCOMING week")
        void shouldActivateNextUpcomingWeek() {
            // Arrange
            AdvanceWeekUseCase.AdvanceWeekCommand command =
                    new AdvanceWeekUseCase.AdvanceWeekCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(activeLeague));
            when(weekRepository.findCurrentWeek(leagueId)).thenReturn(Optional.of(completedWeek));
            when(weekRepository.findByLeagueIdAndGameWeekNumber(leagueId, 2)).thenReturn(Optional.of(nextWeek));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));
            when(weekRepository.save(any(Week.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            useCase.execute(command);

            // Assert
            verify(weekRepository).save(weekCaptor.capture());
            Week savedNextWeek = weekCaptor.getAllValues().stream()
                    .filter(w -> w.getId().equals(nextWeek.getId()))
                    .findFirst()
                    .orElseThrow();
            assertEquals(WeekStatus.ACTIVE, savedNextWeek.getStatus());
        }
    }
}
