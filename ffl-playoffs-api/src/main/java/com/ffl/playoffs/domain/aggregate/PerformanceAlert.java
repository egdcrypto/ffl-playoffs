package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.performance.*;
import lombok.*;

import java.time.Instant;
import java.util.*;

/**
 * Aggregate root for performance alert configuration and instances.
 * Manages alert lifecycle from configuration through triggering and resolution.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PerformanceAlert {
    private UUID id;
    private String name;
    private String description;
    private AlertThreshold threshold;
    private EscalationPolicy escalationPolicy;
    private Set<NotificationChannel> notificationChannels;
    private boolean enabled;
    private AlertStatus status;
    private Instant triggeredAt;
    private Instant acknowledgedAt;
    private UUID acknowledgedBy;
    private Instant resolvedAt;
    private UUID resolvedBy;
    private String resolutionNote;
    private Instant suppressedUntil;
    private String suppressionReason;
    private Instant createdAt;
    private UUID createdBy;
    private Instant updatedAt;

    /**
     * Create a new alert configuration.
     */
    public static PerformanceAlert create(String name, String description, AlertThreshold threshold,
                                          UUID createdBy) {
        Objects.requireNonNull(name, "Alert name is required");
        Objects.requireNonNull(threshold, "Alert threshold is required");
        Objects.requireNonNull(createdBy, "Creator ID is required");

        PerformanceAlert alert = new PerformanceAlert();
        alert.id = UUID.randomUUID();
        alert.name = name;
        alert.description = description;
        alert.threshold = threshold;
        alert.escalationPolicy = EscalationPolicy.defaultPolicy();
        alert.notificationChannels = new HashSet<>(Set.of(NotificationChannel.EMAIL));
        alert.enabled = true;
        alert.status = AlertStatus.RESOLVED;
        alert.createdAt = Instant.now();
        alert.createdBy = createdBy;
        alert.updatedAt = Instant.now();

        return alert;
    }

    /**
     * Trigger this alert when threshold is breached.
     */
    public void trigger() {
        if (!enabled) {
            throw new IllegalStateException("Cannot trigger a disabled alert");
        }
        if (isSuppressed()) {
            return;
        }
        if (status != AlertStatus.RESOLVED) {
            return; // Already triggered
        }

        this.status = AlertStatus.ACTIVE;
        this.triggeredAt = Instant.now();
        this.acknowledgedAt = null;
        this.acknowledgedBy = null;
        this.resolvedAt = null;
        this.resolvedBy = null;
        this.resolutionNote = null;
        this.updatedAt = Instant.now();
    }

    /**
     * Acknowledge an active alert.
     */
    public void acknowledge(UUID userId) {
        Objects.requireNonNull(userId, "User ID is required");

        if (status != AlertStatus.ACTIVE) {
            throw new IllegalStateException("Can only acknowledge active alerts");
        }

        this.status = AlertStatus.ACKNOWLEDGED;
        this.acknowledgedAt = Instant.now();
        this.acknowledgedBy = userId;
        this.updatedAt = Instant.now();
    }

    /**
     * Resolve an acknowledged alert.
     */
    public void resolve(UUID userId, String note) {
        Objects.requireNonNull(userId, "User ID is required");

        if (status != AlertStatus.ACTIVE && status != AlertStatus.ACKNOWLEDGED) {
            throw new IllegalStateException("Can only resolve active or acknowledged alerts");
        }

        this.status = AlertStatus.RESOLVED;
        this.resolvedAt = Instant.now();
        this.resolvedBy = userId;
        this.resolutionNote = note;
        this.updatedAt = Instant.now();
    }

    /**
     * Suppress this alert for a specified duration.
     */
    public void suppress(Instant until, String reason) {
        Objects.requireNonNull(until, "Suppression end time is required");

        if (until.isBefore(Instant.now())) {
            throw new IllegalArgumentException("Suppression end time must be in the future");
        }

        this.suppressedUntil = until;
        this.suppressionReason = reason;
        if (status == AlertStatus.ACTIVE) {
            this.status = AlertStatus.SUPPRESSED;
        }
        this.updatedAt = Instant.now();
    }

    /**
     * Clear suppression.
     */
    public void clearSuppression() {
        this.suppressedUntil = null;
        this.suppressionReason = null;
        this.updatedAt = Instant.now();
    }

    /**
     * Check if alert is currently suppressed.
     */
    public boolean isSuppressed() {
        return suppressedUntil != null && Instant.now().isBefore(suppressedUntil);
    }

    /**
     * Enable the alert.
     */
    public void enable() {
        this.enabled = true;
        this.updatedAt = Instant.now();
    }

    /**
     * Disable the alert.
     */
    public void disable() {
        this.enabled = false;
        this.updatedAt = Instant.now();
    }

    /**
     * Update the threshold configuration.
     */
    public void updateThreshold(AlertThreshold newThreshold) {
        Objects.requireNonNull(newThreshold, "Threshold is required");
        this.threshold = newThreshold;
        this.updatedAt = Instant.now();
    }

    /**
     * Update the escalation policy.
     */
    public void updateEscalationPolicy(EscalationPolicy policy) {
        Objects.requireNonNull(policy, "Escalation policy is required");
        this.escalationPolicy = policy;
        this.updatedAt = Instant.now();
    }

    /**
     * Add a notification channel.
     */
    public void addNotificationChannel(NotificationChannel channel) {
        Objects.requireNonNull(channel, "Channel is required");
        if (this.notificationChannels == null) {
            this.notificationChannels = new HashSet<>();
        }
        this.notificationChannels.add(channel);
        this.updatedAt = Instant.now();
    }

    /**
     * Remove a notification channel.
     */
    public void removeNotificationChannel(NotificationChannel channel) {
        if (this.notificationChannels != null) {
            this.notificationChannels.remove(channel);
            this.updatedAt = Instant.now();
        }
    }

    /**
     * Check if the threshold is triggered by the given metric value.
     */
    public boolean isThresholdTriggered(MetricValue currentValue, MetricValue previousValue) {
        if (currentValue == null || threshold == null) {
            return false;
        }
        if (currentValue.getType() != threshold.getMetricType()) {
            return false;
        }

        Double prevValue = previousValue != null ? previousValue.getValue() : null;
        return threshold.isTriggered(currentValue.getValue(), prevValue);
    }

    /**
     * Get the current escalation level based on how long the alert has been active.
     */
    public Optional<EscalationPolicy.EscalationLevel> getCurrentEscalationLevel() {
        if (status != AlertStatus.ACTIVE || triggeredAt == null || escalationPolicy == null) {
            return Optional.empty();
        }

        java.time.Duration alertDuration = java.time.Duration.between(triggeredAt, Instant.now());
        return escalationPolicy.getLevelForDuration(alertDuration);
    }
}
