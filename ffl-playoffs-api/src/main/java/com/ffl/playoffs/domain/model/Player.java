package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Domain model representing a player in the game.
 */
public class Player {
    private UUID id;
    private String name;
    private String email;
    private UUID gameId;
    private LocalDateTime joinedAt;
    private PlayerStatus status;
    private List<TeamSelection> teamSelections;

    public Player() {
        this.id = UUID.randomUUID();
        this.joinedAt = LocalDateTime.now();
        this.status = PlayerStatus.ACTIVE;
        this.teamSelections = new ArrayList<>();
    }

    public Player(String name, String email, UUID gameId) {
        this();
        this.name = name;
        this.email = email;
        this.gameId = gameId;
    }

    public void eliminate() {
        this.status = PlayerStatus.ELIMINATED;
    }

    public boolean isEliminated() {
        return this.status == PlayerStatus.ELIMINATED;
    }

    public void addTeamSelection(TeamSelection selection) {
        this.teamSelections.add(selection);
    }

    // Getters and setters
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

    public List<TeamSelection> getTeamSelections() { return teamSelections; }
    public void setTeamSelections(List<TeamSelection> teamSelections) { this.teamSelections = teamSelections; }
}
