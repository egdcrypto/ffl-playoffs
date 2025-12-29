package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.entity.AdminAuditLog;
import com.ffl.playoffs.domain.model.AdminAction;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository interface for AdminAuditLog entity.
 * Port in hexagonal architecture.
 */
public interface AdminAuditLogRepository {

    /**
     * Saves an audit log entry
     *
     * @param log the audit log to save
     * @return the saved audit log
     */
    AdminAuditLog save(AdminAuditLog log);

    /**
     * Finds an audit log by ID
     *
     * @param id the audit log ID
     * @return Optional containing the audit log if found
     */
    Optional<AdminAuditLog> findById(UUID id);

    /**
     * Finds all audit logs for a specific admin
     *
     * @param adminId the admin's ID
     * @return list of audit logs
     */
    List<AdminAuditLog> findByAdminId(UUID adminId);

    /**
     * Finds all audit logs for a specific action type
     *
     * @param action the action type
     * @return list of audit logs
     */
    List<AdminAuditLog> findByAction(AdminAction action);

    /**
     * Finds audit logs within a time range
     *
     * @param start the start of the time range
     * @param end the end of the time range
     * @return list of audit logs
     */
    List<AdminAuditLog> findByTimestampBetween(LocalDateTime start, LocalDateTime end);

    /**
     * Finds all audit logs with pagination
     *
     * @param offset the starting index
     * @param limit the maximum number of results
     * @return list of audit logs
     */
    List<AdminAuditLog> findAll(int offset, int limit);

    /**
     * Counts total number of audit logs
     *
     * @return total count
     */
    long count();
}
