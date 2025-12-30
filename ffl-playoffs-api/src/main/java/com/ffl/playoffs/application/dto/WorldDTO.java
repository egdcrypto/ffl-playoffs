package com.ffl.playoffs.application.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Min;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Data Transfer Object for World entity.
 * Used for REST API requests and responses.
 */
public class WorldDTO {

    private UUID id;

    @NotBlank(message = "World name is required")
    private String name;

    private String description;

    @NotNull(message = "Owner ID is required")
    private UUID ownerId;

    private String narrativeSource;

    private String status;

    private Boolean isPublic;

    @Min(value = 1, message = "Max players must be at least 1")
    private Integer maxPlayers;

    private Boolean isDeployed;
    private LocalDateTime deployedAt;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public WorldDTO() {
    }

    // Getters and Setters

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
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
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
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
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
}
