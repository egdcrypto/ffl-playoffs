package com.ffl.playoffs.domain.model.world;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("WorldConfiguration Value Object Tests")
class WorldConfigurationTest {

    @Test
    @DisplayName("should create configuration with builder")
    void shouldCreateConfigurationWithBuilder() {
        WorldConfiguration config = WorldConfiguration.builder()
                .season(2024)
                .startingNflWeek(1)
                .endingNflWeek(18)
                .maxLeagues(50)
                .maxPlayersPerLeague(16)
                .allowLateRegistration(true)
                .autoAdvanceWeeks(false)
                .timezone("America/Los_Angeles")
                .build();

        assertThat(config.getSeason()).isEqualTo(2024);
        assertThat(config.getStartingNflWeek()).isEqualTo(1);
        assertThat(config.getEndingNflWeek()).isEqualTo(18);
        assertThat(config.getMaxLeagues()).isEqualTo(50);
        assertThat(config.getMaxPlayersPerLeague()).isEqualTo(16);
        assertThat(config.getAllowLateRegistration()).isTrue();
        assertThat(config.getAutoAdvanceWeeks()).isFalse();
        assertThat(config.getTimezone()).isEqualTo("America/Los_Angeles");
    }

    @Test
    @DisplayName("should use default values when not specified")
    void shouldUseDefaultValues() {
        WorldConfiguration config = WorldConfiguration.builder()
                .season(2024)
                .startingNflWeek(1)
                .endingNflWeek(18)
                .build();

        assertThat(config.getMaxLeagues()).isEqualTo(100);
        assertThat(config.getMaxPlayersPerLeague()).isEqualTo(20);
        assertThat(config.getAllowLateRegistration()).isFalse();
        assertThat(config.getAutoAdvanceWeeks()).isTrue();
        assertThat(config.getTimezone()).isEqualTo("America/New_York");
    }

    @Test
    @DisplayName("should create default configuration for season")
    void shouldCreateDefaultConfigurationForSeason() {
        WorldConfiguration config = WorldConfiguration.defaultForSeason(2024);

        assertThat(config.getSeason()).isEqualTo(2024);
        assertThat(config.getStartingNflWeek()).isEqualTo(1);
        assertThat(config.getEndingNflWeek()).isEqualTo(18);
    }

    @Test
    @DisplayName("should create playoffs configuration for season")
    void shouldCreatePlayoffsConfigurationForSeason() {
        WorldConfiguration config = WorldConfiguration.playoffsForSeason(2024);

        assertThat(config.getSeason()).isEqualTo(2024);
        assertThat(config.getStartingNflWeek()).isEqualTo(19);
        assertThat(config.getEndingNflWeek()).isEqualTo(22);
    }

    @Test
    @DisplayName("should calculate number of weeks correctly")
    void shouldCalculateNumberOfWeeksCorrectly() {
        WorldConfiguration config = WorldConfiguration.builder()
                .season(2024)
                .startingNflWeek(5)
                .endingNflWeek(12)
                .build();

        assertThat(config.getNumberOfWeeks()).isEqualTo(8);
    }

    @Test
    @DisplayName("should check if week is in range")
    void shouldCheckIfWeekIsInRange() {
        WorldConfiguration config = WorldConfiguration.builder()
                .season(2024)
                .startingNflWeek(5)
                .endingNflWeek(12)
                .build();

        assertThat(config.isWeekInRange(5)).isTrue();
        assertThat(config.isWeekInRange(8)).isTrue();
        assertThat(config.isWeekInRange(12)).isTrue();

        assertThat(config.isWeekInRange(4)).isFalse();
        assertThat(config.isWeekInRange(13)).isFalse();
    }

    @Test
    @DisplayName("should throw for invalid season")
    void shouldThrowForInvalidSeason() {
        assertThatThrownBy(() -> WorldConfiguration.builder()
                .season(2019)
                .startingNflWeek(1)
                .endingNflWeek(18)
                .build())
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Season must be between 2020 and 2100");
    }

    @Test
    @DisplayName("should throw for invalid starting week")
    void shouldThrowForInvalidStartingWeek() {
        assertThatThrownBy(() -> WorldConfiguration.builder()
                .season(2024)
                .startingNflWeek(0)
                .endingNflWeek(18)
                .build())
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Starting NFL week must be between 1 and 22");

        assertThatThrownBy(() -> WorldConfiguration.builder()
                .season(2024)
                .startingNflWeek(23)
                .endingNflWeek(18)
                .build())
                .isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    @DisplayName("should throw when starting week after ending week")
    void shouldThrowWhenStartingWeekAfterEndingWeek() {
        assertThatThrownBy(() -> WorldConfiguration.builder()
                .season(2024)
                .startingNflWeek(15)
                .endingNflWeek(10)
                .build())
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Starting NFL week cannot be after ending NFL week");
    }

    @Test
    @DisplayName("should implement equals and hashCode correctly")
    void shouldImplementEqualsAndHashCodeCorrectly() {
        WorldConfiguration config1 = WorldConfiguration.builder()
                .season(2024)
                .startingNflWeek(1)
                .endingNflWeek(18)
                .build();

        WorldConfiguration config2 = WorldConfiguration.builder()
                .season(2024)
                .startingNflWeek(1)
                .endingNflWeek(18)
                .build();

        WorldConfiguration config3 = WorldConfiguration.builder()
                .season(2025)
                .startingNflWeek(1)
                .endingNflWeek(18)
                .build();

        assertThat(config1).isEqualTo(config2);
        assertThat(config1.hashCode()).isEqualTo(config2.hashCode());
        assertThat(config1).isNotEqualTo(config3);
    }
}
