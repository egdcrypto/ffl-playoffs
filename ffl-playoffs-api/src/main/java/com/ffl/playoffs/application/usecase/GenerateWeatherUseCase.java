package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.StadiumDTO;
import com.ffl.playoffs.application.dto.WeatherConditionsDTO;
import com.ffl.playoffs.domain.aggregate.Stadium;
import com.ffl.playoffs.domain.model.MonthlyWeatherProfile;
import com.ffl.playoffs.domain.model.WeatherConditions;
import com.ffl.playoffs.domain.port.StadiumRepository;
import com.ffl.playoffs.domain.port.WeatherService;
import com.ffl.playoffs.domain.port.WeatherService.WeatherStatModifiers;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.Optional;
import java.util.Random;

/**
 * Use case for generating and retrieving weather conditions.
 */
@Service
@RequiredArgsConstructor
public class GenerateWeatherUseCase {

    private final StadiumRepository stadiumRepository;
    private final WeatherService weatherService;

    /**
     * Generates weather conditions for a game at a stadium.
     *
     * @param stadiumCode The stadium code
     * @param month       The month (1-12)
     * @param seed        Optional random seed for reproducible results
     * @return Weather conditions DTO
     */
    public Optional<WeatherConditionsDTO> generateGameWeather(
            String stadiumCode,
            Integer month,
            Long seed
    ) {
        Optional<Stadium> stadiumOpt = stadiumRepository.findByCode(stadiumCode);
        if (stadiumOpt.isEmpty()) {
            return Optional.empty();
        }

        Stadium stadium = stadiumOpt.get();
        Random random = seed != null ? new Random(seed) : new Random();

        WeatherConditions conditions = weatherService.generateGameWeather(stadium, month, random);
        return Optional.of(WeatherConditionsDTO.fromDomain(conditions));
    }

    /**
     * Generates weather for a team's home stadium.
     */
    public Optional<WeatherConditionsDTO> generateWeatherForTeam(
            String teamAbbreviation,
            Integer month
    ) {
        Optional<Stadium> stadiumOpt = stadiumRepository.findByTeam(teamAbbreviation);
        if (stadiumOpt.isEmpty()) {
            return Optional.empty();
        }

        Stadium stadium = stadiumOpt.get();
        WeatherConditions conditions = weatherService.generateGameWeather(stadium, month, new Random());
        return Optional.of(WeatherConditionsDTO.fromDomain(conditions));
    }

    /**
     * Gets historical weather for a specific date.
     */
    public Optional<WeatherConditionsDTO> getHistoricalWeather(
            String stadiumCode,
            LocalDate date
    ) {
        Optional<Stadium> stadiumOpt = stadiumRepository.findByCode(stadiumCode);
        if (stadiumOpt.isEmpty()) {
            return Optional.empty();
        }

        WeatherConditions conditions = weatherService.getHistoricalWeather(stadiumOpt.get(), date);
        return Optional.of(WeatherConditionsDTO.fromDomain(conditions));
    }

    /**
     * Gets stat modifiers for weather conditions at a stadium.
     */
    public WeatherStatModifiers getStatModifiers(
            String stadiumCode,
            Integer month
    ) {
        Optional<Stadium> stadiumOpt = stadiumRepository.findByCode(stadiumCode);
        if (stadiumOpt.isEmpty()) {
            return WeatherStatModifiers.neutral();
        }

        Stadium stadium = stadiumOpt.get();
        WeatherConditions conditions = weatherService.generateGameWeather(stadium, month, new Random());
        return weatherService.calculateWeatherModifiers(conditions, stadium.getVenueType());
    }

    /**
     * Checks if weather could potentially postpone a game.
     */
    public boolean isGameThreateningWeather(String stadiumCode, Integer month) {
        Optional<Stadium> stadiumOpt = stadiumRepository.findByCode(stadiumCode);
        if (stadiumOpt.isEmpty()) {
            return false;
        }

        Stadium stadium = stadiumOpt.get();
        if (stadium.isDome()) {
            return false; // Domes are never weather-affected
        }

        WeatherConditions conditions = weatherService.generateGameWeather(stadium, month, new Random());
        return weatherService.isGameThreateningWeather(conditions);
    }

    /**
     * Gets ideal (dome-like) weather conditions for reference.
     */
    public WeatherConditionsDTO getIdealConditions() {
        return WeatherConditionsDTO.fromDomain(WeatherConditions.ideal());
    }
}
