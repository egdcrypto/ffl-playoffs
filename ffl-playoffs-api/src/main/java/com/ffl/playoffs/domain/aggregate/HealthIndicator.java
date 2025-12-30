package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.HealthStatus;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;

/**
 * Health indicator aggregate root
 * Represents a system health indicator for monitoring infrastructure components
 */
public class HealthIndicator {
    private String id;
    private String name;
    private HealthStatus status;
    private String details;
    private String message;
    private LocalDateTime since;
    private int affectedUsers;
    private String actionLink;
    private Map<String, Object> metrics;
    private List<String> dependencies;
    private LocalDateTime lastCheckedAt;

    public HealthIndicator() {
        this.status = HealthStatus.UNKNOWN;
        this.metrics = new HashMap<>();
        this.dependencies = new ArrayList<>();
        this.lastCheckedAt = LocalDateTime.now();
    }

    public HealthIndicator(String id, String name) {
        this();
        this.id = id;
        this.name = name;
    }

    /**
     * Updates the health status
     * @param status new health status
     * @param message status message
     */
    public void updateStatus(HealthStatus status, String message) {
        if (this.status != status) {
            this.since = LocalDateTime.now();
        }
        this.status = status;
        this.message = message;
        this.lastCheckedAt = LocalDateTime.now();
    }

    /**
     * Updates the health status with affected users count
     * @param status new health status
     * @param message status message
     * @param affectedUsers estimated number of affected users
     */
    public void updateStatus(HealthStatus status, String message, int affectedUsers) {
        updateStatus(status, message);
        this.affectedUsers = affectedUsers;
    }

    /**
     * Records a metric value
     * @param metricName name of the metric
     * @param value metric value
     */
    public void recordMetric(String metricName, Object value) {
        this.metrics.put(metricName, value);
        this.lastCheckedAt = LocalDateTime.now();
    }

    /**
     * Adds a dependency to this indicator
     * @param dependencyId the dependency indicator id
     */
    public void addDependency(String dependencyId) {
        if (!this.dependencies.contains(dependencyId)) {
            this.dependencies.add(dependencyId);
        }
    }

    /**
     * Checks if the indicator is healthy
     * @return true if status is HEALTHY
     */
    public boolean isHealthy() {
        return this.status == HealthStatus.HEALTHY;
    }

    /**
     * Checks if the indicator is in a degraded state
     * @return true if status is WARNING or CRITICAL
     */
    public boolean isDegraded() {
        return this.status == HealthStatus.WARNING || this.status == HealthStatus.CRITICAL;
    }

    /**
     * Checks if the indicator is critical
     * @return true if status is CRITICAL
     */
    public boolean isCritical() {
        return this.status == HealthStatus.CRITICAL;
    }

    /**
     * Gets the trend based on status history
     * @return trend string: "improving", "stable", or "degrading"
     */
    public String getTrend() {
        // Simplified trend calculation - in real implementation would analyze history
        if (this.status == HealthStatus.HEALTHY) {
            return "stable";
        } else if (this.status == HealthStatus.WARNING) {
            return "degrading";
        } else if (this.status == HealthStatus.CRITICAL) {
            return "degrading";
        }
        return "unknown";
    }

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public HealthStatus getStatus() {
        return status;
    }

    public void setStatus(HealthStatus status) {
        this.status = status;
    }

    public String getDetails() {
        return details;
    }

    public void setDetails(String details) {
        this.details = details;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public LocalDateTime getSince() {
        return since;
    }

    public void setSince(LocalDateTime since) {
        this.since = since;
    }

    public int getAffectedUsers() {
        return affectedUsers;
    }

    public void setAffectedUsers(int affectedUsers) {
        this.affectedUsers = affectedUsers;
    }

    public String getActionLink() {
        return actionLink;
    }

    public void setActionLink(String actionLink) {
        this.actionLink = actionLink;
    }

    public Map<String, Object> getMetrics() {
        return new HashMap<>(metrics);
    }

    public void setMetrics(Map<String, Object> metrics) {
        this.metrics = metrics != null ? new HashMap<>(metrics) : new HashMap<>();
    }

    public List<String> getDependencies() {
        return new ArrayList<>(dependencies);
    }

    public void setDependencies(List<String> dependencies) {
        this.dependencies = dependencies != null ? new ArrayList<>(dependencies) : new ArrayList<>();
    }

    public LocalDateTime getLastCheckedAt() {
        return lastCheckedAt;
    }

    public void setLastCheckedAt(LocalDateTime lastCheckedAt) {
        this.lastCheckedAt = lastCheckedAt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        HealthIndicator that = (HealthIndicator) o;
        return Objects.equals(id, that.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
