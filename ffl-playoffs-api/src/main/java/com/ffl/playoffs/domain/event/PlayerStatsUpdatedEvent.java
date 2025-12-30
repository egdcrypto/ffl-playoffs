package com.ffl.playoffs.domain.event;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Domain event fired when NFL player statistics are updated during a live game
 * Part of the live scoring system
 */
public class PlayerStatsUpdatedEvent {
    private final UUID eventId;
    private final Long nflPlayerId;
    private final String nflPlayerName;
    private final UUID nflGameId;
    private final String gameInfo;
    private final String statUpdate;
    private final double previousPoints;
    private final double newPoints;
    private final double pointsDelta;
    private final LocalDateTime occurredAt;

    private PlayerStatsUpdatedEvent(Builder builder) {
        this.eventId = UUID.randomUUID();
        this.nflPlayerId = builder.nflPlayerId;
        this.nflPlayerName = builder.nflPlayerName;
        this.nflGameId = builder.nflGameId;
        this.gameInfo = builder.gameInfo;
        this.statUpdate = builder.statUpdate;
        this.previousPoints = builder.previousPoints;
        this.newPoints = builder.newPoints;
        this.pointsDelta = builder.newPoints - builder.previousPoints;
        this.occurredAt = LocalDateTime.now();
    }

    public static Builder builder() {
        return new Builder();
    }

    public UUID getEventId() {
        return eventId;
    }

    public Long getNflPlayerId() {
        return nflPlayerId;
    }

    public String getNflPlayerName() {
        return nflPlayerName;
    }

    public UUID getNflGameId() {
        return nflGameId;
    }

    public String getGameInfo() {
        return gameInfo;
    }

    public String getStatUpdate() {
        return statUpdate;
    }

    public double getPreviousPoints() {
        return previousPoints;
    }

    public double getNewPoints() {
        return newPoints;
    }

    public double getPointsDelta() {
        return pointsDelta;
    }

    public LocalDateTime getOccurredAt() {
        return occurredAt;
    }

    public static class Builder {
        private Long nflPlayerId;
        private String nflPlayerName;
        private UUID nflGameId;
        private String gameInfo;
        private String statUpdate;
        private double previousPoints;
        private double newPoints;

        public Builder nflPlayerId(Long nflPlayerId) {
            this.nflPlayerId = nflPlayerId;
            return this;
        }

        public Builder nflPlayerName(String nflPlayerName) {
            this.nflPlayerName = nflPlayerName;
            return this;
        }

        public Builder nflGameId(UUID nflGameId) {
            this.nflGameId = nflGameId;
            return this;
        }

        public Builder gameInfo(String gameInfo) {
            this.gameInfo = gameInfo;
            return this;
        }

        public Builder statUpdate(String statUpdate) {
            this.statUpdate = statUpdate;
            return this;
        }

        public Builder previousPoints(double previousPoints) {
            this.previousPoints = previousPoints;
            return this;
        }

        public Builder newPoints(double newPoints) {
            this.newPoints = newPoints;
            return this;
        }

        public PlayerStatsUpdatedEvent build() {
            return new PlayerStatsUpdatedEvent(this);
        }
    }
}
