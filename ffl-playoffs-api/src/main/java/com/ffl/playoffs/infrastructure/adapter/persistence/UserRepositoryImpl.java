package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.User;
import com.ffl.playoffs.domain.model.Role;
import com.ffl.playoffs.domain.port.UserRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.UserDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.UserMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.UserMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of UserRepository port
 * Infrastructure layer adapter
 */
@Repository
public class UserRepositoryImpl implements UserRepository {

    private final UserMongoRepository mongoRepository;
    private final UserMapper mapper;

    public UserRepositoryImpl(UserMongoRepository mongoRepository, UserMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<User> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<User> findByGoogleId(String googleId) {
        return mongoRepository.findByGoogleId(googleId)
                .map(mapper::toDomain);
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return mongoRepository.findByEmail(email)
                .map(mapper::toDomain);
    }

    @Override
    public User save(User user) {
        UserDocument document = mapper.toDocument(user);
        UserDocument saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public boolean existsByGoogleId(String googleId) {
        return mongoRepository.existsByGoogleId(googleId);
    }

    @Override
    public List<User> findByRole(Role role) {
        return mongoRepository.findByRole(role.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }
}
