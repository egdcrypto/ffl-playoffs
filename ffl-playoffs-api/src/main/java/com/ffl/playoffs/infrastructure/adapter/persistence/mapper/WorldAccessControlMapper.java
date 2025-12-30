package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.aggregate.WorldAccessControl;
import com.ffl.playoffs.domain.model.accesscontrol.*;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldAccessControlDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldAccessControlDocument.WorldMemberDocument;
import org.springframework.stereotype.Component;

import java.util.*;
import java.util.stream.Collectors;

/**
 * Mapper for converting between WorldAccessControl domain aggregate and MongoDB document.
 */
@Component
public class WorldAccessControlMapper {

    public WorldAccessControlDocument toDocument(WorldAccessControl domain) {
        if (domain == null) {
            return null;
        }

        return WorldAccessControlDocument.builder()
                .id(domain.getId() != null ? domain.getId().toString() : null)
                .worldId(domain.getWorldId() != null ? domain.getWorldId().toString() : null)
                .ownerId(domain.getOwnerId() != null ? domain.getOwnerId().toString() : null)
                .members(toMemberDocuments(domain.getMembers()))
                .isPublic(domain.isPublic())
                .requiresApproval(domain.isRequiresApproval())
                .maxMembers(domain.getMaxMembers())
                .settings(domain.getSettings())
                .createdAt(domain.getCreatedAt())
                .updatedAt(domain.getUpdatedAt())
                .build();
    }

    public WorldAccessControl toDomain(WorldAccessControlDocument document) {
        if (document == null) {
            return null;
        }

        return WorldAccessControl.builder()
                .id(document.getId() != null ? UUID.fromString(document.getId()) : null)
                .worldId(document.getWorldId() != null ? UUID.fromString(document.getWorldId()) : null)
                .ownerId(document.getOwnerId() != null ? UUID.fromString(document.getOwnerId()) : null)
                .members(toMemberDomains(document.getMembers()))
                .isPublic(document.isPublic())
                .requiresApproval(document.isRequiresApproval())
                .maxMembers(document.getMaxMembers())
                .settings(document.getSettings() != null ? new HashMap<>(document.getSettings()) : new HashMap<>())
                .createdAt(document.getCreatedAt())
                .updatedAt(document.getUpdatedAt())
                .build();
    }

    private List<WorldMemberDocument> toMemberDocuments(List<WorldMember> members) {
        if (members == null) {
            return new ArrayList<>();
        }
        return members.stream()
                .map(this::toMemberDocument)
                .collect(Collectors.toList());
    }

    private WorldMemberDocument toMemberDocument(WorldMember member) {
        if (member == null) {
            return null;
        }

        Set<String> permissionCodes = null;
        if (member.getAdditionalPermissions() != null) {
            permissionCodes = member.getAdditionalPermissions().stream()
                    .map(WorldPermission::getCode)
                    .collect(Collectors.toSet());
        }

        return WorldMemberDocument.builder()
                .userId(member.getUserId() != null ? member.getUserId().toString() : null)
                .role(member.getRole() != null ? member.getRole().getCode() : null)
                .status(member.getStatus() != null ? member.getStatus().getCode() : null)
                .additionalPermissions(permissionCodes)
                .grantedBy(member.getGrantedBy() != null ? member.getGrantedBy().toString() : null)
                .grantedAt(member.getGrantedAt())
                .expiresAt(member.getExpiresAt())
                .lastAccessAt(member.getLastAccessAt())
                .invitationToken(member.getInvitationToken())
                .build();
    }

    private List<WorldMember> toMemberDomains(List<WorldMemberDocument> documents) {
        if (documents == null) {
            return new ArrayList<>();
        }
        return documents.stream()
                .map(this::toMemberDomain)
                .collect(Collectors.toList());
    }

    private WorldMember toMemberDomain(WorldMemberDocument document) {
        if (document == null) {
            return null;
        }

        Set<WorldPermission> permissions = new HashSet<>();
        if (document.getAdditionalPermissions() != null) {
            for (String code : document.getAdditionalPermissions()) {
                try {
                    permissions.add(WorldPermission.fromCode(code));
                } catch (IllegalArgumentException e) {
                    // Skip unknown permissions
                }
            }
        }

        return WorldMember.builder()
                .userId(document.getUserId() != null ? UUID.fromString(document.getUserId()) : null)
                .role(document.getRole() != null ? WorldRole.fromCode(document.getRole()) : null)
                .status(document.getStatus() != null ? MembershipStatus.fromCode(document.getStatus()) : null)
                .additionalPermissions(permissions)
                .grantedBy(document.getGrantedBy() != null ? UUID.fromString(document.getGrantedBy()) : null)
                .grantedAt(document.getGrantedAt())
                .expiresAt(document.getExpiresAt())
                .lastAccessAt(document.getLastAccessAt())
                .invitationToken(document.getInvitationToken())
                .build();
    }
}
