package com.ffl.playoffs.application.dto;

import java.util.UUID;

/**
 * Data Transfer Object for Roster Slot
 * Represents a position slot in a roster
 */
public class RosterSlotDTO {
    private UUID id;
    private String position;
    private UUID nflPlayerId;
    private String playerName;
    private Boolean isStarting;

    // Constructors
    public RosterSlotDTO() {
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public UUID getNflPlayerId() {
        return nflPlayerId;
    }

    public void setNflPlayerId(UUID nflPlayerId) {
        this.nflPlayerId = nflPlayerId;
    }

    public String getPlayerName() {
        return playerName;
    }

    public void setPlayerName(String playerName) {
        this.playerName = playerName;
    }

    public Boolean getIsStarting() {
        return isStarting;
    }

    public void setIsStarting(Boolean isStarting) {
        this.isStarting = isStarting;
    }
}
