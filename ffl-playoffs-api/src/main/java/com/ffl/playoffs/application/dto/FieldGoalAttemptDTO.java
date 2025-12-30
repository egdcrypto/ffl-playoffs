package com.ffl.playoffs.application.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * DTO representing a single field goal attempt for API responses
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class FieldGoalAttemptDTO {
    private int distanceYards;
    private String range;
    private String result;
    private double points;
    private String kicker;
    private Integer quarter;
}
