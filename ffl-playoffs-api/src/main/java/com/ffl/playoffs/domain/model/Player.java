package com.ffl.playoffs.domain.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Domain model representing a player in the game.
 */
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Player {
    private UUID id;
    private UUID gameId;
    private String name;
    private String email;
    private PlayerStatus status;
    private LocalDateTime joinedAt;
    private List<TeamSelection> teamSelections;
    private Integer totalScore;
    private boolean isEliminated;

    public enum PlayerStatus {
        INVITED,
        ACTIVE,
        ELIMINATED
    }

    public void activate() {
        this.status = PlayerStatus.ACTIVE;
    }

    public void eliminate() {
        this.status = PlayerStatus.ELIMINATED;
        this.isEliminated = true;
    }

    public void addTeamSelection(TeamSelection selection) {
        if (this.teamSelections != null) {
            this.teamSelections.add(selection);
        }
    }

    public void updateScore(Integer points) {
        if (this.totalScore == null) {
            this.totalScore = points;
        } else {
            this.totalScore += points;
        }
    }
}
