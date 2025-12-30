package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.EraProfile;
import com.ffl.playoffs.domain.port.EraProfileRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.EraProfileMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.EraProfileMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of EraProfileRepository port.
 * Infrastructure layer adapter for era profile persistence.
 */
@Repository
public class EraProfileRepositoryImpl implements EraProfileRepository {

    private final EraProfileMongoRepository mongoRepository;
    private final EraProfileMapper mapper;

    public EraProfileRepositoryImpl(EraProfileMongoRepository mongoRepository, EraProfileMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<EraProfile> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<EraProfile> findByWorldId(UUID worldId) {
        return mongoRepository.findByWorldId(worldId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<EraProfile> findAll() {
        return mongoRepository.findAll()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<EraProfile> findByStatus(EraProfile.EraStatus status) {
        return mongoRepository.findByStatus(status.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<EraProfile> findByCreatedBy(UUID userId) {
        return mongoRepository.findByCreatedBy(userId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<EraProfile> findLockedByWorldId(UUID worldId) {
        return mongoRepository.findByWorldIdAndIsLocked(worldId.toString(), true)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsById(UUID id) {
        return mongoRepository.existsById(id.toString());
    }

    @Override
    public EraProfile save(EraProfile eraProfile) {
        var document = mapper.toDocument(eraProfile);
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

    @Override
    public long countByWorldId(UUID worldId) {
        return mongoRepository.countByWorldId(worldId.toString());
    }
}
