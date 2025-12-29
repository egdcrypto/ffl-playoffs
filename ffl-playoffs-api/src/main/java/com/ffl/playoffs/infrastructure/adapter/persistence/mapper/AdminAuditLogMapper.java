package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.entity.AdminAuditLog;
import com.ffl.playoffs.domain.model.AdminAction;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.AdminAuditLogDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper for AdminAuditLog domain entity and MongoDB document
 */
@Component
public class AdminAuditLogMapper {

    /**
     * Converts domain entity to MongoDB document
     */
    public AdminAuditLogDocument toDocument(AdminAuditLog entity) {
        if (entity == null) {
            return null;
        }

        AdminAuditLogDocument document = new AdminAuditLogDocument();
        document.setId(entity.getId().toString());
        document.setAdminId(entity.getAdminId().toString());
        document.setAdminEmail(entity.getAdminEmail());
        document.setAction(entity.getAction().name());
        document.setTimestamp(entity.getTimestamp());
        document.setDetails(entity.getDetails());

        if (entity.getTargetId() != null) {
            document.setTargetId(entity.getTargetId().toString());
        }
        document.setTargetType(entity.getTargetType());

        return document;
    }

    /**
     * Converts MongoDB document to domain entity
     */
    public AdminAuditLog toDomain(AdminAuditLogDocument document) {
        if (document == null) {
            return null;
        }

        AdminAuditLog entity = new AdminAuditLog();
        entity.setId(UUID.fromString(document.getId()));
        entity.setAdminId(UUID.fromString(document.getAdminId()));
        entity.setAdminEmail(document.getAdminEmail());
        entity.setAction(AdminAction.valueOf(document.getAction()));
        entity.setTimestamp(document.getTimestamp());
        entity.setDetails(document.getDetails());

        if (document.getTargetId() != null && !document.getTargetId().isEmpty()) {
            entity.setTargetId(UUID.fromString(document.getTargetId()));
        }
        entity.setTargetType(document.getTargetType());

        return entity;
    }
}
