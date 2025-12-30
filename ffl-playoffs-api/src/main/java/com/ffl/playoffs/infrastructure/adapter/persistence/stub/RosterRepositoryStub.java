package com.ffl.playoffs.infrastructure.adapter.persistence.stub;

import com.ffl.playoffs.domain.aggregate.Roster;
import com.ffl.playoffs.domain.port.RosterRepository;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Stub implementation of RosterRepository for testing and development
 */
@Repository
public class RosterRepositoryStub implements RosterRepository {

    private final Map<UUID, Roster> storage = new ConcurrentHashMap<>();

    @Override
    public Optional<Roster> findById(UUID id) {
        return Optional.ofNullable(storage.get(id));
    }

    @Override
    public Optional<Roster> findByLeaguePlayerId(UUID leaguePlayerId) {
        return storage.values().stream()
                .filter(r -> leaguePlayerId.equals(r.getLeaguePlayerId()))
                .findFirst();
    }

    @Override
    public List<Roster> findByLeagueId(String leagueId) {
        // Roster doesn't have leagueId - return all rosters (stub behavior)
        return new ArrayList<>(storage.values());
    }

    @Override
    public Roster save(Roster roster) {
        if (roster.getId() == null) {
            roster.setId(UUID.randomUUID());
        }
        storage.put(roster.getId(), roster);
        return roster;
    }
}
