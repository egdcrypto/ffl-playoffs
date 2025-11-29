package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.League;
import com.ffl.playoffs.domain.port.LeagueRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.LeagueMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.LeagueMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of LeagueRepository port
 * Infrastructure layer adapter
 */
@Repository
public class LeagueRepositoryImpl implements LeagueRepository {

    private final LeagueMongoRepository mongoRepository;
    private final LeagueMapper mapper;

    public LeagueRepositoryImpl(LeagueMongoRepository mongoRepository, LeagueMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<League> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<League> findByCode(String code) {
        return mongoRepository.findByCode(code)
                .map(mapper::toDomain);
    }

    @Override
    public List<League> findAll() {
        return mongoRepository.findAll()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<League> findByAdminId(UUID adminId) {
        return mongoRepository.findByOwnerId(adminId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsByCode(String code) {
        return mongoRepository.existsByCode(code);
    }

    @Override
    public League save(League league) {
        var document = mapper.toDocument(league);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }
}
