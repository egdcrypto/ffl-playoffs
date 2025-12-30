package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.model.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Unit tests for TiebreakerResolver domain service
 */
@DisplayName("TiebreakerResolver Tests")
class TiebreakerResolverTest {

    private TiebreakerResolver resolver;
    private UUID player1Id;
    private UUID player2Id;

    @BeforeEach
    void setUp() {
        resolver = new TiebreakerResolver();
        player1Id = UUID.randomUUID();
        player2Id = UUID.randomUUID();
    }

    @Nested
    @DisplayName("Highest Position Score Tiebreaker")
    class HighestPositionScoreTiebreakerTests {

        @Test
        @DisplayName("Should resolve tie by highest single position score")
        void shouldResolveTieByHighestPositionScore() {
            // Given - Player 1 has higher QB score
            RosterScore score1 = createRosterScore(player1Id, "John", List.of(
                createPositionScore(Position.QB, new BigDecimal("32.5")),
                createPositionScore(Position.RB, new BigDecimal("20.0"))
            ));
            RosterScore score2 = createRosterScore(player2Id, "Jane", List.of(
                createPositionScore(Position.QB, new BigDecimal("28.0")),
                createPositionScore(Position.RB, new BigDecimal("24.5"))
            ));

            // When
            TiebreakerResult result = resolver.applyTiebreaker(
                TiebreakerMethod.HIGHEST_SINGLE_POSITION_SCORE,
                score1, score2, 1, 2
            );

            // Then
            assertThat(result.isResolved()).isTrue();
            assertThat(result.getWinnerId()).isEqualTo(player1Id);
            assertThat(result.getLoserId()).isEqualTo(player2Id);
            assertThat(result.getMethodUsed()).isEqualTo(TiebreakerMethod.HIGHEST_SINGLE_POSITION_SCORE);
        }

        @Test
        @DisplayName("Should remain tied if highest scores are equal")
        void shouldRemainTiedIfHighestScoresAreEqual() {
            // Given - Both players have same highest score
            RosterScore score1 = createRosterScore(player1Id, "John", List.of(
                createPositionScore(Position.QB, new BigDecimal("30.0")),
                createPositionScore(Position.RB, new BigDecimal("20.0"))
            ));
            RosterScore score2 = createRosterScore(player2Id, "Jane", List.of(
                createPositionScore(Position.QB, new BigDecimal("30.0")),
                createPositionScore(Position.RB, new BigDecimal("20.0"))
            ));

            // When
            TiebreakerResult result = resolver.applyTiebreaker(
                TiebreakerMethod.HIGHEST_SINGLE_POSITION_SCORE,
                score1, score2, 1, 2
            );

            // Then
            assertThat(result.isTied()).isTrue();
        }
    }

    @Nested
    @DisplayName("Most Touchdowns Tiebreaker")
    class MostTouchdownsTiebreakerTests {

        @Test
        @DisplayName("Should resolve tie by most touchdowns")
        void shouldResolveTieByMostTouchdowns() {
            // Given - Player 1 has more touchdowns
            RosterScore score1 = createRosterScoreWithTouchdowns(player1Id, "John", 8);
            RosterScore score2 = createRosterScoreWithTouchdowns(player2Id, "Jane", 6);

            // When
            TiebreakerResult result = resolver.applyTiebreaker(
                TiebreakerMethod.MOST_TOUCHDOWNS,
                score1, score2, 1, 2
            );

            // Then
            assertThat(result.isResolved()).isTrue();
            assertThat(result.getWinnerId()).isEqualTo(player1Id);
            assertThat(result.getWinnerValue()).isEqualTo("8");
            assertThat(result.getLoserValue()).isEqualTo("6");
        }
    }

    @Nested
    @DisplayName("Higher Seed Tiebreaker")
    class HigherSeedTiebreakerTests {

        @Test
        @DisplayName("Should resolve tie by higher seed")
        void shouldResolveTieByHigherSeed() {
            // Given
            RosterScore score1 = createRosterScore(player1Id, "John", List.of());
            RosterScore score2 = createRosterScore(player2Id, "Jane", List.of());

            // When - Player 1 is seed 2, Player 2 is seed 5
            TiebreakerResult result = resolver.applyTiebreaker(
                TiebreakerMethod.HIGHER_SEED,
                score1, score2, 2, 5
            );

            // Then - Lower seed number wins
            assertThat(result.isResolved()).isTrue();
            assertThat(result.getWinnerId()).isEqualTo(player1Id);
        }
    }

    @Nested
    @DisplayName("Cascading Tiebreakers")
    class CascadingTiebreakersTests {

        @Test
        @DisplayName("Should cascade through tiebreakers until resolved")
        void shouldCascadeThroughTiebreakers() {
            // Given - Tied on first tiebreaker, resolved on second
            RosterScore score1 = createRosterScore(player1Id, "John", List.of(
                createPositionScore(Position.QB, new BigDecimal("30.0")),
                createPositionScore(Position.RB, new BigDecimal("25.0"))  // Higher second score
            ));
            RosterScore score2 = createRosterScore(player2Id, "Jane", List.of(
                createPositionScore(Position.QB, new BigDecimal("30.0")),
                createPositionScore(Position.RB, new BigDecimal("20.0"))
            ));

            // When
            TiebreakerResult result = resolver.resolveTie(score1, score2, 1, 2);

            // Then - Resolved by second highest position score
            assertThat(result.isResolved()).isTrue();
            assertThat(result.getWinnerId()).isEqualTo(player1Id);
        }

        @Test
        @DisplayName("Should declare co-winners if all tiebreakers exhausted")
        void shouldDeclareCoWinnersIfAllTiebreakersExhausted() {
            // Given - Identical scores with same seed (shouldn't happen normally)
            RosterScore score1 = createRosterScore(player1Id, "John", List.of(
                createPositionScore(Position.QB, new BigDecimal("30.0"))
            ));
            RosterScore score2 = createRosterScore(player2Id, "Jane", List.of(
                createPositionScore(Position.QB, new BigDecimal("30.0"))
            ));

            // Create resolver with only one tiebreaker that will tie
            TiebreakerConfiguration config = new TiebreakerConfiguration(List.of(
                TiebreakerMethod.HIGHEST_SINGLE_POSITION_SCORE
            ));
            TiebreakerResolver customResolver = new TiebreakerResolver(config);

            // When
            TiebreakerResult result = customResolver.resolveTie(score1, score2, 1, 1);

            // Then - Co-winners declared
            assertThat(result.getMethodUsed()).isEqualTo(TiebreakerMethod.CO_WINNERS);
        }
    }

    // Helper methods

    private RosterScore createRosterScore(UUID playerId, String name, List<PositionScore> positionScores) {
        return new RosterScore(playerId, name, PlayoffRound.WILD_CARD, positionScores);
    }

    private RosterScore createRosterScoreWithTouchdowns(UUID playerId, String name, int touchdowns) {
        PositionScore.PositionStats stats = PositionScore.PositionStats.builder()
            .rushingTouchdowns(touchdowns / 2)
            .receivingTouchdowns(touchdowns - touchdowns / 2)
            .build();

        PositionScore positionScore = new PositionScore(
            Position.RB, 1L, name, "Team",
            new BigDecimal("50.0"), "ACTIVE", stats
        );

        return new RosterScore(playerId, name, PlayoffRound.WILD_CARD, List.of(positionScore));
    }

    private PositionScore createPositionScore(Position position, BigDecimal points) {
        return new PositionScore(
            position, 1L, "Player", "Team",
            points, "ACTIVE", null
        );
    }
}
