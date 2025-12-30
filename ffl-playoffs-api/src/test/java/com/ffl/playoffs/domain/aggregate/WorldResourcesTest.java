package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.resource.*;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.UUID;

import static org.assertj.core.api.Assertions.*;

@DisplayName("WorldResources Aggregate Tests")
class WorldResourcesTest {

    private UUID worldId;
    private UUID ownerId;
    private WorldResources resources;

    @BeforeEach
    void setUp() {
        worldId = UUID.randomUUID();
        ownerId = UUID.randomUUID();
        resources = WorldResources.create(worldId, ownerId, "Test World");
    }

    @Nested
    @DisplayName("Creation Tests")
    class CreationTests {

        @Test
        @DisplayName("should create world resources with required fields")
        void shouldCreateWithRequiredFields() {
            assertThat(resources.getId()).isNotNull();
            assertThat(resources.getWorldId()).isEqualTo(worldId);
            assertThat(resources.getOwnerId()).isEqualTo(ownerId);
            assertThat(resources.getWorldName()).isEqualTo("Test World");
            assertThat(resources.getPriority()).isEqualTo(ResourcePriority.NORMAL);
            assertThat(resources.getCreatedAt()).isNotNull();
            assertThat(resources.getUpdatedAt()).isNotNull();
        }

        @Test
        @DisplayName("should create with default configurations")
        void shouldCreateWithDefaultConfigurations() {
            assertThat(resources.isAutoScalingEnabled()).isFalse();
            assertThat(resources.isSharingEnabled()).isFalse();
            assertThat(resources.getOverLimitConfig()).isNotNull();
            assertThat(resources.getOverLimitConfig().getBehavior()).isEqualTo(OverLimitBehavior.THROTTLE);
        }

        @Test
        @DisplayName("should throw on null world ID")
        void shouldThrowOnNullWorldId() {
            assertThatThrownBy(() -> WorldResources.create(null, ownerId, "Test"))
                    .isInstanceOf(NullPointerException.class)
                    .hasMessageContaining("World ID is required");
        }

        @Test
        @DisplayName("should throw on null owner ID")
        void shouldThrowOnNullOwnerId() {
            assertThatThrownBy(() -> WorldResources.create(worldId, null, "Test"))
                    .isInstanceOf(NullPointerException.class)
                    .hasMessageContaining("Owner ID is required");
        }
    }

    @Nested
    @DisplayName("Allocation Tests")
    class AllocationTests {

        @Test
        @DisplayName("should set allocation for resource type")
        void shouldSetAllocation() {
            resources.setAllocation(ResourceType.COMPUTE_HOURS, 100.0);

            assertThat(resources.getAllocation(ResourceType.COMPUTE_HOURS)).isPresent();
            assertThat(resources.getAllocation(ResourceType.COMPUTE_HOURS).get().getAllocated()).isEqualTo(100.0);
        }

        @Test
        @DisplayName("should update existing allocation")
        void shouldUpdateExistingAllocation() {
            resources.setAllocation(ResourceType.COMPUTE_HOURS, 100.0);
            resources.setAllocation(ResourceType.COMPUTE_HOURS, 200.0);

            assertThat(resources.getTotalAllocated(ResourceType.COMPUTE_HOURS)).isEqualTo(200.0);
        }

        @Test
        @DisplayName("should record usage")
        void shouldRecordUsage() {
            resources.setAllocation(ResourceType.COMPUTE_HOURS, 100.0);
            resources.recordUsage(ResourceType.COMPUTE_HOURS, 25.0);

            assertThat(resources.getTotalUsed(ResourceType.COMPUTE_HOURS)).isEqualTo(25.0);
        }

        @Test
        @DisplayName("should accumulate usage")
        void shouldAccumulateUsage() {
            resources.setAllocation(ResourceType.COMPUTE_HOURS, 100.0);
            resources.recordUsage(ResourceType.COMPUTE_HOURS, 25.0);
            resources.recordUsage(ResourceType.COMPUTE_HOURS, 15.0);

            assertThat(resources.getTotalUsed(ResourceType.COMPUTE_HOURS)).isEqualTo(40.0);
        }
    }

    @Nested
    @DisplayName("Priority Tests")
    class PriorityTests {

        @Test
        @DisplayName("should set priority")
        void shouldSetPriority() {
            resources.setPriority(ResourcePriority.HIGH);

            assertThat(resources.getPriority()).isEqualTo(ResourcePriority.HIGH);
        }

        @Test
        @DisplayName("should throw on null priority")
        void shouldThrowOnNullPriority() {
            assertThatThrownBy(() -> resources.setPriority(null))
                    .isInstanceOf(NullPointerException.class)
                    .hasMessageContaining("Priority is required");
        }
    }

    @Nested
    @DisplayName("Auto-Scaling Tests")
    class AutoScalingTests {

        @Test
        @DisplayName("should enable auto-scaling")
        void shouldEnableAutoScaling() {
            resources.enableAutoScaling();

            assertThat(resources.isAutoScalingEnabled()).isTrue();
        }

        @Test
        @DisplayName("should disable auto-scaling")
        void shouldDisableAutoScaling() {
            resources.enableAutoScaling();
            resources.disableAutoScaling();

            assertThat(resources.isAutoScalingEnabled()).isFalse();
        }

        @Test
        @DisplayName("should add auto-scaling rule")
        void shouldAddAutoScalingRule() {
            AutoScalingRule rule = AutoScalingRule.create("cpu_usage", 80.0, ScalingAction.SCALE_UP);
            resources.addAutoScalingRule(rule);

            assertThat(resources.getAutoScalingRules()).hasSize(1);
            assertThat(resources.getAutoScalingRules().get(0).getMetricName()).isEqualTo("cpu_usage");
        }

        @Test
        @DisplayName("should remove auto-scaling rule")
        void shouldRemoveAutoScalingRule() {
            AutoScalingRule rule = AutoScalingRule.create("cpu_usage", 80.0, ScalingAction.SCALE_UP);
            resources.addAutoScalingRule(rule);

            boolean removed = resources.removeAutoScalingRule(rule.getId());

            assertThat(removed).isTrue();
            assertThat(resources.getAutoScalingRules()).isEmpty();
        }
    }

    @Nested
    @DisplayName("Sharing Tests")
    class SharingTests {

        @Test
        @DisplayName("should enable sharing")
        void shouldEnableSharing() {
            resources.enableSharing();

            assertThat(resources.isSharingEnabled()).isTrue();
        }

        @Test
        @DisplayName("should disable sharing")
        void shouldDisableSharing() {
            resources.enableSharing();
            resources.disableSharing();

            assertThat(resources.isSharingEnabled()).isFalse();
        }

        @Test
        @DisplayName("should configure sharing")
        void shouldConfigureSharing() {
            ResourceSharingConfig config = ResourceSharingConfig.dynamic(75.0);
            resources.configureSharingConfig(config);

            assertThat(resources.getSharingConfig().getMaxSharePercent()).isEqualTo(75.0);
            assertThat(resources.getSharingConfig().getMode()).isEqualTo(ResourceSharingConfig.SharingMode.DYNAMIC);
        }
    }

    @Nested
    @DisplayName("Threshold Tests")
    class ThresholdTests {

        @Test
        @DisplayName("should set threshold")
        void shouldSetThreshold() {
            resources.setThreshold(ResourceType.COMPUTE_HOURS, 70.0, 85.0);

            assertThat(resources.getThreshold(ResourceType.COMPUTE_HOURS)).isPresent();
            assertThat(resources.getThreshold(ResourceType.COMPUTE_HOURS).get().getWarningPercent()).isEqualTo(70.0);
            assertThat(resources.getThreshold(ResourceType.COMPUTE_HOURS).get().getCriticalPercent()).isEqualTo(85.0);
        }

        @Test
        @DisplayName("should detect resources at warning level")
        void shouldDetectResourcesAtWarningLevel() {
            resources.setAllocation(ResourceType.COMPUTE_HOURS, 100.0);
            resources.recordUsage(ResourceType.COMPUTE_HOURS, 80.0);
            resources.setThreshold(ResourceType.COMPUTE_HOURS, 75.0, 90.0);

            assertThat(resources.getResourcesAtWarningLevel()).contains(ResourceType.COMPUTE_HOURS);
        }

        @Test
        @DisplayName("should detect resources at critical level")
        void shouldDetectResourcesAtCriticalLevel() {
            resources.setAllocation(ResourceType.COMPUTE_HOURS, 100.0);
            resources.recordUsage(ResourceType.COMPUTE_HOURS, 95.0);
            resources.setThreshold(ResourceType.COMPUTE_HOURS, 75.0, 90.0);

            assertThat(resources.getResourcesAtCriticalLevel()).contains(ResourceType.COMPUTE_HOURS);
        }
    }

    @Nested
    @DisplayName("Quota Tests")
    class QuotaTests {

        @Test
        @DisplayName("should set quota")
        void shouldSetQuota() {
            resources.setQuota(ResourceType.API_CALLS, 10000.0);

            assertThat(resources.getQuota(ResourceType.API_CALLS)).isPresent();
            assertThat(resources.getQuota(ResourceType.API_CALLS).get().getLimit()).isEqualTo(10000.0);
        }
    }
}
