package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.auth.AuthSession;
import com.ffl.playoffs.domain.model.auth.Permission;
import com.ffl.playoffs.domain.model.auth.SessionStatus;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.AuthSessionDocument;
import org.springframework.stereotype.Component;

import java.util.EnumSet;
import java.util.Set;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Mapper for converting between AuthSession domain model and AuthSessionDocument
 */
@Component
public class AuthSessionMapper {

    /**
     * Convert domain model to document
     * @param session the domain model
     * @return the document
     */
    public AuthSessionDocument toDocument(AuthSession session) {
        if (session == null) {
            return null;
        }

        AuthSessionDocument doc = new AuthSessionDocument();
        doc.setId(session.getId() != null ? session.getId().toString() : null);
        doc.setUserId(session.getUserId() != null ? session.getUserId().toString() : null);
        doc.setSessionToken(session.getSessionToken());
        doc.setRefreshToken(session.getRefreshToken());
        doc.setAuthType(session.getAuthType() != null ? session.getAuthType().getCode() : null);
        doc.setStatus(session.getStatus() != null ? session.getStatus().getCode() : null);
        doc.setPermissions(permissionsToStrings(session.getPermissions()));
        doc.setCreatedAt(session.getCreatedAt());
        doc.setExpiresAt(session.getExpiresAt());
        doc.setRefreshExpiresAt(session.getRefreshExpiresAt());
        doc.setLastActivityAt(session.getLastActivityAt());
        doc.setInvalidatedAt(session.getInvalidatedAt());
        doc.setIpAddress(session.getIpAddress());
        doc.setUserAgent(session.getUserAgent());
        doc.setDeviceId(session.getDeviceId());
        doc.setGoogleId(session.getGoogleId());
        doc.setPatId(session.getPatId() != null ? session.getPatId().toString() : null);

        return doc;
    }

    /**
     * Convert document to domain model
     * @param doc the document
     * @return the domain model
     */
    public AuthSession toDomain(AuthSessionDocument doc) {
        if (doc == null) {
            return null;
        }

        return AuthSession.builder()
                .id(doc.getId() != null ? UUID.fromString(doc.getId()) : null)
                .userId(doc.getUserId() != null ? UUID.fromString(doc.getUserId()) : null)
                .sessionToken(doc.getSessionToken())
                .refreshToken(doc.getRefreshToken())
                .authType(doc.getAuthType() != null ? AuthSession.AuthType.fromCode(doc.getAuthType()) : null)
                .status(doc.getStatus() != null ? SessionStatus.fromCode(doc.getStatus()) : null)
                .permissions(stringsToPermissions(doc.getPermissions()))
                .createdAt(doc.getCreatedAt())
                .expiresAt(doc.getExpiresAt())
                .refreshExpiresAt(doc.getRefreshExpiresAt())
                .lastActivityAt(doc.getLastActivityAt())
                .invalidatedAt(doc.getInvalidatedAt())
                .ipAddress(doc.getIpAddress())
                .userAgent(doc.getUserAgent())
                .deviceId(doc.getDeviceId())
                .googleId(doc.getGoogleId())
                .patId(doc.getPatId() != null ? UUID.fromString(doc.getPatId()) : null)
                .build();
    }

    /**
     * Convert permissions set to strings
     */
    private Set<String> permissionsToStrings(Set<Permission> permissions) {
        if (permissions == null) {
            return null;
        }
        return permissions.stream()
                .map(Permission::getCode)
                .collect(Collectors.toSet());
    }

    /**
     * Convert strings to permissions set
     */
    private Set<Permission> stringsToPermissions(Set<String> strings) {
        if (strings == null || strings.isEmpty()) {
            return EnumSet.noneOf(Permission.class);
        }
        EnumSet<Permission> permissions = EnumSet.noneOf(Permission.class);
        for (String code : strings) {
            try {
                permissions.add(Permission.fromCode(code));
            } catch (IllegalArgumentException e) {
                // Skip unknown permissions
            }
        }
        return permissions;
    }
}
