package com.ffl.playoffs.application.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

/**
 * DTO representing the complete field goal scoring breakdown for a team/player
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FieldGoalScoringBreakdownDTO {
    private String teamName;
    private int week;
    private List<FieldGoalAttemptDTO> fieldGoals;
    private List<FieldGoalRangeBreakdownDTO> rangeBreakdown;
    private double totalFieldGoalPoints;
    private int madeFieldGoals;
    private int attemptedFieldGoals;
}
