package com.ffl.playoffs.domain.model;

/**
 * Level of fatigue from travel.
 */
public enum TravelFatigueLevel {
    MINIMAL(1.0, "Short trip, minimal impact", 0),
    LOW(0.98, "Regional travel, minor fatigue", 1),
    MODERATE(0.95, "Cross-country, noticeable fatigue", 2),
    HIGH(0.92, "Long distance, significant fatigue", 3),
    EXTREME(0.88, "International/max distance", 4);

    private final double performanceModifier;
    private final String description;
    private final int recommendedRestDays;

    TravelFatigueLevel(double performanceModifier, String description, int recommendedRestDays) {
        this.performanceModifier = performanceModifier;
        this.description = description;
        this.recommendedRestDays = recommendedRestDays;
    }

    public double getPerformanceModifier() {
        return performanceModifier;
    }

    public String getDescription() {
        return description;
    }

    public int getRecommendedRestDays() {
        return recommendedRestDays;
    }

    public boolean affectsPerformance() {
        return this != MINIMAL;
    }

    public static TravelFatigueLevel fromDistance(double miles) {
        if (miles < 500) return MINIMAL;
        if (miles < 1000) return LOW;
        if (miles < 1500) return MODERATE;
        if (miles < 2500) return HIGH;
        return EXTREME;
    }
}
