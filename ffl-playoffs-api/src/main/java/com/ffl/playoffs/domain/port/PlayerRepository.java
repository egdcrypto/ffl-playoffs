package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.Player;

import java.util.List;
import java.util.Optional;

public interface PlayerRepository {
    Player save(Player player);
    Optional<Player> findById(Long id);
    Optional<Player> findByEmail(String email);
    Optional<Player> findByGoogleId(String googleId);
    List<Player> findAll();
    List<Player> findByGameId(Long gameId);
    void delete(Long id);
}
