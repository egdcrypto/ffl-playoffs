package com.ffl.playoffs.domain.model;

import java.util.Objects;

/**
 * Value object representing geographic coordinates.
 */
public class GeoCoordinates {

    private final Double latitude;
    private final Double longitude;

    private GeoCoordinates(Double latitude, Double longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }

    /**
     * Creates validated geographic coordinates.
     *
     * @param latitude  Latitude (-90 to 90)
     * @param longitude Longitude (-180 to 180)
     * @return GeoCoordinates instance
     * @throws InvalidCoordinateException if coordinates are out of range
     */
    public static GeoCoordinates of(double latitude, double longitude) {
        if (latitude < -90 || latitude > 90) {
            throw new InvalidCoordinateException(
                    "Latitude must be between -90 and 90, got: " + latitude);
        }
        if (longitude < -180 || longitude > 180) {
            throw new InvalidCoordinateException(
                    "Longitude must be between -180 and 180, got: " + longitude);
        }
        return new GeoCoordinates(latitude, longitude);
    }

    /**
     * Calculates the great-circle distance to another coordinate using Haversine formula.
     */
    public Distance distanceTo(GeoCoordinates other) {
        double earthRadius = 3959.0; // miles

        double dLat = Math.toRadians(other.latitude - this.latitude);
        double dLon = Math.toRadians(other.longitude - this.longitude);

        double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
                   Math.cos(Math.toRadians(this.latitude)) *
                   Math.cos(Math.toRadians(other.latitude)) *
                   Math.sin(dLon / 2) * Math.sin(dLon / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return Distance.miles(earthRadius * c);
    }

    /**
     * Approximate time zone hour difference based on longitude.
     */
    public int getTimeZoneOffset(GeoCoordinates other) {
        return (int) Math.round((other.longitude - this.longitude) / 15.0);
    }

    /**
     * Gets the travel direction to another coordinate.
     */
    public TravelDirection getDirectionTo(GeoCoordinates other) {
        return TravelDirection.from(
                this.latitude, this.longitude,
                other.latitude, other.longitude
        );
    }

    public Double getLatitude() {
        return latitude;
    }

    public Double getLongitude() {
        return longitude;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        GeoCoordinates that = (GeoCoordinates) o;
        return Objects.equals(latitude, that.latitude) &&
               Objects.equals(longitude, that.longitude);
    }

    @Override
    public int hashCode() {
        return Objects.hash(latitude, longitude);
    }

    @Override
    public String toString() {
        return String.format("%.4f, %.4f", latitude, longitude);
    }

    /**
     * Exception for invalid coordinate values.
     */
    public static class InvalidCoordinateException extends RuntimeException {
        public InvalidCoordinateException(String message) {
            super(message);
        }
    }
}
