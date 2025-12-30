package com.ffl.playoffs.infrastructure.adapter.persistence.document;

import org.springframework.data.annotation.Id;
import org.springframework.data.mongodb.core.index.Indexed;
import org.springframework.data.mongodb.core.mapping.Document;

import java.time.LocalDateTime;
import java.util.List;

/**
 * MongoDB document for Stadium aggregate.
 */
@Document(collection = "stadiums")
public class StadiumDocument {

    @Id
    private String id;

    private String name;

    @Indexed(unique = true)
    private String code;

    @Indexed
    private String primaryTeamAbbreviation;

    private List<String> tenantTeams;

    // Location (embedded)
    private CoordinatesDocument coordinates;
    private AddressDocument address;
    private String timeZone;

    @Indexed
    private String weatherZoneCode;

    // Venue characteristics
    @Indexed
    private String venueType;  // OUTDOOR, DOME, RETRACTABLE
    private String surfaceType;  // NATURAL_GRASS, ARTIFICIAL_TURF, HYBRID
    private Integer capacity;
    private Integer elevation;

    // Simulation factors
    private Double homeFieldAdvantage;
    private Double noiseFactor;
    private Double weatherExposure;

    // Metadata
    private Integer openedYear;
    private Boolean isActive;
    private LocalDateTime updatedAt;

    public StadiumDocument() {
    }

    // Embedded documents

    public static class CoordinatesDocument {
        private Double latitude;
        private Double longitude;

        public CoordinatesDocument() {
        }

        public CoordinatesDocument(Double latitude, Double longitude) {
            this.latitude = latitude;
            this.longitude = longitude;
        }

        public Double getLatitude() {
            return latitude;
        }

        public void setLatitude(Double latitude) {
            this.latitude = latitude;
        }

        public Double getLongitude() {
            return longitude;
        }

        public void setLongitude(Double longitude) {
            this.longitude = longitude;
        }
    }

    public static class AddressDocument {
        private String street;
        private String city;
        private String state;
        private String postalCode;
        private String country;

        public AddressDocument() {
        }

        public String getStreet() {
            return street;
        }

        public void setStreet(String street) {
            this.street = street;
        }

        public String getCity() {
            return city;
        }

        public void setCity(String city) {
            this.city = city;
        }

        public String getState() {
            return state;
        }

        public void setState(String state) {
            this.state = state;
        }

        public String getPostalCode() {
            return postalCode;
        }

        public void setPostalCode(String postalCode) {
            this.postalCode = postalCode;
        }

        public String getCountry() {
            return country;
        }

        public void setCountry(String country) {
            this.country = country;
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

    public String getPrimaryTeamAbbreviation() {
        return primaryTeamAbbreviation;
    }

    public void setPrimaryTeamAbbreviation(String primaryTeamAbbreviation) {
        this.primaryTeamAbbreviation = primaryTeamAbbreviation;
    }

    public List<String> getTenantTeams() {
        return tenantTeams;
    }

    public void setTenantTeams(List<String> tenantTeams) {
        this.tenantTeams = tenantTeams;
    }

    public CoordinatesDocument getCoordinates() {
        return coordinates;
    }

    public void setCoordinates(CoordinatesDocument coordinates) {
        this.coordinates = coordinates;
    }

    public AddressDocument getAddress() {
        return address;
    }

    public void setAddress(AddressDocument address) {
        this.address = address;
    }

    public String getTimeZone() {
        return timeZone;
    }

    public void setTimeZone(String timeZone) {
        this.timeZone = timeZone;
    }

    public String getWeatherZoneCode() {
        return weatherZoneCode;
    }

    public void setWeatherZoneCode(String weatherZoneCode) {
        this.weatherZoneCode = weatherZoneCode;
    }

    public String getVenueType() {
        return venueType;
    }

    public void setVenueType(String venueType) {
        this.venueType = venueType;
    }

    public String getSurfaceType() {
        return surfaceType;
    }

    public void setSurfaceType(String surfaceType) {
        this.surfaceType = surfaceType;
    }

    public Integer getCapacity() {
        return capacity;
    }

    public void setCapacity(Integer capacity) {
        this.capacity = capacity;
    }

    public Integer getElevation() {
        return elevation;
    }

    public void setElevation(Integer elevation) {
        this.elevation = elevation;
    }

    public Double getHomeFieldAdvantage() {
        return homeFieldAdvantage;
    }

    public void setHomeFieldAdvantage(Double homeFieldAdvantage) {
        this.homeFieldAdvantage = homeFieldAdvantage;
    }

    public Double getNoiseFactor() {
        return noiseFactor;
    }

    public void setNoiseFactor(Double noiseFactor) {
        this.noiseFactor = noiseFactor;
    }

    public Double getWeatherExposure() {
        return weatherExposure;
    }

    public void setWeatherExposure(Double weatherExposure) {
        this.weatherExposure = weatherExposure;
    }

    public Integer getOpenedYear() {
        return openedYear;
    }

    public void setOpenedYear(Integer openedYear) {
        this.openedYear = openedYear;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}
