package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.invitation.AdminInvitation;
import com.ffl.playoffs.domain.model.invitation.AdminInvitationStatus;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.AdminInvitationDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper for converting between AdminInvitation domain model and MongoDB document.
 */
@Component
public class AdminInvitationMapper {

    /**
     * Convert domain model to document.
     */
    public AdminInvitationDocument toDocument(AdminInvitation invitation) {
        if (invitation == null) {
            return null;
        }

        return AdminInvitationDocument.builder()
                .id(invitation.getId() != null ? invitation.getId().toString() : null)
                .email(invitation.getEmail())
                .name(invitation.getName())
                .invitedBy(invitation.getInvitedBy() != null ? invitation.getInvitedBy().toString() : null)
                .invitationToken(invitation.getInvitationToken())
                .status(invitation.getStatus() != null ? invitation.getStatus().getCode() : null)
                .expiresAt(invitation.getExpiresAt())
                .createdAt(invitation.getCreatedAt())
                .updatedAt(invitation.getUpdatedAt())
                .acceptedAt(invitation.getAcceptedAt())
                .revokedAt(invitation.getRevokedAt())
                .acceptedUserId(invitation.getAcceptedUserId() != null ? invitation.getAcceptedUserId().toString() : null)
                .revokeReason(invitation.getRevokeReason())
                .resendCount(invitation.getResendCount())
                .build();
    }

    /**
     * Convert document to domain model.
     */
    public AdminInvitation toDomain(AdminInvitationDocument doc) {
        if (doc == null) {
            return null;
        }

        return AdminInvitation.builder()
                .id(doc.getId() != null ? UUID.fromString(doc.getId()) : null)
                .email(doc.getEmail())
                .name(doc.getName())
                .invitedBy(doc.getInvitedBy() != null ? UUID.fromString(doc.getInvitedBy()) : null)
                .invitationToken(doc.getInvitationToken())
                .status(doc.getStatus() != null ? AdminInvitationStatus.fromCode(doc.getStatus()) : null)
                .expiresAt(doc.getExpiresAt())
                .createdAt(doc.getCreatedAt())
                .updatedAt(doc.getUpdatedAt())
                .acceptedAt(doc.getAcceptedAt())
                .revokedAt(doc.getRevokedAt())
                .acceptedUserId(doc.getAcceptedUserId() != null ? UUID.fromString(doc.getAcceptedUserId()) : null)
                .revokeReason(doc.getRevokeReason())
                .resendCount(doc.getResendCount())
                .build();
    }
}
