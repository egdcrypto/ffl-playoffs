package com.ffl.playoffs.domain.event;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Domain event fired when an NFL game is completed
 * Triggers finalization of player scores for that game
 */
public class GameCompletedEvent {
    private final UUID eventId;
    private final UUID nflGameId;
    private final String homeTeam;
    private final String awayTeam;
    private final int homeScore;
    private final int awayScore;
    private final boolean isOvertime;
    private final List<Long> affectedNflPlayerIds;
    private final LocalDateTime occurredAt;

    private GameCompletedEvent(Builder builder) {
        this.eventId = UUID.randomUUID();
        this.nflGameId = builder.nflGameId;
        this.homeTeam = builder.homeTeam;
        this.awayTeam = builder.awayTeam;
        this.homeScore = builder.homeScore;
        this.awayScore = builder.awayScore;
        this.isOvertime = builder.isOvertime;
        this.affectedNflPlayerIds = builder.affectedNflPlayerIds != null ?
                List.copyOf(builder.affectedNflPlayerIds) : List.of();
        this.occurredAt = LocalDateTime.now();
    }

    public static Builder builder() {
        return new Builder();
    }

    public UUID getEventId() {
        return eventId;
    }

    public UUID getNflGameId() {
        return nflGameId;
    }

    public String getHomeTeam() {
        return homeTeam;
    }

    public String getAwayTeam() {
        return awayTeam;
    }

    public int getHomeScore() {
        return homeScore;
    }

    public int getAwayScore() {
        return awayScore;
    }

    public boolean isOvertime() {
        return isOvertime;
    }

    public List<Long> getAffectedNflPlayerIds() {
        return affectedNflPlayerIds;
    }

    public LocalDateTime getOccurredAt() {
        return occurredAt;
    }

    public String getGameSummary() {
        return String.format("%s %d - %s %d%s",
                homeTeam, homeScore, awayTeam, awayScore,
                isOvertime ? " (OT)" : "");
    }

    public static class Builder {
        private UUID nflGameId;
        private String homeTeam;
        private String awayTeam;
        private int homeScore;
        private int awayScore;
        private boolean isOvertime;
        private List<Long> affectedNflPlayerIds;

        public Builder nflGameId(UUID nflGameId) {
            this.nflGameId = nflGameId;
            return this;
        }

        public Builder homeTeam(String homeTeam) {
            this.homeTeam = homeTeam;
            return this;
        }

        public Builder awayTeam(String awayTeam) {
            this.awayTeam = awayTeam;
            return this;
        }

        public Builder homeScore(int homeScore) {
            this.homeScore = homeScore;
            return this;
        }

        public Builder awayScore(int awayScore) {
            this.awayScore = awayScore;
            return this;
        }

        public Builder isOvertime(boolean isOvertime) {
            this.isOvertime = isOvertime;
            return this;
        }

        public Builder affectedNflPlayerIds(List<Long> affectedNflPlayerIds) {
            this.affectedNflPlayerIds = affectedNflPlayerIds;
            return this;
        }

        public GameCompletedEvent build() {
            return new GameCompletedEvent(this);
        }
    }
}
