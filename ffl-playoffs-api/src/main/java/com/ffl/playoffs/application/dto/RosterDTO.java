package com.ffl.playoffs.application.dto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Data Transfer Object for Roster
 * Used for API communication
 */
public class RosterDTO {
    private UUID id;
    private UUID leaguePlayerId;
    private UUID leagueId;
    private Boolean isLocked;
    private LocalDateTime lockedAt;
    private LocalDateTime rosterDeadline;
    private List<RosterSlotDTO> slots;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public RosterDTO() {
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getLeaguePlayerId() {
        return leaguePlayerId;
    }

    public void setLeaguePlayerId(UUID leaguePlayerId) {
        this.leaguePlayerId = leaguePlayerId;
    }

    public UUID getLeagueId() {
        return leagueId;
    }

    public void setLeagueId(UUID leagueId) {
        this.leagueId = leagueId;
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

    public LocalDateTime getRosterDeadline() {
        return rosterDeadline;
    }

    public void setRosterDeadline(LocalDateTime rosterDeadline) {
        this.rosterDeadline = rosterDeadline;
    }

    public List<RosterSlotDTO> getSlots() {
        return slots;
    }

    public void setSlots(List<RosterSlotDTO> slots) {
        this.slots = slots;
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
