package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.model.PPRScoringConfiguration;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.PositionScore;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.math.BigDecimal;
import java.math.RoundingMode;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Unit tests for PlayoffScoringCalculator domain service
 * Tests PPR scoring calculations for all positions
 */
@DisplayName("PlayoffScoringCalculator Tests")
class PlayoffScoringCalculatorTest {

    private PlayoffScoringCalculator calculator;

    @BeforeEach
    void setUp() {
        calculator = new PlayoffScoringCalculator();
    }

    @Nested
    @DisplayName("Quarterback Scoring")
    class QuarterbackScoringTests {

        @Test
        @DisplayName("Should calculate QB score with passing yards and TDs")
        void shouldCalculateQBScoreWithPassingYardsAndTDs() {
            // Given - Patrick Mahomes: 350 passing yards, 3 TDs
            PositionScore.PositionStats stats = PositionScore.PositionStats.builder()
                .passingYards(350)
                .passingTouchdowns(3)
                .build();

            // When
            BigDecimal score = calculator.calculateQBScore(stats);

            // Then: 350 * 0.04 + 3 * 4 + 3 (bonus for 300+ yards) = 14 + 12 + 3 = 29
            assertThat(score).isEqualByComparingTo(new BigDecimal("29.00"));
        }

        @Test
        @DisplayName("Should apply turnover penalties")
        void shouldApplyTurnoverPenalties() {
            // Given - Josh Allen: 250 yards, 2 TDs, 3 INTs
            PositionScore.PositionStats stats = PositionScore.PositionStats.builder()
                .passingYards(250)
                .passingTouchdowns(2)
                .interceptions(3)
                .build();

            // When
            BigDecimal score = calculator.calculateQBScore(stats);

            // Then: 250 * 0.04 + 2 * 4 + 3 * -2 = 10 + 8 - 6 = 12
            assertThat(score).isEqualByComparingTo(new BigDecimal("12.00"));
        }

        @Test
        @DisplayName("Should include rushing yards for mobile QB")
        void shouldIncludeRushingYardsForMobileQB() {
            // Given - QB with rushing stats
            PositionScore.PositionStats stats = PositionScore.PositionStats.builder()
                .passingYards(200)
                .passingTouchdowns(1)
                .rushingYards(50)
                .rushingTouchdowns(1)
                .build();

            // When
            BigDecimal score = calculator.calculateQBScore(stats);

            // Then: 200 * 0.04 + 1 * 4 + 50 * 0.1 + 1 * 6 = 8 + 4 + 5 + 6 = 23
            assertThat(score).isEqualByComparingTo(new BigDecimal("23.00"));
        }
    }

    @Nested
    @DisplayName("Running Back Scoring")
    class RunningBackScoringTests {

        @Test
        @DisplayName("Should calculate RB score with rushing and receiving")
        void shouldCalculateRBScoreWithRushingAndReceiving() {
            // Given - RB: 120 rushing yards, 1 TD, 5 receptions, 40 receiving yards
            PositionScore.PositionStats stats = PositionScore.PositionStats.builder()
                .rushingYards(120)
                .rushingTouchdowns(1)
                .receptions(5)
                .receivingYards(40)
                .build();

            // When
            BigDecimal score = calculator.calculateRBScore(stats);

            // Then: 120 * 0.1 + 1 * 6 + 5 * 1 + 40 * 0.1 + 3 (100+ rush bonus) = 12 + 6 + 5 + 4 + 3 = 30
            assertThat(score).isEqualByComparingTo(new BigDecimal("30.00"));
        }

        @Test
        @DisplayName("Should apply fumble penalty")
        void shouldApplyFumblePenalty() {
            // Given - RB with fumble
            PositionScore.PositionStats stats = PositionScore.PositionStats.builder()
                .rushingYards(80)
                .rushingTouchdowns(1)
                .fumblesLost(1)
                .build();

            // When
            BigDecimal score = calculator.calculateRBScore(stats);

            // Then: 80 * 0.1 + 1 * 6 + 1 * -2 = 8 + 6 - 2 = 12
            assertThat(score).isEqualByComparingTo(new BigDecimal("12.00"));
        }
    }

    @Nested
    @DisplayName("Wide Receiver Scoring")
    class WideReceiverScoringTests {

        @Test
        @DisplayName("Should calculate WR score with PPR bonus")
        void shouldCalculateWRScoreWithPPRBonus() {
            // Given - WR: 8 receptions, 110 receiving yards, 1 TD
            PositionScore.PositionStats stats = PositionScore.PositionStats.builder()
                .receptions(8)
                .receivingYards(110)
                .receivingTouchdowns(1)
                .build();

            // When
            BigDecimal score = calculator.calculateWRScore(stats);

            // Then: 8 * 1 + 110 * 0.1 + 1 * 6 + 3 (100+ receiving bonus) = 8 + 11 + 6 + 3 = 28
            assertThat(score).isEqualByComparingTo(new BigDecimal("28.00"));
        }
    }

    @Nested
    @DisplayName("Kicker Scoring")
    class KickerScoringTests {

        @Test
        @DisplayName("Should calculate kicker score with distance-based field goals")
        void shouldCalculateKickerScoreWithDistanceBasedFieldGoals() {
            // Given - Harrison Butker: 2 XP, 1 FG (35 yards), 2 FG (48 yards), 1 FG (52 yards)
            PositionScore.PositionStats stats = PositionScore.PositionStats.builder()
                .extraPointsMade(2)
                .fieldGoalsMade0to39(1)
                .fieldGoalsMade40to49(2)
                .fieldGoalsMade50Plus(1)
                .build();

            // When
            BigDecimal score = calculator.calculateKickerScore(stats);

            // Then: 2*1 + 1*3 + 2*4 + 1*5 = 2 + 3 + 8 + 5 = 18
            assertThat(score).isEqualByComparingTo(new BigDecimal("18.00"));
        }
    }

    @Nested
    @DisplayName("Defense/Special Teams Scoring")
    class DefenseScoringTests {

        @Test
        @DisplayName("Should calculate defense score with all stat categories")
        void shouldCalculateDefenseScoreWithAllStatCategories() {
            // Given - SF 49ers: 4 sacks, 2 INTs, 1 fumble recovery, 1 defensive TD, 10 points allowed
            PositionScore.PositionStats stats = PositionScore.PositionStats.builder()
                .sacks(4)
                .defensiveInterceptions(2)
                .fumbleRecoveries(1)
                .defensiveTouchdowns(1)
                .pointsAllowed(10)
                .build();

            // When
            BigDecimal score = calculator.calculateDefenseScore(stats);

            // Then: 4*1 + 2*2 + 1*2 + 1*6 + 4 (7-13 points allowed) = 4 + 4 + 2 + 6 + 4 = 20
            assertThat(score).isEqualByComparingTo(new BigDecimal("20.00"));
        }

        @Test
        @DisplayName("Should give bonus for shutout")
        void shouldGiveBonusForShutout() {
            // Given - Defense with 0 points allowed
            PositionScore.PositionStats stats = PositionScore.PositionStats.builder()
                .sacks(2)
                .pointsAllowed(0)
                .build();

            // When
            BigDecimal score = calculator.calculateDefenseScore(stats);

            // Then: 2*1 + 10 (shutout) = 12
            assertThat(score).isEqualByComparingTo(new BigDecimal("12.00"));
        }

        @Test
        @DisplayName("Should penalize for high points allowed")
        void shouldPenalizeForHighPointsAllowed() {
            // Given - Defense that allowed 35 points
            PositionScore.PositionStats stats = PositionScore.PositionStats.builder()
                .sacks(1)
                .pointsAllowed(35)
                .build();

            // When
            BigDecimal score = calculator.calculateDefenseScore(stats);

            // Then: 1*1 + -4 (28+ points allowed) = 1 - 4 = -3
            assertThat(score).isEqualByComparingTo(new BigDecimal("-3.00"));
        }
    }

    @Nested
    @DisplayName("Position Score Calculation")
    class PositionScoreCalculationTests {

        @Test
        @DisplayName("Should return zero for null stats")
        void shouldReturnZeroForNullStats() {
            // When
            BigDecimal score = calculator.calculatePositionScore(Position.QB, null);

            // Then
            assertThat(score).isEqualByComparingTo(BigDecimal.ZERO);
        }

        @Test
        @DisplayName("Should use correct calculator for each position")
        void shouldUseCorrectCalculatorForEachPosition() {
            // Given - Stats that work for WR
            PositionScore.PositionStats stats = PositionScore.PositionStats.builder()
                .receptions(5)
                .receivingYards(50)
                .receivingTouchdowns(1)
                .build();

            // When calculating for WR
            BigDecimal wrScore = calculator.calculatePositionScore(Position.WR, stats);

            // Then: 5 * 1 + 50 * 0.1 + 1 * 6 = 5 + 5 + 6 = 16
            assertThat(wrScore).isEqualByComparingTo(new BigDecimal("16.00"));

            // When calculating for TE (same formula as WR)
            BigDecimal teScore = calculator.calculatePositionScore(Position.TE, stats);
            assertThat(teScore).isEqualByComparingTo(new BigDecimal("16.00"));
        }
    }
}
