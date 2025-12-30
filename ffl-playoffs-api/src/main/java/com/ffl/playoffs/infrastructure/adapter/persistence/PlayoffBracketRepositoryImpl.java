package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.PlayoffBracket;
import com.ffl.playoffs.domain.port.PlayoffBracketRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.document.PlayoffBracketDocument;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.PlayoffBracketMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.PlayoffBracketMongoRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * Implementation of PlayoffBracketRepository using MongoDB
 */
@Component
@RequiredArgsConstructor
public class PlayoffBracketRepositoryImpl implements PlayoffBracketRepository {

    private final PlayoffBracketMongoRepository mongoRepository;
    private final PlayoffBracketMapper mapper;

    @Override
    public Optional<PlayoffBracket> findById(UUID id) {
        return mongoRepository.findById(id.toString())
            .map(mapper::toDomain);
    }

    @Override
    public Optional<PlayoffBracket> findByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueId(leagueId.toString())
            .map(mapper::toDomain);
    }

    @Override
    public List<PlayoffBracket> findAllActive() {
        return mongoRepository.findByIsCompleteFalse().stream()
            .map(mapper::toDomain)
            .collect(Collectors.toList());
    }

    @Override
    public List<PlayoffBracket> findAll() {
        return mongoRepository.findAll().stream()
            .map(mapper::toDomain)
            .collect(Collectors.toList());
    }

    @Override
    public PlayoffBracket save(PlayoffBracket bracket) {
        PlayoffBracketDocument document = mapper.toDocument(bracket);
        PlayoffBracketDocument saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public boolean existsByLeagueId(UUID leagueId) {
        return mongoRepository.existsByLeagueId(leagueId.toString());
    }
}
