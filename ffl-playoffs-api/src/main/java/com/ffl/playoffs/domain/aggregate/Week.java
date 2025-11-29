package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.WeekStatus;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Week Entity - represents a game week in the league
 * Maps game weeks to NFL weeks and manages week lifecycle
 * Domain model with no framework dependencies
 */
public class Week {
    private UUID id;
    private UUID leagueId;
    private Integer gameWeekNumber;    // League-specific week number (1, 2, 3, ...)
    private Integer nflWeekNumber;     // Corresponding NFL week (1-22)
    private WeekStatus status;
    private LocalDateTime pickDeadline;
    private LocalDateTime startDate;
    private LocalDateTime endDate;

    // Metadata
    private Integer totalNFLGames;
    private Integer gamesCompleted;
    private Integer gamesInProgress;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Constructors
    public Week() {
        this.id = UUID.randomUUID();
        this.status = WeekStatus.UPCOMING;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Week(UUID leagueId, Integer gameWeekNumber, Integer nflWeekNumber) {
        this();
        this.leagueId = leagueId;
        this.gameWeekNumber = gameWeekNumber;
        this.nflWeekNumber = nflWeekNumber;
    }

    public Week(UUID leagueId, Integer gameWeekNumber, Integer nflWeekNumber, LocalDateTime pickDeadline) {
        this(leagueId, gameWeekNumber, nflWeekNumber);
        this.pickDeadline = pickDeadline;
    }

    // Business Logic

    /**
     * Checks if the week is upcoming (not yet started)
     */
    public boolean isUpcoming() {
        return this.status == WeekStatus.UPCOMING;
    }

    /**
     * Checks if the week is active (selections open)
     */
    public boolean isActive() {
        return this.status == WeekStatus.ACTIVE;
    }

    /**
     * Checks if the week is locked (deadline passed, games in progress)
     */
    public boolean isLocked() {
        return this.status == WeekStatus.LOCKED;
    }

    /**
     * Checks if the week is completed (all games finished)
     */
    public boolean isCompleted() {
        return this.status == WeekStatus.COMPLETED;
    }

    /**
     * Checks if selections can be accepted for this week
     */
    public boolean canAcceptSelections() {
        return this.status == WeekStatus.ACTIVE &&
               this.pickDeadline != null &&
               LocalDateTime.now().isBefore(this.pickDeadline);
    }

    /**
     * Activates the week (moves from UPCOMING to ACTIVE)
     */
    public void activate() {
        if (this.status != WeekStatus.UPCOMING) {
            throw new IllegalStateException("Can only activate UPCOMING weeks");
        }
        this.status = WeekStatus.ACTIVE;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Locks the week after the deadline passes
     */
    public void lock() {
        if (this.status != WeekStatus.ACTIVE) {
            throw new IllegalStateException("Can only lock ACTIVE weeks");
        }
        this.status = WeekStatus.LOCKED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Completes the week after all games are finished
     */
    public void complete() {
        if (this.status != WeekStatus.LOCKED) {
            throw new IllegalStateException("Can only complete LOCKED weeks");
        }
        this.status = WeekStatus.COMPLETED;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Sets the pick deadline for this week
     * Cannot change deadline if week is already active
     */
    public void setPickDeadline(LocalDateTime pickDeadline) {
        if (this.status == WeekStatus.ACTIVE || this.status == WeekStatus.LOCKED || this.status == WeekStatus.COMPLETED) {
            throw new IllegalStateException("CANNOT_CHANGE_ACTIVE_WEEK_DEADLINE");
        }
        this.pickDeadline = pickDeadline;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Checks if the deadline has passed
     */
    public boolean hasDeadlinePassed() {
        return this.pickDeadline != null && LocalDateTime.now().isAfter(this.pickDeadline);
    }

    /**
     * Checks if all games for this week are completed
     */
    public boolean areAllGamesCompleted() {
        return this.totalNFLGames != null &&
               this.gamesCompleted != null &&
               this.totalNFLGames.equals(this.gamesCompleted);
    }

    /**
     * Updates game statistics for this week
     */
    public void updateGameStats(Integer total, Integer completed, Integer inProgress) {
        this.totalNFLGames = total;
        this.gamesCompleted = completed;
        this.gamesInProgress = inProgress;
        this.updatedAt = LocalDateTime.now();
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public UUID getLeagueId() {
        return leagueId;
    }

    public void setLeagueId(UUID leagueId) {
        this.leagueId = leagueId;
    }

    public Integer getGameWeekNumber() {
        return gameWeekNumber;
    }

    public void setGameWeekNumber(Integer gameWeekNumber) {
        this.gameWeekNumber = gameWeekNumber;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getNflWeekNumber() {
        return nflWeekNumber;
    }

    public void setNflWeekNumber(Integer nflWeekNumber) {
        this.nflWeekNumber = nflWeekNumber;
        this.updatedAt = LocalDateTime.now();
    }

    public WeekStatus getStatus() {
        return status;
    }

    public void setStatus(WeekStatus status) {
        this.status = status;
        this.updatedAt = LocalDateTime.now();
    }

    public LocalDateTime getPickDeadline() {
        return pickDeadline;
    }

    public LocalDateTime getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDateTime startDate) {
        this.startDate = startDate;
        this.updatedAt = LocalDateTime.now();
    }

    public LocalDateTime getEndDate() {
        return endDate;
    }

    public void setEndDate(LocalDateTime endDate) {
        this.endDate = endDate;
        this.updatedAt = LocalDateTime.now();
    }

    public Integer getTotalNFLGames() {
        return totalNFLGames;
    }

    public void setTotalNFLGames(Integer totalNFLGames) {
        this.totalNFLGames = totalNFLGames;
    }

    public Integer getGamesCompleted() {
        return gamesCompleted;
    }

    public void setGamesCompleted(Integer gamesCompleted) {
        this.gamesCompleted = gamesCompleted;
    }

    public Integer getGamesInProgress() {
        return gamesInProgress;
    }

    public void setGamesInProgress(Integer gamesInProgress) {
        this.gamesInProgress = gamesInProgress;
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

    @Override
    public String toString() {
        return String.format(
            "Week{id=%s, leagueId=%s, gameWeek=%d, nflWeek=%d, status=%s, deadline=%s}",
            id, leagueId, gameWeekNumber, nflWeekNumber, status, pickDeadline
        );
    }
}
