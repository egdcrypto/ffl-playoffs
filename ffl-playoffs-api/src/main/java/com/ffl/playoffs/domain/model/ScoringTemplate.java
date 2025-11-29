package com.ffl.playoffs.domain.model;

import java.util.HashMap;
import java.util.Map;

/**
 * Pre-defined scoring templates
 *
 * Provides common fantasy football scoring configurations that leagues can use as a starting point.
 */
public enum ScoringTemplate {

    STANDARD("Standard scoring with no PPR"),
    HALF_PPR("Half point per reception (0.5 PPR)"),
    FULL_PPR("Full point per reception (1.0 PPR)"),
    TE_PREMIUM("TE Premium with 1.5 PPR for tight ends"),
    SUPERFLEX("Superflex with enhanced QB scoring");

    private final String description;

    ScoringTemplate(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }

    /**
     * Gets all formulas for this template
     */
    public Map<Position, ScoringFormula> getFormulas() {
        Map<Position, ScoringFormula> formulas = new HashMap<>();

        switch (this) {
            case STANDARD -> {
                for (Position position : Position.values()) {
                    if (position != Position.FLEX) {
                        formulas.put(position, ScoringFormula.standard(position));
                    }
                }
            }
            case HALF_PPR -> {
                for (Position position : Position.values()) {
                    if (position != Position.FLEX) {
                        formulas.put(position, ScoringFormula.halfPPR(position));
                    }
                }
            }
            case FULL_PPR -> {
                for (Position position : Position.values()) {
                    if (position != Position.FLEX) {
                        formulas.put(position, ScoringFormula.fullPPR(position));
                    }
                }
            }
            case TE_PREMIUM -> {
                for (Position position : Position.values()) {
                    if (position != Position.FLEX) {
                        formulas.put(position, ScoringFormula.tePremium(position));
                    }
                }
            }
            case SUPERFLEX -> {
                for (Position position : Position.values()) {
                    if (position != Position.FLEX) {
                        if (position == Position.QB) {
                            // Enhanced QB scoring for Superflex
                            formulas.put(position, ScoringFormula.builder()
                                .position(position)
                                .formula("#passingYards * 0.04 + #passingTDs * 6 - #interceptions * 2 + " +
                                        "#rushingYards * 0.1 + #rushingTDs * 6 - #fumblesLost * 2")
                                .description("Superflex QB scoring: 6pt/TD instead of 4pt")
                                .build());
                        } else {
                            formulas.put(position, ScoringFormula.fullPPR(position));
                        }
                    }
                }
            }
        }

        return formulas;
    }

    /**
     * Gets the formula for a specific position in this template
     */
    public ScoringFormula getFormulaForPosition(Position position) {
        return getFormulas().get(position);
    }
}
