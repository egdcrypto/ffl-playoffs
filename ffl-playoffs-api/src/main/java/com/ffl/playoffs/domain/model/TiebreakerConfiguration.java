package com.ffl.playoffs.domain.model;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

/**
 * Value object representing the tiebreaker configuration for a league
 * Immutable - defines the cascade of tiebreaker methods to apply
 */
public class TiebreakerConfiguration {
    private final List<TiebreakerMethod> tiebreakerCascade;

    public TiebreakerConfiguration(List<TiebreakerMethod> tiebreakerCascade) {
        if (tiebreakerCascade == null || tiebreakerCascade.isEmpty()) {
            this.tiebreakerCascade = getDefaultTiebreakerCascade();
        } else {
            this.tiebreakerCascade = Collections.unmodifiableList(new ArrayList<>(tiebreakerCascade));
        }
    }

    /**
     * Get the default tiebreaker cascade
     * @return list of tiebreaker methods in priority order
     */
    public static List<TiebreakerMethod> getDefaultTiebreakerCascade() {
        return List.of(
            TiebreakerMethod.HIGHEST_SINGLE_POSITION_SCORE,
            TiebreakerMethod.SECOND_HIGHEST_POSITION_SCORE,
            TiebreakerMethod.MOST_TOUCHDOWNS,
            TiebreakerMethod.FEWER_TURNOVERS,
            TiebreakerMethod.HIGHER_SEED
        );
    }

    /**
     * Create a default tiebreaker configuration
     * @return default TiebreakerConfiguration
     */
    public static TiebreakerConfiguration defaultConfiguration() {
        return new TiebreakerConfiguration(getDefaultTiebreakerCascade());
    }

    /**
     * Get the cascade of tiebreaker methods
     * @return immutable list of tiebreaker methods
     */
    public List<TiebreakerMethod> getTiebreakerCascade() {
        return tiebreakerCascade;
    }

    /**
     * Get the next tiebreaker method after the current one
     * @param current the current tiebreaker method
     * @return the next method, or CO_WINNERS if all exhausted
     */
    public TiebreakerMethod getNextMethod(TiebreakerMethod current) {
        int currentIndex = tiebreakerCascade.indexOf(current);
        if (currentIndex < 0 || currentIndex >= tiebreakerCascade.size() - 1) {
            return TiebreakerMethod.CO_WINNERS;
        }
        return tiebreakerCascade.get(currentIndex + 1);
    }

    /**
     * Get the first tiebreaker method in the cascade
     * @return the first tiebreaker method
     */
    public TiebreakerMethod getFirstMethod() {
        return tiebreakerCascade.isEmpty()
            ? TiebreakerMethod.HIGHER_SEED
            : tiebreakerCascade.get(0);
    }
}
