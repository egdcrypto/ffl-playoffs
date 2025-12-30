package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.PositionScore;
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
@DisplayName("GetMatchupsUseCase Tests")
class GetMatchupsUseCaseTest {

    @Mock
    private LeaguePlayerRepository leaguePlayerRepository;

    @Mock
    private PlayoffScoreRepository scoreRepository;

    @InjectMocks
    private GetMatchupsUseCase useCase;

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
    @DisplayName("Should calculate wins, losses, and ties correctly")
    void shouldCalculateWinsLossesAndTiesCorrectly() {
        // Arrange
        LeaguePlayer player1 = createPlayer(player1Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer player2 = createPlayer(player2Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer player3 = createPlayer(player3Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);

        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(player1, player2, player3));

        RosterScore score1 = createRosterScore(player1Id, BigDecimal.valueOf(100)); // Highest
        RosterScore score2 = createRosterScore(player2Id, BigDecimal.valueOf(80));
        RosterScore score3 = createRosterScore(player3Id, BigDecimal.valueOf(60));

        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.WILD_CARD))
                .thenReturn(List.of(score1, score2, score3));

        var command = new GetMatchupsUseCase.GetMatchupsCommand(leagueId, 1);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(leagueId, result.getLeagueId());
        assertEquals(1, result.getWeek());
        assertEquals(3, result.getMatchupRecords().size());

        // Player 1 should have 2 wins (beat player2 and player3)
        var player1Record = result.getMatchupRecords().stream()
                .filter(r -> r.getPlayerId().equals(player1Id))
                .findFirst().orElseThrow();
        assertEquals(2, player1Record.getWins());
        assertEquals(0, player1Record.getLosses());
        assertEquals(0, player1Record.getTies());

        // Player 2 should have 1 win, 1 loss
        var player2Record = result.getMatchupRecords().stream()
                .filter(r -> r.getPlayerId().equals(player2Id))
                .findFirst().orElseThrow();
        assertEquals(1, player2Record.getWins());
        assertEquals(1, player2Record.getLosses());
        assertEquals(0, player2Record.getTies());

        // Player 3 should have 0 wins, 2 losses
        var player3Record = result.getMatchupRecords().stream()
                .filter(r -> r.getPlayerId().equals(player3Id))
                .findFirst().orElseThrow();
        assertEquals(0, player3Record.getWins());
        assertEquals(2, player3Record.getLosses());
        assertEquals(0, player3Record.getTies());
    }

    @Test
    @DisplayName("Should handle ties correctly")
    void shouldHandleTiesCorrectly() {
        // Arrange
        LeaguePlayer player1 = createPlayer(player1Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer player2 = createPlayer(player2Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);

        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(player1, player2));

        RosterScore score1 = createRosterScore(player1Id, BigDecimal.valueOf(100));
        RosterScore score2 = createRosterScore(player2Id, BigDecimal.valueOf(100)); // Same score

        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.WILD_CARD))
                .thenReturn(List.of(score1, score2));

        var command = new GetMatchupsUseCase.GetMatchupsCommand(leagueId, 1);

        // Act
        var result = useCase.execute(command);

        // Assert
        for (var record : result.getMatchupRecords()) {
            assertEquals(0, record.getWins());
            assertEquals(0, record.getLosses());
            assertEquals(1, record.getTies());
        }
    }

    @Test
    @DisplayName("Should sort matchup records by wins descending")
    void shouldSortMatchupRecordsByWinsDescending() {
        // Arrange
        LeaguePlayer player1 = createPlayer(player1Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer player2 = createPlayer(player2Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer player3 = createPlayer(player3Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);

        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(player1, player2, player3));

        RosterScore score1 = createRosterScore(player1Id, BigDecimal.valueOf(60)); // Lowest
        RosterScore score2 = createRosterScore(player2Id, BigDecimal.valueOf(100)); // Highest
        RosterScore score3 = createRosterScore(player3Id, BigDecimal.valueOf(80));

        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.WILD_CARD))
                .thenReturn(List.of(score1, score2, score3));

        var command = new GetMatchupsUseCase.GetMatchupsCommand(leagueId, 1);

        // Act
        var result = useCase.execute(command);

        // Assert - Should be sorted: player2 (2 wins), player3 (1 win), player1 (0 wins)
        assertEquals(player2Id, result.getMatchupRecords().get(0).getPlayerId());
        assertEquals(player3Id, result.getMatchupRecords().get(1).getPlayerId());
        assertEquals(player1Id, result.getMatchupRecords().get(2).getPlayerId());
    }

    @Test
    @DisplayName("Should exclude inactive players from matchups")
    void shouldExcludeInactivePlayersFromMatchups() {
        // Arrange
        LeaguePlayer activePlayer = createPlayer(player1Id, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer inactivePlayer = createPlayer(player2Id, LeaguePlayer.LeaguePlayerStatus.INACTIVE);

        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(activePlayer, inactivePlayer));

        RosterScore score1 = createRosterScore(player1Id, BigDecimal.valueOf(100));
        RosterScore score2 = createRosterScore(player2Id, BigDecimal.valueOf(50));
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.WILD_CARD))
                .thenReturn(List.of(score1, score2));

        var command = new GetMatchupsUseCase.GetMatchupsCommand(leagueId, 1);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(1, result.getMatchupRecords().size());
        assertEquals(player1Id, result.getMatchupRecords().get(0).getPlayerId());
        assertEquals(0, result.getMatchupRecords().get(0).getHeadToHeadResults().size()); // No opponents
    }

    private LeaguePlayer createPlayer(UUID playerId, LeaguePlayer.LeaguePlayerStatus status) {
        LeaguePlayer player = new LeaguePlayer();
        player.setId(playerId);
        player.setLeagueId(leagueId);
        player.setStatus(status);
        return player;
    }

    private RosterScore createRosterScore(UUID playerId, BigDecimal totalScore) {
        PositionScore posScore = new PositionScore(Position.QB, 1L, "Test Player", "KC",
                totalScore, "ACTIVE", null);
        return new RosterScore(playerId, "Player " + playerId.toString().substring(0, 8), PlayoffRound.WILD_CARD, List.of(posScore));
    }
}
