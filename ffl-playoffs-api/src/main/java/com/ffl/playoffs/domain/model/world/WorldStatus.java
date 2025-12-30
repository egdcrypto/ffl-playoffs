package com.ffl.playoffs.domain.model.world;

/**
 * World Status enumeration
 * Represents the lifecycle stages of a fantasy football world/season
 */
public enum WorldStatus {
    /**
     * World has been created but not yet configured
     */
    CREATED("created", "World created but not configured"),

    /**
     * World is being configured (leagues, rules setup)
     */
    CONFIGURING("configuring", "World configuration in progress"),

    /**
     * World is ready to start, waiting for season to begin
     */
    READY("ready", "World ready to start"),

    /**
     * World is active, season in progress
     */
    ACTIVE("active", "World active, season in progress"),

    /**
     * World is paused (for maintenance or other reasons)
     */
    PAUSED("paused", "World temporarily paused"),

    /**
     * World has completed the full season
     */
    COMPLETED("completed", "World season completed"),

    /**
     * World has been cancelled
     */
    CANCELLED("cancelled", "World cancelled");

    private final String code;
    private final String description;

    WorldStatus(String code, String description) {
        this.code = code;
        this.description = description;
    }

    public String getCode() {
        return code;
    }

    public String getDescription() {
        return description;
    }

    /**
     * Check if the world can transition to a new status
     * @param newStatus the target status
     * @return true if transition is valid
     */
    public boolean canTransitionTo(WorldStatus newStatus) {
        return switch (this) {
            case CREATED -> newStatus == CONFIGURING || newStatus == CANCELLED;
            case CONFIGURING -> newStatus == READY || newStatus == CANCELLED;
            case READY -> newStatus == ACTIVE || newStatus == CANCELLED;
            case ACTIVE -> newStatus == PAUSED || newStatus == COMPLETED || newStatus == CANCELLED;
            case PAUSED -> newStatus == ACTIVE || newStatus == CANCELLED;
            case COMPLETED, CANCELLED -> false;
        };
    }

    /**
     * Check if the world is in a terminal state
     * @return true if no further transitions are possible
     */
    public boolean isTerminal() {
        return this == COMPLETED || this == CANCELLED;
    }

    /**
     * Check if the world is in an active state where games can occur
     * @return true if world is active
     */
    public boolean isRunning() {
        return this == ACTIVE;
    }
}
