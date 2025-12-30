package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import java.time.LocalDateTime;

/**
 * MongoDB embedded document for individual roster slot with player assignment.
 * Represents a single position slot in a player's roster with the assigned NFL player.
 * Different from RosterSlotDocument which is for roster configuration counts.
 */
public class RosterPlayerSlotDocument {

    private String id;
    private String rosterId;
    private String position;        // QB, RB, WR, TE, K, DEF, FLEX, SUPERFLEX
    private Long nflPlayerId;       // The NFL player assigned to this slot (null if empty)
    private Integer slotOrder;      // Display order for multiple slots of same position
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public RosterPlayerSlotDocument() {
    }

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getRosterId() {
        return rosterId;
    }

    public void setRosterId(String rosterId) {
        this.rosterId = rosterId;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public Long getNflPlayerId() {
        return nflPlayerId;
    }

    public void setNflPlayerId(Long nflPlayerId) {
        this.nflPlayerId = nflPlayerId;
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
