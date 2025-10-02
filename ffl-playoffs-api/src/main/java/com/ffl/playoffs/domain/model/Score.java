package com.ffl.playoffs.domain.model;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.util.UUID;

/**
 * Domain model representing a score for a team selection.
 */
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Score {
    private UUID id;
    private UUID teamSelectionId;
    private String nflTeam;
    private Integer weekNumber;
    private Integer points;
    private ScoreBreakdown breakdown;

    @Getter
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class ScoreBreakdown {
        private Integer touchdowns;
        private Integer fieldGoals;
        private Integer safeties;
        private Integer extraPoints;
        private Integer twoPointConversions;
    }
}
