package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.model.ScoringRules;
import com.ffl.playoffs.domain.model.TeamSelection;

/**
 * Domain service for calculating scores.
 * This service contains pure business logic with no infrastructure dependencies.
 */
public class ScoringService {

    public Integer calculateTotalScore(Score score, ScoringRules rules) {
        if (score == null || score.getBreakdown() == null || rules == null) {
            return 0;
        }

        Score.ScoreBreakdown breakdown = score.getBreakdown();
        int total = 0;

        if (breakdown.getTouchdowns() != null) {
            total += breakdown.getTouchdowns() * rules.getTouchdownPoints();
        }
        if (breakdown.getFieldGoals() != null) {
            total += breakdown.getFieldGoals() * rules.getFieldGoalPoints();
        }
        if (breakdown.getSafeties() != null) {
            total += breakdown.getSafeties() * rules.getSafetyPoints();
        }
        if (breakdown.getExtraPoints() != null) {
            total += breakdown.getExtraPoints() * rules.getExtraPointPoints();
        }
        if (breakdown.getTwoPointConversions() != null) {
            total += breakdown.getTwoPointConversions() * rules.getTwoPointConversionPoints();
        }

        return total;
    }

    public void applyScore(TeamSelection teamSelection, Score score, ScoringRules rules) {
        Integer totalPoints = calculateTotalScore(score, rules);
        teamSelection.score(totalPoints);
    }
}
