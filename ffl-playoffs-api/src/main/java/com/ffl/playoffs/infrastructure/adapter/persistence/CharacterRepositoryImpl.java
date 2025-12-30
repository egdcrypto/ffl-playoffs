package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.Character;
import com.ffl.playoffs.domain.port.CharacterRepository;
import com.ffl.playoffs.infrastructure.persistence.mongodb.document.CharacterDocument;
import com.ffl.playoffs.infrastructure.persistence.mongodb.mapper.CharacterMapper;
import com.ffl.playoffs.infrastructure.persistence.mongodb.repository.MongoCharacterRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of CharacterRepository port
 * Adapter in hexagonal architecture
 */
@Slf4j
@Repository
@RequiredArgsConstructor
public class CharacterRepositoryImpl implements CharacterRepository {

    private final MongoCharacterRepository mongoRepository;
    private final CharacterMapper mapper;

    @Override
    public Optional<Character> findById(UUID id) {
        log.debug("Finding character by ID: {}", id);
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<Character> findByUserIdAndLeagueId(UUID userId, UUID leagueId) {
        log.debug("Finding character for user {} in league {}", userId, leagueId);
        return mongoRepository.findByUserIdAndLeagueId(userId.toString(), leagueId.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<Character> findByUserId(UUID userId) {
        log.debug("Finding characters for user: {}", userId);
        return mongoRepository.findByUserId(userId.toString()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Character> findByLeagueId(UUID leagueId) {
        log.debug("Finding characters in league: {}", leagueId);
        return mongoRepository.findByLeagueId(leagueId.toString()).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Character> findByTeamNameContaining(String teamName) {
        log.debug("Finding characters with team name containing: {}", teamName);
        return mongoRepository.findByTeamNameContainingIgnoreCase(teamName).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Character> findTopByLevel(int limit) {
        log.debug("Finding top {} characters by level", limit);
        return mongoRepository.findAllByOrderByLevelDesc(PageRequest.of(0, limit)).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Character> findTopByLevelInLeague(UUID leagueId, int limit) {
        log.debug("Finding top {} characters by level in league {}", limit, leagueId);
        return mongoRepository.findByLeagueIdOrderByLevelDesc(leagueId.toString(), PageRequest.of(0, limit)).stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean existsByUserIdAndLeagueId(UUID userId, UUID leagueId) {
        return mongoRepository.existsByUserIdAndLeagueId(userId.toString(), leagueId.toString());
    }

    @Override
    public boolean existsByLeagueIdAndTeamName(UUID leagueId, String teamName) {
        return mongoRepository.existsByLeagueIdAndTeamName(leagueId.toString(), teamName);
    }

    @Override
    public Character save(Character character) {
        log.debug("Saving character: {}", character.getId());
        CharacterDocument document = mapper.toDocument(character);
        CharacterDocument saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID id) {
        log.debug("Deleting character: {}", id);
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public void deleteByUserIdAndLeagueId(UUID userId, UUID leagueId) {
        log.debug("Deleting character for user {} in league {}", userId, leagueId);
        mongoRepository.deleteByUserIdAndLeagueId(userId.toString(), leagueId.toString());
    }

    @Override
    public long countByLeagueId(UUID leagueId) {
        return mongoRepository.countByLeagueId(leagueId.toString());
    }

    @Override
    public long count() {
        return mongoRepository.count();
    }
}
