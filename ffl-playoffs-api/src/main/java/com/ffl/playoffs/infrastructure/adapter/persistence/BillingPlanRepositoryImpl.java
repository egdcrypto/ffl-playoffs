package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.BillingPlan;
import com.ffl.playoffs.domain.port.BillingPlanRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.BillingPlanMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.BillingPlanMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of BillingPlanRepository port
 * Infrastructure layer adapter
 */
@Repository
public class BillingPlanRepositoryImpl implements BillingPlanRepository {

    private final BillingPlanMongoRepository mongoRepository;
    private final BillingPlanMapper mapper;

    public BillingPlanRepositoryImpl(BillingPlanMongoRepository mongoRepository, BillingPlanMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<BillingPlan> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<BillingPlan> findByName(String name) {
        return mongoRepository.findByName(name)
                .map(mapper::toDomain);
    }

    @Override
    public List<BillingPlan> findAll() {
        return mongoRepository.findAll()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<BillingPlan> findAllActive() {
        return mongoRepository.findByActive(true)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<BillingPlan> findFeatured() {
        return mongoRepository.findByFeatured(true)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsByName(String name) {
        return mongoRepository.existsByName(name);
    }

    @Override
    public BillingPlan save(BillingPlan billingPlan) {
        var document = mapper.toDocument(billingPlan);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }
}
