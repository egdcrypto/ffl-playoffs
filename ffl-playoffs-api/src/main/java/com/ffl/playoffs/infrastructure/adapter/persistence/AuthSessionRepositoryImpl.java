package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.auth.AuthSession;
import com.ffl.playoffs.domain.model.auth.SessionStatus;
import com.ffl.playoffs.domain.port.AuthSessionRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.AuthSessionMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.AuthSessionMongoRepository;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of AuthSessionRepository port
 * Infrastructure layer adapter
 */
@Repository
public class AuthSessionRepositoryImpl implements AuthSessionRepository {

    private final AuthSessionMongoRepository mongoRepository;
    private final AuthSessionMapper mapper;

    public AuthSessionRepositoryImpl(AuthSessionMongoRepository mongoRepository,
                                      AuthSessionMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<AuthSession> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<AuthSession> findBySessionToken(String sessionToken) {
        return mongoRepository.findBySessionToken(sessionToken)
                .map(mapper::toDomain);
    }

    @Override
    public Optional<AuthSession> findByRefreshToken(String refreshToken) {
        return mongoRepository.findByRefreshToken(refreshToken)
                .map(mapper::toDomain);
    }

    @Override
    public List<AuthSession> findByUserId(UUID userId) {
        return mongoRepository.findByUserId(userId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AuthSession> findActiveByUserId(UUID userId) {
        return mongoRepository.findByUserIdAndStatus(userId.toString(), SessionStatus.ACTIVE.getCode())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AuthSession> findByStatus(SessionStatus status) {
        return mongoRepository.findByStatus(status.getCode())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AuthSession> findExpiringBefore(Instant expirationTime) {
        return mongoRepository.findExpiringBefore(expirationTime)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AuthSession> findByPatId(UUID patId) {
        return mongoRepository.findByPatId(patId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AuthSession> findByGoogleId(String googleId) {
        return mongoRepository.findByGoogleId(googleId)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<AuthSession> findByDeviceIdAndUserId(String deviceId, UUID userId) {
        return mongoRepository.findByDeviceIdAndUserId(deviceId, userId.toString())
                .map(mapper::toDomain);
    }

    @Override
    public AuthSession save(AuthSession session) {
        var document = mapper.toDocument(session);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public void deleteByUserId(UUID userId) {
        mongoRepository.deleteByUserId(userId.toString());
    }

    @Override
    public int deleteExpiredSessions() {
        return (int) mongoRepository.deleteByStatusAndExpiresAtBefore(
                SessionStatus.ACTIVE.getCode(),
                Instant.now()
        );
    }

    @Override
    public long countActiveByUserId(UUID userId) {
        return mongoRepository.countByUserIdAndStatus(userId.toString(), SessionStatus.ACTIVE.getCode());
    }

    @Override
    public boolean existsBySessionToken(String sessionToken) {
        return mongoRepository.existsBySessionToken(sessionToken);
    }

    @Override
    public int invalidateAllByUserId(UUID userId) {
        List<AuthSession> sessions = findActiveByUserId(userId);
        int count = 0;
        for (AuthSession session : sessions) {
            session.invalidate();
            save(session);
            count++;
        }
        return count;
    }

    @Override
    public List<AuthSession> findWithActivityAfter(Instant after) {
        return mongoRepository.findWithActivityAfter(after)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }
}
