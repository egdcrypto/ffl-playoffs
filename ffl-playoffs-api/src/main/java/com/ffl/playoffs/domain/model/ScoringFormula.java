package com.ffl.playoffs.domain.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

/**
 * ScoringFormula Value Object
 *
 * Represents a SpEL-based scoring formula for a specific position.
 * Formulas are stored per league and can be customized.
 *
 * Example formulas:
 * - QB: "#passingYards * 0.04 + #passingTDs * 4 - #interceptions * 2"
 * - RB: "#rushingYards * 0.1 + #rushingTDs * 6 + #receptions * #pprValue"
 * - DEF: "#sacks * 1 + #interceptions * 2 + (#pointsAllowed <= 6 ? 7 : 0)"
 */
@Getter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ScoringFormula {

    /**
     * Position this formula applies to (QB, RB, WR, TE, K, DEF)
     */
    private Position position;

    /**
     * SpEL expression string
     */
    private String formula;

    /**
     * Human-readable description of the formula
     */
    private String description;

    /**
     * Whether this formula is active
     */
    @Builder.Default
    private boolean active = true;

    /**
     * When the formula was created
     */
    @Builder.Default
    private LocalDateTime createdAt = LocalDateTime.now();

    /**
     * When the formula was last updated
     */
    @Builder.Default
    private LocalDateTime updatedAt = LocalDateTime.now();

    /**
     * Creates a standard (non-PPR) scoring formula for a position
     */
    public static ScoringFormula standard(Position position) {
        return switch (position) {
            case QB -> ScoringFormula.builder()
                .position(position)
                .formula("#passingYards * 0.04 + #passingTDs * 4 - #interceptions * 2 + " +
                        "#rushingYards * 0.1 + #rushingTDs * 6 - #fumblesLost * 2")
                .description("Standard QB scoring: 1pt/25yd passing, 4pt/TD, -2pt/INT, 1pt/10yd rushing, 6pt/TD")
                .build();

            case RB -> ScoringFormula.builder()
                .position(position)
                .formula("#rushingYards * 0.1 + #rushingTDs * 6 + " +
                        "#receivingYards * 0.1 + #receivingTDs * 6 - #fumblesLost * 2")
                .description("Standard RB scoring: 1pt/10yd, 6pt/TD (no PPR)")
                .build();

            case WR -> ScoringFormula.builder()
                .position(position)
                .formula("#receivingYards * 0.1 + #receivingTDs * 6 + " +
                        "#rushingYards * 0.1 + #rushingTDs * 6 - #fumblesLost * 2")
                .description("Standard WR scoring: 1pt/10yd, 6pt/TD (no PPR)")
                .build();

            case TE -> ScoringFormula.builder()
                .position(position)
                .formula("#receivingYards * 0.1 + #receivingTDs * 6 - #fumblesLost * 2")
                .description("Standard TE scoring: 1pt/10yd, 6pt/TD (no PPR)")
                .build();

            case K -> ScoringFormula.builder()
                .position(position)
                .formula("#xpMade * 1 + #fg0to39Made * 3 + #fg40to49Made * 4 + #fg50PlusMade * 5")
                .description("Standard kicker scoring: 1pt/XP, 3-5pts/FG by distance")
                .build();

            case DEF -> ScoringFormula.builder()
                .position(position)
                .formula("#sacks * 1 + #interceptions * 2 + #fumbleRecoveries * 2 + " +
                        "#defensiveTDs * 6 + #safeties * 2")
                .description("Standard defense scoring: sacks, INTs, fumbles, TDs, safeties")
                .build();

            default -> throw new IllegalArgumentException("Unsupported position: " + position);
        };
    }

    /**
     * Creates a Full PPR scoring formula for a position
     */
    public static ScoringFormula fullPPR(Position position) {
        return switch (position) {
            case RB -> ScoringFormula.builder()
                .position(position)
                .formula("#rushingYards * 0.1 + #rushingTDs * 6 + " +
                        "#receivingYards * 0.1 + #receivingTDs * 6 + " +
                        "#receptions * 1.0 - #fumblesLost * 2")
                .description("Full PPR RB scoring: 1pt/reception")
                .build();

            case WR -> ScoringFormula.builder()
                .position(position)
                .formula("#receivingYards * 0.1 + #receivingTDs * 6 + " +
                        "#receptions * 1.0 + #rushingYards * 0.1 + #rushingTDs * 6 - #fumblesLost * 2")
                .description("Full PPR WR scoring: 1pt/reception")
                .build();

            case TE -> ScoringFormula.builder()
                .position(position)
                .formula("#receivingYards * 0.1 + #receivingTDs * 6 + " +
                        "#receptions * 1.0 - #fumblesLost * 2")
                .description("Full PPR TE scoring: 1pt/reception")
                .build();

            default -> standard(position);
        };
    }

    /**
     * Creates a Half PPR scoring formula for a position
     */
    public static ScoringFormula halfPPR(Position position) {
        return switch (position) {
            case RB -> ScoringFormula.builder()
                .position(position)
                .formula("#rushingYards * 0.1 + #rushingTDs * 6 + " +
                        "#receivingYards * 0.1 + #receivingTDs * 6 + " +
                        "#receptions * 0.5 - #fumblesLost * 2")
                .description("Half PPR RB scoring: 0.5pt/reception")
                .build();

            case WR -> ScoringFormula.builder()
                .position(position)
                .formula("#receivingYards * 0.1 + #receivingTDs * 6 + " +
                        "#receptions * 0.5 + #rushingYards * 0.1 + #rushingTDs * 6 - #fumblesLost * 2")
                .description("Half PPR WR scoring: 0.5pt/reception")
                .build();

            case TE -> ScoringFormula.builder()
                .position(position)
                .formula("#receivingYards * 0.1 + #receivingTDs * 6 + " +
                        "#receptions * 0.5 - #fumblesLost * 2")
                .description("Half PPR TE scoring: 0.5pt/reception")
                .build();

            default -> standard(position);
        };
    }

    /**
     * Creates a TE Premium scoring formula
     */
    public static ScoringFormula tePremium(Position position) {
        if (position == Position.TE) {
            return ScoringFormula.builder()
                .position(position)
                .formula("#receivingYards * 0.1 + #receivingTDs * 6 + " +
                        "#receptions * 1.5 - #fumblesLost * 2")
                .description("TE Premium scoring: 1.5pt/reception for tight ends")
                .build();
        }
        return fullPPR(position);
    }

    /**
     * Updates the formula and marks as updated
     */
    public void updateFormula(String newFormula) {
        this.formula = newFormula;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Deactivates this formula
     */
    public void deactivate() {
        this.active = false;
        this.updatedAt = LocalDateTime.now();
    }

    /**
     * Activates this formula
     */
    public void activate() {
        this.active = true;
        this.updatedAt = LocalDateTime.now();
    }
}
