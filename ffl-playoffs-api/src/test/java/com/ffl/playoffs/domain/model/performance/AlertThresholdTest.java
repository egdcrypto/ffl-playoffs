package com.ffl.playoffs.domain.model.performance;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import java.time.Duration;

import static org.assertj.core.api.Assertions.*;

@DisplayName("AlertThreshold Value Object Tests")
class AlertThresholdTest {

    @Test
    @DisplayName("should create threshold with required fields")
    void shouldCreateThresholdWithRequiredFields() {
        AlertThreshold threshold = AlertThreshold.of(
                MetricType.CPU_UTILIZATION,
                AlertCondition.ABOVE,
                80.0,
                AlertSeverity.WARNING
        );

        assertThat(threshold.getMetricType()).isEqualTo(MetricType.CPU_UTILIZATION);
        assertThat(threshold.getCondition()).isEqualTo(AlertCondition.ABOVE);
        assertThat(threshold.getThreshold()).isEqualTo(80.0);
        assertThat(threshold.getSeverity()).isEqualTo(AlertSeverity.WARNING);
        assertThat(threshold.getDuration()).isEqualTo(Duration.ZERO);
    }

    @Test
    @DisplayName("should create threshold with duration")
    void shouldCreateThresholdWithDuration() {
        AlertThreshold threshold = AlertThreshold.of(
                MetricType.ERROR_RATE,
                AlertCondition.ABOVE,
                5.0,
                Duration.ofMinutes(5),
                AlertSeverity.CRITICAL
        );

        assertThat(threshold.getDuration()).isEqualTo(Duration.ofMinutes(5));
        assertThat(threshold.requiresSustainedCondition()).isTrue();
    }

    @Test
    @DisplayName("should detect triggered above threshold")
    void shouldDetectTriggeredAboveThreshold() {
        AlertThreshold threshold = AlertThreshold.of(
                MetricType.CPU_UTILIZATION,
                AlertCondition.ABOVE,
                80.0,
                AlertSeverity.WARNING
        );

        assertThat(threshold.isTriggered(85.0, null)).isTrue();
        assertThat(threshold.isTriggered(75.0, null)).isFalse();
        assertThat(threshold.isTriggered(80.0, null)).isFalse();
    }

    @Test
    @DisplayName("should detect triggered below threshold")
    void shouldDetectTriggeredBelowThreshold() {
        AlertThreshold threshold = AlertThreshold.of(
                MetricType.AVAILABILITY,
                AlertCondition.BELOW,
                99.0,
                AlertSeverity.CRITICAL
        );

        assertThat(threshold.isTriggered(98.5, null)).isTrue();
        assertThat(threshold.isTriggered(99.5, null)).isFalse();
    }

    @Test
    @DisplayName("should update threshold value immutably")
    void shouldUpdateThresholdValueImmutably() {
        AlertThreshold original = AlertThreshold.of(
                MetricType.CPU_UTILIZATION,
                AlertCondition.ABOVE,
                80.0,
                AlertSeverity.WARNING
        );

        AlertThreshold updated = original.withThreshold(90.0);

        assertThat(updated.getThreshold()).isEqualTo(90.0);
        assertThat(original.getThreshold()).isEqualTo(80.0);
    }

    @Test
    @DisplayName("should update severity immutably")
    void shouldUpdateSeverityImmutably() {
        AlertThreshold original = AlertThreshold.of(
                MetricType.CPU_UTILIZATION,
                AlertCondition.ABOVE,
                80.0,
                AlertSeverity.WARNING
        );

        AlertThreshold updated = original.withSeverity(AlertSeverity.CRITICAL);

        assertThat(updated.getSeverity()).isEqualTo(AlertSeverity.CRITICAL);
        assertThat(original.getSeverity()).isEqualTo(AlertSeverity.WARNING);
    }

    @Test
    @DisplayName("should throw for null metric type")
    void shouldThrowForNullMetricType() {
        assertThatThrownBy(() -> AlertThreshold.of(null, AlertCondition.ABOVE, 80.0, AlertSeverity.WARNING))
                .isInstanceOf(NullPointerException.class);
    }
}
