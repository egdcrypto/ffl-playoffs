package com.ffl.playoffs.domain.event;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Domain event - fired when a new game is created
 * Domain model with no framework dependencies
 */
public class GameCreatedEvent {
    private final UUID gameId;
    private final String gameName;
    private final UUID creatorId;
    private final Integer startingWeek;
    private final LocalDateTime timestamp;

    public GameCreatedEvent(UUID gameId, String gameName, UUID creatorId, Integer startingWeek) {
        this.gameId = gameId;
        this.gameName = gameName;
        this.creatorId = creatorId;
        this.startingWeek = startingWeek;
        this.timestamp = LocalDateTime.now();
    }

    public UUID getGameId() {
        return gameId;
    }

    public String getGameName() {
        return gameName;
    }

    public UUID getCreatorId() {
        return creatorId;
    }

    public Integer getStartingWeek() {
        return startingWeek;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    @Override
    public String toString() {
        return "GameCreatedEvent{" +
                "gameId=" + gameId +
                ", gameName='" + gameName + '\'' +
                ", creatorId=" + creatorId +
                ", startingWeek=" + startingWeek +
                ", timestamp=" + timestamp +
                '}';
    }
}
