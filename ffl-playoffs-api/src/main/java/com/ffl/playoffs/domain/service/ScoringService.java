package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.model.Score;
import com.ffl.playoffs.domain.model.ScoringRules;

/**
 * Domain service for calculating scores
 * Pure domain logic with no framework dependencies
 */
public class ScoringService {

    /**
     * Calculate total points for a team based on game stats and scoring rules
     */
    public Score calculateScore(ScoringRules rules, TeamGameStats stats) {
        Score score = new Score();

        // Calculate offensive points
        int offensivePoints = calculateOffensivePoints(rules, stats);
        score.setOffensivePoints(offensivePoints);

        // Calculate defensive points
        int defensivePoints = calculateDefensivePoints(rules, stats);
        score.setDefensivePoints(defensivePoints);

        // Calculate field goal points
        int fieldGoalPoints = calculateFieldGoalPoints(rules, stats);
        score.setFieldGoalPoints(fieldGoalPoints);

        // Calculate total
        score.calculateTotalPoints();

        return score;
    }

    private int calculateOffensivePoints(ScoringRules rules, TeamGameStats stats) {
        int points = 0;

        // Touchdowns
        points += (int) (stats.getPassingTouchdowns() * rules.getPassingTouchdownPoints());
        points += (int) (stats.getRushingTouchdowns() * rules.getRushingTouchdownPoints());
        points += (int) (stats.getReceivingTouchdowns() * rules.getReceivingTouchdownPoints());

        // Yards
        points += (int) (stats.getPassingYards() / rules.getPassingYardsPerPoint());
        points += (int) (stats.getRushingYards() / rules.getRushingYardsPerPoint());
        points += (int) (stats.getReceivingYards() / rules.getReceivingYardsPerPoint());

        return points;
    }

    private int calculateDefensivePoints(ScoringRules rules, TeamGameStats stats) {
        int points = 0;

        // Defensive plays
        points += (int) (stats.getSacks() * rules.getSackPoints());
        points += (int) (stats.getInterceptions() * rules.getInterceptionPoints());
        points += (int) (stats.getFumbleRecoveries() * rules.getFumbleRecoveryPoints());
        points += (int) (stats.getSafeties() * rules.getSafetyPoints());
        points += (int) (stats.getDefensiveTouchdowns() * rules.getDefensiveTouchdownPoints());

        // Points allowed
        points += calculatePointsAllowedScore(rules, stats.getPointsAllowed());

        return points;
    }

    private int calculateFieldGoalPoints(ScoringRules rules, TeamGameStats stats) {
        int points = 0;

        points += (int) (stats.getFieldGoalsUnder40() * rules.getFieldGoalUnder40Points());
        points += (int) (stats.getFieldGoals40To49() * rules.getFieldGoal40To49Points());
        points += (int) (stats.getFieldGoals50Plus() * rules.getFieldGoal50PlusPoints());
        points += (int) (stats.getExtraPoints() * rules.getExtraPointPoints());

        return points;
    }

    private int calculatePointsAllowedScore(ScoringRules rules, int pointsAllowed) {
        if (pointsAllowed == 0) {
            return rules.getPointsAllowed0Points().intValue();
        } else if (pointsAllowed <= 6) {
            return rules.getPointsAllowed1To6Points().intValue();
        } else if (pointsAllowed <= 13) {
            return rules.getPointsAllowed7To13Points().intValue();
        } else if (pointsAllowed <= 20) {
            return rules.getPointsAllowed14To20Points().intValue();
        } else if (pointsAllowed <= 27) {
            return rules.getPointsAllowed21To27Points().intValue();
        } else {
            return rules.getPointsAllowed28PlusPoints().intValue();
        }
    }

    /**
     * Value object representing team game statistics
     * This would typically come from the NFL data provider
     */
    public static class TeamGameStats {
        private int passingYards;
        private int rushingYards;
        private int receivingYards;
        private int passingTouchdowns;
        private int rushingTouchdowns;
        private int receivingTouchdowns;
        private int fieldGoalsUnder40;
        private int fieldGoals40To49;
        private int fieldGoals50Plus;
        private int extraPoints;
        private int sacks;
        private int interceptions;
        private int fumbleRecoveries;
        private int safeties;
        private int defensiveTouchdowns;
        private int pointsAllowed;

        // Getters and Setters
        public int getPassingYards() {
            return passingYards;
        }

        public void setPassingYards(int passingYards) {
            this.passingYards = passingYards;
        }

        public int getRushingYards() {
            return rushingYards;
        }

        public void setRushingYards(int rushingYards) {
            this.rushingYards = rushingYards;
        }

        public int getReceivingYards() {
            return receivingYards;
        }

        public void setReceivingYards(int receivingYards) {
            this.receivingYards = receivingYards;
        }

        public int getPassingTouchdowns() {
            return passingTouchdowns;
        }

        public void setPassingTouchdowns(int passingTouchdowns) {
            this.passingTouchdowns = passingTouchdowns;
        }

        public int getRushingTouchdowns() {
            return rushingTouchdowns;
        }

        public void setRushingTouchdowns(int rushingTouchdowns) {
            this.rushingTouchdowns = rushingTouchdowns;
        }

        public int getReceivingTouchdowns() {
            return receivingTouchdowns;
        }

        public void setReceivingTouchdowns(int receivingTouchdowns) {
            this.receivingTouchdowns = receivingTouchdowns;
        }

        public int getFieldGoalsUnder40() {
            return fieldGoalsUnder40;
        }

        public void setFieldGoalsUnder40(int fieldGoalsUnder40) {
            this.fieldGoalsUnder40 = fieldGoalsUnder40;
        }

        public int getFieldGoals40To49() {
            return fieldGoals40To49;
        }

        public void setFieldGoals40To49(int fieldGoals40To49) {
            this.fieldGoals40To49 = fieldGoals40To49;
        }

        public int getFieldGoals50Plus() {
            return fieldGoals50Plus;
        }

        public void setFieldGoals50Plus(int fieldGoals50Plus) {
            this.fieldGoals50Plus = fieldGoals50Plus;
        }

        public int getExtraPoints() {
            return extraPoints;
        }

        public void setExtraPoints(int extraPoints) {
            this.extraPoints = extraPoints;
        }

        public int getSacks() {
            return sacks;
        }

        public void setSacks(int sacks) {
            this.sacks = sacks;
        }

        public int getInterceptions() {
            return interceptions;
        }

        public void setInterceptions(int interceptions) {
            this.interceptions = interceptions;
        }

        public int getFumbleRecoveries() {
            return fumbleRecoveries;
        }

        public void setFumbleRecoveries(int fumbleRecoveries) {
            this.fumbleRecoveries = fumbleRecoveries;
        }

        public int getSafeties() {
            return safeties;
        }

        public void setSafeties(int safeties) {
            this.safeties = safeties;
        }

        public int getDefensiveTouchdowns() {
            return defensiveTouchdowns;
        }

        public void setDefensiveTouchdowns(int defensiveTouchdowns) {
            this.defensiveTouchdowns = defensiveTouchdowns;
        }

        public int getPointsAllowed() {
            return pointsAllowed;
        }

        public void setPointsAllowed(int pointsAllowed) {
            this.pointsAllowed = pointsAllowed;
        }
    }
}
