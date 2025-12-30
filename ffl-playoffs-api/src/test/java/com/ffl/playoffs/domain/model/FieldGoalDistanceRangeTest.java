package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.ValueSource;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for FieldGoalDistanceRange enum
 */
class FieldGoalDistanceRangeTest {

    @Nested
    @DisplayName("fromDistance")
    class FromDistance {

        @ParameterizedTest
        @DisplayName("should return RANGE_0_39 for distances 0-39")
        @ValueSource(ints = {0, 18, 25, 30, 35, 39})
        void shouldReturnRange0to39ForShortDistances(int yards) {
            assertEquals(FieldGoalDistanceRange.RANGE_0_39, FieldGoalDistanceRange.fromDistance(yards));
        }

        @ParameterizedTest
        @DisplayName("should return RANGE_40_49 for distances 40-49")
        @ValueSource(ints = {40, 42, 45, 48, 49})
        void shouldReturnRange40to49ForMediumDistances(int yards) {
            assertEquals(FieldGoalDistanceRange.RANGE_40_49, FieldGoalDistanceRange.fromDistance(yards));
        }

        @ParameterizedTest
        @DisplayName("should return RANGE_50_PLUS for distances 50+")
        @ValueSource(ints = {50, 52, 55, 58, 60, 65, 75})
        void shouldReturnRange50PlusForLongDistances(int yards) {
            assertEquals(FieldGoalDistanceRange.RANGE_50_PLUS, FieldGoalDistanceRange.fromDistance(yards));
        }

        @Test
        @DisplayName("should throw exception for negative distance")
        void shouldThrowExceptionForNegativeDistance() {
            assertThrows(IllegalArgumentException.class, () ->
                    FieldGoalDistanceRange.fromDistance(-5));
        }
    }

    @Nested
    @DisplayName("contains")
    class Contains {

        @ParameterizedTest
        @DisplayName("RANGE_0_39 should contain distances 0-39")
        @ValueSource(ints = {0, 18, 25, 39})
        void range0to39ShouldContainShortDistances(int yards) {
            assertTrue(FieldGoalDistanceRange.RANGE_0_39.contains(yards));
        }

        @ParameterizedTest
        @DisplayName("RANGE_0_39 should not contain distances 40+")
        @ValueSource(ints = {40, 50, 60})
        void range0to39ShouldNotContainLongDistances(int yards) {
            assertFalse(FieldGoalDistanceRange.RANGE_0_39.contains(yards));
        }

        @ParameterizedTest
        @DisplayName("RANGE_40_49 should contain distances 40-49")
        @ValueSource(ints = {40, 45, 49})
        void range40to49ShouldContainMediumDistances(int yards) {
            assertTrue(FieldGoalDistanceRange.RANGE_40_49.contains(yards));
        }

        @ParameterizedTest
        @DisplayName("RANGE_50_PLUS should contain distances 50+")
        @ValueSource(ints = {50, 55, 60, 75})
        void range50PlusShouldContainLongDistances(int yards) {
            assertTrue(FieldGoalDistanceRange.RANGE_50_PLUS.contains(yards));
        }
    }

    @Nested
    @DisplayName("getDisplayName")
    class GetDisplayName {

        @ParameterizedTest
        @DisplayName("should return correct display names")
        @CsvSource({
                "RANGE_0_39, 0-39 yards",
                "RANGE_40_49, 40-49 yards",
                "RANGE_50_PLUS, 50+ yards"
        })
        void shouldReturnCorrectDisplayNames(FieldGoalDistanceRange range, String expectedName) {
            assertEquals(expectedName, range.getDisplayName());
        }
    }
}
