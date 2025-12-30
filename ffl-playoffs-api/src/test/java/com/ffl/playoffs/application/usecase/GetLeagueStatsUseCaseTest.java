package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.model.RosterScore;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.domain.port.PlayoffScoreRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("GetLeagueStatsUseCase Tests")
class GetLeagueStatsUseCaseTest {

    @Mock
    private LeaguePlayerRepository leaguePlayerRepository;

    @Mock
    private PlayoffScoreRepository scoreRepository;

    @InjectMocks
    private GetLeagueStatsUseCase useCase;

    private UUID leagueId;
    private UUID player1Id;
    private UUID player2Id;
    private UUID player3Id;

    @BeforeEach
    void setUp() {
        leagueId = UUID.randomUUID();
        player1Id = UUID.randomUUID();
        player2Id = UUID.randomUUID();
        player3Id = UUID.randomUUID();
    }

    @Test
    @DisplayName("Should return correct player counts")
    void shouldReturnCorrectPlayerCounts() {
        // Arrange
        LeaguePlayer active1 = createPlayer(player1Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer active2 = createPlayer(player2Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer inactive = createPlayer(player3Id, LeaguePlayer.LeaguePlayerStatus.INACTIVE);

        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(active1, active2, inactive));
        when(scoreRepository.getCumulativeScores(leagueId)).thenReturn(new HashMap<>());
        when(scoreRepository.findByPlayerId(player1Id)).thenReturn(List.of());
        when(scoreRepository.findByPlayerId(player2Id)).thenReturn(List.of());
        when(scoreRepository.findByPlayerId(player3Id)).thenReturn(List.of());

        var command = new GetLeagueStatsUseCase.GetLeagueStatsCommand(leagueId);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(3, result.getTotalPlayers());
        assertEquals(2, result.getActivePlayers());
        assertEquals(1, result.getEliminatedPlayers());
    }

    @Test
    @DisplayName("Should identify current leader")
    void shouldIdentifyCurrentLeader() {
        // Arrange
        LeaguePlayer player1 = createPlayer(player1Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer player2 = createPlayer(player2Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);

        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(player1, player2));

        Map<UUID, BigDecimal> scores = new HashMap<>();
        scores.put(player1Id, BigDecimal.valueOf(150));
        scores.put(player2Id, BigDecimal.valueOf(200)); // Higher score
        when(scoreRepository.getCumulativeScores(leagueId)).thenReturn(scores);
        when(scoreRepository.findByPlayerId(player1Id)).thenReturn(List.of());
        when(scoreRepository.findByPlayerId(player2Id)).thenReturn(List.of());

        var command = new GetLeagueStatsUseCase.GetLeagueStatsCommand(leagueId);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(player2Id, result.getCurrentLeaderId());
        assertEquals(BigDecimal.valueOf(200), result.getHighestTotalScore());
    }

    @Test
    @DisplayName("Should calculate average score")
    void shouldCalculateAverageScore() {
        // Arrange
        LeaguePlayer player1 = createPlayer(player1Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer player2 = createPlayer(player2Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);

        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(player1, player2));

        Map<UUID, BigDecimal> scores = new HashMap<>();
        scores.put(player1Id, BigDecimal.valueOf(100));
        scores.put(player2Id, BigDecimal.valueOf(200));
        when(scoreRepository.getCumulativeScores(leagueId)).thenReturn(scores);
        when(scoreRepository.findByPlayerId(player1Id)).thenReturn(List.of());
        when(scoreRepository.findByPlayerId(player2Id)).thenReturn(List.of());

        var command = new GetLeagueStatsUseCase.GetLeagueStatsCommand(leagueId);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(BigDecimal.valueOf(150).setScale(2), result.getAverageScore());
    }

    @Test
    @DisplayName("Should handle empty league")
    void shouldHandleEmptyLeague() {
        // Arrange
        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of());
        when(scoreRepository.getCumulativeScores(leagueId)).thenReturn(new HashMap<>());

        var command = new GetLeagueStatsUseCase.GetLeagueStatsCommand(leagueId);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(0, result.getTotalPlayers());
        assertEquals(0, result.getActivePlayers());
        assertEquals(BigDecimal.ZERO, result.getAverageScore());
        assertNull(result.getCurrentLeaderId());
    }

    private LeaguePlayer createPlayer(UUID playerId, LeaguePlayer.LeaguePlayerStatus status) {
        LeaguePlayer player = new LeaguePlayer();
        player.setId(playerId);
        player.setLeagueId(leagueId);
        player.setStatus(status);
        return player;
    }
}
