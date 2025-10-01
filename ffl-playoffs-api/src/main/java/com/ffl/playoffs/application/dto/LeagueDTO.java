package com.ffl.playoffs.application.dto;

import jakarta.validation.constraints.Max;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Data Transfer Object for League
 * Used for API communication
 */
public class LeagueDTO {
    private UUID id;

    @NotBlank(message = "League name is required")
    private String name;

    private String description;

    @NotBlank(message = "League code is required")
    private String code;

    private UUID ownerId;

    private String status;

    @NotNull(message = "Starting week is required")
    @Min(value = 1, message = "Starting week must be between 1 and 22")
    @Max(value = 22, message = "Starting week must be between 1 and 22")
    private Integer startingWeek;

    @NotNull(message = "Number of weeks is required")
    @Min(value = 1, message = "Number of weeks must be between 1 and 17")
    @Max(value = 17, message = "Number of weeks must be between 1 and 17")
    private Integer numberOfWeeks;

    private Integer currentWeek;

    private RosterConfigurationDTO rosterConfiguration;
    private ScoringRulesDTO scoringRules;

    private Boolean configurationLocked;
    private LocalDateTime configurationLockedAt;
    private String lockReason;
    private LocalDateTime firstGameStartTime;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public LeagueDTO() {
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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public UUID getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(UUID ownerId) {
        this.ownerId = ownerId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Integer getStartingWeek() {
        return startingWeek;
    }

    public void setStartingWeek(Integer startingWeek) {
        this.startingWeek = startingWeek;
    }

    public Integer getNumberOfWeeks() {
        return numberOfWeeks;
    }

    public void setNumberOfWeeks(Integer numberOfWeeks) {
        this.numberOfWeeks = numberOfWeeks;
    }

    public Integer getCurrentWeek() {
        return currentWeek;
    }

    public void setCurrentWeek(Integer currentWeek) {
        this.currentWeek = currentWeek;
    }

    public RosterConfigurationDTO getRosterConfiguration() {
        return rosterConfiguration;
    }

    public void setRosterConfiguration(RosterConfigurationDTO rosterConfiguration) {
        this.rosterConfiguration = rosterConfiguration;
    }

    public ScoringRulesDTO getScoringRules() {
        return scoringRules;
    }

    public void setScoringRules(ScoringRulesDTO scoringRules) {
        this.scoringRules = scoringRules;
    }

    public Boolean getConfigurationLocked() {
        return configurationLocked;
    }

    public void setConfigurationLocked(Boolean configurationLocked) {
        this.configurationLocked = configurationLocked;
    }

    public LocalDateTime getConfigurationLockedAt() {
        return configurationLockedAt;
    }

    public void setConfigurationLockedAt(LocalDateTime configurationLockedAt) {
        this.configurationLockedAt = configurationLockedAt;
    }

    public String getLockReason() {
        return lockReason;
    }

    public void setLockReason(String lockReason) {
        this.lockReason = lockReason;
    }

    public LocalDateTime getFirstGameStartTime() {
        return firstGameStartTime;
    }

    public void setFirstGameStartTime(LocalDateTime firstGameStartTime) {
        this.firstGameStartTime = firstGameStartTime;
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
