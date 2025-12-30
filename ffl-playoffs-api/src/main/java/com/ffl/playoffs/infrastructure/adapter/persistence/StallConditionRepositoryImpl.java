package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.narrative.StallCondition;
import com.ffl.playoffs.domain.model.narrative.StallConditionType;
import com.ffl.playoffs.domain.port.StallConditionRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.StallConditionDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.StallConditionMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.StallConditionMongoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of StallConditionRepository
 */
@Repository
@RequiredArgsConstructor
public class StallConditionRepositoryImpl implements StallConditionRepository {

    private final StallConditionMongoRepository mongoRepository;
    private final StallConditionMapper mapper;

    @Override
    public StallCondition save(StallCondition condition) {
        StallConditionDocument document = mapper.toDocument(condition);
        StallConditionDocument saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<StallCondition> findById(UUID id) {
        return mongoRepository.findById(id)
                .map(mapper::toDomain);
    }

    @Override
    public List<StallCondition> findByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueId(leagueId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StallCondition> findActiveByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueIdAndResolvedFalse(leagueId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StallCondition> findResolvedByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueIdAndResolvedTrue(leagueId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StallCondition> findByLeagueIdAndType(UUID leagueId, StallConditionType type) {
        return mongoRepository.findByLeagueIdAndType(leagueId, type.getCode()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StallCondition> findByLeagueIdAndSeverity(UUID leagueId, StallConditionType.SeverityLevel severity) {
        return mongoRepository.findByLeagueIdAndSeverity(leagueId, severity.name()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StallCondition> findByLeagueIdAndAffectedPlayerId(UUID leagueId, UUID playerId) {
        return mongoRepository.findByLeagueIdAndAffectedPlayerId(leagueId, playerId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StallCondition> findExceedingThreshold(UUID leagueId) {
        return findActiveByLeagueId(leagueId).stream()
                .filter(StallCondition::exceedsThreshold)
                .collect(Collectors.toList());
    }

    @Override
    public List<StallCondition> findRequiringImmediateAttention(UUID leagueId) {
        return findActiveByLeagueId(leagueId).stream()
                .filter(StallCondition::requiresImmediateAttention)
                .collect(Collectors.toList());
    }

    @Override
    public long countActiveByLeagueId(UUID leagueId) {
        return mongoRepository.countByLeagueIdAndResolvedFalse(leagueId);
    }

    @Override
    public long countByLeagueIdAndType(UUID leagueId, StallConditionType type) {
        return mongoRepository.countByLeagueIdAndType(leagueId, type.getCode());
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
    public void deleteResolvedOlderThan(UUID leagueId, int hours) {
        Instant threshold = Instant.now().minus(hours, ChronoUnit.HOURS);
        mongoRepository.deleteResolvedOlderThan(leagueId, threshold);
    }
}
