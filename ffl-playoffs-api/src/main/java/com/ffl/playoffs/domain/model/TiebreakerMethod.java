package com.ffl.playoffs.domain.model;

/**
 * Enum representing tiebreaker methods for resolving tied scores
 * Methods are applied in priority order (1 = highest priority)
 */
public enum TiebreakerMethod {
    HIGHEST_SINGLE_POSITION_SCORE(1, "Highest Single Position Score",
        "Player with the highest individual position score wins"),
    SECOND_HIGHEST_POSITION_SCORE(2, "Second Highest Position Score",
        "Player with the second highest individual position score wins"),
    MOST_TOUCHDOWNS(3, "Most Touchdowns",
        "Player whose roster scored the most touchdowns wins"),
    FEWER_TURNOVERS(4, "Fewer Turnovers",
        "Player whose roster had fewer turnovers wins"),
    HIGHER_SEED(5, "Higher Seed",
        "Player with the higher original playoff seed wins"),
    HEAD_TO_HEAD(6, "Head-to-Head Record",
        "Player with better head-to-head record wins"),
    BEST_SINGLE_WEEK_SCORE(7, "Best Single Week Score",
        "Player with the best single week score during playoffs wins"),
    TOTAL_PLAYOFF_TOUCHDOWNS(8, "Total Playoff Touchdowns",
        "Player with the most total playoff touchdowns wins"),
    ORIGINAL_DRAFT_POSITION(9, "Original Draft Position",
        "Player with the earlier draft position wins"),
    POINTS_AGAINST(10, "Points Against",
        "Player with fewer points scored against them wins"),
    CO_WINNERS(99, "Co-Winners",
        "Both players declared co-winners if all tiebreakers exhausted");

    private final int priority;
    private final String displayName;
    private final String description;

    TiebreakerMethod(int priority, String displayName, String description) {
        this.priority = priority;
        this.displayName = displayName;
        this.description = description;
    }

    public int getPriority() {
        return priority;
    }

    public String getDisplayName() {
        return displayName;
    }

    public String getDescription() {
        return description;
    }
}
