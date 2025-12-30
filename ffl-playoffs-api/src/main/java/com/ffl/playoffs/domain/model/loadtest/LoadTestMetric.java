package com.ffl.playoffs.domain.model.loadtest;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.time.Instant;
import java.util.Objects;

/**
 * Immutable value object representing a single metric measurement from a load test.
 */
@Getter
@ToString
@EqualsAndHashCode
public final class LoadTestMetric {
    private final MetricType type;
    private final Double value;
    private final Double minValue;
    private final Double maxValue;
    private final Instant timestamp;
    private final String label;

    private LoadTestMetric(MetricType type, Double value, Double minValue, Double maxValue,
                           Instant timestamp, String label) {
        this.type = Objects.requireNonNull(type, "Metric type is required");
        this.value = Objects.requireNonNull(value, "Value is required");
        this.minValue = minValue;
        this.maxValue = maxValue;
        this.timestamp = timestamp != null ? timestamp : Instant.now();
        this.label = label;
    }

    public static LoadTestMetric of(MetricType type, Double value) {
        return new LoadTestMetric(type, value, null, null, Instant.now(), null);
    }

    public static LoadTestMetric of(MetricType type, Double value, String label) {
        return new LoadTestMetric(type, value, null, null, Instant.now(), label);
    }

    public static LoadTestMetric withRange(MetricType type, Double value, Double min, Double max) {
        return new LoadTestMetric(type, value, min, max, Instant.now(), null);
    }

    public static LoadTestMetric create(MetricType type, Double value, Double minValue,
                                        Double maxValue, Instant timestamp, String label) {
        return new LoadTestMetric(type, value, minValue, maxValue, timestamp, label);
    }

    /**
     * Check if this metric is within acceptable range.
     */
    public boolean isWithinRange(Double lowerBound, Double upperBound) {
        if (lowerBound != null && value < lowerBound) {
            return false;
        }
        if (upperBound != null && value > upperBound) {
            return false;
        }
        return true;
    }

    /**
     * Get the formatted value with unit.
     */
    public String getFormattedValue() {
        return String.format("%.2f %s", value, type.getUnit());
    }
}
