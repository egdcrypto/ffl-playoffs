package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.narrative.NarrativePhase;
import com.ffl.playoffs.domain.model.narrative.StoryBeat;
import com.ffl.playoffs.domain.model.narrative.StoryBeatType;
import com.ffl.playoffs.domain.port.StoryBeatRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.StoryBeatDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.StoryBeatMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.StoryBeatMongoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of StoryBeatRepository
 */
@Repository
@RequiredArgsConstructor
public class StoryBeatRepositoryImpl implements StoryBeatRepository {

    private final StoryBeatMongoRepository mongoRepository;
    private final StoryBeatMapper mapper;

    @Override
    public StoryBeat save(StoryBeat beat) {
        StoryBeatDocument document = mapper.toDocument(beat);
        StoryBeatDocument saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<StoryBeat> findById(UUID id) {
        return mongoRepository.findById(id)
                .map(mapper::toDomain);
    }

    @Override
    public List<StoryBeat> findByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueId(leagueId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoryBeat> findByStoryArcId(UUID storyArcId) {
        return mongoRepository.findByStoryArcId(storyArcId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoryBeat> findByLeagueIdAndType(UUID leagueId, StoryBeatType type) {
        return mongoRepository.findByLeagueIdAndType(leagueId, type.getCode()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoryBeat> findByLeagueIdAndPhase(UUID leagueId, NarrativePhase phase) {
        return mongoRepository.findByLeagueIdAndPhase(leagueId, phase.getCode()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoryBeat> findByLeagueIdAndInvolvedPlayerId(UUID leagueId, UUID playerId) {
        return mongoRepository.findByLeagueIdAndInvolvedPlayerId(leagueId, playerId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoryBeat> findByLeagueIdAndWeekNumber(UUID leagueId, Integer weekNumber) {
        return mongoRepository.findByLeagueIdAndWeekNumber(leagueId, weekNumber).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoryBeat> findPublishedByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueIdAndPublishedTrue(leagueId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoryBeat> findUnpublishedByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueIdAndPublishedFalse(leagueId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoryBeat> findRootBeatsByLeagueId(UUID leagueId) {
        return mongoRepository.findRootBeatsByLeagueId(leagueId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoryBeat> findLeafBeatsByLeagueId(UUID leagueId) {
        return mongoRepository.findLeafBeatsByLeagueId(leagueId).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoryBeat> findRecentByLeagueId(UUID leagueId, int limit) {
        return mongoRepository.findByLeagueIdOrderByOccurredAtDesc(leagueId, PageRequest.of(0, limit)).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<StoryBeat> findByLeagueIdAndOccurredAfter(UUID leagueId, Instant since) {
        return mongoRepository.findByLeagueIdAndOccurredAtAfter(leagueId, since).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public long countByLeagueId(UUID leagueId) {
        return mongoRepository.countByLeagueId(leagueId);
    }

    @Override
    public long countByLeagueIdAndType(UUID leagueId, StoryBeatType type) {
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
}
