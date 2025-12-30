package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.World;
import com.ffl.playoffs.domain.model.world.WorldStatus;
import com.ffl.playoffs.domain.port.WorldRepository;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.WorldDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.mapper.WorldMapper;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoWorldRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of WorldRepository port
 * Adapter in hexagonal architecture
 */
@Slf4j
@Repository
@RequiredArgsConstructor
public class WorldRepositoryImpl implements WorldRepository {

    private final MongoWorldRepository mongoRepository;
    private final WorldMapper mapper;

    @Override
    public Optional<World> findById(UUID id) {
        log.debug("Finding world by ID: {}", id);
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<World> findByName(String name) {
        log.debug("Finding world by name: {}", name);
        return mongoRepository.findByName(name)
                .map(mapper::toDomain);
    }

    @Override
    public List<World> findAll() {
        log.debug("Finding all worlds");
        return mongoRepository.findAll().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<World> findByStatus(WorldStatus status) {
        log.debug("Finding worlds by status: {}", status);
        return mongoRepository.findByStatus(status.name()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<World> findBySeason(Integer season) {
        log.debug("Finding worlds by season: {}", season);
        return mongoRepository.findBySeason(season).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<World> findBySeasonAndStatus(Integer season, WorldStatus status) {
        log.debug("Finding worlds by season {} and status {}", season, status);
        return mongoRepository.findBySeasonAndStatus(season, status.name()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<World> findByCreatedBy(UUID userId) {
        log.debug("Finding worlds created by: {}", userId);
        return mongoRepository.findByCreatedBy(userId.toString()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<World> findActiveWorlds() {
        log.debug("Finding active worlds");
        return findByStatus(WorldStatus.ACTIVE);
    }

    @Override
    public Optional<World> findByLeagueId(UUID leagueId) {
        log.debug("Finding world containing league: {}", leagueId);
        return mongoRepository.findByLeagueIdsContaining(leagueId.toString())
                .map(mapper::toDomain);
    }

    @Override
    public boolean existsByName(String name) {
        return mongoRepository.existsByName(name);
    }

    @Override
    public boolean existsBySeason(Integer season) {
        return mongoRepository.existsBySeason(season);
    }

    @Override
    public World save(World world) {
        log.debug("Saving world: {}", world.getId());
        WorldDocument document = mapper.toDocument(world);
        WorldDocument saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID id) {
        log.debug("Deleting world: {}", id);
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public long countByStatus(WorldStatus status) {
        return mongoRepository.countByStatus(status.name());
    }

    @Override
    public long count() {
        return mongoRepository.count();
    }
}
