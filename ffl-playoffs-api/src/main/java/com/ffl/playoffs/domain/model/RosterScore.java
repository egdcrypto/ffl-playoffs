package com.ffl.playoffs.domain.model;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.UUID;

/**
 * Value object representing a player's roster score for a playoff week
 * Contains all position scores and aggregated totals
 */
public class RosterScore {
    private final UUID id;
    private final UUID leaguePlayerId;
    private final String playerName;
    private final PlayoffRound round;
    private final List<PositionScore> positionScores;
    private final BigDecimal totalScore;
    private final int totalTouchdowns;
    private final int totalTurnovers;
    private final LocalDateTime calculatedAt;
    private final boolean isComplete;

    public RosterScore(UUID leaguePlayerId, String playerName, PlayoffRound round,
                       List<PositionScore> positionScores) {
        this.id = UUID.randomUUID();
        this.leaguePlayerId = leaguePlayerId;
        this.playerName = playerName;
        this.round = round;
        this.positionScores = positionScores != null
            ? Collections.unmodifiableList(new ArrayList<>(positionScores))
            : Collections.emptyList();
        this.totalScore = calculateTotalScore();
        this.totalTouchdowns = calculateTotalTouchdowns();
        this.totalTurnovers = calculateTotalTurnovers();
        this.calculatedAt = LocalDateTime.now();
        this.isComplete = checkIfComplete();
    }

    private BigDecimal calculateTotalScore() {
        return positionScores.stream()
            .map(PositionScore::getPoints)
            .reduce(BigDecimal.ZERO, BigDecimal::add)
            .setScale(2, RoundingMode.HALF_UP);
    }

    private int calculateTotalTouchdowns() {
        return positionScores.stream()
            .filter(ps -> ps.getStats() != null)
            .mapToInt(ps -> ps.getStats().getTotalTouchdowns())
            .sum();
    }

    private int calculateTotalTurnovers() {
        return positionScores.stream()
            .filter(ps -> ps.getStats() != null)
            .mapToInt(ps -> ps.getStats().getTotalTurnovers())
            .sum();
    }

    private boolean checkIfComplete() {
        return positionScores.stream()
            .allMatch(ps -> ps.isActive() || ps.isOnBye() || ps.didNotPlay());
    }

    /**
     * Get the highest individual position score
     * @return the highest position score value
     */
    public BigDecimal getHighestPositionScore() {
        return positionScores.stream()
            .map(PositionScore::getPoints)
            .max(Comparator.naturalOrder())
            .orElse(BigDecimal.ZERO);
    }

    /**
     * Get the second highest individual position score
     * @return the second highest position score value
     */
    public BigDecimal getSecondHighestPositionScore() {
        List<BigDecimal> sortedScores = positionScores.stream()
            .map(PositionScore::getPoints)
            .sorted(Comparator.reverseOrder())
            .toList();

        return sortedScores.size() >= 2 ? sortedScores.get(1) : BigDecimal.ZERO;
    }

    /**
     * Get position scores sorted by points descending
     * @return sorted list of position scores
     */
    public List<PositionScore> getPositionScoresSortedByPoints() {
        return positionScores.stream()
            .sorted(Comparator.comparing(PositionScore::getPoints).reversed())
            .toList();
    }

    // Getters
    public UUID getId() { return id; }
    public UUID getLeaguePlayerId() { return leaguePlayerId; }
    public String getPlayerName() { return playerName; }
    public PlayoffRound getRound() { return round; }
    public List<PositionScore> getPositionScores() { return positionScores; }
    public BigDecimal getTotalScore() { return totalScore; }
    public int getTotalTouchdowns() { return totalTouchdowns; }
    public int getTotalTurnovers() { return totalTurnovers; }
    public LocalDateTime getCalculatedAt() { return calculatedAt; }
    public boolean isComplete() { return isComplete; }
}
