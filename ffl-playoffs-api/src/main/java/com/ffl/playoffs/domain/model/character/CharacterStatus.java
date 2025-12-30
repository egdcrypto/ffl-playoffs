package com.ffl.playoffs.domain.model.character;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

import java.util.Arrays;

/**
 * Three-stage character lifecycle status enumeration
 * Represents the progression of a character through the game
 */
@Getter
@RequiredArgsConstructor
public enum CharacterStatus {

    /**
     * Stage 1: Character is created but not yet active in the league/game
     * Character is in a preparation phase, setting up roster, etc.
     */
    DRAFT("draft", "Draft", "Character is in preparation phase"),

    /**
     * Stage 2: Character is actively participating in the league/game
     * Character can make selections, accumulate scores
     */
    ACTIVE("active", "Active", "Character is actively participating"),

    /**
     * Stage 3: Character has been eliminated from competition
     * Final state - character can no longer participate
     */
    ELIMINATED("eliminated", "Eliminated", "Character has been eliminated");

    private final String code;
    private final String displayName;
    private final String description;

    /**
     * Find status by code
     * @param code the status code
     * @return the CharacterStatus
     * @throws IllegalArgumentException if code not found
     */
    public static CharacterStatus fromCode(String code) {
        return Arrays.stream(values())
                .filter(s -> s.getCode().equalsIgnoreCase(code))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Unknown character status code: " + code));
    }

    /**
     * Check if character is in draft stage
     * @return true if in draft stage
     */
    public boolean isDraft() {
        return this == DRAFT;
    }

    /**
     * Check if character is active
     * @return true if active
     */
    public boolean isActive() {
        return this == ACTIVE;
    }

    /**
     * Check if character is eliminated
     * @return true if eliminated
     */
    public boolean isEliminated() {
        return this == ELIMINATED;
    }

    /**
     * Check if character can be activated
     * Only draft characters can be activated
     * @return true if can be activated
     */
    public boolean canActivate() {
        return this == DRAFT;
    }

    /**
     * Check if character can be eliminated
     * Only active characters can be eliminated
     * @return true if can be eliminated
     */
    public boolean canEliminate() {
        return this == ACTIVE;
    }

    /**
     * Check if character can make selections (roster changes, picks)
     * Only active characters can make selections
     * @return true if can make selections
     */
    public boolean canMakeSelections() {
        return this == ACTIVE;
    }

    /**
     * Check if character can accumulate score
     * Only active characters can accumulate score
     * @return true if can accumulate score
     */
    public boolean canAccumulateScore() {
        return this == ACTIVE;
    }

    /**
     * Check if this is a terminal state
     * Eliminated is the terminal state
     * @return true if terminal state
     */
    public boolean isTerminal() {
        return this == ELIMINATED;
    }

    /**
     * Check if character is still in competition
     * Draft and Active characters are in competition
     * @return true if in competition
     */
    public boolean isInCompetition() {
        return this == DRAFT || this == ACTIVE;
    }

    /**
     * Get the next status in the lifecycle
     * DRAFT -> ACTIVE -> ELIMINATED
     * @return the next status, or null if at terminal state
     */
    public CharacterStatus getNextStatus() {
        return switch (this) {
            case DRAFT -> ACTIVE;
            case ACTIVE -> ELIMINATED;
            case ELIMINATED -> null;
        };
    }

    /**
     * Get the previous status in the lifecycle
     * @return the previous status, or null if at initial state
     */
    public CharacterStatus getPreviousStatus() {
        return switch (this) {
            case DRAFT -> null;
            case ACTIVE -> DRAFT;
            case ELIMINATED -> ACTIVE;
        };
    }
}
