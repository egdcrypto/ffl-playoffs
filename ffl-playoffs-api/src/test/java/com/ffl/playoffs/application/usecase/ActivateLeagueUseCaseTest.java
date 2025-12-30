package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.model.LeagueStatus;
import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.model.RosterConfiguration;
import com.ffl.playoffs.domain.model.ScoringRules;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.domain.port.WeekRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

/**
 * Unit tests for ActivateLeagueUseCase
 */
@ExtendWith(MockitoExtension.class)
class ActivateLeagueUseCaseTest {

    @Mock
    private LeagueRepository leagueRepository;

    @Mock
    private WeekRepository weekRepository;

    private ActivateLeagueUseCase useCase;

    private League league;
    private UUID leagueId;

    @BeforeEach
    void setUp() {
        useCase = new ActivateLeagueUseCase(leagueRepository, weekRepository);

        leagueId = UUID.randomUUID();
        league = new League("Test League", "TEST123", UUID.randomUUID(), 15, 4);
        league.setId(leagueId);
        league.setRosterConfiguration(RosterConfiguration.standardRoster());
        league.setScoringRules(new ScoringRules());

        // Add minimum players
        for (int i = 0; i < 2; i++) {
            Player player = new Player();
            player.setId((long) i);
            player.setEmail("player" + i + "@test.com");
            player.setDisplayName("Player " + i);
            league.addPlayer(player);
        }
    }

    @Test
    @DisplayName("Should activate league and create weeks")
    void shouldActivateLeagueAndCreateWeeks() {
        // Given
        when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
        when(weekRepository.saveAll(any())).thenAnswer(invocation -> invocation.getArgument(0));
        when(leagueRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        ActivateLeagueUseCase.ActivateLeagueResult result = useCase.execute(
                new ActivateLeagueUseCase.ActivateLeagueCommand(leagueId)
        );

        // Then
        assertNotNull(result);
        assertEquals(LeagueStatus.ACTIVE, result.getLeague().getStatus());
        assertNotNull(result.getWeeks());
        assertEquals(4, result.getWeeks().size()); // 4 weeks configured

        // Verify weeks are created for correct NFL weeks
        List<Week> weeks = result.getWeeks();
        assertEquals(1, weeks.get(0).getGameWeekNumber());
        assertEquals(15, weeks.get(0).getNflWeekNumber());
        assertEquals(4, weeks.get(3).getGameWeekNumber());
        assertEquals(18, weeks.get(3).getNflWeekNumber());

        verify(weekRepository).saveAll(any());
        verify(leagueRepository).save(any());
    }

    @Test
    @DisplayName("Should throw exception when league not found")
    void shouldThrowExceptionWhenLeagueNotFound() {
        // Given
        when(leagueRepository.findById(leagueId)).thenReturn(Optional.empty());

        // When/Then
        assertThrows(ActivateLeagueUseCase.LeagueNotFoundException.class, () ->
                useCase.execute(new ActivateLeagueUseCase.ActivateLeagueCommand(leagueId))
        );
    }

    @Test
    @DisplayName("Should throw exception when insufficient players")
    void shouldThrowExceptionWhenInsufficientPlayers() {
        // Given
        League leagueWithoutPlayers = new League("Test", "CODE", UUID.randomUUID(), 15, 4);
        leagueWithoutPlayers.setId(leagueId);
        leagueWithoutPlayers.setRosterConfiguration(RosterConfiguration.standardRoster());
        leagueWithoutPlayers.setScoringRules(new ScoringRules());

        when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(leagueWithoutPlayers));

        // When/Then
        assertThrows(League.InsufficientPlayersException.class, () ->
                useCase.execute(new ActivateLeagueUseCase.ActivateLeagueCommand(leagueId))
        );
    }

    @Test
    @DisplayName("Should lock configuration after activation")
    void shouldLockConfigurationAfterActivation() {
        // Given
        when(leagueRepository.findById(leagueId)).thenReturn(Optional.of(league));
        when(weekRepository.saveAll(any())).thenAnswer(invocation -> invocation.getArgument(0));
        when(leagueRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));

        // When
        ActivateLeagueUseCase.ActivateLeagueResult result = useCase.execute(
                new ActivateLeagueUseCase.ActivateLeagueCommand(leagueId)
        );

        // Then
        assertTrue(result.getLeague().getConfigurationLocked());
        assertNotNull(result.getLeague().getConfigurationLockedAt());
    }
}
