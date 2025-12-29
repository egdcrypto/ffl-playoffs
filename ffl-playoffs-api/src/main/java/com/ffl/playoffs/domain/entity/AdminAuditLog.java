package com.ffl.playoffs.domain.entity;

import com.ffl.playoffs.domain.model.AdminAction;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Domain entity for tracking admin activities.
 * Provides audit trail for compliance and monitoring.
 */
public class AdminAuditLog {

    private UUID id;
    private UUID adminId;
    private String adminEmail;
    private AdminAction action;
    private UUID targetId;
    private String targetType;
    private Map<String, Object> details;
    private LocalDateTime timestamp;

    /**
     * Default constructor for persistence frameworks
     */
    public AdminAuditLog() {
        this.details = new HashMap<>();
    }

    /**
     * Creates a new audit log entry
     *
     * @param adminId the ID of the admin who performed the action
     * @param adminEmail the email of the admin (denormalized for queries)
     * @param action the type of action performed
     * @return a new AdminAuditLog with timestamp
     */
    public static AdminAuditLog create(UUID adminId, String adminEmail, AdminAction action) {
        AdminAuditLog log = new AdminAuditLog();
        log.id = UUID.randomUUID();
        log.adminId = adminId;
        log.adminEmail = adminEmail;
        log.action = action;
        log.timestamp = LocalDateTime.now();
        return log;
    }

    /**
     * Creates an audit log for an action on a specific target
     *
     * @param adminId the ID of the admin
     * @param adminEmail the email of the admin
     * @param action the action performed
     * @param targetId the ID of the affected entity
     * @param targetType the type of the affected entity (e.g., "League", "Player")
     * @return a new AdminAuditLog
     */
    public static AdminAuditLog createForTarget(UUID adminId, String adminEmail, AdminAction action,
                                                 UUID targetId, String targetType) {
        AdminAuditLog log = create(adminId, adminEmail, action);
        log.targetId = targetId;
        log.targetType = targetType;
        return log;
    }

    // Business methods

    /**
     * Adds a detail to the audit log
     *
     * @param key the detail key
     * @param value the detail value
     * @return this instance for chaining
     */
    public AdminAuditLog withDetail(String key, Object value) {
        if (this.details == null) {
            this.details = new HashMap<>();
        }
        this.details.put(key, value);
        return this;
    }

    /**
     * Adds multiple details to the audit log
     *
     * @param details the details to add
     * @return this instance for chaining
     */
    public AdminAuditLog withDetails(Map<String, Object> details) {
        if (this.details == null) {
            this.details = new HashMap<>();
        }
        this.details.putAll(details);
        return this;
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getAdminId() {
        return adminId;
    }

    public void setAdminId(UUID adminId) {
        this.adminId = adminId;
    }

    public String getAdminEmail() {
        return adminEmail;
    }

    public void setAdminEmail(String adminEmail) {
        this.adminEmail = adminEmail;
    }

    public AdminAction getAction() {
        return action;
    }

    public void setAction(AdminAction action) {
        this.action = action;
    }

    public UUID getTargetId() {
        return targetId;
    }

    public void setTargetId(UUID targetId) {
        this.targetId = targetId;
    }

    public String getTargetType() {
        return targetType;
    }

    public void setTargetType(String targetType) {
        this.targetType = targetType;
    }

    public Map<String, Object> getDetails() {
        return details;
    }

    public void setDetails(Map<String, Object> details) {
        this.details = details;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(LocalDateTime timestamp) {
        this.timestamp = timestamp;
    }
}
