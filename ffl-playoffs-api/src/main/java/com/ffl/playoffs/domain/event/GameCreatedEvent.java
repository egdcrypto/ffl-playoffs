package com.ffl.playoffs.domain.event;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Domain event raised when a new game is created.
 */
public class GameCreatedEvent {
    private final UUID eventId;
    private final UUID gameId;
    private final String gameName;
    private final UUID creatorId;
    private final LocalDateTime occurredAt;

    public GameCreatedEvent(UUID gameId, String gameName, UUID creatorId) {
        this.eventId = UUID.randomUUID();
        this.gameId = gameId;
        this.gameName = gameName;
        this.creatorId = creatorId;
        this.occurredAt = LocalDateTime.now();
    }

    public UUID getEventId() {
        return eventId;
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

    public LocalDateTime getOccurredAt() {
        return occurredAt;
    }
}
