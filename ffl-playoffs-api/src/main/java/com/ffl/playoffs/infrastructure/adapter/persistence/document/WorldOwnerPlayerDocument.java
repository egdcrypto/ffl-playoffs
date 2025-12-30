package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.CompoundIndexes;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;
import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "world_owner_players")
@CompoundIndexes({
        @CompoundIndex(name = "user_world_idx", def = "{'userId': 1, 'worldId': 1}", unique = true),
        @CompoundIndex(name = "world_status_idx", def = "{'worldId': 1, 'status': 1}"),
        @CompoundIndex(name = "world_role_idx", def = "{'worldId': 1, 'role': 1}")
})
public class WorldOwnerPlayerDocument {
    @Id
    private String id;

    @Indexed
    private String userId;

    @Indexed
    private String worldId;

    private String role;
    private String status;
    private Set<String> permissions;
    private String grantedBy;
    private Instant grantedAt;
    private Instant joinedAt;
    private Instant lastActiveAt;

    @Indexed(sparse = true)
    private String invitationToken;
    private Instant invitationExpiresAt;

    private Instant createdAt;
    private Instant updatedAt;
}
