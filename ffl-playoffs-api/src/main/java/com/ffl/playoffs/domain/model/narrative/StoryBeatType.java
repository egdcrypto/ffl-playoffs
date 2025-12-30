package com.ffl.playoffs.domain.model.narrative;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Types of story beats in the narrative DAG.
 * Each type represents a different kind of narrative moment.
 */
@Getter
@RequiredArgsConstructor
public enum StoryBeatType {

    // Milestone Beats
    SEASON_START("season_start", "Season Start", "The beginning of a new season", true),
    WEEK_START("week_start", "Week Start", "A new week begins", false),
    WEEK_END("week_end", "Week End", "A week concludes", false),
    SEASON_END("season_end", "Season End", "The season finale", true),

    // Competition Beats
    ELIMINATION("elimination", "Elimination", "A player is eliminated", true),
    NEAR_ELIMINATION("near_elimination", "Near Elimination", "A player narrowly avoids elimination", true),
    COMEBACK("comeback", "Comeback", "A significant score recovery", true),
    UPSET("upset", "Upset", "An unexpected result", true),

    // Achievement Beats
    HIGH_SCORE("high_score", "High Score", "A notably high weekly score", false),
    PERFECT_WEEK("perfect_week", "Perfect Week", "All roster picks performed well", true),
    STREAK("streak", "Streak", "A winning or losing streak", false),
    MILESTONE("milestone", "Milestone", "A scoring or ranking milestone", false),

    // Rivalry Beats
    RIVALRY_CLASH("rivalry_clash", "Rivalry Clash", "Head-to-head rivalry moment", true),
    RIVALRY_FORMED("rivalry_formed", "Rivalry Formed", "A new rivalry emerges", true),
    RIVALRY_RESOLVED("rivalry_resolved", "Rivalry Resolved", "A rivalry reaches conclusion", true),

    // Tension Beats
    TENSION_SPIKE("tension_spike", "Tension Spike", "Sudden increase in stakes", false),
    CLIMAX_MOMENT("climax_moment", "Climax Moment", "Peak narrative tension", true),
    RESOLUTION("resolution", "Resolution", "Tension resolves", false),

    // System Beats
    STALL_DETECTED("stall_detected", "Stall Detected", "Narrative stall identified", false),
    CURATOR_INTERVENTION("curator_intervention", "Curator Intervention", "Manual curator action taken", false);

    private final String code;
    private final String displayName;
    private final String description;
    private final boolean isMajorBeat;

    /**
     * Check if this beat type typically ends a story arc
     */
    public boolean isArcEnding() {
        return this == ELIMINATION || this == SEASON_END ||
               this == RIVALRY_RESOLVED || this == RESOLUTION;
    }

    /**
     * Check if this beat type typically starts a story arc
     */
    public boolean isArcStarting() {
        return this == SEASON_START || this == RIVALRY_FORMED ||
               this == TENSION_SPIKE;
    }

    /**
     * Check if this beat type is player-related
     */
    public boolean isPlayerRelated() {
        return this == ELIMINATION || this == NEAR_ELIMINATION ||
               this == COMEBACK || this == UPSET ||
               this == HIGH_SCORE || this == PERFECT_WEEK ||
               this == STREAK || this == MILESTONE;
    }

    /**
     * Check if this beat type is rivalry-related
     */
    public boolean isRivalryRelated() {
        return this == RIVALRY_CLASH || this == RIVALRY_FORMED ||
               this == RIVALRY_RESOLVED;
    }

    /**
     * Check if this beat type is system-generated
     */
    public boolean isSystemGenerated() {
        return this == WEEK_START || this == WEEK_END ||
               this == STALL_DETECTED || this == CURATOR_INTERVENTION;
    }

    /**
     * Get the tension impact of this beat type (-100 to +100)
     */
    public int getTensionImpact() {
        return switch (this) {
            case ELIMINATION -> 30;
            case NEAR_ELIMINATION -> 40;
            case COMEBACK -> 25;
            case UPSET -> 35;
            case CLIMAX_MOMENT -> 50;
            case TENSION_SPIKE -> 20;
            case RIVALRY_CLASH -> 25;
            case RIVALRY_FORMED -> 15;
            case PERFECT_WEEK, HIGH_SCORE -> 10;
            case RESOLUTION, RIVALRY_RESOLVED, SEASON_END -> -20;
            case STALL_DETECTED -> -10;
            default -> 0;
        };
    }

    /**
     * Resolve from code string
     */
    public static StoryBeatType fromCode(String code) {
        for (StoryBeatType type : values()) {
            if (type.code.equalsIgnoreCase(code)) {
                return type;
            }
        }
        throw new IllegalArgumentException("Unknown story beat type code: " + code);
    }
}
