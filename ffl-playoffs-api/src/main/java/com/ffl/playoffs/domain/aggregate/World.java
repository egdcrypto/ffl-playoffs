package com.ffl.playoffs.domain.aggregate;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * World aggregate - represents a playable narrative world.
 * Domain model with no framework dependencies.
 *
 * A World contains narrative content, era profiles, characters,
 * and other elements that make up an interactive experience.
 */
public class World {
    private UUID id;
    private String name;
    private String description;
    private UUID ownerId;
    private String narrativeSource;  // Source material (e.g., "Romeo and Juliet")

    // World status
    private WorldStatus status;

    // World configuration
    private Boolean isPublic;
    private Integer maxPlayers;

    // Deployment status
    private Boolean isDeployed;
    private LocalDateTime deployedAt;

    // Metadata
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    /**
     * Default constructor initializing a new world
     */
    public World() {
        this.id = UUID.randomUUID();
        this.status = WorldStatus.DRAFT;
        this.isPublic = false;
        this.isDeployed = false;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Constructor with essential parameters
     */
    public World(String name, UUID ownerId) {
        this();
        this.name = name;
        this.ownerId = ownerId;
    }

    // ==================== Business Methods ====================

    /**
     * Publishes the world for curation review
     */
    public void submitForReview() {
        if (this.status != WorldStatus.DRAFT) {
            throw new IllegalStateException("Only DRAFT worlds can be submitted for review");
        }
        this.status = WorldStatus.PENDING_REVIEW;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Approves the world after review
     */
    public void approve() {
        if (this.status != WorldStatus.PENDING_REVIEW) {
            throw new IllegalStateException("Only worlds PENDING_REVIEW can be approved");
        }
        this.status = WorldStatus.APPROVED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Rejects the world, returning it to draft
     */
    public void reject() {
        if (this.status != WorldStatus.PENDING_REVIEW) {
            throw new IllegalStateException("Only worlds PENDING_REVIEW can be rejected");
        }
        this.status = WorldStatus.DRAFT;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Deploys the world for players
     */
    public void deploy() {
        if (this.status != WorldStatus.APPROVED) {
            throw new IllegalStateException("Only APPROVED worlds can be deployed");
        }
        this.status = WorldStatus.DEPLOYED;
        this.isDeployed = true;
        this.deployedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Takes the world offline
     */
    public void undeploy() {
        if (this.status != WorldStatus.DEPLOYED) {
            throw new IllegalStateException("Only DEPLOYED worlds can be undeployed");
        }
        this.status = WorldStatus.APPROVED;
        this.isDeployed = false;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Archives the world
     */
    public void archive() {
        if (this.status == WorldStatus.ARCHIVED) {
            throw new IllegalStateException("World is already archived");
        }
        if (this.status == WorldStatus.DEPLOYED) {
            throw new IllegalStateException("Cannot archive a deployed world. Undeploy first.");
        }
        this.status = WorldStatus.ARCHIVED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Makes the world public
     */
    public void makePublic() {
        this.isPublic = true;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Makes the world private
     */
    public void makePrivate() {
        this.isPublic = false;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Checks if the world can be edited
     */
    public boolean canEdit() {
        return this.status == WorldStatus.DRAFT || this.status == WorldStatus.APPROVED;
    }

    /**
     * Checks if the world can be deleted
     */
    public boolean canDelete() {
        return this.status == WorldStatus.DRAFT;
    }

    // ==================== Getters and Setters ====================

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
        this.updatedAt = LocalDateTime.now();
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
        this.updatedAt = LocalDateTime.now();
    }

    public UUID getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(UUID ownerId) {
        this.ownerId = ownerId;
    }

    public String getNarrativeSource() {
        return narrativeSource;
    }

    public void setNarrativeSource(String narrativeSource) {
        this.narrativeSource = narrativeSource;
        this.updatedAt = LocalDateTime.now();
    }

    public WorldStatus getStatus() {
        return status;
    }

    public void setStatus(WorldStatus status) {
        this.status = status;
    }

    public Boolean getIsPublic() {
        return isPublic;
    }

    public void setIsPublic(Boolean isPublic) {
        this.isPublic = isPublic;
    }

    public Integer getMaxPlayers() {
        return maxPlayers;
    }

    public void setMaxPlayers(Integer maxPlayers) {
        this.maxPlayers = maxPlayers;
        this.updatedAt = LocalDateTime.now();
    }

    public Boolean getIsDeployed() {
        return isDeployed;
    }

    public void setIsDeployed(Boolean isDeployed) {
        this.isDeployed = isDeployed;
    }

    public LocalDateTime getDeployedAt() {
        return deployedAt;
    }

    public void setDeployedAt(LocalDateTime deployedAt) {
        this.deployedAt = deployedAt;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    // ==================== Enums ====================

    /**
     * Status of a world in its lifecycle
     */
    public enum WorldStatus {
        DRAFT,
        PENDING_REVIEW,
        APPROVED,
        DEPLOYED,
        ARCHIVED
    }

    @Override
    public String toString() {
        return String.format(
            "World{id=%s, name='%s', owner=%s, status=%s, public=%s, deployed=%s}",
            id, name, ownerId, status, isPublic, isDeployed
        );
    }
}
