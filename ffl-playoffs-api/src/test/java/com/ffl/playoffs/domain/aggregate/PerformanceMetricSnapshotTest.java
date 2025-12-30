package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.performance.MetricType;
import com.ffl.playoffs.domain.model.performance.MetricValue;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.*;

@DisplayName("PerformanceMetricSnapshot Aggregate Tests")
class PerformanceMetricSnapshotTest {

    @Nested
    @DisplayName("Creation Tests")
    class CreationTests {

        @Test
        @DisplayName("should create snapshot with source and service")
        void shouldCreateSnapshotWithSourceAndService() {
            PerformanceMetricSnapshot snapshot = PerformanceMetricSnapshot.create(
                    "prometheus",
                    "api-gateway"
            );

            assertThat(snapshot.getId()).isNotNull();
            assertThat(snapshot.getSource()).isEqualTo("prometheus");
            assertThat(snapshot.getService()).isEqualTo("api-gateway");
            assertThat(snapshot.getTimestamp()).isNotNull();
        }

        @Test
        @DisplayName("should create snapshot with metrics")
        void shouldCreateSnapshotWithMetrics() {
            Map<MetricType, Double> metrics = new HashMap<>();
            metrics.put(MetricType.CPU_UTILIZATION, 75.5);
            metrics.put(MetricType.MEMORY_UTILIZATION, 60.2);

            PerformanceMetricSnapshot snapshot = PerformanceMetricSnapshot.create(
                    "prometheus",
                    "api-gateway",
                    metrics
            );

            assertThat(snapshot.getMetric(MetricType.CPU_UTILIZATION)).contains(75.5);
            assertThat(snapshot.getMetric(MetricType.MEMORY_UTILIZATION)).contains(60.2);
        }
    }

    @Nested
    @DisplayName("Metric Recording Tests")
    class MetricRecordingTests {

        @Test
        @DisplayName("should record metric value")
        void shouldRecordMetricValue() {
            PerformanceMetricSnapshot snapshot = PerformanceMetricSnapshot.create(
                    "prometheus",
                    "api-gateway"
            );

            snapshot.recordMetric(MetricType.CPU_UTILIZATION, 85.0);

            assertThat(snapshot.getMetric(MetricType.CPU_UTILIZATION)).contains(85.0);
        }

        @Test
        @DisplayName("should record metric from MetricValue object")
        void shouldRecordMetricFromMetricValueObject() {
            PerformanceMetricSnapshot snapshot = PerformanceMetricSnapshot.create(
                    "prometheus",
                    "api-gateway"
            );
            MetricValue metricValue = MetricValue.of(MetricType.ERROR_RATE, 2.5, "%");

            snapshot.recordMetric(metricValue);

            assertThat(snapshot.getMetric(MetricType.ERROR_RATE)).contains(2.5);
        }

        @Test
        @DisplayName("should update existing metric")
        void shouldUpdateExistingMetric() {
            PerformanceMetricSnapshot snapshot = PerformanceMetricSnapshot.create(
                    "prometheus",
                    "api-gateway"
            );
            snapshot.recordMetric(MetricType.CPU_UTILIZATION, 75.0);

            snapshot.recordMetric(MetricType.CPU_UTILIZATION, 85.0);

            assertThat(snapshot.getMetric(MetricType.CPU_UTILIZATION)).contains(85.0);
        }
    }

    @Nested
    @DisplayName("Tag Management Tests")
    class TagManagementTests {

        @Test
        @DisplayName("should add tag")
        void shouldAddTag() {
            PerformanceMetricSnapshot snapshot = PerformanceMetricSnapshot.create(
                    "prometheus",
                    "api-gateway"
            );

            snapshot.addTag("environment", "production");

            assertThat(snapshot.hasTag("environment", "production")).isTrue();
        }

        @Test
        @DisplayName("should check tag correctly")
        void shouldCheckTagCorrectly() {
            PerformanceMetricSnapshot snapshot = PerformanceMetricSnapshot.create(
                    "prometheus",
                    "api-gateway"
            );
            snapshot.addTag("region", "us-east-1");

            assertThat(snapshot.hasTag("region", "us-east-1")).isTrue();
            assertThat(snapshot.hasTag("region", "eu-west-1")).isFalse();
            assertThat(snapshot.hasTag("zone", "us-east-1")).isFalse();
        }
    }

    @Nested
    @DisplayName("Health Score Tests")
    class HealthScoreTests {

        @Test
        @DisplayName("should calculate perfect health score")
        void shouldCalculatePerfectHealthScore() {
            Map<MetricType, Double> metrics = new HashMap<>();
            metrics.put(MetricType.ERROR_RATE, 0.0);
            metrics.put(MetricType.AVERAGE_RESPONSE_TIME, 100.0);
            metrics.put(MetricType.CPU_UTILIZATION, 50.0);
            metrics.put(MetricType.MEMORY_UTILIZATION, 50.0);

            PerformanceMetricSnapshot snapshot = PerformanceMetricSnapshot.create(
                    "prometheus",
                    "api-gateway",
                    metrics
            );

            assertThat(snapshot.calculateHealthScore()).isEqualTo(100.0);
        }

        @Test
        @DisplayName("should reduce health score for high error rate")
        void shouldReduceHealthScoreForHighErrorRate() {
            Map<MetricType, Double> metrics = new HashMap<>();
            metrics.put(MetricType.ERROR_RATE, 5.0); // 5% error rate

            PerformanceMetricSnapshot snapshot = PerformanceMetricSnapshot.create(
                    "prometheus",
                    "api-gateway",
                    metrics
            );

            // 5% error rate * 5 = 25 point deduction
            assertThat(snapshot.calculateHealthScore()).isEqualTo(75.0);
        }

        @Test
        @DisplayName("should reduce health score for high CPU")
        void shouldReduceHealthScoreForHighCpu() {
            Map<MetricType, Double> metrics = new HashMap<>();
            metrics.put(MetricType.CPU_UTILIZATION, 90.0);

            PerformanceMetricSnapshot snapshot = PerformanceMetricSnapshot.create(
                    "prometheus",
                    "api-gateway",
                    metrics
            );

            // 90 - 80 = 10 point deduction
            assertThat(snapshot.calculateHealthScore()).isEqualTo(90.0);
        }

        @Test
        @DisplayName("should not go below zero")
        void shouldNotGoBelowZero() {
            Map<MetricType, Double> metrics = new HashMap<>();
            metrics.put(MetricType.ERROR_RATE, 50.0);
            metrics.put(MetricType.CPU_UTILIZATION, 100.0);
            metrics.put(MetricType.MEMORY_UTILIZATION, 100.0);

            PerformanceMetricSnapshot snapshot = PerformanceMetricSnapshot.create(
                    "prometheus",
                    "api-gateway",
                    metrics
            );

            assertThat(snapshot.calculateHealthScore()).isGreaterThanOrEqualTo(0.0);
        }
    }

    @Nested
    @DisplayName("Threshold Check Tests")
    class ThresholdCheckTests {

        @Test
        @DisplayName("should detect metrics exceeding thresholds")
        void shouldDetectMetricsExceedingThresholds() {
            Map<MetricType, Double> metrics = new HashMap<>();
            metrics.put(MetricType.CPU_UTILIZATION, 90.0);
            metrics.put(MetricType.MEMORY_UTILIZATION, 75.0);
            metrics.put(MetricType.ERROR_RATE, 5.0);

            PerformanceMetricSnapshot snapshot = PerformanceMetricSnapshot.create(
                    "prometheus",
                    "api-gateway",
                    metrics
            );

            Map<MetricType, Double> thresholds = new HashMap<>();
            thresholds.put(MetricType.CPU_UTILIZATION, 80.0);
            thresholds.put(MetricType.MEMORY_UTILIZATION, 80.0);
            thresholds.put(MetricType.ERROR_RATE, 1.0);

            List<MetricType> exceeding = snapshot.getMetricsExceedingThresholds(thresholds);

            assertThat(exceeding).containsExactlyInAnyOrder(
                    MetricType.CPU_UTILIZATION,
                    MetricType.ERROR_RATE
            );
        }

        @Test
        @DisplayName("should return empty list when no thresholds exceeded")
        void shouldReturnEmptyListWhenNoThresholdsExceeded() {
            Map<MetricType, Double> metrics = new HashMap<>();
            metrics.put(MetricType.CPU_UTILIZATION, 50.0);

            PerformanceMetricSnapshot snapshot = PerformanceMetricSnapshot.create(
                    "prometheus",
                    "api-gateway",
                    metrics
            );

            Map<MetricType, Double> thresholds = new HashMap<>();
            thresholds.put(MetricType.CPU_UTILIZATION, 80.0);

            List<MetricType> exceeding = snapshot.getMetricsExceedingThresholds(thresholds);

            assertThat(exceeding).isEmpty();
        }
    }

    @Test
    @DisplayName("should get MetricValue object")
    void shouldGetMetricValueObject() {
        Map<MetricType, Double> metrics = new HashMap<>();
        metrics.put(MetricType.CPU_UTILIZATION, 75.5);

        PerformanceMetricSnapshot snapshot = PerformanceMetricSnapshot.create(
                "prometheus",
                "api-gateway",
                metrics
        );

        var metricValue = snapshot.getMetricValue(MetricType.CPU_UTILIZATION);

        assertThat(metricValue).isPresent();
        assertThat(metricValue.get().getValue()).isEqualTo(75.5);
        assertThat(metricValue.get().getType()).isEqualTo(MetricType.CPU_UTILIZATION);
    }
}
