package com.ffl.playoffs.infrastructure.adapter.persistence.stub;

import com.ffl.playoffs.domain.aggregate.NFLPlayer;
import com.ffl.playoffs.domain.model.Position;
import com.ffl.playoffs.domain.port.NFLPlayerRepository;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * Stub implementation of NFLPlayerRepository for testing and development
 */
@Repository
public class NFLPlayerRepositoryStub implements NFLPlayerRepository {

    private final Map<Long, NFLPlayer> storage = new ConcurrentHashMap<>();

    @Override
    public Optional<NFLPlayer> findById(Long id) {
        return Optional.ofNullable(storage.get(id));
    }

    @Override
    public List<NFLPlayer> findAll() {
        return new ArrayList<>(storage.values());
    }

    @Override
    public List<NFLPlayer> findByPosition(Position position) {
        return storage.values().stream()
                .filter(p -> position.equals(p.getPosition()))
                .collect(Collectors.toList());
    }

    @Override
    public List<NFLPlayer> findByTeam(String teamCode) {
        return storage.values().stream()
                .filter(p -> teamCode.equals(p.getNflTeamAbbreviation()) || teamCode.equals(p.getNflTeam()))
                .collect(Collectors.toList());
    }

    @Override
    public List<NFLPlayer> findActivePlayer() {
        return storage.values().stream()
                .filter(NFLPlayer::isActive)
                .collect(Collectors.toList());
    }

    @Override
    public NFLPlayer save(NFLPlayer player) {
        storage.put(player.getId(), player);
        return player;
    }

    @Override
    public List<NFLPlayer> saveAll(List<NFLPlayer> players) {
        players.forEach(p -> storage.put(p.getId(), p));
        return players;
    }

    @Override
    public boolean existsById(Long id) {
        return storage.containsKey(id);
    }
}
