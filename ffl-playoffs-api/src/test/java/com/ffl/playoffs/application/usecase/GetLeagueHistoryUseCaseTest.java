package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.model.PositionScore;
import com.ffl.playoffs.domain.model.Position;
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
import java.util.List;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("GetLeagueHistoryUseCase Tests")
class GetLeagueHistoryUseCaseTest {

    @Mock
    private LeaguePlayerRepository leaguePlayerRepository;

    @Mock
    private PlayoffScoreRepository scoreRepository;

    @InjectMocks
    private GetLeagueHistoryUseCase useCase;

    private UUID leagueId;
    private UUID player1Id;
    private UUID player2Id;

    @BeforeEach
    void setUp() {
        leagueId = UUID.randomUUID();
        player1Id = UUID.randomUUID();
        player2Id = UUID.randomUUID();
    }

    @Test
    @DisplayName("Should return history for all weeks with scores")
    void shouldReturnHistoryForAllWeeksWithScores() {
        // Arrange
        LeaguePlayer player1 = createPlayer(player1Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer player2 = createPlayer(player2Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);

        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(player1, player2));

        RosterScore week1Score1 = createRosterScore(player1Id, PlayoffRound.WILD_CARD, BigDecimal.valueOf(50));
        RosterScore week1Score2 = createRosterScore(player2Id, PlayoffRound.WILD_CARD, BigDecimal.valueOf(40));
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.WILD_CARD))
                .thenReturn(List.of(week1Score1, week1Score2));

        RosterScore week2Score1 = createRosterScore(player1Id, PlayoffRound.DIVISIONAL, BigDecimal.valueOf(45));
        RosterScore week2Score2 = createRosterScore(player2Id, PlayoffRound.DIVISIONAL, BigDecimal.valueOf(55));
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.DIVISIONAL))
                .thenReturn(List.of(week2Score1, week2Score2));

        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.CONFERENCE)).thenReturn(List.of());
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.SUPER_BOWL)).thenReturn(List.of());

        var command = new GetLeagueHistoryUseCase.GetLeagueHistoryCommand(leagueId);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(leagueId, result.getLeagueId());
        assertEquals(2, result.getWeekHistories().size()); // Only weeks with scores

        // Week 1
        var week1 = result.getWeekHistories().get(0);
        assertEquals(1, week1.getWeek());
        assertEquals(PlayoffRound.WILD_CARD, week1.getRound());

        // Week 2
        var week2 = result.getWeekHistories().get(1);
        assertEquals(2, week2.getWeek());
        assertEquals(PlayoffRound.DIVISIONAL, week2.getRound());
    }

    @Test
    @DisplayName("Should mark eliminated players")
    void shouldMarkEliminatedPlayers() {
        // Arrange
        LeaguePlayer activePlayer = createPlayer(player1Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer eliminatedPlayer = createPlayer(player2Id, LeaguePlayer.LeaguePlayerStatus.INACTIVE);

        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(activePlayer, eliminatedPlayer));

        RosterScore score1 = createRosterScore(player1Id, PlayoffRound.WILD_CARD, BigDecimal.valueOf(50));
        RosterScore score2 = createRosterScore(player2Id, PlayoffRound.WILD_CARD, BigDecimal.valueOf(25));
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.WILD_CARD))
                .thenReturn(List.of(score1, score2));

        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.DIVISIONAL)).thenReturn(List.of());
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.CONFERENCE)).thenReturn(List.of());
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.SUPER_BOWL)).thenReturn(List.of());

        var command = new GetLeagueHistoryUseCase.GetLeagueHistoryCommand(leagueId);

        // Act
        var result = useCase.execute(command);

        // Assert
        var standings = result.getWeekHistories().get(0).getStandings();
        var player1Standing = standings.stream().filter(s -> s.getPlayerId().equals(player1Id)).findFirst().orElseThrow();
        var player2Standing = standings.stream().filter(s -> s.getPlayerId().equals(player2Id)).findFirst().orElseThrow();

        assertFalse(player1Standing.isEliminated());
        assertTrue(player2Standing.isEliminated());
    }

    @Test
    @DisplayName("Should assign ranks based on cumulative scores")
    void shouldAssignRanksBasedOnCumulativeScores() {
        // Arrange
        LeaguePlayer player1 = createPlayer(player1Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer player2 = createPlayer(player2Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);

        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(player1, player2));

        RosterScore score1 = createRosterScore(player1Id, PlayoffRound.WILD_CARD, BigDecimal.valueOf(25));
        RosterScore score2 = createRosterScore(player2Id, PlayoffRound.WILD_CARD, BigDecimal.valueOf(50));
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.WILD_CARD))
                .thenReturn(List.of(score1, score2));

        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.DIVISIONAL)).thenReturn(List.of());
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.CONFERENCE)).thenReturn(List.of());
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.SUPER_BOWL)).thenReturn(List.of());

        var command = new GetLeagueHistoryUseCase.GetLeagueHistoryCommand(leagueId);

        // Act
        var result = useCase.execute(command);

        // Assert
        var standings = result.getWeekHistories().get(0).getStandings();
        assertEquals(player2Id, standings.get(0).getPlayerId());
        assertEquals(1, standings.get(0).getRank());
        assertEquals(player1Id, standings.get(1).getPlayerId());
        assertEquals(2, standings.get(1).getRank());
    }

    @Test
    @DisplayName("Should handle empty league history")
    void shouldHandleEmptyLeagueHistory() {
        // Arrange
        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of());
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.WILD_CARD)).thenReturn(List.of());
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.DIVISIONAL)).thenReturn(List.of());
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.CONFERENCE)).thenReturn(List.of());
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.SUPER_BOWL)).thenReturn(List.of());

        var command = new GetLeagueHistoryUseCase.GetLeagueHistoryCommand(leagueId);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertTrue(result.getWeekHistories().isEmpty());
    }

    private LeaguePlayer createPlayer(UUID playerId, LeaguePlayer.LeaguePlayerStatus status) {
        LeaguePlayer player = new LeaguePlayer();
        player.setId(playerId);
        player.setLeagueId(leagueId);
        player.setStatus(status);
        return player;
    }

    private RosterScore createRosterScore(UUID playerId, PlayoffRound round, BigDecimal points) {
        PositionScore posScore = new PositionScore(Position.QB, 1L, "Test Player", "KC",
                points, "ACTIVE", null);
        return new RosterScore(playerId, "Player " + playerId.toString().substring(0, 8), round, List.of(posScore));
    }
}
