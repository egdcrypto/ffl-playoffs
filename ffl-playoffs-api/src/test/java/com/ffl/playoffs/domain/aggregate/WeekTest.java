package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.WeekStatus;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.time.LocalDateTime;
import java.util.UUID;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

/**
 * Unit tests for Week entity
 */
@DisplayName("Week Entity")
class WeekTest {

    private Week week;
    private UUID leagueId;

    @BeforeEach
    void setUp() {
        leagueId = UUID.randomUUID();
        week = new Week(leagueId, 1, 15);
    }

    @Nested
    @DisplayName("Construction")
    class Construction {

        @Test
        @DisplayName("should create week with default constructor")
        void shouldCreateWeekWithDefaultConstructor() {
            Week w = new Week();

            assertThat(w.getId()).isNotNull();
            assertThat(w.getStatus()).isEqualTo(WeekStatus.UPCOMING);
            assertThat(w.getCreatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should create week with league and week numbers")
        void shouldCreateWeekWithLeagueAndWeekNumbers() {
            assertThat(week.getLeagueId()).isEqualTo(leagueId);
            assertThat(week.getGameWeekNumber()).isEqualTo(1);
            assertThat(week.getNflWeekNumber()).isEqualTo(15);
            assertThat(week.getStatus()).isEqualTo(WeekStatus.UPCOMING);
        }

        @Test
        @DisplayName("should create week with deadline")
        void shouldCreateWeekWithDeadline() {
            LocalDateTime deadline = LocalDateTime.now().plusDays(7);
            Week w = new Week(leagueId, 2, 16, deadline);

            assertThat(w.getPickDeadline()).isEqualTo(deadline);
        }
    }

    @Nested
    @DisplayName("Status Transitions")
    class StatusTransitions {

        @Test
        @DisplayName("should activate UPCOMING week")
        void shouldActivateUpcomingWeek() {
            // Given
            assertThat(week.getStatus()).isEqualTo(WeekStatus.UPCOMING);

            // When
            week.activate();

            // Then
            assertThat(week.getStatus()).isEqualTo(WeekStatus.ACTIVE);
        }

        @Test
        @DisplayName("should not activate non-UPCOMING week")
        void shouldNotActivateNonUpcomingWeek() {
            week.activate(); // Now ACTIVE

            assertThatThrownBy(() -> week.activate())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("UPCOMING");
        }

        @Test
        @DisplayName("should lock ACTIVE week")
        void shouldLockActiveWeek() {
            week.activate();

            week.lock();

            assertThat(week.getStatus()).isEqualTo(WeekStatus.LOCKED);
        }

        @Test
        @DisplayName("should not lock non-ACTIVE week")
        void shouldNotLockNonActiveWeek() {
            // Week is UPCOMING

            assertThatThrownBy(() -> week.lock())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("ACTIVE");
        }

        @Test
        @DisplayName("should complete LOCKED week")
        void shouldCompleteLockedWeek() {
            week.activate();
            week.lock();

            week.complete();

            assertThat(week.getStatus()).isEqualTo(WeekStatus.COMPLETED);
        }

        @Test
        @DisplayName("should not complete non-LOCKED week")
        void shouldNotCompleteNonLockedWeek() {
            week.activate(); // Now ACTIVE

            assertThatThrownBy(() -> week.complete())
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("LOCKED");
        }

        @Test
        @DisplayName("should follow complete lifecycle")
        void shouldFollowCompleteLifecycle() {
            assertThat(week.isUpcoming()).isTrue();

            week.activate();
            assertThat(week.isActive()).isTrue();

            week.lock();
            assertThat(week.isLocked()).isTrue();

            week.complete();
            assertThat(week.isCompleted()).isTrue();
        }
    }

    @Nested
    @DisplayName("Pick Deadline")
    class PickDeadline {

        @Test
        @DisplayName("should set deadline for UPCOMING week")
        void shouldSetDeadlineForUpcomingWeek() {
            LocalDateTime deadline = LocalDateTime.now().plusDays(3);

            week.setPickDeadline(deadline);

            assertThat(week.getPickDeadline()).isEqualTo(deadline);
        }

        @Test
        @DisplayName("should not set deadline for ACTIVE week")
        void shouldNotSetDeadlineForActiveWeek() {
            week.activate();
            LocalDateTime deadline = LocalDateTime.now().plusDays(3);

            assertThatThrownBy(() -> week.setPickDeadline(deadline))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("CANNOT_CHANGE_ACTIVE_WEEK_DEADLINE");
        }

        @Test
        @DisplayName("should not set deadline for LOCKED week")
        void shouldNotSetDeadlineForLockedWeek() {
            week.activate();
            week.lock();
            LocalDateTime deadline = LocalDateTime.now().plusDays(3);

            assertThatThrownBy(() -> week.setPickDeadline(deadline))
                    .isInstanceOf(IllegalStateException.class)
                    .hasMessageContaining("CANNOT_CHANGE_ACTIVE_WEEK_DEADLINE");
        }

        @Test
        @DisplayName("should check if deadline has passed")
        void shouldCheckIfDeadlineHasPassed() {
            week.setPickDeadline(LocalDateTime.now().minusHours(1));

            assertThat(week.hasDeadlinePassed()).isTrue();
        }

        @Test
        @DisplayName("should check if deadline has not passed")
        void shouldCheckIfDeadlineHasNotPassed() {
            week.setPickDeadline(LocalDateTime.now().plusHours(1));

            assertThat(week.hasDeadlinePassed()).isFalse();
        }
    }

    @Nested
    @DisplayName("Selection Acceptance")
    class SelectionAcceptance {

        @Test
        @DisplayName("should accept selections when ACTIVE and before deadline")
        void shouldAcceptSelectionsWhenActiveAndBeforeDeadline() {
            week.setPickDeadline(LocalDateTime.now().plusHours(2));
            week.activate();

            assertThat(week.canAcceptSelections()).isTrue();
        }

        @Test
        @DisplayName("should not accept selections when UPCOMING")
        void shouldNotAcceptSelectionsWhenUpcoming() {
            week.setPickDeadline(LocalDateTime.now().plusHours(2));

            assertThat(week.canAcceptSelections()).isFalse();
        }

        @Test
        @DisplayName("should not accept selections when LOCKED")
        void shouldNotAcceptSelectionsWhenLocked() {
            week.setPickDeadline(LocalDateTime.now().plusHours(2));
            week.activate();
            week.lock();

            assertThat(week.canAcceptSelections()).isFalse();
        }

        @Test
        @DisplayName("should not accept selections after deadline")
        void shouldNotAcceptSelectionsAfterDeadline() {
            week.setPickDeadline(LocalDateTime.now().minusHours(1));
            week.activate();

            assertThat(week.canAcceptSelections()).isFalse();
        }
    }

    @Nested
    @DisplayName("Game Statistics")
    class GameStatistics {

        @Test
        @DisplayName("should update game stats")
        void shouldUpdateGameStats() {
            week.updateGameStats(16, 8, 4);

            assertThat(week.getTotalNFLGames()).isEqualTo(16);
            assertThat(week.getGamesCompleted()).isEqualTo(8);
            assertThat(week.getGamesInProgress()).isEqualTo(4);
        }

        @Test
        @DisplayName("should check all games completed")
        void shouldCheckAllGamesCompleted() {
            week.updateGameStats(16, 16, 0);

            assertThat(week.areAllGamesCompleted()).isTrue();
        }

        @Test
        @DisplayName("should check games not completed")
        void shouldCheckGamesNotCompleted() {
            week.updateGameStats(16, 12, 2);

            assertThat(week.areAllGamesCompleted()).isFalse();
        }
    }

    @Nested
    @DisplayName("Status Helper Methods")
    class StatusHelperMethods {

        @Test
        @DisplayName("isUpcoming returns true when UPCOMING")
        void isUpcomingReturnsTrue() {
            assertThat(week.isUpcoming()).isTrue();
            assertThat(week.isActive()).isFalse();
            assertThat(week.isLocked()).isFalse();
            assertThat(week.isCompleted()).isFalse();
        }

        @Test
        @DisplayName("isActive returns true when ACTIVE")
        void isActiveReturnsTrue() {
            week.activate();

            assertThat(week.isUpcoming()).isFalse();
            assertThat(week.isActive()).isTrue();
            assertThat(week.isLocked()).isFalse();
            assertThat(week.isCompleted()).isFalse();
        }

        @Test
        @DisplayName("isLocked returns true when LOCKED")
        void isLockedReturnsTrue() {
            week.activate();
            week.lock();

            assertThat(week.isUpcoming()).isFalse();
            assertThat(week.isActive()).isFalse();
            assertThat(week.isLocked()).isTrue();
            assertThat(week.isCompleted()).isFalse();
        }

        @Test
        @DisplayName("isCompleted returns true when COMPLETED")
        void isCompletedReturnsTrue() {
            week.activate();
            week.lock();
            week.complete();

            assertThat(week.isUpcoming()).isFalse();
            assertThat(week.isActive()).isFalse();
            assertThat(week.isLocked()).isFalse();
            assertThat(week.isCompleted()).isTrue();
        }
    }
}
