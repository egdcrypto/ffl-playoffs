package com.ffl.playoffs.domain.model;

import java.util.Objects;

/**
 * Value object representing an alert condition
 * Defines the threshold and operator for alert evaluation
 */
public class AlertCondition {
    private final String metric;
    private final String operator;
    private final double threshold;
    private final int durationMinutes;

    public AlertCondition(String metric, String operator, double threshold, int durationMinutes) {
        if (metric == null || metric.isBlank()) {
            throw new IllegalArgumentException("Metric cannot be null or blank");
        }
        if (operator == null || operator.isBlank()) {
            throw new IllegalArgumentException("Operator cannot be null or blank");
        }
        if (durationMinutes < 0) {
            throw new IllegalArgumentException("Duration must be non-negative");
        }
        this.metric = metric;
        this.operator = operator;
        this.threshold = threshold;
        this.durationMinutes = durationMinutes;
    }

    public boolean evaluate(double currentValue) {
        return switch (operator) {
            case ">" -> currentValue > threshold;
            case ">=" -> currentValue >= threshold;
            case "<" -> currentValue < threshold;
            case "<=" -> currentValue <= threshold;
            case "==" -> currentValue == threshold;
            case "!=" -> currentValue != threshold;
            default -> throw new IllegalStateException("Unknown operator: " + operator);
        };
    }

    public String getMetric() {
        return metric;
    }

    public String getOperator() {
        return operator;
    }

    public double getThreshold() {
        return threshold;
    }

    public int getDurationMinutes() {
        return durationMinutes;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AlertCondition that = (AlertCondition) o;
        return Double.compare(that.threshold, threshold) == 0 &&
               durationMinutes == that.durationMinutes &&
               Objects.equals(metric, that.metric) &&
               Objects.equals(operator, that.operator);
    }

    @Override
    public int hashCode() {
        return Objects.hash(metric, operator, threshold, durationMinutes);
    }

    @Override
    public String toString() {
        return metric + " " + operator + " " + threshold + " for " + durationMinutes + "m";
    }
}
