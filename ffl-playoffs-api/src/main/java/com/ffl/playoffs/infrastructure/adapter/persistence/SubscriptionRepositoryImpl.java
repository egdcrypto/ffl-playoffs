package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.Subscription;
import com.ffl.playoffs.domain.model.SubscriptionStatus;
import com.ffl.playoffs.domain.port.SubscriptionRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.SubscriptionMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.SubscriptionMongoRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of SubscriptionRepository port
 * Infrastructure layer adapter
 */
@Repository
public class SubscriptionRepositoryImpl implements SubscriptionRepository {

    private final SubscriptionMongoRepository mongoRepository;
    private final SubscriptionMapper mapper;

    public SubscriptionRepositoryImpl(SubscriptionMongoRepository mongoRepository, SubscriptionMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<Subscription> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<Subscription> findActiveByAdminId(UUID adminId) {
        return mongoRepository.findByAdminIdAndStatus(adminId.toString(), SubscriptionStatus.ACTIVE.name())
                .map(mapper::toDomain);
    }

    @Override
    public List<Subscription> findByAdminId(UUID adminId) {
        return mongoRepository.findByAdminId(adminId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Subscription> findByStatus(SubscriptionStatus status) {
        return mongoRepository.findByStatus(status.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Subscription> findExpiringBefore(LocalDateTime date) {
        return mongoRepository.findByEndDateBeforeAndStatus(date, SubscriptionStatus.ACTIVE.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Subscription> findByBillingPlanId(UUID billingPlanId) {
        return mongoRepository.findByBillingPlanId(billingPlanId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean hasActiveSubscription(UUID adminId) {
        return mongoRepository.existsByAdminIdAndStatus(adminId.toString(), SubscriptionStatus.ACTIVE.name());
    }

    @Override
    public Subscription save(Subscription subscription) {
        var document = mapper.toDocument(subscription);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }
}
