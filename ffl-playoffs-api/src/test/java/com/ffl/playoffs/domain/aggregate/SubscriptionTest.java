package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.BillingCycle;
import com.ffl.playoffs.domain.model.Price;
import com.ffl.playoffs.domain.model.SubscriptionStatus;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("Subscription Aggregate Tests")
class SubscriptionTest {

    private UUID adminId;
    private BillingPlan activePlan;

    @BeforeEach
    void setUp() {
        adminId = UUID.randomUUID();
        activePlan = new BillingPlan("Premium", Price.usd(29.99), BillingCycle.MONTHLY);
    }

    @Test
    @DisplayName("should create subscription with admin and plan")
    void shouldCreateSubscriptionWithAdminAndPlan() {
        Subscription subscription = new Subscription(adminId, activePlan);
        assertThat(subscription.getAdminId()).isEqualTo(adminId);
        assertThat(subscription.getStatus()).isEqualTo(SubscriptionStatus.PENDING);
    }

    @Test
    @DisplayName("should activate pending subscription")
    void shouldActivatePendingSubscription() {
        Subscription subscription = new Subscription(adminId, activePlan);
        subscription.activate();
        assertThat(subscription.getStatus()).isEqualTo(SubscriptionStatus.ACTIVE);
    }

    @Test
    @DisplayName("should cancel active subscription")
    void shouldCancelActiveSubscription() {
        Subscription subscription = new Subscription(adminId, activePlan);
        subscription.activate();
        subscription.cancel();
        assertThat(subscription.getStatus()).isEqualTo(SubscriptionStatus.CANCELLED);
    }

    @Test
    @DisplayName("should renew subscription")
    void shouldRenewSubscription() {
        Subscription subscription = new Subscription(adminId, activePlan);
        subscription.activate();
        subscription.renew();
        assertThat(subscription.getRenewalCount()).isEqualTo(1);
    }
}
