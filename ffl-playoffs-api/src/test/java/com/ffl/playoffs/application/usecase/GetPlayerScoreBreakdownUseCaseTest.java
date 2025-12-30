package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.PositionScore;
import com.ffl.playoffs.domain.model.RosterScore;
import com.ffl.playoffs.domain.port.PlayoffScoreRepository;
import com.ffl.playoffs.domain.port.RosterRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
@DisplayName("GetPlayerScoreBreakdownUseCase Tests")
class GetPlayerScoreBreakdownUseCaseTest {

    @Mock
    private RosterRepository rosterRepository;

    @Mock
    private PlayoffScoreRepository scoreRepository;

    @InjectMocks
    private GetPlayerScoreBreakdownUseCase useCase;

    private UUID leagueId;
    private UUID playerId;

    @BeforeEach
    void setUp() {
        leagueId = UUID.randomUUID();
        playerId = UUID.randomUUID();
    }

    @Test
    @DisplayName("Should return breakdown for all weeks when no week filter")
    void shouldReturnBreakdownForAllWeeks() {
        // Arrange
        PositionScore posScore1 = new PositionScore(Position.QB, 1L, "Patrick Mahomes", "KC",
                BigDecimal.valueOf(25), "ACTIVE", null);
        PositionScore posScore2 = new PositionScore(Position.RB, 2L, "Derrick Henry", "TEN",
                BigDecimal.valueOf(18), "ACTIVE", null);

        RosterScore score1 = new RosterScore(playerId, "Player 1", PlayoffRound.WILD_CARD, List.of(posScore1));
        RosterScore score2 = new RosterScore(playerId, "Player 1", PlayoffRound.DIVISIONAL, List.of(posScore2));

        when(scoreRepository.findByPlayerId(playerId)).thenReturn(List.of(score1, score2));

        var command = new GetPlayerScoreBreakdownUseCase.GetScoreBreakdownCommand(leagueId, playerId, null);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(leagueId, result.getLeagueId());
        assertEquals(playerId, result.getPlayerId());
        assertEquals(2, result.getWeeklyBreakdowns().size());
    }

    @Test
    @DisplayName("Should return breakdown for specific week when week filter provided")
    void shouldReturnBreakdownForSpecificWeek() {
        // Arrange
        PositionScore posScore = new PositionScore(Position.QB, 1L, "Patrick Mahomes", "KC",
                BigDecimal.valueOf(30), "ACTIVE", null);
        RosterScore score = new RosterScore(playerId, "Player 1", PlayoffRound.WILD_CARD, List.of(posScore));

        when(scoreRepository.findByPlayerIdAndRound(playerId, PlayoffRound.WILD_CARD))
                .thenReturn(Optional.of(score));

        var command = new GetPlayerScoreBreakdownUseCase.GetScoreBreakdownCommand(leagueId, playerId, 1);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(1, result.getWeeklyBreakdowns().size());
        assertEquals(1, result.getWeeklyBreakdowns().get(0).getWeek());
    }

    @Test
    @DisplayName("Should include position score details")
    void shouldIncludePositionScoreDetails() {
        // Arrange
        PositionScore positionScore = new PositionScore(Position.QB, 1L, "Patrick Mahomes", "KC",
                BigDecimal.valueOf(25), "ACTIVE", null);

        RosterScore score = new RosterScore(playerId, "Player 1", PlayoffRound.WILD_CARD, List.of(positionScore));
        when(scoreRepository.findByPlayerId(playerId)).thenReturn(List.of(score));

        var command = new GetPlayerScoreBreakdownUseCase.GetScoreBreakdownCommand(leagueId, playerId, null);

        // Act
        var result = useCase.execute(command);

        // Assert
        var breakdown = result.getWeeklyBreakdowns().get(0);
        assertEquals(1, breakdown.getPlayerDetails().size());

        var detail = breakdown.getPlayerDetails().get(0);
        assertEquals(Position.QB, detail.getPosition());
        assertEquals("Patrick Mahomes", detail.getPlayerName());
        assertEquals("KC", detail.getTeamCode());
        assertEquals(BigDecimal.valueOf(25).setScale(2), detail.getPoints());
        assertFalse(detail.isOnBye());
        assertTrue(detail.isActive());
    }

    @Test
    @DisplayName("Should handle empty scores")
    void shouldHandleEmptyScores() {
        // Arrange
        when(scoreRepository.findByPlayerId(playerId)).thenReturn(List.of());

        var command = new GetPlayerScoreBreakdownUseCase.GetScoreBreakdownCommand(leagueId, playerId, null);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(BigDecimal.ZERO, result.getTotalScore());
        assertTrue(result.getWeeklyBreakdowns().isEmpty());
    }

    @Test
    @DisplayName("Should handle score with no position scores")
    void shouldHandleScoreWithNoPositionScores() {
        // Arrange
        RosterScore score = new RosterScore(playerId, "Player 1", PlayoffRound.WILD_CARD, List.of());
        when(scoreRepository.findByPlayerId(playerId)).thenReturn(List.of(score));

        var command = new GetPlayerScoreBreakdownUseCase.GetScoreBreakdownCommand(leagueId, playerId, null);

        // Act
        var result = useCase.execute(command);

        // Assert
        assertEquals(1, result.getWeeklyBreakdowns().size());
        assertTrue(result.getWeeklyBreakdowns().get(0).getPlayerDetails().isEmpty());
    }
}
