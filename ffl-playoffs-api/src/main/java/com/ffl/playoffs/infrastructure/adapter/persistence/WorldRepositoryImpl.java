package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.port.WorldRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.WorldMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.WorldMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of WorldRepository port.
 * Infrastructure layer adapter for world persistence.
 */
@Repository
public class WorldRepositoryImpl implements WorldRepository {

    private final WorldMongoRepository mongoRepository;
    private final WorldMapper mapper;

    public WorldRepositoryImpl(WorldMongoRepository mongoRepository, WorldMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<World> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<World> findAll() {
        return mongoRepository.findAll()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<World> findByOwnerId(UUID ownerId) {
        return mongoRepository.findByOwnerId(ownerId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<World> findByStatus(World.WorldStatus status) {
        return mongoRepository.findByStatus(status.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<World> findPublicWorlds() {
        return mongoRepository.findByIsPublic(true)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<World> findDeployedWorlds() {
        return mongoRepository.findByIsDeployed(true)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsById(UUID id) {
        return mongoRepository.existsById(id.toString());
    }

    @Override
    public World save(World world) {
        var document = mapper.toDocument(world);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public long countByOwnerId(UUID ownerId) {
        return mongoRepository.countByOwnerId(ownerId.toString());
    }
}
