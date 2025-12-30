package com.ffl.playoffs.domain.model;

/**
 * Unit of distance measurement.
 */
public enum DistanceUnit {
    MILES("mi", 1.0),
    KILOMETERS("km", 1.60934),
    METERS("m", 1609.34),
    FEET("ft", 5280.0);

    private final String abbreviation;
    private final double toMilesMultiplier;

    DistanceUnit(String abbreviation, double toMilesMultiplier) {
        this.abbreviation = abbreviation;
        this.toMilesMultiplier = toMilesMultiplier;
    }

    public String getAbbreviation() {
        return abbreviation;
    }

    /**
     * Multiplier to convert 1 mile to this unit.
     */
    public double getToMilesMultiplier() {
        return toMilesMultiplier;
    }

    public double toMiles(double value) {
        return value / toMilesMultiplier;
    }

    public double fromMiles(double miles) {
        return miles * toMilesMultiplier;
    }
}
