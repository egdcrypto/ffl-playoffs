package com.ffl.playoffs.application.dto;

import com.ffl.playoffs.domain.model.LiveScoreStatus;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Data Transfer Object for Live Leaderboard
 * Used for real-time leaderboard display
 */
public class LiveLeaderboardDTO {
    private String leagueId;
    private String leagueName;
    private List<LiveLeaderboardEntryDTO> entries;
    private int totalPlayers;
    private int page;
    private int pageSize;
    private LocalDateTime lastUpdated;
    private boolean isLive;

    public LiveLeaderboardDTO() {
    }

    public String getLeagueId() {
        return leagueId;
    }

    public void setLeagueId(String leagueId) {
        this.leagueId = leagueId;
    }

    public String getLeagueName() {
        return leagueName;
    }

    public void setLeagueName(String leagueName) {
        this.leagueName = leagueName;
    }

    public List<LiveLeaderboardEntryDTO> getEntries() {
        return entries;
    }

    public void setEntries(List<LiveLeaderboardEntryDTO> entries) {
        this.entries = entries;
    }

    public int getTotalPlayers() {
        return totalPlayers;
    }

    public void setTotalPlayers(int totalPlayers) {
        this.totalPlayers = totalPlayers;
    }

    public int getPage() {
        return page;
    }

    public void setPage(int page) {
        this.page = page;
    }

    public int getPageSize() {
        return pageSize;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public LocalDateTime getLastUpdated() {
        return lastUpdated;
    }

    public void setLastUpdated(LocalDateTime lastUpdated) {
        this.lastUpdated = lastUpdated;
    }

    public boolean isLive() {
        return isLive;
    }

    public void setLive(boolean live) {
        isLive = live;
    }

    public static class LiveLeaderboardEntryDTO {
        private int rank;
        private int previousRank;
        private int rankDelta;
        private String leaguePlayerId;
        private String playerName;
        private BigDecimal totalScore;
        private BigDecimal scoreDelta;
        private BigDecimal pointsBehindLeader;
        private LiveScoreStatus status;
        private LocalDateTime lastScoreUpdate;
        private boolean hasLivePlayers;

        public LiveLeaderboardEntryDTO() {
        }

        public int getRank() {
            return rank;
        }

        public void setRank(int rank) {
            this.rank = rank;
        }

        public int getPreviousRank() {
            return previousRank;
        }

        public void setPreviousRank(int previousRank) {
            this.previousRank = previousRank;
        }

        public int getRankDelta() {
            return rankDelta;
        }

        public void setRankDelta(int rankDelta) {
            this.rankDelta = rankDelta;
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

        public BigDecimal getTotalScore() {
            return totalScore;
        }

        public void setTotalScore(BigDecimal totalScore) {
            this.totalScore = totalScore;
        }

        public BigDecimal getScoreDelta() {
            return scoreDelta;
        }

        public void setScoreDelta(BigDecimal scoreDelta) {
            this.scoreDelta = scoreDelta;
        }

        public BigDecimal getPointsBehindLeader() {
            return pointsBehindLeader;
        }

        public void setPointsBehindLeader(BigDecimal pointsBehindLeader) {
            this.pointsBehindLeader = pointsBehindLeader;
        }

        public LiveScoreStatus getStatus() {
            return status;
        }

        public void setStatus(LiveScoreStatus status) {
            this.status = status;
        }

        public LocalDateTime getLastScoreUpdate() {
            return lastScoreUpdate;
        }

        public void setLastScoreUpdate(LocalDateTime lastScoreUpdate) {
            this.lastScoreUpdate = lastScoreUpdate;
        }

        public boolean isHasLivePlayers() {
            return hasLivePlayers;
        }

        public void setHasLivePlayers(boolean hasLivePlayers) {
            this.hasLivePlayers = hasLivePlayers;
        }
    }
}
