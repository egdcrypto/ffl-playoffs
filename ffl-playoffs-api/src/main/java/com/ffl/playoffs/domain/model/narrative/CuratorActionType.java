package com.ffl.playoffs.domain.model.narrative;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Types of actions the AI Director or human curator can take
 * to influence the narrative and maintain engagement.
 */
@Getter
@RequiredArgsConstructor
public enum CuratorActionType {

    // Notification Actions
    SEND_REMINDER("send_reminder", "Send Reminder",
            "Send a reminder notification to players",
            ActionCategory.NOTIFICATION, false),

    SEND_ALERT("send_alert", "Send Alert",
            "Send an urgent alert about game state",
            ActionCategory.NOTIFICATION, false),

    // Story Actions
    GENERATE_STORY_BEAT("generate_story_beat", "Generate Story Beat",
            "Create a new narrative story beat",
            ActionCategory.STORY, true),

    HIGHLIGHT_MOMENT("highlight_moment", "Highlight Moment",
            "Highlight a significant game moment",
            ActionCategory.STORY, false),

    HIGHLIGHT_OPPORTUNITY("highlight_opportunity", "Highlight Opportunity",
            "Point out a comeback or strategic opportunity",
            ActionCategory.STORY, false),

    CREATE_RIVALRY("create_rivalry", "Create Rivalry",
            "Establish or emphasize a rivalry narrative",
            ActionCategory.STORY, true),

    // Engagement Actions
    CREATE_CHALLENGE("create_challenge", "Create Challenge",
            "Create a mini-challenge to boost engagement",
            ActionCategory.ENGAGEMENT, true),

    TRIGGER_ELIMINATION_CHECK("trigger_elimination_check", "Trigger Elimination Check",
            "Force an elimination evaluation",
            ActionCategory.ENGAGEMENT, true),

    BOOST_UNDERDOG("boost_underdog", "Boost Underdog",
            "Highlight underdog comeback potential",
            ActionCategory.ENGAGEMENT, false),

    // Moderation Actions
    ADJUST_TENSION("adjust_tension", "Adjust Tension",
            "Manually adjust the tension level",
            ActionCategory.MODERATION, true),

    PAUSE_NARRATIVE("pause_narrative", "Pause Narrative",
            "Temporarily pause narrative generation",
            ActionCategory.MODERATION, true),

    RESUME_NARRATIVE("resume_narrative", "Resume Narrative",
            "Resume narrative generation after pause",
            ActionCategory.MODERATION, true),

    OVERRIDE_PHASE("override_phase", "Override Phase",
            "Manually set the narrative phase",
            ActionCategory.MODERATION, true),

    // Administrative Actions
    ARCHIVE_STORY_ARC("archive_story_arc", "Archive Story Arc",
            "Archive a completed story arc",
            ActionCategory.ADMINISTRATIVE, true),

    RESET_STALL_DETECTION("reset_stall_detection", "Reset Stall Detection",
            "Reset stall detection timers",
            ActionCategory.ADMINISTRATIVE, true);

    private final String code;
    private final String displayName;
    private final String description;
    private final ActionCategory category;
    private final boolean requiresConfirmation;

    /**
     * Categories of curator actions
     */
    public enum ActionCategory {
        NOTIFICATION, STORY, ENGAGEMENT, MODERATION, ADMINISTRATIVE
    }

    /**
     * Check if this action affects the narrative directly
     */
    public boolean affectsNarrative() {
        return category == ActionCategory.STORY || category == ActionCategory.MODERATION;
    }

    /**
     * Check if this action is player-facing
     */
    public boolean isPlayerFacing() {
        return category == ActionCategory.NOTIFICATION ||
               category == ActionCategory.STORY ||
               category == ActionCategory.ENGAGEMENT;
    }

    /**
     * Check if this action can be automated by AI
     */
    public boolean canBeAutomated() {
        return !requiresConfirmation &&
               category != ActionCategory.ADMINISTRATIVE &&
               category != ActionCategory.MODERATION;
    }

    /**
     * Check if this action is reversible
     */
    public boolean isReversible() {
        return switch (this) {
            case PAUSE_NARRATIVE, RESUME_NARRATIVE, ADJUST_TENSION -> true;
            case ARCHIVE_STORY_ARC, TRIGGER_ELIMINATION_CHECK -> false;
            default -> true;
        };
    }

    /**
     * Get the priority level of this action (1-10, higher = more urgent)
     */
    public int getPriorityLevel() {
        return switch (this) {
            case TRIGGER_ELIMINATION_CHECK -> 10;
            case SEND_ALERT -> 9;
            case ADJUST_TENSION, OVERRIDE_PHASE -> 8;
            case PAUSE_NARRATIVE, RESUME_NARRATIVE -> 7;
            case CREATE_CHALLENGE, BOOST_UNDERDOG -> 6;
            case GENERATE_STORY_BEAT, CREATE_RIVALRY -> 5;
            case HIGHLIGHT_MOMENT, HIGHLIGHT_OPPORTUNITY -> 4;
            case SEND_REMINDER -> 3;
            case ARCHIVE_STORY_ARC, RESET_STALL_DETECTION -> 2;
        };
    }

    /**
     * Resolve from code string
     */
    public static CuratorActionType fromCode(String code) {
        for (CuratorActionType type : values()) {
            if (type.code.equalsIgnoreCase(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown curator action type code: " + code);
    }
}
