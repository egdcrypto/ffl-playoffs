package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.aggregate.Week;
import com.ffl.playoffs.domain.model.WeekStatus;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.List;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * Unit tests for WeekCreationService
 */
@DisplayName("WeekCreationService")
class WeekCreationServiceTest {

    private WeekCreationService service;

    @BeforeEach
    void setUp() {
        service = new WeekCreationService();
    }

    private League createLeague(int startingWeek, int numberOfWeeks) {
        League league = new League();
        league.setId(UUID.randomUUID());
        // Use reflection or direct setters to set week configuration
        try {
            var startingWeekField = League.class.getDeclaredField("startingWeek");
            startingWeekField.setAccessible(true);
            startingWeekField.set(league, startingWeek);

            var numberOfWeeksField = League.class.getDeclaredField("numberOfWeeks");
            numberOfWeeksField.setAccessible(true);
            numberOfWeeksField.set(league, numberOfWeeks);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return league;
    }

    @Nested
    @DisplayName("createWeeksForLeague")
    class CreateWeeksForLeague {

        @Test
        @DisplayName("should create correct number of weeks")
        void shouldCreateCorrectNumberOfWeeks() {
            // Given
            League league = createLeague(15, 4);

            // When
            List<Week> weeks = service.createWeeksForLeague(league);

            // Then
            assertThat(weeks).hasSize(4);
        }

        @Test
        @DisplayName("should map game weeks to NFL weeks correctly for playoffs league")
        void shouldMapGameWeeksToNflWeeksForPlayoffs() {
            // Given - playoffs league starting at week 15 with 4 weeks
            League league = createLeague(15, 4);

            // When
            List<Week> weeks = service.createWeeksForLeague(league);

            // Then
            assertThat(weeks.get(0).getGameWeekNumber()).isEqualTo(1);
            assertThat(weeks.get(0).getNflWeekNumber()).isEqualTo(15);

            assertThat(weeks.get(1).getGameWeekNumber()).isEqualTo(2);
            assertThat(weeks.get(1).getNflWeekNumber()).isEqualTo(16);

            assertThat(weeks.get(2).getGameWeekNumber()).isEqualTo(3);
            assertThat(weeks.get(2).getNflWeekNumber()).isEqualTo(17);

            assertThat(weeks.get(3).getGameWeekNumber()).isEqualTo(4);
            assertThat(weeks.get(3).getNflWeekNumber()).isEqualTo(18);
        }

        @Test
        @DisplayName("should map game weeks to NFL weeks correctly for mid-season league")
        void shouldMapGameWeeksToNflWeeksForMidSeason() {
            // Given - mid-season league starting at week 8 with 6 weeks
            League league = createLeague(8, 6);

            // When
            List<Week> weeks = service.createWeeksForLeague(league);

            // Then
            assertThat(weeks).hasSize(6);
            assertThat(weeks.get(0).getNflWeekNumber()).isEqualTo(8);
            assertThat(weeks.get(5).getNflWeekNumber()).isEqualTo(13);
        }

        @Test
        @DisplayName("should map game weeks correctly for full-season league")
        void shouldMapCorrectlyForFullSeasonLeague() {
            // Given - full season league
            League league = createLeague(1, 17);

            // When
            List<Week> weeks = service.createWeeksForLeague(league);

            // Then
            assertThat(weeks).hasSize(17);
            assertThat(weeks.get(0).getGameWeekNumber()).isEqualTo(1);
            assertThat(weeks.get(0).getNflWeekNumber()).isEqualTo(1);
            assertThat(weeks.get(16).getGameWeekNumber()).isEqualTo(17);
            assertThat(weeks.get(16).getNflWeekNumber()).isEqualTo(17);
        }

        @Test
        @DisplayName("should create single week league")
        void shouldCreateSingleWeekLeague() {
            // Given
            League league = createLeague(10, 1);

            // When
            List<Week> weeks = service.createWeeksForLeague(league);

            // Then
            assertThat(weeks).hasSize(1);
            assertThat(weeks.get(0).getGameWeekNumber()).isEqualTo(1);
            assertThat(weeks.get(0).getNflWeekNumber()).isEqualTo(10);
        }

        @Test
        @DisplayName("should set all weeks to UPCOMING status")
        void shouldSetAllWeeksToUpcoming() {
            // Given
            League league = createLeague(15, 4);

            // When
            List<Week> weeks = service.createWeeksForLeague(league);

            // Then
            assertThat(weeks).allMatch(w -> w.getStatus() == WeekStatus.UPCOMING);
        }

        @Test
        @DisplayName("should set pick deadlines for all weeks")
        void shouldSetPickDeadlinesForAllWeeks() {
            // Given
            League league = createLeague(15, 4);

            // When
            List<Week> weeks = service.createWeeksForLeague(league);

            // Then
            assertThat(weeks).allMatch(w -> w.getPickDeadline() != null);
        }

        @Test
        @DisplayName("should set league ID on all weeks")
        void shouldSetLeagueIdOnAllWeeks() {
            // Given
            League league = createLeague(15, 4);

            // When
            List<Week> weeks = service.createWeeksForLeague(league);

            // Then
            assertThat(weeks).allMatch(w -> w.getLeagueId().equals(league.getId()));
        }
    }

    @Nested
    @DisplayName("getCurrentGameWeek")
    class GetCurrentGameWeek {

        @Test
        @DisplayName("should return null when NFL week is before league start")
        void shouldReturnNullBeforeLeagueStart() {
            // Given
            League league = createLeague(15, 4);

            // When
            Integer gameWeek = service.getCurrentGameWeek(league, 14);

            // Then
            assertThat(gameWeek).isNull();
        }

        @Test
        @DisplayName("should return null when NFL week is after league end")
        void shouldReturnNullAfterLeagueEnd() {
            // Given
            League league = createLeague(15, 4); // ends at week 18

            // When
            Integer gameWeek = service.getCurrentGameWeek(league, 19);

            // Then
            assertThat(gameWeek).isNull();
        }

        @Test
        @DisplayName("should return correct game week for current NFL week")
        void shouldReturnCorrectGameWeek() {
            // Given
            League league = createLeague(15, 4);

            // When/Then
            assertThat(service.getCurrentGameWeek(league, 15)).isEqualTo(1);
            assertThat(service.getCurrentGameWeek(league, 16)).isEqualTo(2);
            assertThat(service.getCurrentGameWeek(league, 17)).isEqualTo(3);
            assertThat(service.getCurrentGameWeek(league, 18)).isEqualTo(4);
        }
    }

    @Nested
    @DisplayName("nflWeekToGameWeek")
    class NflWeekToGameWeek {

        @Test
        @DisplayName("should convert NFL week to game week correctly")
        void shouldConvertNflWeekToGameWeek() {
            // Given
            League league = createLeague(15, 4);

            // When/Then
            assertThat(service.nflWeekToGameWeek(league, 15)).isEqualTo(1);
            assertThat(service.nflWeekToGameWeek(league, 16)).isEqualTo(2);
            assertThat(service.nflWeekToGameWeek(league, 17)).isEqualTo(3);
            assertThat(service.nflWeekToGameWeek(league, 18)).isEqualTo(4);
        }

        @Test
        @DisplayName("should return null for NFL week outside range")
        void shouldReturnNullForOutsideRange() {
            // Given
            League league = createLeague(15, 4);

            // When/Then
            assertThat(service.nflWeekToGameWeek(league, 14)).isNull();
            assertThat(service.nflWeekToGameWeek(league, 19)).isNull();
        }
    }

    @Nested
    @DisplayName("gameWeekToNflWeek")
    class GameWeekToNflWeek {

        @Test
        @DisplayName("should convert game week to NFL week correctly")
        void shouldConvertGameWeekToNflWeek() {
            // Given
            League league = createLeague(15, 4);

            // When/Then
            assertThat(service.gameWeekToNflWeek(league, 1)).isEqualTo(15);
            assertThat(service.gameWeekToNflWeek(league, 2)).isEqualTo(16);
            assertThat(service.gameWeekToNflWeek(league, 3)).isEqualTo(17);
            assertThat(service.gameWeekToNflWeek(league, 4)).isEqualTo(18);
        }

        @Test
        @DisplayName("should convert correctly for mid-season league")
        void shouldConvertCorrectlyForMidSeasonLeague() {
            // Given
            League league = createLeague(8, 6);

            // When/Then
            assertThat(service.gameWeekToNflWeek(league, 1)).isEqualTo(8);
            assertThat(service.gameWeekToNflWeek(league, 6)).isEqualTo(13);
        }
    }

    @Nested
    @DisplayName("isNflWeekInLeagueRange")
    class IsNflWeekInLeagueRange {

        @Test
        @DisplayName("should return true for weeks in range")
        void shouldReturnTrueForWeeksInRange() {
            // Given
            League league = createLeague(15, 4); // weeks 15-18

            // When/Then
            assertThat(service.isNflWeekInLeagueRange(league, 15)).isTrue();
            assertThat(service.isNflWeekInLeagueRange(league, 16)).isTrue();
            assertThat(service.isNflWeekInLeagueRange(league, 17)).isTrue();
            assertThat(service.isNflWeekInLeagueRange(league, 18)).isTrue();
        }

        @Test
        @DisplayName("should return false for weeks outside range")
        void shouldReturnFalseForWeeksOutsideRange() {
            // Given
            League league = createLeague(15, 4); // weeks 15-18

            // When/Then
            assertThat(service.isNflWeekInLeagueRange(league, 14)).isFalse();
            assertThat(service.isNflWeekInLeagueRange(league, 19)).isFalse();
            assertThat(service.isNflWeekInLeagueRange(league, 1)).isFalse();
        }
    }
}
