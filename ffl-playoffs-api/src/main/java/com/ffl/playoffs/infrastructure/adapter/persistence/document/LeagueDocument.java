package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;

/**
 * MongoDB document for League entity
 * Infrastructure layer persistence model
 */
@Document(collection = "leagues")
public class LeagueDocument {

    @Id
    private String id;

    private String name;
    private String description;

    @Indexed(unique = true)
    private String code;

    private String ownerId;  // Admin who created the league
    private String status;  // CREATED, WAITING_FOR_PLAYERS, ACTIVE, COMPLETED, CANCELLED

    // Week configuration
    private Integer startingWeek;
    private Integer numberOfWeeks;
    private Integer currentWeek;

    // Configuration (embedded documents)
    private RosterConfigurationDocument rosterConfiguration;
    private ScoringRulesDocument scoringRules;

    // Configuration lock
    private Boolean configurationLocked;
    private LocalDateTime configurationLockedAt;
    private String lockReason;
    private LocalDateTime firstGameStartTime;

    // Players (embedded list)
    private List<PlayerDocument> players;

    // Metadata
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public LeagueDocument() {
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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(String ownerId) {
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

    public RosterConfigurationDocument getRosterConfiguration() {
        return rosterConfiguration;
    }

    public void setRosterConfiguration(RosterConfigurationDocument rosterConfiguration) {
        this.rosterConfiguration = rosterConfiguration;
    }

    public ScoringRulesDocument getScoringRules() {
        return scoringRules;
    }

    public void setScoringRules(ScoringRulesDocument scoringRules) {
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

    public List<PlayerDocument> getPlayers() {
        return players;
    }

    public void setPlayers(List<PlayerDocument> players) {
        this.players = players;
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
