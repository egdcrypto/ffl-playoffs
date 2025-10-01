package com.ffl.playoffs.domain.event;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Domain event - fired when a player is eliminated from the game
 * Domain model with no framework dependencies
 */
public class TeamEliminatedEvent {
    private final UUID playerId;
    private final UUID gameId;
    private final String playerName;
    private final Integer weekEliminated;
    private final LocalDateTime timestamp;

    public TeamEliminatedEvent(UUID playerId, UUID gameId, String playerName, Integer weekEliminated) {
        this.playerId = playerId;
        this.gameId = gameId;
        this.playerName = playerName;
        this.weekEliminated = weekEliminated;
        this.timestamp = LocalDateTime.now();
    }

    public UUID getPlayerId() {
        return playerId;
    }

    public UUID getGameId() {
        return gameId;
    }

    public String getPlayerName() {
        return playerName;
    }

    public Integer getWeekEliminated() {
        return weekEliminated;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    @Override
    public String toString() {
        return "TeamEliminatedEvent{" +
                "playerId=" + playerId +
                ", gameId=" + gameId +
                ", playerName='" + playerName + '\'' +
                ", weekEliminated=" + weekEliminated +
                ", timestamp=" + timestamp +
                '}';
    }
}
