package com.ffl.playoffs.domain.model.accesscontrol;

import lombok.*;

import java.time.Instant;
import java.util.HashSet;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;

/**
 * Represents a member's access to a world.
 * This is a value object that captures the relationship between a user and a world.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WorldMember {
    private UUID userId;
    private WorldRole role;
    private MembershipStatus status;
    private Set<WorldPermission> additionalPermissions;
    private UUID grantedBy;
    private Instant grantedAt;
    private Instant expiresAt;
    private Instant lastAccessAt;
    private String invitationToken;

    /**
     * Create a new world member with the specified role.
     */
    public static WorldMember create(UUID userId, WorldRole role, UUID grantedBy) {
        Objects.requireNonNull(userId, "User ID is required");
        Objects.requireNonNull(role, "Role is required");
        Objects.requireNonNull(grantedBy, "Granted by is required");

        WorldMember member = new WorldMember();
        member.userId = userId;
        member.role = role;
        member.status = MembershipStatus.PENDING;
        member.additionalPermissions = new HashSet<>();
        member.grantedBy = grantedBy;
        member.grantedAt = Instant.now();
        member.invitationToken = UUID.randomUUID().toString();

        return member;
    }

    /**
     * Create an owner member (automatically active).
     */
    public static WorldMember createOwner(UUID userId) {
        Objects.requireNonNull(userId, "User ID is required");

        WorldMember member = new WorldMember();
        member.userId = userId;
        member.role = WorldRole.OWNER;
        member.status = MembershipStatus.ACTIVE;
        member.additionalPermissions = new HashSet<>();
        member.grantedBy = userId; // Self-granted for owner
        member.grantedAt = Instant.now();
        member.lastAccessAt = Instant.now();

        return member;
    }

    /**
     * Activate the membership (accept invitation).
     */
    public void activate() {
        if (!status.canActivate()) {
            throw new IllegalStateException("Cannot activate membership in status: " + status);
        }
        this.status = MembershipStatus.ACTIVE;
        this.lastAccessAt = Instant.now();
        this.invitationToken = null; // Clear invitation token
    }

    /**
     * Suspend the membership.
     */
    public void suspend() {
        if (status != MembershipStatus.ACTIVE) {
            throw new IllegalStateException("Cannot suspend membership in status: " + status);
        }
        if (role == WorldRole.OWNER) {
            throw new IllegalStateException("Cannot suspend owner membership");
        }
        this.status = MembershipStatus.SUSPENDED;
    }

    /**
     * Revoke the membership.
     */
    public void revoke() {
        if (role == WorldRole.OWNER) {
            throw new IllegalStateException("Cannot revoke owner membership");
        }
        this.status = MembershipStatus.REVOKED;
    }

    /**
     * Decline the invitation.
     */
    public void decline() {
        if (status != MembershipStatus.PENDING) {
            throw new IllegalStateException("Can only decline pending invitations");
        }
        this.status = MembershipStatus.DECLINED;
        this.invitationToken = null;
    }

    /**
     * Update the role of this member.
     */
    public void updateRole(WorldRole newRole, UUID updatedBy) {
        if (this.role == WorldRole.OWNER) {
            throw new IllegalStateException("Cannot change owner role directly; use transfer ownership");
        }
        if (newRole == WorldRole.OWNER) {
            throw new IllegalStateException("Cannot promote to owner; use transfer ownership");
        }
        this.role = newRole;
    }

    /**
     * Add an additional permission to this member.
     */
    public void addPermission(WorldPermission permission) {
        if (additionalPermissions == null) {
            additionalPermissions = new HashSet<>();
        }
        additionalPermissions.add(permission);
    }

    /**
     * Remove an additional permission from this member.
     */
    public void removePermission(WorldPermission permission) {
        if (additionalPermissions != null) {
            additionalPermissions.remove(permission);
        }
    }

    /**
     * Check if this member has a specific permission.
     * Considers both role-based and additional permissions.
     */
    public boolean hasPermission(WorldPermission permission) {
        if (!status.hasAccess()) {
            return false;
        }

        // Check role-based permissions
        Set<WorldPermission> rolePermissions = WorldPermission.getPermissionsForRole(role);
        if (rolePermissions.contains(permission)) {
            return true;
        }

        // Check additional permissions
        return additionalPermissions != null && additionalPermissions.contains(permission);
    }

    /**
     * Get all effective permissions for this member.
     */
    public Set<WorldPermission> getEffectivePermissions() {
        if (!status.hasAccess()) {
            return Set.of();
        }

        Set<WorldPermission> permissions = new HashSet<>(WorldPermission.getPermissionsForRole(role));
        if (additionalPermissions != null) {
            permissions.addAll(additionalPermissions);
        }
        return permissions;
    }

    /**
     * Check if this member has access (active status and not expired).
     */
    public boolean hasAccess() {
        if (!status.hasAccess()) {
            return false;
        }
        if (expiresAt != null && Instant.now().isAfter(expiresAt)) {
            return false;
        }
        return true;
    }

    /**
     * Update last access time.
     */
    public void recordAccess() {
        this.lastAccessAt = Instant.now();
    }

    /**
     * Check if membership is expired.
     */
    public boolean isExpired() {
        return expiresAt != null && Instant.now().isAfter(expiresAt);
    }

    /**
     * Set expiration for this membership.
     */
    public void setExpiration(Instant expiresAt) {
        this.expiresAt = expiresAt;
    }

    /**
     * Clear expiration (make permanent).
     */
    public void clearExpiration() {
        this.expiresAt = null;
    }
}
