package com.ffl.playoffs.application.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO representing field goal breakdown for a specific distance range
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FieldGoalRangeBreakdownDTO {
    private String range;
    private int count;
    private double pointsPerFieldGoal;
    private double total;
}
