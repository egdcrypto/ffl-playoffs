package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.util.Map;

/**
 * MongoDB document for WeatherZone entity.
 */
@Document(collection = "weather_zones")
public class WeatherZoneDocument {

    @Id
    private String id;

    private String name;

    @Indexed(unique = true)
    private String code;

    @Indexed
    private String climateType;

    // Geographic bounds
    private BoundsDocument bounds;

    // Monthly weather profiles (key: month number as string "1"-"12")
    private Map<String, MonthlyProfileDocument> monthlyProfiles;

    // Precipitation characteristics
    private Double annualPrecipitationInches;
    private Double annualSnowfallInches;

    public WeatherZoneDocument() {
    }

    // Embedded documents

    public static class BoundsDocument {
        private Double northLat;
        private Double southLat;
        private Double eastLon;
        private Double westLon;

        public BoundsDocument() {
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
    }

    public static class MonthlyProfileDocument {
        private Integer month;
        private Double clearProbability;
        private Double cloudyProbability;
        private Double rainProbability;
        private Double snowProbability;
        private Double stormProbability;
        private Double calmWindProbability;
        private Double moderateWindProbability;
        private Double highWindProbability;
        private Double averageWindSpeed;
        private Double averageHigh;
        private Double averageLow;
        private Double recordHigh;
        private Double recordLow;
        private Double averageHumidity;

        public MonthlyProfileDocument() {
        }

        public Integer getMonth() {
            return month;
        }

        public void setMonth(Integer month) {
            this.month = month;
        }

        public Double getClearProbability() {
            return clearProbability;
        }

        public void setClearProbability(Double clearProbability) {
            this.clearProbability = clearProbability;
        }

        public Double getCloudyProbability() {
            return cloudyProbability;
        }

        public void setCloudyProbability(Double cloudyProbability) {
            this.cloudyProbability = cloudyProbability;
        }

        public Double getRainProbability() {
            return rainProbability;
        }

        public void setRainProbability(Double rainProbability) {
            this.rainProbability = rainProbability;
        }

        public Double getSnowProbability() {
            return snowProbability;
        }

        public void setSnowProbability(Double snowProbability) {
            this.snowProbability = snowProbability;
        }

        public Double getStormProbability() {
            return stormProbability;
        }

        public void setStormProbability(Double stormProbability) {
            this.stormProbability = stormProbability;
        }

        public Double getCalmWindProbability() {
            return calmWindProbability;
        }

        public void setCalmWindProbability(Double calmWindProbability) {
            this.calmWindProbability = calmWindProbability;
        }

        public Double getModerateWindProbability() {
            return moderateWindProbability;
        }

        public void setModerateWindProbability(Double moderateWindProbability) {
            this.moderateWindProbability = moderateWindProbability;
        }

        public Double getHighWindProbability() {
            return highWindProbability;
        }

        public void setHighWindProbability(Double highWindProbability) {
            this.highWindProbability = highWindProbability;
        }

        public Double getAverageWindSpeed() {
            return averageWindSpeed;
        }

        public void setAverageWindSpeed(Double averageWindSpeed) {
            this.averageWindSpeed = averageWindSpeed;
        }

        public Double getAverageHigh() {
            return averageHigh;
        }

        public void setAverageHigh(Double averageHigh) {
            this.averageHigh = averageHigh;
        }

        public Double getAverageLow() {
            return averageLow;
        }

        public void setAverageLow(Double averageLow) {
            this.averageLow = averageLow;
        }

        public Double getRecordHigh() {
            return recordHigh;
        }

        public void setRecordHigh(Double recordHigh) {
            this.recordHigh = recordHigh;
        }

        public Double getRecordLow() {
            return recordLow;
        }

        public void setRecordLow(Double recordLow) {
            this.recordLow = recordLow;
        }

        public Double getAverageHumidity() {
            return averageHumidity;
        }

        public void setAverageHumidity(Double averageHumidity) {
            this.averageHumidity = averageHumidity;
        }
    }

    // Getters and Setters

    public String getId() {
        return id;
    }

    public void setId(String id) {
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

    public String getClimateType() {
        return climateType;
    }

    public void setClimateType(String climateType) {
        this.climateType = climateType;
    }

    public BoundsDocument getBounds() {
        return bounds;
    }

    public void setBounds(BoundsDocument bounds) {
        this.bounds = bounds;
    }

    public Map<String, MonthlyProfileDocument> getMonthlyProfiles() {
        return monthlyProfiles;
    }

    public void setMonthlyProfiles(Map<String, MonthlyProfileDocument> monthlyProfiles) {
        this.monthlyProfiles = monthlyProfiles;
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
}
