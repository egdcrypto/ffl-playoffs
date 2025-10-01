package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.LeaguePlayer;
import com.ffl.playoffs.domain.model.LeaguePlayer.LeaguePlayerStatus;
import com.ffl.playoffs.domain.port.LeaguePlayerRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.LeaguePlayerMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.LeaguePlayerMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of LeaguePlayerRepository port
 * Infrastructure layer adapter
 */
@Repository
public class LeaguePlayerRepositoryImpl implements LeaguePlayerRepository {

    private final LeaguePlayerMongoRepository mongoRepository;
    private final LeaguePlayerMapper mapper;

    public LeaguePlayerRepositoryImpl(LeaguePlayerMongoRepository mongoRepository, LeaguePlayerMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public LeaguePlayer save(LeaguePlayer leaguePlayer) {
        var document = mapper.toDocument(leaguePlayer);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<LeaguePlayer> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<LeaguePlayer> findByUserIdAndLeagueId(UUID userId, UUID leagueId) {
        return mongoRepository.findByUserIdAndLeagueId(userId.toString(), leagueId.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<LeaguePlayer> findByUserId(UUID userId) {
        return mongoRepository.findByUserId(userId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<LeaguePlayer> findActiveLeaguesByUserId(UUID userId) {
        return mongoRepository.findActiveLeaguesByUserId(userId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<LeaguePlayer> findByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueId(leagueId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<LeaguePlayer> findActivePlayersByLeagueId(UUID leagueId) {
        return mongoRepository.findActivePlayersByLeagueId(leagueId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<LeaguePlayer> findByLeagueIdAndStatus(UUID leagueId, LeaguePlayerStatus status) {
        return mongoRepository.findByLeagueIdAndStatus(leagueId.toString(), status.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<LeaguePlayer> findByInvitationToken(String invitationToken) {
        return mongoRepository.findByInvitationToken(invitationToken)
                .map(mapper::toDomain);
    }

    @Override
    public boolean existsByUserIdAndLeagueId(UUID userId, UUID leagueId) {
        return mongoRepository.existsByUserIdAndLeagueId(userId.toString(), leagueId.toString());
    }

    @Override
    public boolean isActivePlayer(UUID userId, UUID leagueId) {
        return mongoRepository.isActivePlayer(userId.toString(), leagueId.toString());
    }

    @Override
    public long countByLeagueId(UUID leagueId) {
        return mongoRepository.countByLeagueId(leagueId.toString());
    }

    @Override
    public long countActivePlayersByLeagueId(UUID leagueId) {
        return mongoRepository.countActivePlayersByLeagueId(leagueId.toString());
    }

    @Override
    public long countPendingInvitationsByLeagueId(UUID leagueId) {
        return mongoRepository.countPendingInvitationsByLeagueId(leagueId.toString());
    }

    @Override
    public void delete(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public void deleteByLeagueId(UUID leagueId) {
        mongoRepository.deleteByLeagueId(leagueId.toString());
    }

    @Override
    public void deleteByUserId(UUID userId) {
        mongoRepository.deleteByUserId(userId.toString());
    }
}
