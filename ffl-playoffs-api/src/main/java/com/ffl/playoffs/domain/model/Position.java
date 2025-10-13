package com.ffl.playoffs.domain.model;

/**
 * NFL Player Position Enum
 * Represents the position of an NFL player or roster slot
 */
public enum Position {
    QB("Quarterback"),
    RB("Running Back"),
    WR("Wide Receiver"),
    TE("Tight End"),
    K("Kicker"),
    DEF("Defense/Special Teams"),
    FLEX("Flex (RB/WR/TE)"),
    SUPERFLEX("Superflex (QB/RB/WR/TE)");

    private final String displayName;

    Position(String displayName) {
        this.displayName = displayName;
    }

    public String getDisplayName() {
        return displayName;
    }

    /**
     * Check if a position is eligible for FLEX
     * @param position the position to check
     * @return true if position can fill FLEX slot
     */
    public static boolean isFlexEligible(Position position) {
        return position == RB || position == WR || position == TE;
    }

    /**
     * Check if a position is eligible for SUPERFLEX
     * @param position the position to check
     * @return true if position can fill SUPERFLEX slot
     */
    public static boolean isSuperflexEligible(Position position) {
        return position == QB || position == RB || position == WR || position == TE;
    }

    /**
     * Validate if a player position can fill a roster slot position
     * @param playerPosition the NFL player's position
     * @param slotPosition the roster slot position
     * @return true if player can fill the slot
     */
    public static boolean canFillSlot(Position playerPosition, Position slotPosition) {
        // Exact match
        if (playerPosition == slotPosition) {
            return true;
        }

        // FLEX slot accepts RB, WR, TE
        if (slotPosition == FLEX && isFlexEligible(playerPosition)) {
            return true;
        }

        // SUPERFLEX slot accepts QB, RB, WR, TE
        if (slotPosition == SUPERFLEX && isSuperflexEligible(playerPosition)) {
            return true;
        }

        return false;
    }
}
