package com.ffl.playoffs.application.dto;

import com.ffl.playoffs.domain.model.LiveScoreStatus;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Data Transfer Object for Live Score information
 * Used for WebSocket and API communication
 */
public class LiveScoreDTO {
    private String leaguePlayerId;
    private String playerName;
    private BigDecimal currentScore;
    private BigDecimal previousScore;
    private BigDecimal scoreDelta;
    private List<PositionScoreDTO> positionBreakdown;
    private LiveScoreStatus status;
    private int currentRank;
    private int previousRank;
    private LocalDateTime lastUpdated;

    public LiveScoreDTO() {
    }

    public String getLeaguePlayerId() {
        return leaguePlayerId;
    }

    public void setLeaguePlayerId(String leaguePlayerId) {
        this.leaguePlayerId = leaguePlayerId;
    }

    public String getPlayerName() {
        return playerName;
    }

    public void setPlayerName(String playerName) {
        this.playerName = playerName;
    }

    public BigDecimal getCurrentScore() {
        return currentScore;
    }

    public void setCurrentScore(BigDecimal currentScore) {
        this.currentScore = currentScore;
    }

    public BigDecimal getPreviousScore() {
        return previousScore;
    }

    public void setPreviousScore(BigDecimal previousScore) {
        this.previousScore = previousScore;
    }

    public BigDecimal getScoreDelta() {
        return scoreDelta;
    }

    public void setScoreDelta(BigDecimal scoreDelta) {
        this.scoreDelta = scoreDelta;
    }

    public List<PositionScoreDTO> getPositionBreakdown() {
        return positionBreakdown;
    }

    public void setPositionBreakdown(List<PositionScoreDTO> positionBreakdown) {
        this.positionBreakdown = positionBreakdown;
    }

    public LiveScoreStatus getStatus() {
        return status;
    }

    public void setStatus(LiveScoreStatus status) {
        this.status = status;
    }

    public int getCurrentRank() {
        return currentRank;
    }

    public void setCurrentRank(int currentRank) {
        this.currentRank = currentRank;
    }

    public int getPreviousRank() {
        return previousRank;
    }

    public void setPreviousRank(int previousRank) {
        this.previousRank = previousRank;
    }

    public LocalDateTime getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(LocalDateTime lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public static class PositionScoreDTO {
        private String position;
        private Long nflPlayerId;
        private String nflPlayerName;
        private BigDecimal score;
        private BigDecimal scoreDelta;
        private String gameInfo;
        private LiveScoreStatus status;
        private String lastStatUpdate;

        public PositionScoreDTO() {
        }

        public String getPosition() {
            return position;
        }

        public void setPosition(String position) {
            this.position = position;
        }

        public Long getNflPlayerId() {
            return nflPlayerId;
        }

        public void setNflPlayerId(Long nflPlayerId) {
            this.nflPlayerId = nflPlayerId;
        }

        public String getNflPlayerName() {
            return nflPlayerName;
        }

        public void setNflPlayerName(String nflPlayerName) {
            this.nflPlayerName = nflPlayerName;
        }

        public BigDecimal getScore() {
            return score;
        }

        public void setScore(BigDecimal score) {
            this.score = score;
        }

        public BigDecimal getScoreDelta() {
            return scoreDelta;
        }

        public void setScoreDelta(BigDecimal scoreDelta) {
            this.scoreDelta = scoreDelta;
        }

        public String getGameInfo() {
            return gameInfo;
        }

        public void setGameInfo(String gameInfo) {
            this.gameInfo = gameInfo;
        }

        public LiveScoreStatus getStatus() {
            return status;
        }

        public void setStatus(LiveScoreStatus status) {
            this.status = status;
        }

        public String getLastStatUpdate() {
            return lastStatUpdate;
        }

        public void setLastStatUpdate(String lastStatUpdate) {
            this.lastStatUpdate = lastStatUpdate;
        }
    }
}
