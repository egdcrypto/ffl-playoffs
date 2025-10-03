package com.ffl.playoffs.domain.event;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Domain event raised when a player is eliminated from the game.
 */
public class TeamEliminatedEvent {
    private final UUID eventId;
    private final UUID playerId;
    private final UUID gameId;
    private final Integer weekNumber;
    private final LocalDateTime occurredAt;
    private final String reason;

    public TeamEliminatedEvent(UUID playerId, UUID gameId, Integer weekNumber, String reason) {
        this.eventId = UUID.randomUUID();
        this.playerId = playerId;
        this.gameId = gameId;
        this.weekNumber = weekNumber;
        this.reason = reason;
        this.occurredAt = LocalDateTime.now();
    }

    public UUID getEventId() {
        return eventId;
    }

    public UUID getPlayerId() {
        return playerId;
    }

    public UUID getGameId() {
        return gameId;
    }

    public Integer getWeekNumber() {
        return weekNumber;
    }

    public LocalDateTime getOccurredAt() {
        return occurredAt;
    }

    public String getReason() {
        return reason;
    }
}
