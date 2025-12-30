package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.AuthSession;
import com.ffl.playoffs.domain.model.auth.AuthenticationType;
import com.ffl.playoffs.domain.port.AuthSessionRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.AuthSessionMapper;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.AuthSessionDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoAuthSessionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * MongoDB implementation of AuthSessionRepository.
 */
@Slf4j
@Repository
@RequiredArgsConstructor
public class AuthSessionRepositoryImpl implements AuthSessionRepository {

    private final MongoAuthSessionRepository mongoRepository;

    @Override
    public AuthSession save(AuthSession session) {
        log.debug("Saving auth session: {}", session.getId());
        AuthSessionDocument document = AuthSessionMapper.toDocument(session);
        AuthSessionDocument saved = mongoRepository.save(document);
        return AuthSessionMapper.toDomain(saved);
    }

    @Override
    public Optional<AuthSession> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(AuthSessionMapper::toDomain);
    }

    @Override
    public List<AuthSession> findActiveByPrincipalId(UUID principalId) {
        List<AuthSessionDocument> documents = mongoRepository
                .findByPrincipalIdAndActiveIsTrue(principalId.toString());
        return AuthSessionMapper.toDomains(documents);
    }

    @Override
    public List<AuthSession> findByPrincipalId(UUID principalId) {
        List<AuthSessionDocument> documents = mongoRepository
                .findByPrincipalId(principalId.toString());
        return AuthSessionMapper.toDomains(documents);
    }

    @Override
    public List<AuthSession> findActiveByType(AuthenticationType authenticationType) {
        List<AuthSessionDocument> documents = mongoRepository
                .findByAuthenticationTypeAndActiveIsTrue(authenticationType.getCode());
        return AuthSessionMapper.toDomains(documents);
    }

    @Override
    public List<AuthSession> findExpiredActiveSessions() {
        List<AuthSessionDocument> documents = mongoRepository
                .findExpiredActiveSessions(LocalDateTime.now());
        return AuthSessionMapper.toDomains(documents);
    }

    @Override
    public List<AuthSession> findIdleSessions(LocalDateTime idleThreshold) {
        List<AuthSessionDocument> documents = mongoRepository
                .findIdleSessions(idleThreshold);
        return AuthSessionMapper.toDomains(documents);
    }

    @Override
    public long countActiveByPrincipalId(UUID principalId) {
        return mongoRepository.countByPrincipalIdAndActiveIsTrue(principalId.toString());
    }

    @Override
    public void deleteById(UUID id) {
        log.debug("Deleting auth session: {}", id);
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public void deleteByPrincipalId(UUID principalId) {
        log.debug("Deleting all sessions for principal: {}", principalId);
        mongoRepository.deleteByPrincipalId(principalId.toString());
    }

    @Override
    public long deleteOlderThan(LocalDateTime olderThan) {
        log.info("Deleting sessions older than: {}", olderThan);
        return mongoRepository.deleteByCreatedAtBefore(olderThan);
    }

    @Override
    public boolean existsById(UUID id) {
        return mongoRepository.existsById(id.toString());
    }
}
