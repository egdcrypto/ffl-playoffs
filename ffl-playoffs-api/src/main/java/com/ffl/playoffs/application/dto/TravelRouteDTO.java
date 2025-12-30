package com.ffl.playoffs.application.dto;

import com.ffl.playoffs.domain.entity.TravelRoute;
import com.ffl.playoffs.domain.model.TravelDirection;
import com.ffl.playoffs.domain.model.TravelFatigueLevel;
import lombok.Builder;
import lombok.Data;

import java.util.UUID;

/**
 * Data transfer object for TravelRoute.
 */
@Data
@Builder
public class TravelRouteDTO {

    private UUID id;
    private String originCode;
    private String destinationCode;

    // Distance and time
    private Double distanceMiles;
    private Long estimatedTravelMinutes;
    private Integer timeZoneChange;

    // Impact factors
    private TravelFatigueLevel fatigueLevel;
    private Double performanceModifier;
    private TravelDirection direction;
    private Integer recommendedRestDays;

    // Computed fields
    private boolean isCoastToCoast;
    private boolean crossesMultipleTimeZones;
    private String fatigueDescription;

    public static TravelRouteDTO fromDomain(TravelRoute route) {
        TravelRouteDTOBuilder builder = TravelRouteDTO.builder()
                .id(route.getId())
                .originCode(route.getOriginCode())
                .destinationCode(route.getDestinationCode())
                .timeZoneChange(route.getTimeZoneChange())
                .fatigueLevel(route.getFatigueLevel())
                .performanceModifier(route.getPerformanceModifier())
                .direction(route.getDirection())
                .recommendedRestDays(route.getRecommendedRestDays())
                .isCoastToCoast(route.isCoastToCoast())
                .crossesMultipleTimeZones(route.crossesMultipleTimeZones())
                .fatigueDescription(route.getFatigueDescription());

        if (route.getDistance() != null) {
            builder.distanceMiles(route.getDistance().inMiles());
        }

        if (route.getEstimatedTravelTime() != null) {
            builder.estimatedTravelMinutes(route.getEstimatedTravelTime().toMinutes());
        }

        return builder.build();
    }
}
