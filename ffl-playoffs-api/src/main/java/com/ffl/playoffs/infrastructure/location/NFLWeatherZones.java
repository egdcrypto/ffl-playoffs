package com.ffl.playoffs.infrastructure.location;

import com.ffl.playoffs.domain.entity.WeatherZone;
import com.ffl.playoffs.domain.model.ClimateType;
import com.ffl.playoffs.domain.model.MonthlyWeatherProfile;

import java.util.List;

/**
 * Static NFL weather zone data provider.
 */
public final class NFLWeatherZones {

    private NFLWeatherZones() {
    }

    /**
     * Returns all weather zones used by NFL stadiums.
     */
    public static List<WeatherZone> all() {
        return List.of(
                greatLakes(),
                northeast(),
                midAtlantic(),
                midwest(),
                mountain(),
                desert(),
                pacific(),
                pacificNorthwest(),
                gulfCoast(),
                southeast(),
                southCentral(),
                subtropical(),
                tropical()
        );
    }

    public static WeatherZone greatLakes() {
        WeatherZone zone = WeatherZone.create("Great Lakes", "GREAT_LAKES", ClimateType.CONTINENTAL);
        zone.setAnnualSnowfallInches(50.0);
        zone.setAnnualPrecipitationInches(38.0);

        // December
        zone.setMonthlyProfile(12, MonthlyWeatherProfile.builder()
                .month(12)
                .clearProbability(0.25)
                .cloudyProbability(0.35)
                .snowProbability(0.30)
                .rainProbability(0.05)
                .stormProbability(0.05)
                .averageHigh(32.0)
                .averageLow(18.0)
                .averageWindSpeed(12.0)
                .averageHumidity(70.0)
                .build());

        // January
        zone.setMonthlyProfile(1, MonthlyWeatherProfile.builder()
                .month(1)
                .clearProbability(0.20)
                .cloudyProbability(0.40)
                .snowProbability(0.35)
                .rainProbability(0.02)
                .stormProbability(0.03)
                .averageHigh(28.0)
                .averageLow(14.0)
                .averageWindSpeed(14.0)
                .averageHumidity(72.0)
                .build());

        return zone;
    }

    public static WeatherZone northeast() {
        WeatherZone zone = WeatherZone.create("Northeast", "NORTHEAST", ClimateType.HUMID_CONTINENTAL);
        zone.setAnnualSnowfallInches(35.0);
        zone.setAnnualPrecipitationInches(46.0);

        zone.setMonthlyProfile(12, MonthlyWeatherProfile.builder()
                .month(12)
                .clearProbability(0.30)
                .cloudyProbability(0.35)
                .snowProbability(0.20)
                .rainProbability(0.10)
                .stormProbability(0.05)
                .averageHigh(38.0)
                .averageLow(26.0)
                .averageWindSpeed(10.0)
                .averageHumidity(65.0)
                .build());

        zone.setMonthlyProfile(1, MonthlyWeatherProfile.builder()
                .month(1)
                .clearProbability(0.25)
                .cloudyProbability(0.40)
                .snowProbability(0.25)
                .rainProbability(0.05)
                .stormProbability(0.05)
                .averageHigh(35.0)
                .averageLow(22.0)
                .averageWindSpeed(12.0)
                .averageHumidity(68.0)
                .build());

        return zone;
    }

    public static WeatherZone midAtlantic() {
        WeatherZone zone = WeatherZone.create("Mid-Atlantic", "MID_ATLANTIC", ClimateType.HUMID_SUBTROPICAL);
        zone.setAnnualSnowfallInches(20.0);
        zone.setAnnualPrecipitationInches(42.0);

        zone.setMonthlyProfile(12, MonthlyWeatherProfile.builder()
                .month(12)
                .clearProbability(0.35)
                .cloudyProbability(0.35)
                .snowProbability(0.10)
                .rainProbability(0.15)
                .stormProbability(0.05)
                .averageHigh(44.0)
                .averageLow(30.0)
                .averageWindSpeed(9.0)
                .averageHumidity(60.0)
                .build());

        return zone;
    }

    public static WeatherZone midwest() {
        WeatherZone zone = WeatherZone.create("Midwest", "MIDWEST", ClimateType.CONTINENTAL);
        zone.setAnnualSnowfallInches(25.0);
        zone.setAnnualPrecipitationInches(40.0);

        zone.setMonthlyProfile(12, MonthlyWeatherProfile.builder()
                .month(12)
                .clearProbability(0.30)
                .cloudyProbability(0.35)
                .snowProbability(0.20)
                .rainProbability(0.10)
                .stormProbability(0.05)
                .averageHigh(36.0)
                .averageLow(20.0)
                .averageWindSpeed(11.0)
                .averageHumidity(65.0)
                .build());

        return zone;
    }

    public static WeatherZone mountain() {
        WeatherZone zone = WeatherZone.create("Mountain/High Altitude", "MOUNTAIN", ClimateType.SEMI_ARID);
        zone.setAnnualSnowfallInches(60.0);
        zone.setAnnualPrecipitationInches(15.0);

        zone.setMonthlyProfile(12, MonthlyWeatherProfile.builder()
                .month(12)
                .clearProbability(0.50)
                .cloudyProbability(0.25)
                .snowProbability(0.20)
                .rainProbability(0.02)
                .stormProbability(0.03)
                .averageHigh(43.0)
                .averageLow(18.0)
                .averageWindSpeed(8.0)
                .averageHumidity(40.0)
                .build());

        return zone;
    }

    public static WeatherZone desert() {
        WeatherZone zone = WeatherZone.create("Desert", "DESERT", ClimateType.ARID);
        zone.setAnnualSnowfallInches(0.0);
        zone.setAnnualPrecipitationInches(8.0);

        zone.setMonthlyProfile(12, MonthlyWeatherProfile.builder()
                .month(12)
                .clearProbability(0.70)
                .cloudyProbability(0.20)
                .rainProbability(0.08)
                .snowProbability(0.0)
                .stormProbability(0.02)
                .averageHigh(58.0)
                .averageLow(40.0)
                .averageWindSpeed(6.0)
                .averageHumidity(30.0)
                .build());

        return zone;
    }

    public static WeatherZone pacific() {
        WeatherZone zone = WeatherZone.create("Pacific/Southern California", "PACIFIC", ClimateType.MEDITERRANEAN);
        zone.setAnnualSnowfallInches(0.0);
        zone.setAnnualPrecipitationInches(14.0);

        zone.setMonthlyProfile(12, MonthlyWeatherProfile.builder()
                .month(12)
                .clearProbability(0.55)
                .cloudyProbability(0.25)
                .rainProbability(0.18)
                .snowProbability(0.0)
                .stormProbability(0.02)
                .averageHigh(65.0)
                .averageLow(48.0)
                .averageWindSpeed(7.0)
                .averageHumidity(55.0)
                .build());

        return zone;
    }

    public static WeatherZone pacificNorthwest() {
        WeatherZone zone = WeatherZone.create("Pacific Northwest", "PACIFIC_NW", ClimateType.OCEANIC);
        zone.setAnnualSnowfallInches(5.0);
        zone.setAnnualPrecipitationInches(37.0);

        zone.setMonthlyProfile(12, MonthlyWeatherProfile.builder()
                .month(12)
                .clearProbability(0.20)
                .cloudyProbability(0.40)
                .rainProbability(0.35)
                .snowProbability(0.03)
                .stormProbability(0.02)
                .averageHigh(46.0)
                .averageLow(38.0)
                .averageWindSpeed(9.0)
                .averageHumidity(80.0)
                .build());

        return zone;
    }

    public static WeatherZone gulfCoast() {
        WeatherZone zone = WeatherZone.create("Gulf Coast", "GULF_COAST", ClimateType.HUMID_SUBTROPICAL);
        zone.setAnnualSnowfallInches(0.0);
        zone.setAnnualPrecipitationInches(62.0);

        zone.setMonthlyProfile(12, MonthlyWeatherProfile.builder()
                .month(12)
                .clearProbability(0.45)
                .cloudyProbability(0.30)
                .rainProbability(0.20)
                .snowProbability(0.0)
                .stormProbability(0.05)
                .averageHigh(60.0)
                .averageLow(45.0)
                .averageWindSpeed(8.0)
                .averageHumidity(75.0)
                .build());

        return zone;
    }

    public static WeatherZone southeast() {
        WeatherZone zone = WeatherZone.create("Southeast", "SOUTHEAST", ClimateType.HUMID_SUBTROPICAL);
        zone.setAnnualSnowfallInches(2.0);
        zone.setAnnualPrecipitationInches(50.0);

        zone.setMonthlyProfile(12, MonthlyWeatherProfile.builder()
                .month(12)
                .clearProbability(0.45)
                .cloudyProbability(0.30)
                .rainProbability(0.20)
                .snowProbability(0.02)
                .stormProbability(0.03)
                .averageHigh(52.0)
                .averageLow(35.0)
                .averageWindSpeed(7.0)
                .averageHumidity(65.0)
                .build());

        return zone;
    }

    public static WeatherZone southCentral() {
        WeatherZone zone = WeatherZone.create("South Central/Texas", "SOUTH_CENTRAL", ClimateType.HUMID_SUBTROPICAL);
        zone.setAnnualSnowfallInches(1.0);
        zone.setAnnualPrecipitationInches(36.0);

        zone.setMonthlyProfile(12, MonthlyWeatherProfile.builder()
                .month(12)
                .clearProbability(0.50)
                .cloudyProbability(0.30)
                .rainProbability(0.15)
                .snowProbability(0.02)
                .stormProbability(0.03)
                .averageHigh(55.0)
                .averageLow(38.0)
                .averageWindSpeed(10.0)
                .averageHumidity(60.0)
                .build());

        return zone;
    }

    public static WeatherZone subtropical() {
        WeatherZone zone = WeatherZone.create("Subtropical/Florida", "SUBTROPICAL", ClimateType.HUMID_SUBTROPICAL);
        zone.setAnnualSnowfallInches(0.0);
        zone.setAnnualPrecipitationInches(52.0);

        zone.setMonthlyProfile(12, MonthlyWeatherProfile.builder()
                .month(12)
                .clearProbability(0.55)
                .cloudyProbability(0.25)
                .rainProbability(0.15)
                .snowProbability(0.0)
                .stormProbability(0.05)
                .averageHigh(72.0)
                .averageLow(55.0)
                .averageWindSpeed(8.0)
                .averageHumidity(70.0)
                .build());

        return zone;
    }

    public static WeatherZone tropical() {
        WeatherZone zone = WeatherZone.create("Tropical/South Florida", "TROPICAL", ClimateType.TROPICAL);
        zone.setAnnualSnowfallInches(0.0);
        zone.setAnnualPrecipitationInches(60.0);

        zone.setMonthlyProfile(12, MonthlyWeatherProfile.builder()
                .month(12)
                .clearProbability(0.60)
                .cloudyProbability(0.20)
                .rainProbability(0.15)
                .snowProbability(0.0)
                .stormProbability(0.05)
                .averageHigh(77.0)
                .averageLow(60.0)
                .averageWindSpeed(9.0)
                .averageHumidity(70.0)
                .build());

        return zone;
    }
}
