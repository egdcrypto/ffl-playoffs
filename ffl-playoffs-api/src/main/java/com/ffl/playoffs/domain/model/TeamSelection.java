package com.ffl.playoffs.domain.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Domain model representing a player's team selection for a week.
 */
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TeamSelection {
    private UUID id;
    private UUID playerId;
    private Integer weekNumber;
    private String nflTeam;
    private LocalDateTime selectedAt;
    private Integer pointsEarned;
    private boolean isScored;

    public void score(Integer points) {
        this.pointsEarned = points;
        this.isScored = true;
    }

    public boolean hasBeenScored() {
        return this.isScored;
    }
}
