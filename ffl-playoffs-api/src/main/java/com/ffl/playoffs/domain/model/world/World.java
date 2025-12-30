package com.ffl.playoffs.domain.model.world;

import lombok.*;

import java.time.Instant;
import java.util.*;

/**
 * World entity - represents a container for fantasy football leagues and their owners.
 *
 * A World is a top-level organizational unit that can contain multiple leagues
 * and be managed by multiple owners with different roles.
 *
 * Domain model with no framework dependencies.
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class World {
    private UUID id;
    private String name;
    private String description;
    private String code; // Unique invite code
    private UUID primaryOwnerId; // The main owner who created the world
    private WorldStatus status;
    private WorldVisibility visibility;
    private WorldSettings settings;

    // Statistics
    private Integer leagueCount;
    private Integer ownerCount;
    private Integer memberCount;

    // Metadata
    private Instant createdAt;
    private Instant updatedAt;
    private Instant activatedAt;
    private Instant archivedAt;

    /**
     * Create a new World with default settings.
     */
    public static World create(String name, String code, UUID primaryOwnerId) {
        Objects.requireNonNull(name, "Name is required");
        Objects.requireNonNull(code, "Code is required");
        Objects.requireNonNull(primaryOwnerId, "Primary owner ID is required");

        if (name.isBlank()) {
            throw new IllegalArgumentException("Name cannot be blank");
        }
        if (code.isBlank()) {
            throw new IllegalArgumentException("Code cannot be blank");
        }

        World world = new World();
        world.id = UUID.randomUUID();
        world.name = name.trim();
        world.code = code.trim().toUpperCase();
        world.primaryOwnerId = primaryOwnerId;
        world.status = WorldStatus.DRAFT;
        world.visibility = WorldVisibility.PRIVATE;
        world.settings = WorldSettings.defaults();
        world.leagueCount = 0;
        world.ownerCount = 1; // Primary owner
        world.memberCount = 0;
        world.createdAt = Instant.now();
        world.updatedAt = Instant.now();

        return world;
    }

    /**
     * Activate the world.
     */
    public void activate() {
        if (!status.canActivate()) {
            throw new IllegalStateException("Cannot activate world in status: " + status);
        }

        this.status = WorldStatus.ACTIVE;
        this.activatedAt = Instant.now();
        this.updatedAt = Instant.now();
    }

    /**
     * Suspend the world.
     */
    public void suspend() {
        if (!status.canSuspend()) {
            throw new IllegalStateException("Cannot suspend world in status: " + status);
        }

        this.status = WorldStatus.SUSPENDED;
        this.updatedAt = Instant.now();
    }

    /**
     * Archive the world.
     */
    public void archive() {
        if (!status.canArchive()) {
            throw new IllegalStateException("Cannot archive world in status: " + status);
        }

        this.status = WorldStatus.ARCHIVED;
        this.archivedAt = Instant.now();
        this.updatedAt = Instant.now();
    }

    /**
     * Mark the world as deleted.
     */
    public void markDeleted() {
        if (status == WorldStatus.DELETED) {
            return; // Already deleted
        }

        this.status = WorldStatus.DELETED;
        this.updatedAt = Instant.now();
    }

    /**
     * Update the world's name.
     */
    public void updateName(String newName) {
        validateModifiable();
        Objects.requireNonNull(newName, "Name is required");
        if (newName.isBlank()) {
            throw new IllegalArgumentException("Name cannot be blank");
        }

        this.name = newName.trim();
        this.updatedAt = Instant.now();
    }

    /**
     * Update the world's description.
     */
    public void updateDescription(String newDescription) {
        validateModifiable();
        this.description = newDescription;
        this.updatedAt = Instant.now();
    }

    /**
     * Update the world's visibility.
     */
    public void updateVisibility(WorldVisibility newVisibility) {
        validateModifiable();
        Objects.requireNonNull(newVisibility, "Visibility is required");

        this.visibility = newVisibility;
        this.updatedAt = Instant.now();
    }

    /**
     * Update the world's settings.
     */
    public void updateSettings(WorldSettings newSettings) {
        validateModifiable();
        Objects.requireNonNull(newSettings, "Settings are required");
        newSettings.validate();

        this.settings = newSettings;
        this.updatedAt = Instant.now();
    }

    /**
     * Transfer primary ownership to a new owner.
     */
    public void transferPrimaryOwnership(UUID newPrimaryOwnerId) {
        Objects.requireNonNull(newPrimaryOwnerId, "New primary owner ID is required");

        if (status.isTerminal()) {
            throw new IllegalStateException("Cannot transfer ownership of a " + status + " world");
        }

        this.primaryOwnerId = newPrimaryOwnerId;
        this.updatedAt = Instant.now();
    }

    /**
     * Increment the league count.
     */
    public void incrementLeagueCount() {
        if (this.leagueCount == null) {
            this.leagueCount = 0;
        }
        this.leagueCount++;
        this.updatedAt = Instant.now();
    }

    /**
     * Decrement the league count.
     */
    public void decrementLeagueCount() {
        if (this.leagueCount != null && this.leagueCount > 0) {
            this.leagueCount--;
            this.updatedAt = Instant.now();
        }
    }

    /**
     * Update the owner count.
     */
    public void updateOwnerCount(int count) {
        if (count < 0) {
            throw new IllegalArgumentException("Owner count cannot be negative");
        }
        this.ownerCount = count;
        this.updatedAt = Instant.now();
    }

    /**
     * Update the member count.
     */
    public void updateMemberCount(int count) {
        if (count < 0) {
            throw new IllegalArgumentException("Member count cannot be negative");
        }
        this.memberCount = count;
        this.updatedAt = Instant.now();
    }

    /**
     * Check if the world is active and operational.
     */
    public boolean isActive() {
        return status == WorldStatus.ACTIVE;
    }

    /**
     * Check if the world is in draft status.
     */
    public boolean isDraft() {
        return status == WorldStatus.DRAFT;
    }

    /**
     * Check if the world has been archived.
     */
    public boolean isArchived() {
        return status == WorldStatus.ARCHIVED;
    }

    /**
     * Check if the world has been deleted.
     */
    public boolean isDeleted() {
        return status == WorldStatus.DELETED;
    }

    /**
     * Check if the given user is the primary owner.
     */
    public boolean isPrimaryOwner(UUID userId) {
        return primaryOwnerId != null && primaryOwnerId.equals(userId);
    }

    /**
     * Check if more leagues can be added.
     */
    public boolean canAddLeague() {
        return status.isOperational() &&
               settings != null &&
               settings.canAddLeague(leagueCount != null ? leagueCount : 0);
    }

    /**
     * Check if more owners can be added.
     */
    public boolean canAddOwner() {
        return !status.isTerminal() &&
               settings != null &&
               settings.canAddOwner(ownerCount != null ? ownerCount : 0);
    }

    /**
     * Check if more members can be added.
     */
    public boolean canAddMember() {
        return status.allowsNewMembers() &&
               settings != null &&
               settings.canAddMember(memberCount != null ? memberCount : 0);
    }

    /**
     * Validate that the world can be modified.
     */
    private void validateModifiable() {
        if (!status.isModifiable()) {
            throw new IllegalStateException("Cannot modify world in status: " + status);
        }
    }

    /**
     * Generate a new invite code.
     */
    public void regenerateCode() {
        validateModifiable();
        this.code = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        this.updatedAt = Instant.now();
    }

    @Override
    public String toString() {
        return String.format(
            "World{id=%s, name='%s', status=%s, visibility=%s, primaryOwner=%s, leagues=%d, owners=%d, members=%d}",
            id, name, status, visibility, primaryOwnerId,
            leagueCount != null ? leagueCount : 0,
            ownerCount != null ? ownerCount : 0,
            memberCount != null ? memberCount : 0
        );
    }
}
