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

        // PPR scoring (Points Per Reception)
        points += (int) (stats.getReceptions() * rules.getReceptionPoints());

        // Two-point conversions
        points += (int) (stats.getTwoPointConversions() * rules.getTwoPointConversionPoints());

        // Negative scoring
        points += (int) (stats.getInterceptionsThrown() * rules.getInterceptionThrownPoints());
        points += (int) (stats.getFumblesLost() * rules.getFumbleLostPoints());

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

        // Points allowed tiers
        points += calculatePointsAllowedScore(rules, stats.getPointsAllowed());

        // Yards allowed tiers
        points += calculateYardsAllowedScore(rules, stats.getYardsAllowed());

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

    private int calculateYardsAllowedScore(ScoringRules rules, int yardsAllowed) {
        if (yardsAllowed < 100) {
            return rules.getYardsAllowedUnder100Points().intValue();
        } else if (yardsAllowed <= 199) {
            return rules.getYardsAllowed100To199Points().intValue();
        } else if (yardsAllowed <= 299) {
            return rules.getYardsAllowed200To299Points().intValue();
        } else if (yardsAllowed <= 349) {
            return rules.getYardsAllowed300To349Points().intValue();
        } else if (yardsAllowed <= 399) {
            return rules.getYardsAllowed350To399Points().intValue();
        } else if (yardsAllowed <= 449) {
            return rules.getYardsAllowed400To449Points().intValue();
        } else if (yardsAllowed <= 499) {
            return rules.getYardsAllowed450To499Points().intValue();
        } else if (yardsAllowed <= 549) {
            return rules.getYardsAllowed500To549Points().intValue();
        } else {
            return rules.getYardsAllowed550PlusPoints().intValue();
        }
    }

    /**
     * Calculate points for individual NFL player
     * @param rules Scoring rules
     * @param playerStats Individual player statistics
     * @return Calculated points for the player
     */
    public double calculatePlayerScore(ScoringRules rules, PlayerGameStats playerStats) {
        double points = 0.0;

        // Passing
        points += playerStats.getPassingYards() / rules.getPassingYardsPerPoint();
        points += playerStats.getPassingTouchdowns() * rules.getPassingTouchdownPoints();
        points += playerStats.getInterceptionsThrown() * rules.getInterceptionThrownPoints();

        // Rushing
        points += playerStats.getRushingYards() / rules.getRushingYardsPerPoint();
        points += playerStats.getRushingTouchdowns() * rules.getRushingTouchdownPoints();

        // Receiving
        points += playerStats.getReceivingYards() / rules.getReceivingYardsPerPoint();
        points += playerStats.getReceivingTouchdowns() * rules.getReceivingTouchdownPoints();
        points += playerStats.getReceptions() * rules.getReceptionPoints(); // PPR

        // Misc
        points += playerStats.getTwoPointConversions() * rules.getTwoPointConversionPoints();
        points += playerStats.getFumblesLost() * rules.getFumbleLostPoints();

        // Kicking
        points += playerStats.getFieldGoalsUnder40() * rules.getFieldGoalUnder40Points();
        points += playerStats.getFieldGoals40To49() * rules.getFieldGoal40To49Points();
        points += playerStats.getFieldGoals50Plus() * rules.getFieldGoal50PlusPoints();
        points += playerStats.getExtraPoints() * rules.getExtraPointPoints();

        return points;
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
        private int receptions; // PPR
        private int twoPointConversions;
        private int interceptionsThrown; // Negative points
        private int fumblesLost; // Negative points
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
        private int yardsAllowed; // Yards allowed by defense

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

        public int getReceptions() {
            return receptions;
        }

        public void setReceptions(int receptions) {
            this.receptions = receptions;
        }

        public int getTwoPointConversions() {
            return twoPointConversions;
        }

        public void setTwoPointConversions(int twoPointConversions) {
            this.twoPointConversions = twoPointConversions;
        }

        public int getInterceptionsThrown() {
            return interceptionsThrown;
        }

        public void setInterceptionsThrown(int interceptionsThrown) {
            this.interceptionsThrown = interceptionsThrown;
        }

        public int getFumblesLost() {
            return fumblesLost;
        }

        public void setFumblesLost(int fumblesLost) {
            this.fumblesLost = fumblesLost;
        }

        public int getYardsAllowed() {
            return yardsAllowed;
        }

        public void setYardsAllowed(int yardsAllowed) {
            this.yardsAllowed = yardsAllowed;
        }
    }

    /**
     * Value object representing individual NFL player statistics
     * Used for calculating individual player fantasy points
     */
    public static class PlayerGameStats {
        private int passingYards;
        private int passingTouchdowns;
        private int interceptionsThrown;
        private int rushingYards;
        private int rushingTouchdowns;
        private int receivingYards;
        private int receivingTouchdowns;
        private int receptions; // PPR
        private int twoPointConversions;
        private int fumblesLost;
        private int fieldGoalsUnder40;
        private int fieldGoals40To49;
        private int fieldGoals50Plus;
        private int extraPoints;

        // Getters and Setters
        public int getPassingYards() {
            return passingYards;
        }

        public void setPassingYards(int passingYards) {
            this.passingYards = passingYards;
        }

        public int getPassingTouchdowns() {
            return passingTouchdowns;
        }

        public void setPassingTouchdowns(int passingTouchdowns) {
            this.passingTouchdowns = passingTouchdowns;
        }

        public int getInterceptionsThrown() {
            return interceptionsThrown;
        }

        public void setInterceptionsThrown(int interceptionsThrown) {
            this.interceptionsThrown = interceptionsThrown;
        }

        public int getRushingYards() {
            return rushingYards;
        }

        public void setRushingYards(int rushingYards) {
            this.rushingYards = rushingYards;
        }

        public int getRushingTouchdowns() {
            return rushingTouchdowns;
        }

        public void setRushingTouchdowns(int rushingTouchdowns) {
            this.rushingTouchdowns = rushingTouchdowns;
        }

        public int getReceivingYards() {
            return receivingYards;
        }

        public void setReceivingYards(int receivingYards) {
            this.receivingYards = receivingYards;
        }

        public int getReceivingTouchdowns() {
            return receivingTouchdowns;
        }

        public void setReceivingTouchdowns(int receivingTouchdowns) {
            this.receivingTouchdowns = receivingTouchdowns;
        }

        public int getReceptions() {
            return receptions;
        }

        public void setReceptions(int receptions) {
            this.receptions = receptions;
        }

        public int getTwoPointConversions() {
            return twoPointConversions;
        }

        public void setTwoPointConversions(int twoPointConversions) {
            this.twoPointConversions = twoPointConversions;
        }

        public int getFumblesLost() {
            return fumblesLost;
        }

        public void setFumblesLost(int fumblesLost) {
            this.fumblesLost = fumblesLost;
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
    }
}
