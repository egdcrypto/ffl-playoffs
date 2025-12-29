package com.ffl.playoffs.domain.model;

/**
 * How a stat modifier is applied to base values.
 */
public enum ModifierType {
    MULTIPLIER,     // Multiply base value (e.g., 0.8 = 80%)
    ADDITIVE,       // Add to base value
    REPLACEMENT,    // Replace base value entirely
    CAP,            // Set maximum value
    FLOOR           // Set minimum value
}
