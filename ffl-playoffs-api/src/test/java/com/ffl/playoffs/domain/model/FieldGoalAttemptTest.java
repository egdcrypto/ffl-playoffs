package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for FieldGoalAttempt value object
 */
class FieldGoalAttemptTest {

    @Nested
    @DisplayName("Constructor")
    class Constructor {

        @Test
        @DisplayName("should create attempt with distance and result")
        void shouldCreateAttemptWithDistanceAndResult() {
            FieldGoalAttempt attempt = new FieldGoalAttempt(45, FieldGoalResult.MADE);

            assertEquals(45, attempt.getDistanceYards());
            assertEquals(FieldGoalResult.MADE, attempt.getResult());
            assertNull(attempt.getKicker());
            assertNull(attempt.getQuarter());
        }

        @Test
        @DisplayName("should create attempt with all fields")
        void shouldCreateAttemptWithAllFields() {
            FieldGoalAttempt attempt = new FieldGoalAttempt(52, FieldGoalResult.MADE, "Justin Tucker", 4);

            assertEquals(52, attempt.getDistanceYards());
            assertEquals(FieldGoalResult.MADE, attempt.getResult());
            assertEquals("Justin Tucker", attempt.getKicker());
            assertEquals(4, attempt.getQuarter());
        }

        @Test
        @DisplayName("should throw exception for negative distance")
        void shouldThrowExceptionForNegativeDistance() {
            assertThrows(IllegalArgumentException.class, () ->
                    new FieldGoalAttempt(-5, FieldGoalResult.MADE));
        }

        @Test
        @DisplayName("should throw exception for null result")
        void shouldThrowExceptionForNullResult() {
            assertThrows(NullPointerException.class, () ->
                    new FieldGoalAttempt(45, null));
        }
    }

    @Nested
    @DisplayName("Factory Methods")
    class FactoryMethods {

        @Test
        @DisplayName("made() should create attempt with MADE result")
        void madeShouldCreateMadeAttempt() {
            FieldGoalAttempt attempt = FieldGoalAttempt.made(35);

            assertEquals(35, attempt.getDistanceYards());
            assertEquals(FieldGoalResult.MADE, attempt.getResult());
            assertTrue(attempt.isMade());
        }

        @Test
        @DisplayName("missed() should create attempt with MISSED result")
        void missedShouldCreateMissedAttempt() {
            FieldGoalAttempt attempt = FieldGoalAttempt.missed(42);

            assertEquals(42, attempt.getDistanceYards());
            assertEquals(FieldGoalResult.MISSED, attempt.getResult());
            assertFalse(attempt.isMade());
        }

        @Test
        @DisplayName("blocked() should create attempt with BLOCKED result")
        void blockedShouldCreateBlockedAttempt() {
            FieldGoalAttempt attempt = FieldGoalAttempt.blocked(28);

            assertEquals(28, attempt.getDistanceYards());
            assertEquals(FieldGoalResult.BLOCKED, attempt.getResult());
            assertFalse(attempt.isMade());
        }
    }

    @Nested
    @DisplayName("getDistanceRange")
    class GetDistanceRange {

        @Test
        @DisplayName("should return correct range for short field goal")
        void shouldReturnCorrectRangeForShortFieldGoal() {
            FieldGoalAttempt attempt = FieldGoalAttempt.made(25);
            assertEquals(FieldGoalDistanceRange.RANGE_0_39, attempt.getDistanceRange());
        }

        @Test
        @DisplayName("should return correct range for medium field goal")
        void shouldReturnCorrectRangeForMediumFieldGoal() {
            FieldGoalAttempt attempt = FieldGoalAttempt.made(45);
            assertEquals(FieldGoalDistanceRange.RANGE_40_49, attempt.getDistanceRange());
        }

        @Test
        @DisplayName("should return correct range for long field goal")
        void shouldReturnCorrectRangeForLongFieldGoal() {
            FieldGoalAttempt attempt = FieldGoalAttempt.made(55);
            assertEquals(FieldGoalDistanceRange.RANGE_50_PLUS, attempt.getDistanceRange());
        }
    }

    @Nested
    @DisplayName("isMade")
    class IsMade {

        @Test
        @DisplayName("should return true for MADE result")
        void shouldReturnTrueForMadeResult() {
            FieldGoalAttempt attempt = new FieldGoalAttempt(45, FieldGoalResult.MADE);
            assertTrue(attempt.isMade());
        }

        @Test
        @DisplayName("should return false for MISSED result")
        void shouldReturnFalseForMissedResult() {
            FieldGoalAttempt attempt = new FieldGoalAttempt(45, FieldGoalResult.MISSED);
            assertFalse(attempt.isMade());
        }

        @Test
        @DisplayName("should return false for BLOCKED result")
        void shouldReturnFalseForBlockedResult() {
            FieldGoalAttempt attempt = new FieldGoalAttempt(45, FieldGoalResult.BLOCKED);
            assertFalse(attempt.isMade());
        }
    }

    @Nested
    @DisplayName("Equality")
    class Equality {

        @Test
        @DisplayName("should be equal for same values")
        void shouldBeEqualForSameValues() {
            FieldGoalAttempt attempt1 = new FieldGoalAttempt(45, FieldGoalResult.MADE, "Tucker", 3);
            FieldGoalAttempt attempt2 = new FieldGoalAttempt(45, FieldGoalResult.MADE, "Tucker", 3);

            assertEquals(attempt1, attempt2);
            assertEquals(attempt1.hashCode(), attempt2.hashCode());
        }

        @Test
        @DisplayName("should not be equal for different distances")
        void shouldNotBeEqualForDifferentDistances() {
            FieldGoalAttempt attempt1 = new FieldGoalAttempt(45, FieldGoalResult.MADE);
            FieldGoalAttempt attempt2 = new FieldGoalAttempt(50, FieldGoalResult.MADE);

            assertNotEquals(attempt1, attempt2);
        }

        @Test
        @DisplayName("should not be equal for different results")
        void shouldNotBeEqualForDifferentResults() {
            FieldGoalAttempt attempt1 = new FieldGoalAttempt(45, FieldGoalResult.MADE);
            FieldGoalAttempt attempt2 = new FieldGoalAttempt(45, FieldGoalResult.MISSED);

            assertNotEquals(attempt1, attempt2);
        }
    }
}
