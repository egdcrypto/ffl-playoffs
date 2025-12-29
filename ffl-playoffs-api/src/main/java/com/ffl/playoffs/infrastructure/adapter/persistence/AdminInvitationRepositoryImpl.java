package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.entity.AdminInvitation;
import com.ffl.playoffs.domain.model.AdminInvitationStatus;
import com.ffl.playoffs.domain.port.AdminInvitationRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.AdminInvitationMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.AdminInvitationMongoRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of AdminInvitationRepository port
 */
@Repository
public class AdminInvitationRepositoryImpl implements AdminInvitationRepository {

    private final AdminInvitationMongoRepository mongoRepository;
    private final AdminInvitationMapper mapper;

    public AdminInvitationRepositoryImpl(AdminInvitationMongoRepository mongoRepository,
                                          AdminInvitationMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public AdminInvitation save(AdminInvitation invitation) {
        var document = mapper.toDocument(invitation);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<AdminInvitation> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<AdminInvitation> findByInvitationToken(String token) {
        return mongoRepository.findByInvitationToken(token)
                .map(mapper::toDomain);
    }

    @Override
    public Optional<AdminInvitation> findPendingByEmail(String email) {
        return mongoRepository.findPendingByEmail(email.toLowerCase())
                .map(mapper::toDomain);
    }

    @Override
    public List<AdminInvitation> findByEmail(String email) {
        return mongoRepository.findByEmail(email.toLowerCase())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AdminInvitation> findByStatus(AdminInvitationStatus status) {
        return mongoRepository.findByStatus(status.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AdminInvitation> findExpiredPending(LocalDateTime now) {
        return mongoRepository.findExpiredPending(now)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsPendingByEmail(String email) {
        return mongoRepository.existsPendingByEmail(email.toLowerCase());
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public List<AdminInvitation> findAll() {
        return mongoRepository.findAll()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }
}
