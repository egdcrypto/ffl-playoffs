package com.ffl.playoffs.domain.model;

import java.time.Duration;
import java.util.Objects;

/**
 * Value object representing distance between locations.
 */
public class Distance {

    private final Double value;
    private final DistanceUnit unit;

    private Distance(Double value, DistanceUnit unit) {
        this.value = value;
        this.unit = unit;
    }

    public static Distance miles(double miles) {
        return new Distance(miles, DistanceUnit.MILES);
    }

    public static Distance kilometers(double km) {
        return new Distance(km, DistanceUnit.KILOMETERS);
    }

    public static Distance meters(double meters) {
        return new Distance(meters, DistanceUnit.METERS);
    }

    public static Distance feet(double feet) {
        return new Distance(feet, DistanceUnit.FEET);
    }

    public double inMiles() {
        return unit.toMiles(value);
    }

    public double inKilometers() {
        return inMiles() * 1.60934;
    }

    public double inMeters() {
        return inKilometers() * 1000;
    }

    /**
     * Estimates flight time for this distance.
     * Assumes 500 mph cruising speed + 1 hour for takeoff/landing.
     */
    public Duration estimatedFlightTime() {
        double hours = inMiles() / 500.0 + 1.0;
        return Duration.ofMinutes((long) (hours * 60));
    }

    /**
     * Gets the fatigue level based on this distance.
     */
    public TravelFatigueLevel getFatigueLevel() {
        return TravelFatigueLevel.fromDistance(inMiles());
    }

    /**
     * Returns the performance modifier for travel this distance.
     */
    public double getPerformanceModifier() {
        return getFatigueLevel().getPerformanceModifier();
    }

    public Double getValue() {
        return value;
    }

    public DistanceUnit getUnit() {
        return unit;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Distance distance = (Distance) o;
        // Compare in same unit (miles)
        return Math.abs(this.inMiles() - distance.inMiles()) < 0.001;
    }

    @Override
    public int hashCode() {
        return Objects.hash(Math.round(inMiles()));
    }

    @Override
    public String toString() {
        if (unit == DistanceUnit.MILES) {
            return String.format("%.1f miles", value);
        }
        return String.format("%.1f %s (%.1f miles)", value, unit.getAbbreviation(), inMiles());
    }
}
