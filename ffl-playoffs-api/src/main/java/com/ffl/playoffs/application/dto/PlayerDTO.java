package com.ffl.playoffs.application.dto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Data Transfer Object for Player
 * Used for API communication
 */
public class PlayerDTO {
    private UUID id;
    private UUID gameId;
    private String name;
    private String email;
    private String status;
    private LocalDateTime joinedAt;
    private boolean isEliminated;
    private List<TeamSelectionDTO> teamSelections;

    // Constructors
    public PlayerDTO() {
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getGameId() {
        return gameId;
    }

    public void setGameId(UUID gameId) {
        this.gameId = gameId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(LocalDateTime joinedAt) {
        this.joinedAt = joinedAt;
    }

    public boolean isEliminated() {
        return isEliminated;
    }

    public void setEliminated(boolean eliminated) {
        isEliminated = eliminated;
    }

    public List<TeamSelectionDTO> getTeamSelections() {
        return teamSelections;
    }

    public void setTeamSelections(List<TeamSelectionDTO> teamSelections) {
        this.teamSelections = teamSelections;
    }
}
