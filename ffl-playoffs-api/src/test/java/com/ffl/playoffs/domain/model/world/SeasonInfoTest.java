package com.ffl.playoffs.domain.model.world;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;

import static org.assertj.core.api.Assertions.*;

@DisplayName("SeasonInfo Value Object Tests")
class SeasonInfoTest {

    @Test
    @DisplayName("should create season info with builder")
    void shouldCreateSeasonInfoWithBuilder() {
        LocalDateTime startDate = LocalDateTime.of(2024, 9, 5, 20, 0);
        LocalDateTime endDate = LocalDateTime.of(2025, 1, 12, 18, 0);

        SeasonInfo seasonInfo = SeasonInfo.builder()
                .season(2024)
                .currentWeek(5)
                .totalWeeks(18)
                .seasonStartDate(startDate)
                .seasonEndDate(endDate)
                .build();

        assertThat(seasonInfo.getSeason()).isEqualTo(2024);
        assertThat(seasonInfo.getCurrentWeek()).isEqualTo(5);
        assertThat(seasonInfo.getTotalWeeks()).isEqualTo(18);
        assertThat(seasonInfo.getSeasonStartDate()).isEqualTo(startDate);
        assertThat(seasonInfo.getSeasonEndDate()).isEqualTo(endDate);
    }

    @Test
    @DisplayName("should create season info from configuration")
    void shouldCreateSeasonInfoFromConfiguration() {
        WorldConfiguration config = WorldConfiguration.builder()
                .season(2024)
                .startingNflWeek(5)
                .endingNflWeek(15)
                .build();

        SeasonInfo seasonInfo = SeasonInfo.fromConfiguration(config);

        assertThat(seasonInfo.getSeason()).isEqualTo(2024);
        assertThat(seasonInfo.getCurrentWeek()).isEqualTo(5);
        assertThat(seasonInfo.getTotalWeeks()).isEqualTo(11);
    }

    @Test
    @DisplayName("should advance week correctly")
    void shouldAdvanceWeekCorrectly() {
        SeasonInfo seasonInfo = SeasonInfo.builder()
                .season(2024)
                .currentWeek(5)
                .totalWeeks(18)
                .build();

        SeasonInfo advanced = seasonInfo.advanceWeek();

        assertThat(advanced.getCurrentWeek()).isEqualTo(6);
        assertThat(advanced.getSeason()).isEqualTo(2024);
        assertThat(advanced.getTotalWeeks()).isEqualTo(18);
    }

    @Test
    @DisplayName("should throw when advancing past last week")
    void shouldThrowWhenAdvancingPastLastWeek() {
        SeasonInfo seasonInfo = SeasonInfo.builder()
                .season(2024)
                .currentWeek(18)
                .totalWeeks(18)
                .build();

        assertThatThrownBy(seasonInfo::advanceWeek)
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("Cannot advance past the last week");
    }

    @Test
    @DisplayName("should update week dates")
    void shouldUpdateWeekDates() {
        SeasonInfo seasonInfo = SeasonInfo.builder()
                .season(2024)
                .currentWeek(5)
                .totalWeeks(18)
                .build();

        LocalDateTime startDate = LocalDateTime.of(2024, 10, 10, 20, 0);
        LocalDateTime endDate = LocalDateTime.of(2024, 10, 14, 23, 0);

        SeasonInfo updated = seasonInfo.withWeekDates(startDate, endDate);

        assertThat(updated.getCurrentWeekStartDate()).isEqualTo(startDate);
        assertThat(updated.getCurrentWeekEndDate()).isEqualTo(endDate);
        assertThat(updated.getCurrentWeek()).isEqualTo(5);
    }

    @Test
    @DisplayName("should detect last week correctly")
    void shouldDetectLastWeekCorrectly() {
        SeasonInfo midSeason = SeasonInfo.builder()
                .season(2024)
                .currentWeek(10)
                .totalWeeks(18)
                .build();

        SeasonInfo lastWeek = SeasonInfo.builder()
                .season(2024)
                .currentWeek(18)
                .totalWeeks(18)
                .build();

        assertThat(midSeason.isLastWeek()).isFalse();
        assertThat(lastWeek.isLastWeek()).isTrue();
    }

    @Test
    @DisplayName("should detect first week correctly")
    void shouldDetectFirstWeekCorrectly() {
        SeasonInfo firstWeek = SeasonInfo.builder()
                .season(2024)
                .currentWeek(1)
                .totalWeeks(18)
                .build();

        SeasonInfo midSeason = SeasonInfo.builder()
                .season(2024)
                .currentWeek(10)
                .totalWeeks(18)
                .build();

        assertThat(firstWeek.isFirstWeek()).isTrue();
        assertThat(midSeason.isFirstWeek()).isFalse();
    }

    @Test
    @DisplayName("should calculate progress percentage")
    void shouldCalculateProgressPercentage() {
        SeasonInfo seasonInfo = SeasonInfo.builder()
                .season(2024)
                .currentWeek(9)
                .totalWeeks(18)
                .build();

        assertThat(seasonInfo.getProgressPercentage()).isEqualTo(50);
    }

    @Test
    @DisplayName("should calculate weeks remaining")
    void shouldCalculateWeeksRemaining() {
        SeasonInfo seasonInfo = SeasonInfo.builder()
                .season(2024)
                .currentWeek(12)
                .totalWeeks(18)
                .build();

        assertThat(seasonInfo.getWeeksRemaining()).isEqualTo(6);
    }

    @Test
    @DisplayName("should throw for invalid current week")
    void shouldThrowForInvalidCurrentWeek() {
        assertThatThrownBy(() -> SeasonInfo.builder()
                .season(2024)
                .currentWeek(0)
                .totalWeeks(18)
                .build())
                .isInstanceOf(IllegalArgumentException.class);
    }

    @Test
    @DisplayName("should implement equals and hashCode correctly")
    void shouldImplementEqualsAndHashCodeCorrectly() {
        SeasonInfo info1 = SeasonInfo.builder()
                .season(2024)
                .currentWeek(5)
                .totalWeeks(18)
                .build();

        SeasonInfo info2 = SeasonInfo.builder()
                .season(2024)
                .currentWeek(5)
                .totalWeeks(18)
                .build();

        SeasonInfo info3 = SeasonInfo.builder()
                .season(2024)
                .currentWeek(6)
                .totalWeeks(18)
                .build();

        assertThat(info1).isEqualTo(info2);
        assertThat(info1.hashCode()).isEqualTo(info2.hashCode());
        assertThat(info1).isNotEqualTo(info3);
    }
}
