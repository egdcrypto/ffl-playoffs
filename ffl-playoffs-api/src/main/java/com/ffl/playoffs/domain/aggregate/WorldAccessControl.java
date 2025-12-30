package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.accesscontrol.*;
import lombok.*;

import java.time.Instant;
import java.util.*;

/**
 * Aggregate root for managing access control for a world.
 * This aggregate tracks ownership, members, and permissions.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class WorldAccessControl {
    private UUID id;
    private UUID worldId;
    private UUID ownerId;
    private List<WorldMember> members;
    private boolean isPublic;
    private boolean requiresApproval;
    private Integer maxMembers;
    private Map<String, String> settings;
    private Instant createdAt;
    private Instant updatedAt;

    /**
     * Create a new world access control aggregate.
     */
    public static WorldAccessControl create(UUID worldId, UUID ownerId) {
        Objects.requireNonNull(worldId, "World ID is required");
        Objects.requireNonNull(ownerId, "Owner ID is required");

        WorldAccessControl accessControl = new WorldAccessControl();
        accessControl.id = UUID.randomUUID();
        accessControl.worldId = worldId;
        accessControl.ownerId = ownerId;
        accessControl.members = new ArrayList<>();
        accessControl.isPublic = false;
        accessControl.requiresApproval = true;
        accessControl.settings = new HashMap<>();
        accessControl.createdAt = Instant.now();
        accessControl.updatedAt = Instant.now();

        // Add owner as first member
        WorldMember ownerMember = WorldMember.createOwner(ownerId);
        accessControl.members.add(ownerMember);

        return accessControl;
    }

    /**
     * Add a new member with the specified role.
     */
    public WorldMember addMember(UUID userId, WorldRole role, UUID grantedBy) {
        Objects.requireNonNull(userId, "User ID is required");
        Objects.requireNonNull(role, "Role is required");
        Objects.requireNonNull(grantedBy, "Granted by is required");

        // Cannot add owner role
        if (role == WorldRole.OWNER) {
            throw new IllegalArgumentException("Cannot add member as owner; use transfer ownership");
        }

        // Check if user is already a member
        if (isMember(userId)) {
            throw new IllegalStateException("User is already a member of this world");
        }

        // Verify granter has permission
        WorldMember granter = getMember(grantedBy)
                .orElseThrow(() -> new IllegalArgumentException("Granter is not a member"));
        if (!granter.getRole().canGrantRole(role)) {
            throw new IllegalStateException("Granter does not have permission to grant this role");
        }

        // Check max members limit
        if (maxMembers != null && getActiveMembers().size() >= maxMembers) {
            throw new IllegalStateException("Maximum member limit reached");
        }

        WorldMember member = WorldMember.create(userId, role, grantedBy);
        members.add(member);
        this.updatedAt = Instant.now();

        return member;
    }

    /**
     * Remove a member from the world.
     */
    public void removeMember(UUID userId, UUID removedBy) {
        Objects.requireNonNull(userId, "User ID is required");
        Objects.requireNonNull(removedBy, "Removed by is required");

        WorldMember member = getMember(userId)
                .orElseThrow(() -> new IllegalArgumentException("User is not a member"));

        // Cannot remove owner
        if (member.getRole() == WorldRole.OWNER) {
            throw new IllegalStateException("Cannot remove owner; use transfer ownership first");
        }

        // Verify remover has permission
        if (!userId.equals(removedBy)) { // User can remove themselves
            WorldMember remover = getMember(removedBy)
                    .orElseThrow(() -> new IllegalArgumentException("Remover is not a member"));
            if (!remover.hasPermission(WorldPermission.REMOVE_MEMBERS)) {
                throw new IllegalStateException("Remover does not have permission to remove members");
            }
            // Cannot remove someone of same or higher role
            if (member.getRole().getLevel() >= remover.getRole().getLevel()) {
                throw new IllegalStateException("Cannot remove member with same or higher role");
            }
        }

        member.revoke();
        this.updatedAt = Instant.now();
    }

    /**
     * Update a member's role.
     */
    public void updateMemberRole(UUID userId, WorldRole newRole, UUID updatedBy) {
        Objects.requireNonNull(userId, "User ID is required");
        Objects.requireNonNull(newRole, "New role is required");
        Objects.requireNonNull(updatedBy, "Updated by is required");

        WorldMember member = getMember(userId)
                .orElseThrow(() -> new IllegalArgumentException("User is not a member"));

        WorldMember updater = getMember(updatedBy)
                .orElseThrow(() -> new IllegalArgumentException("Updater is not a member"));

        if (!updater.hasPermission(WorldPermission.CHANGE_MEMBER_ROLES)) {
            throw new IllegalStateException("Updater does not have permission to change roles");
        }

        if (!updater.getRole().canGrantRole(newRole)) {
            throw new IllegalStateException("Cannot grant role higher than own role");
        }

        member.updateRole(newRole, updatedBy);
        this.updatedAt = Instant.now();
    }

    /**
     * Transfer ownership to another member.
     */
    public void transferOwnership(UUID newOwnerId, UUID currentOwnerId) {
        Objects.requireNonNull(newOwnerId, "New owner ID is required");
        Objects.requireNonNull(currentOwnerId, "Current owner ID is required");

        // Verify current owner
        if (!this.ownerId.equals(currentOwnerId)) {
            throw new IllegalStateException("Only the current owner can transfer ownership");
        }

        // Get current owner member
        WorldMember currentOwner = getMember(currentOwnerId)
                .orElseThrow(() -> new IllegalStateException("Current owner not found in members"));

        // Get or create new owner member
        WorldMember newOwner = getMember(newOwnerId).orElse(null);
        if (newOwner == null) {
            // Add new owner as member first
            newOwner = WorldMember.create(newOwnerId, WorldRole.ADMIN, currentOwnerId);
            newOwner.activate();
            members.add(newOwner);
        }

        // Update roles
        currentOwner.updateRole(WorldRole.ADMIN, currentOwnerId); // Demote to admin
        // Set new owner manually since updateRole doesn't allow OWNER
        newOwner.setRole(WorldRole.OWNER);
        newOwner.setStatus(MembershipStatus.ACTIVE);

        this.ownerId = newOwnerId;
        this.updatedAt = Instant.now();
    }

    /**
     * Accept an invitation.
     */
    public void acceptInvitation(UUID userId, String invitationToken) {
        Objects.requireNonNull(userId, "User ID is required");
        Objects.requireNonNull(invitationToken, "Invitation token is required");

        WorldMember member = getMember(userId)
                .orElseThrow(() -> new IllegalArgumentException("User is not invited to this world"));

        if (!invitationToken.equals(member.getInvitationToken())) {
            throw new IllegalArgumentException("Invalid invitation token");
        }

        member.activate();
        this.updatedAt = Instant.now();
    }

    /**
     * Decline an invitation.
     */
    public void declineInvitation(UUID userId) {
        Objects.requireNonNull(userId, "User ID is required");

        WorldMember member = getMember(userId)
                .orElseThrow(() -> new IllegalArgumentException("User is not invited to this world"));

        member.decline();
        this.updatedAt = Instant.now();
    }

    /**
     * Check if a user has a specific permission.
     */
    public boolean hasPermission(UUID userId, WorldPermission permission) {
        return getMember(userId)
                .map(m -> m.hasPermission(permission))
                .orElse(false);
    }

    /**
     * Check if a user is a member (any status).
     */
    public boolean isMember(UUID userId) {
        return getMember(userId).isPresent();
    }

    /**
     * Check if a user has active access.
     */
    public boolean hasAccess(UUID userId) {
        return getMember(userId)
                .map(WorldMember::hasAccess)
                .orElse(false);
    }

    /**
     * Check if a user is the owner.
     */
    public boolean isOwner(UUID userId) {
        return this.ownerId.equals(userId);
    }

    /**
     * Get a member by user ID.
     */
    public Optional<WorldMember> getMember(UUID userId) {
        if (members == null) {
            return Optional.empty();
        }
        return members.stream()
                .filter(m -> m.getUserId().equals(userId))
                .findFirst();
    }

    /**
     * Get all active members.
     */
    public List<WorldMember> getActiveMembers() {
        if (members == null) {
            return Collections.emptyList();
        }
        return members.stream()
                .filter(WorldMember::hasAccess)
                .toList();
    }

    /**
     * Get members by role.
     */
    public List<WorldMember> getMembersByRole(WorldRole role) {
        if (members == null) {
            return Collections.emptyList();
        }
        return members.stream()
                .filter(m -> m.getRole() == role)
                .toList();
    }

    /**
     * Get members by status.
     */
    public List<WorldMember> getMembersByStatus(MembershipStatus status) {
        if (members == null) {
            return Collections.emptyList();
        }
        return members.stream()
                .filter(m -> m.getStatus() == status)
                .toList();
    }

    /**
     * Get pending invitations.
     */
    public List<WorldMember> getPendingInvitations() {
        return getMembersByStatus(MembershipStatus.PENDING);
    }

    /**
     * Get the count of active members.
     */
    public int getActiveMemberCount() {
        return getActiveMembers().size();
    }

    /**
     * Set whether the world is public.
     */
    public void setPublic(boolean isPublic, UUID updatedBy) {
        if (!hasPermission(updatedBy, WorldPermission.MODIFY_SETTINGS)) {
            throw new IllegalStateException("User does not have permission to modify settings");
        }
        this.isPublic = isPublic;
        this.updatedAt = Instant.now();
    }

    /**
     * Set whether membership requires approval.
     */
    public void setRequiresApproval(boolean requiresApproval, UUID updatedBy) {
        if (!hasPermission(updatedBy, WorldPermission.MODIFY_SETTINGS)) {
            throw new IllegalStateException("User does not have permission to modify settings");
        }
        this.requiresApproval = requiresApproval;
        this.updatedAt = Instant.now();
    }

    /**
     * Set maximum members limit.
     */
    public void setMaxMembers(Integer maxMembers, UUID updatedBy) {
        if (!hasPermission(updatedBy, WorldPermission.MODIFY_SETTINGS)) {
            throw new IllegalStateException("User does not have permission to modify settings");
        }
        if (maxMembers != null && maxMembers < getActiveMemberCount()) {
            throw new IllegalArgumentException("Max members cannot be less than current active member count");
        }
        this.maxMembers = maxMembers;
        this.updatedAt = Instant.now();
    }

    /**
     * Set a custom setting.
     */
    public void setSetting(String key, String value, UUID updatedBy) {
        if (!hasPermission(updatedBy, WorldPermission.MODIFY_SETTINGS)) {
            throw new IllegalStateException("User does not have permission to modify settings");
        }
        if (settings == null) {
            settings = new HashMap<>();
        }
        settings.put(key, value);
        this.updatedAt = Instant.now();
    }

    /**
     * Get a custom setting.
     */
    public Optional<String> getSetting(String key) {
        if (settings == null) {
            return Optional.empty();
        }
        return Optional.ofNullable(settings.get(key));
    }

    /**
     * Grant additional permission to a member.
     */
    public void grantAdditionalPermission(UUID userId, WorldPermission permission, UUID grantedBy) {
        if (!hasPermission(grantedBy, WorldPermission.MANAGE_ACCESS)) {
            throw new IllegalStateException("User does not have permission to manage access");
        }

        WorldMember member = getMember(userId)
                .orElseThrow(() -> new IllegalArgumentException("User is not a member"));

        member.addPermission(permission);
        this.updatedAt = Instant.now();
    }

    /**
     * Revoke additional permission from a member.
     */
    public void revokeAdditionalPermission(UUID userId, WorldPermission permission, UUID revokedBy) {
        if (!hasPermission(revokedBy, WorldPermission.MANAGE_ACCESS)) {
            throw new IllegalStateException("User does not have permission to manage access");
        }

        WorldMember member = getMember(userId)
                .orElseThrow(() -> new IllegalArgumentException("User is not a member"));

        member.removePermission(permission);
        this.updatedAt = Instant.now();
    }
}
