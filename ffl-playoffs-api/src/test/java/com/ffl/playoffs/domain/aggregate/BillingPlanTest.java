package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.BillingCycle;
import com.ffl.playoffs.domain.model.Price;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("BillingPlan Aggregate Tests")
class BillingPlanTest {

    @Nested
    @DisplayName("Construction")
    class Construction {

        @Test
        @DisplayName("should create billing plan with default constructor")
        void shouldCreateBillingPlanWithDefaultConstructor() {
            // When
            BillingPlan plan = new BillingPlan();

            // Then
            assertThat(plan.getId()).isNotNull();
            assertThat(plan.isActive()).isTrue();
            assertThat(plan.isFeatured()).isFalse();
            assertThat(plan.getCreatedAt()).isNotNull();
            assertThat(plan.getUpdatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should create billing plan with required fields")
        void shouldCreateBillingPlanWithRequiredFields() {
            // Given
            Price price = Price.usd(9.99);
            BillingCycle cycle = BillingCycle.MONTHLY;

            // When
            BillingPlan plan = new BillingPlan("Basic Plan", price, cycle);

            // Then
            assertThat(plan.getName()).isEqualTo("Basic Plan");
            assertThat(plan.getPrice()).isEqualTo(price);
            assertThat(plan.getBillingCycle()).isEqualTo(cycle);
            assertThat(plan.getMaxLeagues()).isEqualTo(1);
            assertThat(plan.getMaxPlayersPerLeague()).isEqualTo(10);
            assertThat(plan.getAdvancedScoringEnabled()).isFalse();
            assertThat(plan.getCustomBrandingEnabled()).isFalse();
            assertThat(plan.getPrioritySupportEnabled()).isFalse();
        }

        @Test
        @DisplayName("should throw exception when name is null")
        void shouldThrowExceptionWhenNameIsNull() {
            assertThatThrownBy(() -> new BillingPlan(null, Price.usd(9.99), BillingCycle.MONTHLY))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Plan name is required");
        }

        @Test
        @DisplayName("should throw exception when name is blank")
        void shouldThrowExceptionWhenNameIsBlank() {
            assertThatThrownBy(() -> new BillingPlan("  ", Price.usd(9.99), BillingCycle.MONTHLY))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Plan name is required");
        }

        @Test
        @DisplayName("should throw exception when price is null")
        void shouldThrowExceptionWhenPriceIsNull() {
            assertThatThrownBy(() -> new BillingPlan("Basic", null, BillingCycle.MONTHLY))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Price is required");
        }

        @Test
        @DisplayName("should throw exception when billing cycle is null")
        void shouldThrowExceptionWhenBillingCycleIsNull() {
            assertThatThrownBy(() -> new BillingPlan("Basic", Price.usd(9.99), null))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Billing cycle is required");
        }
    }

    @Nested
    @DisplayName("Activation")
    class Activation {

        @Test
        @DisplayName("should activate plan")
        void shouldActivatePlan() {
            BillingPlan plan = new BillingPlan("Basic", Price.usd(9.99), BillingCycle.MONTHLY);
            plan.deactivate();
            assertThat(plan.isActive()).isFalse();

            plan.activate();

            assertThat(plan.isActive()).isTrue();
        }

        @Test
        @DisplayName("should deactivate plan")
        void shouldDeactivatePlan() {
            BillingPlan plan = new BillingPlan("Basic", Price.usd(9.99), BillingCycle.MONTHLY);
            assertThat(plan.isActive()).isTrue();

            plan.deactivate();

            assertThat(plan.isActive()).isFalse();
        }
    }

    @Nested
    @DisplayName("Featured Status")
    class FeaturedStatus {

        @Test
        @DisplayName("should mark as featured")
        void shouldMarkAsFeatured() {
            BillingPlan plan = new BillingPlan("Premium", Price.usd(29.99), BillingCycle.MONTHLY);
            assertThat(plan.isFeatured()).isFalse();

            plan.markAsFeatured();

            assertThat(plan.isFeatured()).isTrue();
        }

        @Test
        @DisplayName("should remove featured status")
        void shouldRemoveFeaturedStatus() {
            BillingPlan plan = new BillingPlan("Premium", Price.usd(29.99), BillingCycle.MONTHLY);
            plan.markAsFeatured();
            assertThat(plan.isFeatured()).isTrue();

            plan.removeFeaturedStatus();

            assertThat(plan.isFeatured()).isFalse();
        }
    }

    @Nested
    @DisplayName("Update Limits")
    class UpdateLimits {

        @Test
        @DisplayName("should update limits")
        void shouldUpdateLimits() {
            BillingPlan plan = new BillingPlan("Basic", Price.usd(9.99), BillingCycle.MONTHLY);

            plan.updateLimits(5, 25);

            assertThat(plan.getMaxLeagues()).isEqualTo(5);
            assertThat(plan.getMaxPlayersPerLeague()).isEqualTo(25);
        }

        @Test
        @DisplayName("should throw exception for max leagues less than 1")
        void shouldThrowExceptionForMaxLeaguesLessThan1() {
            BillingPlan plan = new BillingPlan("Basic", Price.usd(9.99), BillingCycle.MONTHLY);

            assertThatThrownBy(() -> plan.updateLimits(0, 10))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Max leagues must be at least 1");
        }

        @Test
        @DisplayName("should throw exception for max players less than 2")
        void shouldThrowExceptionForMaxPlayersLessThan2() {
            BillingPlan plan = new BillingPlan("Basic", Price.usd(9.99), BillingCycle.MONTHLY);

            assertThatThrownBy(() -> plan.updateLimits(1, 1))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Max players per league must be at least 2");
        }
    }

    @Nested
    @DisplayName("Update Features")
    class UpdateFeatures {

        @Test
        @DisplayName("should update features")
        void shouldUpdateFeatures() {
            BillingPlan plan = new BillingPlan("Premium", Price.usd(29.99), BillingCycle.MONTHLY);

            plan.updateFeatures(true, true, true);

            assertThat(plan.getAdvancedScoringEnabled()).isTrue();
            assertThat(plan.getCustomBrandingEnabled()).isTrue();
            assertThat(plan.getPrioritySupportEnabled()).isTrue();
        }

        @Test
        @DisplayName("should update partial features")
        void shouldUpdatePartialFeatures() {
            BillingPlan plan = new BillingPlan("Basic", Price.usd(9.99), BillingCycle.MONTHLY);

            plan.updateFeatures(true, null, null);

            assertThat(plan.getAdvancedScoringEnabled()).isTrue();
            assertThat(plan.getCustomBrandingEnabled()).isFalse();
            assertThat(plan.getPrioritySupportEnabled()).isFalse();
        }
    }

    @Nested
    @DisplayName("Update Price")
    class UpdatePrice {

        @Test
        @DisplayName("should update price")
        void shouldUpdatePrice() {
            BillingPlan plan = new BillingPlan("Basic", Price.usd(9.99), BillingCycle.MONTHLY);
            Price newPrice = Price.usd(14.99);

            plan.updatePrice(newPrice);

            assertThat(plan.getPrice()).isEqualTo(newPrice);
        }

        @Test
        @DisplayName("should throw exception for null price")
        void shouldThrowExceptionForNullPrice() {
            BillingPlan plan = new BillingPlan("Basic", Price.usd(9.99), BillingCycle.MONTHLY);

            assertThatThrownBy(() -> plan.updatePrice(null))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Price cannot be null");
        }
    }

    @Nested
    @DisplayName("isFree")
    class IsFree {

        @Test
        @DisplayName("should return true for free plan")
        void shouldReturnTrueForFreePlan() {
            BillingPlan plan = new BillingPlan("Free", Price.free(), BillingCycle.ONE_TIME);
            assertThat(plan.isFree()).isTrue();
        }

        @Test
        @DisplayName("should return false for paid plan")
        void shouldReturnFalseForPaidPlan() {
            BillingPlan plan = new BillingPlan("Basic", Price.usd(9.99), BillingCycle.MONTHLY);
            assertThat(plan.isFree()).isFalse();
        }
    }

    @Nested
    @DisplayName("canSubscribe")
    class CanSubscribe {

        @Test
        @DisplayName("should return true for active plan")
        void shouldReturnTrueForActivePlan() {
            BillingPlan plan = new BillingPlan("Basic", Price.usd(9.99), BillingCycle.MONTHLY);
            assertThat(plan.canSubscribe()).isTrue();
        }

        @Test
        @DisplayName("should return false for inactive plan")
        void shouldReturnFalseForInactivePlan() {
            BillingPlan plan = new BillingPlan("Basic", Price.usd(9.99), BillingCycle.MONTHLY);
            plan.deactivate();
            assertThat(plan.canSubscribe()).isFalse();
        }
    }

    @Nested
    @DisplayName("Factory Methods")
    class FactoryMethods {

        @Test
        @DisplayName("should create free tier plan")
        void shouldCreateFreeTierPlan() {
            BillingPlan plan = BillingPlan.freeTier();

            assertThat(plan.getName()).isEqualTo("Free");
            assertThat(plan.isFree()).isTrue();
            assertThat(plan.getBillingCycle()).isEqualTo(BillingCycle.ONE_TIME);
            assertThat(plan.getMaxLeagues()).isEqualTo(1);
            assertThat(plan.getMaxPlayersPerLeague()).isEqualTo(10);
        }

        @Test
        @DisplayName("should create basic monthly plan")
        void shouldCreateBasicMonthlyPlan() {
            BillingPlan plan = BillingPlan.basicMonthly(9.99);

            assertThat(plan.getName()).isEqualTo("Basic");
            assertThat(plan.getPrice().getAmount().doubleValue()).isEqualTo(9.99);
            assertThat(plan.getBillingCycle()).isEqualTo(BillingCycle.MONTHLY);
            assertThat(plan.getMaxLeagues()).isEqualTo(3);
            assertThat(plan.getMaxPlayersPerLeague()).isEqualTo(20);
            assertThat(plan.getAdvancedScoringEnabled()).isTrue();
        }

        @Test
        @DisplayName("should create premium monthly plan")
        void shouldCreatePremiumMonthlyPlan() {
            BillingPlan plan = BillingPlan.premiumMonthly(29.99);

            assertThat(plan.getName()).isEqualTo("Premium");
            assertThat(plan.getPrice().getAmount().doubleValue()).isEqualTo(29.99);
            assertThat(plan.getBillingCycle()).isEqualTo(BillingCycle.MONTHLY);
            assertThat(plan.getMaxLeagues()).isEqualTo(10);
            assertThat(plan.getMaxPlayersPerLeague()).isEqualTo(50);
            assertThat(plan.getAdvancedScoringEnabled()).isTrue();
            assertThat(plan.getCustomBrandingEnabled()).isTrue();
            assertThat(plan.getPrioritySupportEnabled()).isTrue();
            assertThat(plan.isFeatured()).isTrue();
        }
    }
}
