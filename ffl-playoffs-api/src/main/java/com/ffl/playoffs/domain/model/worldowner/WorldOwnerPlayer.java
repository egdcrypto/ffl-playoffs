package com.ffl.playoffs.domain.model.worldowner;

import lombok.*;

import java.time.Instant;
import java.util.*;

/**
 * Represents a player who has ownership/management role in a World.
 * This is the junction entity between User and World for ownership purposes.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WorldOwnerPlayer {
    private UUID id;
    private UUID userId;
    private UUID worldId;
    private OwnershipRole role;
    private OwnershipStatus status;
    private Set<WorldOwnerPermission> permissions;
    private UUID grantedBy;
    private Instant grantedAt;
    private Instant joinedAt;
    private Instant lastActiveAt;
    private String invitationToken;
    private Instant invitationExpiresAt;
    private Instant createdAt;
    private Instant updatedAt;

    /**
     * Create a new world owner player with an invitation.
     */
    public static WorldOwnerPlayer createInvitation(UUID userId, UUID worldId, OwnershipRole role, UUID grantedBy) {
        Objects.requireNonNull(userId, "User ID is required");
        Objects.requireNonNull(worldId, "World ID is required");
        Objects.requireNonNull(role, "Role is required");
        Objects.requireNonNull(grantedBy, "Granted by is required");

        if (role == OwnershipRole.PRIMARY_OWNER) {
            throw new IllegalArgumentException("Cannot invite as PRIMARY_OWNER; use createPrimaryOwner instead");
        }

        WorldOwnerPlayer player = new WorldOwnerPlayer();
        player.id = UUID.randomUUID();
        player.userId = userId;
        player.worldId = worldId;
        player.role = role;
        player.status = OwnershipStatus.INVITED;
        player.permissions = new HashSet<>(WorldOwnerPermission.getPermissionsForRole(role));
        player.grantedBy = grantedBy;
        player.grantedAt = Instant.now();
        player.invitationToken = UUID.randomUUID().toString();
        player.invitationExpiresAt = Instant.now().plusSeconds(7 * 24 * 60 * 60); // 7 days
        player.createdAt = Instant.now();
        player.updatedAt = Instant.now();

        return player;
    }

    /**
     * Create a primary owner (typically when creating a new world).
     */
    public static WorldOwnerPlayer createPrimaryOwner(UUID userId, UUID worldId) {
        Objects.requireNonNull(userId, "User ID is required");
        Objects.requireNonNull(worldId, "World ID is required");

        WorldOwnerPlayer player = new WorldOwnerPlayer();
        player.id = UUID.randomUUID();
        player.userId = userId;
        player.worldId = worldId;
        player.role = OwnershipRole.PRIMARY_OWNER;
        player.status = OwnershipStatus.ACTIVE;
        player.permissions = new HashSet<>(WorldOwnerPermission.getPermissionsForRole(OwnershipRole.PRIMARY_OWNER));
        player.grantedBy = userId; // Self-granted for initial owner
        player.grantedAt = Instant.now();
        player.joinedAt = Instant.now();
        player.lastActiveAt = Instant.now();
        player.createdAt = Instant.now();
        player.updatedAt = Instant.now();

        return player;
    }

    /**
     * Accept the invitation.
     */
    public void acceptInvitation(String token) {
        Objects.requireNonNull(token, "Token is required");

        if (status != OwnershipStatus.INVITED) {
            throw new IllegalStateException("Cannot accept invitation in status: " + status);
        }

        if (!token.equals(this.invitationToken)) {
            throw new IllegalArgumentException("Invalid invitation token");
        }

        if (invitationExpiresAt != null && Instant.now().isAfter(invitationExpiresAt)) {
            throw new IllegalStateException("Invitation has expired");
        }

        this.status = OwnershipStatus.ACTIVE;
        this.joinedAt = Instant.now();
        this.lastActiveAt = Instant.now();
        this.invitationToken = null;
        this.invitationExpiresAt = null;
        this.updatedAt = Instant.now();
    }

    /**
     * Decline the invitation.
     */
    public void declineInvitation() {
        if (status != OwnershipStatus.INVITED) {
            throw new IllegalStateException("Cannot decline invitation in status: " + status);
        }

        this.status = OwnershipStatus.DECLINED;
        this.invitationToken = null;
        this.invitationExpiresAt = null;
        this.updatedAt = Instant.now();
    }

    /**
     * Deactivate the owner.
     */
    public void deactivate() {
        if (status != OwnershipStatus.ACTIVE) {
            throw new IllegalStateException("Cannot deactivate owner in status: " + status);
        }

        if (role == OwnershipRole.PRIMARY_OWNER) {
            throw new IllegalStateException("Cannot deactivate PRIMARY_OWNER; transfer ownership first");
        }

        this.status = OwnershipStatus.INACTIVE;
        this.updatedAt = Instant.now();
    }

    /**
     * Reactivate the owner.
     */
    public void reactivate() {
        if (!status.canReactivate()) {
            throw new IllegalStateException("Cannot reactivate owner in status: " + status);
        }

        this.status = OwnershipStatus.ACTIVE;
        this.lastActiveAt = Instant.now();
        this.updatedAt = Instant.now();
    }

    /**
     * Remove the owner.
     */
    public void remove() {
        if (role == OwnershipRole.PRIMARY_OWNER) {
            throw new IllegalStateException("Cannot remove PRIMARY_OWNER; transfer ownership first");
        }

        this.status = OwnershipStatus.REMOVED;
        this.permissions.clear();
        this.updatedAt = Instant.now();
    }

    /**
     * Update the ownership role.
     */
    public void updateRole(OwnershipRole newRole) {
        Objects.requireNonNull(newRole, "New role is required");

        if (this.role == OwnershipRole.PRIMARY_OWNER && newRole != OwnershipRole.PRIMARY_OWNER) {
            throw new IllegalStateException("Cannot demote PRIMARY_OWNER; use transfer ownership");
        }

        if (newRole == OwnershipRole.PRIMARY_OWNER && this.role != OwnershipRole.PRIMARY_OWNER) {
            throw new IllegalStateException("Cannot promote to PRIMARY_OWNER; use transfer ownership");
        }

        this.role = newRole;
        // Update permissions based on new role
        this.permissions = new HashSet<>(WorldOwnerPermission.getPermissionsForRole(newRole));
        this.updatedAt = Instant.now();
    }

    /**
     * Promote to primary owner (used during ownership transfer).
     */
    public void promoteToPrimaryOwner() {
        if (status != OwnershipStatus.ACTIVE) {
            throw new IllegalStateException("Can only promote active owners to PRIMARY_OWNER");
        }

        this.role = OwnershipRole.PRIMARY_OWNER;
        this.permissions = new HashSet<>(WorldOwnerPermission.getPermissionsForRole(OwnershipRole.PRIMARY_OWNER));
        this.updatedAt = Instant.now();
    }

    /**
     * Demote from primary owner (used during ownership transfer).
     */
    public void demoteFromPrimaryOwner(OwnershipRole newRole) {
        if (this.role != OwnershipRole.PRIMARY_OWNER) {
            throw new IllegalStateException("Can only demote a PRIMARY_OWNER");
        }

        if (newRole == OwnershipRole.PRIMARY_OWNER) {
            throw new IllegalArgumentException("New role cannot be PRIMARY_OWNER");
        }

        this.role = newRole;
        this.permissions = new HashSet<>(WorldOwnerPermission.getPermissionsForRole(newRole));
        this.updatedAt = Instant.now();
    }

    /**
     * Grant an additional permission.
     */
    public void grantPermission(WorldOwnerPermission permission) {
        if (permissions == null) {
            permissions = new HashSet<>();
        }
        permissions.add(permission);
        this.updatedAt = Instant.now();
    }

    /**
     * Revoke a permission.
     */
    public void revokePermission(WorldOwnerPermission permission) {
        if (permissions != null) {
            permissions.remove(permission);
            this.updatedAt = Instant.now();
        }
    }

    /**
     * Check if this owner has a specific permission.
     */
    public boolean hasPermission(WorldOwnerPermission permission) {
        if (!isActive()) {
            return false;
        }
        return permissions != null && permissions.contains(permission);
    }

    /**
     * Check if this owner is currently active.
     */
    public boolean isActive() {
        return status == OwnershipStatus.ACTIVE;
    }

    /**
     * Check if this owner is the primary owner.
     */
    public boolean isPrimaryOwner() {
        return role == OwnershipRole.PRIMARY_OWNER;
    }

    /**
     * Update last active timestamp.
     */
    public void recordActivity() {
        this.lastActiveAt = Instant.now();
        this.updatedAt = Instant.now();
    }

    /**
     * Check if the invitation has expired.
     */
    public boolean isInvitationExpired() {
        return status == OwnershipStatus.INVITED &&
                invitationExpiresAt != null &&
                Instant.now().isAfter(invitationExpiresAt);
    }

    /**
     * Get all effective permissions.
     */
    public Set<WorldOwnerPermission> getEffectivePermissions() {
        if (!isActive()) {
            return Set.of();
        }
        return permissions != null ? new HashSet<>(permissions) : Set.of();
    }
}
