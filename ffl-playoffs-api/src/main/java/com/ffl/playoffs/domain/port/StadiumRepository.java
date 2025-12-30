package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.Stadium;
import com.ffl.playoffs.domain.entity.WeatherZone;
import com.ffl.playoffs.domain.model.VenueType;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Repository port for Stadium aggregate and WeatherZone entity.
 */
public interface StadiumRepository {

    // Stadium CRUD
    Stadium save(Stadium stadium);

    Optional<Stadium> findById(UUID id);

    Optional<Stadium> findByCode(String code);

    Optional<Stadium> findByTeam(String teamAbbreviation);

    List<Stadium> findAll();

    void delete(UUID id);

    // Stadium queries
    List<Stadium> findByVenueType(VenueType type);

    List<Stadium> findByWeatherZone(String weatherZoneCode);

    List<Stadium> findOutdoorStadiums();

    List<Stadium> findDomeStadiums();

    List<Stadium> findRetractableRoofStadiums();

    /**
     * Finds stadiums that share the same venue (e.g., MetLife for NYJ/NYG).
     */
    List<Stadium> findBySharedVenue(String stadiumCode);

    // Weather zone operations
    WeatherZone saveWeatherZone(WeatherZone weatherZone);

    Optional<WeatherZone> findWeatherZone(String code);

    List<WeatherZone> findAllWeatherZones();

    void deleteWeatherZone(String code);

    // Bulk operations
    List<Stadium> saveAll(List<Stadium> stadiums);

    List<WeatherZone> saveAllWeatherZones(List<WeatherZone> weatherZones);

    /**
     * Checks if a stadium exists for the given team.
     */
    boolean existsByTeam(String teamAbbreviation);

    /**
     * Counts total stadiums.
     */
    long count();
}
