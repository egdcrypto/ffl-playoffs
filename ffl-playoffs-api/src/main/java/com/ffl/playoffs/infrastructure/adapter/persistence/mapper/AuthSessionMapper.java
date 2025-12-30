package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.AuthSession;
import com.ffl.playoffs.domain.model.auth.AuthenticationType;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.AuthSessionDocument;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Mapper for converting between AuthSession domain aggregate and AuthSessionDocument.
 */
public final class AuthSessionMapper {

    private AuthSessionMapper() {
        // Utility class
    }

    /**
     * Convert domain aggregate to MongoDB document
     */
    public static AuthSessionDocument toDocument(AuthSession session) {
        if (session == null) {
            return null;
        }

        return AuthSessionDocument.builder()
                .id(session.getId() != null ? session.getId().toString() : null)
                .principalId(session.getPrincipalId() != null ? session.getPrincipalId().toString() : null)
                .authenticationType(session.getAuthenticationType() != null
                        ? session.getAuthenticationType().getCode() : null)
                .identifier(session.getIdentifier())
                .ipAddress(session.getIpAddress())
                .userAgent(session.getUserAgent())
                .createdAt(session.getCreatedAt())
                .expiresAt(session.getExpiresAt())
                .lastActivityAt(session.getLastActivityAt())
                .active(session.isActive())
                .terminationReason(session.getTerminationReason())
                .terminatedAt(session.getTerminatedAt())
                .build();
    }

    /**
     * Convert MongoDB document to domain aggregate
     */
    public static AuthSession toDomain(AuthSessionDocument document) {
        if (document == null) {
            return null;
        }

        AuthSession session = new AuthSession();

        if (document.getId() != null) {
            session.setId(UUID.fromString(document.getId()));
        }
        if (document.getPrincipalId() != null) {
            session.setPrincipalId(UUID.fromString(document.getPrincipalId()));
        }
        if (document.getAuthenticationType() != null) {
            session.setAuthenticationType(AuthenticationType.fromCode(document.getAuthenticationType()));
        }
        session.setIdentifier(document.getIdentifier());
        session.setIpAddress(document.getIpAddress());
        session.setUserAgent(document.getUserAgent());
        session.setCreatedAt(document.getCreatedAt());
        session.setExpiresAt(document.getExpiresAt());
        session.setLastActivityAt(document.getLastActivityAt());
        session.setActive(document.isActive());
        session.setTerminationReason(document.getTerminationReason());
        session.setTerminatedAt(document.getTerminatedAt());

        return session;
    }

    /**
     * Convert list of domain aggregates to documents
     */
    public static List<AuthSessionDocument> toDocuments(List<AuthSession> sessions) {
        if (sessions == null) {
            return List.of();
        }
        return sessions.stream()
                .map(AuthSessionMapper::toDocument)
                .collect(Collectors.toList());
    }

    /**
     * Convert list of documents to domain aggregates
     */
    public static List<AuthSession> toDomains(List<AuthSessionDocument> documents) {
        if (documents == null) {
            return List.of();
        }
        return documents.stream()
                .map(AuthSessionMapper::toDomain)
                .collect(Collectors.toList());
    }
}
