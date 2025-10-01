package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.Player;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Port interface for Player persistence
 * Domain defines the contract, infrastructure implements it
 * No framework dependencies in this interface
 */
public interface PlayerRepository {

    Player save(Player player);

    Optional<Player> findById(UUID id);

    List<Player> findByGameId(UUID gameId);

    Optional<Player> findByGameIdAndEmail(UUID gameId, String email);

    List<Player> findActivePlayersByGameId(UUID gameId);

    List<Player> findEliminatedPlayersByGameId(UUID gameId);

    void delete(UUID id);

    boolean existsByGameIdAndEmail(UUID gameId, String email);
}
