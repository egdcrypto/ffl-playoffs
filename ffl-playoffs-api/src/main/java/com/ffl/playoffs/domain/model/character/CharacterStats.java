package com.ffl.playoffs.domain.model.character;

import java.util.Objects;

/**
 * Character Stats value object
 * Contains statistical performance data for a character
 */
public final class CharacterStats {

    private final Integer gamesPlayed;
    private final Integer wins;
    private final Integer losses;
    private final Integer ties;
    private final Integer seasonsPlayed;
    private final Integer seasonWins;
    private final Integer currentWinStreak;
    private final Integer bestWinStreak;
    private final Double totalPointsScored;
    private final Double highestWeeklyScore;

    private CharacterStats(Builder builder) {
        this.gamesPlayed = builder.gamesPlayed != null ? builder.gamesPlayed : 0;
        this.wins = builder.wins != null ? builder.wins : 0;
        this.losses = builder.losses != null ? builder.losses : 0;
        this.ties = builder.ties != null ? builder.ties : 0;
        this.seasonsPlayed = builder.seasonsPlayed != null ? builder.seasonsPlayed : 0;
        this.seasonWins = builder.seasonWins != null ? builder.seasonWins : 0;
        this.currentWinStreak = builder.currentWinStreak != null ? builder.currentWinStreak : 0;
        this.bestWinStreak = builder.bestWinStreak != null ? builder.bestWinStreak : 0;
        this.totalPointsScored = builder.totalPointsScored != null ? builder.totalPointsScored : 0.0;
        this.highestWeeklyScore = builder.highestWeeklyScore != null ? builder.highestWeeklyScore : 0.0;
    }

    /**
     * Create empty stats for a new character
     * @return empty stats
     */
    public static CharacterStats empty() {
        return builder().build();
    }

    /**
     * Record a game win
     * @param pointsScored points scored in the game
     * @return updated stats
     */
    public CharacterStats recordWin(double pointsScored) {
        int newStreak = this.currentWinStreak + 1;
        return builder()
                .gamesPlayed(this.gamesPlayed + 1)
                .wins(this.wins + 1)
                .losses(this.losses)
                .ties(this.ties)
                .seasonsPlayed(this.seasonsPlayed)
                .seasonWins(this.seasonWins)
                .currentWinStreak(newStreak)
                .bestWinStreak(Math.max(this.bestWinStreak, newStreak))
                .totalPointsScored(this.totalPointsScored + pointsScored)
                .highestWeeklyScore(Math.max(this.highestWeeklyScore, pointsScored))
                .build();
    }

    /**
     * Record a game loss
     * @param pointsScored points scored in the game
     * @return updated stats
     */
    public CharacterStats recordLoss(double pointsScored) {
        return builder()
                .gamesPlayed(this.gamesPlayed + 1)
                .wins(this.wins)
                .losses(this.losses + 1)
                .ties(this.ties)
                .seasonsPlayed(this.seasonsPlayed)
                .seasonWins(this.seasonWins)
                .currentWinStreak(0) // Reset streak
                .bestWinStreak(this.bestWinStreak)
                .totalPointsScored(this.totalPointsScored + pointsScored)
                .highestWeeklyScore(Math.max(this.highestWeeklyScore, pointsScored))
                .build();
    }

    /**
     * Record a tie
     * @param pointsScored points scored in the game
     * @return updated stats
     */
    public CharacterStats recordTie(double pointsScored) {
        return builder()
                .gamesPlayed(this.gamesPlayed + 1)
                .wins(this.wins)
                .losses(this.losses)
                .ties(this.ties + 1)
                .seasonsPlayed(this.seasonsPlayed)
                .seasonWins(this.seasonWins)
                .currentWinStreak(0) // Reset streak
                .bestWinStreak(this.bestWinStreak)
                .totalPointsScored(this.totalPointsScored + pointsScored)
                .highestWeeklyScore(Math.max(this.highestWeeklyScore, pointsScored))
                .build();
    }

    /**
     * Record a season championship win
     * @return updated stats
     */
    public CharacterStats recordSeasonWin() {
        return builder()
                .gamesPlayed(this.gamesPlayed)
                .wins(this.wins)
                .losses(this.losses)
                .ties(this.ties)
                .seasonsPlayed(this.seasonsPlayed + 1)
                .seasonWins(this.seasonWins + 1)
                .currentWinStreak(this.currentWinStreak)
                .bestWinStreak(this.bestWinStreak)
                .totalPointsScored(this.totalPointsScored)
                .highestWeeklyScore(this.highestWeeklyScore)
                .build();
    }

    /**
     * Record completing a season (without winning)
     * @return updated stats
     */
    public CharacterStats recordSeasonComplete() {
        return builder()
                .gamesPlayed(this.gamesPlayed)
                .wins(this.wins)
                .losses(this.losses)
                .ties(this.ties)
                .seasonsPlayed(this.seasonsPlayed + 1)
                .seasonWins(this.seasonWins)
                .currentWinStreak(this.currentWinStreak)
                .bestWinStreak(this.bestWinStreak)
                .totalPointsScored(this.totalPointsScored)
                .highestWeeklyScore(this.highestWeeklyScore)
                .build();
    }

    /**
     * Calculate win percentage
     * @return win percentage (0-100)
     */
    public double getWinPercentage() {
        if (gamesPlayed == 0) {
            return 0.0;
        }
        return (wins * 100.0) / gamesPlayed;
    }

    /**
     * Calculate average points per game
     * @return average points
     */
    public double getAveragePointsPerGame() {
        if (gamesPlayed == 0) {
            return 0.0;
        }
        return totalPointsScored / gamesPlayed;
    }

    // Getters

    public Integer getGamesPlayed() {
        return gamesPlayed;
    }

    public Integer getWins() {
        return wins;
    }

    public Integer getLosses() {
        return losses;
    }

    public Integer getTies() {
        return ties;
    }

    public Integer getSeasonsPlayed() {
        return seasonsPlayed;
    }

    public Integer getSeasonWins() {
        return seasonWins;
    }

    public Integer getCurrentWinStreak() {
        return currentWinStreak;
    }

    public Integer getBestWinStreak() {
        return bestWinStreak;
    }

    public Double getTotalPointsScored() {
        return totalPointsScored;
    }

    public Double getHighestWeeklyScore() {
        return highestWeeklyScore;
    }

    // Builder

    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private Integer gamesPlayed;
        private Integer wins;
        private Integer losses;
        private Integer ties;
        private Integer seasonsPlayed;
        private Integer seasonWins;
        private Integer currentWinStreak;
        private Integer bestWinStreak;
        private Double totalPointsScored;
        private Double highestWeeklyScore;

        public Builder gamesPlayed(Integer gamesPlayed) {
            this.gamesPlayed = gamesPlayed;
            return this;
        }

        public Builder wins(Integer wins) {
            this.wins = wins;
            return this;
        }

        public Builder losses(Integer losses) {
            this.losses = losses;
            return this;
        }

        public Builder ties(Integer ties) {
            this.ties = ties;
            return this;
        }

        public Builder seasonsPlayed(Integer seasonsPlayed) {
            this.seasonsPlayed = seasonsPlayed;
            return this;
        }

        public Builder seasonWins(Integer seasonWins) {
            this.seasonWins = seasonWins;
            return this;
        }

        public Builder currentWinStreak(Integer currentWinStreak) {
            this.currentWinStreak = currentWinStreak;
            return this;
        }

        public Builder bestWinStreak(Integer bestWinStreak) {
            this.bestWinStreak = bestWinStreak;
            return this;
        }

        public Builder totalPointsScored(Double totalPointsScored) {
            this.totalPointsScored = totalPointsScored;
            return this;
        }

        public Builder highestWeeklyScore(Double highestWeeklyScore) {
            this.highestWeeklyScore = highestWeeklyScore;
            return this;
        }

        public CharacterStats build() {
            return new CharacterStats(this);
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CharacterStats that = (CharacterStats) o;
        return Objects.equals(gamesPlayed, that.gamesPlayed) &&
                Objects.equals(wins, that.wins) &&
                Objects.equals(losses, that.losses) &&
                Objects.equals(ties, that.ties) &&
                Objects.equals(seasonsPlayed, that.seasonsPlayed) &&
                Objects.equals(seasonWins, that.seasonWins);
    }

    @Override
    public int hashCode() {
        return Objects.hash(gamesPlayed, wins, losses, ties, seasonsPlayed, seasonWins);
    }

    @Override
    public String toString() {
        return String.format("CharacterStats{games=%d, W/L/T=%d/%d/%d, seasons=%d, wins=%.1f%%}",
                gamesPlayed, wins, losses, ties, seasonsPlayed, getWinPercentage());
    }
}
