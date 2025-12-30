package com.ffl.playoffs.domain.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Objects;

/**
 * RankChange Value Object
 * Represents a change in leaderboard position
 * Immutable domain model with no framework dependencies
 */
public final class RankChange {
    private final String leaguePlayerId;
    private final String playerName;
    private final String leagueId;
    private final int previousRank;
    private final int newRank;
    private final int rankDelta;
    private final String leaderName;
    private final BigDecimal pointsBehindLeader;
    private final BigDecimal currentScore;
    private final LocalDateTime timestamp;

    private RankChange(Builder builder) {
        this.leaguePlayerId = Objects.requireNonNull(builder.leaguePlayerId, "leaguePlayerId is required");
        this.playerName = builder.playerName;
        this.leagueId = Objects.requireNonNull(builder.leagueId, "leagueId is required");
        this.previousRank = builder.previousRank;
        this.newRank = builder.newRank;
        this.rankDelta = this.previousRank - this.newRank; // Positive means moved up
        this.leaderName = builder.leaderName;
        this.pointsBehindLeader = builder.pointsBehindLeader;
        this.currentScore = builder.currentScore;
        this.timestamp = builder.timestamp != null ? builder.timestamp : LocalDateTime.now();
    }

    public static Builder builder() {
        return new Builder();
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

    public int getPreviousRank() {
        return previousRank;
    }

    public int getNewRank() {
        return newRank;
    }

    public int getRankDelta() {
        return rankDelta;
    }

    public String getLeaderName() {
        return leaderName;
    }

    public BigDecimal getPointsBehindLeader() {
        return pointsBehindLeader;
    }

    public BigDecimal getCurrentScore() {
        return currentScore;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    /**
     * Check if player moved up in rankings
     * @return true if rank improved (lower number)
     */
    public boolean movedUp() {
        return rankDelta > 0;
    }

    /**
     * Check if player moved down in rankings
     * @return true if rank dropped (higher number)
     */
    public boolean movedDown() {
        return rankDelta < 0;
    }

    /**
     * Check if player is now the leader
     * @return true if new rank is 1
     */
    public boolean isNowLeader() {
        return newRank == 1;
    }

    /**
     * Check if player entered top 3
     * @return true if moved into top 3 from outside
     */
    public boolean enteredTopThree() {
        return previousRank > 3 && newRank <= 3;
    }

    /**
     * Check if this is a significant rank change (3+ positions)
     * @return true if significant change
     */
    public boolean isSignificant() {
        return Math.abs(rankDelta) >= 3;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        RankChange that = (RankChange) o;
        return previousRank == that.previousRank &&
                newRank == that.newRank &&
                Objects.equals(leaguePlayerId, that.leaguePlayerId) &&
                Objects.equals(leagueId, that.leagueId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(leaguePlayerId, leagueId, previousRank, newRank);
    }

    public static class Builder {
        private String leaguePlayerId;
        private String playerName;
        private String leagueId;
        private int previousRank;
        private int newRank;
        private String leaderName;
        private BigDecimal pointsBehindLeader;
        private BigDecimal currentScore;
        private LocalDateTime timestamp;

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

        public Builder previousRank(int previousRank) {
            this.previousRank = previousRank;
            return this;
        }

        public Builder newRank(int newRank) {
            this.newRank = newRank;
            return this;
        }

        public Builder leaderName(String leaderName) {
            this.leaderName = leaderName;
            return this;
        }

        public Builder pointsBehindLeader(BigDecimal pointsBehindLeader) {
            this.pointsBehindLeader = pointsBehindLeader;
            return this;
        }

        public Builder currentScore(BigDecimal currentScore) {
            this.currentScore = currentScore;
            return this;
        }

        public Builder timestamp(LocalDateTime timestamp) {
            this.timestamp = timestamp;
            return this;
        }

        public RankChange build() {
            return new RankChange(this);
        }
    }
}
