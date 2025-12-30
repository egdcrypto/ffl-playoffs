package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.port.RosterRepository;
import com.ffl.playoffs.infrastructure.adapter.persistence.mapper.RosterMapper;
import com.ffl.playoffs.infrastructure.adapter.persistence.repository.RosterMongoRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;
import java.util.UUID;

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
    public Roster save(Roster roster) {
        var document = mapper.toDocument(roster);
        var saved = mongoRepository.save(document);
        return mapper.toDomain(saved);
    }
}
