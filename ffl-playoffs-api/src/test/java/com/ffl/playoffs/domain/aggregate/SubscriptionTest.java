package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.BillingCycle;
import com.ffl.playoffs.domain.model.Price;
import com.ffl.playoffs.domain.model.SubscriptionStatus;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("Subscription Aggregate Tests")
class SubscriptionTest {

    private UUID adminId;
    private BillingPlan activePlan;
    private BillingPlan freePlan;

    @BeforeEach
    void setUp() {
        adminId = UUID.randomUUID();
        activePlan = new BillingPlan("Premium", Price.usd(29.99), BillingCycle.MONTHLY);
        freePlan = new BillingPlan("Free", Price.free(), BillingCycle.ONE_TIME);
    }

    @Nested
    @DisplayName("Construction")
    class Construction {

        @Test
        @DisplayName("should create subscription with default constructor")
        void shouldCreateSubscriptionWithDefaultConstructor() {
            Subscription subscription = new Subscription();

            assertThat(subscription.getId()).isNotNull();
            assertThat(subscription.getStatus()).isEqualTo(SubscriptionStatus.PENDING);
            assertThat(subscription.getRenewalCount()).isEqualTo(0);
            assertThat(subscription.getCreatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should create subscription with admin and plan")
        void shouldCreateSubscriptionWithAdminAndPlan() {
            Subscription subscription = new Subscription(adminId, activePlan);

            assertThat(subscription.getAdminId()).isEqualTo(adminId);
            assertThat(subscription.getBillingPlanId()).isEqualTo(activePlan.getId());
            assertThat(subscription.getBillingPlanName()).isEqualTo("Premium");
            assertThat(subscription.getCurrentPrice().getAmount().doubleValue()).isEqualTo(29.99);
            assertThat(subscription.getBillingCycle()).isEqualTo(BillingCycle.MONTHLY);
            assertThat(subscription.getStatus()).isEqualTo(SubscriptionStatus.PENDING);
        }

        @Test
        @DisplayName("should calculate end date for recurring billing")
        void shouldCalculateEndDateForRecurringBilling() {
            Subscription subscription = new Subscription(adminId, activePlan);

            assertThat(subscription.getEndDate()).isNotNull();
            assertThat(subscription.getNextBillingDate()).isEqualTo(subscription.getEndDate());
        }

        @Test
        @DisplayName("should have null end date for one-time billing")
        void shouldHaveNullEndDateForOneTimeBilling() {
            Subscription subscription = new Subscription(adminId, freePlan);

            assertThat(subscription.getEndDate()).isNull();
            assertThat(subscription.getNextBillingDate()).isNull();
        }

        @Test
        @DisplayName("should throw exception when admin ID is null")
        void shouldThrowExceptionWhenAdminIdIsNull() {
            assertThatThrownBy(() -> new Subscription(null, activePlan))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Admin ID is required");
        }

        @Test
        @DisplayName("should throw exception when billing plan is null")
        void shouldThrowExceptionWhenBillingPlanIsNull() {
            assertThatThrownBy(() -> new Subscription(adminId, null))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Billing plan is required");
        }

        @Test
        @DisplayName("should throw exception when subscribing to inactive plan")
        void shouldThrowExceptionWhenSubscribingToInactivePlan() {
            activePlan.deactivate();

            assertThatThrownBy(() -> new Subscription(adminId, activePlan))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("Cannot subscribe to inactive plan");
        }
    }

    @Nested
    @DisplayName("Activation")
    class Activation {

        @Test
        @DisplayName("should activate pending subscription")
        void shouldActivatePendingSubscription() {
            Subscription subscription = new Subscription(adminId, activePlan);

            subscription.activate();

            assertThat(subscription.getStatus()).isEqualTo(SubscriptionStatus.ACTIVE);
        }

        @Test
        @DisplayName("should throw exception when activating non-pending subscription")
        void shouldThrowExceptionWhenActivatingNonPendingSubscription() {
            Subscription subscription = new Subscription(adminId, activePlan);
            subscription.activate();

            assertThatThrownBy(() -> subscription.activate())
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("Can only activate pending subscriptions");
        }

        @Test
        @DisplayName("should activate free subscription immediately")
        void shouldActivateFreeSubscriptionImmediately() {
            Subscription subscription = new Subscription(adminId, freePlan);

            subscription.activateFree();

            assertThat(subscription.getStatus()).isEqualTo(SubscriptionStatus.ACTIVE);
        }

        @Test
        @DisplayName("should throw exception when using activateFree on paid subscription")
        void shouldThrowExceptionWhenUsingActivateFreeOnPaidSubscription() {
            Subscription subscription = new Subscription(adminId, activePlan);

            assertThatThrownBy(() -> subscription.activateFree())
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("Can only use activateFree for free subscriptions");
        }
    }

    @Nested
    @DisplayName("Status Changes")
    class StatusChanges {

        @Test
        @DisplayName("should mark as past due")
        void shouldMarkAsPastDue() {
            Subscription subscription = new Subscription(adminId, activePlan);
            subscription.activate();

            subscription.markPastDue();

            assertThat(subscription.getStatus()).isEqualTo(SubscriptionStatus.PAST_DUE);
        }

        @Test
        @DisplayName("should suspend active subscription")
        void shouldSuspendActiveSubscription() {
            Subscription subscription = new Subscription(adminId, activePlan);
            subscription.activate();

            subscription.suspend();

            assertThat(subscription.getStatus()).isEqualTo(SubscriptionStatus.SUSPENDED);
        }

        @Test
        @DisplayName("should resume suspended subscription")
        void shouldResumeSuspendedSubscription() {
            Subscription subscription = new Subscription(adminId, activePlan);
            subscription.activate();
            subscription.suspend();

            subscription.resume();

            assertThat(subscription.getStatus()).isEqualTo(SubscriptionStatus.ACTIVE);
        }

        @Test
        @DisplayName("should cancel active subscription")
        void shouldCancelActiveSubscription() {
            Subscription subscription = new Subscription(adminId, activePlan);
            subscription.activate();

            subscription.cancel();

            assertThat(subscription.getStatus()).isEqualTo(SubscriptionStatus.CANCELLED);
            assertThat(subscription.getCancelledAt()).isNotNull();
        }

        @Test
        @DisplayName("should expire subscription")
        void shouldExpireSubscription() {
            Subscription subscription = new Subscription(adminId, activePlan);
            subscription.activate();

            subscription.expire();

            assertThat(subscription.getStatus()).isEqualTo(SubscriptionStatus.EXPIRED);
        }
    }

    @Nested
    @DisplayName("Renewal")
    class Renewal {

        @Test
        @DisplayName("should renew active subscription")
        void shouldRenewActiveSubscription() {
            Subscription subscription = new Subscription(adminId, activePlan);
            subscription.activate();

            subscription.renew();

            assertThat(subscription.getStatus()).isEqualTo(SubscriptionStatus.ACTIVE);
            assertThat(subscription.getRenewalCount()).isEqualTo(1);
        }

        @Test
        @DisplayName("should renew expired subscription")
        void shouldRenewExpiredSubscription() {
            Subscription subscription = new Subscription(adminId, activePlan);
            subscription.activate();
            subscription.expire();

            subscription.renew();

            assertThat(subscription.getStatus()).isEqualTo(SubscriptionStatus.ACTIVE);
        }

        @Test
        @DisplayName("should throw exception when renewing cancelled subscription")
        void shouldThrowExceptionWhenRenewingCancelledSubscription() {
            Subscription subscription = new Subscription(adminId, activePlan);
            subscription.activate();
            subscription.cancel();

            assertThatThrownBy(() -> subscription.renew())
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("Cannot renew subscription");
        }
    }

    @Nested
    @DisplayName("Plan Change")
    class PlanChange {

        @Test
        @DisplayName("should change to new plan")
        void shouldChangeToNewPlan() {
            Subscription subscription = new Subscription(adminId, freePlan);
            subscription.activateFree();

            subscription.changePlan(activePlan);

            assertThat(subscription.getBillingPlanId()).isEqualTo(activePlan.getId());
            assertThat(subscription.getBillingPlanName()).isEqualTo("Premium");
            assertThat(subscription.getCurrentPrice().getAmount().doubleValue()).isEqualTo(29.99);
        }

        @Test
        @DisplayName("should throw exception when changing to inactive plan")
        void shouldThrowExceptionWhenChangingToInactivePlan() {
            Subscription subscription = new Subscription(adminId, freePlan);
            subscription.activateFree();
            activePlan.deactivate();

            assertThatThrownBy(() -> subscription.changePlan(activePlan))
                .isInstanceOf(IllegalStateException.class)
                .hasMessageContaining("Cannot change to inactive plan");
        }
    }

    @Nested
    @DisplayName("Validation")
    class Validation {

        @Test
        @DisplayName("should be valid when active and not expired")
        void shouldBeValidWhenActiveAndNotExpired() {
            Subscription subscription = new Subscription(adminId, activePlan);
            subscription.activate();

            assertThat(subscription.isValid()).isTrue();
        }

        @Test
        @DisplayName("should not be valid when pending")
        void shouldNotBeValidWhenPending() {
            Subscription subscription = new Subscription(adminId, activePlan);

            assertThat(subscription.isValid()).isFalse();
        }

        @Test
        @DisplayName("should identify free subscription")
        void shouldIdentifyFreeSubscription() {
            Subscription subscription = new Subscription(adminId, freePlan);

            assertThat(subscription.isFree()).isTrue();
        }
    }
}
