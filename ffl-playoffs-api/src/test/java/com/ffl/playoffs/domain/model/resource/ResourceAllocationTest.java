package com.ffl.playoffs.domain.model.resource;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("ResourceAllocation Value Object Tests")
class ResourceAllocationTest {

    @Test
    @DisplayName("should create allocation with defaults")
    void shouldCreateAllocationWithDefaults() {
        ResourceAllocation allocation = ResourceAllocation.of(ResourceType.COMPUTE_HOURS, 100.0);

        assertThat(allocation.getResourceType()).isEqualTo(ResourceType.COMPUTE_HOURS);
        assertThat(allocation.getAllocated()).isEqualTo(100.0);
        assertThat(allocation.getReserved()).isEqualTo(0.0);
        assertThat(allocation.getUsed()).isEqualTo(0.0);
    }

    @Test
    @DisplayName("should create allocation with reserved amount")
    void shouldCreateAllocationWithReserved() {
        ResourceAllocation allocation = ResourceAllocation.of(ResourceType.STORAGE_GB, 500.0, 100.0);

        assertThat(allocation.getAllocated()).isEqualTo(500.0);
        assertThat(allocation.getReserved()).isEqualTo(100.0);
        assertThat(allocation.getUsed()).isEqualTo(0.0);
    }

    @Test
    @DisplayName("should calculate available correctly")
    void shouldCalculateAvailableCorrectly() {
        ResourceAllocation allocation = ResourceAllocation.of(ResourceType.COMPUTE_HOURS, 100.0, 20.0, 30.0);

        // Available = allocated - used = 100 - 30 = 70
        assertThat(allocation.getAvailable()).isEqualTo(70.0);
    }

    @Test
    @DisplayName("should calculate usage percentage correctly")
    void shouldCalculateUsagePercentageCorrectly() {
        ResourceAllocation allocation = ResourceAllocation.of(ResourceType.COMPUTE_HOURS, 100.0, 0.0, 75.0);

        assertThat(allocation.getUsagePercentage()).isEqualTo(75.0);
    }

    @Test
    @DisplayName("should handle zero allocated for usage percentage")
    void shouldHandleZeroAllocatedForUsagePercentage() {
        ResourceAllocation allocation = ResourceAllocation.of(ResourceType.COMPUTE_HOURS, 0.0, 0.0, 0.0);

        assertThat(allocation.getUsagePercentage()).isEqualTo(0.0);
    }

    @Test
    @DisplayName("should check if over limit")
    void shouldCheckIfOverLimit() {
        ResourceAllocation under = ResourceAllocation.of(ResourceType.COMPUTE_HOURS, 100.0, 0.0, 50.0);
        ResourceAllocation atLimit = ResourceAllocation.of(ResourceType.COMPUTE_HOURS, 100.0, 0.0, 100.0);
        ResourceAllocation over = ResourceAllocation.of(ResourceType.COMPUTE_HOURS, 100.0, 0.0, 150.0);

        assertThat(under.isOverLimit()).isFalse();
        assertThat(atLimit.isOverLimit()).isFalse();
        assertThat(over.isOverLimit()).isTrue();
    }

    @Test
    @DisplayName("should add usage immutably")
    void shouldAddUsageImmutably() {
        ResourceAllocation original = ResourceAllocation.of(ResourceType.COMPUTE_HOURS, 100.0, 0.0, 20.0);
        ResourceAllocation updated = original.addUsage(30.0);

        assertThat(original.getUsed()).isEqualTo(20.0);
        assertThat(updated.getUsed()).isEqualTo(50.0);
    }

    @Test
    @DisplayName("should update allocated immutably")
    void shouldUpdateAllocatedImmutably() {
        ResourceAllocation original = ResourceAllocation.of(ResourceType.COMPUTE_HOURS, 100.0);
        ResourceAllocation updated = original.withAllocated(200.0);

        assertThat(original.getAllocated()).isEqualTo(100.0);
        assertThat(updated.getAllocated()).isEqualTo(200.0);
    }

    @Test
    @DisplayName("should throw on null resource type")
    void shouldThrowOnNullResourceType() {
        assertThatThrownBy(() -> ResourceAllocation.of(null, 100.0))
                .isInstanceOf(NullPointerException.class)
                .hasMessageContaining("Resource type is required");
    }
}
