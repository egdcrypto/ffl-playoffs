package com.ffl.playoffs.application.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

/**
 * Data Transfer Object for Game.
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class GameDTO {
    private UUID id;
    private String name;
    private UUID creatorId;
    private LocalDateTime createdAt;
    private String status;
    private Integer currentWeek;
    private List<PlayerDTO> players;
    private ScoringRulesDTO scoringRules;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    @Builder
    public static class ScoringRulesDTO {
        private Integer touchdownPoints;
        private Integer fieldGoalPoints;
        private Integer safetyPoints;
        private Integer extraPointPoints;
        private Integer twoPointConversionPoints;
    }
}
