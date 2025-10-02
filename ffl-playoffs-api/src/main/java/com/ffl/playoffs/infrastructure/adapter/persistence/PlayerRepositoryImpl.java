package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.port.PlayerRepository;
import org.springframework.stereotype.Repository;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

/**
 * In-memory implementation of PlayerRepository.
 * Replace with JPA implementation when persistence is needed.
 */
@Repository
public class PlayerRepositoryImpl implements PlayerRepository {

    private final Map<UUID, Player> storage = new ConcurrentHashMap<>();

    @Override
    public Player save(Player player) {
        storage.put(player.getId(), player);
        return player;
    }

    @Override
    public Optional<Player> findById(UUID id) {
        return Optional.ofNullable(storage.get(id));
    }

    @Override
    public List<Player> findByGameId(UUID gameId) {
        return storage.values().stream()
                .filter(player -> player.getGameId().equals(gameId))
                .toList();
    }

    @Override
    public List<Player> findActivePlayersByGameId(UUID gameId) {
        return storage.values().stream()
                .filter(player -> player.getGameId().equals(gameId))
                .filter(player -> !player.isEliminated())
                .toList();
    }

    @Override
    public void delete(UUID id) {
        storage.remove(id);
    }

    @Override
    public boolean existsByEmail(String email) {
        return storage.values().stream()
                .anyMatch(player -> player.getEmail().equals(email));
    }
}
