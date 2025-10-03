package com.ffl.playoffs.application.dto;

import com.ffl.playoffs.domain.model.GameStatus;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Data Transfer Object for Game.
 */
public class GameDTO {
    private UUID id;
    private String name;
    private LocalDateTime createdAt;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private GameStatus status;
    private UUID creatorId;
    private List<PlayerDTO> players;
    private Integer currentWeek;

    // Constructors
    public GameDTO() {}

    // Getters and Setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getStartDate() { return startDate; }
    public void setStartDate(LocalDateTime startDate) { this.startDate = startDate; }

    public LocalDateTime getEndDate() { return endDate; }
    public void setEndDate(LocalDateTime endDate) { this.endDate = endDate; }

    public GameStatus getStatus() { return status; }
    public void setStatus(GameStatus status) { this.status = status; }

    public UUID getCreatorId() { return creatorId; }
    public void setCreatorId(UUID creatorId) { this.creatorId = creatorId; }

    public List<PlayerDTO> getPlayers() { return players; }
    public void setPlayers(List<PlayerDTO> players) { this.players = players; }

    public Integer getCurrentWeek() { return currentWeek; }
    public void setCurrentWeek(Integer currentWeek) { this.currentWeek = currentWeek; }
}
