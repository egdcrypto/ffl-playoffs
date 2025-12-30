package com.ffl.playoffs.domain.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Value object representing a player's ranking in the playoffs
 * Can be for a single week or cumulative
 */
public class PlayoffRanking {
    private final UUID leaguePlayerId;
    private final String playerName;
    private final int rank;
    private final int previousRank;
    private final BigDecimal score;
    private final PlayoffRound round;
    private final boolean isCumulative;
    private final int roundsSurvived;
    private final PlayerPlayoffStatus status;
    private final LocalDateTime updatedAt;

    private PlayoffRanking(Builder builder) {
        this.leaguePlayerId = builder.leaguePlayerId;
        this.playerName = builder.playerName;
        this.rank = builder.rank;
        this.previousRank = builder.previousRank;
        this.score = builder.score;
        this.round = builder.round;
        this.isCumulative = builder.isCumulative;
        this.roundsSurvived = builder.roundsSurvived;
        this.status = builder.status;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Calculate the rank change from previous round
     * @return positive number if improved, negative if dropped, 0 if unchanged
     */
    public int getRankChange() {
        if (previousRank == 0) {
            return 0; // No previous rank available
        }
        return previousRank - rank; // Positive = improved
    }

    /**
     * Check if this player improved their rank
     * @return true if rank improved
     */
    public boolean hasImproved() {
        return getRankChange() > 0;
    }

    /**
     * Calculate survival rate as a percentage
     * @param totalRounds total rounds in the playoff
     * @return survival rate percentage
     */
    public double getSurvivalRate(int totalRounds) {
        if (totalRounds == 0) return 0.0;
        return (double) roundsSurvived / totalRounds * 100.0;
    }

    // Getters
    public UUID getLeaguePlayerId() { return leaguePlayerId; }
    public String getPlayerName() { return playerName; }
    public int getRank() { return rank; }
    public int getPreviousRank() { return previousRank; }
    public BigDecimal getScore() { return score; }
    public PlayoffRound getRound() { return round; }
    public boolean isCumulative() { return isCumulative; }
    public int getRoundsSurvived() { return roundsSurvived; }
    public PlayerPlayoffStatus getStatus() { return status; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }

    public static Builder builder() {
        return new Builder();
    }

    public static class Builder {
        private UUID leaguePlayerId;
        private String playerName;
        private int rank;
        private int previousRank;
        private BigDecimal score;
        private PlayoffRound round;
        private boolean isCumulative;
        private int roundsSurvived;
        private PlayerPlayoffStatus status;

        public Builder leaguePlayerId(UUID leaguePlayerId) {
            this.leaguePlayerId = leaguePlayerId;
            return this;
        }
        public Builder playerName(String playerName) {
            this.playerName = playerName;
            return this;
        }
        public Builder rank(int rank) {
            this.rank = rank;
            return this;
        }
        public Builder previousRank(int previousRank) {
            this.previousRank = previousRank;
            return this;
        }
        public Builder score(BigDecimal score) {
            this.score = score;
            return this;
        }
        public Builder round(PlayoffRound round) {
            this.round = round;
            return this;
        }
        public Builder isCumulative(boolean isCumulative) {
            this.isCumulative = isCumulative;
            return this;
        }
        public Builder roundsSurvived(int roundsSurvived) {
            this.roundsSurvived = roundsSurvived;
            return this;
        }
        public Builder status(PlayerPlayoffStatus status) {
            this.status = status;
            return this;
        }

        public PlayoffRanking build() {
            return new PlayoffRanking(this);
        }
    }
}
