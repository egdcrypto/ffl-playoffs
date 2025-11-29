package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.aggregate.Game;

import java.util.List;
import java.util.Optional;

public interface GameRepository {
    Game save(Game game);
    Optional<Game> findById(Long id);
    Optional<Game> findByInviteCode(String inviteCode);
    List<Game> findAll();
    List<Game> findByPlayerId(Long playerId);
    void delete(Long id);
    boolean existsByInviteCode(String inviteCode);
}
