package com.ffl.playoffs.domain.model.performance;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

/**
 * Conditions that can trigger performance alerts.
 */
@Getter
@RequiredArgsConstructor
public enum AlertCondition {
    ABOVE("above", "Above Threshold"),
    BELOW("below", "Below Threshold"),
    EQUALS("equals", "Equals Value"),
    CHANGE_RATE_INCREASE("change_rate_increase", "Rate of Increase"),
    CHANGE_RATE_DECREASE("change_rate_decrease", "Rate of Decrease"),
    ANOMALY("anomaly", "Anomaly Detected");

    private final String code;
    private final String displayName;

    public boolean evaluate(Double currentValue, Double threshold, Double previousValue) {
        if (currentValue == null || threshold == null) {
            return false;
        }

        return switch (this) {
            case ABOVE -> currentValue > threshold;
            case BELOW -> currentValue < threshold;
            case EQUALS -> Math.abs(currentValue - threshold) < 0.0001;
            case CHANGE_RATE_INCREASE -> {
                if (previousValue == null || previousValue == 0) {
                    yield false;
                }
                double changeRate = ((currentValue - previousValue) / previousValue) * 100;
                yield changeRate > threshold;
            }
            case CHANGE_RATE_DECREASE -> {
                if (previousValue == null || previousValue == 0) {
                    yield false;
                }
                double changeRate = ((previousValue - currentValue) / previousValue) * 100;
                yield changeRate > threshold;
            }
            case ANOMALY -> false; // Requires statistical analysis
        };
    }

    public static AlertCondition fromCode(String code) {
        for (AlertCondition condition : values()) {
            if (condition.code.equals(code)) {
                return condition;
            }
        }
        throw new IllegalArgumentException("Unknown alert condition code: " + code);
    }
}
