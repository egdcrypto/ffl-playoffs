package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.entity.AdminAuditLog;
import com.ffl.playoffs.domain.model.AdminAction;
import com.ffl.playoffs.domain.port.AdminAuditLogRepository;
import com.ffl.playoffs.domain.port.UserRepository;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Use case for retrieving admin audit logs.
 * Only SUPER_ADMIN can view audit logs.
 */
@Service
public class GetAdminAuditLogsUseCase {

    private final UserRepository userRepository;
    private final AdminAuditLogRepository auditLogRepository;

    public GetAdminAuditLogsUseCase(UserRepository userRepository,
                                     AdminAuditLogRepository auditLogRepository) {
        this.userRepository = userRepository;
        this.auditLogRepository = auditLogRepository;
    }

    /**
     * Retrieves admin audit logs with optional filtering.
     *
     * @param command the query command
     * @return the result containing audit logs
     * @throws IllegalStateException if requester is not SUPER_ADMIN
     */
    public GetAdminAuditLogsResult execute(GetAdminAuditLogsCommand command) {
        // Verify requester is SUPER_ADMIN
        User requester = userRepository.findById(command.getRequesterId())
                .orElseThrow(() -> new IllegalArgumentException("Requester not found"));

        if (!requester.isSuperAdmin()) {
            throw new IllegalStateException("Only SUPER_ADMIN can view audit logs");
        }

        List<AdminAuditLog> logs;

        // Apply filters if provided
        if (command.getAdminId() != null) {
            logs = auditLogRepository.findByAdminId(command.getAdminId());
        } else if (command.getAction() != null) {
            logs = auditLogRepository.findByAction(command.getAction());
        } else if (command.getStartDate() != null && command.getEndDate() != null) {
            logs = auditLogRepository.findByTimestampBetween(command.getStartDate(), command.getEndDate());
        } else {
            logs = auditLogRepository.findAll(command.getOffset(), command.getLimit());
        }

        long totalCount = auditLogRepository.count();

        List<AuditLogEntry> entries = logs.stream()
                .map(log -> new AuditLogEntry(
                        log.getId(),
                        log.getAdminId(),
                        log.getAdminEmail(),
                        log.getAction(),
                        log.getTargetId(),
                        log.getTargetType(),
                        log.getDetails(),
                        log.getTimestamp()
                ))
                .collect(Collectors.toList());

        return new GetAdminAuditLogsResult(entries, totalCount);
    }

    /**
     * Command for retrieving audit logs
     */
    public static class GetAdminAuditLogsCommand {
        private final UUID requesterId;
        private final UUID adminId;
        private final AdminAction action;
        private final LocalDateTime startDate;
        private final LocalDateTime endDate;
        private final int offset;
        private final int limit;

        public GetAdminAuditLogsCommand(UUID requesterId) {
            this(requesterId, null, null, null, null, 0, 50);
        }

        public GetAdminAuditLogsCommand(UUID requesterId, UUID adminId, AdminAction action,
                                         LocalDateTime startDate, LocalDateTime endDate,
                                         int offset, int limit) {
            this.requesterId = requesterId;
            this.adminId = adminId;
            this.action = action;
            this.startDate = startDate;
            this.endDate = endDate;
            this.offset = offset;
            this.limit = limit;
        }

        public UUID getRequesterId() {
            return requesterId;
        }

        public UUID getAdminId() {
            return adminId;
        }

        public AdminAction getAction() {
            return action;
        }

        public LocalDateTime getStartDate() {
            return startDate;
        }

        public LocalDateTime getEndDate() {
            return endDate;
        }

        public int getOffset() {
            return offset;
        }

        public int getLimit() {
            return limit;
        }

        // Builder methods for optional parameters
        public static Builder builder(UUID requesterId) {
            return new Builder(requesterId);
        }

        public static class Builder {
            private final UUID requesterId;
            private UUID adminId;
            private AdminAction action;
            private LocalDateTime startDate;
            private LocalDateTime endDate;
            private int offset = 0;
            private int limit = 50;

            public Builder(UUID requesterId) {
                this.requesterId = requesterId;
            }

            public Builder adminId(UUID adminId) {
                this.adminId = adminId;
                return this;
            }

            public Builder action(AdminAction action) {
                this.action = action;
                return this;
            }

            public Builder dateRange(LocalDateTime startDate, LocalDateTime endDate) {
                this.startDate = startDate;
                this.endDate = endDate;
                return this;
            }

            public Builder offset(int offset) {
                this.offset = offset;
                return this;
            }

            public Builder limit(int limit) {
                this.limit = limit;
                return this;
            }

            public GetAdminAuditLogsCommand build() {
                return new GetAdminAuditLogsCommand(requesterId, adminId, action,
                        startDate, endDate, offset, limit);
            }
        }
    }

    /**
     * Audit log entry for the result
     */
    public static class AuditLogEntry {
        private final UUID id;
        private final UUID adminId;
        private final String adminEmail;
        private final AdminAction action;
        private final UUID targetId;
        private final String targetType;
        private final Map<String, Object> details;
        private final LocalDateTime timestamp;

        public AuditLogEntry(UUID id, UUID adminId, String adminEmail, AdminAction action,
                            UUID targetId, String targetType, Map<String, Object> details,
                            LocalDateTime timestamp) {
            this.id = id;
            this.adminId = adminId;
            this.adminEmail = adminEmail;
            this.action = action;
            this.targetId = targetId;
            this.targetType = targetType;
            this.details = details;
            this.timestamp = timestamp;
        }

        public UUID getId() {
            return id;
        }

        public UUID getAdminId() {
            return adminId;
        }

        public String getAdminEmail() {
            return adminEmail;
        }

        public AdminAction getAction() {
            return action;
        }

        public UUID getTargetId() {
            return targetId;
        }

        public String getTargetType() {
            return targetType;
        }

        public Map<String, Object> getDetails() {
            return details;
        }

        public LocalDateTime getTimestamp() {
            return timestamp;
        }
    }

    /**
     * Result containing audit logs
     */
    public static class GetAdminAuditLogsResult {
        private final List<AuditLogEntry> logs;
        private final long totalCount;

        public GetAdminAuditLogsResult(List<AuditLogEntry> logs, long totalCount) {
            this.logs = logs;
            this.totalCount = totalCount;
        }

        public List<AuditLogEntry> getLogs() {
            return logs;
        }

        public long getTotalCount() {
            return totalCount;
        }
    }
}
