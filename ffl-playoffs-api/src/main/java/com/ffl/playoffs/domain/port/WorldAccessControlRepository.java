package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.WorldAccessControl;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository port for WorldAccessControl aggregate.
 */
public interface WorldAccessControlRepository {

    /**
     * Save a world access control aggregate.
     */
    WorldAccessControl save(WorldAccessControl accessControl);

    /**
     * Find by ID.
     */
    Optional<WorldAccessControl> findById(UUID id);

    /**
     * Find by world ID.
     */
    Optional<WorldAccessControl> findByWorldId(UUID worldId);

    /**
     * Find all worlds where a user is a member (any status).
     */
    List<WorldAccessControl> findByMemberId(UUID userId);

    /**
     * Find all worlds where a user has active access.
     */
    List<WorldAccessControl> findByActiveMemberId(UUID userId);

    /**
     * Find all worlds owned by a user.
     */
    List<WorldAccessControl> findByOwnerId(UUID ownerId);

    /**
     * Find public worlds.
     */
    List<WorldAccessControl> findPublicWorlds();

    /**
     * Find worlds with pending invitations for a user.
     */
    List<WorldAccessControl> findWithPendingInvitationForUser(UUID userId);

    /**
     * Delete by ID.
     */
    void deleteById(UUID id);

    /**
     * Delete by world ID.
     */
    void deleteByWorldId(UUID worldId);

    /**
     * Check if access control exists for a world.
     */
    boolean existsByWorldId(UUID worldId);
}
