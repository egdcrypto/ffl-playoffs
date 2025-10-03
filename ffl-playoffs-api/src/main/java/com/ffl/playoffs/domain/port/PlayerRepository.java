package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.Player;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Port interface for Player persistence.
 */
public interface PlayerRepository {
    
    Player save(Player player);
    
    Optional<Player> findById(UUID id);
    
    List<Player> findByGameId(UUID gameId);
    
    Optional<Player> findByEmailAndGameId(String email, UUID gameId);
    
    void delete(UUID id);
    
    boolean existsByEmailAndGameId(String email, UUID gameId);
}
