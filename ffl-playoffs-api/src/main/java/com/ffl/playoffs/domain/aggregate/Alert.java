package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.AlertSeverity;

import java.time.LocalDateTime;
import java.util.Objects;
import java.util.UUID;

/**
 * Alert aggregate root
 * Represents a platform alert that requires admin attention
 */
public class Alert {
    private UUID id;
    private AlertSeverity severity;
    private String title;
    private String message;
    private String source;
    private LocalDateTime createdAt;
    private boolean acknowledged;
    private UUID acknowledgedBy;
    private LocalDateTime acknowledgedAt;
    private String acknowledgeNote;
    private boolean resolved;
    private UUID resolvedBy;
    private LocalDateTime resolvedAt;
    private String resolution;
    private String rootCause;
    private LocalDateTime snoozedUntil;
    private String snoozeReason;

    public Alert() {
        this.id = UUID.randomUUID();
        this.createdAt = LocalDateTime.now();
        this.acknowledged = false;
        this.resolved = false;
    }

    public Alert(AlertSeverity severity, String title, String message, String source) {
        this();
        this.severity = severity;
        this.title = title;
        this.message = message;
        this.source = source;
    }

    /**
     * Acknowledges the alert
     * @param adminId the admin acknowledging the alert
     * @param note optional note about the acknowledgment
     */
    public void acknowledge(UUID adminId, String note) {
        if (this.resolved) {
            throw new IllegalStateException("Cannot acknowledge a resolved alert");
        }
        this.acknowledged = true;
        this.acknowledgedBy = adminId;
        this.acknowledgedAt = LocalDateTime.now();
        this.acknowledgeNote = note;
    }

    /**
     * Resolves the alert
     * @param adminId the admin resolving the alert
     * @param resolution description of how the alert was resolved
     * @param rootCause root cause analysis
     */
    public void resolve(UUID adminId, String resolution, String rootCause) {
        if (this.resolved) {
            throw new IllegalStateException("Alert is already resolved");
        }
        this.resolved = true;
        this.resolvedBy = adminId;
        this.resolvedAt = LocalDateTime.now();
        this.resolution = resolution;
        this.rootCause = rootCause;
        this.snoozedUntil = null; // Clear snooze on resolution
    }

    /**
     * Snoozes the alert for a specified duration
     * @param durationMinutes minutes to snooze
     * @param reason reason for snoozing
     */
    public void snooze(int durationMinutes, String reason) {
        if (this.resolved) {
            throw new IllegalStateException("Cannot snooze a resolved alert");
        }
        if (durationMinutes <= 0) {
            throw new IllegalArgumentException("Duration must be positive");
        }
        this.snoozedUntil = LocalDateTime.now().plusMinutes(durationMinutes);
        this.snoozeReason = reason;
    }

    /**
     * Checks if the alert is currently snoozed
     * @return true if alert is snoozed and snooze period hasn't expired
     */
    public boolean isSnoozed() {
        return this.snoozedUntil != null && LocalDateTime.now().isBefore(this.snoozedUntil);
    }

    /**
     * Checks if the alert is active (not resolved and not snoozed)
     * @return true if alert is active
     */
    public boolean isActive() {
        return !this.resolved && !isSnoozed();
    }

    /**
     * Checks if the alert is critical
     * @return true if severity is CRITICAL
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

    public AlertSeverity getSeverity() {
        return severity;
    }

    public void setSeverity(AlertSeverity severity) {
        this.severity = severity;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getSource() {
        return source;
    }

    public void setSource(String source) {
        this.source = source;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isAcknowledged() {
        return acknowledged;
    }

    public void setAcknowledged(boolean acknowledged) {
        this.acknowledged = acknowledged;
    }

    public UUID getAcknowledgedBy() {
        return acknowledgedBy;
    }

    public void setAcknowledgedBy(UUID acknowledgedBy) {
        this.acknowledgedBy = acknowledgedBy;
    }

    public LocalDateTime getAcknowledgedAt() {
        return acknowledgedAt;
    }

    public void setAcknowledgedAt(LocalDateTime acknowledgedAt) {
        this.acknowledgedAt = acknowledgedAt;
    }

    public String getAcknowledgeNote() {
        return acknowledgeNote;
    }

    public void setAcknowledgeNote(String acknowledgeNote) {
        this.acknowledgeNote = acknowledgeNote;
    }

    public boolean isResolved() {
        return resolved;
    }

    public void setResolved(boolean resolved) {
        this.resolved = resolved;
    }

    public UUID getResolvedBy() {
        return resolvedBy;
    }

    public void setResolvedBy(UUID resolvedBy) {
        this.resolvedBy = resolvedBy;
    }

    public LocalDateTime getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(LocalDateTime resolvedAt) {
        this.resolvedAt = resolvedAt;
    }

    public String getResolution() {
        return resolution;
    }

    public void setResolution(String resolution) {
        this.resolution = resolution;
    }

    public String getRootCause() {
        return rootCause;
    }

    public void setRootCause(String rootCause) {
        this.rootCause = rootCause;
    }

    public LocalDateTime getSnoozedUntil() {
        return snoozedUntil;
    }

    public void setSnoozedUntil(LocalDateTime snoozedUntil) {
        this.snoozedUntil = snoozedUntil;
    }

    public String getSnoozeReason() {
        return snoozeReason;
    }

    public void setSnoozeReason(String snoozeReason) {
        this.snoozeReason = snoozeReason;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Alert alert = (Alert) o;
        return Objects.equals(id, alert.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
