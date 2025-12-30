package com.ffl.playoffs.infrastructure.adapter.persistence.stub;

import com.ffl.playoffs.domain.aggregate.PlayoffMatchup;
import com.ffl.playoffs.domain.model.MatchupStatus;
import com.ffl.playoffs.domain.model.PlayoffRound;
import com.ffl.playoffs.domain.port.PlayoffMatchupRepository;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * Stub implementation of PlayoffMatchupRepository for testing and development
 */
@Repository
public class PlayoffMatchupRepositoryStub implements PlayoffMatchupRepository {

    private final Map<UUID, PlayoffMatchup> storage = new ConcurrentHashMap<>();

    @Override
    public Optional<PlayoffMatchup> findById(UUID id) {
        return Optional.ofNullable(storage.get(id));
    }

    @Override
    public List<PlayoffMatchup> findByBracketId(UUID bracketId) {
        return storage.values().stream()
                .filter(m -> bracketId.equals(m.getBracketId()))
                .collect(Collectors.toList());
    }

    @Override
    public List<PlayoffMatchup> findByBracketIdAndRound(UUID bracketId, PlayoffRound round) {
        return storage.values().stream()
                .filter(m -> bracketId.equals(m.getBracketId()) && round.equals(m.getRound()))
                .collect(Collectors.toList());
    }

    @Override
    public List<PlayoffMatchup> findByBracketIdAndStatus(UUID bracketId, MatchupStatus status) {
        return storage.values().stream()
                .filter(m -> bracketId.equals(m.getBracketId()) && status.equals(m.getStatus()))
                .collect(Collectors.toList());
    }

    @Override
    public Optional<PlayoffMatchup> findByBracketIdAndPlayerIdAndRound(UUID bracketId, UUID playerId, PlayoffRound round) {
        return storage.values().stream()
                .filter(m -> bracketId.equals(m.getBracketId()) && round.equals(m.getRound()))
                .filter(m -> playerId.equals(m.getPlayer1Id()) || playerId.equals(m.getPlayer2Id()))
                .findFirst();
    }

    @Override
    public List<PlayoffMatchup> findUpsets(UUID bracketId) {
        return storage.values().stream()
                .filter(m -> bracketId.equals(m.getBracketId()) && m.isUpset())
                .collect(Collectors.toList());
    }

    @Override
    public PlayoffMatchup save(PlayoffMatchup matchup) {
        if (matchup.getId() == null) {
            matchup.setId(UUID.randomUUID());
        }
        storage.put(matchup.getId(), matchup);
        return matchup;
    }

    @Override
    public List<PlayoffMatchup> saveAll(List<PlayoffMatchup> matchups) {
        matchups.forEach(this::save);
        return matchups;
    }

    @Override
    public void deleteById(UUID id) {
        storage.remove(id);
    }
}
