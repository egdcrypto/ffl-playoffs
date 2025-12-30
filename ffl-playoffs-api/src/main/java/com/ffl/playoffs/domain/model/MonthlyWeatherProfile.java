package com.ffl.playoffs.domain.model;

import java.util.Random;

/**
 * Value object representing weather probabilities and characteristics for a specific month.
 */
public class MonthlyWeatherProfile {

    private final Integer month;  // 1-12

    // Condition probabilities (should sum to ~1.0)
    private final Double clearProbability;
    private final Double cloudyProbability;
    private final Double rainProbability;
    private final Double snowProbability;
    private final Double stormProbability;

    // Wind characteristics
    private final Double calmWindProbability;
    private final Double moderateWindProbability;
    private final Double highWindProbability;
    private final Double averageWindSpeed;

    // Temperature
    private final Double averageHigh;
    private final Double averageLow;
    private final Double recordHigh;
    private final Double recordLow;

    // Humidity
    private final Double averageHumidity;

    private MonthlyWeatherProfile(Builder builder) {
        this.month = builder.month;
        this.clearProbability = builder.clearProbability;
        this.cloudyProbability = builder.cloudyProbability;
        this.rainProbability = builder.rainProbability;
        this.snowProbability = builder.snowProbability;
        this.stormProbability = builder.stormProbability;
        this.calmWindProbability = builder.calmWindProbability;
        this.moderateWindProbability = builder.moderateWindProbability;
        this.highWindProbability = builder.highWindProbability;
        this.averageWindSpeed = builder.averageWindSpeed;
        this.averageHigh = builder.averageHigh;
        this.averageLow = builder.averageLow;
        this.recordHigh = builder.recordHigh;
        this.recordLow = builder.recordLow;
        this.averageHumidity = builder.averageHumidity;
    }

    public static Builder builder() {
        return new Builder();
    }

    /**
     * Generates weather conditions based on this profile.
     */
    public WeatherConditions generateWeather(Random random) {
        WeatherType type = selectWeatherType(random);
        int temperature = generateTemperature(random);
        int windSpeed = generateWindSpeed(random);

        return WeatherConditions.builder()
                .type(type)
                .temperature(temperature)
                .humidity(averageHumidity != null ? averageHumidity.intValue() : 60)
                .windSpeed(windSpeed)
                .windDirection(WindDirection.fromDegrees(random.nextInt(360)))
                .precipitation(getPrecipitationType(type))
                .precipitationIntensity(type.isPrecipitating() ? 0.3 + random.nextDouble() * 0.4 : 0.0)
                .visibility(getVisibility(type))
                .lightning(type == WeatherType.THUNDERSTORM)
                .build();
    }

    private WeatherType selectWeatherType(Random random) {
        double roll = random.nextDouble();
        double cumulative = 0.0;

        if (stormProbability != null) {
            cumulative += stormProbability;
            if (roll < cumulative) return WeatherType.THUNDERSTORM;
        }

        if (snowProbability != null) {
            cumulative += snowProbability;
            if (roll < cumulative) return WeatherType.SNOW;
        }

        if (rainProbability != null) {
            cumulative += rainProbability;
            if (roll < cumulative) return WeatherType.RAIN;
        }

        if (cloudyProbability != null) {
            cumulative += cloudyProbability;
            if (roll < cumulative) return WeatherType.CLOUDY;
        }

        return WeatherType.CLEAR;
    }

    private int generateTemperature(Random random) {
        double high = averageHigh != null ? averageHigh : 70;
        double low = averageLow != null ? averageLow : 50;
        double average = (high + low) / 2;
        double variance = (high - low) / 2;
        return (int) (average + (random.nextGaussian() * variance * 0.5));
    }

    private int generateWindSpeed(Random random) {
        double avg = averageWindSpeed != null ? averageWindSpeed : 8;
        double roll = random.nextDouble();

        if (highWindProbability != null && roll > 1 - highWindProbability) {
            return (int) (avg * 2 + random.nextDouble() * 10);
        } else if (calmWindProbability != null && roll < calmWindProbability) {
            return (int) (random.nextDouble() * 5);
        }
        return (int) (avg + random.nextGaussian() * 3);
    }

    private PrecipitationType getPrecipitationType(WeatherType type) {
        return switch (type) {
            case LIGHT_RAIN -> PrecipitationType.LIGHT_RAIN;
            case RAIN -> PrecipitationType.MODERATE_RAIN;
            case HEAVY_RAIN, THUNDERSTORM -> PrecipitationType.HEAVY_RAIN;
            case LIGHT_SNOW -> PrecipitationType.LIGHT_SNOW;
            case SNOW -> PrecipitationType.MODERATE_SNOW;
            case HEAVY_SNOW -> PrecipitationType.HEAVY_SNOW;
            case SLEET -> PrecipitationType.SLEET;
            default -> PrecipitationType.NONE;
        };
    }

    private int getVisibility(WeatherType type) {
        return switch (type) {
            case HEAVY_RAIN, HEAVY_SNOW -> 1;
            case THUNDERSTORM, SNOW -> 2;
            case RAIN, FOG -> 3;
            case LIGHT_RAIN, LIGHT_SNOW -> 5;
            default -> 10;
        };
    }

    // Getters
    public Integer getMonth() {
        return month;
    }

    public Double getClearProbability() {
        return clearProbability;
    }

    public Double getCloudyProbability() {
        return cloudyProbability;
    }

    public Double getRainProbability() {
        return rainProbability;
    }

    public Double getSnowProbability() {
        return snowProbability;
    }

    public Double getStormProbability() {
        return stormProbability;
    }

    public Double getAverageWindSpeed() {
        return averageWindSpeed;
    }

    public Double getAverageHigh() {
        return averageHigh;
    }

    public Double getAverageLow() {
        return averageLow;
    }

    public Double getAverageHumidity() {
        return averageHumidity;
    }

    public static class Builder {
        private Integer month;
        private Double clearProbability = 0.4;
        private Double cloudyProbability = 0.3;
        private Double rainProbability = 0.2;
        private Double snowProbability = 0.0;
        private Double stormProbability = 0.1;
        private Double calmWindProbability = 0.3;
        private Double moderateWindProbability = 0.5;
        private Double highWindProbability = 0.2;
        private Double averageWindSpeed = 8.0;
        private Double averageHigh = 70.0;
        private Double averageLow = 50.0;
        private Double recordHigh;
        private Double recordLow;
        private Double averageHumidity = 60.0;

        public Builder month(Integer month) {
            this.month = month;
            return this;
        }

        public Builder clearProbability(Double prob) {
            this.clearProbability = prob;
            return this;
        }

        public Builder cloudyProbability(Double prob) {
            this.cloudyProbability = prob;
            return this;
        }

        public Builder rainProbability(Double prob) {
            this.rainProbability = prob;
            return this;
        }

        public Builder snowProbability(Double prob) {
            this.snowProbability = prob;
            return this;
        }

        public Builder stormProbability(Double prob) {
            this.stormProbability = prob;
            return this;
        }

        public Builder averageWindSpeed(Double speed) {
            this.averageWindSpeed = speed;
            return this;
        }

        public Builder calmWindProbability(Double prob) {
            this.calmWindProbability = prob;
            return this;
        }

        public Builder moderateWindProbability(Double prob) {
            this.moderateWindProbability = prob;
            return this;
        }

        public Builder highWindProbability(Double prob) {
            this.highWindProbability = prob;
            return this;
        }

        public Builder averageHigh(Double temp) {
            this.averageHigh = temp;
            return this;
        }

        public Builder averageLow(Double temp) {
            this.averageLow = temp;
            return this;
        }

        public Builder recordHigh(Double temp) {
            this.recordHigh = temp;
            return this;
        }

        public Builder recordLow(Double temp) {
            this.recordLow = temp;
            return this;
        }

        public Builder averageHumidity(Double humidity) {
            this.averageHumidity = humidity;
            return this;
        }

        public MonthlyWeatherProfile build() {
            return new MonthlyWeatherProfile(this);
        }
    }
}
