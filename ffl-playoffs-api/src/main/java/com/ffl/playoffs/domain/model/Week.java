package com.ffl.playoffs.domain.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Week entity - represents an NFL playoff week
 * Domain model with no framework dependencies
 */
public class Week {
    private UUID id;
    private Integer weekNumber;
    private String weekName; // e.g., "Wild Card", "Divisional", "Conference Championship", "Super Bowl"
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private WeekStatus status;
    private List<String> availableTeams;

    public Week() {
        this.id = UUID.randomUUID();
        this.status = WeekStatus.UPCOMING;
        this.availableTeams = new ArrayList<>();
    }

    public Week(Integer weekNumber, String weekName, LocalDateTime startDate, LocalDateTime endDate) {
        this();
        this.weekNumber = weekNumber;
        this.weekName = weekName;
        this.startDate = startDate;
        this.endDate = endDate;
    }

    // Business methods
    public void startWeek() {
        if (this.status != WeekStatus.UPCOMING) {
            throw new IllegalStateException("Week must be upcoming to start");
        }
        this.status = WeekStatus.IN_PROGRESS;
    }

    public void completeWeek() {
        if (this.status != WeekStatus.IN_PROGRESS) {
            throw new IllegalStateException("Week must be in progress to complete");
        }
        this.status = WeekStatus.COMPLETED;
    }

    public boolean isSelectionAllowed() {
        return this.status == WeekStatus.UPCOMING;
    }

    public void addAvailableTeam(String teamCode) {
        if (!this.availableTeams.contains(teamCode)) {
            this.availableTeams.add(teamCode);
        }
    }

    public void removeAvailableTeam(String teamCode) {
        this.availableTeams.remove(teamCode);
    }

    public boolean isTeamAvailable(String teamCode) {
        return this.availableTeams.contains(teamCode);
    }

    // Getters and Setters
    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public Integer getWeekNumber() {
        return weekNumber;
    }

    public void setWeekNumber(Integer weekNumber) {
        this.weekNumber = weekNumber;
    }

    public String getWeekName() {
        return weekName;
    }

    public void setWeekName(String weekName) {
        this.weekName = weekName;
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

    public WeekStatus getStatus() {
        return status;
    }

    public void setStatus(WeekStatus status) {
        this.status = status;
    }

    public List<String> getAvailableTeams() {
        return availableTeams;
    }

    public void setAvailableTeams(List<String> availableTeams) {
        this.availableTeams = availableTeams;
    }

    public enum WeekStatus {
        UPCOMING,
        IN_PROGRESS,
        COMPLETED
    }
}
