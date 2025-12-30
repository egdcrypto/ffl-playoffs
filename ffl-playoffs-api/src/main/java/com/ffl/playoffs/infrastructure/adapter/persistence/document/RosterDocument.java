package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;

/**
 * MongoDB document for Roster entity.
 * Represents a league player's fantasy football roster with all slot assignments.
 */
@Document(collection = "rosters")
public class RosterDocument {

    @Id
    private String id;

    @Indexed
    private String leaguePlayerId;      // The fantasy league player who owns this roster

    @Indexed
    private String gameId;              // Game/League reference

    private List<RosterPlayerSlotDocument> slots;

    private Boolean isLocked;
    private String lockStatus;          // UNLOCKED, LOCKED, LOCKED_INCOMPLETE
    private LocalDateTime lockedAt;
    private LocalDateTime rosterDeadline;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public RosterDocument() {
    }

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getLeaguePlayerId() {
        return leaguePlayerId;
    }

    public void setLeaguePlayerId(String leaguePlayerId) {
        this.leaguePlayerId = leaguePlayerId;
    }

    public String getGameId() {
        return gameId;
    }

    public void setGameId(String gameId) {
        this.gameId = gameId;
    }

    public List<RosterPlayerSlotDocument> getSlots() {
        return slots;
    }

    public void setSlots(List<RosterPlayerSlotDocument> slots) {
        this.slots = slots;
    }

    public Boolean getIsLocked() {
        return isLocked;
    }

    public void setIsLocked(Boolean isLocked) {
        this.isLocked = isLocked;
    }

    public String getLockStatus() {
        return lockStatus;
    }

    public void setLockStatus(String lockStatus) {
        this.lockStatus = lockStatus;
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
