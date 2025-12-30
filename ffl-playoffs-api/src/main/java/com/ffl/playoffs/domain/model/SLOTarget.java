package com.ffl.playoffs.domain.model;

import java.util.Objects;

/**
 * Value object representing a Service Level Objective target
 * Defines the target percentage and rolling window
 */
public class SLOTarget {
    private final double targetPercent;
    private final int windowDays;
    private final String indicator;

    public SLOTarget(double targetPercent, int windowDays, String indicator) {
        if (targetPercent < 0 || targetPercent > 100) {
            throw new IllegalArgumentException("Target percent must be between 0 and 100");
        }
        if (windowDays <= 0) {
            throw new IllegalArgumentException("Window days must be positive");
        }
        if (indicator == null || indicator.isBlank()) {
            throw new IllegalArgumentException("Indicator cannot be null or blank");
        }
        this.targetPercent = targetPercent;
        this.windowDays = windowDays;
        this.indicator = indicator;
    }

    /**
     * Calculates the error budget based on total requests
     * @param totalRequests total number of requests in the window
     * @return allowed number of errors
     */
    public long calculateErrorBudget(long totalRequests) {
        double errorRate = (100 - targetPercent) / 100.0;
        return Math.round(totalRequests * errorRate);
    }

    /**
     * Calculates remaining error budget
     * @param totalRequests total requests in window
     * @param currentErrors current error count
     * @return remaining error budget
     */
    public long calculateRemainingBudget(long totalRequests, long currentErrors) {
        long totalBudget = calculateErrorBudget(totalRequests);
        return Math.max(0, totalBudget - currentErrors);
    }

    /**
     * Calculates burn rate
     * @param currentErrorRate current error rate as percentage
     * @return burn rate (1.0 = sustainable, >1.0 = burning faster than allowed)
     */
    public double calculateBurnRate(double currentErrorRate) {
        double allowedErrorRate = 100 - targetPercent;
        if (allowedErrorRate == 0) return currentErrorRate > 0 ? Double.POSITIVE_INFINITY : 0;
        return currentErrorRate / allowedErrorRate;
    }

    public double getTargetPercent() {
        return targetPercent;
    }

    public int getWindowDays() {
        return windowDays;
    }

    public String getIndicator() {
        return indicator;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SLOTarget sloTarget = (SLOTarget) o;
        return Double.compare(sloTarget.targetPercent, targetPercent) == 0 &&
               windowDays == sloTarget.windowDays &&
               Objects.equals(indicator, sloTarget.indicator);
    }

    @Override
    public int hashCode() {
        return Objects.hash(targetPercent, windowDays, indicator);
    }

    @Override
    public String toString() {
        return targetPercent + "% over " + windowDays + " days (" + indicator + ")";
    }
}
