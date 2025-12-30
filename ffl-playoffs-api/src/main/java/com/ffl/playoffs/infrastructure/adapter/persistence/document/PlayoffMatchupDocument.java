package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * MongoDB embedded document for PlayoffMatchup entity
 * Used within PlayoffBracketDocument
 */
public class PlayoffMatchupDocument {

    private String id;
    private String bracketId;
    private String round; // PlayoffRound as string
    private int matchupNumber;

    // Players
    private String player1Id;
    private String player1Name;
    private int player1Seed;
    private String player2Id;
    private String player2Name;
    private int player2Seed;

    // Scores (stored as embedded documents or references)
    private RosterScoreDocument player1Score;
    private RosterScoreDocument player2Score;

    // Result
    private String status; // MatchupStatus as string
    private String winnerId;
    private String loserId;
    private BigDecimal marginOfVictory;
    private boolean isUpset;
    private TiebreakerResultDocument tiebreakerResult;

    // Timestamps
    private LocalDateTime createdAt;
    private LocalDateTime completedAt;

    public PlayoffMatchupDocument() {
    }

    // Getters and Setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getBracketId() { return bracketId; }
    public void setBracketId(String bracketId) { this.bracketId = bracketId; }

    public String getRound() { return round; }
    public void setRound(String round) { this.round = round; }

    public int getMatchupNumber() { return matchupNumber; }
    public void setMatchupNumber(int matchupNumber) { this.matchupNumber = matchupNumber; }

    public String getPlayer1Id() { return player1Id; }
    public void setPlayer1Id(String player1Id) { this.player1Id = player1Id; }

    public String getPlayer1Name() { return player1Name; }
    public void setPlayer1Name(String player1Name) { this.player1Name = player1Name; }

    public int getPlayer1Seed() { return player1Seed; }
    public void setPlayer1Seed(int player1Seed) { this.player1Seed = player1Seed; }

    public String getPlayer2Id() { return player2Id; }
    public void setPlayer2Id(String player2Id) { this.player2Id = player2Id; }

    public String getPlayer2Name() { return player2Name; }
    public void setPlayer2Name(String player2Name) { this.player2Name = player2Name; }

    public int getPlayer2Seed() { return player2Seed; }
    public void setPlayer2Seed(int player2Seed) { this.player2Seed = player2Seed; }

    public RosterScoreDocument getPlayer1Score() { return player1Score; }
    public void setPlayer1Score(RosterScoreDocument player1Score) { this.player1Score = player1Score; }

    public RosterScoreDocument getPlayer2Score() { return player2Score; }
    public void setPlayer2Score(RosterScoreDocument player2Score) { this.player2Score = player2Score; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getWinnerId() { return winnerId; }
    public void setWinnerId(String winnerId) { this.winnerId = winnerId; }

    public String getLoserId() { return loserId; }
    public void setLoserId(String loserId) { this.loserId = loserId; }

    public BigDecimal getMarginOfVictory() { return marginOfVictory; }
    public void setMarginOfVictory(BigDecimal marginOfVictory) { this.marginOfVictory = marginOfVictory; }

    public boolean isUpset() { return isUpset; }
    public void setUpset(boolean upset) { isUpset = upset; }

    public TiebreakerResultDocument getTiebreakerResult() { return tiebreakerResult; }
    public void setTiebreakerResult(TiebreakerResultDocument tiebreakerResult) { this.tiebreakerResult = tiebreakerResult; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getCompletedAt() { return completedAt; }
    public void setCompletedAt(LocalDateTime completedAt) { this.completedAt = completedAt; }

    /**
     * Embedded document for tiebreaker result
     */
    public static class TiebreakerResultDocument {
        private String winnerId;
        private String loserId;
        private String methodUsed;
        private String winnerValue;
        private String loserValue;
        private boolean isTied;

        public String getWinnerId() { return winnerId; }
        public void setWinnerId(String winnerId) { this.winnerId = winnerId; }

        public String getLoserId() { return loserId; }
        public void setLoserId(String loserId) { this.loserId = loserId; }

        public String getMethodUsed() { return methodUsed; }
        public void setMethodUsed(String methodUsed) { this.methodUsed = methodUsed; }

        public String getWinnerValue() { return winnerValue; }
        public void setWinnerValue(String winnerValue) { this.winnerValue = winnerValue; }

        public String getLoserValue() { return loserValue; }
        public void setLoserValue(String loserValue) { this.loserValue = loserValue; }

        public boolean isTied() { return isTied; }
        public void setTied(boolean tied) { isTied = tied; }
    }
}
