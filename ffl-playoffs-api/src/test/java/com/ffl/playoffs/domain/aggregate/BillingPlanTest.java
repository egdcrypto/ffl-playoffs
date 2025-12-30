package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.BillingCycle;
import com.ffl.playoffs.domain.model.Price;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("BillingPlan Aggregate Tests")
class BillingPlanTest {

    @Test
    @DisplayName("should create billing plan with required fields")
    void shouldCreateBillingPlanWithRequiredFields() {
        BillingPlan plan = new BillingPlan("Basic Plan", Price.usd(9.99), BillingCycle.MONTHLY);
        assertThat(plan.getName()).isEqualTo("Basic Plan");
        assertThat(plan.isActive()).isTrue();
    }

    @Test
    @DisplayName("should create free tier plan")
    void shouldCreateFreeTierPlan() {
        BillingPlan plan = BillingPlan.freeTier();
        assertThat(plan.isFree()).isTrue();
        assertThat(plan.getMaxLeagues()).isEqualTo(1);
    }

    @Test
    @DisplayName("should create premium monthly plan")
    void shouldCreatePremiumMonthlyPlan() {
        BillingPlan plan = BillingPlan.premiumMonthly(29.99);
        assertThat(plan.isFeatured()).isTrue();
        assertThat(plan.getMaxLeagues()).isEqualTo(10);
    }

    @Test
    @DisplayName("should deactivate plan")
    void shouldDeactivatePlan() {
        BillingPlan plan = new BillingPlan("Basic", Price.usd(9.99), BillingCycle.MONTHLY);
        plan.deactivate();
        assertThat(plan.isActive()).isFalse();
        assertThat(plan.canSubscribe()).isFalse();
    }
}
