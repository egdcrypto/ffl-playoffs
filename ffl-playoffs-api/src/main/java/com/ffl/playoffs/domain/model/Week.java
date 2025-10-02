package com.ffl.playoffs.domain.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Domain model representing a playoff week.
 */
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Week {
    private UUID id;
    private Integer weekNumber;
    private LocalDateTime startDate;
    private LocalDateTime endDate;
    private WeekStatus status;
    private List<String> availableTeams;

    public enum WeekStatus {
        UPCOMING,
        ACTIVE,
        COMPLETED
    }

    public void activate() {
        this.status = WeekStatus.ACTIVE;
    }

    public void complete() {
        this.status = WeekStatus.COMPLETED;
    }

    public boolean isActive() {
        return WeekStatus.ACTIVE.equals(this.status);
    }

    public boolean isCompleted() {
        return WeekStatus.COMPLETED.equals(this.status);
    }
}
