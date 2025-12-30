package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.TeamSelectionDTO;
import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.model.WeekStatus;
import com.ffl.playoffs.domain.port.TeamSelectionRepository;
import com.ffl.playoffs.domain.port.WeekRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("SelectTeamUseCase Tests")
class SelectTeamUseCaseTest {

    @Mock
    private WeekRepository weekRepository;

    @Mock
    private TeamSelectionRepository teamSelectionRepository;

    @InjectMocks
    private SelectTeamUseCase useCase;

    private UUID playerId;
    private UUID weekId;
    private UUID leagueId;
    private String nflTeam;
    private Week activeWeek;

    @BeforeEach
    void setUp() {
        playerId = UUID.randomUUID();
        weekId = UUID.randomUUID();
        leagueId = UUID.randomUUID();
        nflTeam = "Kansas City Chiefs";

        // Create an active week that can accept selections
        activeWeek = new Week(leagueId, 1, 15);
        activeWeek.setId(weekId);
        activeWeek.setPickDeadline(LocalDateTime.now().plusDays(1)); // Deadline in the future
        activeWeek.activate(); // Set status to ACTIVE
    }

    @Nested
    @DisplayName("Successful Selection")
    class SuccessfulSelection {

        @Test
        @DisplayName("should create team selection when week is active and team not used")
        void shouldCreateSelectionWhenValid() {
            // Arrange
            when(weekRepository.findById(weekId)).thenReturn(Optional.of(activeWeek));
            when(teamSelectionRepository.hasPlayerSelectedTeam(playerId, nflTeam)).thenReturn(false);
            when(teamSelectionRepository.save(any(TeamSelection.class))).thenAnswer(invocation -> {
                TeamSelection selection = invocation.getArgument(0);
                selection.setId(1L);
                return selection;
            });

            // Act
            TeamSelectionDTO result = useCase.execute(playerId, weekId, nflTeam);

            // Assert
            assertNotNull(result);
            assertEquals(nflTeam, result.getNflTeam());
            assertEquals("PENDING", result.getStatus());
            assertNotNull(result.getSelectedAt());

            verify(weekRepository).findById(weekId);
            verify(teamSelectionRepository).hasPlayerSelectedTeam(playerId, nflTeam);
            verify(teamSelectionRepository).save(any(TeamSelection.class));
        }

        @Test
        @DisplayName("should save selection with correct player and week references")
        void shouldSaveWithCorrectReferences() {
            // Arrange
            when(weekRepository.findById(weekId)).thenReturn(Optional.of(activeWeek));
            when(teamSelectionRepository.hasPlayerSelectedTeam(playerId, nflTeam)).thenReturn(false);

            ArgumentCaptor<TeamSelection> selectionCaptor = ArgumentCaptor.forClass(TeamSelection.class);
            when(teamSelectionRepository.save(selectionCaptor.capture())).thenAnswer(invocation -> {
                TeamSelection selection = invocation.getArgument(0);
                selection.setId(1L);
                return selection;
            });

            // Act
            useCase.execute(playerId, weekId, nflTeam);

            // Assert
            TeamSelection savedSelection = selectionCaptor.getValue();
            assertEquals(nflTeam, savedSelection.getNflTeam());
            assertEquals(TeamSelection.SelectionStatus.PENDING, savedSelection.getStatus());
            assertNotNull(savedSelection.getSelectedAt());
        }
    }

    @Nested
    @DisplayName("Week Not Found")
    class WeekNotFound {

        @Test
        @DisplayName("should throw exception when week does not exist")
        void shouldThrowWhenWeekNotFound() {
            // Arrange
            when(weekRepository.findById(weekId)).thenReturn(Optional.empty());

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(playerId, weekId, nflTeam)
            );

            assertTrue(exception.getMessage().contains("Week not found"));
            verify(weekRepository).findById(weekId);
            verifyNoInteractions(teamSelectionRepository);
        }
    }

    @Nested
    @DisplayName("Week Not Accepting Selections")
    class WeekNotAcceptingSelections {

        @Test
        @DisplayName("should throw exception when week is not active")
        void shouldThrowWhenWeekNotActive() {
            // Arrange
            Week upcomingWeek = new Week(leagueId, 1, 15);
            upcomingWeek.setId(weekId);
            // Week is in UPCOMING status by default (not activated)

            when(weekRepository.findById(weekId)).thenReturn(Optional.of(upcomingWeek));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(playerId, weekId, nflTeam)
            );

            assertEquals("Week is not open for selections", exception.getMessage());
            verify(teamSelectionRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when deadline has passed")
        void shouldThrowWhenDeadlinePassed() {
            // Arrange
            Week expiredWeek = new Week(leagueId, 1, 15);
            expiredWeek.setId(weekId);
            expiredWeek.setPickDeadline(LocalDateTime.now().minusHours(1)); // Deadline in the past
            expiredWeek.activate();

            when(weekRepository.findById(weekId)).thenReturn(Optional.of(expiredWeek));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(playerId, weekId, nflTeam)
            );

            assertEquals("Week is not open for selections", exception.getMessage());
            verify(teamSelectionRepository, never()).save(any());
        }

        @Test
        @DisplayName("should throw exception when week is locked")
        void shouldThrowWhenWeekLocked() {
            // Arrange
            Week lockedWeek = new Week(leagueId, 1, 15);
            lockedWeek.setId(weekId);
            lockedWeek.setPickDeadline(LocalDateTime.now().plusDays(1));
            lockedWeek.activate();
            lockedWeek.lock(); // Now status is LOCKED

            when(weekRepository.findById(weekId)).thenReturn(Optional.of(lockedWeek));

            // Act & Assert
            IllegalStateException exception = assertThrows(
                    IllegalStateException.class,
                    () -> useCase.execute(playerId, weekId, nflTeam)
            );

            assertEquals("Week is not open for selections", exception.getMessage());
        }
    }

    @Nested
    @DisplayName("Team Already Used")
    class TeamAlreadyUsed {

        @Test
        @DisplayName("should throw exception when team has already been selected by player")
        void shouldThrowWhenTeamAlreadyUsed() {
            // Arrange
            when(weekRepository.findById(weekId)).thenReturn(Optional.of(activeWeek));
            when(teamSelectionRepository.hasPlayerSelectedTeam(playerId, nflTeam)).thenReturn(true);

            // Act & Assert
            IllegalArgumentException exception = assertThrows(
                    IllegalArgumentException.class,
                    () -> useCase.execute(playerId, weekId, nflTeam)
            );

            assertTrue(exception.getMessage().contains("has already been used"));
            assertTrue(exception.getMessage().contains(nflTeam));
            verify(teamSelectionRepository, never()).save(any());
        }
    }
}
