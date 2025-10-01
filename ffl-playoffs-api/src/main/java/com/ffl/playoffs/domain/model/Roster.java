package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Roster Entity (Aggregate Root)
 * Represents a league player's fantasy football roster
 * Contains multiple RosterSlots with NFL player assignments
 */
public class Roster {
    private UUID id;
    private UUID leaguePlayerId; // The fantasy league player who owns this roster
    private UUID gameId;
    private List<RosterSlot> slots;
    private boolean isLocked;
    private LocalDateTime lockedAt;
    private LocalDateTime rosterDeadline;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public Roster() {
        this.id = UUID.randomUUID();
        this.slots = new ArrayList<>();
        this.isLocked = false;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Roster(UUID leaguePlayerId, UUID gameId, RosterConfiguration config) {
        this();
        this.leaguePlayerId = leaguePlayerId;
        this.gameId = gameId;
        initializeSlots(config);
    }

    // Business Logic
    private void initializeSlots(RosterConfiguration config) {
        config.getPositionSlots().forEach((position, count) -> {
            for (int i = 1; i <= count; i++) {
                RosterSlot slot = new RosterSlot(this.id, position, i);
                this.slots.add(slot);
            }
        });
        this.updatedAt = LocalDateTime.now();
    }

    public void assignPlayerToSlot(UUID slotId, Long nflPlayerId, Position playerPosition) {
        validateNotLocked();

        // Check if player is already on roster
        if (hasPlayer(nflPlayerId)) {
            throw new IllegalStateException("Player is already on your roster");
        }

        RosterSlot slot = findSlotById(slotId);
        if (slot == null) {
            throw new IllegalArgumentException("Roster slot not found");
        }

        slot.assignPlayer(nflPlayerId, playerPosition);
        this.updatedAt = LocalDateTime.now();
    }

    public void removePlayerFromSlot(UUID slotId) {
        validateNotLocked();

        RosterSlot slot = findSlotById(slotId);
        if (slot == null) {
            throw new IllegalArgumentException("Roster slot not found");
        }

        slot.clearPlayer();
        this.updatedAt = LocalDateTime.now();
    }

    public void dropAndAddPlayer(UUID slotId, Long dropPlayerId, Long addPlayerId, Position addPlayerPosition) {
        validateNotLocked();

        RosterSlot slot = findSlotById(slotId);
        if (slot == null) {
            throw new IllegalArgumentException("Roster slot not found");
        }

        if (!slot.getNflPlayerId().equals(dropPlayerId)) {
            throw new IllegalStateException("Slot does not contain the player to drop");
        }

        // Check if new player is already on roster
        if (hasPlayer(addPlayerId)) {
            throw new IllegalStateException("New player is already on your roster");
        }

        slot.clearPlayer();
        slot.assignPlayer(addPlayerId, addPlayerPosition);
        this.updatedAt = LocalDateTime.now();
    }

    public boolean isComplete() {
        return slots.stream().allMatch(RosterSlot::isFilled);
    }

    public List<Position> getMissingPositions() {
        return slots.stream()
            .filter(RosterSlot::isEmpty)
            .map(slot -> slot.getPosition())
            .collect(Collectors.toList());
    }

    public int getFilledSlotCount() {
        return (int) slots.stream().filter(RosterSlot::isFilled).count();
    }

    public int getTotalSlotCount() {
        return slots.size();
    }

    public boolean hasPlayer(Long nflPlayerId) {
        return slots.stream()
            .anyMatch(slot -> slot.isFilled() && slot.getNflPlayerId().equals(nflPlayerId));
    }

    public void lockRoster(LocalDateTime lockTime) {
        this.isLocked = true;
        this.lockedAt = lockTime;
        this.updatedAt = LocalDateTime.now();
    }

    public void unlockRoster() {
        this.isLocked = false;
        this.lockedAt = null;
        this.updatedAt = LocalDateTime.now();
    }

    private void validateNotLocked() {
        if (isLocked) {
            throw new RosterLockedException("Roster is locked - no changes allowed");
        }
        if (rosterDeadline != null && LocalDateTime.now().isAfter(rosterDeadline)) {
            throw new RosterLockedException("Roster deadline has passed");
        }
    }

    private RosterSlot findSlotById(UUID slotId) {
        return slots.stream()
            .filter(slot -> slot.getId().equals(slotId))
            .findFirst()
            .orElse(null);
    }

    public List<RosterSlot> getSlotsByPosition(Position position) {
        return slots.stream()
            .filter(slot -> slot.getPosition() == position)
            .collect(Collectors.toList());
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

    public UUID getGameId() {
        return gameId;
    }

    public void setGameId(UUID gameId) {
        this.gameId = gameId;
    }

    public List<RosterSlot> getSlots() {
        return new ArrayList<>(slots); // Return defensive copy
    }

    public void setSlots(List<RosterSlot> slots) {
        this.slots = new ArrayList<>(slots);
        this.updatedAt = LocalDateTime.now();
    }

    public boolean isLocked() {
        return isLocked;
    }

    public void setLocked(boolean locked) {
        isLocked = locked;
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

    // Exception
    public static class RosterLockedException extends RuntimeException {
        public RosterLockedException(String message) {
            super(message);
        }
    }
}
