package com.ffl.playoffs.domain.model;

/**
 * Direction of travel between locations.
 */
public enum TravelDirection {
    EAST("Traveling east", -1),      // Harder adjustment
    WEST("Traveling west", 1),       // Easier adjustment
    NORTH("Traveling north", 0),
    SOUTH("Traveling south", 0),
    NORTHEAST("Traveling northeast", -1),
    NORTHWEST("Traveling northwest", 0),
    SOUTHEAST("Traveling southeast", -1),
    SOUTHWEST("Traveling southwest", 0);

    private final String description;
    private final int timeZoneAdjustmentFactor;

    TravelDirection(String description, int timeZoneAdjustmentFactor) {
        this.description = description;
        this.timeZoneAdjustmentFactor = timeZoneAdjustmentFactor;
    }

    public String getDescription() {
        return description;
    }

    /**
     * Factor for time zone adjustment fatigue.
     * Negative = harder (eastward), Positive = easier (westward), 0 = neutral.
     */
    public int getTimeZoneAdjustmentFactor() {
        return timeZoneAdjustmentFactor;
    }

    public boolean isEastward() {
        return this == EAST || this == NORTHEAST || this == SOUTHEAST;
    }

    public boolean isWestward() {
        return this == WEST || this == NORTHWEST || this == SOUTHWEST;
    }

    public static TravelDirection from(double originLat, double originLon,
                                        double destLat, double destLon) {
        double latDiff = destLat - originLat;
        double lonDiff = destLon - originLon;

        boolean north = latDiff > 0;
        boolean east = lonDiff > 0;

        if (Math.abs(latDiff) > Math.abs(lonDiff) * 2) {
            return north ? NORTH : SOUTH;
        } else if (Math.abs(lonDiff) > Math.abs(latDiff) * 2) {
            return east ? EAST : WEST;
        } else if (north && east) {
            return NORTHEAST;
        } else if (north) {
            return NORTHWEST;
        } else if (east) {
            return SOUTHEAST;
        } else {
            return SOUTHWEST;
        }
    }
}
