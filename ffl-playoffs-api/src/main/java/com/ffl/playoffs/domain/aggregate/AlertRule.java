package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.AlertCondition;
import com.ffl.playoffs.domain.model.AlertSeverity;
import com.ffl.playoffs.domain.model.AlertState;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;

/**
 * Alert rule aggregate root
 * Represents a monitoring alert rule configuration
 */
public class AlertRule {
    private UUID id;
    private String name;
    private String description;
    private AlertCondition condition;
    private AlertSeverity severity;
    private AlertState state;
    private List<String> notificationChannels;
    private Map<String, String> labels;
    private boolean enabled;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime lastTriggeredAt;
    private UUID createdBy;

    public AlertRule() {
        this.id = UUID.randomUUID();
        this.state = AlertState.RESOLVED;
        this.notificationChannels = new ArrayList<>();
        this.labels = new HashMap<>();
        this.enabled = true;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public AlertRule(String name, AlertCondition condition, AlertSeverity severity) {
        this();
        this.name = name;
        this.condition = condition;
        this.severity = severity;
    }

    /**
     * Evaluates the rule against a current metric value
     * @param currentValue the current metric value
     * @return true if the condition is met
     */
    public boolean evaluate(double currentValue) {
        if (!enabled) {
            return false;
        }
        return condition.evaluate(currentValue);
    }

    /**
     * Triggers the alert
     */
    public void trigger() {
        if (this.state != AlertState.FIRING) {
            this.state = AlertState.FIRING;
            this.lastTriggeredAt = LocalDateTime.now();
            this.updatedAt = LocalDateTime.now();
        }
    }

    /**
     * Resolves the alert
     */
    public void resolve() {
        this.state = AlertState.RESOLVED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Acknowledges the alert
     */
    public void acknowledge() {
        if (this.state == AlertState.FIRING) {
            this.state = AlertState.ACKNOWLEDGED;
            this.updatedAt = LocalDateTime.now();
        }
    }

    /**
     * Silences the alert
     */
    public void silence() {
        this.state = AlertState.SILENCED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Enables the alert rule
     */
    public void enable() {
        this.enabled = true;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Disables the alert rule
     */
    public void disable() {
        this.enabled = false;
        this.state = AlertState.RESOLVED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Adds a notification channel
     * @param channel the channel to add
     */
    public void addNotificationChannel(String channel) {
        if (!this.notificationChannels.contains(channel)) {
            this.notificationChannels.add(channel);
            this.updatedAt = LocalDateTime.now();
        }
    }

    /**
     * Removes a notification channel
     * @param channel the channel to remove
     */
    public void removeNotificationChannel(String channel) {
        if (this.notificationChannels.remove(channel)) {
            this.updatedAt = LocalDateTime.now();
        }
    }

    /**
     * Adds a label
     * @param key label key
     * @param value label value
     */
    public void addLabel(String key, String value) {
        this.labels.put(key, value);
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Checks if the alert is currently firing
     * @return true if alert is firing
     */
    public boolean isFiring() {
        return this.state == AlertState.FIRING;
    }

    /**
     * Checks if the alert is critical
     * @return true if severity is critical
     */
    public boolean isCritical() {
        return this.severity == AlertSeverity.CRITICAL;
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

    public AlertCondition getCondition() {
        return condition;
    }

    public void setCondition(AlertCondition condition) {
        this.condition = condition;
    }

    public AlertSeverity getSeverity() {
        return severity;
    }

    public void setSeverity(AlertSeverity severity) {
        this.severity = severity;
    }

    public AlertState getState() {
        return state;
    }

    public void setState(AlertState state) {
        this.state = state;
    }

    public List<String> getNotificationChannels() {
        return new ArrayList<>(notificationChannels);
    }

    public void setNotificationChannels(List<String> notificationChannels) {
        this.notificationChannels = notificationChannels != null ? new ArrayList<>(notificationChannels) : new ArrayList<>();
    }

    public Map<String, String> getLabels() {
        return new HashMap<>(labels);
    }

    public void setLabels(Map<String, String> labels) {
        this.labels = labels != null ? new HashMap<>(labels) : new HashMap<>();
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

    public LocalDateTime getLastTriggeredAt() {
        return lastTriggeredAt;
    }

    public void setLastTriggeredAt(LocalDateTime lastTriggeredAt) {
        this.lastTriggeredAt = lastTriggeredAt;
    }

    public UUID getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(UUID createdBy) {
        this.createdBy = createdBy;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        AlertRule alertRule = (AlertRule) o;
        return Objects.equals(id, alertRule.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
