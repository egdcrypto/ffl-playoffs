package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.PlayerInvitation;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.PlayerInvitationDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper between PlayerInvitation domain entity and PlayerInvitationDocument.
 * Infrastructure layer - handles domain/document conversion.
 */
@Component
public class PlayerInvitationMapper {

    /**
     * Converts a MongoDB document to a domain entity.
     *
     * @param document the MongoDB document
     * @return the domain entity
     */
    public PlayerInvitation toDomain(PlayerInvitationDocument document) {
        if (document == null) {
            return null;
        }

        PlayerInvitation invitation = new PlayerInvitation();
        invitation.setId(UUID.fromString(document.getId()));
        invitation.setLeagueId(UUID.fromString(document.getLeagueId()));
        invitation.setLeagueName(document.getLeagueName());
        invitation.setEmail(document.getEmail());
        invitation.setInvitationToken(document.getInvitationToken());
        invitation.setStatus(PlayerInvitation.InvitationStatus.valueOf(document.getStatus()));
        invitation.setInvitedByUserId(UUID.fromString(document.getInvitedByUserId()));
        invitation.setCreatedAt(document.getCreatedAt());
        invitation.setExpiresAt(document.getExpiresAt());
        invitation.setAcceptedAt(document.getAcceptedAt());

        if (document.getAcceptedByUserId() != null) {
            invitation.setAcceptedByUserId(UUID.fromString(document.getAcceptedByUserId()));
        }

        return invitation;
    }

    /**
     * Converts a domain entity to a MongoDB document.
     *
     * @param invitation the domain entity
     * @return the MongoDB document
     */
    public PlayerInvitationDocument toDocument(PlayerInvitation invitation) {
        if (invitation == null) {
            return null;
        }

        PlayerInvitationDocument document = new PlayerInvitationDocument();
        document.setId(invitation.getId().toString());
        document.setLeagueId(invitation.getLeagueId().toString());
        document.setLeagueName(invitation.getLeagueName());
        document.setEmail(invitation.getEmail());
        document.setInvitationToken(invitation.getInvitationToken());
        document.setStatus(invitation.getStatus().name());
        document.setInvitedByUserId(invitation.getInvitedByUserId().toString());
        document.setCreatedAt(invitation.getCreatedAt());
        document.setExpiresAt(invitation.getExpiresAt());
        document.setAcceptedAt(invitation.getAcceptedAt());

        if (invitation.getAcceptedByUserId() != null) {
            document.setAcceptedByUserId(invitation.getAcceptedByUserId().toString());
        }

        return document;
    }
}
