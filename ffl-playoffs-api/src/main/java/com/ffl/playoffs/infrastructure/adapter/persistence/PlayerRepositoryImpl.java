package com.ffl.playoffs.infrastructure.adapter.persistence;

import com.ffl.playoffs.domain.model.Player;
import com.ffl.playoffs.domain.port.PlayerRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.stream.Collectors;

/**
 * In-memory implementation of PlayerRepository for initial development.
 * Will be replaced with JPA implementation later.
 */
@Repository
public class PlayerRepositoryImpl implements PlayerRepository {
    
    private final ConcurrentHashMap<UUID, Player> players = new ConcurrentHashMap<>();

    @Override
    public Player save(Player player) {
        players.put(player.getId(), player);
        return player;
    }

    @Override
    public Optional<Player> findById(UUID id) {
        return Optional.ofNullable(players.get(id));
    }

    @Override
    public List<Player> findByGameId(UUID gameId) {
        return players.values().stream()
                .filter(p -> p.getGameId().equals(gameId))
                .collect(Collectors.toList());
    }

    @Override
    public Optional<Player> findByEmailAndGameId(String email, UUID gameId) {
        return players.values().stream()
                .filter(p -> p.getEmail().equals(email) && p.getGameId().equals(gameId))
                .findFirst();
    }

    @Override
    public void delete(UUID id) {
        players.remove(id);
    }

    @Override
    public boolean existsByEmailAndGameId(String email, UUID gameId) {
        return players.values().stream()
                .anyMatch(p -> p.getEmail().equals(email) && p.getGameId().equals(gameId));
    }
}
