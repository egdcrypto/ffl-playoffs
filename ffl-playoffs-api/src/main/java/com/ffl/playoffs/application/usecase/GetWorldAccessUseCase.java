package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.domain.aggregate.WorldAccessControl;
import com.ffl.playoffs.domain.model.accesscontrol.WorldMember;
import com.ffl.playoffs.domain.model.accesscontrol.WorldPermission;
import com.ffl.playoffs.domain.port.WorldAccessControlRepository;
import lombok.Builder;
import lombok.Getter;

import java.util.List;
import java.util.Optional;
import java.util.Set;
import java.util.UUID;

/**
 * Use case for retrieving world access information.
 */
public class GetWorldAccessUseCase {

    private final WorldAccessControlRepository repository;

    public GetWorldAccessUseCase(WorldAccessControlRepository repository) {
        this.repository = repository;
    }

    /**
     * Get access control for a world.
     */
    public Optional<WorldAccessControl> getByWorldId(UUID worldId) {
        return repository.findByWorldId(worldId);
    }

    /**
     * Get all worlds a user has access to.
     */
    public List<WorldAccessControl> getWorldsForUser(UUID userId) {
        return repository.findByActiveMemberId(userId);
    }

    /**
     * Get all worlds owned by a user.
     */
    public List<WorldAccessControl> getOwnedWorlds(UUID ownerId) {
        return repository.findByOwnerId(ownerId);
    }

    /**
     * Get pending invitations for a user.
     */
    public List<WorldAccessControl> getPendingInvitations(UUID userId) {
        return repository.findWithPendingInvitationForUser(userId);
    }

    /**
     * Get public worlds.
     */
    public List<WorldAccessControl> getPublicWorlds() {
        return repository.findPublicWorlds();
    }

    /**
     * Check if a user has access to a world.
     */
    public boolean hasAccess(UUID worldId, UUID userId) {
        return repository.findByWorldId(worldId)
                .map(ac -> ac.hasAccess(userId))
                .orElse(false);
    }

    /**
     * Check if a user has a specific permission.
     */
    public boolean hasPermission(UUID worldId, UUID userId, WorldPermission permission) {
        return repository.findByWorldId(worldId)
                .map(ac -> ac.hasPermission(userId, permission))
                .orElse(false);
    }

    /**
     * Get a user's access summary for a world.
     */
    public Optional<UserAccessSummary> getUserAccessSummary(UUID worldId, UUID userId) {
        return repository.findByWorldId(worldId)
                .flatMap(ac -> ac.getMember(userId)
                        .map(member -> UserAccessSummary.builder()
                                .worldId(worldId)
                                .userId(userId)
                                .role(member.getRole())
                                .status(member.getStatus())
                                .permissions(member.getEffectivePermissions())
                                .hasAccess(member.hasAccess())
                                .isOwner(ac.isOwner(userId))
                                .build()));
    }

    @Getter
    @Builder
    public static class UserAccessSummary {
        private final UUID worldId;
        private final UUID userId;
        private final com.ffl.playoffs.domain.model.accesscontrol.WorldRole role;
        private final com.ffl.playoffs.domain.model.accesscontrol.MembershipStatus status;
        private final Set<WorldPermission> permissions;
        private final boolean hasAccess;
        private final boolean isOwner;
    }
}
