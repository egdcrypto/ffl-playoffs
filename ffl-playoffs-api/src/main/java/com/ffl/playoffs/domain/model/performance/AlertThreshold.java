package com.ffl.playoffs.domain.model.performance;

import lombok.EqualsAndHashCode;
import lombok.Getter;
import lombok.ToString;

import java.time.Duration;
import java.util.Objects;

/**
 * Immutable value object representing alert threshold configuration.
 */
@Getter
@ToString
@EqualsAndHashCode
public final class AlertThreshold {
    private final MetricType metricType;
    private final AlertCondition condition;
    private final Double threshold;
    private final Duration duration;
    private final AlertSeverity severity;

    private AlertThreshold(MetricType metricType, AlertCondition condition, Double threshold,
                          Duration duration, AlertSeverity severity) {
        this.metricType = Objects.requireNonNull(metricType, "Metric type is required");
        this.condition = Objects.requireNonNull(condition, "Condition is required");
        this.threshold = Objects.requireNonNull(threshold, "Threshold is required");
        this.duration = duration != null ? duration : Duration.ZERO;
        this.severity = Objects.requireNonNull(severity, "Severity is required");
    }

    public static AlertThreshold of(MetricType metricType, AlertCondition condition,
                                    Double threshold, AlertSeverity severity) {
        return new AlertThreshold(metricType, condition, threshold, Duration.ZERO, severity);
    }

    public static AlertThreshold of(MetricType metricType, AlertCondition condition,
                                    Double threshold, Duration duration, AlertSeverity severity) {
        return new AlertThreshold(metricType, condition, threshold, duration, severity);
    }

    public boolean isTriggered(Double currentValue, Double previousValue) {
        return condition.evaluate(currentValue, threshold, previousValue);
    }

    public boolean requiresSustainedCondition() {
        return duration != null && !duration.isZero();
    }

    public AlertThreshold withSeverity(AlertSeverity newSeverity) {
        return new AlertThreshold(this.metricType, this.condition, this.threshold,
                                  this.duration, newSeverity);
    }

    public AlertThreshold withThreshold(Double newThreshold) {
        return new AlertThreshold(this.metricType, this.condition, newThreshold,
                                  this.duration, this.severity);
    }
}
