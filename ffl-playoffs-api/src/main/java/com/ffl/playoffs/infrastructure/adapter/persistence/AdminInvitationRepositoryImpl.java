package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.invitation.AdminInvitation;
import com.ffl.playoffs.domain.model.invitation.AdminInvitationStatus;
import com.ffl.playoffs.domain.port.AdminInvitationRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.AdminInvitationDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.AdminInvitationMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.AdminInvitationMongoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of AdminInvitationRepository.
 */
@Repository
@RequiredArgsConstructor
public class AdminInvitationRepositoryImpl implements AdminInvitationRepository {

    private final AdminInvitationMongoRepository mongoRepository;
    private final AdminInvitationMapper mapper;

    @Override
    public AdminInvitation save(AdminInvitation invitation) {
        AdminInvitationDocument doc = mapper.toDocument(invitation);
        AdminInvitationDocument saved = mongoRepository.save(doc);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<AdminInvitation> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<AdminInvitation> findByToken(String token) {
        return mongoRepository.findByInvitationToken(token)
                .map(mapper::toDomain);
    }

    @Override
    public Optional<AdminInvitation> findByEmail(String email) {
        return mongoRepository.findByEmail(email.toLowerCase())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<AdminInvitation> findPendingByEmail(String email) {
        return mongoRepository.findPendingByEmail(email.toLowerCase())
                .map(mapper::toDomain);
    }

    @Override
    public List<AdminInvitation> findByStatus(AdminInvitationStatus status) {
        return mongoRepository.findByStatus(status.getCode())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AdminInvitation> findByInvitedBy(UUID invitedBy) {
        return mongoRepository.findByInvitedBy(invitedBy.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AdminInvitation> findPendingInvitations() {
        return mongoRepository.findPendingInvitations()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AdminInvitation> findExpiredInvitations() {
        return mongoRepository.findExpiredInvitations(Instant.now())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AdminInvitation> findByEmailAndStatus(String email, AdminInvitationStatus status) {
        return mongoRepository.findByEmailAndStatus(email.toLowerCase(), status.getCode())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsPendingByEmail(String email) {
        return mongoRepository.existsPendingByEmail(email.toLowerCase());
    }

    @Override
    public boolean existsById(UUID id) {
        return mongoRepository.existsById(id.toString());
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public long countByStatus(AdminInvitationStatus status) {
        return mongoRepository.countByStatus(status.getCode());
    }

    @Override
    public long countPendingByInvitedBy(UUID invitedBy) {
        return mongoRepository.countPendingByInvitedBy(invitedBy.toString());
    }

    @Override
    public List<AdminInvitation> findAll() {
        return mongoRepository.findAll()
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }
}
