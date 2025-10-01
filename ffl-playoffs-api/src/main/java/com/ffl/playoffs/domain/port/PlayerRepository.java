package com.ffl.playoffs.domain.port;

import com.ffl.playoffs.application.dto.Page;
import com.ffl.playoffs.application.dto.PageRequest;
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

    /**
     * Find all players in a game with pagination
     * @param gameId the game ID
     * @param pageRequest pagination parameters
     * @return paginated list of players
     */
    Page<Player> findByGameId(UUID gameId, PageRequest pageRequest);

    /**
     * Find all players in a game (unpaginated)
     * @param gameId the game ID
     * @return list of all players
     */
    List<Player> findByGameId(UUID gameId);

    Optional<Player> findByGameIdAndEmail(UUID gameId, String email);

    /**
     * Find active players in a game with pagination
     * @param gameId the game ID
     * @param pageRequest pagination parameters
     * @return paginated list of active players
     */
    Page<Player> findActivePlayersByGameId(UUID gameId, PageRequest pageRequest);

    /**
     * Find active players in a game (unpaginated)
     * @param gameId the game ID
     * @return list of active players
     */
    List<Player> findActivePlayersByGameId(UUID gameId);

    /**
     * Find eliminated players in a game with pagination
     * @param gameId the game ID
     * @param pageRequest pagination parameters
     * @return paginated list of eliminated players
     */
    Page<Player> findEliminatedPlayersByGameId(UUID gameId, PageRequest pageRequest);

    /**
     * Find eliminated players in a game (unpaginated)
     * @param gameId the game ID
     * @return list of eliminated players
     */
    List<Player> findEliminatedPlayersByGameId(UUID gameId);

    void delete(UUID id);

    boolean existsByGameIdAndEmail(UUID gameId, String email);
}
