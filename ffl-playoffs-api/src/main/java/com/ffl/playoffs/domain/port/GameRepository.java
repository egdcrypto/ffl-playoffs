package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.Game;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Port interface for Game persistence.
 * No framework dependencies - pure domain interface.
 */
public interface GameRepository {
    
    Game save(Game game);
    
    Optional<Game> findById(UUID id);
    
    Optional<Game> findByInviteCode(String inviteCode);
    
    List<Game> findAll();
    
    void delete(UUID id);
    
    boolean existsByInviteCode(String inviteCode);
}
