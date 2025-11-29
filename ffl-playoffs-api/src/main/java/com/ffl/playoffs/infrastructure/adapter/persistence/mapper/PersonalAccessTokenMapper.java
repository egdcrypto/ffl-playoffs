package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.PATScope;
import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.PersonalAccessTokenDocument;
import org.springframework.stereotype.Component;

import java.util.UUID;

/**
 * Mapper to convert between PersonalAccessToken domain model and PersonalAccessTokenDocument
 * Infrastructure layer
 */
@Component
public class PersonalAccessTokenMapper {

    /**
     * Converts PersonalAccessToken domain entity to PersonalAccessTokenDocument
     * @param token the domain entity
     * @return the MongoDB document
     */
    public PersonalAccessTokenDocument toDocument(PersonalAccessToken token) {
        if (token == null) {
            return null;
        }

        PersonalAccessTokenDocument document = new PersonalAccessTokenDocument();
        document.setId(token.getId() != null ? token.getId().toString() : null);
        document.setName(token.getName());
        document.setTokenIdentifier(token.getTokenIdentifier());
        document.setTokenHash(token.getTokenHash());
        document.setScope(token.getScope() != null ? token.getScope().name() : null);
        document.setExpiresAt(token.getExpiresAt());
        document.setCreatedBy(token.getCreatedBy());
        document.setCreatedAt(token.getCreatedAt());
        document.setLastUsedAt(token.getLastUsedAt());
        document.setRevoked(token.isRevoked());
        document.setRevokedAt(token.getRevokedAt());

        return document;
    }

    /**
     * Converts PersonalAccessTokenDocument to PersonalAccessToken domain entity
     * @param document the MongoDB document
     * @return the domain entity
     */
    public PersonalAccessToken toDomain(PersonalAccessTokenDocument document) {
        if (document == null) {
            return null;
        }

        PersonalAccessToken token = new PersonalAccessToken();
        token.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        token.setName(document.getName());
        token.setTokenIdentifier(document.getTokenIdentifier());
        token.setTokenHash(document.getTokenHash());
        token.setScope(document.getScope() != null ? PATScope.valueOf(document.getScope()) : null);
        token.setExpiresAt(document.getExpiresAt());
        token.setCreatedBy(document.getCreatedBy());
        token.setCreatedAt(document.getCreatedAt());
        token.setLastUsedAt(document.getLastUsedAt());
        token.setRevoked(document.isRevoked());
        token.setRevokedAt(document.getRevokedAt());

        return token;
    }
}
