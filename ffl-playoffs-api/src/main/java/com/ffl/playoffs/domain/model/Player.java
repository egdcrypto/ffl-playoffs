package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Player entity - represents a player in an FFL playoffs game
 * Domain model with no framework dependencies
 */
public class Player {
    private UUID id;
    private UUID gameId;
    private String name;
    private String email;
    private PlayerStatus status;
    private LocalDateTime joinedAt;
    private List<TeamSelection> teamSelections;
    private boolean isEliminated;

    public Player() {
        this.id = UUID.randomUUID();
        this.teamSelections = new ArrayList<>();
        this.status = PlayerStatus.INVITED;
        this.isEliminated = false;
    }

    public Player(UUID gameId, String name, String email) {
        this();
        this.gameId = gameId;
        this.name = name;
        this.email = email;
    }

    // Business methods
    public void acceptInvitation() {
        if (this.status != PlayerStatus.INVITED) {
            throw new IllegalStateException("Player has already responded to invitation");
        }
        this.status = PlayerStatus.ACTIVE;
        this.joinedAt = LocalDateTime.now();
    }

    public void makeTeamSelection(TeamSelection selection) {
        if (this.status != PlayerStatus.ACTIVE) {
            throw new IllegalStateException("Player must be active to make selections");
        }
        if (this.isEliminated) {
            throw new IllegalStateException("Eliminated players cannot make selections");
        }
        this.teamSelections.add(selection);
    }

    public void eliminate() {
        if (this.isEliminated) {
            throw new IllegalStateException("Player is already eliminated");
        }
        this.isEliminated = true;
        this.status = PlayerStatus.ELIMINATED;
    }

    public boolean hasSelectedTeamForWeek(Integer week) {
        return teamSelections.stream()
                .anyMatch(selection -> selection.getWeek().equals(week));
    }

    public TeamSelection getSelectionForWeek(Integer week) {
        return teamSelections.stream()
                .filter(selection -> selection.getWeek().equals(week))
                .findFirst()
                .orElse(null);
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

    public PlayerStatus getStatus() {
        return status;
    }

    public void setStatus(PlayerStatus status) {
        this.status = status;
    }

    public LocalDateTime getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(LocalDateTime joinedAt) {
        this.joinedAt = joinedAt;
    }

    public List<TeamSelection> getTeamSelections() {
        return teamSelections;
    }

    public void setTeamSelections(List<TeamSelection> teamSelections) {
        this.teamSelections = teamSelections;
    }

    public boolean isEliminated() {
        return isEliminated;
    }

    public void setEliminated(boolean eliminated) {
        isEliminated = eliminated;
    }

    public enum PlayerStatus {
        INVITED,
        ACTIVE,
        ELIMINATED
    }
}
