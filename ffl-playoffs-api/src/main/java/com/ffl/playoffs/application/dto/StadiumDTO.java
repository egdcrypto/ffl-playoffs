package com.ffl.playoffs.application.dto;

import com.ffl.playoffs.domain.aggregate.Stadium;
import com.ffl.playoffs.domain.model.SurfaceType;
import com.ffl.playoffs.domain.model.VenueType;
import lombok.Builder;
import lombok.Data;

import java.util.List;
import java.util.UUID;

/**
 * Data transfer object for Stadium.
 */
@Data
@Builder
public class StadiumDTO {

    private UUID id;
    private String name;
    private String code;
    private String primaryTeamAbbreviation;
    private List<String> tenantTeams;

    // Location
    private Double latitude;
    private Double longitude;
    private String city;
    private String state;
    private String timeZone;
    private String weatherZoneCode;

    // Venue characteristics
    private VenueType venueType;
    private SurfaceType surfaceType;
    private Integer capacity;
    private Integer elevation;

    // Simulation factors
    private Double homeFieldAdvantage;
    private Double noiseFactor;
    private Double weatherExposure;

    // Computed fields
    private boolean isOutdoor;
    private boolean isDome;
    private boolean isHighAltitude;

    public static StadiumDTO fromDomain(Stadium stadium) {
        StadiumDTOBuilder builder = StadiumDTO.builder()
                .id(stadium.getId())
                .name(stadium.getName())
                .code(stadium.getCode())
                .primaryTeamAbbreviation(stadium.getPrimaryTeamAbbreviation())
                .tenantTeams(stadium.getTenantTeams())
                .timeZone(stadium.getTimeZone())
                .weatherZoneCode(stadium.getWeatherZoneCode())
                .venueType(stadium.getVenueType())
                .surfaceType(stadium.getSurfaceType())
                .capacity(stadium.getCapacity())
                .elevation(stadium.getElevation())
                .homeFieldAdvantage(stadium.getHomeFieldAdvantage())
                .noiseFactor(stadium.getNoiseFactor())
                .weatherExposure(stadium.getWeatherExposure())
                .isOutdoor(stadium.isOutdoor())
                .isDome(stadium.isDome())
                .isHighAltitude(stadium.isHighAltitude());

        if (stadium.getCoordinates() != null) {
            builder.latitude(stadium.getCoordinates().getLatitude())
                    .longitude(stadium.getCoordinates().getLongitude());
        }

        if (stadium.getAddress() != null) {
            builder.city(stadium.getAddress().getCity())
                    .state(stadium.getAddress().getState());
        }

        return builder.build();
    }
}
