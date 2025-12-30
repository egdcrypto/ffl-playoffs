package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.LeagueStatsDTO;
import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/**
 * Unit tests for GetLeagueStatsUseCase
 */
@ExtendWith(MockitoExtension.class)
class GetLeagueStatsUseCaseTest {

    @Mock
    private LeaguePlayerRepository leaguePlayerRepository;

    private GetLeagueStatsUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new GetLeagueStatsUseCase(leaguePlayerRepository);
    }

    @Nested
    @DisplayName("Execute")
    class Execute {

        @Test
        @DisplayName("should return stats for league with players")
        void shouldReturnStatsForLeagueWithPlayers() {
            UUID leagueId = UUID.randomUUID();
            List<LeaguePlayer> allPlayers = List.of(
                    createPlayer("Player 1", 100.0),
                    createPlayer("Player 2", 80.0),
                    createPlayer("Player 3", 60.0)
            );
            List<LeaguePlayer> activePlayers = List.of(
                    createPlayer("Player 1", 100.0),
                    createPlayer("Player 2", 80.0)
            );

            when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(allPlayers);
            when(leaguePlayerRepository.findActivePlayersByLeagueId(leagueId)).thenReturn(activePlayers);

            LeagueStatsDTO result = useCase.execute(leagueId);

            assertNotNull(result);
            assertEquals(leagueId, result.getLeagueId());
            assertEquals(3, result.getTotalPlayers());
            assertEquals(2, result.getActivePlayers());
            assertEquals(1, result.getEliminatedPlayers());
            assertEquals(100.0, result.getHighestScore());
            assertEquals(60.0, result.getLowestScore());
            assertEquals(80.0, result.getAverageScore(), 0.01);
            assertEquals("Player 1", result.getCurrentLeader());
            assertEquals(100.0, result.getLeaderScore());
        }

        @Test
        @DisplayName("should return stats for empty league")
        void shouldReturnStatsForEmptyLeague() {
            UUID leagueId = UUID.randomUUID();

            when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of());
            when(leaguePlayerRepository.findActivePlayersByLeagueId(leagueId)).thenReturn(List.of());

            LeagueStatsDTO result = useCase.execute(leagueId);

            assertNotNull(result);
            assertEquals(leagueId, result.getLeagueId());
            assertEquals(0, result.getTotalPlayers());
            assertEquals(0, result.getActivePlayers());
            assertEquals(0, result.getEliminatedPlayers());
            assertEquals(0.0, result.getHighestScore());
            assertEquals(0.0, result.getLowestScore());
            assertEquals(0.0, result.getAverageScore());
            assertNull(result.getCurrentLeader());
        }

        @Test
        @DisplayName("should handle players with null scores")
        void shouldHandlePlayersWithNullScores() {
            UUID leagueId = UUID.randomUUID();
            LeaguePlayer playerWithNullScore = createPlayer("Player 1", null);
            LeaguePlayer playerWithScore = createPlayer("Player 2", 50.0);

            when(leaguePlayerRepository.findByLeagueId(leagueId))
                    .thenReturn(List.of(playerWithNullScore, playerWithScore));
            when(leaguePlayerRepository.findActivePlayersByLeagueId(leagueId))
                    .thenReturn(List.of(playerWithNullScore, playerWithScore));

            LeagueStatsDTO result = useCase.execute(leagueId);

            assertNotNull(result);
            assertEquals(2, result.getTotalPlayers());
            assertEquals(50.0, result.getHighestScore());
            assertEquals("Player 2", result.getCurrentLeader());
        }

        @Test
        @DisplayName("should calculate correct average with varying scores")
        void shouldCalculateCorrectAverage() {
            UUID leagueId = UUID.randomUUID();
            List<LeaguePlayer> players = List.of(
                    createPlayer("P1", 100.0),
                    createPlayer("P2", 50.0),
                    createPlayer("P3", 75.0),
                    createPlayer("P4", 25.0)
            );

            when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(players);
            when(leaguePlayerRepository.findActivePlayersByLeagueId(leagueId)).thenReturn(players);

            LeagueStatsDTO result = useCase.execute(leagueId);

            assertEquals(62.5, result.getAverageScore(), 0.01);
        }
    }

    private LeaguePlayer createPlayer(String displayName, Double totalScore) {
        LeaguePlayer player = new LeaguePlayer();
        player.setDisplayName(displayName);
        player.setTotalScore(totalScore);
        return player;
    }
}
