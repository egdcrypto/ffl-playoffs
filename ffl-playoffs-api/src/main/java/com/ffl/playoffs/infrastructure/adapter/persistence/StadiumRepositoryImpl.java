package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.Stadium;
import com.ffl.playoffs.domain.entity.WeatherZone;
import com.ffl.playoffs.domain.model.VenueType;
import com.ffl.playoffs.domain.port.StadiumRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.StadiumDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WeatherZoneDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.StadiumMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.WeatherZoneMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.StadiumMongoRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.WeatherZoneMongoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of StadiumRepository.
 */
@Repository
@RequiredArgsConstructor
public class StadiumRepositoryImpl implements StadiumRepository {

    private final StadiumMongoRepository stadiumMongoRepository;
    private final WeatherZoneMongoRepository weatherZoneMongoRepository;
    private final StadiumMapper stadiumMapper;
    private final WeatherZoneMapper weatherZoneMapper;

    @Override
    public Stadium save(Stadium stadium) {
        stadium.setUpdatedAt(LocalDateTime.now());
        StadiumDocument document = stadiumMapper.toDocument(stadium);
        StadiumDocument saved = stadiumMongoRepository.save(document);
        return stadiumMapper.toDomain(saved);
    }

    @Override
    public Optional<Stadium> findById(UUID id) {
        return stadiumMongoRepository.findById(id.toString())
                .map(stadiumMapper::toDomain);
    }

    @Override
    public Optional<Stadium> findByCode(String code) {
        return stadiumMongoRepository.findByCode(code)
                .map(stadiumMapper::toDomain);
    }

    @Override
    public Optional<Stadium> findByTeam(String teamAbbreviation) {
        // First try primary team
        Optional<Stadium> primary = stadiumMongoRepository.findByPrimaryTeamAbbreviation(teamAbbreviation)
                .map(stadiumMapper::toDomain);
        if (primary.isPresent()) {
            return primary;
        }

        // Then check tenant teams
        List<StadiumDocument> tenantStadiums = stadiumMongoRepository.findByTenantTeamsContaining(teamAbbreviation);
        return tenantStadiums.stream()
                .findFirst()
                .map(stadiumMapper::toDomain);
    }

    @Override
    public List<Stadium> findAll() {
        return stadiumMongoRepository.findAll().stream()
                .map(stadiumMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public void delete(UUID id) {
        stadiumMongoRepository.deleteById(id.toString());
    }

    @Override
    public List<Stadium> findByVenueType(VenueType type) {
        return stadiumMongoRepository.findByVenueType(type.name()).stream()
                .map(stadiumMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Stadium> findByWeatherZone(String weatherZoneCode) {
        return stadiumMongoRepository.findByWeatherZoneCode(weatherZoneCode).stream()
                .map(stadiumMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Stadium> findOutdoorStadiums() {
        return findByVenueType(VenueType.OUTDOOR);
    }

    @Override
    public List<Stadium> findDomeStadiums() {
        return findByVenueType(VenueType.DOME);
    }

    @Override
    public List<Stadium> findRetractableRoofStadiums() {
        return findByVenueType(VenueType.RETRACTABLE);
    }

    @Override
    public List<Stadium> findBySharedVenue(String stadiumCode) {
        // Get the stadium, then find all stadiums with the same code
        // (For shared venues like MetLife, both teams would reference the same stadium)
        Optional<StadiumDocument> stadium = stadiumMongoRepository.findByCode(stadiumCode);
        if (stadium.isEmpty()) {
            return List.of();
        }
        return List.of(stadiumMapper.toDomain(stadium.get()));
    }

    // Weather Zone operations

    @Override
    public WeatherZone saveWeatherZone(WeatherZone weatherZone) {
        WeatherZoneDocument document = weatherZoneMapper.toDocument(weatherZone);
        WeatherZoneDocument saved = weatherZoneMongoRepository.save(document);
        return weatherZoneMapper.toDomain(saved);
    }

    @Override
    public Optional<WeatherZone> findWeatherZone(String code) {
        return weatherZoneMongoRepository.findByCode(code)
                .map(weatherZoneMapper::toDomain);
    }

    @Override
    public List<WeatherZone> findAllWeatherZones() {
        return weatherZoneMongoRepository.findAll().stream()
                .map(weatherZoneMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public void deleteWeatherZone(String code) {
        weatherZoneMongoRepository.deleteByCode(code);
    }

    // Bulk operations

    @Override
    public List<Stadium> saveAll(List<Stadium> stadiums) {
        List<StadiumDocument> documents = stadiums.stream()
                .peek(s -> s.setUpdatedAt(LocalDateTime.now()))
                .map(stadiumMapper::toDocument)
                .collect(Collectors.toList());
        List<StadiumDocument> saved = stadiumMongoRepository.saveAll(documents);
        return saved.stream()
                .map(stadiumMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WeatherZone> saveAllWeatherZones(List<WeatherZone> weatherZones) {
        List<WeatherZoneDocument> documents = weatherZones.stream()
                .map(weatherZoneMapper::toDocument)
                .collect(Collectors.toList());
        List<WeatherZoneDocument> saved = weatherZoneMongoRepository.saveAll(documents);
        return saved.stream()
                .map(weatherZoneMapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsByTeam(String teamAbbreviation) {
        return stadiumMongoRepository.existsByPrimaryTeamAbbreviation(teamAbbreviation);
    }

    @Override
    public long count() {
        return stadiumMongoRepository.count();
    }
}
