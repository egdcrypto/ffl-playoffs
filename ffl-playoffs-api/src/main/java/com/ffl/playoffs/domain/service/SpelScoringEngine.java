package com.ffl.playoffs.domain.service;

import org.springframework.expression.Expression;
import org.springframework.expression.ExpressionParser;
import org.springframework.expression.spel.standard.SpelExpressionParser;
import org.springframework.expression.spel.support.StandardEvaluationContext;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * SpEL-Based Dynamic Scoring Engine
 *
 * Provides flexible fantasy scoring using Spring Expression Language (SpEL).
 * Supports:
 * - Custom scoring formulas per position
 * - Conditional expressions for tiered scoring
 * - Milestone bonuses
 * - Formula validation
 * - Compilation caching for performance
 * - Real-time batch evaluation
 */
@Service
public class SpelScoringEngine {

    private final ExpressionParser parser = new SpelExpressionParser();
    private final Map<String, Expression> compiledFormulaCache = new ConcurrentHashMap<>();

    /**
     * Valid stat variable names that can be used in formulas
     */
    private static final Set<String> VALID_VARIABLES = Set.of(
        // Passing stats
        "passingYards", "passingTDs", "interceptions", "passingAttempts", "passingCompletions",

        // Rushing stats
        "rushingYards", "rushingTDs", "rushingAttempts",

        // Receiving stats
        "receptions", "receivingYards", "receivingTDs", "targets",

        // Other offensive stats
        "fumblesLost", "twoPointConversions",

        // Kicker stats
        "xpMade", "xpMissed", "fgMade", "fgMissed",
        "fg0to39Made", "fg40to49Made", "fg50PlusMade",
        "fg0to39Missed", "fg40to49Missed",

        // Defensive stats
        "sacks", "defensiveInterceptions", "fumbleRecoveries",
        "defensiveTDs", "safeties", "pointsAllowed", "yardsAllowed",

        // League configuration variables
        "pprValue", "tePremium", "baseScore"
    );

    /**
     * Calculates fantasy points using a SpEL formula
     *
     * @param formula SpEL expression string
     * @param stats Map of variable names to values
     * @return Calculated fantasy points
     * @throws ScoringFormulaException if formula evaluation fails
     */
    public Double calculate(String formula, Map<String, Object> stats) {
        try {
            Expression expression = getOrCompileFormula(formula);
            StandardEvaluationContext context = createEvaluationContext(stats);
            return expression.getValue(context, Double.class);
        } catch (Exception e) {
            throw new ScoringFormulaException("Failed to evaluate formula: " + formula, e);
        }
    }

    /**
     * Batch calculates fantasy points for multiple players
     * Optimized for real-time scoring of 1000+ players
     *
     * @param formula SpEL expression string
     * @param playerStatsMap Map of player IDs to their stats
     * @return Map of player IDs to calculated points
     */
    public Map<String, Double> batchCalculate(String formula, Map<String, Map<String, Object>> playerStatsMap) {
        Expression expression = getOrCompileFormula(formula);
        Map<String, Double> results = new HashMap<>();

        playerStatsMap.forEach((playerId, stats) -> {
            try {
                StandardEvaluationContext context = createEvaluationContext(stats);
                Double points = expression.getValue(context, Double.class);
                results.put(playerId, points);
            } catch (Exception e) {
                throw new ScoringFormulaException(
                    "Failed to calculate for player " + playerId + ": " + formula, e);
            }
        });

        return results;
    }

    /**
     * Validates a scoring formula
     *
     * @param formula SpEL expression string
     * @return Validation result
     */
    public FormulaValidationResult validate(String formula) {
        try {
            // Parse the formula
            Expression expression = parser.parseExpression(formula);

            // Test evaluation with sample data
            StandardEvaluationContext context = createSampleContext();
            expression.getValue(context, Double.class);

            // Check for unknown variables (simplified check)
            List<String> unknownVariables = extractUnknownVariables(formula);
            if (!unknownVariables.isEmpty()) {
                return FormulaValidationResult.invalid(
                    "Unknown variable: " + unknownVariables.get(0));
            }

            return FormulaValidationResult.valid();
        } catch (Exception e) {
            return FormulaValidationResult.invalid(e.getMessage());
        }
    }

    /**
     * Clears the formula compilation cache
     * Useful when formulas are updated
     */
    public void clearCache() {
        compiledFormulaCache.clear();
    }

    /**
     * Gets cache size for monitoring
     */
    public int getCacheSize() {
        return compiledFormulaCache.size();
    }

    /**
     * Gets or compiles a formula from cache
     */
    private Expression getOrCompileFormula(String formula) {
        return compiledFormulaCache.computeIfAbsent(formula, parser::parseExpression);
    }

    /**
     * Creates an evaluation context with all variables set
     */
    private StandardEvaluationContext createEvaluationContext(Map<String, Object> stats) {
        StandardEvaluationContext context = new StandardEvaluationContext();

        // Set all stats as variables
        stats.forEach((key, value) -> {
            // Convert Integer to appropriate type for calculations
            if (value instanceof Integer) {
                context.setVariable(key, ((Integer) value).doubleValue());
            } else {
                context.setVariable(key, value);
            }
        });

        // Set default values for common variables if not present
        setDefaultIfAbsent(context, "passingYards", 0.0);
        setDefaultIfAbsent(context, "passingTDs", 0.0);
        setDefaultIfAbsent(context, "interceptions", 0.0);
        setDefaultIfAbsent(context, "rushingYards", 0.0);
        setDefaultIfAbsent(context, "rushingTDs", 0.0);
        setDefaultIfAbsent(context, "receptions", 0.0);
        setDefaultIfAbsent(context, "receivingYards", 0.0);
        setDefaultIfAbsent(context, "receivingTDs", 0.0);
        setDefaultIfAbsent(context, "fumblesLost", 0.0);

        return context;
    }

    /**
     * Creates a sample context for validation
     */
    private StandardEvaluationContext createSampleContext() {
        Map<String, Object> sampleStats = new HashMap<>();

        // Add sample values for all valid variables
        VALID_VARIABLES.forEach(var -> sampleStats.put(var, 0.0));

        return createEvaluationContext(sampleStats);
    }

    /**
     * Sets a default value if variable is not already set
     */
    private void setDefaultIfAbsent(StandardEvaluationContext context, String variable, Object defaultValue) {
        try {
            Object value = context.lookupVariable(variable);
            if (value == null) {
                context.setVariable(variable, defaultValue);
            }
        } catch (Exception e) {
            context.setVariable(variable, defaultValue);
        }
    }

    /**
     * Extracts unknown variables from formula (simplified implementation)
     * A complete implementation would use proper SpEL AST parsing
     */
    private List<String> extractUnknownVariables(String formula) {
        List<String> unknown = new ArrayList<>();

        // Simple regex-based extraction (simplified)
        // Look for #variableName patterns
        java.util.regex.Pattern pattern = java.util.regex.Pattern.compile("#([a-zA-Z][a-zA-Z0-9]*)");
        java.util.regex.Matcher matcher = pattern.matcher(formula);

        while (matcher.find()) {
            String varName = matcher.group(1);
            if (!VALID_VARIABLES.contains(varName)) {
                unknown.add(varName);
            }
        }

        return unknown;
    }

    /**
     * Exception thrown when formula evaluation fails
     */
    public static class ScoringFormulaException extends RuntimeException {
        public ScoringFormulaException(String message, Throwable cause) {
            super(message, cause);
        }
    }

    /**
     * Result of formula validation
     */
    public static class FormulaValidationResult {
        private final boolean valid;
        private final String errorMessage;

        private FormulaValidationResult(boolean valid, String errorMessage) {
            this.valid = valid;
            this.errorMessage = errorMessage;
        }

        public static FormulaValidationResult valid() {
            return new FormulaValidationResult(true, null);
        }

        public static FormulaValidationResult invalid(String errorMessage) {
            return new FormulaValidationResult(false, errorMessage);
        }

        public boolean isValid() {
            return valid;
        }

        public String getErrorMessage() {
            return errorMessage;
        }
    }
}
