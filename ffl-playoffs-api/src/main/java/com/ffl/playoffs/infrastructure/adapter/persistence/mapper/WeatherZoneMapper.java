package com.ffl.playoffs.infrastructure.adapter.persistence.mapper;

import com.ffl.playoffs.domain.entity.WeatherZone;
import com.ffl.playoffs.domain.model.ClimateType;
import com.ffl.playoffs.domain.model.MonthlyWeatherProfile;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WeatherZoneDocument;
import org.springframework.stereotype.Component;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Mapper to convert between WeatherZone domain model and WeatherZoneDocument.
 */
@Component
public class WeatherZoneMapper {

    /**
     * Converts WeatherZone domain entity to WeatherZoneDocument.
     */
    public WeatherZoneDocument toDocument(WeatherZone zone) {
        if (zone == null) {
            return null;
        }

        WeatherZoneDocument document = new WeatherZoneDocument();
        document.setId(zone.getId() != null ? zone.getId().toString() : null);
        document.setName(zone.getName());
        document.setCode(zone.getCode());
        document.setClimateType(zone.getClimateType() != null ? zone.getClimateType().name() : null);
        document.setAnnualPrecipitationInches(zone.getAnnualPrecipitationInches());
        document.setAnnualSnowfallInches(zone.getAnnualSnowfallInches());

        // Bounds
        if (zone.getNorthLat() != null || zone.getSouthLat() != null ||
            zone.getEastLon() != null || zone.getWestLon() != null) {
            WeatherZoneDocument.BoundsDocument bounds = new WeatherZoneDocument.BoundsDocument();
            bounds.setNorthLat(zone.getNorthLat());
            bounds.setSouthLat(zone.getSouthLat());
            bounds.setEastLon(zone.getEastLon());
            bounds.setWestLon(zone.getWestLon());
            document.setBounds(bounds);
        }

        // Monthly profiles
        if (zone.getMonthlyProfiles() != null && !zone.getMonthlyProfiles().isEmpty()) {
            Map<String, WeatherZoneDocument.MonthlyProfileDocument> profileDocs = new HashMap<>();
            for (Map.Entry<Integer, MonthlyWeatherProfile> entry : zone.getMonthlyProfiles().entrySet()) {
                profileDocs.put(entry.getKey().toString(), toProfileDocument(entry.getValue()));
            }
            document.setMonthlyProfiles(profileDocs);
        }

        return document;
    }

    /**
     * Converts WeatherZoneDocument to WeatherZone domain entity.
     */
    public WeatherZone toDomain(WeatherZoneDocument document) {
        if (document == null) {
            return null;
        }

        WeatherZone zone = new WeatherZone();
        zone.setId(document.getId() != null ? UUID.fromString(document.getId()) : null);
        zone.setName(document.getName());
        zone.setCode(document.getCode());
        zone.setClimateType(document.getClimateType() != null ? ClimateType.valueOf(document.getClimateType()) : null);
        zone.setAnnualPrecipitationInches(document.getAnnualPrecipitationInches());
        zone.setAnnualSnowfallInches(document.getAnnualSnowfallInches());

        // Bounds
        if (document.getBounds() != null) {
            zone.setNorthLat(document.getBounds().getNorthLat());
            zone.setSouthLat(document.getBounds().getSouthLat());
            zone.setEastLon(document.getBounds().getEastLon());
            zone.setWestLon(document.getBounds().getWestLon());
        }

        // Monthly profiles
        if (document.getMonthlyProfiles() != null && !document.getMonthlyProfiles().isEmpty()) {
            Map<Integer, MonthlyWeatherProfile> profiles = new HashMap<>();
            for (Map.Entry<String, WeatherZoneDocument.MonthlyProfileDocument> entry :
                    document.getMonthlyProfiles().entrySet()) {
                profiles.put(Integer.parseInt(entry.getKey()), toProfileDomain(entry.getValue()));
            }
            zone.setMonthlyProfiles(profiles);
        }

        return zone;
    }

    private WeatherZoneDocument.MonthlyProfileDocument toProfileDocument(MonthlyWeatherProfile profile) {
        WeatherZoneDocument.MonthlyProfileDocument doc = new WeatherZoneDocument.MonthlyProfileDocument();
        doc.setMonth(profile.getMonth());
        doc.setClearProbability(profile.getClearProbability());
        doc.setCloudyProbability(profile.getCloudyProbability());
        doc.setRainProbability(profile.getRainProbability());
        doc.setSnowProbability(profile.getSnowProbability());
        doc.setStormProbability(profile.getStormProbability());
        doc.setAverageWindSpeed(profile.getAverageWindSpeed());
        doc.setAverageHigh(profile.getAverageHigh());
        doc.setAverageLow(profile.getAverageLow());
        doc.setAverageHumidity(profile.getAverageHumidity());
        return doc;
    }

    private MonthlyWeatherProfile toProfileDomain(WeatherZoneDocument.MonthlyProfileDocument doc) {
        return MonthlyWeatherProfile.builder()
                .month(doc.getMonth())
                .clearProbability(doc.getClearProbability())
                .cloudyProbability(doc.getCloudyProbability())
                .rainProbability(doc.getRainProbability())
                .snowProbability(doc.getSnowProbability())
                .stormProbability(doc.getStormProbability())
                .averageWindSpeed(doc.getAverageWindSpeed())
                .averageHigh(doc.getAverageHigh())
                .averageLow(doc.getAverageLow())
                .averageHumidity(doc.getAverageHumidity())
                .build();
    }
}
