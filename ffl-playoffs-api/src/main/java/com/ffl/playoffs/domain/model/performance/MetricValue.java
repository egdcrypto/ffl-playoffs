package com.ffl.playoffs.domain.model.performance;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.time.Instant;
import java.util.Objects;

/**
 * Immutable value object representing a metric measurement at a point in time.
 */
@Getter
@ToString
@EqualsAndHashCode
public final class MetricValue {
    private final MetricType type;
    private final Double value;
    private final String unit;
    private final Instant timestamp;
    private final String source;

    private MetricValue(MetricType type, Double value, String unit, Instant timestamp, String source) {
        this.type = Objects.requireNonNull(type, "Metric type is required");
        this.value = Objects.requireNonNull(value, "Value is required");
        this.unit = unit;
        this.timestamp = Objects.requireNonNull(timestamp, "Timestamp is required");
        this.source = source;
    }

    public static MetricValue of(MetricType type, Double value, String unit) {
        return new MetricValue(type, value, unit, Instant.now(), null);
    }

    public static MetricValue of(MetricType type, Double value, String unit, Instant timestamp) {
        return new MetricValue(type, value, unit, timestamp, null);
    }

    public static MetricValue of(MetricType type, Double value, String unit, Instant timestamp, String source) {
        return new MetricValue(type, value, unit, timestamp, source);
    }

    public boolean isAboveThreshold(Double threshold) {
        return value > threshold;
    }

    public boolean isBelowThreshold(Double threshold) {
        return value < threshold;
    }

    public Double percentageChange(MetricValue previous) {
        if (previous == null || previous.value == 0) {
            return null;
        }
        return ((this.value - previous.value) / previous.value) * 100;
    }
}
