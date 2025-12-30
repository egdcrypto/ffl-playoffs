package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

/**
 * MongoDB document for EraProfile entity.
 * Infrastructure layer persistence model.
 */
@Document(collection = "era_profiles")
public class EraProfileDocument {

    @Id
    private String id;

    private String name;
    private String description;

    @Indexed
    private String worldId;

    // Time period
    private Integer startYear;
    private Integer endYear;
    private String timePeriodLabel;

    // Technology configuration
    private String technologyLevel;

    // Curation status
    @Indexed
    private String status;
    private Boolean isLocked;
    private LocalDateTime lockedAt;
    private String lockReason;

    // Curation checklist
    private Boolean technologyApproved;
    private Boolean charactersValidated;
    private Boolean objectsValidated;
    private Boolean locationsValidated;
    private Boolean conflictsResolved;

    // Metadata
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @Indexed
    private String createdBy;

    public EraProfileDocument() {
    }

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
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

    public String getWorldId() {
        return worldId;
    }

    public void setWorldId(String worldId) {
        this.worldId = worldId;
    }

    public Integer getStartYear() {
        return startYear;
    }

    public void setStartYear(Integer startYear) {
        this.startYear = startYear;
    }

    public Integer getEndYear() {
        return endYear;
    }

    public void setEndYear(Integer endYear) {
        this.endYear = endYear;
    }

    public String getTimePeriodLabel() {
        return timePeriodLabel;
    }

    public void setTimePeriodLabel(String timePeriodLabel) {
        this.timePeriodLabel = timePeriodLabel;
    }

    public String getTechnologyLevel() {
        return technologyLevel;
    }

    public void setTechnologyLevel(String technologyLevel) {
        this.technologyLevel = technologyLevel;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Boolean getIsLocked() {
        return isLocked;
    }

    public void setIsLocked(Boolean isLocked) {
        this.isLocked = isLocked;
    }

    public LocalDateTime getLockedAt() {
        return lockedAt;
    }

    public void setLockedAt(LocalDateTime lockedAt) {
        this.lockedAt = lockedAt;
    }

    public String getLockReason() {
        return lockReason;
    }

    public void setLockReason(String lockReason) {
        this.lockReason = lockReason;
    }

    public Boolean getTechnologyApproved() {
        return technologyApproved;
    }

    public void setTechnologyApproved(Boolean technologyApproved) {
        this.technologyApproved = technologyApproved;
    }

    public Boolean getCharactersValidated() {
        return charactersValidated;
    }

    public void setCharactersValidated(Boolean charactersValidated) {
        this.charactersValidated = charactersValidated;
    }

    public Boolean getObjectsValidated() {
        return objectsValidated;
    }

    public void setObjectsValidated(Boolean objectsValidated) {
        this.objectsValidated = objectsValidated;
    }

    public Boolean getLocationsValidated() {
        return locationsValidated;
    }

    public void setLocationsValidated(Boolean locationsValidated) {
        this.locationsValidated = locationsValidated;
    }

    public Boolean getConflictsResolved() {
        return conflictsResolved;
    }

    public void setConflictsResolved(Boolean conflictsResolved) {
        this.conflictsResolved = conflictsResolved;
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

    public String getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(String createdBy) {
        this.createdBy = createdBy;
    }
}
