package com.ffl.playoffs.domain.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Objects;
import java.util.UUID;

/**
 * ScoreUpdate Value Object
 * Represents a single score update with delta tracking
 * Immutable domain model with no framework dependencies
 */
public final class ScoreUpdate {
    private final UUID id;
    private final String leaguePlayerId;
    private final String leagueId;
    private final BigDecimal previousScore;
    private final BigDecimal newScore;
    private final BigDecimal scoreDelta;
    private final String updatedPosition;
    private final Long nflPlayerId;
    private final String nflPlayerName;
    private final String statUpdate;
    private final LiveScoreStatus status;
    private final LocalDateTime timestamp;
    private final String idempotencyKey;

    private ScoreUpdate(Builder builder) {
        this.id = builder.id != null ? builder.id : UUID.randomUUID();
        this.leaguePlayerId = Objects.requireNonNull(builder.leaguePlayerId, "leaguePlayerId is required");
        this.leagueId = Objects.requireNonNull(builder.leagueId, "leagueId is required");
        this.previousScore = builder.previousScore != null ? builder.previousScore : BigDecimal.ZERO;
        this.newScore = Objects.requireNonNull(builder.newScore, "newScore is required");
        this.scoreDelta = this.newScore.subtract(this.previousScore);
        this.updatedPosition = builder.updatedPosition;
        this.nflPlayerId = builder.nflPlayerId;
        this.nflPlayerName = builder.nflPlayerName;
        this.statUpdate = builder.statUpdate;
        this.status = builder.status != null ? builder.status : LiveScoreStatus.LIVE;
        this.timestamp = builder.timestamp != null ? builder.timestamp : LocalDateTime.now();
        this.idempotencyKey = generateIdempotencyKey();
    }

    private String generateIdempotencyKey() {
        return String.format("%s-%s-%s-%s",
                leaguePlayerId,
                nflPlayerId != null ? nflPlayerId : "roster",
                newScore.toPlainString(),
                timestamp.toString());
    }

    public static Builder builder() {
        return new Builder();
    }

    public UUID getId() {
        return id;
    }

    public String getLeaguePlayerId() {
        return leaguePlayerId;
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

    public String getUpdatedPosition() {
        return updatedPosition;
    }

    public Long getNflPlayerId() {
        return nflPlayerId;
    }

    public String getNflPlayerName() {
        return nflPlayerName;
    }

    public String getStatUpdate() {
        return statUpdate;
    }

    public LiveScoreStatus getStatus() {
        return status;
    }

    public LocalDateTime getTimestamp() {
        return timestamp;
    }

    public String getIdempotencyKey() {
        return idempotencyKey;
    }

    /**
     * Check if this is a positive score change
     * @return true if score increased
     */
    public boolean isPositiveChange() {
        return scoreDelta.compareTo(BigDecimal.ZERO) > 0;
    }

    /**
     * Check if this is a negative score change (e.g., stat correction)
     * @return true if score decreased
     */
    public boolean isNegativeChange() {
        return scoreDelta.compareTo(BigDecimal.ZERO) < 0;
    }

    /**
     * Check if score is unchanged
     * @return true if score is the same
     */
    public boolean isUnchanged() {
        return scoreDelta.compareTo(BigDecimal.ZERO) == 0;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        ScoreUpdate that = (ScoreUpdate) o;
        return Objects.equals(idempotencyKey, that.idempotencyKey);
    }

    @Override
    public int hashCode() {
        return Objects.hash(idempotencyKey);
    }

    public static class Builder {
        private UUID id;
        private String leaguePlayerId;
        private String leagueId;
        private BigDecimal previousScore;
        private BigDecimal newScore;
        private String updatedPosition;
        private Long nflPlayerId;
        private String nflPlayerName;
        private String statUpdate;
        private LiveScoreStatus status;
        private LocalDateTime timestamp;

        public Builder id(UUID id) {
            this.id = id;
            return this;
        }

        public Builder leaguePlayerId(String leaguePlayerId) {
            this.leaguePlayerId = leaguePlayerId;
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

        public Builder updatedPosition(String updatedPosition) {
            this.updatedPosition = updatedPosition;
            return this;
        }

        public Builder nflPlayerId(Long nflPlayerId) {
            this.nflPlayerId = nflPlayerId;
            return this;
        }

        public Builder nflPlayerName(String nflPlayerName) {
            this.nflPlayerName = nflPlayerName;
            return this;
        }

        public Builder statUpdate(String statUpdate) {
            this.statUpdate = statUpdate;
            return this;
        }

        public Builder status(LiveScoreStatus status) {
            this.status = status;
            return this;
        }

        public Builder timestamp(LocalDateTime timestamp) {
            this.timestamp = timestamp;
            return this;
        }

        public ScoreUpdate build() {
            return new ScoreUpdate(this);
        }
    }
}
