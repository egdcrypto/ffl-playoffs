package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.model.LeagueStatus;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.WeekStatus;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.TeamSelectionRepository;
import com.ffl.playoffs.domain.port.WeekRepository;
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
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("GetGameHealthUseCase Tests")
class GetGameHealthUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    @Mock
    private WeekRepository weekRepository;

    @Mock
    private TeamSelectionRepository teamSelectionRepository;

    private GetGameHealthUseCase useCase;

    private UUID leagueId;
    private League league;

    @BeforeEach
    void setUp() {
        useCase = new GetGameHealthUseCase(leagueRepository, weekRepository, teamSelectionRepository);

        leagueId = UUID.randomUUID();

        league = new League();
        league.setId(leagueId);
        league.setName("Test League");
        league.setCode("TEST");
        league.setOwnerId(UUID.randomUUID());
        league.setStartingWeekAndDuration(15, 3);
        league.setStatus(LeagueStatus.ACTIVE);

        // Add some players
        List<Player> players = new ArrayList<>();
        players.add(Player.builder().id(1L).email("player1@test.com").displayName("Player 1").status(Player.PlayerStatus.ACTIVE).build());
        players.add(Player.builder().id(2L).email("player2@test.com").displayName("Player 2").status(Player.PlayerStatus.ACTIVE).build());
        players.add(Player.builder().id(3L).email("player3@test.com").displayName("Player 3").status(Player.PlayerStatus.ACTIVE).build());
        league.setPlayers(players);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should return game health status successfully")
        void shouldReturnGameHealthStatusSuccessfully() {
            // Arrange
            GetGameHealthUseCase.GetGameHealthCommand command =
                    new GetGameHealthUseCase.GetGameHealthCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(weekRepository.findByLeagueId(leagueId)).thenReturn(List.of());
            when(weekRepository.findCurrentWeek(leagueId)).thenReturn(Optional.empty());

            // Act
            GetGameHealthUseCase.GameHealthStatus result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(leagueId, result.getLeagueId());
            assertEquals("Test League", result.getLeagueName());
            assertEquals("ACTIVE", result.getStatus());
        }

        @Test
        @DisplayName("should throw LeagueNotFoundException when league not found")
        void shouldThrowExceptionWhenLeagueNotFound() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            GetGameHealthUseCase.GetGameHealthCommand command =
                    new GetGameHealthUseCase.GetGameHealthCommand(unknownLeagueId);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            GetGameHealthUseCase.LeagueNotFoundException exception = assertThrows(
                    GetGameHealthUseCase.LeagueNotFoundException.class,
                    () -> useCase.execute(command)
            );

            assertEquals(unknownLeagueId, exception.getLeagueId());
            assertTrue(exception.getMessage().contains("League not found"));
        }

        @Test
        @DisplayName("should calculate player counts correctly")
        void shouldCalculatePlayerCountsCorrectly() {
            // Arrange
            GetGameHealthUseCase.GetGameHealthCommand command =
                    new GetGameHealthUseCase.GetGameHealthCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(weekRepository.findByLeagueId(leagueId)).thenReturn(List.of());
            when(weekRepository.findCurrentWeek(leagueId)).thenReturn(Optional.empty());

            // Act
            GetGameHealthUseCase.GameHealthStatus result = useCase.execute(command);

            // Assert
            assertEquals(3, result.getTotalPlayers());
        }

        @Test
        @DisplayName("should handle null current week")
        void shouldHandleNullCurrentWeek() {
            // Arrange
            GetGameHealthUseCase.GetGameHealthCommand command =
                    new GetGameHealthUseCase.GetGameHealthCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(weekRepository.findByLeagueId(leagueId)).thenReturn(List.of());
            when(weekRepository.findCurrentWeek(leagueId)).thenReturn(Optional.empty());

            // Act
            GetGameHealthUseCase.GameHealthStatus result = useCase.execute(command);

            // Assert
            assertNull(result.getCurrentWeek());
            assertEquals(0, result.getActiveSelections());
            assertEquals(0, result.getMissedSelections());
        }

        @Test
        @DisplayName("should count active and missed selections")
        void shouldCountActiveAndMissedSelections() {
            // Arrange
            UUID weekId = UUID.randomUUID();
            Week currentWeek = new Week();
            currentWeek.setId(weekId);
            currentWeek.setGameWeekNumber(15);
            currentWeek.setLeagueId(leagueId);

            GetGameHealthUseCase.GetGameHealthCommand command =
                    new GetGameHealthUseCase.GetGameHealthCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(weekRepository.findByLeagueId(leagueId)).thenReturn(List.of(currentWeek));
            when(weekRepository.findCurrentWeek(leagueId)).thenReturn(Optional.of(currentWeek));
            when(teamSelectionRepository.countByWeekId(weekId)).thenReturn(2L);

            // Act
            GetGameHealthUseCase.GameHealthStatus result = useCase.execute(command);

            // Assert
            assertEquals(2, result.getActiveSelections());
            assertEquals(1, result.getMissedSelections()); // 3 total players - 2 active = 1 missed
        }

        @Test
        @DisplayName("should calculate weeks remaining")
        void shouldCalculateWeeksRemaining() {
            // Arrange
            Week completedWeek = new Week();
            completedWeek.setId(UUID.randomUUID());
            completedWeek.setGameWeekNumber(15);
            completedWeek.setLeagueId(leagueId);
            completedWeek.setStatus(WeekStatus.COMPLETED);

            GetGameHealthUseCase.GetGameHealthCommand command =
                    new GetGameHealthUseCase.GetGameHealthCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(weekRepository.findByLeagueId(leagueId)).thenReturn(List.of(completedWeek));
            when(weekRepository.findCurrentWeek(leagueId)).thenReturn(Optional.empty());

            // Act
            GetGameHealthUseCase.GameHealthStatus result = useCase.execute(command);

            // Assert
            assertEquals(2, result.getWeeksRemaining()); // 3 total weeks - 1 completed = 2 remaining
        }

        @Test
        @DisplayName("should return data integration status")
        void shouldReturnDataIntegrationStatus() {
            // Arrange
            GetGameHealthUseCase.GetGameHealthCommand command =
                    new GetGameHealthUseCase.GetGameHealthCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
            when(weekRepository.findByLeagueId(leagueId)).thenReturn(List.of());
            when(weekRepository.findCurrentWeek(leagueId)).thenReturn(Optional.empty());

            // Act
            GetGameHealthUseCase.GameHealthStatus result = useCase.execute(command);

            // Assert
            assertEquals(GetGameHealthUseCase.DataIntegrationStatus.HEALTHY, result.getDataIntegrationStatus());
        }

        @Test
        @DisplayName("should handle league with null players")
        void shouldHandleLeagueWithNullPlayers() {
            // Arrange
            League leagueWithNullPlayers = new League();
            leagueWithNullPlayers.setId(leagueId);
            leagueWithNullPlayers.setName("Test League");
            leagueWithNullPlayers.setCode("TEST");
            leagueWithNullPlayers.setOwnerId(UUID.randomUUID());
            leagueWithNullPlayers.setStartingWeekAndDuration(15, 3);
            leagueWithNullPlayers.setStatus(LeagueStatus.DRAFT);
            // players is null

            GetGameHealthUseCase.GetGameHealthCommand command =
                    new GetGameHealthUseCase.GetGameHealthCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(leagueWithNullPlayers));
            when(weekRepository.findByLeagueId(leagueId)).thenReturn(List.of());
            when(weekRepository.findCurrentWeek(leagueId)).thenReturn(Optional.empty());

            // Act
            GetGameHealthUseCase.GameHealthStatus result = useCase.execute(command);

            // Assert
            assertEquals(0, result.getTotalPlayers());
        }
    }

    @Nested
    @DisplayName("GetGameHealthCommand")
    class GetGameHealthCommandTests {

        @Test
        @DisplayName("should create command with league ID")
        void shouldCreateCommandWithLeagueId() {
            // Arrange & Act
            GetGameHealthUseCase.GetGameHealthCommand command =
                    new GetGameHealthUseCase.GetGameHealthCommand(leagueId);

            // Assert
            assertEquals(leagueId, command.getLeagueId());
        }
    }

    @Nested
    @DisplayName("GameHealthStatus")
    class GameHealthStatusTests {

        @Test
        @DisplayName("should return active selections display")
        void shouldReturnActiveSelectionsDisplay() {
            // Arrange
            GetGameHealthUseCase.GameHealthStatus status =
                    new GetGameHealthUseCase.GameHealthStatus(
                            leagueId, "Test", "ACTIVE", 10, 7, 3, 15, 2,
                            GetGameHealthUseCase.DataIntegrationStatus.HEALTHY, null);

            // Act
            String display = status.getActiveSelectionsDisplay();

            // Assert
            assertEquals("7 of 10", display);
        }
    }
}
