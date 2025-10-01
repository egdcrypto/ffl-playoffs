package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.PageRequest;
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

    /**
     * Find all games with pagination
     * @param pageRequest pagination parameters
     * @return paginated list of games
     */
    Page<Game> findAll(PageRequest pageRequest);

    /**
     * Find all games (unpaginated)
     * @return list of all games
     */
    List<Game> findAll();

    /**
     * Find games by creator with pagination
     * @param creatorId the creator's user ID
     * @param pageRequest pagination parameters
     * @return paginated list of games
     */
    Page<Game> findByCreatorId(UUID creatorId, PageRequest pageRequest);

    /**
     * Find games by status with pagination
     * @param status the game status
     * @param pageRequest pagination parameters
     * @return paginated list of games
     */
    Page<Game> findByStatus(String status, PageRequest pageRequest);

    void delete(UUID id);

    boolean existsByCode(String code);
}
