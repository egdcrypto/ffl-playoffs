package com.ffl.playoffs.domain.model.loadtest;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.util.Objects;

/**
 * Immutable value object representing pass/fail thresholds for a metric.
 */
@Getter
@ToString
@EqualsAndHashCode
public final class LoadTestThreshold {
    private final MetricType metricType;
    private final Double warningThreshold;
    private final Double failureThreshold;
    private final ThresholdDirection direction;
    private final boolean required;

    private LoadTestThreshold(MetricType metricType, Double warningThreshold,
                              Double failureThreshold, ThresholdDirection direction, boolean required) {
        this.metricType = Objects.requireNonNull(metricType, "Metric type is required");
        this.warningThreshold = warningThreshold;
        this.failureThreshold = failureThreshold;
        this.direction = direction != null ? direction : ThresholdDirection.MAX;
        this.required = required;

        if (warningThreshold != null && failureThreshold != null) {
            if (this.direction == ThresholdDirection.MAX && warningThreshold > failureThreshold) {
                throw new IllegalArgumentException("Warning threshold must be <= failure threshold for MAX direction");
            }
            if (this.direction == ThresholdDirection.MIN && warningThreshold < failureThreshold) {
                throw new IllegalArgumentException("Warning threshold must be >= failure threshold for MIN direction");
            }
        }
    }

    public static LoadTestThreshold maxThreshold(MetricType type, Double warning, Double failure) {
        return new LoadTestThreshold(type, warning, failure, ThresholdDirection.MAX, true);
    }

    public static LoadTestThreshold minThreshold(MetricType type, Double warning, Double failure) {
        return new LoadTestThreshold(type, warning, failure, ThresholdDirection.MIN, true);
    }

    public static LoadTestThreshold optional(MetricType type, Double warning, Double failure,
                                             ThresholdDirection direction) {
        return new LoadTestThreshold(type, warning, failure, direction, false);
    }

    /**
     * Evaluate a metric value against this threshold.
     */
    public ThresholdResult evaluate(Double value) {
        if (value == null) {
            return required ? ThresholdResult.FAILURE : ThresholdResult.PASS;
        }

        if (direction == ThresholdDirection.MAX) {
            if (failureThreshold != null && value > failureThreshold) {
                return ThresholdResult.FAILURE;
            }
            if (warningThreshold != null && value > warningThreshold) {
                return ThresholdResult.WARNING;
            }
        } else {
            if (failureThreshold != null && value < failureThreshold) {
                return ThresholdResult.FAILURE;
            }
            if (warningThreshold != null && value < warningThreshold) {
                return ThresholdResult.WARNING;
            }
        }
        return ThresholdResult.PASS;
    }

    public enum ThresholdDirection {
        MAX,  // Value should not exceed threshold
        MIN   // Value should not fall below threshold
    }

    public enum ThresholdResult {
        PASS,
        WARNING,
        FAILURE
    }
}
