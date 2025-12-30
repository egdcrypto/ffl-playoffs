package com.ffl.playoffs.domain.aggregate;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * EraProfile aggregate - represents a time period and historical context for a narrative world.
 * Domain model with no framework dependencies.
 *
 * Used for world curation to ensure temporal consistency in playable worlds.
 * Tracks technology levels, time periods, and curation status.
 */
public class EraProfile {
    private UUID id;
    private String name;
    private String description;
    private UUID worldId;  // Reference to the world/narrative this era belongs to

    // Time period
    private Integer startYear;
    private Integer endYear;
    private String timePeriodLabel;  // e.g., "Renaissance", "Medieval", "Victorian"

    // Technology configuration
    private TechnologyLevel technologyLevel;

    // Curation status
    private EraStatus status;
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
    private UUID createdBy;

    /**
     * Default constructor initializing a new era profile
     */
    public EraProfile() {
        this.id = UUID.randomUUID();
        this.status = EraStatus.DRAFT;
        this.isLocked = false;
        this.technologyApproved = false;
        this.charactersValidated = false;
        this.objectsValidated = false;
        this.locationsValidated = false;
        this.conflictsResolved = false;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Constructor with essential parameters
     */
    public EraProfile(String name, UUID worldId, Integer startYear, Integer endYear) {
        this();
        this.name = name;
        this.worldId = worldId;
        this.startYear = startYear;
        this.endYear = endYear;
    }

    // ==================== Business Methods ====================

    /**
     * Approves the technology level for this era
     */
    public void approveTechnology() {
        if (this.isLocked != null && this.isLocked) {
            throw new EraLockedException("Cannot modify locked era profile");
        }
        this.technologyApproved = true;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Validates character knowledge against era limitations
     */
    public void validateCharacters() {
        if (this.isLocked != null && this.isLocked) {
            throw new EraLockedException("Cannot modify locked era profile");
        }
        this.charactersValidated = true;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Validates objects against era technology level
     */
    public void validateObjects() {
        if (this.isLocked != null && this.isLocked) {
            throw new EraLockedException("Cannot modify locked era profile");
        }
        this.objectsValidated = true;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Validates location architecture against era
     */
    public void validateLocations() {
        if (this.isLocked != null && this.isLocked) {
            throw new EraLockedException("Cannot modify locked era profile");
        }
        this.locationsValidated = true;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Marks conflicts as resolved
     */
    public void resolveConflicts() {
        if (this.isLocked != null && this.isLocked) {
            throw new EraLockedException("Cannot modify locked era profile");
        }
        this.conflictsResolved = true;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Checks if the curation checklist is complete
     */
    public boolean isCurationComplete() {
        return Boolean.TRUE.equals(technologyApproved) &&
               Boolean.TRUE.equals(charactersValidated) &&
               Boolean.TRUE.equals(objectsValidated) &&
               Boolean.TRUE.equals(locationsValidated) &&
               Boolean.TRUE.equals(conflictsResolved);
    }

    /**
     * Locks the era for world deployment
     * @throws IllegalStateException if curation is not complete
     */
    public void lock(String reason) {
        if (!isCurationComplete()) {
            throw new IncompleteCurationException("Cannot lock era profile: curation checklist is incomplete");
        }
        this.isLocked = true;
        this.lockedAt = LocalDateTime.now();
        this.lockReason = reason;
        this.status = EraStatus.LOCKED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Submits the era for review
     */
    public void submitForReview() {
        if (this.status != EraStatus.DRAFT) {
            throw new IllegalStateException("Can only submit DRAFT eras for review");
        }
        this.status = EraStatus.PENDING_REVIEW;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Approves the era after review
     */
    public void approve() {
        if (this.status != EraStatus.PENDING_REVIEW) {
            throw new IllegalStateException("Can only approve eras that are PENDING_REVIEW");
        }
        this.status = EraStatus.APPROVED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Rejects the era after review, returning it to draft
     */
    public void reject() {
        if (this.status != EraStatus.PENDING_REVIEW) {
            throw new IllegalStateException("Can only reject eras that are PENDING_REVIEW");
        }
        this.status = EraStatus.DRAFT;
        this.updatedAt = LocalDateTime.now();
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

    public UUID getWorldId() {
        return worldId;
    }

    public void setWorldId(UUID worldId) {
        this.worldId = worldId;
    }

    public Integer getStartYear() {
        return startYear;
    }

    public void setStartYear(Integer startYear) {
        this.startYear = startYear;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getEndYear() {
        return endYear;
    }

    public void setEndYear(Integer endYear) {
        this.endYear = endYear;
        this.updatedAt = LocalDateTime.now();
    }

    public String getTimePeriodLabel() {
        return timePeriodLabel;
    }

    public void setTimePeriodLabel(String timePeriodLabel) {
        this.timePeriodLabel = timePeriodLabel;
        this.updatedAt = LocalDateTime.now();
    }

    public TechnologyLevel getTechnologyLevel() {
        return technologyLevel;
    }

    public void setTechnologyLevel(TechnologyLevel technologyLevel) {
        this.technologyLevel = technologyLevel;
        this.updatedAt = LocalDateTime.now();
    }

    public EraStatus getStatus() {
        return status;
    }

    public void setStatus(EraStatus status) {
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

    public UUID getCreatedBy() {
        return createdBy;
    }

    public void setCreatedBy(UUID createdBy) {
        this.createdBy = createdBy;
    }

    // ==================== Enums ====================

    /**
     * Technology level for an era
     */
    public enum TechnologyLevel {
        PREHISTORIC,
        ANCIENT,
        MEDIEVAL,
        RENAISSANCE,
        INDUSTRIAL,
        MODERN,
        FUTURISTIC,
        CUSTOM
    }

    /**
     * Status of era curation workflow
     */
    public enum EraStatus {
        DRAFT,
        PENDING_REVIEW,
        APPROVED,
        LOCKED
    }

    // ==================== Exception Classes ====================

    /**
     * Exception thrown when attempting to modify a locked era
     */
    public static class EraLockedException extends RuntimeException {
        public EraLockedException(String message) {
            super(message);
        }
    }

    /**
     * Exception thrown when attempting to lock an era with incomplete curation
     */
    public static class IncompleteCurationException extends RuntimeException {
        public IncompleteCurationException(String message) {
            super(message);
        }
    }

    @Override
    public String toString() {
        return String.format(
            "EraProfile{id=%s, name='%s', worldId=%s, years=%d-%d, tech=%s, status=%s, locked=%s}",
            id, name, worldId, startYear, endYear, technologyLevel, status, isLocked
        );
    }
}
