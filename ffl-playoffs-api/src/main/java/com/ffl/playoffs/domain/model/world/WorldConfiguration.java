package com.ffl.playoffs.domain.model.world;

import java.util.Objects;

/**
 * World Configuration value object
 * Contains all configurable settings for a fantasy football world
 */
public final class WorldConfiguration {

    private final Integer season;
    private final Integer startingNflWeek;
    private final Integer endingNflWeek;
    private final Integer maxLeagues;
    private final Integer maxPlayersPerLeague;
    private final Boolean allowLateRegistration;
    private final Boolean autoAdvanceWeeks;
    private final String timezone;

    private WorldConfiguration(Builder builder) {
        this.season = Objects.requireNonNull(builder.season, "Season is required");
        this.startingNflWeek = Objects.requireNonNull(builder.startingNflWeek, "Starting NFL week is required");
        this.endingNflWeek = Objects.requireNonNull(builder.endingNflWeek, "Ending NFL week is required");
        this.maxLeagues = builder.maxLeagues != null ? builder.maxLeagues : 100;
        this.maxPlayersPerLeague = builder.maxPlayersPerLeague != null ? builder.maxPlayersPerLeague : 20;
        this.allowLateRegistration = builder.allowLateRegistration != null ? builder.allowLateRegistration : false;
        this.autoAdvanceWeeks = builder.autoAdvanceWeeks != null ? builder.autoAdvanceWeeks : true;
        this.timezone = builder.timezone != null ? builder.timezone : "America/New_York";

        validate();
    }

    /**
     * Validates the configuration
     * @throws IllegalArgumentException if validation fails
     */
    private void validate() {
        if (season < 2020 || season > 2100) {
            throw new IllegalArgumentException("Season must be between 2020 and 2100");
        }

        if (startingNflWeek < 1 || startingNflWeek > 22) {
            throw new IllegalArgumentException("Starting NFL week must be between 1 and 22");
        }

        if (endingNflWeek < 1 || endingNflWeek > 22) {
            throw new IllegalArgumentException("Ending NFL week must be between 1 and 22");
        }

        if (startingNflWeek > endingNflWeek) {
            throw new IllegalArgumentException("Starting NFL week cannot be after ending NFL week");
        }

        if (maxLeagues < 1 || maxLeagues > 10000) {
            throw new IllegalArgumentException("Max leagues must be between 1 and 10000");
        }

        if (maxPlayersPerLeague < 2 || maxPlayersPerLeague > 100) {
            throw new IllegalArgumentException("Max players per league must be between 2 and 100");
        }
    }

    /**
     * Creates a default configuration for a given season
     * @param season the NFL season year
     * @return default configuration
     */
    public static WorldConfiguration defaultForSeason(int season) {
        return builder()
                .season(season)
                .startingNflWeek(1)
                .endingNflWeek(18)
                .maxLeagues(100)
                .maxPlayersPerLeague(20)
                .allowLateRegistration(false)
                .autoAdvanceWeeks(true)
                .timezone("America/New_York")
                .build();
    }

    /**
     * Creates a playoffs configuration for a given season
     * @param season the NFL season year
     * @return playoffs configuration (weeks 19-22)
     */
    public static WorldConfiguration playoffsForSeason(int season) {
        return builder()
                .season(season)
                .startingNflWeek(19)
                .endingNflWeek(22)
                .maxLeagues(100)
                .maxPlayersPerLeague(20)
                .allowLateRegistration(false)
                .autoAdvanceWeeks(true)
                .timezone("America/New_York")
                .build();
    }

    /**
     * Calculate the number of weeks in this world
     * @return number of weeks
     */
    public int getNumberOfWeeks() {
        return endingNflWeek - startingNflWeek + 1;
    }

    /**
     * Check if a given NFL week is within this world's range
     * @param nflWeek the NFL week to check
     * @return true if within range
     */
    public boolean isWeekInRange(int nflWeek) {
        return nflWeek >= startingNflWeek && nflWeek <= endingNflWeek;
    }

    // Getters

    public Integer getSeason() {
        return season;
    }

    public Integer getStartingNflWeek() {
        return startingNflWeek;
    }

    public Integer getEndingNflWeek() {
        return endingNflWeek;
    }

    public Integer getMaxLeagues() {
        return maxLeagues;
    }

    public Integer getMaxPlayersPerLeague() {
        return maxPlayersPerLeague;
    }

    public Boolean getAllowLateRegistration() {
        return allowLateRegistration;
    }

    public Boolean getAutoAdvanceWeeks() {
        return autoAdvanceWeeks;
    }

    public String getTimezone() {
        return timezone;
    }

    // Builder

    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private Integer season;
        private Integer startingNflWeek;
        private Integer endingNflWeek;
        private Integer maxLeagues;
        private Integer maxPlayersPerLeague;
        private Boolean allowLateRegistration;
        private Boolean autoAdvanceWeeks;
        private String timezone;

        public Builder season(Integer season) {
            this.season = season;
            return this;
        }

        public Builder startingNflWeek(Integer startingNflWeek) {
            this.startingNflWeek = startingNflWeek;
            return this;
        }

        public Builder endingNflWeek(Integer endingNflWeek) {
            this.endingNflWeek = endingNflWeek;
            return this;
        }

        public Builder maxLeagues(Integer maxLeagues) {
            this.maxLeagues = maxLeagues;
            return this;
        }

        public Builder maxPlayersPerLeague(Integer maxPlayersPerLeague) {
            this.maxPlayersPerLeague = maxPlayersPerLeague;
            return this;
        }

        public Builder allowLateRegistration(Boolean allowLateRegistration) {
            this.allowLateRegistration = allowLateRegistration;
            return this;
        }

        public Builder autoAdvanceWeeks(Boolean autoAdvanceWeeks) {
            this.autoAdvanceWeeks = autoAdvanceWeeks;
            return this;
        }

        public Builder timezone(String timezone) {
            this.timezone = timezone;
            return this;
        }

        public WorldConfiguration build() {
            return new WorldConfiguration(this);
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        WorldConfiguration that = (WorldConfiguration) o;
        return Objects.equals(season, that.season) &&
                Objects.equals(startingNflWeek, that.startingNflWeek) &&
                Objects.equals(endingNflWeek, that.endingNflWeek) &&
                Objects.equals(maxLeagues, that.maxLeagues) &&
                Objects.equals(maxPlayersPerLeague, that.maxPlayersPerLeague) &&
                Objects.equals(allowLateRegistration, that.allowLateRegistration) &&
                Objects.equals(autoAdvanceWeeks, that.autoAdvanceWeeks) &&
                Objects.equals(timezone, that.timezone);
    }

    @Override
    public int hashCode() {
        return Objects.hash(season, startingNflWeek, endingNflWeek, maxLeagues,
                maxPlayersPerLeague, allowLateRegistration, autoAdvanceWeeks, timezone);
    }

    @Override
    public String toString() {
        return String.format("WorldConfiguration{season=%d, weeks=%d-%d, maxLeagues=%d, maxPlayers=%d}",
                season, startingNflWeek, endingNflWeek, maxLeagues, maxPlayersPerLeague);
    }
}
