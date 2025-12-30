package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.CompoundIndex;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;

/**
 * MongoDB document for cached TravelRoute entities.
 */
@Document(collection = "travel_routes")
@CompoundIndex(name = "route_idx", def = "{'originCode': 1, 'destinationCode': 1}", unique = true)
public class TravelRouteDocument {

    @Id
    private String id;

    @Indexed
    private String originCode;

    @Indexed
    private String destinationCode;

    // Distance and time
    @Indexed
    private Double distanceMiles;
    private Long estimatedTravelMinutes;
    private Integer timeZoneChange;

    // Impact factors
    private String fatigueLevel;  // MINIMAL, LOW, MODERATE, HIGH, EXTREME
    private Double performanceModifier;
    private String direction;  // NORTH, SOUTH, EAST, WEST, etc.
    private Integer recommendedRestDays;

    // Metadata
    private LocalDateTime calculatedAt;

    public TravelRouteDocument() {
    }

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
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

    public Double getDistanceMiles() {
        return distanceMiles;
    }

    public void setDistanceMiles(Double distanceMiles) {
        this.distanceMiles = distanceMiles;
    }

    public Long getEstimatedTravelMinutes() {
        return estimatedTravelMinutes;
    }

    public void setEstimatedTravelMinutes(Long estimatedTravelMinutes) {
        this.estimatedTravelMinutes = estimatedTravelMinutes;
    }

    public Integer getTimeZoneChange() {
        return timeZoneChange;
    }

    public void setTimeZoneChange(Integer timeZoneChange) {
        this.timeZoneChange = timeZoneChange;
    }

    public String getFatigueLevel() {
        return fatigueLevel;
    }

    public void setFatigueLevel(String fatigueLevel) {
        this.fatigueLevel = fatigueLevel;
    }

    public Double getPerformanceModifier() {
        return performanceModifier;
    }

    public void setPerformanceModifier(Double performanceModifier) {
        this.performanceModifier = performanceModifier;
    }

    public String getDirection() {
        return direction;
    }

    public void setDirection(String direction) {
        this.direction = direction;
    }

    public Integer getRecommendedRestDays() {
        return recommendedRestDays;
    }

    public void setRecommendedRestDays(Integer recommendedRestDays) {
        this.recommendedRestDays = recommendedRestDays;
    }

    public LocalDateTime getCalculatedAt() {
        return calculatedAt;
    }

    public void setCalculatedAt(LocalDateTime calculatedAt) {
        this.calculatedAt = calculatedAt;
    }
}
