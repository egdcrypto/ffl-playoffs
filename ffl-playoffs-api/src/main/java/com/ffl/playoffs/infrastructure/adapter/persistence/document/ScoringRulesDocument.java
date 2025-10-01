package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.math.BigDecimal;

/**
 * MongoDB embedded document for ScoringRules
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ScoringRulesDocument {

    // PPR Rules
    private BigDecimal pointsPerReception;
    private BigDecimal pointsPerPassingYard;
    private BigDecimal pointsPerRushingYard;
    private BigDecimal pointsPerReceivingYard;
    private BigDecimal pointsPerPassingTouchdown;
    private BigDecimal pointsPerRushingTouchdown;
    private BigDecimal pointsPerReceivingTouchdown;
    private BigDecimal pointsPerInterception;
    private BigDecimal pointsPerFumbleLost;

    // Field Goal Rules
    private BigDecimal pointsPerFieldGoalMade;
    private BigDecimal pointsPerExtraPointMade;

    // Defensive Rules
    private BigDecimal pointsPerSack;
    private BigDecimal pointsPerInterceptionDef;
    private BigDecimal pointsPerFumbleRecovery;
    private BigDecimal pointsPerDefensiveTouchdown;
}
