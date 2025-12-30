package com.ffl.playoffs.infrastructure.persistence.mongodb.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;
import org.springframework.data.mongodb.core.mapping.Field;

import java.time.LocalDateTime;

/**
 * MongoDB document for authentication sessions.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "auth_sessions")
@CompoundIndex(name = "principal_active_idx", def = "{'principal_id': 1, 'active': 1}")
public class AuthSessionDocument {

    @Id
    private String id;

    @Field("principal_id")
    @Indexed
    private String principalId;

    @Field("authentication_type")
    @Indexed
    private String authenticationType;

    @Field("identifier")
    private String identifier;

    @Field("ip_address")
    private String ipAddress;

    @Field("user_agent")
    private String userAgent;

    @Field("created_at")
    @Indexed
    private LocalDateTime createdAt;

    @Field("expires_at")
    @Indexed
    private LocalDateTime expiresAt;

    @Field("last_activity_at")
    @Indexed
    private LocalDateTime lastActivityAt;

    @Field("active")
    @Indexed
    @Builder.Default
    private boolean active = true;

    @Field("termination_reason")
    private String terminationReason;

    @Field("terminated_at")
    private LocalDateTime terminatedAt;
}
