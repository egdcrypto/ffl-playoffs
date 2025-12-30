package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for FieldGoalScoringRules value object
 */
class FieldGoalScoringRulesTest {

    @Nested
    @DisplayName("Default Rules")
    class DefaultRules {

        @Test
        @DisplayName("should create default rules with expected values")
        void shouldCreateDefaultRulesWithExpectedValues() {
            FieldGoalScoringRules rules = FieldGoalScoringRules.defaultRules();

            assertEquals(3.0, rules.getFg0to19Points());
            assertEquals(3.0, rules.getFg20to29Points());
            assertEquals(3.0, rules.getFg30to39Points());
            assertEquals(4.0, rules.getFg40to49Points());
            assertEquals(5.0, rules.getFg50PlusPoints());
            assertEquals(1.0, rules.getExtraPointPoints());
            assertEquals(0.0, rules.getMissedExtraPointPenalty());
        }
    }

    @Nested
    @DisplayName("Simplified Tiers")
    class SimplifiedTiers {

        @Test
        @DisplayName("should create rules with 3-tier format")
        void shouldCreateRulesWith3TierFormat() {
            FieldGoalScoringRules rules = FieldGoalScoringRules.withSimplifiedTiers(2.0, 5.0, 7.0);

            assertEquals(2.0, rules.getFg0to19Points());
            assertEquals(2.0, rules.getFg20to29Points());
            assertEquals(2.0, rules.getFg30to39Points());
            assertEquals(5.0, rules.getFg40to49Points());
            assertEquals(7.0, rules.getFg50PlusPoints());
        }

        @Test
        @DisplayName("should create rules with 3-tier format and extra point config")
        void shouldCreateRulesWith3TierAndExtraPoint() {
            FieldGoalScoringRules rules = FieldGoalScoringRules.withSimplifiedTiers(3.0, 6.0, 10.0, 2.0, 1.0);

            assertEquals(3.0, rules.getFg0to19Points());
            assertEquals(6.0, rules.getFg40to49Points());
            assertEquals(10.0, rules.getFg50PlusPoints());
            assertEquals(2.0, rules.getExtraPointPoints());
            assertEquals(1.0, rules.getMissedExtraPointPenalty());
        }
    }

    @Nested
    @DisplayName("Calculate Field Goal Points")
    class CalculateFieldGoalPoints {

        @ParameterizedTest
        @DisplayName("should calculate correct points for each distance tier")
        @CsvSource({
                "18, 3.0",
                "25, 3.0",
                "39, 3.0",
                "40, 4.0",
                "45, 4.0",
                "49, 4.0",
                "50, 5.0",
                "55, 5.0",
                "65, 5.0"
        })
        void shouldCalculateCorrectPointsForEachTier(int yards, double expectedPoints) {
            FieldGoalScoringRules rules = FieldGoalScoringRules.defaultRules();
            assertEquals(expectedPoints, rules.calculateFieldGoalPoints(yards));
        }

        @Test
        @DisplayName("should calculate points with custom rules")
        void shouldCalculatePointsWithCustomRules() {
            FieldGoalScoringRules rules = FieldGoalScoringRules.withSimplifiedTiers(2.0, 5.0, 7.0);

            assertEquals(2.0, rules.calculateFieldGoalPoints(30));
            assertEquals(5.0, rules.calculateFieldGoalPoints(45));
            assertEquals(7.0, rules.calculateFieldGoalPoints(55));
        }
    }

    @Nested
    @DisplayName("Get Points For Range")
    class GetPointsForRange {

        @Test
        @DisplayName("should return correct points for each range")
        void shouldReturnCorrectPointsForEachRange() {
            FieldGoalScoringRules rules = FieldGoalScoringRules.defaultRules();

            assertEquals(3.0, rules.getPointsForRange(FieldGoalDistanceRange.RANGE_0_39));
            assertEquals(4.0, rules.getPointsForRange(FieldGoalDistanceRange.RANGE_40_49));
            assertEquals(5.0, rules.getPointsForRange(FieldGoalDistanceRange.RANGE_50_PLUS));
        }
    }

    @Nested
    @DisplayName("Calculate Total Points")
    class CalculateTotalPoints {

        @Test
        @DisplayName("should calculate total points for multiple made field goals")
        void shouldCalculateTotalPointsForMultipleMade() {
            FieldGoalScoringRules rules = FieldGoalScoringRules.defaultRules();
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.made(25),  // 3 pts
                    FieldGoalAttempt.made(45),  // 4 pts
                    FieldGoalAttempt.made(55)   // 5 pts
            );

            assertEquals(12.0, rules.calculateTotalPoints(attempts));
        }

        @Test
        @DisplayName("should only count made field goals")
        void shouldOnlyCountMadeFieldGoals() {
            FieldGoalScoringRules rules = FieldGoalScoringRules.defaultRules();
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.made(30),    // 3 pts
                    FieldGoalAttempt.missed(45),  // 0 pts
                    FieldGoalAttempt.made(52)     // 5 pts
            );

            assertEquals(8.0, rules.calculateTotalPoints(attempts));
        }

        @Test
        @DisplayName("should return 0 for all missed field goals")
        void shouldReturnZeroForAllMissed() {
            FieldGoalScoringRules rules = FieldGoalScoringRules.defaultRules();
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.missed(35),
                    FieldGoalAttempt.missed(42),
                    FieldGoalAttempt.blocked(50)
            );

            assertEquals(0.0, rules.calculateTotalPoints(attempts));
        }

        @Test
        @DisplayName("should return 0 for empty list")
        void shouldReturnZeroForEmptyList() {
            FieldGoalScoringRules rules = FieldGoalScoringRules.defaultRules();
            assertEquals(0.0, rules.calculateTotalPoints(Collections.emptyList()));
        }

        @Test
        @DisplayName("should return 0 for null list")
        void shouldReturnZeroForNullList() {
            FieldGoalScoringRules rules = FieldGoalScoringRules.defaultRules();
            assertEquals(0.0, rules.calculateTotalPoints(null));
        }

        @Test
        @DisplayName("should calculate correctly with custom rules - feature scenario")
        void shouldCalculateCorrectlyWithCustomRules() {
            // From feature file: League rewards long field goals more heavily
            FieldGoalScoringRules rules = FieldGoalScoringRules.withSimplifiedTiers(3.0, 6.0, 10.0);
            List<FieldGoalAttempt> attempts = Collections.singletonList(
                    FieldGoalAttempt.made(55)  // 10 pts with custom rules
            );

            assertEquals(10.0, rules.calculateTotalPoints(attempts));
        }
    }

    @Nested
    @DisplayName("Calculate Breakdown")
    class CalculateBreakdown {

        @Test
        @DisplayName("should calculate breakdown for mixed distance field goals")
        void shouldCalculateBreakdownForMixedDistances() {
            FieldGoalScoringRules rules = FieldGoalScoringRules.defaultRules();
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.made(28),  // 0-39
                    FieldGoalAttempt.made(42),  // 40-49
                    FieldGoalAttempt.made(51)   // 50+
            );

            Map<FieldGoalDistanceRange, FieldGoalScoringRules.FieldGoalRangeBreakdown> breakdown =
                    rules.calculateBreakdown(attempts);

            FieldGoalScoringRules.FieldGoalRangeBreakdown range0_39 = breakdown.get(FieldGoalDistanceRange.RANGE_0_39);
            assertEquals(1, range0_39.getCount());
            assertEquals(3.0, range0_39.getPointsPerFg());
            assertEquals(3.0, range0_39.getTotal());

            FieldGoalScoringRules.FieldGoalRangeBreakdown range40_49 = breakdown.get(FieldGoalDistanceRange.RANGE_40_49);
            assertEquals(1, range40_49.getCount());
            assertEquals(4.0, range40_49.getPointsPerFg());
            assertEquals(4.0, range40_49.getTotal());

            FieldGoalScoringRules.FieldGoalRangeBreakdown range50plus = breakdown.get(FieldGoalDistanceRange.RANGE_50_PLUS);
            assertEquals(1, range50plus.getCount());
            assertEquals(5.0, range50plus.getPointsPerFg());
            assertEquals(5.0, range50plus.getTotal());
        }

        @Test
        @DisplayName("should calculate breakdown for multiple in same range")
        void shouldCalculateBreakdownForMultipleSameRange() {
            FieldGoalScoringRules rules = FieldGoalScoringRules.defaultRules();
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.made(22),
                    FieldGoalAttempt.made(30),
                    FieldGoalAttempt.made(35),
                    FieldGoalAttempt.made(39)
            );

            Map<FieldGoalDistanceRange, FieldGoalScoringRules.FieldGoalRangeBreakdown> breakdown =
                    rules.calculateBreakdown(attempts);

            FieldGoalScoringRules.FieldGoalRangeBreakdown range0_39 = breakdown.get(FieldGoalDistanceRange.RANGE_0_39);
            assertEquals(4, range0_39.getCount());
            assertEquals(3.0, range0_39.getPointsPerFg());
            assertEquals(12.0, range0_39.getTotal());
        }

        @Test
        @DisplayName("should exclude missed field goals from breakdown")
        void shouldExcludeMissedFromBreakdown() {
            FieldGoalScoringRules rules = FieldGoalScoringRules.defaultRules();
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.made(30),     // counts
                    FieldGoalAttempt.missed(45),   // doesn't count
                    FieldGoalAttempt.made(52)      // counts
            );

            Map<FieldGoalDistanceRange, FieldGoalScoringRules.FieldGoalRangeBreakdown> breakdown =
                    rules.calculateBreakdown(attempts);

            assertEquals(1, breakdown.get(FieldGoalDistanceRange.RANGE_0_39).getCount());
            assertEquals(0, breakdown.get(FieldGoalDistanceRange.RANGE_40_49).getCount());
            assertEquals(1, breakdown.get(FieldGoalDistanceRange.RANGE_50_PLUS).getCount());
        }
    }

    @Nested
    @DisplayName("Calculate Extra Point Points")
    class CalculateExtraPointPoints {

        @Test
        @DisplayName("should calculate points for made extra points")
        void shouldCalculatePointsForMadeExtraPoints() {
            FieldGoalScoringRules rules = FieldGoalScoringRules.defaultRules();
            assertEquals(3.0, rules.calculateExtraPointPoints(3, 0));
        }

        @Test
        @DisplayName("should subtract penalty for missed extra points")
        void shouldSubtractPenaltyForMissed() {
            FieldGoalScoringRules rules = FieldGoalScoringRules.withSimplifiedTiers(3.0, 4.0, 5.0, 1.0, 1.0);
            assertEquals(1.0, rules.calculateExtraPointPoints(2, 1)); // 2 made - 1 missed
        }
    }
}
