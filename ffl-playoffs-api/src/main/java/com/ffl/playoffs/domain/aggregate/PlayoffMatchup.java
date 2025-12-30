package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.MatchupStatus;
import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.model.RosterScore;
import com.ffl.playoffs.domain.model.TiebreakerMethod;
import com.ffl.playoffs.domain.model.TiebreakerResult;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Entity representing a single playoff matchup between two players
 * Part of the PlayoffBracket aggregate
 */
public class PlayoffMatchup {
    private UUID id;
    private UUID bracketId;
    private PlayoffRound round;
    private int matchupNumber;

    // Players
    private UUID player1Id;
    private String player1Name;
    private int player1Seed;
    private UUID player2Id;
    private String player2Name;
    private int player2Seed;

    // Scores
    private RosterScore player1Score;
    private RosterScore player2Score;

    // Result
    private MatchupStatus status;
    private UUID winnerId;
    private UUID loserId;
    private BigDecimal marginOfVictory;
    private boolean isUpset;
    private TiebreakerResult tiebreakerResult;

    // Timestamps
    private LocalDateTime createdAt;
    private LocalDateTime completedAt;

    public PlayoffMatchup() {
        this.id = UUID.randomUUID();
        this.status = MatchupStatus.SCHEDULED;
        this.createdAt = LocalDateTime.now();
    }

    public PlayoffMatchup(UUID bracketId, PlayoffRound round, int matchupNumber) {
        this();
        this.bracketId = bracketId;
        this.round = round;
        this.matchupNumber = matchupNumber;
    }

    // Business Methods

    /**
     * Set player 1 for this matchup
     */
    public void setPlayer1(UUID playerId, String playerName, int seed) {
        validateMatchupNotComplete();
        this.player1Id = playerId;
        this.player1Name = playerName;
        this.player1Seed = seed;
    }

    /**
     * Set player 2 for this matchup
     */
    public void setPlayer2(UUID playerId, String playerName, int seed) {
        validateMatchupNotComplete();
        this.player2Id = playerId;
        this.player2Name = playerName;
        this.player2Seed = seed;
    }

    /**
     * Update score for player 1
     */
    public void updatePlayer1Score(RosterScore score) {
        validateMatchupNotComplete();
        this.player1Score = score;
        updateStatus();
    }

    /**
     * Update score for player 2
     */
    public void updatePlayer2Score(RosterScore score) {
        validateMatchupNotComplete();
        this.player2Score = score;
        updateStatus();
    }

    /**
     * Determine the winner based on scores
     * Returns true if winner determined, false if tiebreaker needed
     */
    public boolean determineWinner() {
        if (player1Score == null || player2Score == null) {
            return false;
        }

        BigDecimal score1 = player1Score.getTotalScore();
        BigDecimal score2 = player2Score.getTotalScore();
        int comparison = score1.compareTo(score2);

        if (comparison > 0) {
            setWinner(player1Id, player2Id, score1.subtract(score2));
            return true;
        } else if (comparison < 0) {
            setWinner(player2Id, player1Id, score2.subtract(score1));
            return true;
        } else {
            // Tied - tiebreaker needed
            this.status = MatchupStatus.TIED;
            return false;
        }
    }

    /**
     * Apply tiebreaker result to resolve the matchup
     */
    public void applyTiebreakerResult(TiebreakerResult result) {
        if (this.status != MatchupStatus.TIED) {
            throw new IllegalStateException("Cannot apply tiebreaker - matchup is not tied");
        }

        this.tiebreakerResult = result;

        if (result.isResolved()) {
            setWinner(result.getWinnerId(), result.getLoserId(), BigDecimal.ZERO);
        } else if (result.getMethodUsed() == TiebreakerMethod.CO_WINNERS) {
            // Both declared co-winners (championship only)
            this.status = MatchupStatus.COMPLETED;
            this.completedAt = LocalDateTime.now();
        }
    }

    private void setWinner(UUID winnerId, UUID loserId, BigDecimal margin) {
        this.winnerId = winnerId;
        this.loserId = loserId;
        this.marginOfVictory = margin.abs();
        this.status = MatchupStatus.COMPLETED;
        this.completedAt = LocalDateTime.now();

        // Check for upset (lower seed beats higher seed)
        if (winnerId.equals(player1Id) && player1Seed > player2Seed) {
            this.isUpset = true;
        } else if (winnerId.equals(player2Id) && player2Seed > player1Seed) {
            this.isUpset = true;
        }
    }

    private void updateStatus() {
        if (player1Score != null && player2Score != null) {
            if (player1Score.isComplete() && player2Score.isComplete()) {
                // Both scores complete - can determine winner
                if (status != MatchupStatus.COMPLETED && status != MatchupStatus.TIED) {
                    status = MatchupStatus.IN_PROGRESS;
                }
            } else {
                status = MatchupStatus.IN_PROGRESS;
            }
        }
    }

    private void validateMatchupNotComplete() {
        if (status == MatchupStatus.COMPLETED) {
            throw new IllegalStateException("Cannot modify a completed matchup");
        }
    }

    /**
     * Check if this matchup is ready to determine a winner
     */
    public boolean isReadyForResult() {
        return player1Score != null && player2Score != null
            && player1Score.isComplete() && player2Score.isComplete();
    }

    /**
     * Get the score for a specific player
     */
    public RosterScore getScoreForPlayer(UUID playerId) {
        if (player1Id.equals(playerId)) {
            return player1Score;
        } else if (player2Id.equals(playerId)) {
            return player2Score;
        }
        return null;
    }

    /**
     * Check if a player is in this matchup
     */
    public boolean hasPlayer(UUID playerId) {
        return player1Id.equals(playerId) || player2Id.equals(playerId);
    }

    // Getters
    public UUID getId() { return id; }
    public void setId(UUID id) { this.id = id; }
    public UUID getBracketId() { return bracketId; }
    public void setBracketId(UUID bracketId) { this.bracketId = bracketId; }
    public PlayoffRound getRound() { return round; }
    public void setRound(PlayoffRound round) { this.round = round; }
    public int getMatchupNumber() { return matchupNumber; }
    public void setMatchupNumber(int matchupNumber) { this.matchupNumber = matchupNumber; }
    public UUID getPlayer1Id() { return player1Id; }
    public String getPlayer1Name() { return player1Name; }
    public int getPlayer1Seed() { return player1Seed; }
    public UUID getPlayer2Id() { return player2Id; }
    public String getPlayer2Name() { return player2Name; }
    public int getPlayer2Seed() { return player2Seed; }
    public RosterScore getPlayer1Score() { return player1Score; }
    public RosterScore getPlayer2Score() { return player2Score; }
    public MatchupStatus getStatus() { return status; }
    public void setStatus(MatchupStatus status) { this.status = status; }
    public UUID getWinnerId() { return winnerId; }
    public void setWinnerId(UUID winnerId) { this.winnerId = winnerId; }
    public UUID getLoserId() { return loserId; }
    public void setLoserId(UUID loserId) { this.loserId = loserId; }
    public BigDecimal getMarginOfVictory() { return marginOfVictory; }
    public void setMarginOfVictory(BigDecimal marginOfVictory) { this.marginOfVictory = marginOfVictory; }
    public boolean isUpset() { return isUpset; }
    public void setUpset(boolean upset) { isUpset = upset; }
    public TiebreakerResult getTiebreakerResult() { return tiebreakerResult; }
    public void setTiebreakerResult(TiebreakerResult tiebreakerResult) { this.tiebreakerResult = tiebreakerResult; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public LocalDateTime getCompletedAt() { return completedAt; }
    public void setCompletedAt(LocalDateTime completedAt) { this.completedAt = completedAt; }
}
