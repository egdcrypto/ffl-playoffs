package com.ffl.playoffs.domain.entity;

import com.ffl.playoffs.domain.aggregate.Stadium;
import com.ffl.playoffs.domain.model.*;

import java.time.Duration;
import java.util.UUID;

/**
 * TravelRoute entity - represents travel between two stadiums.
 */
public class TravelRoute {

    private UUID id;
    private String originCode;
    private String destinationCode;

    // Distance and time
    private Distance distance;
    private Duration estimatedTravelTime;
    private Integer timeZoneChange;

    // Impact factors
    private TravelFatigueLevel fatigueLevel;
    private Double performanceModifier;

    // Direction
    private TravelDirection direction;

    // Rest requirements
    private Integer recommendedRestDays;

    public TravelRoute() {
        this.id = UUID.randomUUID();
    }

    /**
     * Creates a travel route between two stadiums.
     */
    public static TravelRoute between(Stadium from, Stadium to) {
        TravelRoute route = new TravelRoute();
        route.originCode = from.getCode();
        route.destinationCode = to.getCode();

        // Calculate distance
        route.distance = from.distanceTo(to);

        // Calculate fatigue level
        route.fatigueLevel = route.distance.getFatigueLevel();

        // Calculate travel time
        route.estimatedTravelTime = route.distance.estimatedFlightTime();

        // Calculate time zone change
        route.timeZoneChange = from.timeZoneDifference(to);

        // Determine direction
        if (from.getCoordinates() != null && to.getCoordinates() != null) {
            route.direction = from.getCoordinates().getDirectionTo(to.getCoordinates());
        } else {
            route.direction = TravelDirection.EAST; // default
        }

        // Calculate performance modifier (combines distance and timezone effects)
        route.performanceModifier = calculatePerformanceModifier(
                route.fatigueLevel,
                route.timeZoneChange,
                route.direction
        );

        // Recommended rest days
        route.recommendedRestDays = route.fatigueLevel.getRecommendedRestDays();
        if (Math.abs(route.timeZoneChange) >= 3) {
            route.recommendedRestDays += 1; // Extra day for big timezone changes
        }

        return route;
    }

    private static double calculatePerformanceModifier(TravelFatigueLevel fatigue,
                                                        Integer tzChange,
                                                        TravelDirection direction) {
        double modifier = fatigue.getPerformanceModifier();

        // Additional penalty for timezone changes
        if (tzChange != null && Math.abs(tzChange) >= 2) {
            modifier *= (1.0 - Math.abs(tzChange) * 0.01);
        }

        // Eastward travel is harder on the body
        if (direction != null && direction.isEastward() && tzChange != null && tzChange > 0) {
            modifier *= 0.99;
        }

        return modifier;
    }

    // Business methods

    /**
     * Gets adjusted performance modifier based on days since travel.
     */
    public double getAdjustedModifier(int daysSinceTravel) {
        if (daysSinceTravel >= recommendedRestDays) {
            return 1.0; // Full recovery
        }

        // Partial recovery based on days rested
        double recoveryProgress = (double) daysSinceTravel / recommendedRestDays;
        double penalty = 1.0 - performanceModifier;
        return performanceModifier + (penalty * recoveryProgress);
    }

    /**
     * Returns true if this is a coast-to-coast trip.
     */
    public boolean isCoastToCoast() {
        return distance != null && distance.inMiles() > 2000 &&
               Math.abs(timeZoneChange != null ? timeZoneChange : 0) >= 3;
    }

    /**
     * Returns true if this route crosses multiple time zones.
     */
    public boolean crossesMultipleTimeZones() {
        return timeZoneChange != null && Math.abs(timeZoneChange) >= 2;
    }

    /**
     * Gets fatigue description for display.
     */
    public String getFatigueDescription() {
        StringBuilder sb = new StringBuilder();
        sb.append(fatigueLevel.getDescription());

        if (crossesMultipleTimeZones()) {
            sb.append(" with ").append(Math.abs(timeZoneChange)).append(" timezone change");
            if (direction != null && direction.isEastward()) {
                sb.append(" (eastward - harder adjustment)");
            }
        }

        return sb.toString();
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getOriginCode() {
        return originCode;
    }

    public void setOriginCode(String originCode) {
        this.originCode = originCode;
    }

    public String getDestinationCode() {
        return destinationCode;
    }

    public void setDestinationCode(String destinationCode) {
        this.destinationCode = destinationCode;
    }

    public Distance getDistance() {
        return distance;
    }

    public void setDistance(Distance distance) {
        this.distance = distance;
    }

    public Duration getEstimatedTravelTime() {
        return estimatedTravelTime;
    }

    public void setEstimatedTravelTime(Duration estimatedTravelTime) {
        this.estimatedTravelTime = estimatedTravelTime;
    }

    public Integer getTimeZoneChange() {
        return timeZoneChange;
    }

    public void setTimeZoneChange(Integer timeZoneChange) {
        this.timeZoneChange = timeZoneChange;
    }

    public TravelFatigueLevel getFatigueLevel() {
        return fatigueLevel;
    }

    public void setFatigueLevel(TravelFatigueLevel fatigueLevel) {
        this.fatigueLevel = fatigueLevel;
    }

    public Double getPerformanceModifier() {
        return performanceModifier;
    }

    public void setPerformanceModifier(Double performanceModifier) {
        this.performanceModifier = performanceModifier;
    }

    public TravelDirection getDirection() {
        return direction;
    }

    public void setDirection(TravelDirection direction) {
        this.direction = direction;
    }

    public Integer getRecommendedRestDays() {
        return recommendedRestDays;
    }

    public void setRecommendedRestDays(Integer recommendedRestDays) {
        this.recommendedRestDays = recommendedRestDays;
    }

    @Override
    public String toString() {
        return String.format("TravelRoute{%s -> %s, %.0f miles, %s}",
                originCode, destinationCode,
                distance != null ? distance.inMiles() : 0,
                fatigueLevel);
    }
}
