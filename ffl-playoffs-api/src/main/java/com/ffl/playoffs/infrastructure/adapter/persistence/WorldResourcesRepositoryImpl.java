package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.WorldResources;
import com.ffl.playoffs.domain.port.WorldResourcesRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.WorldResourcesMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.WorldResourcesMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of WorldResourcesRepository port.
 */
@Repository
public class WorldResourcesRepositoryImpl implements WorldResourcesRepository {

    private final WorldResourcesMongoRepository mongoRepository;
    private final WorldResourcesMapper mapper;

    public WorldResourcesRepositoryImpl(WorldResourcesMongoRepository mongoRepository, WorldResourcesMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<WorldResources> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<WorldResources> findByWorldId(UUID worldId) {
        return mongoRepository.findByWorldId(worldId.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<WorldResources> findByOwnerId(UUID ownerId) {
        return mongoRepository.findByOwnerId(ownerId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<WorldResources> findAll() {
        return mongoRepository.findAll()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsByWorldId(UUID worldId) {
        return mongoRepository.existsByWorldId(worldId.toString());
    }

    @Override
    public WorldResources save(WorldResources worldResources) {
        var document = mapper.toDocument(worldResources);
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
