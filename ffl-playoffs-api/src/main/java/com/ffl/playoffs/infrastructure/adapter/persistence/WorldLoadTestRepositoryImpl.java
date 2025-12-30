package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.WorldLoadTest;
import com.ffl.playoffs.domain.port.WorldLoadTestRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.LoadTestMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.WorldLoadTestMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of WorldLoadTestRepository port.
 */
@Repository
public class WorldLoadTestRepositoryImpl implements WorldLoadTestRepository {

    private final WorldLoadTestMongoRepository mongoRepository;
    private final LoadTestMapper mapper;

    public WorldLoadTestRepositoryImpl(WorldLoadTestMongoRepository mongoRepository,
                                       LoadTestMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<WorldLoadTest> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<WorldLoadTest> findByWorldId(UUID worldId) {
        return mongoRepository.findByWorldId(worldId.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<WorldLoadTest> findAll() {
        return mongoRepository.findAll()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WorldLoadTest> findByStatus(WorldLoadTest.WorldLoadTestStatus status) {
        return mongoRepository.findByOverallStatus(status.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsByWorldId(UUID worldId) {
        return mongoRepository.existsByWorldId(worldId.toString());
    }

    @Override
    public WorldLoadTest save(WorldLoadTest worldLoadTest) {
        var document = mapper.toDocument(worldLoadTest);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public void deleteByWorldId(UUID worldId) {
        mongoRepository.deleteByWorldId(worldId.toString());
    }
}
