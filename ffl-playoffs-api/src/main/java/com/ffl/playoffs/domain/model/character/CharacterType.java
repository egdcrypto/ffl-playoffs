package com.ffl.playoffs.domain.model.character;

/**
 * Character Type enumeration
 * Represents the progression tier of a player's character
 */
public enum CharacterType {
    /**
     * New player, just started
     */
    ROOKIE("rookie", "Rookie", 0),

    /**
     * Standard player with some experience
     */
    STANDARD("standard", "Standard", 10),

    /**
     * Experienced player, won at least one season
     */
    PRO("pro", "Pro", 50),

    /**
     * Elite player, multiple season wins
     */
    ELITE("elite", "Elite", 100),

    /**
     * Legendary status, exceptional achievement
     */
    LEGEND("legend", "Legend", 200);

    private final String code;
    private final String displayName;
    private final int requiredLevel;

    CharacterType(String code, String displayName, int requiredLevel) {
        this.code = code;
        this.displayName = displayName;
        this.requiredLevel = requiredLevel;
    }

    public String getCode() {
        return code;
    }

    public String getDisplayName() {
        return displayName;
    }

    public int getRequiredLevel() {
        return requiredLevel;
    }

    /**
     * Get the character type for a given level
     * @param level the character's level
     * @return the appropriate character type
     */
    public static CharacterType forLevel(int level) {
        if (level >= LEGEND.requiredLevel) {
            return LEGEND;
        } else if (level >= ELITE.requiredLevel) {
            return ELITE;
        } else if (level >= PRO.requiredLevel) {
            return PRO;
        } else if (level >= STANDARD.requiredLevel) {
            return STANDARD;
        }
        return ROOKIE;
    }

    /**
     * Check if this type can be upgraded to another type
     * @param targetType the type to upgrade to
     * @return true if upgrade is possible
     */
    public boolean canUpgradeTo(CharacterType targetType) {
        return this.ordinal() < targetType.ordinal();
    }
}
