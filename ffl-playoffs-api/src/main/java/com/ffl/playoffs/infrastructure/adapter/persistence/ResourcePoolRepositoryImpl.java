package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.ResourcePool;
import com.ffl.playoffs.domain.port.ResourcePoolRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.ResourcePoolMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.ResourcePoolMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of ResourcePoolRepository port.
 */
@Repository
public class ResourcePoolRepositoryImpl implements ResourcePoolRepository {

    private final ResourcePoolMongoRepository mongoRepository;
    private final ResourcePoolMapper mapper;

    public ResourcePoolRepositoryImpl(ResourcePoolMongoRepository mongoRepository, ResourcePoolMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<ResourcePool> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<ResourcePool> findByOwnerId(UUID ownerId) {
        return mongoRepository.findByOwnerId(ownerId.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<ResourcePool> findAll() {
        return mongoRepository.findAll()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<ResourcePool> findBySubscriptionTier(String subscriptionTier) {
        return mongoRepository.findBySubscriptionTier(subscriptionTier)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsByOwnerId(UUID ownerId) {
        return mongoRepository.existsByOwnerId(ownerId.toString());
    }

    @Override
    public ResourcePool save(ResourcePool resourcePool) {
        var document = mapper.toDocument(resourcePool);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }
}
