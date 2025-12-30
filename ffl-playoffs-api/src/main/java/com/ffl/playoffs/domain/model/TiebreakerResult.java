package com.ffl.playoffs.domain.model;

import java.util.UUID;

/**
 * Value object representing the result of a tiebreaker resolution
 */
public class TiebreakerResult {
    private final UUID winnerId;
    private final UUID loserId;
    private final TiebreakerMethod methodUsed;
    private final String winnerValue;
    private final String loserValue;
    private final boolean isTied;

    private TiebreakerResult(UUID winnerId, UUID loserId, TiebreakerMethod methodUsed,
                             String winnerValue, String loserValue, boolean isTied) {
        this.winnerId = winnerId;
        this.loserId = loserId;
        this.methodUsed = methodUsed;
        this.winnerValue = winnerValue;
        this.loserValue = loserValue;
        this.isTied = isTied;
    }

    /**
     * Create a resolved tiebreaker result with a winner
     */
    public static TiebreakerResult resolved(UUID winnerId, UUID loserId,
                                            TiebreakerMethod methodUsed,
                                            String winnerValue, String loserValue) {
        return new TiebreakerResult(winnerId, loserId, methodUsed, winnerValue, loserValue, false);
    }

    /**
     * Create an unresolved tiebreaker result (still tied)
     */
    public static TiebreakerResult stillTied(TiebreakerMethod methodUsed, String value) {
        return new TiebreakerResult(null, null, methodUsed, value, value, true);
    }

    /**
     * Create a co-winners result when all tiebreakers are exhausted
     */
    public static TiebreakerResult coWinners(UUID player1Id, UUID player2Id) {
        return new TiebreakerResult(player1Id, player2Id, TiebreakerMethod.CO_WINNERS,
            "Co-Winners", "Co-Winners", true);
    }

    public UUID getWinnerId() { return winnerId; }
    public UUID getLoserId() { return loserId; }
    public TiebreakerMethod getMethodUsed() { return methodUsed; }
    public String getWinnerValue() { return winnerValue; }
    public String getLoserValue() { return loserValue; }
    public boolean isTied() { return isTied; }
    public boolean isResolved() { return !isTied; }
}
