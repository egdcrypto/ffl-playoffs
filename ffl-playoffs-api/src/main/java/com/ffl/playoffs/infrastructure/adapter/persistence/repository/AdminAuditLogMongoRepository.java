package com.ffl.playoffs.infrastructure.adapter.persistence.repository;

import com.ffl.playoffs.infrastructure.adapter.persistence.document.AdminAuditLogDocument;
import org.springframework.data.domain.Pageable;
import org.springframework.data.mongodb.repository.MongoRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;

/**
 * Spring Data MongoDB repository for AdminAuditLog documents
 */
@Repository
public interface AdminAuditLogMongoRepository extends MongoRepository<AdminAuditLogDocument, String> {

    /**
     * Find audit logs by admin ID
     */
    List<AdminAuditLogDocument> findByAdminId(String adminId);

    /**
     * Find audit logs by action
     */
    List<AdminAuditLogDocument> findByAction(String action);

    /**
     * Find audit logs within time range
     */
    List<AdminAuditLogDocument> findByTimestampBetween(LocalDateTime start, LocalDateTime end);

    /**
     * Find all audit logs with pagination, ordered by timestamp descending
     */
    List<AdminAuditLogDocument> findAllByOrderByTimestampDesc(Pageable pageable);
}
