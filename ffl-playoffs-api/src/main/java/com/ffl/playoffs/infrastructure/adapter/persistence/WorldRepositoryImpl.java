package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.world.World;
import com.ffl.playoffs.domain.model.world.WorldStatus;
import com.ffl.playoffs.domain.model.world.WorldVisibility;
import com.ffl.playoffs.domain.port.WorldRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.WorldDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.WorldMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.WorldMongoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of WorldRepository.
 */
@Repository
@RequiredArgsConstructor
public class WorldRepositoryImpl implements WorldRepository {

    private final WorldMongoRepository mongoRepository;
    private final WorldMapper mapper;

    @Override
    public World save(World world) {
        WorldDocument doc = mapper.toDocument(world);
        WorldDocument saved = mongoRepository.save(doc);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<World> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<World> findByCode(String code) {
        return mongoRepository.findByCode(code)
                .map(mapper::toDomain);
    }

    @Override
    public List<World> findByPrimaryOwnerId(UUID primaryOwnerId) {
        return mongoRepository.findByPrimaryOwnerId(primaryOwnerId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<World> findByStatus(WorldStatus status) {
        return mongoRepository.findByStatus(status.getCode())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<World> findActiveWorlds() {
        return findByStatus(WorldStatus.ACTIVE);
    }

    @Override
    public List<World> findPubliclyVisibleWorlds() {
        return mongoRepository.findPubliclyVisibleWorlds()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<World> findByVisibility(WorldVisibility visibility) {
        return mongoRepository.findByVisibility(visibility.getCode())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsByCode(String code) {
        return mongoRepository.existsByCode(code);
    }

    @Override
    public boolean existsById(UUID id) {
        return mongoRepository.existsById(id.toString());
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public long countByPrimaryOwnerId(UUID primaryOwnerId) {
        return mongoRepository.countByPrimaryOwnerId(primaryOwnerId.toString());
    }

    @Override
    public long countActiveWorlds() {
        return mongoRepository.countByStatus(WorldStatus.ACTIVE.getCode());
    }

    @Override
    public List<World> searchByName(String namePart) {
        return mongoRepository.searchByNameContaining(namePart)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<World> findWorldsWithMemberCapacity() {
        return mongoRepository.findWorldsWithMemberCapacity()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }
}
