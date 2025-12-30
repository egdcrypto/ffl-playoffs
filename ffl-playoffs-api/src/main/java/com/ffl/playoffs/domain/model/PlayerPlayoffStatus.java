package com.ffl.playoffs.domain.model;

/**
 * Enum representing a player's status in the playoffs
 */
public enum PlayerPlayoffStatus {
    ACTIVE("Active in playoffs"),
    ELIMINATED("Eliminated from playoffs"),
    CHAMPION("Playoff champion"),
    CO_CHAMPION("Playoff co-champion");

    private final String displayName;

    PlayerPlayoffStatus(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    /**
     * Check if the player is still competing
     * @return true if the player is still active
     */
    public boolean isCompeting() {
        return this == ACTIVE;
    }

    /**
     * Check if the player has won the championship
     * @return true if the player is a champion or co-champion
     */
    public boolean isChampion() {
        return this == CHAMPION || this == CO_CHAMPION;
    }
}
