package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class Game {
    private UUID id;
    private String name;
    private LocalDateTime createdAt;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private GameStatus status;
    private List<Player> players;
    private List<Week> weeks;
    private UUID creatorId;

    public Game() {
        this.id = UUID.randomUUID();
        this.createdAt = LocalDateTime.now();
        this.status = GameStatus.DRAFT;
        this.players = new ArrayList<>();
        this.weeks = new ArrayList<>();
    }

    public Game(String name, LocalDateTime startDate, LocalDateTime endDate, UUID creatorId) {
        this();
        this.name = name;
        this.startDate = startDate;
        this.endDate = endDate;
        this.creatorId = creatorId;
    }

    public void addPlayer(Player player) {
        this.players.add(player);
    }

    public void removePlayer(Player player) {
        this.players.remove(player);
    }

    public void startGame() {
        if (this.status != GameStatus.DRAFT) {
            throw new IllegalStateException("Game can only be started from DRAFT status");
        }
        this.status = GameStatus.ACTIVE;
    }

    public void completeGame() {
        if (this.status != GameStatus.ACTIVE) {
            throw new IllegalStateException("Only ACTIVE games can be completed");
        }
        this.status = GameStatus.COMPLETED;
    }

    // Getters and setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
    }

    public LocalDateTime getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDateTime endDate) {
        this.endDate = endDate;
    }

    public GameStatus getStatus() {
        return status;
    }

    public void setStatus(GameStatus status) {
        this.status = status;
    }

    public List<Player> getPlayers() {
        return players;
    }

    public void setPlayers(List<Player> players) {
        this.players = players;
    }

    public List<Week> getWeeks() {
        return weeks;
    }

    public void setWeeks(List<Week> weeks) {
        this.weeks = weeks;
    }

    public UUID getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(UUID creatorId) {
        this.creatorId = creatorId;
    }
}
