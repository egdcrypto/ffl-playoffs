package com.ffl.playoffs.domain.model.resource;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("ResourceType Enum Tests")
class ResourceTypeTest {

    @Test
    @DisplayName("should have exactly six resource types")
    void shouldHaveExactlySixResourceTypes() {
        assertThat(ResourceType.values()).hasSize(6);
    }

    @Test
    @DisplayName("should have COMPUTE_HOURS resource type")
    void shouldHaveComputeHoursType() {
        assertThat(ResourceType.COMPUTE_HOURS).isNotNull();
        assertThat(ResourceType.COMPUTE_HOURS.getCode()).isEqualTo("compute_hours");
        assertThat(ResourceType.COMPUTE_HOURS.getDisplayName()).isEqualTo("Compute Hours");
        assertThat(ResourceType.COMPUTE_HOURS.getUnit()).isEqualTo("hours");
        assertThat(ResourceType.COMPUTE_HOURS.isConsumable()).isTrue();
    }

    @Test
    @DisplayName("should have STORAGE_GB resource type")
    void shouldHaveStorageGbType() {
        assertThat(ResourceType.STORAGE_GB).isNotNull();
        assertThat(ResourceType.STORAGE_GB.getCode()).isEqualTo("storage_gb");
        assertThat(ResourceType.STORAGE_GB.getDisplayName()).isEqualTo("Storage");
        assertThat(ResourceType.STORAGE_GB.getUnit()).isEqualTo("GB");
        assertThat(ResourceType.STORAGE_GB.isConsumable()).isTrue();
    }

    @Test
    @DisplayName("should have CONCURRENT_USERS as non-consumable")
    void shouldHaveConcurrentUsersAsNonConsumable() {
        assertThat(ResourceType.CONCURRENT_USERS).isNotNull();
        assertThat(ResourceType.CONCURRENT_USERS.isConsumable()).isFalse();
        assertThat(ResourceType.CONCURRENT_USERS.isConcurrentLimit()).isTrue();
    }

    @Test
    @DisplayName("should find resource type by code")
    void shouldFindResourceTypeByCode() {
        assertThat(ResourceType.fromCode("compute_hours")).contains(ResourceType.COMPUTE_HOURS);
        assertThat(ResourceType.fromCode("storage_gb")).contains(ResourceType.STORAGE_GB);
        assertThat(ResourceType.fromCode("bandwidth_gb")).contains(ResourceType.BANDWIDTH_GB);
        assertThat(ResourceType.fromCode("ai_tokens")).contains(ResourceType.AI_TOKENS);
        assertThat(ResourceType.fromCode("concurrent_users")).contains(ResourceType.CONCURRENT_USERS);
        assertThat(ResourceType.fromCode("api_calls")).contains(ResourceType.API_CALLS);
    }

    @Test
    @DisplayName("should return empty for unknown code")
    void shouldReturnEmptyForUnknownCode() {
        assertThat(ResourceType.fromCode("unknown")).isEmpty();
        assertThat(ResourceType.fromCode(null)).isEmpty();
    }
}
