package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.Week;
import com.ffl.playoffs.domain.model.WeekStatus;
import com.ffl.playoffs.domain.port.WeekRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.WeekMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.WeekMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of WeekRepository port
 * Infrastructure layer adapter
 */
@Repository
public class WeekRepositoryImpl implements WeekRepository {

    private final WeekMongoRepository mongoRepository;
    private final WeekMapper mapper;

    public WeekRepositoryImpl(WeekMongoRepository mongoRepository, WeekMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Week save(Week week) {
        var document = mapper.toDocument(week);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public List<Week> saveAll(List<Week> weeks) {
        var documents = weeks.stream()
                .map(mapper::toDocument)
                .collect(Collectors.toList());
        var saved = mongoRepository.saveAll(documents);
        return saved.stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<Week> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<Week> findByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueIdOrderByGameWeekNumberAsc(leagueId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<Week> findByLeagueIdAndGameWeekNumber(UUID leagueId, Integer gameWeekNumber) {
        return mongoRepository.findByLeagueIdAndGameWeekNumber(leagueId.toString(), gameWeekNumber)
                .map(mapper::toDomain);
    }

    @Override
    public Optional<Week> findByLeagueIdAndNflWeekNumber(UUID leagueId, Integer nflWeekNumber) {
        return mongoRepository.findByLeagueIdAndNflWeekNumber(leagueId.toString(), nflWeekNumber)
                .map(mapper::toDomain);
    }

    @Override
    public Optional<Week> findCurrentWeek(UUID leagueId) {
        return mongoRepository.findCurrentWeek(leagueId.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<Week> findByLeagueIdAndStatus(UUID leagueId, WeekStatus status) {
        return mongoRepository.findByLeagueIdAndStatus(leagueId.toString(), status.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsByLeagueId(UUID leagueId) {
        return mongoRepository.existsByLeagueId(leagueId.toString());
    }

    @Override
    public long countByLeagueId(UUID leagueId) {
        return mongoRepository.countByLeagueId(leagueId.toString());
    }

    @Override
    public void delete(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public void deleteByLeagueId(UUID leagueId) {
        mongoRepository.deleteByLeagueId(leagueId.toString());
    }
}
