package com.ffl.playoffs.domain.model;

/**
 * Source/origin of a world event.
 */
public enum EventSource {
    CURATED,        // Manually created by admin
    SIMULATED,      // Generated during simulation
    HISTORICAL,     // Imported from real NFL data
    RANDOM          // Randomly generated based on probabilities
}
