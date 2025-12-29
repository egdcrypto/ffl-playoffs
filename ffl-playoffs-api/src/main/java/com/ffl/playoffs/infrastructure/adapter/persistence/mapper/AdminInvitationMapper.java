package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.entity.AdminInvitation;
import com.ffl.playoffs.domain.model.AdminInvitationStatus;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.AdminInvitationDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper for AdminInvitation domain entity and MongoDB document
 */
@Component
public class AdminInvitationMapper {

    /**
     * Converts domain entity to MongoDB document
     */
    public AdminInvitationDocument toDocument(AdminInvitation entity) {
        if (entity == null) {
            return null;
        }

        AdminInvitationDocument document = new AdminInvitationDocument();
        document.setId(entity.getId().toString());
        document.setEmail(entity.getEmail());
        document.setStatus(entity.getStatus().name());
        document.setInvitationToken(entity.getInvitationToken());
        document.setInvitedBy(entity.getInvitedBy().toString());
        document.setCreatedAt(entity.getCreatedAt());
        document.setExpiresAt(entity.getExpiresAt());
        document.setAcceptedAt(entity.getAcceptedAt());

        if (entity.getAcceptedByUserId() != null) {
            document.setAcceptedByUserId(entity.getAcceptedByUserId().toString());
        }

        return document;
    }

    /**
     * Converts MongoDB document to domain entity
     */
    public AdminInvitation toDomain(AdminInvitationDocument document) {
        if (document == null) {
            return null;
        }

        AdminInvitation entity = new AdminInvitation();
        entity.setId(UUID.fromString(document.getId()));
        entity.setEmail(document.getEmail());
        entity.setStatus(AdminInvitationStatus.valueOf(document.getStatus()));
        entity.setInvitationToken(document.getInvitationToken());
        entity.setInvitedBy(UUID.fromString(document.getInvitedBy()));
        entity.setCreatedAt(document.getCreatedAt());
        entity.setExpiresAt(document.getExpiresAt());
        entity.setAcceptedAt(document.getAcceptedAt());

        if (document.getAcceptedByUserId() != null) {
            entity.setAcceptedByUserId(UUID.fromString(document.getAcceptedByUserId()));
        }

        return entity;
    }
}
