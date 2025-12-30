package com.ffl.playoffs.domain.model.performance;

import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.*;

@DisplayName("MetricType Enum Tests")
class MetricTypeTest {

    @Test
    @DisplayName("should have correct code and display name")
    void shouldHaveCorrectCodeAndDisplayName() {
        assertThat(MetricType.CPU_UTILIZATION.getCode()).isEqualTo("cpu_utilization");
        assertThat(MetricType.CPU_UTILIZATION.getDisplayName()).isEqualTo("CPU Utilization");
        assertThat(MetricType.CPU_UTILIZATION.getCategory()).isEqualTo(MetricType.MetricCategory.INFRASTRUCTURE);
    }

    @Test
    @DisplayName("should find metric by code")
    void shouldFindMetricByCode() {
        MetricType type = MetricType.fromCode("error_rate");
        assertThat(type).isEqualTo(MetricType.ERROR_RATE);
        assertThat(type.getCategory()).isEqualTo(MetricType.MetricCategory.ERROR);
    }

    @Test
    @DisplayName("should throw for unknown code")
    void shouldThrowForUnknownCode() {
        assertThatThrownBy(() -> MetricType.fromCode("unknown_metric"))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessageContaining("Unknown metric type code");
    }

    @Test
    @DisplayName("should have latency metrics with correct category")
    void shouldHaveLatencyMetricsWithCorrectCategory() {
        assertThat(MetricType.AVERAGE_RESPONSE_TIME.getCategory())
                .isEqualTo(MetricType.MetricCategory.LATENCY);
        assertThat(MetricType.P95_RESPONSE_TIME.getCategory())
                .isEqualTo(MetricType.MetricCategory.LATENCY);
    }

    @Test
    @DisplayName("should have frontend metrics with correct category")
    void shouldHaveFrontendMetricsWithCorrectCategory() {
        assertThat(MetricType.LCP.getCategory()).isEqualTo(MetricType.MetricCategory.FRONTEND);
        assertThat(MetricType.FID.getCategory()).isEqualTo(MetricType.MetricCategory.FRONTEND);
        assertThat(MetricType.CLS.getCategory()).isEqualTo(MetricType.MetricCategory.FRONTEND);
    }
}
