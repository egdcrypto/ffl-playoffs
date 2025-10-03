package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Domain model representing a playoff week in the game.
 */
public class Week {
    private UUID id;
    private UUID gameId;
    private Integer weekNumber;
    private Integer nflWeek;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private WeekStatus status;

    public Week() {
        this.id = UUID.randomUUID();
        this.status = WeekStatus.PENDING;
    }

    public Week(UUID gameId, Integer weekNumber, Integer nflWeek, LocalDateTime startDate, LocalDateTime endDate) {
        this();
        this.gameId = gameId;
        this.weekNumber = weekNumber;
        this.nflWeek = nflWeek;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    public void open() {
        this.status = WeekStatus.OPEN;
    }

    public void close() {
        this.status = WeekStatus.CLOSED;
    }

    public void complete() {
        this.status = WeekStatus.COMPLETED;
    }

    public boolean isOpen() {
        return this.status == WeekStatus.OPEN;
    }

    // Getters and setters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }

    public UUID getGameId() { return gameId; }
    public void setGameId(UUID gameId) { this.gameId = gameId; }

    public Integer getWeekNumber() { return weekNumber; }
    public void setWeekNumber(Integer weekNumber) { this.weekNumber = weekNumber; }

    public Integer getNflWeek() { return nflWeek; }
    public void setNflWeek(Integer nflWeek) { this.nflWeek = nflWeek; }

    public LocalDateTime getStartDate() { return startDate; }
    public void setStartDate(LocalDateTime startDate) { this.startDate = startDate; }

    public LocalDateTime getEndDate() { return endDate; }
    public void setEndDate(LocalDateTime endDate) { this.endDate = endDate; }

    public WeekStatus getStatus() { return status; }
    public void setStatus(WeekStatus status) { this.status = status; }
}
