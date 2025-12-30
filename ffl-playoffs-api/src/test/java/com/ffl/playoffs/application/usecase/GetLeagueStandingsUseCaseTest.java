package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.LeaguePlayer;
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
@DisplayName("GetLeagueStandingsUseCase Tests")
class GetLeagueStandingsUseCaseTest {

    @Mock
    private LeaguePlayerRepository leaguePlayerRepository;

    @Mock
    private PlayoffScoreRepository scoreRepository;

    @InjectMocks
    private GetLeagueStandingsUseCase useCase;

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
    @DisplayName("Should return standings sorted by score descending")
    void shouldReturnStandingsSortedByScoreDescending() {
        // Arrange
        LeaguePlayer player1 = createPlayer(player1Id, leagueId, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer player2 = createPlayer(player2Id, leagueId, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer player3 = createPlayer(player3Id, leagueId, LeaguePlayer.LeaguePlayerStatus.ACTIVE);

        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(player1, player2, player3));

        Map<UUID, BigDecimal> scores = new HashMap<>();
        scores.put(player1Id, BigDecimal.valueOf(50));
        scores.put(player2Id, BigDecimal.valueOf(100)); // Highest
        scores.put(player3Id, BigDecimal.valueOf(75));
        when(scoreRepository.getCumulativeScores(leagueId)).thenReturn(scores);

        var command = new GetLeagueStandingsUseCase.GetStandingsCommand(leagueId, true);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(3, result.getTotalPlayers());
        assertEquals(leagueId, result.getLeagueId());

        // Verify sorted by score descending
        assertEquals(player2Id, result.getStandings().get(0).getPlayerId());
        assertEquals(1, result.getStandings().get(0).getRank());
        assertEquals(BigDecimal.valueOf(100), result.getStandings().get(0).getTotalScore());

        assertEquals(player3Id, result.getStandings().get(1).getPlayerId());
        assertEquals(2, result.getStandings().get(1).getRank());

        assertEquals(player1Id, result.getStandings().get(2).getPlayerId());
        assertEquals(3, result.getStandings().get(2).getRank());
    }

    @Test
    @DisplayName("Should exclude eliminated players when includeEliminated is false")
    void shouldExcludeEliminatedPlayersWhenFlagIsFalse() {
        // Arrange
        LeaguePlayer activePlayer = createPlayer(player1Id, leagueId, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer inactivePlayer = createPlayer(player2Id, leagueId, LeaguePlayer.LeaguePlayerStatus.INACTIVE);
        LeaguePlayer removedPlayer = createPlayer(player3Id, leagueId, LeaguePlayer.LeaguePlayerStatus.REMOVED);

        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(activePlayer, inactivePlayer, removedPlayer));

        Map<UUID, BigDecimal> scores = new HashMap<>();
        scores.put(player1Id, BigDecimal.valueOf(100));
        scores.put(player2Id, BigDecimal.valueOf(50));
        scores.put(player3Id, BigDecimal.valueOf(25));
        when(scoreRepository.getCumulativeScores(leagueId)).thenReturn(scores);

        var command = new GetLeagueStandingsUseCase.GetStandingsCommand(leagueId, false);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(1, result.getStandings().size());
        assertEquals(player1Id, result.getStandings().get(0).getPlayerId());
        assertFalse(result.getStandings().get(0).isEliminated());
    }

    @Test
    @DisplayName("Should include eliminated players when includeEliminated is true")
    void shouldIncludeEliminatedPlayersWhenFlagIsTrue() {
        // Arrange
        LeaguePlayer activePlayer = createPlayer(player1Id, leagueId, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer inactivePlayer = createPlayer(player2Id, leagueId, LeaguePlayer.LeaguePlayerStatus.INACTIVE);

        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(activePlayer, inactivePlayer));

        Map<UUID, BigDecimal> scores = new HashMap<>();
        scores.put(player1Id, BigDecimal.valueOf(100));
        scores.put(player2Id, BigDecimal.valueOf(50));
        when(scoreRepository.getCumulativeScores(leagueId)).thenReturn(scores);

        var command = new GetLeagueStandingsUseCase.GetStandingsCommand(leagueId, true);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(2, result.getStandings().size());
        assertTrue(result.getStandings().stream()
                .anyMatch(s -> s.getPlayerId().equals(player2Id) && s.isEliminated()));
    }

    @Test
    @DisplayName("Should handle empty league")
    void shouldHandleEmptyLeague() {
        // Arrange
        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of());
        when(scoreRepository.getCumulativeScores(leagueId)).thenReturn(new HashMap<>());

        var command = new GetLeagueStandingsUseCase.GetStandingsCommand(leagueId, true);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(0, result.getTotalPlayers());
        assertTrue(result.getStandings().isEmpty());
    }

    @Test
    @DisplayName("Should handle player with no score")
    void shouldHandlePlayerWithNoScore() {
        // Arrange
        LeaguePlayer player = createPlayer(player1Id, leagueId, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(player));
        when(scoreRepository.getCumulativeScores(leagueId)).thenReturn(new HashMap<>()); // No scores

        var command = new GetLeagueStandingsUseCase.GetStandingsCommand(leagueId, true);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(1, result.getStandings().size());
        assertEquals(BigDecimal.ZERO, result.getStandings().get(0).getTotalScore());
    }

    private LeaguePlayer createPlayer(UUID playerId, UUID leagueId, LeaguePlayer.LeaguePlayerStatus status) {
        LeaguePlayer player = new LeaguePlayer();
        player.setId(playerId);
        player.setLeagueId(leagueId);
        player.setStatus(status);
        return player;
    }
}
