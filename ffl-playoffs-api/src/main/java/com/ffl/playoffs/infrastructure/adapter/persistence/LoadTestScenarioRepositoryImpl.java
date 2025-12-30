package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.LoadTestScenario;
import com.ffl.playoffs.domain.model.loadtest.LoadTestType;
import com.ffl.playoffs.domain.port.LoadTestScenarioRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.LoadTestMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.LoadTestScenarioMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of LoadTestScenarioRepository port.
 */
@Repository
public class LoadTestScenarioRepositoryImpl implements LoadTestScenarioRepository {

    private final LoadTestScenarioMongoRepository mongoRepository;
    private final LoadTestMapper mapper;

    public LoadTestScenarioRepositoryImpl(LoadTestScenarioMongoRepository mongoRepository,
                                          LoadTestMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<LoadTestScenario> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<LoadTestScenario> findByWorldId(UUID worldId) {
        return mongoRepository.findByWorldId(worldId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<LoadTestScenario> findEnabledByWorldId(UUID worldId) {
        return mongoRepository.findByWorldIdAndEnabled(worldId.toString(), true)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<LoadTestScenario> findByTestType(LoadTestType testType) {
        return mongoRepository.findByTestType(testType.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<LoadTestScenario> findByTag(String tag) {
        return mongoRepository.findByTagsContaining(tag)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public LoadTestScenario save(LoadTestScenario scenario) {
        var document = mapper.toDocument(scenario);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public boolean existsById(UUID id) {
        return mongoRepository.existsById(id.toString());
    }
}
