package com.ffl.playoffs.application.dto;

import com.ffl.playoffs.domain.model.PlayerStatus;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Data Transfer Object for Player.
 */
public class PlayerDTO {
    private UUID id;
    private String name;
    private String email;
    private UUID gameId;
    private LocalDateTime joinedAt;
    private PlayerStatus status;
    private List<TeamSelectionDTO> teamSelections;
    private Double currentScore;

    // Constructors
    public PlayerDTO() {}

    // Getters and Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public UUID getGameId() { return gameId; }
    public void setGameId(UUID gameId) { this.gameId = gameId; }

    public LocalDateTime getJoinedAt() { return joinedAt; }
    public void setJoinedAt(LocalDateTime joinedAt) { this.joinedAt = joinedAt; }

    public PlayerStatus getStatus() { return status; }
    public void setStatus(PlayerStatus status) { this.status = status; }

    public List<TeamSelectionDTO> getTeamSelections() { return teamSelections; }
    public void setTeamSelections(List<TeamSelectionDTO> teamSelections) { this.teamSelections = teamSelections; }

    public Double getCurrentScore() { return currentScore; }
    public void setCurrentScore(Double currentScore) { this.currentScore = currentScore; }
}
