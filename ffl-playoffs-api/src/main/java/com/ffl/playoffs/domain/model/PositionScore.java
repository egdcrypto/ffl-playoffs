package com.ffl.playoffs.domain.model;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Value object representing the score for a single roster position
 * Includes player stats and calculated points
 */
public class PositionScore {
    private final Position position;
    private final Long nflPlayerId;
    private final String playerName;
    private final String nflTeam;
    private final BigDecimal points;
    private final String status; // ACTIVE, BYE, DNP, PARTIAL
    private final PositionStats stats;

    public PositionScore(Position position, Long nflPlayerId, String playerName,
                         String nflTeam, BigDecimal points, String status, PositionStats stats) {
        this.position = position;
        this.nflPlayerId = nflPlayerId;
        this.playerName = playerName;
        this.nflTeam = nflTeam;
        this.points = points != null ? points.setScale(2, RoundingMode.HALF_UP) : BigDecimal.ZERO;
        this.status = status;
        this.stats = stats;
    }

    // Factory method for a player on bye
    public static PositionScore byeWeek(Position position, Long nflPlayerId, String playerName, String nflTeam) {
        return new PositionScore(position, nflPlayerId, playerName, nflTeam,
            BigDecimal.ZERO, "BYE", null);
    }

    // Factory method for a player who did not play
    public static PositionScore didNotPlay(Position position, Long nflPlayerId, String playerName, String nflTeam) {
        return new PositionScore(position, nflPlayerId, playerName, nflTeam,
            BigDecimal.ZERO, "DNP", null);
    }

    public Position getPosition() {
        return position;
    }

    public Long getNflPlayerId() {
        return nflPlayerId;
    }

    public String getPlayerName() {
        return playerName;
    }

    public String getNflTeam() {
        return nflTeam;
    }

    public BigDecimal getPoints() {
        return points;
    }

    public String getStatus() {
        return status;
    }

    public PositionStats getStats() {
        return stats;
    }

    public boolean isOnBye() {
        return "BYE".equals(status);
    }

    public boolean didNotPlay() {
        return "DNP".equals(status);
    }

    public boolean isActive() {
        return "ACTIVE".equals(status);
    }

    /**
     * Inner class for detailed position stats
     */
    public static class PositionStats {
        private final Integer passingYards;
        private final Integer passingTouchdowns;
        private final Integer interceptions;
        private final Integer rushingYards;
        private final Integer rushingTouchdowns;
        private final Integer receivingYards;
        private final Integer receivingTouchdowns;
        private final Integer receptions;
        private final Integer fumblesLost;
        private final Integer sacks;
        private final Integer defensiveInterceptions;
        private final Integer fumbleRecoveries;
        private final Integer defensiveTouchdowns;
        private final Integer pointsAllowed;
        private final Integer fieldGoalsMade0to39;
        private final Integer fieldGoalsMade40to49;
        private final Integer fieldGoalsMade50Plus;
        private final Integer extraPointsMade;

        private PositionStats(Builder builder) {
            this.passingYards = builder.passingYards;
            this.passingTouchdowns = builder.passingTouchdowns;
            this.interceptions = builder.interceptions;
            this.rushingYards = builder.rushingYards;
            this.rushingTouchdowns = builder.rushingTouchdowns;
            this.receivingYards = builder.receivingYards;
            this.receivingTouchdowns = builder.receivingTouchdowns;
            this.receptions = builder.receptions;
            this.fumblesLost = builder.fumblesLost;
            this.sacks = builder.sacks;
            this.defensiveInterceptions = builder.defensiveInterceptions;
            this.fumbleRecoveries = builder.fumbleRecoveries;
            this.defensiveTouchdowns = builder.defensiveTouchdowns;
            this.pointsAllowed = builder.pointsAllowed;
            this.fieldGoalsMade0to39 = builder.fieldGoalsMade0to39;
            this.fieldGoalsMade40to49 = builder.fieldGoalsMade40to49;
            this.fieldGoalsMade50Plus = builder.fieldGoalsMade50Plus;
            this.extraPointsMade = builder.extraPointsMade;
        }

        public static Builder builder() {
            return new Builder();
        }

        // Getters
        public Integer getPassingYards() { return passingYards; }
        public Integer getPassingTouchdowns() { return passingTouchdowns; }
        public Integer getInterceptions() { return interceptions; }
        public Integer getRushingYards() { return rushingYards; }
        public Integer getRushingTouchdowns() { return rushingTouchdowns; }
        public Integer getReceivingYards() { return receivingYards; }
        public Integer getReceivingTouchdowns() { return receivingTouchdowns; }
        public Integer getReceptions() { return receptions; }
        public Integer getFumblesLost() { return fumblesLost; }
        public Integer getSacks() { return sacks; }
        public Integer getDefensiveInterceptions() { return defensiveInterceptions; }
        public Integer getFumbleRecoveries() { return fumbleRecoveries; }
        public Integer getDefensiveTouchdowns() { return defensiveTouchdowns; }
        public Integer getPointsAllowed() { return pointsAllowed; }
        public Integer getFieldGoalsMade0to39() { return fieldGoalsMade0to39; }
        public Integer getFieldGoalsMade40to49() { return fieldGoalsMade40to49; }
        public Integer getFieldGoalsMade50Plus() { return fieldGoalsMade50Plus; }
        public Integer getExtraPointsMade() { return extraPointsMade; }

        public int getTotalTouchdowns() {
            int total = 0;
            if (passingTouchdowns != null) total += passingTouchdowns;
            if (rushingTouchdowns != null) total += rushingTouchdowns;
            if (receivingTouchdowns != null) total += receivingTouchdowns;
            if (defensiveTouchdowns != null) total += defensiveTouchdowns;
            return total;
        }

        public int getTotalTurnovers() {
            int total = 0;
            if (interceptions != null) total += interceptions;
            if (fumblesLost != null) total += fumblesLost;
            return total;
        }

        public static class Builder {
            private Integer passingYards;
            private Integer passingTouchdowns;
            private Integer interceptions;
            private Integer rushingYards;
            private Integer rushingTouchdowns;
            private Integer receivingYards;
            private Integer receivingTouchdowns;
            private Integer receptions;
            private Integer fumblesLost;
            private Integer sacks;
            private Integer defensiveInterceptions;
            private Integer fumbleRecoveries;
            private Integer defensiveTouchdowns;
            private Integer pointsAllowed;
            private Integer fieldGoalsMade0to39;
            private Integer fieldGoalsMade40to49;
            private Integer fieldGoalsMade50Plus;
            private Integer extraPointsMade;

            public Builder passingYards(Integer passingYards) { this.passingYards = passingYards; return this; }
            public Builder passingTouchdowns(Integer passingTouchdowns) { this.passingTouchdowns = passingTouchdowns; return this; }
            public Builder interceptions(Integer interceptions) { this.interceptions = interceptions; return this; }
            public Builder rushingYards(Integer rushingYards) { this.rushingYards = rushingYards; return this; }
            public Builder rushingTouchdowns(Integer rushingTouchdowns) { this.rushingTouchdowns = rushingTouchdowns; return this; }
            public Builder receivingYards(Integer receivingYards) { this.receivingYards = receivingYards; return this; }
            public Builder receivingTouchdowns(Integer receivingTouchdowns) { this.receivingTouchdowns = receivingTouchdowns; return this; }
            public Builder receptions(Integer receptions) { this.receptions = receptions; return this; }
            public Builder fumblesLost(Integer fumblesLost) { this.fumblesLost = fumblesLost; return this; }
            public Builder sacks(Integer sacks) { this.sacks = sacks; return this; }
            public Builder defensiveInterceptions(Integer defensiveInterceptions) { this.defensiveInterceptions = defensiveInterceptions; return this; }
            public Builder fumbleRecoveries(Integer fumbleRecoveries) { this.fumbleRecoveries = fumbleRecoveries; return this; }
            public Builder defensiveTouchdowns(Integer defensiveTouchdowns) { this.defensiveTouchdowns = defensiveTouchdowns; return this; }
            public Builder pointsAllowed(Integer pointsAllowed) { this.pointsAllowed = pointsAllowed; return this; }
            public Builder fieldGoalsMade0to39(Integer fieldGoalsMade0to39) { this.fieldGoalsMade0to39 = fieldGoalsMade0to39; return this; }
            public Builder fieldGoalsMade40to49(Integer fieldGoalsMade40to49) { this.fieldGoalsMade40to49 = fieldGoalsMade40to49; return this; }
            public Builder fieldGoalsMade50Plus(Integer fieldGoalsMade50Plus) { this.fieldGoalsMade50Plus = fieldGoalsMade50Plus; return this; }
            public Builder extraPointsMade(Integer extraPointsMade) { this.extraPointsMade = extraPointsMade; return this; }

            public PositionStats build() {
                return new PositionStats(this);
            }
        }
    }
}
