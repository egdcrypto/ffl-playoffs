package com.ffl.playoffs.domain.model.resource;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("ResourceThreshold Value Object Tests")
class ResourceThresholdTest {

    @Test
    @DisplayName("should create threshold with defaults")
    void shouldCreateThresholdWithDefaults() {
        ResourceThreshold threshold = ResourceThreshold.defaultFor(ResourceType.COMPUTE_HOURS);

        assertThat(threshold.getResourceType()).isEqualTo(ResourceType.COMPUTE_HOURS);
        assertThat(threshold.getWarningPercent()).isEqualTo(75.0);
        assertThat(threshold.getCriticalPercent()).isEqualTo(90.0);
    }

    @Test
    @DisplayName("should create threshold with custom values")
    void shouldCreateThresholdWithCustomValues() {
        ResourceThreshold threshold = ResourceThreshold.of(ResourceType.STORAGE_GB, 60.0, 80.0);

        assertThat(threshold.getWarningPercent()).isEqualTo(60.0);
        assertThat(threshold.getCriticalPercent()).isEqualTo(80.0);
    }

    @Test
    @DisplayName("should check normal level")
    void shouldCheckNormalLevel() {
        ResourceThreshold threshold = ResourceThreshold.of(ResourceType.COMPUTE_HOURS, 75.0, 90.0);

        assertThat(threshold.checkLevel(50.0)).isEqualTo(ResourceThreshold.ThresholdLevel.NORMAL);
        assertThat(threshold.checkLevel(74.9)).isEqualTo(ResourceThreshold.ThresholdLevel.NORMAL);
    }

    @Test
    @DisplayName("should check warning level")
    void shouldCheckWarningLevel() {
        ResourceThreshold threshold = ResourceThreshold.of(ResourceType.COMPUTE_HOURS, 75.0, 90.0);

        assertThat(threshold.checkLevel(75.0)).isEqualTo(ResourceThreshold.ThresholdLevel.WARNING);
        assertThat(threshold.checkLevel(85.0)).isEqualTo(ResourceThreshold.ThresholdLevel.WARNING);
        assertThat(threshold.checkLevel(89.9)).isEqualTo(ResourceThreshold.ThresholdLevel.WARNING);
    }

    @Test
    @DisplayName("should check critical level")
    void shouldCheckCriticalLevel() {
        ResourceThreshold threshold = ResourceThreshold.of(ResourceType.COMPUTE_HOURS, 75.0, 90.0);

        assertThat(threshold.checkLevel(90.0)).isEqualTo(ResourceThreshold.ThresholdLevel.CRITICAL);
        assertThat(threshold.checkLevel(100.0)).isEqualTo(ResourceThreshold.ThresholdLevel.CRITICAL);
    }

    @Test
    @DisplayName("should handle null usage percentage")
    void shouldHandleNullUsagePercentage() {
        ResourceThreshold threshold = ResourceThreshold.of(ResourceType.COMPUTE_HOURS, 75.0, 90.0);

        assertThat(threshold.checkLevel(null)).isEqualTo(ResourceThreshold.ThresholdLevel.NORMAL);
    }

    @Test
    @DisplayName("should check isWarning convenience method")
    void shouldCheckIsWarningConvenienceMethod() {
        ResourceThreshold threshold = ResourceThreshold.of(ResourceType.COMPUTE_HOURS, 75.0, 90.0);

        assertThat(threshold.isWarning(50.0)).isFalse();
        assertThat(threshold.isWarning(80.0)).isTrue();
        assertThat(threshold.isWarning(95.0)).isFalse(); // Critical, not warning
    }

    @Test
    @DisplayName("should check isCritical convenience method")
    void shouldCheckIsCriticalConvenienceMethod() {
        ResourceThreshold threshold = ResourceThreshold.of(ResourceType.COMPUTE_HOURS, 75.0, 90.0);

        assertThat(threshold.isCritical(50.0)).isFalse();
        assertThat(threshold.isCritical(80.0)).isFalse();
        assertThat(threshold.isCritical(95.0)).isTrue();
    }

    @Test
    @DisplayName("should throw on invalid warning percent")
    void shouldThrowOnInvalidWarningPercent() {
        assertThatThrownBy(() -> ResourceThreshold.of(ResourceType.COMPUTE_HOURS, -5.0, 90.0))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Warning percent must be between 0 and 100");

        assertThatThrownBy(() -> ResourceThreshold.of(ResourceType.COMPUTE_HOURS, 105.0, 90.0))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Warning percent must be between 0 and 100");
    }

    @Test
    @DisplayName("should throw when warning >= critical")
    void shouldThrowWhenWarningGreaterThanOrEqualCritical() {
        assertThatThrownBy(() -> ResourceThreshold.of(ResourceType.COMPUTE_HOURS, 90.0, 90.0))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Warning percent must be less than critical percent");

        assertThatThrownBy(() -> ResourceThreshold.of(ResourceType.COMPUTE_HOURS, 95.0, 90.0))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Warning percent must be less than critical percent");
    }
}
