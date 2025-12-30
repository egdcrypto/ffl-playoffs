package com.ffl.playoffs.domain.model.character;

/**
 * Achievement Type enumeration
 * Represents different types of achievements a character can earn
 */
public enum AchievementType {
    // Participation achievements
    FIRST_LEAGUE("first_league", "First Steps", "Joined your first league", 10),
    FIRST_WIN("first_win", "Victor", "Won your first game", 25),
    FIRST_SEASON("first_season", "Survivor", "Completed your first full season", 50),

    // Win-based achievements
    SEASON_CHAMPION("season_champion", "Season Champion", "Won a season championship", 100),
    BACK_TO_BACK("back_to_back", "Back to Back", "Won consecutive seasons", 150),
    DYNASTY("dynasty", "Dynasty Builder", "Won 3 or more seasons", 250),

    // Performance achievements
    PERFECT_WEEK("perfect_week", "Perfect Week", "Scored highest in all positions for a week", 75),
    TOP_SCORER("top_scorer", "Top Scorer", "Highest total points in a season", 100),
    COMEBACK_KING("comeback_king", "Comeback King", "Won after being last place", 50),

    // Streak achievements
    STREAK_5("streak_5", "Hot Streak", "Won 5 games in a row", 40),
    STREAK_10("streak_10", "On Fire", "Won 10 games in a row", 80),
    UNDEFEATED("undefeated", "Undefeated", "Completed a season without a loss", 200),

    // Consistency achievements
    CONSISTENCY_EXPERT("consistency_expert", "Consistent Performer", "Top 3 finish for 5 consecutive weeks", 60),
    IRON_MAN("iron_man", "Iron Man", "Participated in 10 seasons", 100),
    VETERAN("veteran", "Veteran", "Played 100 games", 75),

    // Social achievements
    LEAGUE_FOUNDER("league_founder", "League Founder", "Created a league", 25),
    RECRUITER("recruiter", "Recruiter", "Invited 5 players to a league", 30),

    // Special achievements
    UNDERDOG("underdog", "Underdog Victory", "Won as the lowest ranked player", 50),
    RIVALRY_WIN("rivalry_win", "Rivalry Winner", "Defeated the same opponent 3 times", 35);

    private final String code;
    private final String name;
    private final String description;
    private final int xpReward;

    AchievementType(String code, String name, String description, int xpReward) {
        this.code = code;
        this.name = name;
        this.description = description;
        this.xpReward = xpReward;
    }

    public String getCode() {
        return code;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public int getXpReward() {
        return xpReward;
    }

    /**
     * Check if this achievement is a one-time achievement
     * @return true if can only be earned once
     */
    public boolean isOneTime() {
        return switch (this) {
            case FIRST_LEAGUE, FIRST_WIN, FIRST_SEASON -> true;
            default -> false;
        };
    }

    /**
     * Check if this achievement is repeatable
     * @return true if can be earned multiple times
     */
    public boolean isRepeatable() {
        return !isOneTime();
    }
}
