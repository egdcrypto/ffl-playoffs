package com.ffl.playoffs.domain.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Domain model representing a playoff game.
 * This is a pure domain entity with no framework dependencies.
 */
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Game {
    private UUID id;
    private String name;
    private UUID creatorId;
    private LocalDateTime createdAt;
    private GameStatus status;
    private List<Player> players;
    private List<Week> weeks;
    private Integer currentWeek;
    private ScoringRules scoringRules;

    public enum GameStatus {
        SETUP,
        IN_PROGRESS,
        COMPLETED
    }

    public void addPlayer(Player player) {
        if (this.players == null) {
            this.players = new ArrayList<>();
        }
        this.players.add(player);
    }

    public void startGame() {
        this.status = GameStatus.IN_PROGRESS;
        this.currentWeek = 1;
    }

    public void advanceWeek() {
        if (this.currentWeek != null) {
            this.currentWeek++;
        }
    }

    public void completeGame() {
        this.status = GameStatus.COMPLETED;
    }

    public boolean isSetup() {
        return GameStatus.SETUP.equals(this.status);
    }

    public boolean isInProgress() {
        return GameStatus.IN_PROGRESS.equals(this.status);
    }

    public boolean isCompleted() {
        return GameStatus.COMPLETED.equals(this.status);
    }
}
