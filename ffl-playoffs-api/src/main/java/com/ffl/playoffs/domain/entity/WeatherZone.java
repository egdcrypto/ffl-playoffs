package com.ffl.playoffs.domain.entity;

import com.ffl.playoffs.domain.model.*;

import java.util.*;

/**
 * WeatherZone entity - defines a climate region with weather characteristics.
 */
public class WeatherZone {

    private UUID id;
    private String name;
    private String code;
    private ClimateType climateType;

    // Geographic bounds (optional)
    private Double northLat;
    private Double southLat;
    private Double eastLon;
    private Double westLon;

    // Weather probabilities by month (1-12)
    private Map<Integer, MonthlyWeatherProfile> monthlyProfiles;

    // Precipitation characteristics
    private Double annualPrecipitationInches;
    private Double annualSnowfallInches;

    public WeatherZone() {
        this.id = UUID.randomUUID();
        this.monthlyProfiles = new HashMap<>();
    }

    // Business methods

    /**
     * Generates weather conditions for a given month.
     */
    public WeatherConditions generateWeather(Integer month, Random random) {
        MonthlyWeatherProfile profile = monthlyProfiles.get(month);
        if (profile == null) {
            profile = getDefaultProfile(month);
        }
        return profile.generateWeather(random);
    }

    /**
     * Gets weather probabilities for a specific month.
     */
    public MonthlyWeatherProfile getWeatherProfile(Integer month) {
        return monthlyProfiles.getOrDefault(month, getDefaultProfile(month));
    }

    /**
     * Returns true if snow is possible for a given month.
     */
    public boolean isSnowPossible(Integer month) {
        if (!climateType.isSnowPossible()) {
            return false;
        }
        // Check if it's winter months (Nov-Mar in Northern Hemisphere)
        return month >= 11 || month <= 3;
    }

    /**
     * Returns true if extreme cold is possible for a given month.
     */
    public boolean isExtremeColdPossible(Integer month) {
        if (!climateType.hasColdWinters()) {
            return false;
        }
        MonthlyWeatherProfile profile = monthlyProfiles.get(month);
        if (profile != null && profile.getAverageLow() != null) {
            return profile.getAverageLow() < 20;
        }
        // Default: Dec-Feb in cold climates
        return month == 12 || month <= 2;
    }

    /**
     * Gets temperature range for a month.
     */
    public TemperatureRange getTemperatureRange(Integer month) {
        MonthlyWeatherProfile profile = monthlyProfiles.get(month);
        if (profile != null) {
            return new TemperatureRange(
                    profile.getAverageLow() != null ? profile.getAverageLow().intValue() : 50,
                    profile.getAverageHigh() != null ? profile.getAverageHigh().intValue() : 70
            );
        }
        return new TemperatureRange(50, 70);
    }

    /**
     * Checks if a coordinate is within this zone's bounds.
     */
    public boolean contains(GeoCoordinates coords) {
        if (northLat == null || southLat == null || eastLon == null || westLon == null) {
            return false;
        }
        double lat = coords.getLatitude();
        double lon = coords.getLongitude();
        return lat >= southLat && lat <= northLat &&
               lon >= westLon && lon <= eastLon;
    }

    public void setMonthlyProfile(Integer month, MonthlyWeatherProfile profile) {
        monthlyProfiles.put(month, profile);
    }

    private MonthlyWeatherProfile getDefaultProfile(Integer month) {
        return MonthlyWeatherProfile.builder()
                .month(month)
                .clearProbability(0.4)
                .cloudyProbability(0.3)
                .rainProbability(0.2)
                .snowProbability(climateType.isSnowPossible() && (month >= 11 || month <= 3) ? 0.1 : 0.0)
                .averageHigh(getDefaultHighTemp(month))
                .averageLow(getDefaultLowTemp(month))
                .averageHumidity(climateType.isHumid() ? 75.0 : 50.0)
                .build();
    }

    private double getDefaultHighTemp(Integer month) {
        // Simple sine wave approximation for northern hemisphere
        double base = climateType.hasColdWinters() ? 50 : 75;
        double amplitude = climateType.hasColdWinters() ? 25 : 10;
        return base + amplitude * Math.sin((month - 4) * Math.PI / 6);
    }

    private double getDefaultLowTemp(Integer month) {
        return getDefaultHighTemp(month) - 15;
    }

    // Static factory methods

    public static WeatherZone create(String name, String code, ClimateType climateType) {
        WeatherZone zone = new WeatherZone();
        zone.name = name;
        zone.code = code;
        zone.climateType = climateType;
        return zone;
    }

    // Getters and Setters

    public UUID getId() {
        return id;
    }

    public void setId(UUID id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public ClimateType getClimateType() {
        return climateType;
    }

    public void setClimateType(ClimateType climateType) {
        this.climateType = climateType;
    }

    public Double getNorthLat() {
        return northLat;
    }

    public void setNorthLat(Double northLat) {
        this.northLat = northLat;
    }

    public Double getSouthLat() {
        return southLat;
    }

    public void setSouthLat(Double southLat) {
        this.southLat = southLat;
    }

    public Double getEastLon() {
        return eastLon;
    }

    public void setEastLon(Double eastLon) {
        this.eastLon = eastLon;
    }

    public Double getWestLon() {
        return westLon;
    }

    public void setWestLon(Double westLon) {
        this.westLon = westLon;
    }

    public Map<Integer, MonthlyWeatherProfile> getMonthlyProfiles() {
        return new HashMap<>(monthlyProfiles);
    }

    public void setMonthlyProfiles(Map<Integer, MonthlyWeatherProfile> monthlyProfiles) {
        this.monthlyProfiles = new HashMap<>(monthlyProfiles);
    }

    public Double getAnnualPrecipitationInches() {
        return annualPrecipitationInches;
    }

    public void setAnnualPrecipitationInches(Double annualPrecipitationInches) {
        this.annualPrecipitationInches = annualPrecipitationInches;
    }

    public Double getAnnualSnowfallInches() {
        return annualSnowfallInches;
    }

    public void setAnnualSnowfallInches(Double annualSnowfallInches) {
        this.annualSnowfallInches = annualSnowfallInches;
    }

    @Override
    public String toString() {
        return String.format("WeatherZone{code='%s', name='%s', climate=%s}",
                code, name, climateType);
    }

    /**
     * Temperature range for a month.
     */
    public record TemperatureRange(int low, int high) {
        public int average() {
            return (low + high) / 2;
        }
    }
}
