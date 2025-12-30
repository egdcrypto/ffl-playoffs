package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.model.LeagueStatus;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.model.ScoringRules;
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

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyList;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("ActivateLeagueUseCase Tests")
class ActivateLeagueUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    @Mock
    private WeekRepository weekRepository;

    private ActivateLeagueUseCase useCase;

    @Captor
    private ArgumentCaptor<League> leagueCaptor;

    @Captor
    private ArgumentCaptor<List<Week>> weeksCaptor;

    private UUID leagueId;
    private League readyLeague;

    @BeforeEach
    void setUp() {
        useCase = new ActivateLeagueUseCase(leagueRepository, weekRepository);

        leagueId = UUID.randomUUID();

        // Create a league ready for activation
        readyLeague = new League();
        readyLeague.setId(leagueId);
        readyLeague.setName("Ready League");
        readyLeague.setStatus(LeagueStatus.DRAFT);
        readyLeague.setStartingWeekAndDuration(15, 3);
        readyLeague.setRosterConfiguration(RosterConfiguration.standardRoster());
        readyLeague.setScoringRules(ScoringRules.standardRules());
        readyLeague.setMinPlayers(2);

        // Add minimum players
        Player player1 = Player.builder().id(1L).email("p1@test.com").displayName("Player 1").build();
        Player player2 = Player.builder().id(2L).email("p2@test.com").displayName("Player 2").build();
        readyLeague.getPlayers().add(player1);
        readyLeague.getPlayers().add(player2);
    }

    @Nested
    @DisplayName("execute")
    class Execute {

        @Test
        @DisplayName("should activate league successfully and create weeks")
        void shouldActivateLeagueSuccessfully() {
            // Arrange
            ActivateLeagueUseCase.ActivateLeagueCommand command =
                    new ActivateLeagueUseCase.ActivateLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(readyLeague));
            when(weekRepository.saveAll(anyList())).thenAnswer(inv -> inv.getArgument(0));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            ActivateLeagueUseCase.ActivateLeagueResult result = useCase.execute(command);

            // Assert
            assertNotNull(result);
            assertEquals(LeagueStatus.ACTIVE, result.getLeague().getStatus());
            assertEquals(3, result.getWeeks().size());

            verify(weekRepository).saveAll(weeksCaptor.capture());
            List<Week> savedWeeks = weeksCaptor.getValue();
            assertEquals(3, savedWeeks.size());
        }

        @Test
        @DisplayName("should throw LeagueNotFoundException when league not found")
        void shouldThrowLeagueNotFoundException() {
            // Arrange
            UUID unknownLeagueId = UUID.randomUUID();
            ActivateLeagueUseCase.ActivateLeagueCommand command =
                    new ActivateLeagueUseCase.ActivateLeagueCommand(unknownLeagueId);

            when(leagueRepository.findById(unknownLeagueId)).thenReturn(Optional.empty());

            // Act & Assert
            ActivateLeagueUseCase.LeagueNotFoundException exception = assertThrows(
                    ActivateLeagueUseCase.LeagueNotFoundException.class,
                    () -> useCase.execute(command)
            );

            assertEquals(unknownLeagueId, exception.getLeagueId());
            verify(leagueRepository, never()).save(any());
            verify(weekRepository, never()).saveAll(anyList());
        }

        @Test
        @DisplayName("should throw InsufficientPlayersException when not enough players")
        void shouldThrowExceptionWhenInsufficientPlayers() {
            // Arrange
            League leagueWithNoPlayers = new League();
            leagueWithNoPlayers.setId(leagueId);
            leagueWithNoPlayers.setName("Empty League");
            leagueWithNoPlayers.setStatus(LeagueStatus.DRAFT);
            leagueWithNoPlayers.setStartingWeekAndDuration(15, 3);
            leagueWithNoPlayers.setRosterConfiguration(RosterConfiguration.standardRoster());
            leagueWithNoPlayers.setScoringRules(ScoringRules.standardRules());
            leagueWithNoPlayers.setMinPlayers(2);

            ActivateLeagueUseCase.ActivateLeagueCommand command =
                    new ActivateLeagueUseCase.ActivateLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(leagueWithNoPlayers));

            // Act & Assert
            League.InsufficientPlayersException exception = assertThrows(
                    League.InsufficientPlayersException.class,
                    () -> useCase.execute(command)
            );

            assertEquals("INSUFFICIENT_PLAYERS", exception.getErrorCode());
            verify(leagueRepository, never()).save(any());
            verify(weekRepository, never()).saveAll(anyList());
        }

        @Test
        @DisplayName("should throw IncompleteConfigurationException when missing roster config")
        void shouldThrowExceptionWhenMissingRosterConfig() {
            // Arrange
            League leagueWithoutConfig = new League();
            leagueWithoutConfig.setId(leagueId);
            leagueWithoutConfig.setName("Incomplete League");
            leagueWithoutConfig.setStatus(LeagueStatus.DRAFT);
            leagueWithoutConfig.setStartingWeekAndDuration(15, 3);
            leagueWithoutConfig.setMinPlayers(2);
            leagueWithoutConfig.getPlayers().add(Player.builder().id(1L).email("p1@test.com").displayName("P1").build());
            leagueWithoutConfig.getPlayers().add(Player.builder().id(2L).email("p2@test.com").displayName("P2").build());

            ActivateLeagueUseCase.ActivateLeagueCommand command =
                    new ActivateLeagueUseCase.ActivateLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(leagueWithoutConfig));

            // Act & Assert
            League.IncompleteConfigurationException exception = assertThrows(
                    League.IncompleteConfigurationException.class,
                    () -> useCase.execute(command)
            );

            assertEquals("INCOMPLETE_CONFIGURATION", exception.getErrorCode());
            verify(leagueRepository, never()).save(any());
        }

        @Test
        @DisplayName("should create first week as ACTIVE and others as UPCOMING")
        void shouldCreateFirstWeekAsActive() {
            // Arrange
            ActivateLeagueUseCase.ActivateLeagueCommand command =
                    new ActivateLeagueUseCase.ActivateLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(readyLeague));
            when(weekRepository.saveAll(anyList())).thenAnswer(inv -> inv.getArgument(0));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            ActivateLeagueUseCase.ActivateLeagueResult result = useCase.execute(command);

            // Assert
            List<Week> weeks = result.getWeeks();
            assertEquals(WeekStatus.ACTIVE, weeks.get(0).getStatus());
            assertEquals(WeekStatus.UPCOMING, weeks.get(1).getStatus());
            assertEquals(WeekStatus.UPCOMING, weeks.get(2).getStatus());
        }

        @Test
        @DisplayName("should create weeks with correct NFL week numbers")
        void shouldCreateWeeksWithCorrectNflWeekNumbers() {
            // Arrange
            ActivateLeagueUseCase.ActivateLeagueCommand command =
                    new ActivateLeagueUseCase.ActivateLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(readyLeague));
            when(weekRepository.saveAll(anyList())).thenAnswer(inv -> inv.getArgument(0));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            ActivateLeagueUseCase.ActivateLeagueResult result = useCase.execute(command);

            // Assert
            List<Week> weeks = result.getWeeks();
            assertEquals(15, weeks.get(0).getNflWeekNumber());
            assertEquals(16, weeks.get(1).getNflWeekNumber());
            assertEquals(17, weeks.get(2).getNflWeekNumber());
        }

        @Test
        @DisplayName("should lock configuration after activation")
        void shouldLockConfigurationAfterActivation() {
            // Arrange
            ActivateLeagueUseCase.ActivateLeagueCommand command =
                    new ActivateLeagueUseCase.ActivateLeagueCommand(leagueId);

            when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(readyLeague));
            when(weekRepository.saveAll(anyList())).thenAnswer(inv -> inv.getArgument(0));
            when(leagueRepository.save(any(League.class))).thenAnswer(inv -> inv.getArgument(0));

            // Act
            ActivateLeagueUseCase.ActivateLeagueResult result = useCase.execute(command);

            // Assert
            assertTrue(result.getLeague().getConfigurationLocked());
        }
    }
}
