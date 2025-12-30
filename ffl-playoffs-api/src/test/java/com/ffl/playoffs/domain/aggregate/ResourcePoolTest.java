package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.resource.ResourceThreshold;
import com.ffl.playoffs.domain.model.resource.ResourceType;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.time.Instant;
import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("ResourcePool Aggregate Tests")
class ResourcePoolTest {

    private UUID ownerId;
    private ResourcePool pool;

    @BeforeEach
    void setUp() {
        ownerId = UUID.randomUUID();
        pool = ResourcePool.create(ownerId, "premium");
    }

    @Nested
    @DisplayName("Creation Tests")
    class CreationTests {

        @Test
        @DisplayName("should create resource pool with required fields")
        void shouldCreateWithRequiredFields() {
            assertThat(pool.getId()).isNotNull();
            assertThat(pool.getOwnerId()).isEqualTo(ownerId);
            assertThat(pool.getSubscriptionTier()).isEqualTo("premium");
            assertThat(pool.getCreatedAt()).isNotNull();
            assertThat(pool.getUpdatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should create with empty maps")
        void shouldCreateWithEmptyMaps() {
            assertThat(pool.getTotalLimits()).isEmpty();
            assertThat(pool.getAllocatedToWorlds()).isEmpty();
            assertThat(pool.getTotalUsed()).isEmpty();
        }

        @Test
        @DisplayName("should throw on null owner ID")
        void shouldThrowOnNullOwnerId() {
            assertThatThrownBy(() -> ResourcePool.create(null, "premium"))
                    .isInstanceOf(NullPointerException.class)
                    .hasMessageContaining("Owner ID is required");
        }
    }

    @Nested
    @DisplayName("Limit Tests")
    class LimitTests {

        @Test
        @DisplayName("should set limit for resource type")
        void shouldSetLimit() {
            pool.setLimit(ResourceType.COMPUTE_HOURS, 1000.0);

            assertThat(pool.getLimit(ResourceType.COMPUTE_HOURS)).isEqualTo(1000.0);
        }

        @Test
        @DisplayName("should return zero for unset limit")
        void shouldReturnZeroForUnsetLimit() {
            assertThat(pool.getLimit(ResourceType.COMPUTE_HOURS)).isEqualTo(0.0);
        }

        @Test
        @DisplayName("should set burst limit")
        void shouldSetBurstLimit() {
            pool.setLimit(ResourceType.COMPUTE_HOURS, 1000.0);
            pool.setBurstLimit(ResourceType.COMPUTE_HOURS, 120.0);

            assertThat(pool.getBurstLimits().get(ResourceType.COMPUTE_HOURS)).isEqualTo(120.0);
        }
    }

    @Nested
    @DisplayName("Allocation Tests")
    class AllocationTests {

        @Test
        @DisplayName("should allocate to world")
        void shouldAllocateToWorld() {
            pool.setLimit(ResourceType.COMPUTE_HOURS, 1000.0);

            boolean result = pool.allocateToWorld(ResourceType.COMPUTE_HOURS, 200.0);

            assertThat(result).isTrue();
            assertThat(pool.getAllocated(ResourceType.COMPUTE_HOURS)).isEqualTo(200.0);
            assertThat(pool.getAvailable(ResourceType.COMPUTE_HOURS)).isEqualTo(800.0);
        }

        @Test
        @DisplayName("should fail allocation when insufficient resources")
        void shouldFailAllocationWhenInsufficient() {
            pool.setLimit(ResourceType.COMPUTE_HOURS, 100.0);

            boolean result = pool.allocateToWorld(ResourceType.COMPUTE_HOURS, 200.0);

            assertThat(result).isFalse();
            assertThat(pool.getAllocated(ResourceType.COMPUTE_HOURS)).isEqualTo(0.0);
        }

        @Test
        @DisplayName("should release allocation from world")
        void shouldReleaseFromWorld() {
            pool.setLimit(ResourceType.COMPUTE_HOURS, 1000.0);
            pool.allocateToWorld(ResourceType.COMPUTE_HOURS, 200.0);

            pool.releaseFromWorld(ResourceType.COMPUTE_HOURS, 100.0);

            assertThat(pool.getAllocated(ResourceType.COMPUTE_HOURS)).isEqualTo(100.0);
            assertThat(pool.getAvailable(ResourceType.COMPUTE_HOURS)).isEqualTo(900.0);
        }

        @Test
        @DisplayName("should check can allocate")
        void shouldCheckCanAllocate() {
            pool.setLimit(ResourceType.COMPUTE_HOURS, 1000.0);
            pool.allocateToWorld(ResourceType.COMPUTE_HOURS, 800.0);

            assertThat(pool.canAllocate(ResourceType.COMPUTE_HOURS, 100.0)).isTrue();
            assertThat(pool.canAllocate(ResourceType.COMPUTE_HOURS, 300.0)).isFalse();
        }
    }

    @Nested
    @DisplayName("Usage Tests")
    class UsageTests {

        @Test
        @DisplayName("should record usage")
        void shouldRecordUsage() {
            pool.setLimit(ResourceType.COMPUTE_HOURS, 1000.0);

            pool.recordUsage(ResourceType.COMPUTE_HOURS, 50.0);

            assertThat(pool.getUsed(ResourceType.COMPUTE_HOURS)).isEqualTo(50.0);
        }

        @Test
        @DisplayName("should accumulate usage")
        void shouldAccumulateUsage() {
            pool.setLimit(ResourceType.COMPUTE_HOURS, 1000.0);

            pool.recordUsage(ResourceType.COMPUTE_HOURS, 50.0);
            pool.recordUsage(ResourceType.COMPUTE_HOURS, 30.0);

            assertThat(pool.getUsed(ResourceType.COMPUTE_HOURS)).isEqualTo(80.0);
        }

        @Test
        @DisplayName("should calculate usage percentage")
        void shouldCalculateUsagePercentage() {
            pool.setLimit(ResourceType.COMPUTE_HOURS, 1000.0);
            pool.recordUsage(ResourceType.COMPUTE_HOURS, 250.0);

            assertThat(pool.getUsagePercentage(ResourceType.COMPUTE_HOURS)).isEqualTo(25.0);
        }

        @Test
        @DisplayName("should check if limit exceeded")
        void shouldCheckIfLimitExceeded() {
            pool.setLimit(ResourceType.COMPUTE_HOURS, 100.0);
            pool.recordUsage(ResourceType.COMPUTE_HOURS, 50.0);

            assertThat(pool.isLimitExceeded(ResourceType.COMPUTE_HOURS)).isFalse();

            pool.recordUsage(ResourceType.COMPUTE_HOURS, 50.0);

            assertThat(pool.isLimitExceeded(ResourceType.COMPUTE_HOURS)).isTrue();
        }

        @Test
        @DisplayName("should check if burst limit exceeded")
        void shouldCheckIfBurstLimitExceeded() {
            pool.setLimit(ResourceType.COMPUTE_HOURS, 100.0);
            pool.setBurstLimit(ResourceType.COMPUTE_HOURS, 120.0);
            pool.recordUsage(ResourceType.COMPUTE_HOURS, 110.0);

            assertThat(pool.isLimitExceeded(ResourceType.COMPUTE_HOURS)).isTrue();
            assertThat(pool.isBurstLimitExceeded(ResourceType.COMPUTE_HOURS)).isFalse();

            pool.recordUsage(ResourceType.COMPUTE_HOURS, 15.0);

            assertThat(pool.isBurstLimitExceeded(ResourceType.COMPUTE_HOURS)).isTrue();
        }
    }

    @Nested
    @DisplayName("Threshold Tests")
    class ThresholdTests {

        @Test
        @DisplayName("should set and check threshold")
        void shouldSetAndCheckThreshold() {
            pool.setLimit(ResourceType.COMPUTE_HOURS, 1000.0);
            pool.setThreshold(ResourceType.COMPUTE_HOURS, 75.0, 90.0);
            pool.recordUsage(ResourceType.COMPUTE_HOURS, 800.0);

            assertThat(pool.checkThresholdLevel(ResourceType.COMPUTE_HOURS))
                    .isEqualTo(ResourceThreshold.ThresholdLevel.WARNING);
        }

        @Test
        @DisplayName("should detect resources at warning level")
        void shouldDetectResourcesAtWarningLevel() {
            pool.setLimit(ResourceType.COMPUTE_HOURS, 100.0);
            pool.setThreshold(ResourceType.COMPUTE_HOURS, 75.0, 90.0);
            pool.recordUsage(ResourceType.COMPUTE_HOURS, 80.0);

            assertThat(pool.getResourcesAtWarningLevel()).contains(ResourceType.COMPUTE_HOURS);
            assertThat(pool.getResourcesAtCriticalLevel()).isEmpty();
        }

        @Test
        @DisplayName("should detect resources at critical level")
        void shouldDetectResourcesAtCriticalLevel() {
            pool.setLimit(ResourceType.COMPUTE_HOURS, 100.0);
            pool.setThreshold(ResourceType.COMPUTE_HOURS, 75.0, 90.0);
            pool.recordUsage(ResourceType.COMPUTE_HOURS, 95.0);

            assertThat(pool.getResourcesAtCriticalLevel()).contains(ResourceType.COMPUTE_HOURS);
            assertThat(pool.getResourcesAtWarningLevel()).isEmpty();
        }
    }

    @Nested
    @DisplayName("Billing Period Tests")
    class BillingPeriodTests {

        @Test
        @DisplayName("should set billing period")
        void shouldSetBillingPeriod() {
            Instant start = Instant.now();
            Instant end = start.plusSeconds(86400 * 30);

            pool.setBillingPeriod(start, end);

            assertThat(pool.getBillingPeriodStart()).isEqualTo(start);
            assertThat(pool.getBillingPeriodEnd()).isEqualTo(end);
        }

        @Test
        @DisplayName("should reset usage for new period")
        void shouldResetUsageForNewPeriod() {
            pool.setLimit(ResourceType.COMPUTE_HOURS, 1000.0);
            pool.recordUsage(ResourceType.COMPUTE_HOURS, 500.0);

            pool.resetUsageForNewPeriod();

            assertThat(pool.getUsed(ResourceType.COMPUTE_HOURS)).isEqualTo(0.0);
        }
    }

    @Nested
    @DisplayName("Budget Tests")
    class BudgetTests {

        @Test
        @DisplayName("should configure budget")
        void shouldConfigureBudget() {
            ResourcePool.BudgetConfig config = ResourcePool.BudgetConfig.create(1000.0);

            pool.configureBudget(config);

            assertThat(pool.getBudgetConfig()).isNotNull();
            assertThat(pool.getBudgetConfig().getMonthlyBudget()).isEqualTo(1000.0);
            assertThat(pool.getBudgetConfig().getAlertAt80Percent()).isEqualTo(800.0);
            assertThat(pool.getBudgetConfig().getAlertAt100Percent()).isEqualTo(1000.0);
        }
    }
}
