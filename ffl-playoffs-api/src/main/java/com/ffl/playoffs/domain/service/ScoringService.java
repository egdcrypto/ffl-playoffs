package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.port.NflDataProvider;

import java.util.Map;
import java.util.UUID;

/**
 * Domain service for calculating scores.
 * Pure domain logic with no framework dependencies.
 */
public class ScoringService {
    
    private final NflDataProvider nflDataProvider;

    public ScoringService(NflDataProvider nflDataProvider) {
        this.nflDataProvider = nflDataProvider;
    }

    /**
     * Calculate score for a team selection based on NFL stats.
     */
    public Score calculateScore(UUID teamSelectionId, String teamCode, int nflWeek, int season) {
        Map<String, Object> teamStats = nflDataProvider.getTeamStats(teamCode, nflWeek, season);
        
        Score score = new Score(teamSelectionId);
        score.setRawStats(teamStats);
        
        // Calculate position-specific scores
        double qbScore = calculateQuarterbackScore(teamStats);
        double rbScore = calculateRunningBackScore(teamStats);
        double wrScore = calculateWideReceiverScore(teamStats);
        double teScore = calculateTightEndScore(teamStats);
        double kScore = calculateKickerScore(teamStats);
        double dstScore = calculateDefenseScore(teamStats);
        
        score.addPositionScore("QB", qbScore);
        score.addPositionScore("RB", rbScore);
        score.addPositionScore("WR", wrScore);
        score.addPositionScore("TE", teScore);
        score.addPositionScore("K", kScore);
        score.addPositionScore("DST", dstScore);
        
        return score;
    }

    private double calculateQuarterbackScore(Map<String, Object> stats) {
        // Example scoring logic - can be customized
        double passingYards = getStatAsDouble(stats, "passingYards") * 0.04;
        double passingTDs = getStatAsDouble(stats, "passingTouchdowns") * 4.0;
        double interceptions = getStatAsDouble(stats, "interceptions") * -2.0;
        return passingYards + passingTDs + interceptions;
    }

    private double calculateRunningBackScore(Map<String, Object> stats) {
        double rushingYards = getStatAsDouble(stats, "rushingYards") * 0.1;
        double rushingTDs = getStatAsDouble(stats, "rushingTouchdowns") * 6.0;
        return rushingYards + rushingTDs;
    }

    private double calculateWideReceiverScore(Map<String, Object> stats) {
        double receivingYards = getStatAsDouble(stats, "receivingYards") * 0.1;
        double receivingTDs = getStatAsDouble(stats, "receivingTouchdowns") * 6.0;
        double receptions = getStatAsDouble(stats, "receptions") * 0.5;
        return receivingYards + receivingTDs + receptions;
    }

    private double calculateTightEndScore(Map<String, Object> stats) {
        // Same as WR for now
        return calculateWideReceiverScore(stats);
    }

    private double calculateKickerScore(Map<String, Object> stats) {
        double fieldGoals = getStatAsDouble(stats, "fieldGoalsMade") * 3.0;
        double extraPoints = getStatAsDouble(stats, "extraPointsMade") * 1.0;
        return fieldGoals + extraPoints;
    }

    private double calculateDefenseScore(Map<String, Object> stats) {
        double sacks = getStatAsDouble(stats, "sacks") * 1.0;
        double interceptions = getStatAsDouble(stats, "interceptions") * 2.0;
        double fumblesRecovered = getStatAsDouble(stats, "fumblesRecovered") * 2.0;
        double pointsAllowed = getStatAsDouble(stats, "pointsAllowed");
        
        double pointsAllowedScore = 0.0;
        if (pointsAllowed == 0) pointsAllowedScore = 10.0;
        else if (pointsAllowed <= 6) pointsAllowedScore = 7.0;
        else if (pointsAllowed <= 13) pointsAllowedScore = 4.0;
        else if (pointsAllowed <= 20) pointsAllowedScore = 1.0;
        else if (pointsAllowed <= 27) pointsAllowedScore = 0.0;
        else pointsAllowedScore = -4.0;
        
        return sacks + interceptions + fumblesRecovered + pointsAllowedScore;
    }

    private double getStatAsDouble(Map<String, Object> stats, String key) {
        Object value = stats.get(key);
        if (value == null) return 0.0;
        if (value instanceof Number) {
            return ((Number) value).doubleValue();
        }
        return 0.0;
    }
}
