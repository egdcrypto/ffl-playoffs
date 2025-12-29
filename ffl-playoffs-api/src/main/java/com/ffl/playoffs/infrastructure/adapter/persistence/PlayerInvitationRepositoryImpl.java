package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.PlayerInvitation;
import com.ffl.playoffs.domain.port.PlayerInvitationRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.PlayerInvitationMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.PlayerInvitationMongoRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of PlayerInvitationRepository port.
 * Infrastructure layer adapter.
 */
@Repository
public class PlayerInvitationRepositoryImpl implements PlayerInvitationRepository {

    private final PlayerInvitationMongoRepository mongoRepository;
    private final PlayerInvitationMapper mapper;

    public PlayerInvitationRepositoryImpl(
            PlayerInvitationMongoRepository mongoRepository,
            PlayerInvitationMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<PlayerInvitation> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<PlayerInvitation> findByToken(String token) {
        return mongoRepository.findByInvitationToken(token)
                .map(mapper::toDomain);
    }

    @Override
    public List<PlayerInvitation> findPendingByEmail(String email) {
        return mongoRepository.findPendingByEmail(email)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<PlayerInvitation> findPendingByEmailAndLeague(String email, UUID leagueId) {
        return mongoRepository.findPendingByEmailAndLeagueId(email, leagueId.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<PlayerInvitation> findByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueId(leagueId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<PlayerInvitation> findPendingByLeagueId(UUID leagueId) {
        return mongoRepository.findPendingByLeagueId(leagueId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsPendingByEmailAndLeague(String email, UUID leagueId) {
        return mongoRepository.existsPendingByEmailAndLeagueId(email, leagueId.toString());
    }

    @Override
    public PlayerInvitation save(PlayerInvitation invitation) {
        var document = mapper.toDocument(invitation);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public List<PlayerInvitation> findExpiredPendingInvitations() {
        return mongoRepository.findExpiredPendingInvitations(LocalDateTime.now())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }
}
