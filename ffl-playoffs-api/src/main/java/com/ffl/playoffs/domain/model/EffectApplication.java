package com.ffl.playoffs.domain.model;

/**
 * How an effect is applied to stats.
 */
public enum EffectApplication {
    MULTIPLIER,     // Multiply stat by value (e.g., 0.8 for -20%)
    ADDITIVE,       // Add value to stat
    REPLACEMENT     // Replace stat entirely with value
}
