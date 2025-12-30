package com.ffl.playoffs.domain.service;

import com.ffl.playoffs.domain.model.RosterScore;
import com.ffl.playoffs.domain.model.TiebreakerConfiguration;
import com.ffl.playoffs.domain.model.TiebreakerMethod;
import com.ffl.playoffs.domain.model.TiebreakerResult;

import java.math.BigDecimal;
import java.util.UUID;

/**
 * Domain service for resolving tiebreakers between tied matchups
 * Pure domain logic - no framework dependencies
 */
public class TiebreakerResolver {

    private final TiebreakerConfiguration configuration;

    public TiebreakerResolver(TiebreakerConfiguration configuration) {
        this.configuration = configuration != null
            ? configuration
            : TiebreakerConfiguration.defaultConfiguration();
    }

    public TiebreakerResolver() {
        this(TiebreakerConfiguration.defaultConfiguration());
    }

    /**
     * Resolve a tie between two players using the configured tiebreaker cascade
     */
    public TiebreakerResult resolveTie(RosterScore score1, RosterScore score2,
                                       int seed1, int seed2) {
        for (TiebreakerMethod method : configuration.getTiebreakerCascade()) {
            TiebreakerResult result = applyTiebreaker(method, score1, score2, seed1, seed2);
            if (result.isResolved()) {
                return result;
            }
        }

        // All tiebreakers exhausted - declare co-winners
        return TiebreakerResult.coWinners(score1.getLeaguePlayerId(), score2.getLeaguePlayerId());
    }

    /**
     * Apply a specific tiebreaker method
     */
    public TiebreakerResult applyTiebreaker(TiebreakerMethod method,
                                            RosterScore score1, RosterScore score2,
                                            int seed1, int seed2) {
        return switch (method) {
            case HIGHEST_SINGLE_POSITION_SCORE -> resolveByHighestPositionScore(score1, score2);
            case SECOND_HIGHEST_POSITION_SCORE -> resolveBySecondHighestPositionScore(score1, score2);
            case MOST_TOUCHDOWNS -> resolveByMostTouchdowns(score1, score2);
            case FEWER_TURNOVERS -> resolveByFewerTurnovers(score1, score2);
            case HIGHER_SEED -> resolveByHigherSeed(score1, score2, seed1, seed2);
            default -> TiebreakerResult.stillTied(method, "Not implemented");
        };
    }

    private TiebreakerResult resolveByHighestPositionScore(RosterScore score1, RosterScore score2) {
        BigDecimal highest1 = score1.getHighestPositionScore();
        BigDecimal highest2 = score2.getHighestPositionScore();

        int comparison = highest1.compareTo(highest2);
        if (comparison > 0) {
            return TiebreakerResult.resolved(
                score1.getLeaguePlayerId(),
                score2.getLeaguePlayerId(),
                TiebreakerMethod.HIGHEST_SINGLE_POSITION_SCORE,
                highest1.toString(),
                highest2.toString()
            );
        } else if (comparison < 0) {
            return TiebreakerResult.resolved(
                score2.getLeaguePlayerId(),
                score1.getLeaguePlayerId(),
                TiebreakerMethod.HIGHEST_SINGLE_POSITION_SCORE,
                highest2.toString(),
                highest1.toString()
            );
        }

        return TiebreakerResult.stillTied(TiebreakerMethod.HIGHEST_SINGLE_POSITION_SCORE, highest1.toString());
    }

    private TiebreakerResult resolveBySecondHighestPositionScore(RosterScore score1, RosterScore score2) {
        BigDecimal second1 = score1.getSecondHighestPositionScore();
        BigDecimal second2 = score2.getSecondHighestPositionScore();

        int comparison = second1.compareTo(second2);
        if (comparison > 0) {
            return TiebreakerResult.resolved(
                score1.getLeaguePlayerId(),
                score2.getLeaguePlayerId(),
                TiebreakerMethod.SECOND_HIGHEST_POSITION_SCORE,
                second1.toString(),
                second2.toString()
            );
        } else if (comparison < 0) {
            return TiebreakerResult.resolved(
                score2.getLeaguePlayerId(),
                score1.getLeaguePlayerId(),
                TiebreakerMethod.SECOND_HIGHEST_POSITION_SCORE,
                second2.toString(),
                second1.toString()
            );
        }

        return TiebreakerResult.stillTied(TiebreakerMethod.SECOND_HIGHEST_POSITION_SCORE, second1.toString());
    }

    private TiebreakerResult resolveByMostTouchdowns(RosterScore score1, RosterScore score2) {
        int tds1 = score1.getTotalTouchdowns();
        int tds2 = score2.getTotalTouchdowns();

        if (tds1 > tds2) {
            return TiebreakerResult.resolved(
                score1.getLeaguePlayerId(),
                score2.getLeaguePlayerId(),
                TiebreakerMethod.MOST_TOUCHDOWNS,
                String.valueOf(tds1),
                String.valueOf(tds2)
            );
        } else if (tds2 > tds1) {
            return TiebreakerResult.resolved(
                score2.getLeaguePlayerId(),
                score1.getLeaguePlayerId(),
                TiebreakerMethod.MOST_TOUCHDOWNS,
                String.valueOf(tds2),
                String.valueOf(tds1)
            );
        }

        return TiebreakerResult.stillTied(TiebreakerMethod.MOST_TOUCHDOWNS, String.valueOf(tds1));
    }

    private TiebreakerResult resolveByFewerTurnovers(RosterScore score1, RosterScore score2) {
        int turnovers1 = score1.getTotalTurnovers();
        int turnovers2 = score2.getTotalTurnovers();

        // Fewer turnovers wins
        if (turnovers1 < turnovers2) {
            return TiebreakerResult.resolved(
                score1.getLeaguePlayerId(),
                score2.getLeaguePlayerId(),
                TiebreakerMethod.FEWER_TURNOVERS,
                String.valueOf(turnovers1),
                String.valueOf(turnovers2)
            );
        } else if (turnovers2 < turnovers1) {
            return TiebreakerResult.resolved(
                score2.getLeaguePlayerId(),
                score1.getLeaguePlayerId(),
                TiebreakerMethod.FEWER_TURNOVERS,
                String.valueOf(turnovers2),
                String.valueOf(turnovers1)
            );
        }

        return TiebreakerResult.stillTied(TiebreakerMethod.FEWER_TURNOVERS, String.valueOf(turnovers1));
    }

    private TiebreakerResult resolveByHigherSeed(RosterScore score1, RosterScore score2,
                                                  int seed1, int seed2) {
        // Lower seed number = higher seed (1 is best)
        if (seed1 < seed2) {
            return TiebreakerResult.resolved(
                score1.getLeaguePlayerId(),
                score2.getLeaguePlayerId(),
                TiebreakerMethod.HIGHER_SEED,
                "Seed " + seed1,
                "Seed " + seed2
            );
        } else if (seed2 < seed1) {
            return TiebreakerResult.resolved(
                score2.getLeaguePlayerId(),
                score1.getLeaguePlayerId(),
                TiebreakerMethod.HIGHER_SEED,
                "Seed " + seed2,
                "Seed " + seed1
            );
        }

        // Same seed (shouldn't happen in a properly seeded bracket)
        return TiebreakerResult.stillTied(TiebreakerMethod.HIGHER_SEED, "Seed " + seed1);
    }

    public TiebreakerConfiguration getConfiguration() {
        return configuration;
    }
}
