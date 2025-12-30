package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.FieldGoalScoringBreakdownDTO;
import com.ffl.playoffs.domain.model.FieldGoalAttempt;
import com.ffl.playoffs.domain.model.FieldGoalDistanceRange;
import com.ffl.playoffs.domain.model.FieldGoalScoringRules;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for CalculateFieldGoalScoringUseCase
 */
class CalculateFieldGoalScoringUseCaseTest {

    private CalculateFieldGoalScoringUseCase useCase;

    @BeforeEach
    void setUp() {
        useCase = new CalculateFieldGoalScoringUseCase();
    }

    @Nested
    @DisplayName("Calculate Total Points")
    class CalculateTotalPoints {

        @Test
        @DisplayName("should calculate total points with default rules")
        void shouldCalculateTotalPointsWithDefaultRules() {
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.made(25),  // 3 pts
                    FieldGoalAttempt.made(35),  // 3 pts
                    FieldGoalAttempt.made(38)   // 3 pts
            );

            double total = useCase.calculateTotalPoints(attempts);

            assertEquals(9.0, total);
        }

        @Test
        @DisplayName("should calculate total points for 40-49 range")
        void shouldCalculateTotalPointsFor40to49Range() {
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.made(40),  // 4 pts
                    FieldGoalAttempt.made(45)   // 4 pts
            );

            double total = useCase.calculateTotalPoints(attempts);

            assertEquals(8.0, total);
        }

        @Test
        @DisplayName("should calculate total points for 50+ range")
        void shouldCalculateTotalPointsFor50PlusRange() {
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.made(52),  // 5 pts
                    FieldGoalAttempt.made(58)   // 5 pts
            );

            double total = useCase.calculateTotalPoints(attempts);

            assertEquals(10.0, total);
        }

        @Test
        @DisplayName("should calculate total points across multiple ranges")
        void shouldCalculateTotalPointsAcrossMultipleRanges() {
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.made(28),  // 3 pts (0-39)
                    FieldGoalAttempt.made(42),  // 4 pts (40-49)
                    FieldGoalAttempt.made(51)   // 5 pts (50+)
            );

            double total = useCase.calculateTotalPoints(attempts);

            assertEquals(12.0, total);
        }

        @Test
        @DisplayName("should exclude missed field goals")
        void shouldExcludeMissedFieldGoals() {
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.made(30),    // 3 pts
                    FieldGoalAttempt.missed(45),  // 0 pts
                    FieldGoalAttempt.made(52)     // 5 pts
            );

            double total = useCase.calculateTotalPoints(attempts);

            assertEquals(8.0, total);
        }

        @Test
        @DisplayName("should return 0 for all missed field goals")
        void shouldReturnZeroForAllMissed() {
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.missed(35),
                    FieldGoalAttempt.missed(42),
                    FieldGoalAttempt.blocked(50)
            );

            double total = useCase.calculateTotalPoints(attempts);

            assertEquals(0.0, total);
        }

        @Test
        @DisplayName("should return 0 for empty list")
        void shouldReturnZeroForEmptyList() {
            double total = useCase.calculateTotalPoints(Collections.emptyList());
            assertEquals(0.0, total);
        }

        @Test
        @DisplayName("should return 0 for null list")
        void shouldReturnZeroForNullList() {
            double total = useCase.calculateTotalPoints(null);
            assertEquals(0.0, total);
        }

        @Test
        @DisplayName("should calculate with custom rules")
        void shouldCalculateWithCustomRules() {
            FieldGoalScoringRules customRules = FieldGoalScoringRules.withSimplifiedTiers(2.0, 5.0, 7.0);
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.made(30),  // 2 pts
                    FieldGoalAttempt.made(43),  // 5 pts
                    FieldGoalAttempt.made(52)   // 7 pts
            );

            double total = useCase.calculateTotalPoints(attempts, customRules);

            assertEquals(14.0, total);
        }

        @Test
        @DisplayName("should calculate with long distance league rules")
        void shouldCalculateWithLongDistanceLeagueRules() {
            FieldGoalScoringRules customRules = FieldGoalScoringRules.withSimplifiedTiers(3.0, 6.0, 10.0);
            List<FieldGoalAttempt> attempts = Collections.singletonList(
                    FieldGoalAttempt.made(55)  // 10 pts
            );

            double total = useCase.calculateTotalPoints(attempts, customRules);

            assertEquals(10.0, total);
        }
    }

    @Nested
    @DisplayName("Calculate Breakdown")
    class CalculateBreakdown {

        @Test
        @DisplayName("should return breakdown with all field goal details")
        void shouldReturnBreakdownWithAllDetails() {
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.made(32),
                    FieldGoalAttempt.made(38),
                    FieldGoalAttempt.made(47),
                    FieldGoalAttempt.made(53)
            );

            FieldGoalScoringBreakdownDTO breakdown = useCase.calculateBreakdown(
                    "Tampa Bay Buccaneers", 2, attempts);

            assertEquals("Tampa Bay Buccaneers", breakdown.getTeamName());
            assertEquals(2, breakdown.getWeek());
            assertEquals(4, breakdown.getFieldGoals().size());
            assertEquals(15.0, breakdown.getTotalFieldGoalPoints());
            assertEquals(4, breakdown.getMadeFieldGoals());
            assertEquals(4, breakdown.getAttemptedFieldGoals());
        }

        @Test
        @DisplayName("should include range breakdown in response")
        void shouldIncludeRangeBreakdownInResponse() {
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.made(28),
                    FieldGoalAttempt.made(42),
                    FieldGoalAttempt.made(51)
            );

            FieldGoalScoringBreakdownDTO breakdown = useCase.calculateBreakdown(
                    "San Francisco 49ers", 1, attempts);

            assertEquals(3, breakdown.getRangeBreakdown().size());

            // Verify 0-39 range
            var range0_39 = breakdown.getRangeBreakdown().stream()
                    .filter(r -> r.getRange().equals("0-39 yards"))
                    .findFirst()
                    .orElseThrow();
            assertEquals(1, range0_39.getCount());
            assertEquals(3.0, range0_39.getPointsPerFieldGoal());
            assertEquals(3.0, range0_39.getTotal());

            // Verify 40-49 range
            var range40_49 = breakdown.getRangeBreakdown().stream()
                    .filter(r -> r.getRange().equals("40-49 yards"))
                    .findFirst()
                    .orElseThrow();
            assertEquals(1, range40_49.getCount());
            assertEquals(4.0, range40_49.getPointsPerFieldGoal());
            assertEquals(4.0, range40_49.getTotal());

            // Verify 50+ range
            var range50plus = breakdown.getRangeBreakdown().stream()
                    .filter(r -> r.getRange().equals("50+ yards"))
                    .findFirst()
                    .orElseThrow();
            assertEquals(1, range50plus.getCount());
            assertEquals(5.0, range50plus.getPointsPerFieldGoal());
            assertEquals(5.0, range50plus.getTotal());
        }

        @Test
        @DisplayName("should correctly track made vs attempted")
        void shouldCorrectlyTrackMadeVsAttempted() {
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.made(30),
                    FieldGoalAttempt.missed(45),
                    FieldGoalAttempt.made(52),
                    FieldGoalAttempt.blocked(28)
            );

            FieldGoalScoringBreakdownDTO breakdown = useCase.calculateBreakdown(
                    "Philadelphia Eagles", 1, attempts);

            assertEquals(2, breakdown.getMadeFieldGoals());
            assertEquals(4, breakdown.getAttemptedFieldGoals());
            assertEquals(8.0, breakdown.getTotalFieldGoalPoints()); // 30 (3) + 52 (5) = 8
        }

        @Test
        @DisplayName("should handle no field goals attempted")
        void shouldHandleNoFieldGoalsAttempted() {
            FieldGoalScoringBreakdownDTO breakdown = useCase.calculateBreakdown(
                    "New York Jets", 1, Collections.emptyList());

            assertEquals("New York Jets", breakdown.getTeamName());
            assertEquals(0, breakdown.getMadeFieldGoals());
            assertEquals(0, breakdown.getAttemptedFieldGoals());
            assertEquals(0.0, breakdown.getTotalFieldGoalPoints());
        }

        @Test
        @DisplayName("should calculate with custom rules")
        void shouldCalculateBreakdownWithCustomRules() {
            FieldGoalScoringRules customRules = FieldGoalScoringRules.withSimplifiedTiers(2.0, 5.0, 7.0);
            List<FieldGoalAttempt> attempts = Arrays.asList(
                    FieldGoalAttempt.made(30),  // 2 pts
                    FieldGoalAttempt.made(43),  // 5 pts
                    FieldGoalAttempt.made(52)   // 7 pts
            );

            FieldGoalScoringBreakdownDTO breakdown = useCase.calculateBreakdown(
                    "Green Bay Packers", 1, attempts, customRules);

            assertEquals(14.0, breakdown.getTotalFieldGoalPoints());
        }
    }

    @Nested
    @DisplayName("Distance Validation")
    class DistanceValidation {

        @Test
        @DisplayName("should return true for valid distances")
        void shouldReturnTrueForValidDistances() {
            assertTrue(useCase.isValidDistance(0));
            assertTrue(useCase.isValidDistance(25));
            assertTrue(useCase.isValidDistance(50));
            assertTrue(useCase.isValidDistance(75)); // Record-breaking kick
        }

        @Test
        @DisplayName("should return false for negative distances")
        void shouldReturnFalseForNegativeDistances() {
            assertFalse(useCase.isValidDistance(-5));
            assertFalse(useCase.isValidDistance(-1));
        }
    }

    @Nested
    @DisplayName("Get Distance Range")
    class GetDistanceRange {

        @Test
        @DisplayName("should return correct range for each distance")
        void shouldReturnCorrectRangeForEachDistance() {
            assertEquals(FieldGoalDistanceRange.RANGE_0_39, useCase.getDistanceRange(18));
            assertEquals(FieldGoalDistanceRange.RANGE_0_39, useCase.getDistanceRange(39));
            assertEquals(FieldGoalDistanceRange.RANGE_40_49, useCase.getDistanceRange(40));
            assertEquals(FieldGoalDistanceRange.RANGE_40_49, useCase.getDistanceRange(49));
            assertEquals(FieldGoalDistanceRange.RANGE_50_PLUS, useCase.getDistanceRange(50));
            assertEquals(FieldGoalDistanceRange.RANGE_50_PLUS, useCase.getDistanceRange(75));
        }

        @Test
        @DisplayName("should throw exception for negative distance")
        void shouldThrowExceptionForNegativeDistance() {
            assertThrows(IllegalArgumentException.class, () -> useCase.getDistanceRange(-5));
        }
    }
}
