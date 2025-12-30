package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * MongoDB embedded document for PlayoffRanking value object
 */
public class PlayoffRankingDocument {

    private String leaguePlayerId;
    private String playerName;
    private int rank;
    private int previousRank;
    private BigDecimal score;
    private String round; // PlayoffRound as string
    private boolean isCumulative;
    private int roundsSurvived;
    private String status; // PlayerPlayoffStatus as string
    private LocalDateTime updatedAt;

    public PlayoffRankingDocument() {
    }

    // Getters and Setters
    public String getLeaguePlayerId() { return leaguePlayerId; }
    public void setLeaguePlayerId(String leaguePlayerId) { this.leaguePlayerId = leaguePlayerId; }

    public String getPlayerName() { return playerName; }
    public void setPlayerName(String playerName) { this.playerName = playerName; }

    public int getRank() { return rank; }
    public void setRank(int rank) { this.rank = rank; }

    public int getPreviousRank() { return previousRank; }
    public void setPreviousRank(int previousRank) { this.previousRank = previousRank; }

    public BigDecimal getScore() { return score; }
    public void setScore(BigDecimal score) { this.score = score; }

    public String getRound() { return round; }
    public void setRound(String round) { this.round = round; }

    public boolean isCumulative() { return isCumulative; }
    public void setCumulative(boolean cumulative) { isCumulative = cumulative; }

    public int getRoundsSurvived() { return roundsSurvived; }
    public void setRoundsSurvived(int roundsSurvived) { this.roundsSurvived = roundsSurvived; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
