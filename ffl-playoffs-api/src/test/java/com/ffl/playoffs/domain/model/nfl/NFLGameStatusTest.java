package com.ffl.playoffs.domain.model.nfl;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.Arguments;
import org.junit.jupiter.params.provider.MethodSource;
import org.junit.jupiter.params.provider.ValueSource;

import java.util.stream.Stream;

import static org.junit.jupiter.api.Assertions.*;

@DisplayName("NFLGameStatus Enum Tests")
class NFLGameStatusTest {

    @Test
    @DisplayName("Should have all expected status values")
    void shouldHaveAllExpectedStatusValues() {
        NFLGameStatus[] statuses = NFLGameStatus.values();
        assertEquals(6, statuses.length);
        assertNotNull(NFLGameStatus.SCHEDULED);
        assertNotNull(NFLGameStatus.IN_PROGRESS);
        assertNotNull(NFLGameStatus.HALFTIME);
        assertNotNull(NFLGameStatus.FINAL);
        assertNotNull(NFLGameStatus.POSTPONED);
        assertNotNull(NFLGameStatus.CANCELLED);
    }

    @Test
    @DisplayName("SCHEDULED should have correct display name")
    void scheduledShouldHaveCorrectDisplayName() {
        assertEquals("Scheduled", NFLGameStatus.SCHEDULED.getDisplayName());
    }

    @Test
    @DisplayName("IN_PROGRESS should have correct display name")
    void inProgressShouldHaveCorrectDisplayName() {
        assertEquals("In Progress", NFLGameStatus.IN_PROGRESS.getDisplayName());
    }

    @Test
    @DisplayName("HALFTIME should have correct display name")
    void halftimeShouldHaveCorrectDisplayName() {
        assertEquals("Halftime", NFLGameStatus.HALFTIME.getDisplayName());
    }

    @Test
    @DisplayName("FINAL should have correct display name")
    void finalShouldHaveCorrectDisplayName() {
        assertEquals("Final", NFLGameStatus.FINAL.getDisplayName());
    }

    @ParameterizedTest
    @DisplayName("isActive should return true only for IN_PROGRESS and HALFTIME")
    @MethodSource("isActiveTestCases")
    void isActiveShouldReturnCorrectValue(NFLGameStatus status, boolean expectedIsActive) {
        assertEquals(expectedIsActive, status.isActive());
    }

    private static Stream<Arguments> isActiveTestCases() {
        return Stream.of(
                Arguments.of(NFLGameStatus.SCHEDULED, false),
                Arguments.of(NFLGameStatus.IN_PROGRESS, true),
                Arguments.of(NFLGameStatus.HALFTIME, true),
                Arguments.of(NFLGameStatus.FINAL, false),
                Arguments.of(NFLGameStatus.POSTPONED, false),
                Arguments.of(NFLGameStatus.CANCELLED, false)
        );
    }

    @ParameterizedTest
    @DisplayName("isCompleted should return true only for FINAL")
    @MethodSource("isCompletedTestCases")
    void isCompletedShouldReturnCorrectValue(NFLGameStatus status, boolean expectedIsCompleted) {
        assertEquals(expectedIsCompleted, status.isCompleted());
    }

    private static Stream<Arguments> isCompletedTestCases() {
        return Stream.of(
                Arguments.of(NFLGameStatus.SCHEDULED, false),
                Arguments.of(NFLGameStatus.IN_PROGRESS, false),
                Arguments.of(NFLGameStatus.HALFTIME, false),
                Arguments.of(NFLGameStatus.FINAL, true),
                Arguments.of(NFLGameStatus.POSTPONED, false),
                Arguments.of(NFLGameStatus.CANCELLED, false)
        );
    }

    @ParameterizedTest
    @DisplayName("isScheduled should return true only for SCHEDULED")
    @MethodSource("isScheduledTestCases")
    void isScheduledShouldReturnCorrectValue(NFLGameStatus status, boolean expectedIsScheduled) {
        assertEquals(expectedIsScheduled, status.isScheduled());
    }

    private static Stream<Arguments> isScheduledTestCases() {
        return Stream.of(
                Arguments.of(NFLGameStatus.SCHEDULED, true),
                Arguments.of(NFLGameStatus.IN_PROGRESS, false),
                Arguments.of(NFLGameStatus.HALFTIME, false),
                Arguments.of(NFLGameStatus.FINAL, false),
                Arguments.of(NFLGameStatus.POSTPONED, false),
                Arguments.of(NFLGameStatus.CANCELLED, false)
        );
    }

    @ParameterizedTest
    @DisplayName("isCancelledOrPostponed should return true for CANCELLED and POSTPONED")
    @MethodSource("isCancelledOrPostponedTestCases")
    void isCancelledOrPostponedShouldReturnCorrectValue(NFLGameStatus status, boolean expected) {
        assertEquals(expected, status.isCancelledOrPostponed());
    }

    private static Stream<Arguments> isCancelledOrPostponedTestCases() {
        return Stream.of(
                Arguments.of(NFLGameStatus.SCHEDULED, false),
                Arguments.of(NFLGameStatus.IN_PROGRESS, false),
                Arguments.of(NFLGameStatus.HALFTIME, false),
                Arguments.of(NFLGameStatus.FINAL, false),
                Arguments.of(NFLGameStatus.POSTPONED, true),
                Arguments.of(NFLGameStatus.CANCELLED, true)
        );
    }

    @ParameterizedTest
    @DisplayName("fromString should convert valid strings correctly")
    @ValueSource(strings = {"SCHEDULED", "scheduled", "Scheduled", "SCHEDULED"})
    void fromStringShouldConvertValidStrings(String input) {
        assertEquals(NFLGameStatus.SCHEDULED, NFLGameStatus.fromString(input));
    }

    @Test
    @DisplayName("fromString should convert IN_PROGRESS with spaces")
    void fromStringShouldConvertInProgressWithSpaces() {
        assertEquals(NFLGameStatus.IN_PROGRESS, NFLGameStatus.fromString("IN PROGRESS"));
        assertEquals(NFLGameStatus.IN_PROGRESS, NFLGameStatus.fromString("in progress"));
    }

    @Test
    @DisplayName("fromString should return SCHEDULED for null")
    void fromStringShouldReturnScheduledForNull() {
        assertEquals(NFLGameStatus.SCHEDULED, NFLGameStatus.fromString(null));
    }

    @Test
    @DisplayName("fromString should return SCHEDULED for invalid string")
    void fromStringShouldReturnScheduledForInvalidString() {
        assertEquals(NFLGameStatus.SCHEDULED, NFLGameStatus.fromString("INVALID"));
        assertEquals(NFLGameStatus.SCHEDULED, NFLGameStatus.fromString(""));
        assertEquals(NFLGameStatus.SCHEDULED, NFLGameStatus.fromString("unknown"));
    }
}
