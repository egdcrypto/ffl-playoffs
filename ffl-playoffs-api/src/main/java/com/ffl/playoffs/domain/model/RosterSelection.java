package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * RosterSelection Entity
 * Links a roster slot to an NFL player - represents the actual assignment
 * Separates the slot configuration from the player selection
 * Domain model with no framework dependencies
 */
public class RosterSelection {
    private UUID id;
    private UUID rosterSlotId;  // References RosterSlot
    private Long nflPlayerId;   // References NFLPlayer
    private UUID rosterId;      // References Roster
    private Integer week;       // Which week this selection applies to
    private LocalDateTime selectedAt;
    private LocalDateTime lockedAt;  // When this selection was locked (game started)
    private boolean locked;     // Cannot change once locked
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public RosterSelection() {
        this.id = UUID.randomUUID();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
        this.locked = false;
    }

    public RosterSelection(UUID rosterSlotId, Long nflPlayerId, UUID rosterId, Integer week) {
        this();
        this.rosterSlotId = rosterSlotId;
        this.nflPlayerId = nflPlayerId;
        this.rosterId = rosterId;
        this.week = week;
        this.selectedAt = LocalDateTime.now();
    }

    // Business Logic

    /**
     * Locks this selection so it cannot be changed
     * Called when the roster is locked (first game starts)
     */
    public void lock() {
        if (this.locked) {
            throw new IllegalStateException("Selection is already locked");
        }
        this.locked = true;
        this.lockedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Validates that this selection can be modified
     * @throws IllegalStateException if selection is locked
     */
    public void validateMutable() {
        if (this.locked) {
            throw new IllegalStateException(
                "Cannot modify selection - roster is locked since " + this.lockedAt
            );
        }
    }

    /**
     * Updates the NFL player for this selection
     * @param newPlayerId the new player ID
     * @throws IllegalStateException if selection is locked
     */
    public void updatePlayer(Long newPlayerId) {
        validateMutable();
        this.nflPlayerId = newPlayerId;
        this.selectedAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Clears the NFL player from this selection
     * @throws IllegalStateException if selection is locked
     */
    public void clearPlayer() {
        validateMutable();
        this.nflPlayerId = null;
        this.selectedAt = null;
        this.updatedAt = LocalDateTime.now();
    }

    public boolean hasPlayer() {
        return this.nflPlayerId != null;
    }

    public boolean isEmpty() {
        return this.nflPlayerId == null;
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getRosterSlotId() {
        return rosterSlotId;
    }

    public void setRosterSlotId(UUID rosterSlotId) {
        this.rosterSlotId = rosterSlotId;
    }

    public Long getNflPlayerId() {
        return nflPlayerId;
    }

    public void setNflPlayerId(Long nflPlayerId) {
        this.nflPlayerId = nflPlayerId;
        this.updatedAt = LocalDateTime.now();
    }

    public UUID getRosterId() {
        return rosterId;
    }

    public void setRosterId(UUID rosterId) {
        this.rosterId = rosterId;
    }

    public Integer getWeek() {
        return week;
    }

    public void setWeek(Integer week) {
        this.week = week;
    }

    public LocalDateTime getSelectedAt() {
        return selectedAt;
    }

    public void setSelectedAt(LocalDateTime selectedAt) {
        this.selectedAt = selectedAt;
    }

    public LocalDateTime getLockedAt() {
        return lockedAt;
    }

    public void setLockedAt(LocalDateTime lockedAt) {
        this.lockedAt = lockedAt;
    }

    public boolean isLocked() {
        return locked;
    }

    public void setLocked(boolean locked) {
        this.locked = locked;
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
