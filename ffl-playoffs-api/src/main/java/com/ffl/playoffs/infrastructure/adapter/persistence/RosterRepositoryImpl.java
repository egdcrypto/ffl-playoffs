package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.model.RosterLockStatus;
import com.ffl.playoffs.domain.port.RosterRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.RosterMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.RosterMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * MongoDB implementation of RosterRepository port.
 * Infrastructure layer adapter that bridges domain logic to MongoDB persistence.
 */
@Repository
public class RosterRepositoryImpl implements RosterRepository {

    private final RosterMongoRepository mongoRepository;
    private final RosterMapper mapper;

    public RosterRepositoryImpl(RosterMongoRepository mongoRepository, RosterMapper mapper) {
        this.mongoRepository = mongoRepository;
        this.mapper = mapper;
    }

    @Override
    public Optional<Roster> findById(UUID id) {
        return mongoRepository.findById(id.toString())
                .map(mapper::toDomain);
    }

    @Override
    public Optional<Roster> findByLeaguePlayerId(UUID leaguePlayerId) {
        return mongoRepository.findByLeaguePlayerId(leaguePlayerId.toString())
                .map(mapper::toDomain);
    }

    @Override
    public List<Roster> findByLeagueId(UUID leagueId) {
        return mongoRepository.findByGameId(leagueId.toString())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public List<Roster> findByLeagueIdAndLockStatus(UUID leagueId, RosterLockStatus lockStatus) {
        return mongoRepository.findByGameIdAndLockStatus(leagueId.toString(), lockStatus.name())
                .stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }

    @Override
    public long countByLeagueIdAndLockStatus(UUID leagueId, RosterLockStatus lockStatus) {
        return mongoRepository.countByGameIdAndLockStatus(leagueId.toString(), lockStatus.name());
    }

    @Override
    public Roster save(Roster roster) {
        var document = mapper.toDocument(roster);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }

    @Override
    public List<Roster> saveAll(List<Roster> rosters) {
        var documents = rosters.stream()
                .map(mapper::toDocument)
                .collect(Collectors.toList());
        var savedDocuments = mongoRepository.saveAll(documents);
        return savedDocuments.stream()
                .map(mapper::toDomain)
                .collect(Collectors.toList());
    }
}
