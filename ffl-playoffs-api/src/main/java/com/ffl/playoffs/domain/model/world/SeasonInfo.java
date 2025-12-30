package com.ffl.playoffs.domain.model.world;

import java.time.LocalDateTime;
import java.util.Objects;

/**
 * Season Info value object
 * Contains metadata about the current state of a world's season
 */
public final class SeasonInfo {

    private final Integer season;
    private final Integer currentWeek;
    private final Integer totalWeeks;
    private final LocalDateTime seasonStartDate;
    private final LocalDateTime seasonEndDate;
    private final LocalDateTime currentWeekStartDate;
    private final LocalDateTime currentWeekEndDate;

    private SeasonInfo(Builder builder) {
        this.season = Objects.requireNonNull(builder.season, "Season is required");
        this.currentWeek = Objects.requireNonNull(builder.currentWeek, "Current week is required");
        this.totalWeeks = Objects.requireNonNull(builder.totalWeeks, "Total weeks is required");
        this.seasonStartDate = builder.seasonStartDate;
        this.seasonEndDate = builder.seasonEndDate;
        this.currentWeekStartDate = builder.currentWeekStartDate;
        this.currentWeekEndDate = builder.currentWeekEndDate;

        validate();
    }

    private void validate() {
        if (currentWeek < 1 || currentWeek > totalWeeks + 1) {
            throw new IllegalArgumentException(
                    String.format("Current week %d must be between 1 and %d", currentWeek, totalWeeks + 1));
        }

        if (totalWeeks < 1 || totalWeeks > 22) {
            throw new IllegalArgumentException("Total weeks must be between 1 and 22");
        }
    }

    /**
     * Create initial season info from world configuration
     * @param configuration the world configuration
     * @return season info at week 1
     */
    public static SeasonInfo fromConfiguration(WorldConfiguration configuration) {
        return builder()
                .season(configuration.getSeason())
                .currentWeek(configuration.getStartingNflWeek())
                .totalWeeks(configuration.getNumberOfWeeks())
                .build();
    }

    /**
     * Advance to the next week
     * @return new SeasonInfo with incremented week
     * @throws IllegalStateException if already at last week
     */
    public SeasonInfo advanceWeek() {
        if (isLastWeek()) {
            throw new IllegalStateException("Cannot advance past the last week of the season");
        }

        return builder()
                .season(this.season)
                .currentWeek(this.currentWeek + 1)
                .totalWeeks(this.totalWeeks)
                .seasonStartDate(this.seasonStartDate)
                .seasonEndDate(this.seasonEndDate)
                .build();
    }

    /**
     * Update week dates
     * @param startDate start of the week
     * @param endDate end of the week
     * @return new SeasonInfo with updated dates
     */
    public SeasonInfo withWeekDates(LocalDateTime startDate, LocalDateTime endDate) {
        return builder()
                .season(this.season)
                .currentWeek(this.currentWeek)
                .totalWeeks(this.totalWeeks)
                .seasonStartDate(this.seasonStartDate)
                .seasonEndDate(this.seasonEndDate)
                .currentWeekStartDate(startDate)
                .currentWeekEndDate(endDate)
                .build();
    }

    /**
     * Check if currently on the last week
     * @return true if on last week
     */
    public boolean isLastWeek() {
        return currentWeek >= totalWeeks;
    }

    /**
     * Check if currently on the first week
     * @return true if on first week
     */
    public boolean isFirstWeek() {
        return currentWeek == 1;
    }

    /**
     * Get the progress through the season as a percentage
     * @return progress percentage (0-100)
     */
    public int getProgressPercentage() {
        return (int) ((currentWeek * 100.0) / totalWeeks);
    }

    /**
     * Get the number of weeks remaining
     * @return weeks remaining
     */
    public int getWeeksRemaining() {
        return Math.max(0, totalWeeks - currentWeek);
    }

    // Getters

    public Integer getSeason() {
        return season;
    }

    public Integer getCurrentWeek() {
        return currentWeek;
    }

    public Integer getTotalWeeks() {
        return totalWeeks;
    }

    public LocalDateTime getSeasonStartDate() {
        return seasonStartDate;
    }

    public LocalDateTime getSeasonEndDate() {
        return seasonEndDate;
    }

    public LocalDateTime getCurrentWeekStartDate() {
        return currentWeekStartDate;
    }

    public LocalDateTime getCurrentWeekEndDate() {
        return currentWeekEndDate;
    }

    // Builder

    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private Integer season;
        private Integer currentWeek;
        private Integer totalWeeks;
        private LocalDateTime seasonStartDate;
        private LocalDateTime seasonEndDate;
        private LocalDateTime currentWeekStartDate;
        private LocalDateTime currentWeekEndDate;

        public Builder season(Integer season) {
            this.season = season;
            return this;
        }

        public Builder currentWeek(Integer currentWeek) {
            this.currentWeek = currentWeek;
            return this;
        }

        public Builder totalWeeks(Integer totalWeeks) {
            this.totalWeeks = totalWeeks;
            return this;
        }

        public Builder seasonStartDate(LocalDateTime seasonStartDate) {
            this.seasonStartDate = seasonStartDate;
            return this;
        }

        public Builder seasonEndDate(LocalDateTime seasonEndDate) {
            this.seasonEndDate = seasonEndDate;
            return this;
        }

        public Builder currentWeekStartDate(LocalDateTime currentWeekStartDate) {
            this.currentWeekStartDate = currentWeekStartDate;
            return this;
        }

        public Builder currentWeekEndDate(LocalDateTime currentWeekEndDate) {
            this.currentWeekEndDate = currentWeekEndDate;
            return this;
        }

        public SeasonInfo build() {
            return new SeasonInfo(this);
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SeasonInfo that = (SeasonInfo) o;
        return Objects.equals(season, that.season) &&
                Objects.equals(currentWeek, that.currentWeek) &&
                Objects.equals(totalWeeks, that.totalWeeks);
    }

    @Override
    public int hashCode() {
        return Objects.hash(season, currentWeek, totalWeeks);
    }

    @Override
    public String toString() {
        return String.format("SeasonInfo{season=%d, week=%d/%d, remaining=%d}",
                season, currentWeek, totalWeeks, getWeeksRemaining());
    }
}
