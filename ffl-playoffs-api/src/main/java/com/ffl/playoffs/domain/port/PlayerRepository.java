package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.Player;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Port (interface) for Player persistence.
 * This defines the contract that infrastructure adapters must implement.
 */
public interface PlayerRepository {
    Player save(Player player);
    Optional<Player> findById(UUID id);
    List<Player> findByGameId(UUID gameId);
    List<Player> findActivePlayersByGameId(UUID gameId);
    void delete(UUID id);
    boolean existsByEmail(String email);
}
