package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.model.worldowner.*;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldOwnerPlayerDocument;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Mapper for converting between WorldOwnerPlayer domain model and MongoDB document.
 */
@Component
public class WorldOwnerPlayerMapper {

    public WorldOwnerPlayerDocument toDocument(WorldOwnerPlayer domain) {
        if (domain == null) {
            return null;
        }

        Set<String> permissionCodes = null;
        if (domain.getPermissions() != null) {
            permissionCodes = domain.getPermissions().stream()
                    .map(WorldOwnerPermission::getCode)
                    .collect(Collectors.toSet());
        }

        return WorldOwnerPlayerDocument.builder()
                .id(domain.getId() != null ? domain.getId().toString() : null)
                .userId(domain.getUserId() != null ? domain.getUserId().toString() : null)
                .worldId(domain.getWorldId() != null ? domain.getWorldId().toString() : null)
                .role(domain.getRole() != null ? domain.getRole().getCode() : null)
                .status(domain.getStatus() != null ? domain.getStatus().getCode() : null)
                .permissions(permissionCodes)
                .grantedBy(domain.getGrantedBy() != null ? domain.getGrantedBy().toString() : null)
                .grantedAt(domain.getGrantedAt())
                .joinedAt(domain.getJoinedAt())
                .lastActiveAt(domain.getLastActiveAt())
                .invitationToken(domain.getInvitationToken())
                .invitationExpiresAt(domain.getInvitationExpiresAt())
                .createdAt(domain.getCreatedAt())
                .updatedAt(domain.getUpdatedAt())
                .build();
    }

    public WorldOwnerPlayer toDomain(WorldOwnerPlayerDocument document) {
        if (document == null) {
            return null;
        }

        Set<WorldOwnerPermission> permissions = new HashSet<>();
        if (document.getPermissions() != null) {
            for (String code : document.getPermissions()) {
                try {
                    permissions.add(WorldOwnerPermission.fromCode(code));
                } catch (IllegalArgumentException e) {
                    // Skip unknown permissions
                }
            }
        }

        return WorldOwnerPlayer.builder()
                .id(document.getId() != null ? UUID.fromString(document.getId()) : null)
                .userId(document.getUserId() != null ? UUID.fromString(document.getUserId()) : null)
                .worldId(document.getWorldId() != null ? UUID.fromString(document.getWorldId()) : null)
                .role(document.getRole() != null ? OwnershipRole.fromCode(document.getRole()) : null)
                .status(document.getStatus() != null ? OwnershipStatus.fromCode(document.getStatus()) : null)
                .permissions(permissions)
                .grantedBy(document.getGrantedBy() != null ? UUID.fromString(document.getGrantedBy()) : null)
                .grantedAt(document.getGrantedAt())
                .joinedAt(document.getJoinedAt())
                .lastActiveAt(document.getLastActiveAt())
                .invitationToken(document.getInvitationToken())
                .invitationExpiresAt(document.getInvitationExpiresAt())
                .createdAt(document.getCreatedAt())
                .updatedAt(document.getUpdatedAt())
                .build();
    }

    public List<WorldOwnerPlayer> toDomainList(List<WorldOwnerPlayerDocument> documents) {
        if (documents == null) {
            return new ArrayList<>();
        }
        return documents.stream()
                .map(this::toDomain)
                .collect(Collectors.toList());
    }
}
