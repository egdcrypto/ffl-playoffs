package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.SLOTarget;

import java.time.LocalDateTime;
import java.util.Objects;
import java.util.UUID;

/**
 * SLO (Service Level Objective) aggregate root
 * Represents a service level objective with error budget tracking
 */
public class SLO {
    private UUID id;
    private String name;
    private String description;
    private String serviceName;
    private SLOTarget target;
    private double alertOnBurnRate;
    private boolean enabled;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private UUID createdBy;

    // Current state (calculated from metrics)
    private double currentValue;
    private long totalRequests;
    private long errorCount;
    private double burnRate;
    private LocalDateTime lastCalculatedAt;

    public SLO() {
        this.id = UUID.randomUUID();
        this.enabled = true;
        this.alertOnBurnRate = 2.0; // Default: alert at 2x burn rate
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public SLO(String name, String serviceName, SLOTarget target) {
        this();
        this.name = name;
        this.serviceName = serviceName;
        this.target = target;
    }

    /**
     * Updates the current SLO metrics
     * @param totalRequests total requests in the window
     * @param errorCount number of errors
     */
    public void updateMetrics(long totalRequests, long errorCount) {
        this.totalRequests = totalRequests;
        this.errorCount = errorCount;

        if (totalRequests > 0) {
            this.currentValue = ((totalRequests - errorCount) * 100.0) / totalRequests;
            double errorRate = (errorCount * 100.0) / totalRequests;
            this.burnRate = target.calculateBurnRate(errorRate);
        } else {
            this.currentValue = 100.0;
            this.burnRate = 0.0;
        }

        this.lastCalculatedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Gets the remaining error budget
     * @return remaining error budget as number of allowed errors
     */
    public long getRemainingBudget() {
        return target.calculateRemainingBudget(totalRequests, errorCount);
    }

    /**
     * Gets the remaining error budget as percentage
     * @return remaining budget percentage (0-100)
     */
    public double getRemainingBudgetPercent() {
        long totalBudget = target.calculateErrorBudget(totalRequests);
        if (totalBudget == 0) return 100.0;
        return (getRemainingBudget() * 100.0) / totalBudget;
    }

    /**
     * Checks if the SLO is currently being met
     * @return true if current value meets target
     */
    public boolean isMet() {
        return currentValue >= target.getTargetPercent();
    }

    /**
     * Checks if the burn rate exceeds the alert threshold
     * @return true if burn rate is too high
     */
    public boolean isBurnRateExceeded() {
        return burnRate > alertOnBurnRate;
    }

    /**
     * Estimates when error budget will be exhausted at current burn rate
     * @return estimated hours until budget exhaustion, or -1 if not burning
     */
    public double estimatedHoursUntilExhaustion() {
        if (burnRate <= 1.0) {
            return -1; // Not burning budget
        }
        double remainingPercent = getRemainingBudgetPercent();
        double hoursInWindow = target.getWindowDays() * 24.0;
        double consumedPerHour = (100.0 / hoursInWindow) * burnRate;
        return remainingPercent / consumedPerHour;
    }

    /**
     * Enables the SLO
     */
    public void enable() {
        this.enabled = true;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Disables the SLO
     */
    public void disable() {
        this.enabled = false;
        this.updatedAt = LocalDateTime.now();
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public SLOTarget getTarget() {
        return target;
    }

    public void setTarget(SLOTarget target) {
        this.target = target;
    }

    public double getAlertOnBurnRate() {
        return alertOnBurnRate;
    }

    public void setAlertOnBurnRate(double alertOnBurnRate) {
        this.alertOnBurnRate = alertOnBurnRate;
    }

    public boolean isEnabled() {
        return enabled;
    }

    public void setEnabled(boolean enabled) {
        this.enabled = enabled;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public UUID getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(UUID createdBy) {
        this.createdBy = createdBy;
    }

    public double getCurrentValue() {
        return currentValue;
    }

    public void setCurrentValue(double currentValue) {
        this.currentValue = currentValue;
    }

    public long getTotalRequests() {
        return totalRequests;
    }

    public void setTotalRequests(long totalRequests) {
        this.totalRequests = totalRequests;
    }

    public long getErrorCount() {
        return errorCount;
    }

    public void setErrorCount(long errorCount) {
        this.errorCount = errorCount;
    }

    public double getBurnRate() {
        return burnRate;
    }

    public void setBurnRate(double burnRate) {
        this.burnRate = burnRate;
    }

    public LocalDateTime getLastCalculatedAt() {
        return lastCalculatedAt;
    }

    public void setLastCalculatedAt(LocalDateTime lastCalculatedAt) {
        this.lastCalculatedAt = lastCalculatedAt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        SLO slo = (SLO) o;
        return Objects.equals(id, slo.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
