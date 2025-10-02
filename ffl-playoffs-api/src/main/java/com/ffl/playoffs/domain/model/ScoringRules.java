package com.ffl.playoffs.domain.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

/**
 * Value object representing the scoring rules for a game.
 */
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ScoringRules {
    private Integer touchdownPoints;
    private Integer fieldGoalPoints;
    private Integer safetyPoints;
    private Integer extraPointPoints;
    private Integer twoPointConversionPoints;

    public static ScoringRules defaultRules() {
        return ScoringRules.builder()
                .touchdownPoints(6)
                .fieldGoalPoints(3)
                .safetyPoints(2)
                .extraPointPoints(1)
                .twoPointConversionPoints(2)
                .build();
    }
}
