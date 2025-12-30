package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.narrative.AIDirector;
import com.ffl.playoffs.domain.port.AIDirectorRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.AIDirectorDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.AIDirectorMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.AIDirectorMongoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of AIDirectorRepository
 */
@Repository
@RequiredArgsConstructor
public class AIDirectorRepositoryImpl implements AIDirectorRepository {

    private final AIDirectorMongoRepository mongoRepository;
    private final AIDirectorMapper mapper;

    @Override
    public AIDirector save(AIDirector director) {
        AIDirectorDocument document = mapper.toDocument(director);
        AIDirectorDocument saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<AIDirector> findById(UUID id) {
        return mongoRepository.findById(id)
                .map(mapper::toDomain);
    }

    @Override
    public Optional<AIDirector> findByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueId(leagueId)
                .map(mapper::toDomain);
    }

    @Override
    public List<AIDirector> findAllActive() {
        return mongoRepository.findByStatus("active").stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AIDirector> findWithActiveStalls() {
        return mongoRepository.findWithActiveStalls().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AIDirector> findWithPendingActions() {
        return mongoRepository.findWithPendingActions().stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<AIDirector> findInactive(int thresholdHours) {
        Instant threshold = Instant.now().minus(thresholdHours, ChronoUnit.HOURS);
        return mongoRepository.findInactiveSince(threshold).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsByLeagueId(UUID leagueId) {
        return mongoRepository.existsByLeagueId(leagueId);
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
