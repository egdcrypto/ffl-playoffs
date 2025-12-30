package com.ffl.playoffs.application.usecase;

import com.ffl.playoffs.application.dto.StadiumDTO;
import com.ffl.playoffs.application.dto.WeatherZoneDTO;
import com.ffl.playoffs.domain.aggregate.Stadium;
import com.ffl.playoffs.domain.entity.WeatherZone;
import com.ffl.playoffs.domain.model.VenueType;
import com.ffl.playoffs.domain.port.StadiumRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Use case for retrieving stadium and weather zone information.
 */
@Service
@RequiredArgsConstructor
public class GetStadiumUseCase {

    private final StadiumRepository stadiumRepository;

    /**
     * Gets a stadium by its unique ID.
     */
    public Optional<StadiumDTO> getById(UUID id) {
        return stadiumRepository.findById(id)
                .map(StadiumDTO::fromDomain);
    }

    /**
     * Gets a stadium by its code.
     */
    public Optional<StadiumDTO> getByCode(String code) {
        return stadiumRepository.findByCode(code)
                .map(StadiumDTO::fromDomain);
    }

    /**
     * Gets the stadium for a specific NFL team.
     */
    public Optional<StadiumDTO> getByTeam(String teamAbbreviation) {
        return stadiumRepository.findByTeam(teamAbbreviation)
                .map(StadiumDTO::fromDomain);
    }

    /**
     * Gets all stadiums.
     */
    public List<StadiumDTO> getAll() {
        return stadiumRepository.findAll().stream()
                .map(StadiumDTO::fromDomain)
                .toList();
    }

    /**
     * Gets all outdoor stadiums (weather-exposed).
     */
    public List<StadiumDTO> getOutdoorStadiums() {
        return stadiumRepository.findOutdoorStadiums().stream()
                .map(StadiumDTO::fromDomain)
                .toList();
    }

    /**
     * Gets all dome stadiums.
     */
    public List<StadiumDTO> getDomeStadiums() {
        return stadiumRepository.findDomeStadiums().stream()
                .map(StadiumDTO::fromDomain)
                .toList();
    }

    /**
     * Gets all stadiums with retractable roofs.
     */
    public List<StadiumDTO> getRetractableRoofStadiums() {
        return stadiumRepository.findRetractableRoofStadiums().stream()
                .map(StadiumDTO::fromDomain)
                .toList();
    }

    /**
     * Gets stadiums by venue type.
     */
    public List<StadiumDTO> getByVenueType(VenueType venueType) {
        return stadiumRepository.findByVenueType(venueType).stream()
                .map(StadiumDTO::fromDomain)
                .toList();
    }

    /**
     * Gets stadiums in a specific weather zone.
     */
    public List<StadiumDTO> getByWeatherZone(String weatherZoneCode) {
        return stadiumRepository.findByWeatherZone(weatherZoneCode).stream()
                .map(StadiumDTO::fromDomain)
                .toList();
    }

    /**
     * Gets a weather zone by code.
     */
    public Optional<WeatherZoneDTO> getWeatherZone(String code) {
        return stadiumRepository.findWeatherZone(code)
                .map(WeatherZoneDTO::fromDomain);
    }

    /**
     * Gets all weather zones.
     */
    public List<WeatherZoneDTO> getAllWeatherZones() {
        return stadiumRepository.findAllWeatherZones().stream()
                .map(WeatherZoneDTO::fromDomain)
                .toList();
    }

    /**
     * Checks if a stadium is at high altitude (affects kicking).
     */
    public boolean isHighAltitude(String stadiumCode) {
        return stadiumRepository.findByCode(stadiumCode)
                .map(Stadium::isHighAltitude)
                .orElse(false);
    }

    /**
     * Gets altitude kicking modifier for a stadium.
     */
    public double getAltitudeKickingModifier(String stadiumCode) {
        return stadiumRepository.findByCode(stadiumCode)
                .map(Stadium::getAltitudeKickingModifier)
                .orElse(1.0);
    }
}
