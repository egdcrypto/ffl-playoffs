package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.IncidentSeverity;
import com.ffl.playoffs.domain.model.IncidentStatus;

import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Objects;
import java.util.UUID;

/**
 * Incident aggregate root
 * Represents a platform incident requiring attention
 */
public class Incident {
    private UUID id;
    private String incidentNumber;
    private String title;
    private String description;
    private IncidentSeverity severity;
    private IncidentStatus status;
    private List<UUID> relatedAlerts;
    private List<String> affectedServices;
    private List<String> timeline;
    private UUID assignedTo;
    private UUID createdBy;
    private LocalDateTime createdAt;
    private LocalDateTime acknowledgedAt;
    private LocalDateTime resolvedAt;
    private LocalDateTime closedAt;
    private String resolution;
    private String rootCause;

    public Incident() {
        this.id = UUID.randomUUID();
        this.status = IncidentStatus.OPEN;
        this.relatedAlerts = new ArrayList<>();
        this.affectedServices = new ArrayList<>();
        this.timeline = new ArrayList<>();
        this.createdAt = LocalDateTime.now();
    }

    public Incident(String title, IncidentSeverity severity) {
        this();
        this.title = title;
        this.severity = severity;
        this.incidentNumber = "INC-" + System.currentTimeMillis() % 100000;
        addTimelineEntry("Incident created with severity " + severity);
    }

    /**
     * Acknowledges the incident
     * @param adminId the admin acknowledging
     */
    public void acknowledge(UUID adminId) {
        if (this.status != IncidentStatus.OPEN) {
            throw new IllegalStateException("Can only acknowledge an open incident");
        }
        this.status = IncidentStatus.ACKNOWLEDGED;
        this.assignedTo = adminId;
        this.acknowledgedAt = LocalDateTime.now();
        addTimelineEntry("Incident acknowledged");
    }

    /**
     * Starts investigation
     */
    public void startInvestigation() {
        if (this.status != IncidentStatus.ACKNOWLEDGED) {
            throw new IllegalStateException("Must acknowledge incident before investigating");
        }
        this.status = IncidentStatus.INVESTIGATING;
        addTimelineEntry("Investigation started");
    }

    /**
     * Marks incident as mitigated
     * @param mitigationNote description of mitigation
     */
    public void mitigate(String mitigationNote) {
        if (this.status != IncidentStatus.INVESTIGATING) {
            throw new IllegalStateException("Must be investigating to mitigate");
        }
        this.status = IncidentStatus.MITIGATED;
        addTimelineEntry("Mitigated: " + mitigationNote);
    }

    /**
     * Resolves the incident
     * @param resolution description of resolution
     */
    public void resolve(String resolution) {
        this.status = IncidentStatus.RESOLVED;
        this.resolution = resolution;
        this.resolvedAt = LocalDateTime.now();
        addTimelineEntry("Resolved: " + resolution);
    }

    /**
     * Closes the incident after post-incident review
     * @param rootCause root cause analysis
     */
    public void close(String rootCause) {
        if (this.status != IncidentStatus.RESOLVED) {
            throw new IllegalStateException("Must resolve incident before closing");
        }
        this.status = IncidentStatus.CLOSED;
        this.rootCause = rootCause;
        this.closedAt = LocalDateTime.now();
        addTimelineEntry("Incident closed. Root cause: " + rootCause);
    }

    /**
     * Adds a related alert to the incident
     * @param alertId the alert id
     */
    public void addRelatedAlert(UUID alertId) {
        if (!this.relatedAlerts.contains(alertId)) {
            this.relatedAlerts.add(alertId);
            addTimelineEntry("Alert " + alertId + " linked");
        }
    }

    /**
     * Adds an affected service
     * @param serviceName the service name
     */
    public void addAffectedService(String serviceName) {
        if (!this.affectedServices.contains(serviceName)) {
            this.affectedServices.add(serviceName);
        }
    }

    /**
     * Adds a timeline entry
     * @param entry the entry to add
     */
    public void addTimelineEntry(String entry) {
        this.timeline.add(LocalDateTime.now() + ": " + entry);
    }

    /**
     * Calculates the time to resolution
     * @return duration from creation to resolution, or null if not resolved
     */
    public Duration getTimeToResolution() {
        if (this.resolvedAt == null) {
            return null;
        }
        return Duration.between(this.createdAt, this.resolvedAt);
    }

    /**
     * Checks if the incident is active
     * @return true if not resolved or closed
     */
    public boolean isActive() {
        return this.status != IncidentStatus.RESOLVED && this.status != IncidentStatus.CLOSED;
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getIncidentNumber() {
        return incidentNumber;
    }

    public void setIncidentNumber(String incidentNumber) {
        this.incidentNumber = incidentNumber;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public IncidentSeverity getSeverity() {
        return severity;
    }

    public void setSeverity(IncidentSeverity severity) {
        this.severity = severity;
    }

    public IncidentStatus getStatus() {
        return status;
    }

    public void setStatus(IncidentStatus status) {
        this.status = status;
    }

    public List<UUID> getRelatedAlerts() {
        return new ArrayList<>(relatedAlerts);
    }

    public void setRelatedAlerts(List<UUID> relatedAlerts) {
        this.relatedAlerts = relatedAlerts != null ? new ArrayList<>(relatedAlerts) : new ArrayList<>();
    }

    public List<String> getAffectedServices() {
        return new ArrayList<>(affectedServices);
    }

    public void setAffectedServices(List<String> affectedServices) {
        this.affectedServices = affectedServices != null ? new ArrayList<>(affectedServices) : new ArrayList<>();
    }

    public List<String> getTimeline() {
        return new ArrayList<>(timeline);
    }

    public void setTimeline(List<String> timeline) {
        this.timeline = timeline != null ? new ArrayList<>(timeline) : new ArrayList<>();
    }

    public UUID getAssignedTo() {
        return assignedTo;
    }

    public void setAssignedTo(UUID assignedTo) {
        this.assignedTo = assignedTo;
    }

    public UUID getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(UUID createdBy) {
        this.createdBy = createdBy;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getAcknowledgedAt() {
        return acknowledgedAt;
    }

    public void setAcknowledgedAt(LocalDateTime acknowledgedAt) {
        this.acknowledgedAt = acknowledgedAt;
    }

    public LocalDateTime getResolvedAt() {
        return resolvedAt;
    }

    public void setResolvedAt(LocalDateTime resolvedAt) {
        this.resolvedAt = resolvedAt;
    }

    public LocalDateTime getClosedAt() {
        return closedAt;
    }

    public void setClosedAt(LocalDateTime closedAt) {
        this.closedAt = closedAt;
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

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Incident incident = (Incident) o;
        return Objects.equals(id, incident.id);
    }

    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
}
