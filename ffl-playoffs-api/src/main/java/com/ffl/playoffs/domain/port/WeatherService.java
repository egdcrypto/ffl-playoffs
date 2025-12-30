package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.Stadium;
import com.ffl.playoffs.domain.model.MonthlyWeatherProfile;
import com.ffl.playoffs.domain.model.VenueType;
import com.ffl.playoffs.domain.model.WeatherConditions;

import java.time.LocalDate;
import java.util.Random;

/**
 * Service port for weather generation and calculations.
 */
public interface WeatherService {

    /**
     * Generates weather conditions for a game at a stadium.
     *
     * @param stadium The stadium where the game is played
     * @param month   The month (1-12)
     * @param random  Random source for consistent simulation
     * @return Generated weather conditions
     */
    WeatherConditions generateGameWeather(
            Stadium stadium,
            Integer month,
            Random random
    );

    /**
     * Gets historical weather for a specific date at a stadium.
     *
     * @param stadium The stadium location
     * @param date    The date for weather lookup
     * @return Historical weather conditions
     */
    WeatherConditions getHistoricalWeather(
            Stadium stadium,
            LocalDate date
    );

    /**
     * Gets weather profile for a stadium and month.
     *
     * @param stadium The stadium
     * @param month   The month (1-12)
     * @return Monthly weather profile with probabilities
     */
    MonthlyWeatherProfile getWeatherProfile(
            Stadium stadium,
            Integer month
    );

    /**
     * Calculates stat modifiers based on weather conditions.
     *
     * @param conditions Weather conditions
     * @param venueType  Type of venue (affects exposure)
     * @return Modifier values for various stat categories
     */
    WeatherStatModifiers calculateWeatherModifiers(
            WeatherConditions conditions,
            VenueType venueType
    );

    /**
     * Checks if weather is severe enough to potentially postpone a game.
     *
     * @param conditions The weather conditions
     * @return true if conditions are potentially game-affecting
     */
    boolean isGameThreateningWeather(WeatherConditions conditions);

    /**
     * Record holding stat modifiers from weather effects.
     */
    record WeatherStatModifiers(
            double passingModifier,
            double rushingModifier,
            double kickingModifier,
            double injuryRiskModifier,
            double turnoversModifier
    ) {
        public static WeatherStatModifiers neutral() {
            return new WeatherStatModifiers(1.0, 1.0, 1.0, 1.0, 1.0);
        }

        public static WeatherStatModifiers forWeather(WeatherConditions conditions) {
            return new WeatherStatModifiers(
                    conditions.getPassingModifier(),
                    conditions.getRushingModifier(),
                    conditions.getKickingModifier(),
                    conditions.getInjuryRiskModifier(),
                    conditions.getTurnoverModifier()
            );
        }
    }
}
