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
@DisplayName("GetWeeklyRankingsUseCase Tests")
class GetWeeklyRankingsUseCaseTest {

    @Mock
    private LeaguePlayerRepository leaguePlayerRepository;

    @Mock
    private PlayoffScoreRepository scoreRepository;

    @InjectMocks
    private GetWeeklyRankingsUseCase useCase;

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
    @DisplayName("Should return weekly rankings sorted by score descending")
    void shouldReturnWeeklyRankingsSortedByScoreDescending() {
        // Arrange
        LeaguePlayer player1 = createPlayer(player1Id, leagueId, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer player2 = createPlayer(player2Id, leagueId, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer player3 = createPlayer(player3Id, leagueId, LeaguePlayer.LeaguePlayerStatus.ACTIVE);

        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(player1, player2, player3));

        RosterScore score1 = createRosterScore(player1Id, "Player 1", PlayoffRound.WILD_CARD, BigDecimal.valueOf(50));
        RosterScore score2 = createRosterScore(player2Id, "Player 2", PlayoffRound.WILD_CARD, BigDecimal.valueOf(100));
        RosterScore score3 = createRosterScore(player3Id, "Player 3", PlayoffRound.WILD_CARD, BigDecimal.valueOf(75));

        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.WILD_CARD))
                .thenReturn(List.of(score1, score2, score3));

        var command = new GetWeeklyRankingsUseCase.GetWeeklyRankingsCommand(leagueId, 1);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(leagueId, result.getLeagueId());
        assertEquals(1, result.getWeek());
        assertEquals(3, result.getRankings().size());

        // Verify sorted by score descending
        assertEquals(player2Id, result.getRankings().get(0).getPlayerId());
        assertEquals(1, result.getRankings().get(0).getRank());
        assertEquals(0, BigDecimal.valueOf(100).compareTo(result.getRankings().get(0).getWeekScore()));

        assertEquals(player3Id, result.getRankings().get(1).getPlayerId());
        assertEquals(2, result.getRankings().get(1).getRank());

        assertEquals(player1Id, result.getRankings().get(2).getPlayerId());
        assertEquals(3, result.getRankings().get(2).getRank());
    }

    @Test
    @DisplayName("Should convert week 2 to DIVISIONAL round")
    void shouldConvertWeek2ToDivisionalRound() {
        // Arrange
        LeaguePlayer player = createPlayer(player1Id, leagueId, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(player));

        RosterScore score = createRosterScore(player1Id, "Player 1", PlayoffRound.DIVISIONAL, BigDecimal.valueOf(80));
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.DIVISIONAL))
                .thenReturn(List.of(score));

        var command = new GetWeeklyRankingsUseCase.GetWeeklyRankingsCommand(leagueId, 2);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(PlayoffRound.DIVISIONAL, result.getRound());
    }

    @Test
    @DisplayName("Should handle empty week scores")
    void shouldHandleEmptyWeekScores() {
        // Arrange
        LeaguePlayer player = createPlayer(player1Id, leagueId, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(player));
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.WILD_CARD)).thenReturn(List.of());

        var command = new GetWeeklyRankingsUseCase.GetWeeklyRankingsCommand(leagueId, 1);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(1, result.getRankings().size());
        assertEquals(BigDecimal.ZERO, result.getRankings().get(0).getWeekScore());
    }

    @Test
    @DisplayName("Should exclude inactive players")
    void shouldExcludeInactivePlayers() {
        // Arrange
        LeaguePlayer activePlayer = createPlayer(player1Id, leagueId, LeaguePlayer.LeaguePlayerStatus.ACTIVE);
        LeaguePlayer inactivePlayer = createPlayer(player2Id, leagueId, LeaguePlayer.LeaguePlayerStatus.INACTIVE);

        when(leaguePlayerRepository.findByLeagueId(leagueId)).thenReturn(List.of(activePlayer, inactivePlayer));

        RosterScore score1 = createRosterScore(player1Id, "Player 1", PlayoffRound.WILD_CARD, BigDecimal.valueOf(100));
        RosterScore score2 = createRosterScore(player2Id, "Player 2", PlayoffRound.WILD_CARD, BigDecimal.valueOf(50));
        when(scoreRepository.findByLeagueIdAndRound(leagueId, PlayoffRound.WILD_CARD))
                .thenReturn(List.of(score1, score2));

        var command = new GetWeeklyRankingsUseCase.GetWeeklyRankingsCommand(leagueId, 1);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(1, result.getRankings().size());
        assertEquals(player1Id, result.getRankings().get(0).getPlayerId());
    }

    private LeaguePlayer createPlayer(UUID playerId, UUID leagueId, LeaguePlayer.LeaguePlayerStatus status) {
        LeaguePlayer player = new LeaguePlayer();
        player.setId(playerId);
        player.setLeagueId(leagueId);
        player.setStatus(status);
        return player;
    }

    private RosterScore createRosterScore(UUID playerId, String playerName, PlayoffRound round, BigDecimal score) {
        PositionScore posScore = new PositionScore(Position.QB, 1L, "Test Player", "KC",
                score, "ACTIVE", null);
        return new RosterScore(playerId, playerName, round, List.of(posScore));
    }
}
