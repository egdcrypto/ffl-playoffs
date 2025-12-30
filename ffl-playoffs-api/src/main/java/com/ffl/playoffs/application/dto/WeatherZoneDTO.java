package com.ffl.playoffs.application.dto;

import com.ffl.playoffs.domain.entity.WeatherZone;
import com.ffl.playoffs.domain.model.ClimateType;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

/**
 * Data transfer object for WeatherZone.
 */
@Data
@Builder
public class WeatherZoneDTO {

    private UUID id;
    private String name;
    private String code;
    private ClimateType climateType;

    // Geographic bounds
    private Double northLat;
    private Double southLat;
    private Double eastLon;
    private Double westLon;

    // Precipitation characteristics
    private Double annualPrecipitationInches;
    private Double annualSnowfallInches;

    public static WeatherZoneDTO fromDomain(WeatherZone zone) {
        return WeatherZoneDTO.builder()
                .id(zone.getId())
                .name(zone.getName())
                .code(zone.getCode())
                .climateType(zone.getClimateType())
                .northLat(zone.getNorthLat())
                .southLat(zone.getSouthLat())
                .eastLon(zone.getEastLon())
                .westLon(zone.getWestLon())
                .annualPrecipitationInches(zone.getAnnualPrecipitationInches())
                .annualSnowfallInches(zone.getAnnualSnowfallInches())
                .build();
    }
}
