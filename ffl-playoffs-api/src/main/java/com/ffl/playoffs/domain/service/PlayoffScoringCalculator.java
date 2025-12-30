package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.model.PPRScoringConfiguration;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.model.PositionScore;

import java.math.BigDecimal;
import java.math.RoundingMode;

/**
 * Domain service for calculating playoff scores using PPR scoring rules
 * Pure domain logic - no framework dependencies
 */
public class PlayoffScoringCalculator {

    private final PPRScoringConfiguration config;

    public PlayoffScoringCalculator(PPRScoringConfiguration config) {
        this.config = config != null ? config : PPRScoringConfiguration.defaultConfiguration();
    }

    public PlayoffScoringCalculator() {
        this(PPRScoringConfiguration.defaultConfiguration());
    }

    /**
     * Calculate score for a player based on their stats
     */
    public BigDecimal calculatePositionScore(Position position, PositionScore.PositionStats stats) {
        if (stats == null) {
            return BigDecimal.ZERO;
        }

        return switch (position) {
            case QB -> calculateQBScore(stats);
            case RB -> calculateRBScore(stats);
            case WR -> calculateWRScore(stats);
            case TE -> calculateTEScore(stats);
            case K -> calculateKickerScore(stats);
            case DEF -> calculateDefenseScore(stats);
            case FLEX, SUPERFLEX -> calculateFlexScore(stats);
        };
    }

    /**
     * Calculate quarterback score
     * Base: passing yards * 0.04 + passing TDs * 4 + rushing yards * 0.1 + rushing TDs * 6
     * Penalties: interceptions * -2 + fumbles lost * -2
     * Bonuses: 300+ passing yards = +3
     */
    public BigDecimal calculateQBScore(PositionScore.PositionStats stats) {
        BigDecimal score = BigDecimal.ZERO;

        // Passing yards
        if (stats.getPassingYards() != null) {
            score = score.add(
                new BigDecimal(stats.getPassingYards()).multiply(config.getPassingYardsPerPoint())
            );

            // 300+ passing yards bonus
            if (stats.getPassingYards() >= 300) {
                score = score.add(config.getPassingYards300Bonus());
            }
        }

        // Passing touchdowns
        if (stats.getPassingTouchdowns() != null) {
            score = score.add(
                new BigDecimal(stats.getPassingTouchdowns()).multiply(config.getPassingTouchdownPoints())
            );
        }

        // Rushing yards (QBs can rush)
        if (stats.getRushingYards() != null) {
            score = score.add(
                new BigDecimal(stats.getRushingYards()).multiply(config.getRushingYardsPerPoint())
            );
        }

        // Rushing touchdowns
        if (stats.getRushingTouchdowns() != null) {
            score = score.add(
                new BigDecimal(stats.getRushingTouchdowns()).multiply(config.getRushingTouchdownPoints())
            );
        }

        // Interceptions (negative)
        if (stats.getInterceptions() != null) {
            score = score.add(
                new BigDecimal(stats.getInterceptions()).multiply(config.getInterceptionPoints())
            );
        }

        // Fumbles lost (negative)
        if (stats.getFumblesLost() != null) {
            score = score.add(
                new BigDecimal(stats.getFumblesLost()).multiply(config.getFumbleLostPoints())
            );
        }

        return score.setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Calculate running back score
     * Base: rushing yards * 0.1 + rushing TDs * 6 + receptions * 1 + receiving yards * 0.1 + receiving TDs * 6
     * Penalties: fumbles lost * -2
     * Bonuses: 100+ rushing yards = +3
     */
    public BigDecimal calculateRBScore(PositionScore.PositionStats stats) {
        BigDecimal score = BigDecimal.ZERO;

        // Rushing yards
        if (stats.getRushingYards() != null) {
            score = score.add(
                new BigDecimal(stats.getRushingYards()).multiply(config.getRushingYardsPerPoint())
            );

            // 100+ rushing yards bonus
            if (stats.getRushingYards() >= 100) {
                score = score.add(config.getRushingYards100Bonus());
            }
        }

        // Rushing touchdowns
        if (stats.getRushingTouchdowns() != null) {
            score = score.add(
                new BigDecimal(stats.getRushingTouchdowns()).multiply(config.getRushingTouchdownPoints())
            );
        }

        // Receptions (PPR)
        if (stats.getReceptions() != null) {
            score = score.add(
                new BigDecimal(stats.getReceptions()).multiply(config.getReceptionPoints())
            );
        }

        // Receiving yards
        if (stats.getReceivingYards() != null) {
            score = score.add(
                new BigDecimal(stats.getReceivingYards()).multiply(config.getReceivingYardsPerPoint())
            );
        }

        // Receiving touchdowns
        if (stats.getReceivingTouchdowns() != null) {
            score = score.add(
                new BigDecimal(stats.getReceivingTouchdowns()).multiply(config.getReceivingTouchdownPoints())
            );
        }

        // Fumbles lost (negative)
        if (stats.getFumblesLost() != null) {
            score = score.add(
                new BigDecimal(stats.getFumblesLost()).multiply(config.getFumbleLostPoints())
            );
        }

        return score.setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Calculate wide receiver score
     * Same as RB but with receiving yards bonus
     */
    public BigDecimal calculateWRScore(PositionScore.PositionStats stats) {
        BigDecimal score = BigDecimal.ZERO;

        // Receptions (PPR)
        if (stats.getReceptions() != null) {
            score = score.add(
                new BigDecimal(stats.getReceptions()).multiply(config.getReceptionPoints())
            );
        }

        // Receiving yards
        if (stats.getReceivingYards() != null) {
            score = score.add(
                new BigDecimal(stats.getReceivingYards()).multiply(config.getReceivingYardsPerPoint())
            );

            // 100+ receiving yards bonus
            if (stats.getReceivingYards() >= 100) {
                score = score.add(config.getReceivingYards100Bonus());
            }
        }

        // Receiving touchdowns
        if (stats.getReceivingTouchdowns() != null) {
            score = score.add(
                new BigDecimal(stats.getReceivingTouchdowns()).multiply(config.getReceivingTouchdownPoints())
            );
        }

        // Rushing yards (end-arounds, etc.)
        if (stats.getRushingYards() != null) {
            score = score.add(
                new BigDecimal(stats.getRushingYards()).multiply(config.getRushingYardsPerPoint())
            );
        }

        // Rushing touchdowns
        if (stats.getRushingTouchdowns() != null) {
            score = score.add(
                new BigDecimal(stats.getRushingTouchdowns()).multiply(config.getRushingTouchdownPoints())
            );
        }

        // Fumbles lost (negative)
        if (stats.getFumblesLost() != null) {
            score = score.add(
                new BigDecimal(stats.getFumblesLost()).multiply(config.getFumbleLostPoints())
            );
        }

        return score.setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Calculate tight end score
     * Same as WR
     */
    public BigDecimal calculateTEScore(PositionScore.PositionStats stats) {
        return calculateWRScore(stats);
    }

    /**
     * Calculate flex position score based on underlying position stats
     */
    public BigDecimal calculateFlexScore(PositionScore.PositionStats stats) {
        // Flex can be RB, WR, or TE - calculate based on available stats
        BigDecimal score = BigDecimal.ZERO;

        // Check if this looks like a RB (has significant rushing)
        if (stats.getRushingYards() != null && stats.getRushingYards() > 0) {
            return calculateRBScore(stats);
        }

        // Otherwise treat as WR/TE
        return calculateWRScore(stats);
    }

    /**
     * Calculate kicker score
     * Extra points: 1 point each
     * FG 0-39 yards: 3 points
     * FG 40-49 yards: 4 points
     * FG 50+ yards: 5 points
     */
    public BigDecimal calculateKickerScore(PositionScore.PositionStats stats) {
        BigDecimal score = BigDecimal.ZERO;

        // Extra points
        if (stats.getExtraPointsMade() != null) {
            score = score.add(
                new BigDecimal(stats.getExtraPointsMade()).multiply(config.getExtraPointMadePoints())
            );
        }

        // Field goals by distance
        if (stats.getFieldGoalsMade0to39() != null) {
            score = score.add(
                new BigDecimal(stats.getFieldGoalsMade0to39()).multiply(config.getFieldGoal0to39Points())
            );
        }

        if (stats.getFieldGoalsMade40to49() != null) {
            score = score.add(
                new BigDecimal(stats.getFieldGoalsMade40to49()).multiply(config.getFieldGoal40to49Points())
            );
        }

        if (stats.getFieldGoalsMade50Plus() != null) {
            score = score.add(
                new BigDecimal(stats.getFieldGoalsMade50Plus()).multiply(config.getFieldGoal50PlusPoints())
            );
        }

        return score.setScale(2, RoundingMode.HALF_UP);
    }

    /**
     * Calculate defense/special teams score
     * Sacks: 1 point each
     * Interceptions: 2 points each
     * Fumble recoveries: 2 points each
     * Defensive TDs: 6 points each
     * Points allowed: variable based on tier
     */
    public BigDecimal calculateDefenseScore(PositionScore.PositionStats stats) {
        BigDecimal score = BigDecimal.ZERO;

        // Sacks
        if (stats.getSacks() != null) {
            score = score.add(
                new BigDecimal(stats.getSacks()).multiply(config.getSackPoints())
            );
        }

        // Defensive interceptions
        if (stats.getDefensiveInterceptions() != null) {
            score = score.add(
                new BigDecimal(stats.getDefensiveInterceptions()).multiply(config.getDefensiveInterceptionPoints())
            );
        }

        // Fumble recoveries
        if (stats.getFumbleRecoveries() != null) {
            score = score.add(
                new BigDecimal(stats.getFumbleRecoveries()).multiply(config.getFumbleRecoveryPoints())
            );
        }

        // Defensive touchdowns
        if (stats.getDefensiveTouchdowns() != null) {
            score = score.add(
                new BigDecimal(stats.getDefensiveTouchdowns()).multiply(config.getDefensiveTouchdownPoints())
            );
        }

        // Points allowed
        if (stats.getPointsAllowed() != null) {
            score = score.add(config.getPointsAllowedScore(stats.getPointsAllowed()));
        }

        return score.setScale(2, RoundingMode.HALF_UP);
    }

    public PPRScoringConfiguration getConfig() {
        return config;
    }
}
