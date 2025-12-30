package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.narrative.NarrativePhase;
import com.ffl.playoffs.domain.model.narrative.StoryArc;
import com.ffl.playoffs.domain.model.narrative.StoryArcStatus;
import com.ffl.playoffs.domain.port.StoryArcRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.StoryArcDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.StoryArcMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.StoryArcMongoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of StoryArcRepository
 */
@Repository
@RequiredArgsConstructor
public class StoryArcRepositoryImpl implements StoryArcRepository {

    private final StoryArcMongoRepository mongoRepository;
    private final StoryArcMapper mapper;

    @Override
    public StoryArc save(StoryArc arc) {
        StoryArcDocument document = mapper.toDocument(arc);
        StoryArcDocument saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<StoryArc> findById(UUID id) {
        return mongoRepository.findById(id)
                .map(mapper::toDomain);
    }

    @Override
    public List<StoryArc> findByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueId(leagueId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoryArc> findByLeagueIdAndStatus(UUID leagueId, StoryArcStatus status) {
        return mongoRepository.findByLeagueIdAndStatus(leagueId, status.getCode()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoryArc> findActiveByLeagueId(UUID leagueId) {
        return findByLeagueIdAndStatus(leagueId, StoryArcStatus.ACTIVE);
    }

    @Override
    public List<StoryArc> findByLeagueIdAndCurrentPhase(UUID leagueId, NarrativePhase phase) {
        return mongoRepository.findByLeagueIdAndCurrentPhase(leagueId, phase.getCode()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoryArc> findByLeagueIdAndInvolvedPlayerId(UUID leagueId, UUID playerId) {
        return mongoRepository.findByLeagueIdAndInvolvedPlayerId(leagueId, playerId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoryArc> findCompletedByLeagueId(UUID leagueId) {
        return findByLeagueIdAndStatus(leagueId, StoryArcStatus.COMPLETED);
    }

    @Override
    public List<StoryArc> findArchivedByLeagueId(UUID leagueId) {
        return findByLeagueIdAndStatus(leagueId, StoryArcStatus.ARCHIVED);
    }

    @Override
    public long countByLeagueIdAndStatus(UUID leagueId, StoryArcStatus status) {
        return mongoRepository.countByLeagueIdAndStatus(leagueId, status.getCode());
    }

    @Override
    public long countActiveByLeagueId(UUID leagueId) {
        return countByLeagueIdAndStatus(leagueId, StoryArcStatus.ACTIVE);
    }

    @Override
    public void delete(UUID id) {
        mongoRepository.deleteById(id);
    }

    @Override
    public void deleteByLeagueId(UUID leagueId) {
        mongoRepository.deleteByLeagueId(leagueId);
    }
}
