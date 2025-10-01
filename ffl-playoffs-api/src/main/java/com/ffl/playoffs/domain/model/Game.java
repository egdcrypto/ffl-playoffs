package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Game entity - represents an FFL playoffs game
 * Domain model with no framework dependencies
 */
public class Game {
    private UUID id;
    private String name;
    private String code;
    private UUID creatorId;
    private GameStatus status;
    private Integer startingWeek;
    private Integer currentWeek;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<Player> players;
    private ScoringRules scoringRules;

    public Game() {
        this.id = UUID.randomUUID();
        this.players = new ArrayList<>();
        this.status = GameStatus.CREATED;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Game(String name, String code, UUID creatorId, Integer startingWeek) {
        this();
        this.name = name;
        this.code = code;
        this.creatorId = creatorId;
        this.startingWeek = startingWeek;
        this.currentWeek = startingWeek;
    }

    // Business methods
    public void addPlayer(Player player) {
        if (this.status != GameStatus.CREATED && this.status != GameStatus.WAITING_FOR_PLAYERS) {
            throw new IllegalStateException("Cannot add players to a game that has started");
        }
        this.players.add(player);
        this.updatedAt = LocalDateTime.now();
    }

    public void start() {
        if (this.status != GameStatus.WAITING_FOR_PLAYERS && this.status != GameStatus.CREATED) {
            throw new IllegalStateException("Game cannot be started in current status: " + this.status);
        }
        if (this.players.size() < 2) {
            throw new IllegalStateException("Game requires at least 2 players to start");
        }
        this.status = GameStatus.IN_PROGRESS;
        this.updatedAt = LocalDateTime.now();
    }

    public void advanceWeek() {
        if (this.status != GameStatus.IN_PROGRESS) {
            throw new IllegalStateException("Can only advance week for games in progress");
        }
        this.currentWeek++;
        this.updatedAt = LocalDateTime.now();
    }

    public void complete() {
        if (this.status != GameStatus.IN_PROGRESS) {
            throw new IllegalStateException("Can only complete games that are in progress");
        }
        this.status = GameStatus.COMPLETED;
        this.updatedAt = LocalDateTime.now();
    }

    // Getters and Setters
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

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public UUID getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(UUID creatorId) {
        this.creatorId = creatorId;
    }

    public GameStatus getStatus() {
        return status;
    }

    public void setStatus(GameStatus status) {
        this.status = status;
    }

    public Integer getStartingWeek() {
        return startingWeek;
    }

    public void setStartingWeek(Integer startingWeek) {
        this.startingWeek = startingWeek;
    }

    public Integer getCurrentWeek() {
        return currentWeek;
    }

    public void setCurrentWeek(Integer currentWeek) {
        this.currentWeek = currentWeek;
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

    public List<Player> getPlayers() {
        return players;
    }

    public void setPlayers(List<Player> players) {
        this.players = players;
    }

    public ScoringRules getScoringRules() {
        return scoringRules;
    }

    public void setScoringRules(ScoringRules scoringRules) {
        this.scoringRules = scoringRules;
    }

    public enum GameStatus {
        CREATED,
        WAITING_FOR_PLAYERS,
        IN_PROGRESS,
        COMPLETED,
        CANCELLED
    }
}
