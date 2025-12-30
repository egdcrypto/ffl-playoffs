package com.ffl.playoffs.application.dto;

import com.ffl.playoffs.domain.model.*;
import lombok.Builder;
import lombok.Data;

/**
 * Data transfer object for WeatherConditions.
 */
@Data
@Builder
public class WeatherConditionsDTO {

    private WeatherType type;
    private Integer temperature;
    private Integer humidity;
    private Integer windSpeed;
    private WindDirection windDirection;
    private PrecipitationType precipitation;
    private Double precipitationIntensity;
    private Integer visibility;
    private Boolean lightning;
    private WeatherSeverity severity;
    private FieldCondition fieldCondition;

    // Stat modifiers
    private Double passingModifier;
    private Double rushingModifier;
    private Double kickingModifier;
    private Double injuryRiskModifier;
    private Double turnoverModifier;

    // Display
    private String description;

    public static WeatherConditionsDTO fromDomain(WeatherConditions conditions) {
        return WeatherConditionsDTO.builder()
                .type(conditions.getType())
                .temperature(conditions.getTemperature())
                .humidity(conditions.getHumidity())
                .windSpeed(conditions.getWindSpeed())
                .windDirection(conditions.getWindDirection())
                .precipitation(conditions.getPrecipitation())
                .precipitationIntensity(conditions.getPrecipitationIntensity())
                .visibility(conditions.getVisibility())
                .lightning(conditions.getLightning())
                .severity(conditions.getSeverity())
                .fieldCondition(conditions.getFieldCondition())
                .passingModifier(conditions.getPassingModifier())
                .rushingModifier(conditions.getRushingModifier())
                .kickingModifier(conditions.getKickingModifier())
                .injuryRiskModifier(conditions.getInjuryRiskModifier())
                .turnoverModifier(conditions.getTurnoverModifier())
                .description(conditions.getDescription())
                .build();
    }
}
