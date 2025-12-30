package com.ffl.playoffs.domain.model;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("SubscriptionStatus Enum Tests")
class SubscriptionStatusTest {

    @Nested
    @DisplayName("Display Name")
    class DisplayNameTests {

        @Test
        @DisplayName("should have correct display names")
        void shouldHaveCorrectDisplayNames() {
            assertThat(SubscriptionStatus.PENDING.getDisplayName()).isEqualTo("Pending");
            assertThat(SubscriptionStatus.ACTIVE.getDisplayName()).isEqualTo("Active");
            assertThat(SubscriptionStatus.PAST_DUE.getDisplayName()).isEqualTo("Past Due");
            assertThat(SubscriptionStatus.SUSPENDED.getDisplayName()).isEqualTo("Suspended");
            assertThat(SubscriptionStatus.CANCELLED.getDisplayName()).isEqualTo("Cancelled");
            assertThat(SubscriptionStatus.EXPIRED.getDisplayName()).isEqualTo("Expired");
        }
    }

    @Nested
    @DisplayName("isActive")
    class IsActive {

        @Test
        @DisplayName("ACTIVE should be active")
        void activeShouldBeActive() {
            assertThat(SubscriptionStatus.ACTIVE.isActive()).isTrue();
        }

        @Test
        @DisplayName("Other statuses should not be active")
        void otherStatusesShouldNotBeActive() {
            assertThat(SubscriptionStatus.PENDING.isActive()).isFalse();
            assertThat(SubscriptionStatus.PAST_DUE.isActive()).isFalse();
            assertThat(SubscriptionStatus.SUSPENDED.isActive()).isFalse();
            assertThat(SubscriptionStatus.CANCELLED.isActive()).isFalse();
            assertThat(SubscriptionStatus.EXPIRED.isActive()).isFalse();
        }
    }

    @Nested
    @DisplayName("canRenew")
    class CanRenew {

        @Test
        @DisplayName("ACTIVE can be renewed")
        void activeCanBeRenewed() {
            assertThat(SubscriptionStatus.ACTIVE.canRenew()).isTrue();
        }

        @Test
        @DisplayName("PAST_DUE can be renewed")
        void pastDueCanBeRenewed() {
            assertThat(SubscriptionStatus.PAST_DUE.canRenew()).isTrue();
        }

        @Test
        @DisplayName("EXPIRED can be renewed")
        void expiredCanBeRenewed() {
            assertThat(SubscriptionStatus.EXPIRED.canRenew()).isTrue();
        }

        @Test
        @DisplayName("PENDING cannot be renewed")
        void pendingCannotBeRenewed() {
            assertThat(SubscriptionStatus.PENDING.canRenew()).isFalse();
        }

        @Test
        @DisplayName("SUSPENDED cannot be renewed")
        void suspendedCannotBeRenewed() {
            assertThat(SubscriptionStatus.SUSPENDED.canRenew()).isFalse();
        }

        @Test
        @DisplayName("CANCELLED cannot be renewed")
        void cancelledCannotBeRenewed() {
            assertThat(SubscriptionStatus.CANCELLED.canRenew()).isFalse();
        }
    }

    @Nested
    @DisplayName("canCancel")
    class CanCancel {

        @Test
        @DisplayName("ACTIVE can be cancelled")
        void activeCanBeCancelled() {
            assertThat(SubscriptionStatus.ACTIVE.canCancel()).isTrue();
        }

        @Test
        @DisplayName("PAST_DUE can be cancelled")
        void pastDueCanBeCancelled() {
            assertThat(SubscriptionStatus.PAST_DUE.canCancel()).isTrue();
        }

        @Test
        @DisplayName("PENDING can be cancelled")
        void pendingCanBeCancelled() {
            assertThat(SubscriptionStatus.PENDING.canCancel()).isTrue();
        }

        @Test
        @DisplayName("SUSPENDED cannot be cancelled")
        void suspendedCannotBeCancelled() {
            assertThat(SubscriptionStatus.SUSPENDED.canCancel()).isFalse();
        }

        @Test
        @DisplayName("CANCELLED cannot be cancelled again")
        void cancelledCannotBeCancelledAgain() {
            assertThat(SubscriptionStatus.CANCELLED.canCancel()).isFalse();
        }

        @Test
        @DisplayName("EXPIRED cannot be cancelled")
        void expiredCannotBeCancelled() {
            assertThat(SubscriptionStatus.EXPIRED.canCancel()).isFalse();
        }
    }
}
