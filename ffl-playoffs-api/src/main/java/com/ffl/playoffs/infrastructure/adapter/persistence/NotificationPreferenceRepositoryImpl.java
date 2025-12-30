package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.NotificationPreference;
import com.ffl.playoffs.domain.port.NotificationPreferenceRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.NotificationPreferenceDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.NotificationPreferenceMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.NotificationPreferenceMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

/**
 * MongoDB implementation of NotificationPreferenceRepository port
 * Infrastructure layer adapter
 */
@Repository
public class NotificationPreferenceRepositoryImpl implements NotificationPreferenceRepository {

    private final NotificationPreferenceMongoRepository mongoRepository;
    private final NotificationPreferenceMapper mapper;

    public NotificationPreferenceRepositoryImpl(
            NotificationPreferenceMongoRepository mongoRepository,
            NotificationPreferenceMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public NotificationPreference save(NotificationPreference preference) {
        NotificationPreferenceDocument document = mapper.toDocument(preference);
        NotificationPreferenceDocument saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<NotificationPreference> findByUserId(String userId) {
        return mongoRepository.findByUserId(userId)
                .map(mapper::toDomain);
    }

    @Override
    public Optional<NotificationPreference> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public void deleteByUserId(String userId) {
        mongoRepository.deleteByUserId(userId);
    }

    @Override
    public boolean existsByUserId(String userId) {
        return mongoRepository.existsByUserId(userId);
    }
}
