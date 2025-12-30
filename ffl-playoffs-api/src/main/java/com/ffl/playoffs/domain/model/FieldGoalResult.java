package com.ffl.playoffs.domain.model;

/**
 * Enum representing the result of a field goal attempt
 */
public enum FieldGoalResult {
    MADE,
    MISSED,
    BLOCKED;

    /**
     * Checks if the field goal was successful
     * @return true if the field goal was made
     */
    public boolean isSuccessful() {
        return this == MADE;
    }
}
