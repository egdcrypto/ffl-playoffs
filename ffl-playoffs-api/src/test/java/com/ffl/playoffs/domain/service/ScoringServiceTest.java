package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.model.ScoringRules;
import com.ffl.playoffs.domain.service.ScoringService.PlayerGameStats;
import com.ffl.playoffs.domain.service.ScoringService.TeamGameStats;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("ScoringService Domain Service Tests")
class ScoringServiceTest {

    private ScoringService scoringService;
    private ScoringRules rules;

    @BeforeEach
    void setUp() {
        scoringService = new ScoringService();
        rules = new ScoringRules(); // Uses default rules
    }

    @Nested
    @DisplayName("Team Score Calculation")
    class TeamScoreCalculation {

        @Test
        @DisplayName("should calculate score for team with no stats")
        void shouldCalculateScoreForTeamWithNoStats() {
            // Given
            TeamGameStats stats = new TeamGameStats();

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            assertThat(score).isNotNull();
            assertThat(score.getTotalPoints()).isEqualTo(0);
        }

        @Test
        @DisplayName("should calculate offensive points correctly")
        void shouldCalculateOffensivePointsCorrectly() {
            // Given
            TeamGameStats stats = new TeamGameStats();
            stats.setPassingYards(300); // 300/25 = 12 points
            stats.setPassingTouchdowns(2); // 2 * 4 = 8 points
            stats.setRushingYards(100); // 100/10 = 10 points
            stats.setRushingTouchdowns(1); // 1 * 6 = 6 points
            stats.setReceivingYards(50); // 50/10 = 5 points
            stats.setReceivingTouchdowns(1); // 1 * 6 = 6 points
            stats.setReceptions(5); // 5 * 1 = 5 points (PPR)

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            // Total: 12 + 8 + 10 + 6 + 5 + 6 + 5 = 52
            assertThat(score.getOffensivePoints()).isEqualTo(52);
        }

        @Test
        @DisplayName("should apply negative scoring for interceptions and fumbles")
        void shouldApplyNegativeScoringForInterceptionsAndFumbles() {
            // Given
            TeamGameStats stats = new TeamGameStats();
            stats.setInterceptionsThrown(2); // 2 * -2 = -4
            stats.setFumblesLost(1); // 1 * -2 = -2

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            assertThat(score.getOffensivePoints()).isEqualTo(-6);
        }

        @Test
        @DisplayName("should calculate defensive points correctly")
        void shouldCalculateDefensivePointsCorrectly() {
            // Given
            TeamGameStats stats = new TeamGameStats();
            stats.setSacks(3); // 3 * 1 = 3
            stats.setInterceptions(2); // 2 * 2 = 4
            stats.setFumbleRecoveries(1); // 1 * 2 = 2
            stats.setSafeties(1); // 1 * 2 = 2
            stats.setDefensiveTouchdowns(1); // 1 * 6 = 6

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            // Total: 3 + 4 + 2 + 2 + 6 = 17
            assertThat(score.getDefensivePoints()).isEqualTo(17);
        }

        @Test
        @DisplayName("should calculate field goal points correctly")
        void shouldCalculateFieldGoalPointsCorrectly() {
            // Given
            TeamGameStats stats = new TeamGameStats();
            stats.setFieldGoalsUnder40(2); // 2 * 3 = 6
            stats.setFieldGoals40To49(1); // 1 * 4 = 4
            stats.setFieldGoals50Plus(1); // 1 * 5 = 5
            stats.setExtraPoints(3); // 3 * 1 = 3

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            // Total: 6 + 4 + 5 + 3 = 18
            assertThat(score.getFieldGoalPoints()).isEqualTo(18);
        }
    }

    @Nested
    @DisplayName("Points Allowed Scoring")
    class PointsAllowedScoring {

        @Test
        @DisplayName("should give max points for shutout (0 points allowed)")
        void shouldGiveMaxPointsForShutout() {
            // Given
            TeamGameStats stats = new TeamGameStats();
            stats.setPointsAllowed(0);

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            assertThat(score.getDefensivePoints()).isEqualTo(10);
        }

        @Test
        @DisplayName("should give 7 points for 1-6 points allowed")
        void shouldGive7PointsFor1To6PointsAllowed() {
            // Given
            TeamGameStats stats = new TeamGameStats();
            stats.setPointsAllowed(3);

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            assertThat(score.getDefensivePoints()).isEqualTo(7);
        }

        @Test
        @DisplayName("should give 4 points for 7-13 points allowed")
        void shouldGive4PointsFor7To13PointsAllowed() {
            // Given
            TeamGameStats stats = new TeamGameStats();
            stats.setPointsAllowed(10);

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            assertThat(score.getDefensivePoints()).isEqualTo(4);
        }

        @Test
        @DisplayName("should give 1 point for 14-20 points allowed")
        void shouldGive1PointFor14To20PointsAllowed() {
            // Given
            TeamGameStats stats = new TeamGameStats();
            stats.setPointsAllowed(17);

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            assertThat(score.getDefensivePoints()).isEqualTo(1);
        }

        @Test
        @DisplayName("should give 0 points for 21-27 points allowed")
        void shouldGive0PointsFor21To27PointsAllowed() {
            // Given
            TeamGameStats stats = new TeamGameStats();
            stats.setPointsAllowed(24);

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            assertThat(score.getDefensivePoints()).isEqualTo(0);
        }

        @Test
        @DisplayName("should give negative points for 28+ points allowed")
        void shouldGiveNegativePointsFor28PlusPointsAllowed() {
            // Given
            TeamGameStats stats = new TeamGameStats();
            stats.setPointsAllowed(35);

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            assertThat(score.getDefensivePoints()).isEqualTo(-1);
        }
    }

    @Nested
    @DisplayName("Yards Allowed Scoring")
    class YardsAllowedScoring {

        @Test
        @DisplayName("should give 5 points for under 100 yards allowed")
        void shouldGive5PointsForUnder100YardsAllowed() {
            // Given
            TeamGameStats stats = new TeamGameStats();
            stats.setYardsAllowed(75);

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            assertThat(score.getDefensivePoints()).isEqualTo(5);
        }

        @Test
        @DisplayName("should give 3 points for 100-199 yards allowed")
        void shouldGive3PointsFor100To199YardsAllowed() {
            // Given
            TeamGameStats stats = new TeamGameStats();
            stats.setYardsAllowed(150);

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            assertThat(score.getDefensivePoints()).isEqualTo(3);
        }

        @Test
        @DisplayName("should give 2 points for 200-299 yards allowed")
        void shouldGive2PointsFor200To299YardsAllowed() {
            // Given
            TeamGameStats stats = new TeamGameStats();
            stats.setYardsAllowed(250);

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            assertThat(score.getDefensivePoints()).isEqualTo(2);
        }

        @Test
        @DisplayName("should give 0 points for 300-349 yards allowed")
        void shouldGive0PointsFor300To349YardsAllowed() {
            // Given
            TeamGameStats stats = new TeamGameStats();
            stats.setYardsAllowed(325);

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            assertThat(score.getDefensivePoints()).isEqualTo(0);
        }

        @Test
        @DisplayName("should give negative points for 550+ yards allowed")
        void shouldGiveNegativePointsFor550PlusYardsAllowed() {
            // Given
            TeamGameStats stats = new TeamGameStats();
            stats.setYardsAllowed(600);

            // When
            Score score = scoringService.calculateScore(rules, stats);

            // Then
            assertThat(score.getDefensivePoints()).isEqualTo(-7);
        }
    }

    @Nested
    @DisplayName("Player Score Calculation")
    class PlayerScoreCalculation {

        @Test
        @DisplayName("should calculate QB score correctly")
        void shouldCalculateQBScoreCorrectly() {
            // Given
            PlayerGameStats stats = new PlayerGameStats();
            stats.setPassingYards(300); // 300/25 = 12.0
            stats.setPassingTouchdowns(3); // 3 * 4 = 12.0
            stats.setInterceptionsThrown(1); // 1 * -2 = -2.0
            stats.setRushingYards(20); // 20/10 = 2.0
            stats.setRushingTouchdowns(1); // 1 * 6 = 6.0

            // When
            double score = scoringService.calculatePlayerScore(rules, stats);

            // Then
            // Total: 12 + 12 - 2 + 2 + 6 = 30.0
            assertThat(score).isEqualTo(30.0);
        }

        @Test
        @DisplayName("should calculate RB score correctly")
        void shouldCalculateRBScoreCorrectly() {
            // Given
            PlayerGameStats stats = new PlayerGameStats();
            stats.setRushingYards(100); // 100/10 = 10.0
            stats.setRushingTouchdowns(2); // 2 * 6 = 12.0
            stats.setReceivingYards(30); // 30/10 = 3.0
            stats.setReceptions(3); // 3 * 1 = 3.0 (PPR)
            stats.setReceivingTouchdowns(1); // 1 * 6 = 6.0

            // When
            double score = scoringService.calculatePlayerScore(rules, stats);

            // Then
            // Total: 10 + 12 + 3 + 3 + 6 = 34.0
            assertThat(score).isEqualTo(34.0);
        }

        @Test
        @DisplayName("should calculate WR score correctly")
        void shouldCalculateWRScoreCorrectly() {
            // Given
            PlayerGameStats stats = new PlayerGameStats();
            stats.setReceivingYards(120); // 120/10 = 12.0
            stats.setReceptions(8); // 8 * 1 = 8.0 (PPR)
            stats.setReceivingTouchdowns(2); // 2 * 6 = 12.0
            stats.setRushingYards(15); // 15/10 = 1.5
            stats.setTwoPointConversions(1); // 1 * 2 = 2.0

            // When
            double score = scoringService.calculatePlayerScore(rules, stats);

            // Then
            // Total: 12 + 8 + 12 + 1 + 2 = 35.0 (integer division in yards)
            assertThat(score).isEqualTo(35.0);
        }

        @Test
        @DisplayName("should calculate K score correctly")
        void shouldCalculateKScoreCorrectly() {
            // Given
            PlayerGameStats stats = new PlayerGameStats();
            stats.setFieldGoalsUnder40(2); // 2 * 3 = 6.0
            stats.setFieldGoals40To49(1); // 1 * 4 = 4.0
            stats.setFieldGoals50Plus(1); // 1 * 5 = 5.0
            stats.setExtraPoints(4); // 4 * 1 = 4.0

            // When
            double score = scoringService.calculatePlayerScore(rules, stats);

            // Then
            // Total: 6 + 4 + 5 + 4 = 19.0
            assertThat(score).isEqualTo(19.0);
        }

        @Test
        @DisplayName("should apply fumble penalty correctly")
        void shouldApplyFumblePenaltyCorrectly() {
            // Given
            PlayerGameStats stats = new PlayerGameStats();
            stats.setRushingYards(100); // 100/10 = 10.0
            stats.setFumblesLost(2); // 2 * -2 = -4.0

            // When
            double score = scoringService.calculatePlayerScore(rules, stats);

            // Then
            // Total: 10 - 4 = 6.0
            assertThat(score).isEqualTo(6.0);
        }

        @Test
        @DisplayName("should return 0 for player with no stats")
        void shouldReturn0ForPlayerWithNoStats() {
            // Given
            PlayerGameStats stats = new PlayerGameStats();

            // When
            double score = scoringService.calculatePlayerScore(rules, stats);

            // Then
            assertThat(score).isEqualTo(0.0);
        }
    }

    @Nested
    @DisplayName("Custom Scoring Rules")
    class CustomScoringRules {

        @Test
        @DisplayName("should use custom passing touchdown points")
        void shouldUseCustomPassingTouchdownPoints() {
            // Given
            ScoringRules customRules = new ScoringRules();
            customRules.setPassingTouchdownPoints(6.0); // Increase from default 4.0

            PlayerGameStats stats = new PlayerGameStats();
            stats.setPassingTouchdowns(2);

            // When
            double score = scoringService.calculatePlayerScore(customRules, stats);

            // Then
            assertThat(score).isEqualTo(12.0); // 2 * 6
        }

        @Test
        @DisplayName("should use custom PPR value (Half-PPR)")
        void shouldUseCustomPPRValue() {
            // Given
            ScoringRules customRules = new ScoringRules();
            customRules.setReceptionPoints(0.5); // Half-PPR instead of full

            PlayerGameStats stats = new PlayerGameStats();
            stats.setReceptions(10);

            // When
            double score = scoringService.calculatePlayerScore(customRules, stats);

            // Then
            assertThat(score).isEqualTo(5.0); // 10 * 0.5
        }

        @Test
        @DisplayName("should use custom yards per point ratios")
        void shouldUseCustomYardsPerPointRatios() {
            // Given
            ScoringRules customRules = new ScoringRules();
            customRules.setPassingYardsPerPoint(20.0); // More points for passing

            PlayerGameStats stats = new PlayerGameStats();
            stats.setPassingYards(200);

            // When
            double score = scoringService.calculatePlayerScore(customRules, stats);

            // Then
            assertThat(score).isEqualTo(10.0); // 200/20
        }
    }

    @Nested
    @DisplayName("Edge Cases")
    class EdgeCases {

        @Test
        @DisplayName("should handle integer division for yards correctly")
        void shouldHandleIntegerDivisionForYardsCorrectly() {
            // Given
            PlayerGameStats stats = new PlayerGameStats();
            stats.setPassingYards(24); // 24/25 = 0 (integer division)

            // When
            double score = scoringService.calculatePlayerScore(rules, stats);

            // Then
            assertThat(score).isEqualTo(0.0);
        }

        @Test
        @DisplayName("should handle fractional points correctly")
        void shouldHandleFractionalPointsCorrectly() {
            // Given
            ScoringRules customRules = new ScoringRules();
            customRules.setReceptionPoints(0.5); // Half-PPR

            PlayerGameStats stats = new PlayerGameStats();
            stats.setReceptions(7); // 7 * 0.5 = 3.5

            // When
            double score = scoringService.calculatePlayerScore(customRules, stats);

            // Then
            assertThat(score).isEqualTo(3.5);
        }

        @Test
        @DisplayName("should handle maximum realistic stats")
        void shouldHandleMaximumRealisticStats() {
            // Given
            PlayerGameStats stats = new PlayerGameStats();
            stats.setPassingYards(500);
            stats.setPassingTouchdowns(7);
            stats.setRushingYards(200);
            stats.setRushingTouchdowns(3);
            stats.setReceivingYards(300);
            stats.setReceivingTouchdowns(4);
            stats.setReceptions(20);

            // When
            double score = scoringService.calculatePlayerScore(rules, stats);

            // Then
            assertThat(score).isGreaterThan(0);
            // 500/25 + 7*4 + 200/10 + 3*6 + 300/10 + 4*6 + 20*1
            // = 20 + 28 + 20 + 18 + 30 + 24 + 20 = 160
            assertThat(score).isEqualTo(160.0);
        }
    }
}
