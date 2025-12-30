package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldAccessControl;
import com.ffl.playoffs.domain.model.accesscontrol.WorldMember;
import com.ffl.playoffs.domain.model.accesscontrol.WorldRole;
import com.ffl.playoffs.domain.port.WorldAccessControlRepository;
import lombok.Builder;
import lombok.Getter;

import java.time.Instant;
import java.util.UUID;

/**
 * Use case for adding a new member to a world.
 */
public class AddWorldMemberUseCase {

    private final WorldAccessControlRepository repository;

    public AddWorldMemberUseCase(WorldAccessControlRepository repository) {
        this.repository = repository;
    }

    /**
     * Adds a new member to a world.
     *
     * @param command The add member command
     * @return The created WorldMember
     * @throws IllegalArgumentException if world not found
     * @throws IllegalStateException if user already a member or granter lacks permission
     */
    public WorldMember execute(AddWorldMemberCommand command) {
        // Find the access control
        WorldAccessControl accessControl = repository.findByWorldId(command.getWorldId())
                .orElseThrow(() -> new IllegalArgumentException("World access control not found: " + command.getWorldId()));

        // Add member
        WorldMember member = accessControl.addMember(
                command.getUserId(),
                command.getRole(),
                command.getGrantedBy()
        );

        // Set optional expiration
        if (command.getExpiresAt() != null) {
            member.setExpiration(command.getExpiresAt());
        }

        // Save
        repository.save(accessControl);

        return member;
    }

    @Getter
    @Builder
    public static class AddWorldMemberCommand {
        private final UUID worldId;
        private final UUID userId;
        private final WorldRole role;
        private final UUID grantedBy;
        private final Instant expiresAt;
    }
}
