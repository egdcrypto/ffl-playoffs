package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.*;
import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.Instant;

/**
 * MongoDB document for Admin Invitation entity.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Document(collection = "admin_invitations")
public class AdminInvitationDocument {
    @Id
    private String id;

    @Indexed
    private String email;

    private String name;

    @Indexed
    private String invitedBy;

    @Indexed(unique = true, sparse = true)
    private String invitationToken;

    @Indexed
    private String status;

    private Instant expiresAt;
    private Instant createdAt;
    private Instant updatedAt;
    private Instant acceptedAt;
    private Instant revokedAt;
    private String acceptedUserId;
    private String revokeReason;
    private Integer resendCount;
}
