package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Roster Slot Entity
 * Represents a single position slot in a league player's roster
 * Links an NFL player to a roster position
 */
public class RosterSlot {
    private UUID id;
    private UUID rosterId;
    private Position position; // QB, RB, WR, TE, FLEX, K, DEF, SUPERFLEX
    private Long nflPlayerId; // The selected NFL player for this slot
    private Integer slotOrder; // Display order (1, 2, 3... for multiple slots of same position)
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public RosterSlot() {
        this.id = UUID.randomUUID();
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public RosterSlot(UUID rosterId, Position position, Integer slotOrder) {
        this();
        this.rosterId = rosterId;
        this.position = position;
        this.slotOrder = slotOrder;
    }

    // Business Logic
    public boolean isFilled() {
        return nflPlayerId != null;
    }

    public boolean isEmpty() {
        return nflPlayerId == null;
    }

    public void assignPlayer(Long nflPlayerId, Position playerPosition) {
        if (!Position.canFillSlot(playerPosition, this.position)) {
            throw new IllegalArgumentException(
                String.format("Player position %s cannot fill %s slot", playerPosition, this.position)
            );
        }
        this.nflPlayerId = nflPlayerId;
        this.updatedAt = LocalDateTime.now();
    }

    public void clearPlayer() {
        this.nflPlayerId = null;
        this.updatedAt = LocalDateTime.now();
    }

    public String getSlotLabel() {
        if (slotOrder != null && slotOrder > 1) {
            return position.name() + slotOrder;
        }
        return position.name();
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getRosterId() {
        return rosterId;
    }

    public void setRosterId(UUID rosterId) {
        this.rosterId = rosterId;
    }

    public Position getPosition() {
        return position;
    }

    public void setPosition(Position position) {
        this.position = position;
        this.updatedAt = LocalDateTime.now();
    }

    public Long getNflPlayerId() {
        return nflPlayerId;
    }

    public void setNflPlayerId(Long nflPlayerId) {
        this.nflPlayerId = nflPlayerId;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getSlotOrder() {
        return slotOrder;
    }

    public void setSlotOrder(Integer slotOrder) {
        this.slotOrder = slotOrder;
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
