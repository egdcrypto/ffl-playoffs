package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.Game;
import com.ffl.playoffs.domain.port.GameRepository;
import org.springframework.stereotype.Repository;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;

/**
 * In-memory implementation of GameRepository for initial development.
 * Will be replaced with JPA implementation later.
 */
@Repository
public class GameRepositoryImpl implements GameRepository {
    
    private final ConcurrentHashMap<UUID, Game> games = new ConcurrentHashMap<>();

    @Override
    public Game save(Game game) {
        games.put(game.getId(), game);
        return game;
    }

    @Override
    public Optional<Game> findById(UUID id) {
        return Optional.ofNullable(games.get(id));
    }

    @Override
    public Optional<Game> findByInviteCode(String inviteCode) {
        // Not implemented in this simple version
        return Optional.empty();
    }

    @Override
    public List<Game> findAll() {
        return new ArrayList<>(games.values());
    }

    @Override
    public void delete(UUID id) {
        games.remove(id);
    }

    @Override
    public boolean existsByInviteCode(String inviteCode) {
        // Not implemented in this simple version
        return false;
    }
}
