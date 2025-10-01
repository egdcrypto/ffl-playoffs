package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.PersonalAccessToken;
import com.ffl.playoffs.domain.port.PersonalAccessTokenRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.PersonalAccessTokenMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.PersonalAccessTokenMongoRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of PersonalAccessTokenRepository port
 * Infrastructure layer adapter
 */
@Repository
public class PersonalAccessTokenRepositoryImpl implements PersonalAccessTokenRepository {

    private final PersonalAccessTokenMongoRepository mongoRepository;
    private final PersonalAccessTokenMapper mapper;

    public PersonalAccessTokenRepositoryImpl(PersonalAccessTokenMongoRepository mongoRepository,
                                            PersonalAccessTokenMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<PersonalAccessToken> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<PersonalAccessToken> findByTokenIdentifier(String tokenIdentifier) {
        return mongoRepository.findByTokenIdentifier(tokenIdentifier)
                .map(mapper::toDomain);
    }

    @Override
    public List<PersonalAccessToken> findByCreatedBy(UUID userId) {
        return mongoRepository.findByCreatedBy(userId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<PersonalAccessToken> findAllActive() {
        return mongoRepository.findAllActive(LocalDateTime.now())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public PersonalAccessToken save(PersonalAccessToken token) {
        var document = mapper.toDocument(token);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public boolean existsByName(String name) {
        return mongoRepository.existsByName(name);
    }
}
