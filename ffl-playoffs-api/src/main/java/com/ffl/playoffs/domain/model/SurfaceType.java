package com.ffl.playoffs.domain.model;

/**
 * Type of playing surface in a stadium.
 */
public enum SurfaceType {
    NATURAL_GRASS("Natural grass surface", 1.0),
    ARTIFICIAL_TURF("Synthetic turf", 1.15),
    HYBRID("Natural/synthetic hybrid", 1.05);

    private final String description;
    private final double injuryMultiplier;

    SurfaceType(String description, double injuryMultiplier) {
        this.description = description;
        this.injuryMultiplier = injuryMultiplier;
    }

    public String getDescription() {
        return description;
    }

    /**
     * Returns the relative injury risk multiplier.
     * 1.0 = baseline (natural grass), higher = more risky.
     */
    public double getInjuryMultiplier() {
        return injuryMultiplier;
    }

    public boolean isNatural() {
        return this == NATURAL_GRASS || this == HYBRID;
    }

    public boolean isArtificial() {
        return this == ARTIFICIAL_TURF;
    }
}
