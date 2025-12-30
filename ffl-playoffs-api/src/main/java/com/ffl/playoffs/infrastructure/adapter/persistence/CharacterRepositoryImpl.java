package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.character.Character;
import com.ffl.playoffs.domain.model.character.CharacterStatus;
import com.ffl.playoffs.domain.port.CharacterRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.CharacterMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.CharacterMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of CharacterRepository port
 * Infrastructure layer adapter
 */
@Repository
public class CharacterRepositoryImpl implements CharacterRepository {

    private final CharacterMongoRepository mongoRepository;
    private final CharacterMapper mapper;

    public CharacterRepositoryImpl(CharacterMongoRepository mongoRepository,
                                    CharacterMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<Character> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<Character> findByUserIdAndLeagueId(UUID userId, UUID leagueId) {
        return mongoRepository.findByUserIdAndLeagueId(userId.toString(), leagueId.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<Character> findByUserId(UUID userId) {
        return mongoRepository.findByUserId(userId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Character> findByLeagueId(UUID leagueId) {
        return mongoRepository.findByLeagueId(leagueId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Character> findByLeagueIdAndStatus(UUID leagueId, CharacterStatus status) {
        return mongoRepository.findByLeagueIdAndStatus(leagueId.toString(), status.getCode())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Character> findActiveByLeagueId(UUID leagueId) {
        return findByLeagueIdAndStatus(leagueId, CharacterStatus.ACTIVE);
    }

    @Override
    public List<Character> findEliminatedByLeagueId(UUID leagueId) {
        return findByLeagueIdAndStatus(leagueId, CharacterStatus.ELIMINATED);
    }

    @Override
    public List<Character> findByLeagueIdOrderByTotalScoreDesc(UUID leagueId) {
        return mongoRepository.findByLeagueIdOrderByTotalScoreDesc(leagueId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Character> findByLeagueIdOrderByOverallRankAsc(UUID leagueId) {
        return mongoRepository.findByLeagueIdOrderByOverallRankAsc(leagueId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Character> findByLeagueIdAndEliminationWeek(UUID leagueId, Integer week) {
        return mongoRepository.findByLeagueIdAndEliminationWeek(leagueId.toString(), week)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Character save(Character character) {
        var document = mapper.toDocument(character);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public void deleteById(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public void deleteByUserId(UUID userId) {
        mongoRepository.deleteByUserId(userId.toString());
    }

    @Override
    public void deleteByLeagueId(UUID leagueId) {
        mongoRepository.deleteByLeagueId(leagueId.toString());
    }

    @Override
    public long countByLeagueId(UUID leagueId) {
        return mongoRepository.countByLeagueId(leagueId.toString());
    }

    @Override
    public long countActiveByLeagueId(UUID leagueId) {
        return countByLeagueIdAndStatus(leagueId, CharacterStatus.ACTIVE);
    }

    @Override
    public long countByLeagueIdAndStatus(UUID leagueId, CharacterStatus status) {
        return mongoRepository.countByLeagueIdAndStatus(leagueId.toString(), status.getCode());
    }

    @Override
    public boolean existsByUserIdAndLeagueId(UUID userId, UUID leagueId) {
        return mongoRepository.existsByUserIdAndLeagueId(userId.toString(), leagueId.toString());
    }

    @Override
    public boolean existsByLeagueIdAndName(UUID leagueId, String name) {
        return mongoRepository.existsByLeagueIdAndName(leagueId.toString(), name);
    }

    @Override
    public List<Character> findLowestScoringActiveCharacters(UUID leagueId, int limit) {
        return mongoRepository.findByLeagueIdAndStatusOrderByTotalScoreAsc(
                        leagueId.toString(), CharacterStatus.ACTIVE.getCode())
                .stream()
                .limit(limit)
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }
}
