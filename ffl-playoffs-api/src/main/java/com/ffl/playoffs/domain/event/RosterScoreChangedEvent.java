package com.ffl.playoffs.domain.event;

import com.ffl.playoffs.domain.model.LiveScoreStatus;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Domain event fired when a league player's roster score changes
 * Triggers WebSocket updates and potential notifications
 */
public class RosterScoreChangedEvent {
    private final UUID eventId;
    private final String leaguePlayerId;
    private final String playerName;
    private final String leagueId;
    private final BigDecimal previousScore;
    private final BigDecimal newScore;
    private final BigDecimal scoreDelta;
    private final List<String> updatedPositions;
    private final LiveScoreStatus status;
    private final LocalDateTime occurredAt;

    private RosterScoreChangedEvent(Builder builder) {
        this.eventId = UUID.randomUUID();
        this.leaguePlayerId = builder.leaguePlayerId;
        this.playerName = builder.playerName;
        this.leagueId = builder.leagueId;
        this.previousScore = builder.previousScore;
        this.newScore = builder.newScore;
        this.scoreDelta = builder.newScore.subtract(builder.previousScore);
        this.updatedPositions = builder.updatedPositions != null ?
                List.copyOf(builder.updatedPositions) : List.of();
        this.status = builder.status;
        this.occurredAt = LocalDateTime.now();
    }

    public static Builder builder() {
        return new Builder();
    }

    public UUID getEventId() {
        return eventId;
    }

    public String getLeaguePlayerId() {
        return leaguePlayerId;
    }

    public String getPlayerName() {
        return playerName;
    }

    public String getLeagueId() {
        return leagueId;
    }

    public BigDecimal getPreviousScore() {
        return previousScore;
    }

    public BigDecimal getNewScore() {
        return newScore;
    }

    public BigDecimal getScoreDelta() {
        return scoreDelta;
    }

    public List<String> getUpdatedPositions() {
        return updatedPositions;
    }

    public LiveScoreStatus getStatus() {
        return status;
    }

    public LocalDateTime getOccurredAt() {
        return occurredAt;
    }

    /**
     * Check if the score crossed a milestone (every 50 points)
     * @param milestone the milestone to check (e.g., 100, 150)
     * @return true if this update crossed the milestone
     */
    public boolean crossedMilestone(int milestone) {
        return previousScore.intValue() < milestone && newScore.intValue() >= milestone;
    }

    public static class Builder {
        private String leaguePlayerId;
        private String playerName;
        private String leagueId;
        private BigDecimal previousScore;
        private BigDecimal newScore;
        private List<String> updatedPositions;
        private LiveScoreStatus status;

        public Builder leaguePlayerId(String leaguePlayerId) {
            this.leaguePlayerId = leaguePlayerId;
            return this;
        }

        public Builder playerName(String playerName) {
            this.playerName = playerName;
            return this;
        }

        public Builder leagueId(String leagueId) {
            this.leagueId = leagueId;
            return this;
        }

        public Builder previousScore(BigDecimal previousScore) {
            this.previousScore = previousScore;
            return this;
        }

        public Builder newScore(BigDecimal newScore) {
            this.newScore = newScore;
            return this;
        }

        public Builder updatedPositions(List<String> updatedPositions) {
            this.updatedPositions = updatedPositions;
            return this;
        }

        public Builder status(LiveScoreStatus status) {
            this.status = status;
            return this;
        }

        public RosterScoreChangedEvent build() {
            return new RosterScoreChangedEvent(this);
        }
    }
}
