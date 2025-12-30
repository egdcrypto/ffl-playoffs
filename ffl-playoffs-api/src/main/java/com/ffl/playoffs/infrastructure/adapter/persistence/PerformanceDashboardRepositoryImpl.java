package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.PerformanceDashboard;
import com.ffl.playoffs.domain.port.PerformanceDashboardRepository;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.PerformanceDashboardDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.mapper.PerformanceDashboardMapper;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoPerformanceDashboardRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of PerformanceDashboardRepository.
 */
@Repository
@RequiredArgsConstructor
public class PerformanceDashboardRepositoryImpl implements PerformanceDashboardRepository {

    private final MongoPerformanceDashboardRepository mongoRepository;
    private final PerformanceDashboardMapper mapper;

    @Override
    public PerformanceDashboard save(PerformanceDashboard dashboard) {
        PerformanceDashboardDocument doc = mapper.toDocument(dashboard);
        PerformanceDashboardDocument saved = mongoRepository.save(doc);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<PerformanceDashboard> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<PerformanceDashboard> findByOwnerId(UUID ownerId) {
        return mongoRepository.findByOwnerId(ownerId.toString()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<PerformanceDashboard> findDefaultByOwnerId(UUID ownerId) {
        return mongoRepository.findByOwnerIdAndIsDefaultTrue(ownerId.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<PerformanceDashboard> findAllShared() {
        return mongoRepository.findByIsSharedTrue().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<PerformanceDashboard> findAccessibleByUserId(UUID userId) {
        return mongoRepository.findAccessibleByUserId(userId.toString()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsByNameAndOwnerId(String name, UUID ownerId) {
        return mongoRepository.existsByNameAndOwnerId(name, ownerId.toString());
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }
}
