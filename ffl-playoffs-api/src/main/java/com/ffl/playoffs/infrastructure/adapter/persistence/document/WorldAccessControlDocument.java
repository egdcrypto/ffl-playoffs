package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "world_access_controls")
public class WorldAccessControlDocument {
    @Id
    private String id;

    @Indexed(unique = true)
    private String worldId;

    @Indexed
    private String ownerId;

    private List<WorldMemberDocument> members;
    private boolean isPublic;
    private boolean requiresApproval;
    private Integer maxMembers;
    private Map<String, String> settings;
    private Instant createdAt;
    private Instant updatedAt;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class WorldMemberDocument {
        @Indexed
        private String userId;
        private String role;
        private String status;
        private Set<String> additionalPermissions;
        private String grantedBy;
        private Instant grantedAt;
        private Instant expiresAt;
        private Instant lastAccessAt;
        private String invitationToken;
    }
}
