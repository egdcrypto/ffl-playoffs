package com.ffl.playoffs.domain.model;

/**
 * Wind direction for weather conditions.
 */
public enum WindDirection {
    NORTH("N", 0),
    NORTHEAST("NE", 45),
    EAST("E", 90),
    SOUTHEAST("SE", 135),
    SOUTH("S", 180),
    SOUTHWEST("SW", 225),
    WEST("W", 270),
    NORTHWEST("NW", 315),
    VARIABLE("VAR", -1),
    CALM("CALM", -1);

    private final String abbreviation;
    private final int degrees;

    WindDirection(String abbreviation, int degrees) {
        this.abbreviation = abbreviation;
        this.degrees = degrees;
    }

    public String getAbbreviation() {
        return abbreviation;
    }

    public int getDegrees() {
        return degrees;
    }

    public boolean isCalm() {
        return this == CALM;
    }

    public static WindDirection fromDegrees(int degrees) {
        if (degrees < 0) return VARIABLE;
        int normalized = degrees % 360;
        if (normalized < 23) return NORTH;
        if (normalized < 68) return NORTHEAST;
        if (normalized < 113) return EAST;
        if (normalized < 158) return SOUTHEAST;
        if (normalized < 203) return SOUTH;
        if (normalized < 248) return SOUTHWEST;
        if (normalized < 293) return WEST;
        if (normalized < 338) return NORTHWEST;
        return NORTH;
    }
}
