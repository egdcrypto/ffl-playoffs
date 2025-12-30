package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.TeamSelection;
import com.ffl.playoffs.domain.port.TeamSelectionRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.TeamSelectionMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.TeamSelectionMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of TeamSelectionRepository port
 * Infrastructure layer adapter
 */
@Repository
public class TeamSelectionRepositoryImpl implements TeamSelectionRepository {

    private final TeamSelectionMongoRepository mongoRepository;
    private final TeamSelectionMapper mapper;

    public TeamSelectionRepositoryImpl(TeamSelectionMongoRepository mongoRepository, TeamSelectionMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public TeamSelection save(TeamSelection teamSelection) {
        var document = mapper.toDocument(teamSelection);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public Optional<TeamSelection> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<TeamSelection> findByPlayerId(UUID playerId) {
        return mongoRepository.findByPlayerId(playerId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public Optional<TeamSelection> findByPlayerIdAndWeek(UUID playerId, int week) {
        return mongoRepository.findByPlayerIdAndWeek(playerId.toString(), week)
                .map(mapper::toDomain);
    }

    @Override
    public List<TeamSelection> findByGameId(UUID gameId) {
        return mongoRepository.findByGameId(gameId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<TeamSelection> findByGameIdAndWeek(UUID gameId, int week) {
        return mongoRepository.findByGameIdAndWeek(gameId.toString(), week)
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public boolean hasPlayerSelectedTeam(UUID playerId, String teamName) {
        return mongoRepository.hasPlayerSelectedTeam(playerId.toString(), teamName);
    }

    @Override
    public long countByPlayerId(UUID playerId) {
        return mongoRepository.countByPlayerId(playerId.toString());
    }

    @Override
    public void delete(UUID id) {
        mongoRepository.deleteById(id.toString());
    }

    @Override
    public void deleteByPlayerId(UUID playerId) {
        mongoRepository.deleteByPlayerId(playerId.toString());
    }

    @Override
    public long countByWeekId(UUID weekId) {
        return mongoRepository.countByWeekId(weekId.toString());
    }

    @Override
    public List<TeamSelection> findByWeekId(UUID weekId) {
        return mongoRepository.findByWeekId(weekId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }
}
