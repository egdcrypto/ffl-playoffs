package com.ffl.playoffs.domain.aggregate;

import com.ffl.playoffs.domain.model.*;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Stadium aggregate root - represents an NFL stadium or venue.
 */
public class Stadium {

    private UUID id;
    private String name;
    private String code;

    // Team association
    private String primaryTeamAbbreviation;
    private List<String> tenantTeams;

    // Location
    private GeoCoordinates coordinates;
    private Address address;
    private String timeZone;
    private String weatherZoneCode;

    // Venue characteristics
    private VenueType venueType;
    private SurfaceType surfaceType;
    private Integer capacity;
    private Integer elevation;  // Feet above sea level

    // Simulation factors
    private Double homeFieldAdvantage;
    private Double noiseFactor;
    private Double weatherExposure;

    // Metadata
    private Integer openedYear;
    private Boolean isActive;
    private LocalDateTime updatedAt;

    public Stadium() {
        this.id = UUID.randomUUID();
        this.tenantTeams = new ArrayList<>();
        this.isActive = true;
        this.homeFieldAdvantage = 1.0;
        this.noiseFactor = 1.0;
        this.updatedAt = LocalDateTime.now();
    }

    // Business methods

    /**
     * Returns true if stadium is fully exposed to weather.
     */
    public boolean isOutdoor() {
        return venueType == VenueType.OUTDOOR;
    }

    /**
     * Returns true if stadium is a climate-controlled dome.
     */
    public boolean isDome() {
        return venueType == VenueType.DOME;
    }

    /**
     * Returns true if stadium is at high altitude (> 5000 ft).
     */
    public boolean isHighAltitude() {
        return elevation != null && elevation > 5000;
    }

    /**
     * Returns true if weather can affect games at this stadium.
     */
    public boolean isWeatherExposed() {
        return venueType != VenueType.DOME;
    }

    /**
     * Gets the weather exposure factor (0.0 = dome, 1.0 = full outdoor).
     */
    public double getEffectiveWeatherExposure() {
        if (weatherExposure != null) {
            return weatherExposure;
        }
        return venueType.getWeatherExposure();
    }

    /**
     * Gets kicking modifier for altitude.
     * High altitude (Denver) helps kicking due to thin air.
     */
    public double getAltitudeKickingModifier() {
        if (elevation == null || elevation < 3000) {
            return 1.0;
        }
        // At 5280 ft (Denver), ball carries about 5% further
        return 1.0 + (elevation - 3000) / 50000.0;
    }

    /**
     * Gets passing modifier for altitude.
     * Thin air helps passing slightly but affects stamina.
     */
    public double getAltitudePassingModifier() {
        if (elevation == null || elevation < 3000) {
            return 1.0;
        }
        return 1.0 + (elevation - 3000) / 100000.0;
    }

    /**
     * Calculates distance to another stadium.
     */
    public Distance distanceTo(Stadium other) {
        if (coordinates == null || other.coordinates == null) {
            return Distance.miles(0);
        }
        return coordinates.distanceTo(other.coordinates);
    }

    /**
     * Gets time zone difference in hours to another stadium.
     */
    public int timeZoneDifference(Stadium other) {
        if (coordinates == null || other.coordinates == null) {
            return 0;
        }
        return coordinates.getTimeZoneOffset(other.coordinates);
    }

    /**
     * Gets the TimeZoneRegion for this stadium.
     */
    public TimeZoneRegion getTimeZoneRegion() {
        if (timeZone == null) {
            return TimeZoneRegion.eastern();
        }
        return TimeZoneRegion.fromZoneId(timeZone);
    }

    /**
     * Checks if this stadium belongs to the given team.
     */
    public boolean isHomeFor(String teamAbbreviation) {
        if (primaryTeamAbbreviation != null && primaryTeamAbbreviation.equals(teamAbbreviation)) {
            return true;
        }
        return tenantTeams != null && tenantTeams.contains(teamAbbreviation);
    }

    public void addTenantTeam(String teamAbbr) {
        if (tenantTeams == null) {
            tenantTeams = new ArrayList<>();
        }
        if (!tenantTeams.contains(teamAbbr)) {
            tenantTeams.add(teamAbbr);
        }
    }

    // Static factory

    public static Stadium create(String name, String code, String teamAbbr,
                                  double lat, double lon, String timeZone,
                                  VenueType venueType, SurfaceType surfaceType,
                                  int capacity, int elevation) {
        Stadium stadium = new Stadium();
        stadium.name = name;
        stadium.code = code;
        stadium.primaryTeamAbbreviation = teamAbbr;
        stadium.coordinates = GeoCoordinates.of(lat, lon);
        stadium.timeZone = timeZone;
        stadium.venueType = venueType;
        stadium.surfaceType = surfaceType;
        stadium.capacity = capacity;
        stadium.elevation = elevation;
        stadium.weatherExposure = venueType.getWeatherExposure();
        return stadium;
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

    public String getPrimaryTeamAbbreviation() {
        return primaryTeamAbbreviation;
    }

    public void setPrimaryTeamAbbreviation(String primaryTeamAbbreviation) {
        this.primaryTeamAbbreviation = primaryTeamAbbreviation;
    }

    public List<String> getTenantTeams() {
        return new ArrayList<>(tenantTeams);
    }

    public void setTenantTeams(List<String> tenantTeams) {
        this.tenantTeams = new ArrayList<>(tenantTeams);
    }

    public GeoCoordinates getCoordinates() {
        return coordinates;
    }

    public void setCoordinates(GeoCoordinates coordinates) {
        this.coordinates = coordinates;
    }

    public Address getAddress() {
        return address;
    }

    public void setAddress(Address address) {
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

    public VenueType getVenueType() {
        return venueType;
    }

    public void setVenueType(VenueType venueType) {
        this.venueType = venueType;
    }

    public SurfaceType getSurfaceType() {
        return surfaceType;
    }

    public void setSurfaceType(SurfaceType surfaceType) {
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

    @Override
    public String toString() {
        return String.format("Stadium{code='%s', name='%s', team=%s, type=%s}",
                code, name, primaryTeamAbbreviation, venueType);
    }
}
