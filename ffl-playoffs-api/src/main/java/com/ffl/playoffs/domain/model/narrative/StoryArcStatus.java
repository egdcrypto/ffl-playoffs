package com.ffl.playoffs.domain.model.narrative;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Status of a story arc in the narrative system.
 */
@Getter
@RequiredArgsConstructor
public enum StoryArcStatus {

    ACTIVE("active", "Active", "Story arc is currently active"),
    PAUSED("paused", "Paused", "Story arc is temporarily paused"),
    COMPLETED("completed", "Completed", "Story arc has concluded naturally"),
    ARCHIVED("archived", "Archived", "Story arc has been archived");

    private final String code;
    private final String displayName;
    private final String description;

    /**
     * Check if the arc is still ongoing
     */
    public boolean isOngoing() {
        return this == ACTIVE || this == PAUSED;
    }

    /**
     * Check if the arc can accept new beats
     */
    public boolean canAddBeats() {
        return this == ACTIVE;
    }

    /**
     * Check if the arc can be resumed
     */
    public boolean canResume() {
        return this == PAUSED;
    }

    /**
     * Check if the arc can be archived
     */
    public boolean canArchive() {
        return this == COMPLETED;
    }

    /**
     * Resolve from code string
     */
    public static StoryArcStatus fromCode(String code) {
        for (StoryArcStatus status : values()) {
            if (status.code.equalsIgnoreCase(code)) {
                return status;
            }
        }
        throw new IllegalArgumentException("Unknown story arc status code: " + code);
    }
}
