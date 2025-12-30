package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * MongoDB embedded document for RosterScore value object
 */
public class RosterScoreDocument {

    private String id;
    private String leaguePlayerId;
    private String playerName;
    private String round; // PlayoffRound as string
    private List<PositionScoreDocument> positionScores;
    private BigDecimal totalScore;
    private int totalTouchdowns;
    private int totalTurnovers;
    private LocalDateTime calculatedAt;
    private boolean isComplete;

    public RosterScoreDocument() {
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getLeaguePlayerId() { return leaguePlayerId; }
    public void setLeaguePlayerId(String leaguePlayerId) { this.leaguePlayerId = leaguePlayerId; }

    public String getPlayerName() { return playerName; }
    public void setPlayerName(String playerName) { this.playerName = playerName; }

    public String getRound() { return round; }
    public void setRound(String round) { this.round = round; }

    public List<PositionScoreDocument> getPositionScores() { return positionScores; }
    public void setPositionScores(List<PositionScoreDocument> positionScores) { this.positionScores = positionScores; }

    public BigDecimal getTotalScore() { return totalScore; }
    public void setTotalScore(BigDecimal totalScore) { this.totalScore = totalScore; }

    public int getTotalTouchdowns() { return totalTouchdowns; }
    public void setTotalTouchdowns(int totalTouchdowns) { this.totalTouchdowns = totalTouchdowns; }

    public int getTotalTurnovers() { return totalTurnovers; }
    public void setTotalTurnovers(int totalTurnovers) { this.totalTurnovers = totalTurnovers; }

    public LocalDateTime getCalculatedAt() { return calculatedAt; }
    public void setCalculatedAt(LocalDateTime calculatedAt) { this.calculatedAt = calculatedAt; }

    public boolean isComplete() { return isComplete; }
    public void setComplete(boolean complete) { isComplete = complete; }

    /**
     * Embedded document for position score
     */
    public static class PositionScoreDocument {
        private String position;
        private Long nflPlayerId;
        private String playerName;
        private String nflTeam;
        private BigDecimal points;
        private String status;
        private PositionStatsDocument stats;

        public String getPosition() { return position; }
        public void setPosition(String position) { this.position = position; }

        public Long getNflPlayerId() { return nflPlayerId; }
        public void setNflPlayerId(Long nflPlayerId) { this.nflPlayerId = nflPlayerId; }

        public String getPlayerName() { return playerName; }
        public void setPlayerName(String playerName) { this.playerName = playerName; }

        public String getNflTeam() { return nflTeam; }
        public void setNflTeam(String nflTeam) { this.nflTeam = nflTeam; }

        public BigDecimal getPoints() { return points; }
        public void setPoints(BigDecimal points) { this.points = points; }

        public String getStatus() { return status; }
        public void setStatus(String status) { this.status = status; }

        public PositionStatsDocument getStats() { return stats; }
        public void setStats(PositionStatsDocument stats) { this.stats = stats; }
    }

    /**
     * Embedded document for position stats
     */
    public static class PositionStatsDocument {
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

        // Getters and Setters
        public Integer getPassingYards() { return passingYards; }
        public void setPassingYards(Integer passingYards) { this.passingYards = passingYards; }

        public Integer getPassingTouchdowns() { return passingTouchdowns; }
        public void setPassingTouchdowns(Integer passingTouchdowns) { this.passingTouchdowns = passingTouchdowns; }

        public Integer getInterceptions() { return interceptions; }
        public void setInterceptions(Integer interceptions) { this.interceptions = interceptions; }

        public Integer getRushingYards() { return rushingYards; }
        public void setRushingYards(Integer rushingYards) { this.rushingYards = rushingYards; }

        public Integer getRushingTouchdowns() { return rushingTouchdowns; }
        public void setRushingTouchdowns(Integer rushingTouchdowns) { this.rushingTouchdowns = rushingTouchdowns; }

        public Integer getReceivingYards() { return receivingYards; }
        public void setReceivingYards(Integer receivingYards) { this.receivingYards = receivingYards; }

        public Integer getReceivingTouchdowns() { return receivingTouchdowns; }
        public void setReceivingTouchdowns(Integer receivingTouchdowns) { this.receivingTouchdowns = receivingTouchdowns; }

        public Integer getReceptions() { return receptions; }
        public void setReceptions(Integer receptions) { this.receptions = receptions; }

        public Integer getFumblesLost() { return fumblesLost; }
        public void setFumblesLost(Integer fumblesLost) { this.fumblesLost = fumblesLost; }

        public Integer getSacks() { return sacks; }
        public void setSacks(Integer sacks) { this.sacks = sacks; }

        public Integer getDefensiveInterceptions() { return defensiveInterceptions; }
        public void setDefensiveInterceptions(Integer defensiveInterceptions) { this.defensiveInterceptions = defensiveInterceptions; }

        public Integer getFumbleRecoveries() { return fumbleRecoveries; }
        public void setFumbleRecoveries(Integer fumbleRecoveries) { this.fumbleRecoveries = fumbleRecoveries; }

        public Integer getDefensiveTouchdowns() { return defensiveTouchdowns; }
        public void setDefensiveTouchdowns(Integer defensiveTouchdowns) { this.defensiveTouchdowns = defensiveTouchdowns; }

        public Integer getPointsAllowed() { return pointsAllowed; }
        public void setPointsAllowed(Integer pointsAllowed) { this.pointsAllowed = pointsAllowed; }

        public Integer getFieldGoalsMade0to39() { return fieldGoalsMade0to39; }
        public void setFieldGoalsMade0to39(Integer fieldGoalsMade0to39) { this.fieldGoalsMade0to39 = fieldGoalsMade0to39; }

        public Integer getFieldGoalsMade40to49() { return fieldGoalsMade40to49; }
        public void setFieldGoalsMade40to49(Integer fieldGoalsMade40to49) { this.fieldGoalsMade40to49 = fieldGoalsMade40to49; }

        public Integer getFieldGoalsMade50Plus() { return fieldGoalsMade50Plus; }
        public void setFieldGoalsMade50Plus(Integer fieldGoalsMade50Plus) { this.fieldGoalsMade50Plus = fieldGoalsMade50Plus; }

        public Integer getExtraPointsMade() { return extraPointsMade; }
        public void setExtraPointsMade(Integer extraPointsMade) { this.extraPointsMade = extraPointsMade; }
    }
}
