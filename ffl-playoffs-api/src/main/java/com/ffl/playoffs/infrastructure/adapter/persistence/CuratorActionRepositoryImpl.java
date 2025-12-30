package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.narrative.CuratorAction;
import com.ffl.playoffs.domain.model.narrative.CuratorActionType;
import com.ffl.playoffs.domain.port.CuratorActionRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.CuratorActionDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.CuratorActionMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.CuratorActionMongoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of CuratorActionRepository
 */
@Repository
@RequiredArgsConstructor
public class CuratorActionRepositoryImpl implements CuratorActionRepository {

    private final CuratorActionMongoRepository mongoRepository;
    private final CuratorActionMapper mapper;

    @Override
    public CuratorAction save(CuratorAction action) {
        CuratorActionDocument document = mapper.toDocument(action);
        CuratorActionDocument saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<CuratorAction> findById(UUID id) {
        return mongoRepository.findById(id)
                .map(mapper::toDomain);
    }

    @Override
    public List<CuratorAction> findByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueId(leagueId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<CuratorAction> findPendingByLeagueId(UUID leagueId) {
        return findByLeagueIdAndStatus(leagueId, CuratorAction.ActionStatus.PENDING);
    }

    @Override
    public List<CuratorAction> findInProgressByLeagueId(UUID leagueId) {
        return findByLeagueIdAndStatus(leagueId, CuratorAction.ActionStatus.IN_PROGRESS);
    }

    @Override
    public List<CuratorAction> findCompletedByLeagueId(UUID leagueId) {
        return findByLeagueIdAndStatus(leagueId, CuratorAction.ActionStatus.COMPLETED);
    }

    @Override
    public List<CuratorAction> findByLeagueIdAndType(UUID leagueId, CuratorActionType type) {
        return mongoRepository.findByLeagueIdAndType(leagueId, type.getCode()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<CuratorAction> findByLeagueIdAndStatus(UUID leagueId, CuratorAction.ActionStatus status) {
        return mongoRepository.findByLeagueIdAndStatus(leagueId, status.name()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<CuratorAction> findAutomatedByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueIdAndAutomatedTrue(leagueId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<CuratorAction> findManualByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueIdAndAutomatedFalse(leagueId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<CuratorAction> findByInitiatedBy(UUID userId) {
        return mongoRepository.findByInitiatedBy(userId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<CuratorAction> findByRelatedStallConditionId(UUID stallConditionId) {
        return mongoRepository.findByRelatedStallConditionId(stallConditionId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<CuratorAction> findByRelatedStoryArcId(UUID storyArcId) {
        return mongoRepository.findByRelatedStoryArcId(storyArcId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<CuratorAction> findByTargetPlayerId(UUID playerId) {
        return mongoRepository.findByTargetPlayerId(playerId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<CuratorAction> findRecentByLeagueId(UUID leagueId, int limit) {
        return mongoRepository.findByLeagueIdOrderByCreatedAtDesc(leagueId, PageRequest.of(0, limit)).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public long countPendingByLeagueId(UUID leagueId) {
        return mongoRepository.countByLeagueIdAndStatus(leagueId, CuratorAction.ActionStatus.PENDING.name());
    }

    @Override
    public long countByLeagueIdAndType(UUID leagueId, CuratorActionType type) {
        return mongoRepository.countByLeagueIdAndType(leagueId, type.getCode());
    }

    @Override
    public long countByLeagueIdAndStatus(UUID leagueId, CuratorAction.ActionStatus status) {
        return mongoRepository.countByLeagueIdAndStatus(leagueId, status.name());
    }

    @Override
    public void delete(UUID id) {
        mongoRepository.deleteById(id);
    }

    @Override
    public void deleteByLeagueId(UUID leagueId) {
        mongoRepository.deleteByLeagueId(leagueId);
    }

    @Override
    public void deleteCompletedOlderThan(UUID leagueId, int hours) {
        Instant threshold = Instant.now().minus(hours, ChronoUnit.HOURS);
        mongoRepository.deleteCompletedOlderThan(leagueId, threshold);
    }
}
