package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.domain.model.Game;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

/**
 * Port interface for Game persistence
 * Domain defines the contract, infrastructure implements it
 * No framework dependencies in this interface
 */
public interface GameRepository {

    Game save(Game game);

    Optional<Game> findById(UUID id);

    Optional<Game> findByCode(String code);

    List<Game> findByCreatorId(UUID creatorId);

    List<Game> findAll();

    void delete(UUID id);

    boolean existsByCode(String code);
}
