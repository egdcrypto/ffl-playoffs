package com.ffl.playoffs.domain.model;

import java.util.Objects;

/**
 * Value object representing current or simulated weather conditions at a location.
 */
public class WeatherConditions {

    private final WeatherType type;
    private final Integer temperature;           // Fahrenheit
    private final Integer humidity;              // Percentage
    private final Integer windSpeed;             // MPH
    private final WindDirection windDirection;
    private final PrecipitationType precipitation;
    private final Double precipitationIntensity; // 0.0-1.0
    private final Integer visibility;            // Miles
    private final Boolean lightning;
    private final Integer feelsLike;             // Wind chill / heat index
    private final FieldCondition fieldCondition;

    private WeatherConditions(Builder builder) {
        this.type = builder.type;
        this.temperature = builder.temperature;
        this.humidity = builder.humidity;
        this.windSpeed = builder.windSpeed;
        this.windDirection = builder.windDirection;
        this.precipitation = builder.precipitation;
        this.precipitationIntensity = builder.precipitationIntensity;
        this.visibility = builder.visibility;
        this.lightning = builder.lightning;
        this.feelsLike = builder.feelsLike != null ? builder.feelsLike :
                calculateFeelsLike(builder.temperature, builder.windSpeed, builder.humidity);
        this.fieldCondition = builder.fieldCondition != null ? builder.fieldCondition :
                FieldCondition.fromWeather(builder.type, builder.temperature != null ? builder.temperature : 70);
    }

    public static Builder builder() {
        return new Builder();
    }

    // Factory methods

    public static WeatherConditions ideal() {
        return builder()
                .type(WeatherType.CLEAR)
                .temperature(72)
                .humidity(50)
                .windSpeed(5)
                .windDirection(WindDirection.CALM)
                .precipitation(PrecipitationType.NONE)
                .visibility(10)
                .lightning(false)
                .build();
    }

    public static WeatherConditions dome() {
        return builder()
                .type(WeatherType.CLEAR)
                .temperature(72)
                .humidity(50)
                .windSpeed(0)
                .windDirection(WindDirection.CALM)
                .precipitation(PrecipitationType.NONE)
                .visibility(10)
                .lightning(false)
                .fieldCondition(FieldCondition.DRY)
                .build();
    }

    public static WeatherConditions rain(int temperature, int windSpeed) {
        return builder()
                .type(WeatherType.RAIN)
                .temperature(temperature)
                .humidity(85)
                .windSpeed(windSpeed)
                .precipitation(PrecipitationType.MODERATE_RAIN)
                .precipitationIntensity(0.5)
                .visibility(3)
                .lightning(false)
                .build();
    }

    public static WeatherConditions snow(int temperature, double intensity) {
        return builder()
                .type(intensity > 0.6 ? WeatherType.HEAVY_SNOW : WeatherType.SNOW)
                .temperature(temperature)
                .humidity(80)
                .windSpeed(10)
                .precipitation(intensity > 0.6 ? PrecipitationType.HEAVY_SNOW : PrecipitationType.MODERATE_SNOW)
                .precipitationIntensity(intensity)
                .visibility(intensity > 0.6 ? 1 : 3)
                .lightning(false)
                .build();
    }

    public static WeatherConditions extremeCold(int temperature, int windSpeed) {
        return builder()
                .type(WeatherType.CLEAR)
                .temperature(temperature)
                .humidity(40)
                .windSpeed(windSpeed)
                .precipitation(PrecipitationType.NONE)
                .visibility(10)
                .lightning(false)
                .fieldCondition(FieldCondition.FROZEN)
                .build();
    }

    // Stat modifiers

    public double getPassingModifier() {
        double modifier = type.getPassingModifier();
        if (windSpeed != null && windSpeed > 15) {
            modifier *= (1.0 - (windSpeed - 15) * 0.01);
        }
        if (isCold()) {
            modifier *= 0.95;
        }
        return Math.max(0.5, modifier);
    }

    public double getKickingModifier() {
        double modifier = type.getKickingModifier();
        if (windSpeed != null && windSpeed > 10) {
            modifier *= (1.0 - (windSpeed - 10) * 0.015);
        }
        return Math.max(0.5, modifier);
    }

    public double getInjuryModifier() {
        return fieldCondition.getInjuryMultiplier();
    }

    public double getRushingModifier() {
        double modifier = 1.0;
        if (fieldCondition == FieldCondition.WET || fieldCondition == FieldCondition.MUDDY) {
            modifier *= 0.95;
        } else if (fieldCondition == FieldCondition.SNOWY || fieldCondition == FieldCondition.SLIPPERY) {
            modifier *= 0.85;
        }
        return modifier;
    }

    public double getInjuryRiskModifier() {
        return fieldCondition.getInjuryMultiplier();
    }

    public double getTurnoverModifier() {
        double modifier = 1.0;
        if (type.isPrecipitating()) {
            modifier *= 1.15; // More turnovers in rain/snow
        }
        if (isCold()) {
            modifier *= 1.10; // Cold hands increase fumbles
        }
        if (windSpeed != null && windSpeed > 20) {
            modifier *= 1.10; // High wind increases turnovers
        }
        return modifier;
    }

    public String getDescription() {
        return toString();
    }

    public static WeatherConditions defaultConditions() {
        return builder()
                .type(WeatherType.CLEAR)
                .temperature(65)
                .humidity(55)
                .windSpeed(8)
                .windDirection(WindDirection.WEST)
                .precipitation(PrecipitationType.NONE)
                .visibility(10)
                .lightning(false)
                .build();
    }

    // Classification

    public WeatherSeverity getSeverity() {
        if (type == WeatherType.CLEAR && !isCold() && !isHot()) {
            return WeatherSeverity.IDEAL;
        }
        if (type.isSevere() || (isCold() && feelsLike != null && feelsLike < 0)) {
            return WeatherSeverity.EXTREME;
        }
        if (type.isPrecipitating() && windSpeed != null && windSpeed > 20) {
            return WeatherSeverity.SEVERE;
        }
        if (type.isPrecipitating() || windSpeed != null && windSpeed > 15) {
            return WeatherSeverity.MODERATE;
        }
        if (isCold() || isHot()) {
            return WeatherSeverity.MILD;
        }
        return WeatherSeverity.NORMAL;
    }

    public boolean isExtreme() {
        return getSeverity() == WeatherSeverity.EXTREME;
    }

    public boolean isPrecipitating() {
        return type.isPrecipitating();
    }

    public boolean isCold() {
        return temperature != null && temperature < 32;
    }

    public boolean isHot() {
        return temperature != null && temperature > 90;
    }

    private static Integer calculateFeelsLike(Integer temperature, Integer windSpeed, Integer humidity) {
        if (temperature == null) return null;

        // Wind chill for cold temps
        if (temperature <= 50 && windSpeed != null && windSpeed > 3) {
            return (int) (35.74 + 0.6215 * temperature -
                         35.75 * Math.pow(windSpeed, 0.16) +
                         0.4275 * temperature * Math.pow(windSpeed, 0.16));
        }

        // Heat index for hot temps
        if (temperature >= 80 && humidity != null) {
            double T = temperature;
            double R = humidity;
            return (int) (-42.379 + 2.04901523 * T + 10.14333127 * R
                         - 0.22475541 * T * R - 6.83783e-3 * T * T
                         - 5.481717e-2 * R * R + 1.22874e-3 * T * T * R
                         + 8.5282e-4 * T * R * R - 1.99e-6 * T * T * R * R);
        }

        return temperature;
    }

    // Getters

    public WeatherType getType() {
        return type;
    }

    public Integer getTemperature() {
        return temperature;
    }

    public Integer getHumidity() {
        return humidity;
    }

    public Integer getWindSpeed() {
        return windSpeed;
    }

    public WindDirection getWindDirection() {
        return windDirection;
    }

    public PrecipitationType getPrecipitation() {
        return precipitation;
    }

    public Double getPrecipitationIntensity() {
        return precipitationIntensity;
    }

    public Integer getVisibility() {
        return visibility;
    }

    public Boolean getLightning() {
        return lightning;
    }

    public Integer getFeelsLike() {
        return feelsLike;
    }

    public FieldCondition getFieldCondition() {
        return fieldCondition;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        WeatherConditions that = (WeatherConditions) o;
        return type == that.type &&
               Objects.equals(temperature, that.temperature) &&
               Objects.equals(windSpeed, that.windSpeed);
    }

    @Override
    public int hashCode() {
        return Objects.hash(type, temperature, windSpeed);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append(type.getDescription());
        if (temperature != null) {
            sb.append(", ").append(temperature).append("°F");
            if (feelsLike != null && !feelsLike.equals(temperature)) {
                sb.append(" (feels like ").append(feelsLike).append("°F)");
            }
        }
        if (windSpeed != null && windSpeed > 5) {
            sb.append(", wind ").append(windSpeed).append(" mph");
        }
        return sb.toString();
    }

    public static class Builder {
        private WeatherType type = WeatherType.CLEAR;
        private Integer temperature;
        private Integer humidity;
        private Integer windSpeed;
        private WindDirection windDirection = WindDirection.CALM;
        private PrecipitationType precipitation = PrecipitationType.NONE;
        private Double precipitationIntensity = 0.0;
        private Integer visibility = 10;
        private Boolean lightning = false;
        private Integer feelsLike;
        private FieldCondition fieldCondition;

        public Builder type(WeatherType type) {
            this.type = type;
            return this;
        }

        public Builder temperature(Integer temperature) {
            this.temperature = temperature;
            return this;
        }

        public Builder humidity(Integer humidity) {
            this.humidity = humidity;
            return this;
        }

        public Builder windSpeed(Integer windSpeed) {
            this.windSpeed = windSpeed;
            return this;
        }

        public Builder windDirection(WindDirection windDirection) {
            this.windDirection = windDirection;
            return this;
        }

        public Builder precipitation(PrecipitationType precipitation) {
            this.precipitation = precipitation;
            return this;
        }

        public Builder precipitationIntensity(Double intensity) {
            this.precipitationIntensity = intensity;
            return this;
        }

        public Builder visibility(Integer visibility) {
            this.visibility = visibility;
            return this;
        }

        public Builder lightning(Boolean lightning) {
            this.lightning = lightning;
            return this;
        }

        public Builder feelsLike(Integer feelsLike) {
            this.feelsLike = feelsLike;
            return this;
        }

        public Builder fieldCondition(FieldCondition fieldCondition) {
            this.fieldCondition = fieldCondition;
            return this;
        }

        public WeatherConditions build() {
            return new WeatherConditions(this);
        }
    }
}
