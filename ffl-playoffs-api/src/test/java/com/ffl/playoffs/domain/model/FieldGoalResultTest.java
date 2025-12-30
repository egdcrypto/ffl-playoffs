package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

/**
 * Unit tests for FieldGoalResult enum
 */
class FieldGoalResultTest {

    @Test
    @DisplayName("MADE result should be successful")
    void madeResultShouldBeSuccessful() {
        assertTrue(FieldGoalResult.MADE.isSuccessful());
    }

    @Test
    @DisplayName("MISSED result should not be successful")
    void missedResultShouldNotBeSuccessful() {
        assertFalse(FieldGoalResult.MISSED.isSuccessful());
    }

    @Test
    @DisplayName("BLOCKED result should not be successful")
    void blockedResultShouldNotBeSuccessful() {
        assertFalse(FieldGoalResult.BLOCKED.isSuccessful());
    }
}
