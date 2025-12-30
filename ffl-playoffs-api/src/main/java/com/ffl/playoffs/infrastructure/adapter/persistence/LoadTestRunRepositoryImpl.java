package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.LoadTestRun;
import com.ffl.playoffs.domain.model.loadtest.LoadTestStatus;
import com.ffl.playoffs.domain.port.LoadTestRunRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.LoadTestMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.LoadTestRunMongoRepository;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of LoadTestRunRepository port.
 */
@Repository
public class LoadTestRunRepositoryImpl implements LoadTestRunRepository {

    private final LoadTestRunMongoRepository mongoRepository;
    private final LoadTestMapper mapper;

    public LoadTestRunRepositoryImpl(LoadTestRunMongoRepository mongoRepository,
                                     LoadTestMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<LoadTestRun> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<LoadTestRun> findByScenarioId(UUID scenarioId) {
        return mongoRepository.findByScenarioId(scenarioId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<LoadTestRun> findByWorldId(UUID worldId) {
        return mongoRepository.findByWorldId(worldId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<LoadTestRun> findByStatus(LoadTestStatus status) {
        return mongoRepository.findByStatus(status.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<LoadTestRun> findRunningByWorldId(UUID worldId) {
        return mongoRepository.findByWorldIdAndStatus(worldId.toString(), LoadTestStatus.RUNNING.name())
                .map(mapper::toDomain);
    }

    @Override
    public List<LoadTestRun> findRecentByWorldId(UUID worldId, int limit) {
        return mongoRepository.findByWorldIdOrderByCreatedAtDesc(worldId.toString(), PageRequest.of(0, limit))
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<LoadTestRun> findByWorldIdAndTimeRange(UUID worldId, Instant startTime, Instant endTime) {
        return mongoRepository.findByWorldIdAndStartTimeBetween(worldId.toString(), startTime, endTime)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public LoadTestRun save(LoadTestRun run) {
        var document = mapper.toDocument(run);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public void deleteByWorldIdOlderThan(UUID worldId, Instant cutoffTime) {
        mongoRepository.deleteByWorldIdAndCreatedAtBefore(worldId.toString(), cutoffTime);
    }
}
