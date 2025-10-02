package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.port.GameRepository;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * In-memory implementation of GameRepository.
 * Replace with JPA implementation when persistence is needed.
 */
@Repository
public class GameRepositoryImpl implements GameRepository {

    private final Map<UUID, Game> storage = new ConcurrentHashMap<>();

    @Override
    public Game save(Game game) {
        storage.put(game.getId(), game);
        return game;
    }

    @Override
    public Optional<Game> findById(UUID id) {
        return Optional.ofNullable(storage.get(id));
    }

    @Override
    public List<Game> findByCreatorId(UUID creatorId) {
        return storage.values().stream()
                .filter(game -> game.getCreatorId().equals(creatorId))
                .toList();
    }

    @Override
    public List<Game> findAll() {
        return new ArrayList<>(storage.values());
    }

    @Override
    public void delete(UUID id) {
        storage.remove(id);
    }

    @Override
    public boolean existsById(UUID id) {
        return storage.containsKey(id);
    }
}
