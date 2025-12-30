package com.ffl.playoffs.domain.model.narrative;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Types of stall conditions that the AI Director can detect.
 * Stalls indicate periods of low engagement that may need intervention.
 */
@Getter
@RequiredArgsConstructor
public enum StallConditionType {

    INACTIVE_PLAYERS("inactive_players", "Inactive Players",
            "Players not making roster changes or selections",
            SeverityLevel.MEDIUM, 24),

    SCORE_PLATEAU("score_plateau", "Score Plateau",
            "Scores remaining static with no significant changes",
            SeverityLevel.LOW, 48),

    NO_ELIMINATIONS("no_eliminations", "No Eliminations",
            "Extended period without eliminations in elimination phase",
            SeverityLevel.HIGH, 168),

    LOW_COMPETITION("low_competition", "Low Competition",
            "Score gaps too wide, reducing competitive tension",
            SeverityLevel.MEDIUM, 72),

    ABANDONED_ROSTERS("abandoned_rosters", "Abandoned Rosters",
            "Players with incomplete or stale rosters",
            SeverityLevel.HIGH, 48),

    PREDICTABLE_OUTCOME("predictable_outcome", "Predictable Outcome",
            "Leader's advantage too large to overcome",
            SeverityLevel.LOW, 168),

    ENGAGEMENT_DROP("engagement_drop", "Engagement Drop",
            "Sudden decrease in player activity",
            SeverityLevel.MEDIUM, 24),

    NARRATIVE_GAP("narrative_gap", "Narrative Gap",
            "No story beats generated for extended period",
            SeverityLevel.MEDIUM, 72);

    private final String code;
    private final String displayName;
    private final String description;
    private final SeverityLevel severity;
    private final int defaultThresholdHours;

    /**
     * Severity levels for stall conditions
     */
    public enum SeverityLevel {
        LOW, MEDIUM, HIGH, CRITICAL
    }

    /**
     * Check if this stall type requires immediate curator attention
     */
    public boolean requiresImmediateAttention() {
        return severity == SeverityLevel.HIGH || severity == SeverityLevel.CRITICAL;
    }

    /**
     * Check if this stall type affects player engagement
     */
    public boolean affectsEngagement() {
        return this == INACTIVE_PLAYERS || this == ABANDONED_ROSTERS || this == ENGAGEMENT_DROP;
    }

    /**
     * Check if this stall type affects competitive balance
     */
    public boolean affectsCompetitiveBalance() {
        return this == LOW_COMPETITION || this == PREDICTABLE_OUTCOME || this == NO_ELIMINATIONS;
    }

    /**
     * Check if this stall type affects narrative flow
     */
    public boolean affectsNarrativeFlow() {
        return this == SCORE_PLATEAU || this == NARRATIVE_GAP;
    }

    /**
     * Get recommended curator action for this stall type
     */
    public CuratorActionType getRecommendedAction() {
        return switch (this) {
            case INACTIVE_PLAYERS, ABANDONED_ROSTERS -> CuratorActionType.SEND_REMINDER;
            case SCORE_PLATEAU, NARRATIVE_GAP -> CuratorActionType.GENERATE_STORY_BEAT;
            case NO_ELIMINATIONS -> CuratorActionType.TRIGGER_ELIMINATION_CHECK;
            case LOW_COMPETITION, PREDICTABLE_OUTCOME -> CuratorActionType.HIGHLIGHT_OPPORTUNITY;
            case ENGAGEMENT_DROP -> CuratorActionType.CREATE_CHALLENGE;
        };
    }

    /**
     * Resolve from code string
     */
    public static StallConditionType fromCode(String code) {
        for (StallConditionType type : values()) {
            if (type.code.equalsIgnoreCase(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown stall condition type code: " + code);
    }
}
